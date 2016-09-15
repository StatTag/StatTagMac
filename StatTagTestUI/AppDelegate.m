//
//  AppDelegate.m
//  StatTagTestUI
//
//  Created by Eric Whitley on 8/3/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "AppDelegate.h"
#import "STWindowLauncher.h"
#import "STUpdateOutputController.h"

#import "StatTag.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
@synthesize logTextView;



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


- (IBAction)openSettings:(id)sender {
  [STWindowLauncher openSettings];
}


- (IBAction)openUpdateTags:(id)sender {
  [STWindowLauncher openUpdateOutput];
  
  //[self logCurrentWordTags];

}



- (IBAction)insertTestTags:(id)sender {
  
  STDocumentManager* manager;
  STMSWord2011Application* app;
  STMSWord2011Document* doc;

  
  app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  doc = [app activeDocument];
  manager = [[STDocumentManager alloc] init];
  
  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];
  
  [manager GetTags];
  
  for(STTag* tag in [manager GetTags]) {
    NSLog(@"original codeFile tag -> name: %@, type: %@", [tag Name], [tag Type]);
    NSLog(@"original codeFile tag -> formatted result: %@", [tag FormattedResult]);
    [manager InsertField:tag];
  }
  
  for(STMSWord2011Field* field in [doc fields]) {
    //[field toggleShowCodes];
    field.showCodes = ![field showCodes];
    field.showCodes = ![field showCodes];
  }
  
  [self logCurrentWordTags];
  
}

- (IBAction)manageCodeFiles:(id)sender {
  [STWindowLauncher openManageCodeFiles];
}


- (IBAction)viewTagData:(id)sender {
  [self logCurrentWordTags];
}


- (void)logCurrentWordTags {
  
  STMSWord2011Application* app;
  STMSWord2011Document* doc;
  
  
  app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  doc = [app activeDocument];

  
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];
  
  [manager GetTags];
  
//  STStatsManager* stats = [[STStatsManager alloc] init:manager];
//  for(STCodeFile* cf in [manager GetCodeFileList]) {
//    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
//  }
  
  
  //  [manager UpdateFields];
  
  
  SBElementArray<STMSWord2011Field*>* fields = [doc fields];
  int fieldsCount = [fields count];
  // Fields is a 1-based index
  
  NSMutableString* tagData = [[NSMutableString alloc] init];

  [tagData appendString:[NSString stringWithFormat:@"\r\nPreparing to process %d fields", fieldsCount]];

  
  int index = 0;
  for(STMSWord2011Field* field in [doc fields]) {
    [tagData appendString:[NSString stringWithFormat:@"\r\n"]];
    [tagData appendString:[NSString stringWithFormat:@"\r\nfield (%d)", index]];
    [tagData appendString:[NSString stringWithFormat:@"\r\n=================="]];
    [tagData appendString:[NSString stringWithFormat:@"\r\nFieldCode -> start : %ld, end : %ld, length : %ld", [[field fieldCode] startOfContent], [[field fieldCode] endOfContent], [[[field fieldCode] content] length]   ]];
    
//    STMSWord2011SelectionObject* selection = [[[[STGlobals sharedInstance] ThisAddIn] Application] selection];
//    selection.selectionStart = [[field fieldCode] startOfContent];
//    selection.selectionEnd = [[field fieldCode] startOfContent] + 1;
//    NSString* startText = [[selection textObject] content];
//
//    selection.selectionStart = [[field fieldCode] endOfContent];
//    selection.selectionEnd = [[field fieldCode] endOfContent] + 1;
//    NSString* endText = [[selection textObject] content];
    
//    [tagData appendString:[NSString stringWithFormat:@"\r\nFieldCode character -> start : %@, end : %@", startText, endText]];

    [tagData appendString:[NSString stringWithFormat:@"\r\nfieldCode.content : %@", [[field fieldCode] content]]];
    [tagData appendString:[NSString stringWithFormat:@"\r\nfieldText : %@", [field fieldText]]];
    
    if ([[manager TagManager] IsStatTagField:field]) {
      STFieldTag* fieldTag = [[manager TagManager] GetFieldTag:field];
      [tagData appendString:[NSString stringWithFormat:@"\r\nfieldTag FormattedResult : %@", [fieldTag FormattedResult]]];
    } else {
      [tagData appendString:[NSString stringWithFormat:@"\r\nNot a StatTag field"]];
    }
    //NSLog(@"serialized : %@", [STFieldTag Serialize:tag]);
    
    index++;
  }
  
  [[self logTextView] setString:tagData];
  

}


@end
