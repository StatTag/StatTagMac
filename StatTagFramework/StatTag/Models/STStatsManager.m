//
//  STStatsManager.m
//  StatTag
//
//  Created by Eric Whitley on 7/8/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STStatsManager.h"
#import "StatTagFramework.h"
#import "STDocumentManager.h"
#import "STIStatAutomation.h"
#import "STICodeFileParser.h"

BOOL Globals_Application_ScreenUpdating = true;

@implementation STStatsManagerExecuteResult
@synthesize Success = _Success;
@synthesize UpdatedTags = UpdatedTags;
@end


@implementation STStatsManager


const NSInteger RefreshStepInterval = 5;
@synthesize Manager = _Manager;


-(instancetype)init:(STDocumentManager*)manager {
  self = [super init];
  if(self) {
   self.Manager = manager;
  }
  return self;
}



/**
 Factory method to return the appropriate statistical automation engine
 
 @param file The code file we will be executing
 @returns A stat package automation instance
*/
+(id<STIStatAutomation>)GetStatAutomation:(STCodeFile*) file
{
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages Stata]])
    {
      return [[STStataAutomation alloc] init];
    } else if ([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages SAS]]) {
      return [[STSASAutomation alloc] init];
    } else if ([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages R]]) {
      return [[STRAutomation alloc] init];
    }
  }
  
  return nil;
}

+(id<STICodeFileParser>)GetCodeFileParser:(STCodeFile*) file
{
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages Stata]])
    {
      return [[STStataParser alloc] init];
    }
  }
  
  return nil;
}


