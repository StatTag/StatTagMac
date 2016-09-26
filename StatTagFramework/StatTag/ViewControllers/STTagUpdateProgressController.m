//
//  STTagUpdateProgressController.m
//  StatTag
//
//  Created by Eric Whitley on 8/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTagUpdateProgressController.h"
#import "StatTag.h"

@interface STTagUpdateProgressController ()

@end

@implementation STTagUpdateProgressController
@synthesize progressIndicator;
@synthesize progressText;

@synthesize manager = _manager;
@synthesize tagsToProcess = _tagsToProcess;


- (id)init
{
  self = [super initWithWindowNibName:@"STTagUpdateProgressController"];
  return self;
}

- (void)windowDidLoad {
  [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  
  [self refreshTagsAsync];
  //[self refreshTagsAsyncAS];
  //[self refreshTags];
}

- (void)refreshTags {
  
  //non-async version because we're using the indeterminate indicator
  // not working quite right becuse we sort of stall and the window doesn't fire correctly
  // circle back here
  
  [progressIndicator startAnimation:nil];

  @try {
    [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", @"something"]];
    
    STStatsManager* stats = [[STStatsManager alloc] init:_manager];
    for(STCodeFile* cf in [_manager GetCodeFileList]) {
      [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", [[cf FilePathURL] lastPathComponent] ]];
      
      STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                           filterMode:[STConstantsParserFilterMode TagList]
                                                            tagsToRun:_tagsToProcess
                                             ];
      [progressText setStringValue:[NSString stringWithFormat:@"Updating field codes in %@", [[_manager activeDocument] name]]];
    }

    //note we're not using the observer here - so this is not particularly informative to the user
    [_manager UpdateFields];
    //[WordHelpers updateAllFields];

    [progressIndicator setIndeterminate:YES];
    [progressIndicator stopAnimation:nil];

    [[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseOK];
  }
  @catch (NSException* exc) {
    [[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseStop];
  }
}

- (void)refreshTagsAsyncAS {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    @try {
      dispatch_async(dispatch_get_main_queue(), ^{
        [progressIndicator startAnimation:nil];
        [progressText setStringValue:[NSString stringWithFormat:@"Updating document..."]];
      });
      BOOL success = [WordHelpers updateAllFields];
      dispatch_async(dispatch_get_main_queue(), ^{
        [progressIndicator stopAnimation:nil];
        [[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseOK];
      });
    }
    @catch (NSException* ex){
      dispatch_async(dispatch_get_main_queue(), ^{
        [progressIndicator stopAnimation:nil];
        [[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseCancel];
      });
    }
  });
}

- (void)refreshTagsAsync {
  
  //this isn't right - but just in here to show some testing
  
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

      @try {

        
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", @"something"]];
        });
        
        STStatsManager* stats = [[STStatsManager alloc] init:_manager];
        for(STCodeFile* cf in [_manager GetCodeFileList]) {
          //NSLog(@"found codefile %@", [cf FilePath]);
          
          dispatch_async(dispatch_get_main_queue(), ^{
            [progressText setStringValue:[NSString stringWithFormat:@"Updating tags in %@", [[cf FilePathURL] lastPathComponent] ]];
          });
          
          STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                               filterMode:[STConstantsParserFilterMode TagList]
                                                                tagsToRun:_tagsToProcess
                                                 ];
          
          dispatch_async(dispatch_get_main_queue(), ^{
            [progressText setStringValue:[NSString stringWithFormat:@"Updating field codes in %@", [[_manager activeDocument] name]]];
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

          [_manager UpdateFields];

          [progressIndicator setIndeterminate:YES];
          [progressIndicator stopAnimation:nil];
          
          
          [[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseOK];

        });


        dispatch_async(dispatch_get_main_queue(), ^{
  //        [NSApp endSheet:[self window]];
  //        [[self window] orderOut:self];
        });

      }
       @catch (NSException* exc) {
         [[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseStop];
       }

    
    });
    
    //success = true;
}

- (IBAction)cancelOperation:(id)sender {
}

@end
