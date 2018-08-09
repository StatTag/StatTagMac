//
//  UpdateOutputProgressViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "UpdateOutputProgressViewController.h"
#import "StatTagFramework.h"
#import "STTag+StatisticalPackage.h"

@interface UpdateOutputProgressViewController ()

@end

@implementation UpdateOutputProgressViewController

@synthesize progressIndicator;
@synthesize progressText;

@synthesize documentManager = _documentManager;
@synthesize tagsToProcess = _tagsToProcess;
@synthesize failedTags = _failedTags;
@synthesize failedTagErrors = _failedTagErrors;

@synthesize insert = _insert;


-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"UpdateOutputProgressViewController" owner:self topLevelObjects:nil];
    _insert = NO;
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
    // Do view setup here.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(tagUpdateStart:)
                                               name:@"tagUpdateStart"
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(tagUpdateComplete:)
                                               name:@"tagUpdateComplete"
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(allTagUpdatesComplete:)
                                               name:@"allTagUpdatesComplete"
                                             object:nil];
  
  
}

-(void)viewDidAppear {

  [self setNumTagsCompleted:@0];
  [self setNumTagsToProcess:@0];
  _failedTags = [[NSMutableArray<STTag*> alloc] init];
  _failedTagErrors = [[NSMutableDictionary<STTag*, NSException*> alloc] init];

  [self refreshTagsAsync];
  
  //StatTagResponseState responseState = [self refreshTagsAsync];
  //[_delegate dismissUpdateOutputProgressController:self withReturnCode:responseState andFailedTags:[self failedTags] withErrors:[self failedTagErrors]];

//  [self refreshTags];
}

- (void)refreshTagsAsync {
  
  //this isn't quite right - but it works for now
  [self setNumTagsCompleted:@0];
  [self setNumTagsToProcess:[NSNumber numberWithLong:[[self tagsToProcess] count]]];
  [[self progressIndicatorDeterminate] setMinValue:0];
  [[self progressIndicatorDeterminate] setMaxValue:[[self tagsToProcess] count]];

  [progressIndicator setIndeterminate:YES];
  [progressIndicator startAnimation:nil];
  if([self insert])
  {
    [progressText setStringValue:[NSString stringWithFormat:@"Inserting tags..."]];
  } else {
    [progressText setStringValue:[NSString stringWithFormat:@"Updating tags..."]];
  }
  ////NSLog(@"%lu tags", (unsigned long)[_tagsToProcess count]);
  
  __block StatTagResponseState responseState;
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    @try {

      if([self insert])
      {
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:@"Starting to insert tags..."];
        });
        STStatsManagerExecuteResult* result = [_documentManager InsertTagPlaceholdersInDocument:[self tagsToProcess]];
        dispatch_async(dispatch_get_main_queue(), ^{
          
          [progressIndicator setIndeterminate:YES];
          [progressIndicator stopAnimation:nil];
          [progressText setStringValue:@"Insert complete"];
          
          responseState = [result Success] == true ? OK : Error;
          [[NSNotificationCenter defaultCenter] postNotificationName:@"allTagUpdatesComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseState], @"failedTags":[result FailedTags]}];
          //[_delegate dismissUpdateOutputProgressController:self withReturnCode:responseState andFailedTags:[self failedTags] withErrors:[self failedTagErrors]];
          //return;
        });

      }
      else
      {
  
        STStatsManager* stats = [[STStatsManager alloc] initWithDocumentManager:_documentManager andSettingsManager:nil];
        #pragma unused (stats)
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:@"Starting to update tags..."];
          [self setProgressCountText:[NSString stringWithFormat:@"%@/%ld", [self numTagsCompleted], [[self tagsToProcess] count]]];
          [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numTagsCompleted], [self numTagsToProcess]]];
        });

        STStatsManagerExecuteResult* allResults = [[STStatsManagerExecuteResult alloc] init];
        [allResults setSuccess:true];
        //dispatch_async(dispatch_get_main_queue(), ^{
          for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
            STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                                 filterMode:[STConstantsParserFilterMode TagList]
                                                                  tagsToRun:_tagsToProcess
                                                   ];
            [[allResults FailedTags] addObjectsFromArray:[result FailedTags]];
            [[allResults UpdatedTags] addObjectsFromArray:[result UpdatedTags]];
            [allResults setSuccess:([result Success] == true && [allResults Success] == true)];
            #pragma unused (result)
          }
        //});
        
        dispatch_async(dispatch_get_main_queue(), ^{

          [progressText setStringValue:@"Updating Fields in Microsoft Word..."];
          
          //can we move this to a background thread?
          for(STTag* tag in _tagsToProcess)
          {
            STUpdatePair<STTag*>* pair = [[STUpdatePair alloc] init];
            pair.Old = tag;
            pair.New = tag;
            [_documentManager UpdateFields:pair];
          }
          //EWW 2017-03-07
          //changed entire update process here
          //        [_documentManager UpdateFields];
          
          [progressIndicator setIndeterminate:YES];
          [progressIndicator stopAnimation:nil];
          
          [progressText setStringValue:@"Updates complete"];
          //responseState = OK;
          //[[NSNotificationCenter defaultCenter] postNotificationName:@"allTagUpdatesComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseState]}];
          //[_delegate dismissUpdateOutputProgressController:self withReturnCode:responseState  andFailedTags:[self failedTags] withErrors:[self failedTagErrors]];
          responseState = [allResults Success] == true ? OK : Error;
          [[NSNotificationCenter defaultCenter] postNotificationName:@"allTagUpdatesComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseState], @"failedTags":[allResults FailedTags]}];

        });
      
      }
      //      dispatch_async(dispatch_get_main_queue(), ^{
      //        //        [NSApp endSheet:[self window]];
      //        //        [[self window] orderOut:self];
      //      });
        
    }
    @catch (NSException* exc) {
      //dispatch_async(dispatch_get_main_queue(), ^{
        //responseState = Error;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allTagUpdatesComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:Error]}];
        //[_delegate dismissUpdateOutputProgressController:self withReturnCode:responseState andFailedTags:[self failedTags] withErrors:[self failedTagErrors]];
        
      //});

    }


    
  });

  
  //[[NSNotificationCenter defaultCenter] postNotificationName:@"allTagUpdatesComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseState]}];
  
