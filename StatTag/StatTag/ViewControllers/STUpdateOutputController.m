//
//  STUpdateOutputController.m
//  StatTag
//
//  Created by Eric Whitley on 8/4/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STUpdateOutputController.h"
#import "StatTag.h"
#import "STTagUpdateProgressController.h"

@interface STUpdateOutputController ()

@end

@implementation STUpdateOutputController
@synthesize labelOnDemandSearchText;
@synthesize buttonOnDemandSelectAll;
@synthesize buttonOnDemandSelectNone;
@synthesize tableViewOnDemand;
@synthesize buttonRefresh;
@synthesize buttonCancel;
@synthesize onDemandTags;
@synthesize documentTags = _documentTags;

STDocumentManager* manager;
STMSWord2011Application* app;
STMSWord2011Document* doc;

STTagUpdateProgressController* tagUpdateProgressController;


breakLoop = YES;
#define maxloop 1000

static NSString* const KVO_CONTEXT_FIELD_STATUS_CHANGED = @"KVO_CONTEXT_FIELD_STATUS_CHANGED";

- (void)startObservingManager:(STDocumentManager*)manager {
  [manager addObserver:self forKeyPath:@"wordFieldsTotal" options:NSKeyValueObservingOptionOld context:&KVO_CONTEXT_FIELD_STATUS_CHANGED];
  [manager addObserver:self forKeyPath:@"wordFieldsUpdated" options:NSKeyValueObservingOptionOld context:&KVO_CONTEXT_FIELD_STATUS_CHANGED];
  [manager addObserver:self forKeyPath:@"wordFieldUpdateStatus" options:NSKeyValueObservingOptionOld context:&KVO_CONTEXT_FIELD_STATUS_CHANGED];
}

- (void)stopObservingManager:(STDocumentManager*)manager {
  [manager removeObserver:self forKeyPath:@"wordFieldsTotal" context:&KVO_CONTEXT_FIELD_STATUS_CHANGED];
  [manager removeObserver:self forKeyPath:@"wordFieldsUpdated" context:&KVO_CONTEXT_FIELD_STATUS_CHANGED];
  [manager removeObserver:self forKeyPath:@"wordFieldUpdateStatus" context:&KVO_CONTEXT_FIELD_STATUS_CHANGED];
}

- (void)windowWillClose:(NSNotification *)notification {
  [[NSApplication sharedApplication] stopModal];
}


- (void)awakeFromNib {

}

- (void)windowDidLoad {
  [super windowDidLoad];
  
  
  app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  doc = [app activeDocument];
  
  //  [[[STGlobals sharedInstance] ThisAddIn] Application_DocumentOpen:doc];
  //  manager = [[[STGlobals sharedInstance] ThisAddIn] DocumentManager];
  
  manager = [[STDocumentManager alloc] init];
  //this isn't what we should be doing, but we don't have the same approach as Windows
  
  [manager LoadCodeFileListFromDocument:doc];
  //DocumentManager.LoadCodeFileListFromDocument(doc);
  
  //NSLog(@"GetCodeFileList : %@", [manager GetCodeFileList]);
  for(STCodeFile* file in [manager GetCodeFileList]) {
    [file LoadTagsFromContent];
  }
  
  
  [self willChangeValueForKey:@"documentTags"];
  _documentTags = [[NSMutableArray<STTag*> alloc] initWithArray:[manager GetTags]];
  [self didChangeValueForKey:@"documentTags"];
//  [onDemandTags fetch:nil];
  

  
  //[manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
 
  
  

  
}


-(void)getTags {
  
  [manager GetTags];
  
}


- (IBAction)selectOnDemandNone:(id)sender {
  [onDemandTags setSelectionIndexes:[NSIndexSet indexSet]];
}

- (IBAction)selectOnDemandAll:(id)sender {
  //OK, I expect this to break... our range end should be count - 1, not count, but... the selection is one item short if we do that
  [onDemandTags setSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[onDemandTags arrangedObjects] count])]];
}


