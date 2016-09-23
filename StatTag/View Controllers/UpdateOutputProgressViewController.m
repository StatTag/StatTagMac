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
  [self refreshTagsAsync];
//  [self refreshTags];
}


- (void)refreshTags {
  
  //non-async version because we're using the indeterminate indicator
  // not working quite right becuse we sort of stall and the window doesn't fire correctly
  // circle back here
  
  [progressIndicator startAnimation:nil];
  
  @try {
    [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", @"something"]];
    
    STStatsManager* stats = [[STStatsManager alloc] init:_documentManager];
    for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
      [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", [[cf FilePathURL] lastPathComponent] ]];
      
      STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                           filterMode:[STConstantsParserFilterMode TagList]
                                                            tagsToRun:_tagsToProcess
                                             ];
      #pragma unused (result)

      [progressText setStringValue:[NSString stringWithFormat:@"Updating field codes in %@", [[_documentManager activeDocument] name]]];
    }
    
    //note we're not using the observer here - so this is not particularly informative to the user
    [_documentManager UpdateFields];
    //[WordHelpers updateAllFields];
    
    [progressIndicator setIndeterminate:YES];
    [progressIndicator stopAnimation:nil];
    
    //[[[[self view] window] sheetParent] endSheet:[[self view] window] returnCode:NSModalResponseOK];
    
    [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)OK];

    //[self dismissViewController:<#(nonnull NSViewController *)#>
    
  }
  @catch (NSException* exc) {
    [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)Error];

    //[[[[self view] window] sheetParent] endSheet:[[self view] window] returnCode:NSModalResponseStop];
  }
}

//- (void)refreshTagsAsyncAS {
//  dispatch_async(dispatch_get_global_queue(0, 0), ^{
//    @try {
//      dispatch_async(dispatch_get_main_queue(), ^{
//        [progressIndicator startAnimation:nil];
//        [progressText setStringValue:[NSString stringWithFormat:@"Updating document..."]];
//      });
//      BOOL success = [WordHelpers updateAllFields];
//      #pragma unused (success)
//      dispatch_async(dispatch_get_main_queue(), ^{
//        [progressIndicator stopAnimation:nil];
//        [[[[self view] window] sheetParent] endSheet:[[self view] window] returnCode:NSModalResponseOK];
//      });
//    }
//    @catch (NSException* ex){
//      dispatch_async(dispatch_get_main_queue(), ^{
//        [progressIndicator stopAnimation:nil];
//        [[[[self view] window] sheetParent] endSheet:[[self view] window] returnCode:NSModalResponseCancel];
//      });
//    }
//  });
//}

- (void)refreshTagsAsync {
  
  //this isn't quite right - but it works for now
  
  [progressIndicator setIndeterminate:YES];
  [progressIndicator startAnimation:nil];
  [progressText setStringValue:[NSString stringWithFormat:@"Updating tags..."]];
  NSLog(@"%lu tags", (unsigned long)[_tagsToProcess count]);
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    @try {
      
      
//      dispatch_async(dispatch_get_main_queue(), ^{
//        [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", @"something"]];
//      });
      
      STStatsManager* stats = [[STStatsManager alloc] init:_documentManager];
      for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
        //NSLog(@"found codefile %@", [cf FilePath]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", [[cf FilePathURL] lastPathComponent] ]];
        });
        
        STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                             filterMode:[STConstantsParserFilterMode TagList]
                                                              tagsToRun:_tagsToProcess
                                               ];
        #pragma unused (result)
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:[NSString stringWithFormat:@"Updating field codes in %@", [[_documentManager activeDocument] name]]];
        });
        
        
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        //           still doesn't work when launched from 32-bit
        //          NSTask* updateTask = [[NSTask alloc] init];
        //          updateTask.launchPath = @"/Library/Frameworks/StatTagWordFieldUpdater";
        //          [updateTask launch];
        //          [updateTask waitUntilExit];
        //          int status = [updateTask terminationStatus];
        //          NSLog(@"NSTask status : %d", status);
        
        /*
         tell application "StatTagTestUI"
         updateFields
         end tell
         */
        //          NSLog(@"going to AppleScript");
        //          BOOL success = [WordHelpers updateAllFields];
        //          NSLog(@"script success = %hhd", success);
        //          NSLog(@"returning from AppleScript");
        
        [_documentManager UpdateFields];
        
        [progressIndicator setIndeterminate:YES];
        [progressIndicator stopAnimation:nil];
        
        [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)OK];
        //[[[[self view] window] sheetParent] endSheet:[[self view] window] returnCode:NSModalResponseOK];
        
      });
      
      
      dispatch_async(dispatch_get_main_queue(), ^{
        //        [NSApp endSheet:[self window]];
        //        [[self window] orderOut:self];
      });
      
    }
    @catch (NSException* exc) {
      [_delegate dismissUpdateOutputProgressController:self withReturnCode:(StatTagResponseState)Error];
      //[[[[self view] window] sheetParent] endSheet:[[self view] window] returnCode:NSModalResponseStop];
    }
    
    
  });
  
  //success = true;
}

- (IBAction)cancelOperation:(id)sender {
}


@end