//  dispatch_sync(serialQ, ^{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"allTagUpdatesComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseState]}];
//    //[_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)responseState andFailedTags:[self failedTags] withErrors:[self failedTagErrors]];
//  });

//  return responseState;

}



- (IBAction)cancelOperation:(id)sender {
}


-(void)tagUpdateStart:(NSNotification*)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString* tagName = [[notification userInfo] valueForKey:@"tagName"];
    NSString* codeFileName = [[notification userInfo] valueForKey:@"codeFileName"];
    NSString* type = [[notification userInfo] valueForKey:@"type"];
    //NSLog(@"tagUpdateStart complete => tag: %@", tagName);

    if([type isEqualToString:@"tag"])
    {
      [[self progressText] setStringValue:[NSString stringWithFormat:@"%@ %@ '%@' from code file'%@'", [self insert] ? @"Inserting" : @"Updating", type, tagName, codeFileName]];
    }
    if([type isEqualToString:@"field"])
    {
      [[self progressText] setStringValue:[NSString stringWithFormat:@"%@ %@ for tag '%@'", [self insert] ? @"Inserting" : @"Updating", type, tagName]];
    }
    ////NSLog(@"tag update start (%@/%@): %@", [self numTagsCompleted], [self numTagsToProcess], tagName);
    [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numTagsCompleted], [self numTagsToProcess]]];
  });
}

-(void)tagUpdateComplete:(NSNotification*)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{

    //NSString* tagName = [[notification userInfo] valueForKey:@"tagName"];
    NSString* tagID = [[notification userInfo] valueForKey:@"tagID"];
    //NSLog(@"tagUpdateComplete complete => tag: %@", tagName);
    bool no_result = [(NSNumber*)[[notification userInfo] valueForKey:@"no_result"] boolValue];
    NSException* ex = (NSException*)[[notification userInfo] valueForKey:@"exception"];
    //@"no_result" : [NSNumber numberWithBool:no_result]}
    if(no_result)
    {
      //NSLog(@"tagUpdateComplete - Failed to process tag : '%@' Id:(%@)", tagName, tagID);
      //find our tag from the ID
      for(STTag* t in [self tagsToProcess])
      {
        if([[t Id] isEqualToString:tagID])
        {
          [[self failedTags] addObject:t];
          if(ex != nil)
          {
            [[self failedTagErrors] setObject:ex forKey:t];
          }
        }
      }
    }
    
    [self setNumTagsCompleted:[NSNumber numberWithDouble:([[self numTagsCompleted] doubleValue] + 1.0)]];
    if([[self numTagsToProcess] doubleValue] > 0) {
      [[self progressIndicatorDeterminate] setDoubleValue:[[self numTagsCompleted] doubleValue]];
    }
    else {
      [[self progressIndicatorDeterminate] setDoubleValue:1.0];
    }
    [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numTagsCompleted], [self numTagsToProcess]]];
  });
}

-(void)allTagUpdatesComplete:(NSNotification*)notification
{
  NSNumber* responseStateNum = [[notification userInfo] valueForKey:@"responseState"];
  StatTagResponseState responseState = (StatTagResponseState)[responseStateNum integerValue];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)responseState andFailedTags:[self failedTags] withErrors:[self failedTagErrors]];
  });
}



//old version - leaving here for reference
//- (void)refreshTags {
//
//  //non-async version because we're using the indeterminate indicator
//  // not working quite right because we sort of stall and the window doesn't fire correctly
//  // circle back here
//
//  [progressIndicator startAnimation:nil];
//  [[self progressIndicatorDeterminate] startAnimation:nil];
//
//  @try {
//    [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", @"something"]];
//
//    STStatsManager* stats = [[STStatsManager alloc] init:_documentManager];
//    for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
//      [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", [[cf FilePathURL] lastPathComponent] ]];
//
//      STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
//                                                           filterMode:[STConstantsParserFilterMode TagList]
//                                                            tagsToRun:_tagsToProcess
//                                             ];
//      #pragma unused (result)
//
//      [progressText setStringValue:[NSString stringWithFormat:@"Updating field codes in %@", [[_documentManager activeDocument] name]]];
//    }
//
//    //note we're not using the observer here - so this is not particularly informative to the user
//    [_documentManager UpdateFields];
//    //[WordHelpers updateAllFields];
//
//    [progressIndicator setIndeterminate:YES];
//    [progressIndicator stopAnimation:nil];
//    [[self progressIndicatorDeterminate] stopAnimation:nil];
//
//    //[[[[self view] window] sheetParent] endSheet:[[self view] window] returnCode:NSModalResponseOK];
//
//    [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)OK];
//
//    //[self dismissViewController:<#(nonnull NSViewController *)#>
//
//  }
//  @catch (NSException* exc) {
//    [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)Error];
//
//    //[[[[self view] window] sheetParent] endSheet:[[self view] window] returnCode:NSModalResponseStop];
//  }
//}



@end
