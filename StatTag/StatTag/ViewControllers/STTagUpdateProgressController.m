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
  
  [self refreshTags];
}

- (void)refreshTags {
  
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
          
          [NSException raise:@"Invalid foo value" format:@"foo of X is invalid"];

          
          dispatch_async(dispatch_get_main_queue(), ^{
            [progressText setStringValue:[NSString stringWithFormat:@"Updating field codes in %@", [[_manager activeDocument] name]]];
          });
          
          dispatch_async(dispatch_get_main_queue(), ^{
            [_manager UpdateFields];
          });
          
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [progressIndicator setIndeterminate:YES];
          [progressIndicator stopAnimation:nil];
          
          
           [[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseOK];
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