/**
 Run the statistical package for a given code file.

  @param file: The code file to execute
  @param filterMode: The type of filter to apply on the types of commands to execute
  @param tagsToRun: An optional list of tags to execute code for.  This is only applied when the filter mode is ParserFilterMode.TagList
*/
-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file filterMode:(NSInteger)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun {
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"ExecuteStatPackage preparing to execute %ld tags", (unsigned long)[tagsToRun count]);
  });
  
  STStatsManagerExecuteResult* result = [[STStatsManagerExecuteResult alloc] init];
  result.Success = false;
  result.UpdatedTags = [[NSMutableArray<STTag*> alloc] init];
  
  //STStataAutomation* automation = [[STStataAutomation alloc] init];
  NSObject<STIStatAutomation>* automation = [[self class] GetStatAutomation:file];
  
  if(! [automation Initialize]){
    //FIXME: we should probably do something w/ NSError here?
    /*
     MessageBox.Show(automation.GetInitializationErrorMessage(), UIUtility.GetAddInName());
     */
    //   UIUtility.GetAddInName());
    return result;
  }
  
  NSObject<STICodeFileParser>* parser = [STFactories GetParser:file];
  if (parser == nil) {
    return result;
  }

  NSString* previousTagName;
  NSString* currentTagName;
  
  @try {
    // Get all of the commands in the code file that should be executed given the current filter
    NSArray<STExecutionStep*>* steps = [parser GetExecutionSteps:file filterMode:filterMode tagsToRun:tagsToRun];
    
    //C# apparently had this initially as an enumeration, then moved to index-based counting
    // not sure why, but following C#
    for (NSInteger index = 0; index < [steps count]; index++) {
      
      STExecutionStep* step = steps[index];
      
      // Every few steps, we will allow the screen to update, otherwise the UI looks like it's
      // completely hung up.  Note that we will only do this if screen updating is disabled when
      // we invoke this method.  Otherwise we run the risk of not re-enabling screen updates.
      if (!Globals_Application_ScreenUpdating && (index%RefreshStepInterval == 0))
      {
        //FIXME: this whole section is a placeholder
        // Need to understand what this is really doing vs. our progress indicator which we would handle via a KVO
        Globals_Application_ScreenUpdating = true;
        //Globals.ThisAddIn.Application.ScreenRefresh();
        //refresh UI
        Globals_Application_ScreenUpdating = false;
      }

      //send a notification that we're starting a tag
      if([step Tag] != nil)
      {
        if(![[[step Tag] Name] isEqualToString:previousTagName])
        {
          //we changed tags, so update the name and fire off a notification
          currentTagName = [NSString stringWithString:[[step Tag] Name]];
          dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tagUpdateStart" object:self userInfo:@{@"tagName":currentTagName, @"codeFileName":[[[step Tag] CodeFile] FileName], @"type" : @"tag"}];
          });
        }
      }
      
      // If there is no tag, we will join all of the command code together.  This allows us to have
      // multi-line statements, such as a for loop.  Because we don't check for return results, we just
      // process the command and continue.
      if ([step Tag] == nil)
      {
        NSString* combinedCommand = [[step Code] componentsJoinedByString:@"\r\n"];
        [automation RunCommands:[NSArray<NSString*> arrayWithObject:combinedCommand]];
        continue;
      }
      
      NSArray<STCommandResult*>* results = [automation RunCommands:[step Code] tag:[step Tag]];
      STTag* tag = [[self Manager] FindTag:[[step Tag] Id]];

      
      NSLog(@"results count : %lu", (unsigned long)[results count]);
      for(STCommandResult* r in results) {
        NSLog(@"results result : %@", [r ToString]);
      }


      if(tag != nil) {
        NSArray<STCommandResult*>* resultList = [NSArray<STCommandResult*> arrayWithArray:results];
        // Determine if we had a cached list, and if so if the results have changed.
        
        //FIXME: review this line - may or may not work as expected
        BOOL resultsChanged = ([tag CachedResult] != nil && ![resultList isEqualToArray:[tag CachedResult]]);
        // original c#
        //bool resultsChanged = (tag.CachedResult != null && !resultList.SequenceEqual(tag.CachedResult));
        
        NSLog(@"OLD count : %lu", (unsigned long)[[tag CachedResult] count]);
        for(STCommandResult* r in [tag CachedResult]) {
          NSLog(@"OLD result : %@", [r ToString]);
        }
        NSLog(@"new count : %lu", (unsigned long)[resultList count]);
        for(STCommandResult* r in resultList) {
          NSLog(@"new result : %@", [r ToString]);
        }
        
        
        tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithArray:results];
        
        // If the results did change, we need to sweep the document and update all of the results
        if(resultsChanged) {
          NSLog(@"results changed");
          // For all table tags, update the formatted cells collection
          if([tag IsTableTag]) {
            NSLog(@"is a table tag");
            //original c#
                //tag.CachedResult.FindAll(x => x.TableResult != null).ForEach(
                  //x =>
                  //x.TableResult.FormattedCells =
                  //tag.TableFormat.Format(x.TableResult,
                //Factories.GetValueFormatter(tag.CodeFile))
                //);
            //FIXME: test this... it's very likely we're not actually modifying the object as we think we are here... these are probably copies and not strongly referenced instances
            for(STCommandResult* a_result in [tag CachedResult]) {
              if([a_result TableResult] != nil ) {
//                a_result.TableResult.FormattedCells = [NSMutableArray<NSString*> arrayWithArray:[[tag TableFormat]Format:[a_result TableResult] valueFormatter:[STFactories GetValueFormatter:[tag CodeFile]]]];
                
                a_result.TableResult.FormattedCells = [[tag TableFormat] Format:[a_result TableResult] valueFormatter: [STFactories GetValueFormatter:[tag CodeFile]]];
              }
            }
          }
          
          NSLog(@"ExecuteStatPackage (%d) - result? %@", __LINE__, result);
          NSLog(@"ExecuteStatPackage (%d) - [result UpdatedTags] %@", __LINE__, [result UpdatedTags]);
          NSLog(@"ExecuteStatPackage (%d) - tag? %@", __LINE__, tag);
          [[result UpdatedTags] addObject:tag];

        }
      }
      //send a notification that we're completing a tag
      if([step Tag] != nil)
      {
        if(![currentTagName isEqualToString:previousTagName])
        {
          dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tagUpdateComplete" object:self userInfo:@{@"tagName":currentTagName, @"codeFileName":[[[step Tag] CodeFile] FileName], @"type" : @"tag"}];
          });
          previousTagName = [NSString stringWithString:currentTagName];
          //currentTagName = [[step Tag] Name];
        }
      }

    }

    result.Success = true;
  }
  @catch (NSException* exception) {
    //FIXME: return an NSError?
    NSLog(@"%@", exception.reason);
    NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    NSLog(@"%@", [NSThread callStackSymbols]);

    NSLog(@"Exception Initialize %@: %@", NSStringFromClass([self class]), [exception description]);
    /*
     MessageBox.Show(exc.Message, UIUtility.GetAddInName(), MessageBoxButtons.OK, MessageBoxIcon.Error);
     */
    
    return result;
  }
  @finally {
  }
  
  
  return result;
  
  
}
-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file {
  return [self ExecuteStatPackage:file filterMode:[STConstantsParserFilterMode ExcludeOnDemand] tagsToRun:nil];
}
-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file filterMode:(NSInteger)filterMode {
  return [self ExecuteStatPackage:file filterMode:filterMode tagsToRun:nil];
}


@end