- (IBAction)refreshTags:(id)sender {
  
//  STStatsManager* stats = [[STStatsManager alloc] init:manager];
//  for(STCodeFile* cf in [manager GetCodeFileList]) {
//    NSLog(@"found codefile %@", [cf FilePath]);
//    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
//  }

//  STStatsManager* stats = [[STStatsManager alloc] init:manager];
//  for(STCodeFile* cf in [manager GetCodeFileList]) {
//    NSLog(@"found codefile %@", [cf FilePath]);
//    
//    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
//                                                 filterMode:[STConstantsParserFilterMode TagList]
//                                                tagsToRun:[onDemandTags selectedObjects]
//                                           ];
//    NSLog(@"result : %hhd", result.Success);
//  }

  
//  [self startRefreshingFields];
  [self startRefreshingFieldsWithModalController];
  //NSLog(@"success? %hhd", success);

//  if(success) {
//    [[self window] close];
//  } else {
//    
//  }
//  [manager UpdateFields];
  
}
- (void)startRefreshingFieldsWithModalController {
  
  //tagUpdateProgressController
  
  if (tagUpdateProgressController == nil)
  {
    tagUpdateProgressController = [[STTagUpdateProgressController alloc] init];
    tagUpdateProgressController.tagsToProcess = [onDemandTags selectedObjects];
    tagUpdateProgressController.manager = manager;
  }
  
  [[self window] beginSheet:[tagUpdateProgressController window] completionHandler:^(NSModalResponse returnCode){
    //NSLog(@"returnCode : %@", returnCode);
    tagUpdateProgressController = nil;
    if(returnCode == NSModalResponseOK) {
      [[self window] close];
    } else {
      NSAlert *alert = [[NSAlert alloc] init];
      [alert setMessageText:@"StatTag encountered a problem"];
      [alert setInformativeText:@"StatTag could not update your selected tags"];
      [alert setAlertStyle:NSCriticalAlertStyle];
      [alert addButtonWithTitle:@"Ok"];
      [alert runModal];
    }
    
  }];
  
}


//http://stackoverflow.com/questions/8054202/how-to-correctly-display-a-progress-sheet-modally-while-using-grand-central-di
- (void)startRefreshingFields {
  
  breakLoop = NO;

  NSLog(@"refreshing %d tags and %d fields", [[self documentTags] count], [[manager wordFieldsTotal] integerValue]);
  
  
  NSRect sheetRect = NSMakeRect(0, 0, 400, 114);
  
  NSWindow *progSheet = [[NSWindow alloc] initWithContentRect:sheetRect
                                                    styleMask:NSTitledWindowMask
                                                      backing:NSBackingStoreBuffered
                                                        defer:YES];
  
  NSView *contentView = [[NSView alloc] initWithFrame:sheetRect];
  
  
  NSProgressIndicator *progInd = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(20, 41, 32, 32)];
  //we want the progress indicator positioned centered vertically with 20 pixel left leading
  progInd.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:progInd];
  [progInd addConstraint:[NSLayoutConstraint constraintWithItem:progInd attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:32]];
  [progInd addConstraint:[NSLayoutConstraint constraintWithItem:progInd attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:32]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:progInd attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:progInd attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];

  
  NSTextField *inputField = [[NSTextField alloc] initWithFrame:NSMakeRect(72, 46, 235, 22)];
  //NSTextField *inputField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 235, 22)];
  [inputField setBezeled:NO];
  [inputField setDrawsBackground:NO];
  [inputField setEditable:NO];
  [inputField setSelectable:NO];
  [contentView addSubview:inputField];
  //we want the text field 12 pixels to the right of the progress spinner*, centered vertically, and 20 pixels from the right edge of the containing view
  //* -> can't quite figure out how to do this, so fudging with fixed size of 64 (20+32+12)
  //also - text will not _really_ be centered vertically - the text's view will.
  inputField.translatesAutoresizingMaskIntoConstraints = NO;
  [inputField addConstraint:[NSLayoutConstraint constraintWithItem:inputField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:22]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:inputField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:64]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:inputField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:inputField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

  
  NSButton *cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(304, 12, 82, 32)];
  cancelButton.bezelStyle = NSRoundedBezelStyle;
  cancelButton.title = @"Cancel";
  cancelButton.action = @selector(cancelRefreshingFields:);
  cancelButton.target = self;
  [contentView addSubview:cancelButton];
  
  [progSheet setContentView:contentView];
  progInd.style = NSProgressIndicatorSpinningStyle;
  [progInd setHidden:NO];
  [progInd setIndeterminate:YES];
  [progInd setUsesThreadedAnimation:YES];
  [progInd startAnimation:nil];

  
  [[ self window] beginSheet:progSheet
       completionHandler:^(NSModalResponse returnCode){
         
   }];

  [progSheet makeKeyAndOrderFront:self];

