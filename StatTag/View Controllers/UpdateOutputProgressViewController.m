//
//  UpdateOutputProgressViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "UpdateOutputProgressViewController.h"
#import "StatTag.h"

@interface UpdateOutputProgressViewController ()

@end

@implementation UpdateOutputProgressViewController

@synthesize progressIndicator;
@synthesize progressText;

@synthesize documentManager = _documentManager;
@synthesize tagsToProcess = _tagsToProcess;


-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"UpdateOutputProgressViewController" owner:self topLevelObjects:nil];
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
    // Do view setup here.
}

-(void)viewDidAppear {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(tagUpdateStart:)
                                               name:@"tagUpdateStart"
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(tagUpdateComplete:)
                                               name:@"tagUpdateComplete"
                                             object:nil];

  [self setNumTagsCompleted:@0];
  [self setNumTagsToProcess:@0];

  [self refreshTagsAsync];
//  [self refreshTags];
}

- (void)refreshTagsAsync {
  
  //this isn't quite right - but it works for now
  
  [progressIndicator setIndeterminate:YES];
  [progressIndicator startAnimation:nil];
  [progressText setStringValue:[NSString stringWithFormat:@"Updating tags..."]];
  //NSLog(@"%lu tags", (unsigned long)[_tagsToProcess count]);
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    @try {
      
      STStatsManager* stats = [[STStatsManager alloc] init:_documentManager];
      for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
        //NSLog(@"found codefile %@", [cf FilePath]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:@"Starting to update tags..."];
          [self setNumTagsCompleted:@0];
          [self setProgressCountText:[NSString stringWithFormat:@"%@/%ld", [self numTagsCompleted], [[self tagsToProcess] count]]];
          [self setNumTagsToProcess:[NSNumber numberWithLong:[[self tagsToProcess] count]]];
          [[self progressIndicatorDeterminate] setMinValue:0];
          [[self progressIndicatorDeterminate] setMaxValue:[[self tagsToProcess] count]];
          [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numTagsCompleted], [self numTagsToProcess]]];
        });
        
        STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                             filterMode:[STConstantsParserFilterMode TagList]
                                                              tagsToRun:_tagsToProcess
                                               ];

        #pragma unused (result)
        
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [progressText setStringValue:@"Updating Fields in Microsoft Word..."];

        [_documentManager UpdateFields];
        
        [progressIndicator setIndeterminate:YES];
        [progressIndicator stopAnimation:nil];

        [progressText setStringValue:@"Updates complete"];

        [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)OK];
      });
      
      
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
    [[self progressText] setStringValue:[NSString stringWithFormat:@"Updating tag '%@' in code file'%@'", tagName, codeFileName]];
    //NSLog(@"tag update start (%@/%@): %@", [self numTagsCompleted], [self numTagsToProcess], tagName);
    [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numTagsCompleted], [self numTagsToProcess]]];
  });
}

-(void)tagUpdateComplete:(NSNotification*)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{
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
