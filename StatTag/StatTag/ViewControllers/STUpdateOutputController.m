//
//  STUpdateOutputController.m
//  StatTag
//
//  Created by Eric Whitley on 8/4/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STUpdateOutputController.h"
#import "StatTag.h"


@interface STUpdateOutputController ()

@end

@implementation STUpdateOutputController
@synthesize labelOnDemandSearchText;
@synthesize buttonOnDemandSelectAll;
@synthesize buttonOnDemandSelectNone;
@synthesize tableViewOnDemand;
@synthesize buttonRefresh;
@synthesize buttonCancel;

STDocumentManager* manager;
STMSWord2011Application* app;
STMSWord2011Document* doc;


- (void)windowWillClose:(NSNotification *)notification {
  [[NSApplication sharedApplication] stopModal];
}

- (void)windowDidBecomeKey:(NSNotification*)notification
{
  NSLog(@"windowDidBecomeKey");
}


- (void)windowDidLoad {
  [super windowDidLoad];
  
  
  app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  doc = [app activeDocument];
  manager = [[STDocumentManager alloc] init];

  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
 
  
  NSLog(@"tried to bring front");

  
}

-(BOOL)canBecomeKeyWindow {
  NSLog(@"canBecomeKeyWindow");
  return YES;
}

-(void)getTags {
  
  [manager GetTags];
  
}


- (IBAction)selectOnDemandNone:(id)sender {
}

- (IBAction)selectOnDemandAll:(id)sender {
}


- (IBAction)refreshTags:(id)sender {
  
  STStatsManager* stats = [[STStatsManager alloc] init:manager];
  for(STCodeFile* cf in [manager GetCodeFileList]) {
    NSLog(@"found codefile %@", [cf FilePath]);
    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
  }

  [manager UpdateFields];
  
  [[self window] close];
}

- (IBAction)cancel:(id)sender {
  [[self window] close];
}

@end