//  [NSApp beginSheet:progSheet
//     modalForWindow:self.window
//      modalDelegate:nil
//     didEndSelector:NULL
//        contextInfo:NULL];
//  
//  [progSheet makeKeyAndOrderFront:self];
  
  //[progInd setIndeterminate:YES];
  //[progInd setDoubleValue:0.f];
  //[progInd startAnimation:self];
  
  
  // Start computation using GCD...
  
  NSLog(@"Updating %d tags", [[onDemandTags selectedObjects] count]);
  
  //BOOL success = false;
  @try {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      dispatch_async(dispatch_get_main_queue(), ^{
        [inputField setStringValue:[NSString stringWithFormat:@"Updating tags in %@", @"something"]];
      });

      STStatsManager* stats = [[STStatsManager alloc] init:manager];
      for(STCodeFile* cf in [manager GetCodeFileList]) {
        //NSLog(@"found codefile %@", [cf FilePath]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [inputField setStringValue:[NSString stringWithFormat:@"Updating tags in %@", [[cf FilePathURL] lastPathComponent] ]];
        });
        
        STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                             filterMode:[STConstantsParserFilterMode TagList]
                                                              tagsToRun:[onDemandTags selectedObjects]
                                               ];

        dispatch_async(dispatch_get_main_queue(), ^{
          [inputField setStringValue:[NSString stringWithFormat:@"Updating field codes in %@", [doc name]]];
        });

        dispatch_async(dispatch_get_main_queue(), ^{
          [manager UpdateFields];
        });

  //      dispatch_async(dispatch_get_main_queue(), ^{
  //        [progInd setDoubleValue: (double)progressCurrent/progressTarget * 100];
  //      });

        //NSLog(@"result : %hhd", result.Success);
      }

      
      
  //    for (int i = 0; i < maxloop; i++) {
  //      
  //      [NSThread sleepForTimeInterval:0.01];
  //      
  //      if (breakLoop)
  //      {
  //        break;
  //      }
  //    
  //      // Update the progress bar which is in the sheet:
  //      //dispatch_async(dispatch_get_main_queue(), ^{
  //      //  //[progInd setDoubleValue: (double)i/maxloop * 100];
  //      //});
  //    }
      
      
      // Calculation finished, remove sheet on main thread
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [progInd setIndeterminate:YES];
        [progInd stopAnimation:nil];
        
        [NSApp endSheet:progSheet];
        [progSheet orderOut:self];
      });
    });
  
    //success = true;
  }
  @catch (NSException* exc) {
    
  }

  //return success;
}

- (IBAction)cancelRefreshingFields:(id)sender
{
  NSLog(@"Cancelling");
  breakLoop = YES;
}

- (BOOL) getNewValues {
  return true;
}

- (BOOL) updateTagsInDocument {
  return true;
}

- (IBAction)cancel:(id)sender {
  [[self window] close];
}

@end
