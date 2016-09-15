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


- (void)windowWillClose:(NSNotification *)notification {
  //[[self window] close];
  [[NSApplication sharedApplication] stopModal];
}


- (void)awakeFromNib {

}

-(void)windowDidBecomeKey:(NSNotification *)notification {
  NSLog(@"window became key");
}

-(void)windowDidResignKey:(NSNotification *)note {
  NSLog(@"windowDidResignKey");
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
  
  
  
  
  NSLog(@"canBecomeKeyWindow : %hhd", [[self window] canBecomeKeyWindow]);
  
//  [[NSApp mainWindow] makeKeyAndOrderFront:self];
  //[[self window] makeKeyAndOrderFront: self];

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
