//
//  UpdateOutputProgressViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "UpdateOutputProgressViewController.h"
#import "StatTagFramework.h"

@interface UpdateOutputProgressViewController ()

@end

@implementation UpdateOutputProgressViewController

@synthesize progressIndicator;
@synthesize progressText;

@synthesize documentManager = _documentManager;
@synthesize tagsToProcess = _tagsToProcess;

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
}

-(void)viewDidAppear {

  [self setNumTagsCompleted:@0];
  [self setNumTagsToProcess:@0];

  [self refreshTagsAsync];
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
  //NSLog(@"%lu tags", (unsigned long)[_tagsToProcess count]);
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    @try {

      if([self insert])
      {
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:@"Starting to insert tags..."];
        });
        [_documentManager InsertTagsInDocument:[self tagsToProcess]];
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressIndicator setIndeterminate:YES];
          [progressIndicator stopAnimation:nil];
          [progressText setStringValue:@"Insert complete"];
          [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)OK];
          return;
        });
      }
      else
      {
  
        STStatsManager* stats = [[STStatsManager alloc] init:_documentManager];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:@"Starting to update tags..."];
          [self setProgressCountText:[NSString stringWithFormat:@"%@/%ld", [self numTagsCompleted], [[self tagsToProcess] count]]];
          [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numTagsCompleted], [self numTagsToProcess]]];
        });

        for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
          //NSLog(@"found codefile %@", [cf FilePath]);
          
          
          STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                               filterMode:[STConstantsParserFilterMode TagList]
                                                                tagsToRun:_tagsToProcess
                                                 ];
          #pragma unused (result)
          
        }
        
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
          
          [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)OK];
        });
      
      }
      //      dispatch_async(dispatch_get_main_queue(), ^{
      //        //        [NSApp endSheet:[self window]];
      //        //        [[self window] orderOut:self];
      //      });
        
    }
    @catch (NSException* exc) {
      [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)Error];
    }
  });
  
}

- (IBAction)cancelOperation:(id)sender {
}


-(void)tagUpdateStart:(NSNotification*)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString* tagName = [[notification userInfo] valueForKey:@"tagName"];
    NSString* codeFileName = [[notification userInfo] valueForKey:@"codeFileName"];
    NSString* type = [[notification userInfo] valueForKey:@"type"];
    NSLog(@"tagUpdateStart complete => tag: %@", tagName);

    if([type isEqualToString:@"tag"])
    {
      [[self progressText] setStringValue:[NSString stringWithFormat:@"%@ %@ '%@' from code file'%@'", [self insert] ? @"Inserting" : @"Updating", type, tagName, codeFileName]];
    }
    if([type isEqualToString:@"field"])
    {
      [[self progressText] setStringValue:[NSString stringWithFormat:@"%@ %@ for tag '%@'", [self insert] ? @"Inserting" : @"Updating", type, tagName]];
    }
    //NSLog(@"tag update start (%@/%@): %@", [self numTagsCompleted], [self numTagsToProcess], tagName);
    [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numTagsCompleted], [self numTagsToProcess]]];
  });
}

-(void)tagUpdateComplete:(NSNotification*)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{

    NSString* tagName = [[notification userInfo] valueForKey:@"tagName"];
    NSLog(@"tagUpdateComplete complete => tag: %@", tagName);
    
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




//old version - leaving here for reference
//- (void)refreshTags {
//
//  //non-async version because we're using the indeterminate indicator
//  // not working quite right becuse we sort of stall and the window doesn't fire correctly
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
