//
//  STWindowLauncher.m
//  StatTag
//
//  Created by Eric Whitley on 8/4/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STWindowLauncher.h"

#import "STSettingsController.h"
#import "STUpdateOutputController.h"
#import "STManageCodeFilesController.h"

#import "StatTag.h"


@implementation STWindowLauncher

STSettingsController* settingsController;
STUpdateOutputController* updateOutputController;
STManageCodeFilesController* manageCodeFilesController;

+(NSString*)testGettingFields {
  
  NSLog(@"testGettingFields - starting ");

  STLogManager* logger = [[STLogManager alloc] init];
  [logger WriteMessage:@"testGettingFields - starting "];
  
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];

  [logger WriteMessage:@"testGettingFields - before doc "];
  [logger WriteMessage:[NSString stringWithFormat:@"doc name : %@ ", [doc name]]];

  NSLog(@"testGettingFields - doc name is %@", [doc name]);
  
  for(int i = 0; i < [[doc fields] count]; i++){

    STMSWord2011Field* field = [[doc fields] objectAtIndex:i];
    NSLog(@"");
    NSLog(@"FIELD -> found field (%d) : %@ and json : %@", [field entry_index], [[field fieldCode] content], [field fieldText]);
    
    STMSWord2011TextRange* code = [field fieldCode];
    if(code != nil) {
      STMSWord2011Field* nestedField = [[code fields] firstObject];//[code fields][1];
      NSLog(@"   NESTED FIELD -> found field (%d) : %@ and json : %@", [nestedField entry_index], [[nestedField fieldCode] content], [nestedField fieldText]);
    }

  }
  

//  for(STMSWord2011Field* field in [doc fields]) {
//    NSLog(@"");
//    NSLog(@"FIELD -> found field (%d) : %@ and json : %@", [field entry_index], [[field fieldCode] content], [field fieldText]);
//
//    STMSWord2011TextRange* code = [field fieldCode];
//    STMSWord2011Field* nestedField = [[code fields] firstObject];//[code fields][1];
//    NSLog(@"   NESTED FIELD -> found field (%d) : %@ and json : %@", [nestedField entry_index], [[nestedField fieldCode] content], [nestedField fieldText]);
//  }
  
  return @"got fields";
}

+(NSString*)openSettings {
  NSLog(@"STWindowLauncher - openSettings - started");
  
  
  [NSApplication sharedApplication];
  [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

  
  if(settingsController == nil)
    settingsController = [[STSettingsController alloc] initWithWindowNibName:@"STSettingsController"];
  
  STLogManager* logManager = [[STLogManager alloc] init];
  STPropertiesManager* propertiesManager = [[STPropertiesManager alloc] init];
  //STProperties* properties = [[STProperties alloc] init];
  
  settingsController.Properties = [propertiesManager Properties];
  settingsController.LogManager = logManager;
  settingsController.PropertiesManager = propertiesManager;
  [propertiesManager Load];
  
  NSWindow* settingsWindow = [settingsController window];
  //settingsWindow.delegate = self;
  
  NSLog(@"before messing with window");
  
  [settingsWindow setTitle:@"Settings"];
//  [settingsWindow setLevel:NSFloatingWindowLevel];
//  [settingsWindow setOrderedIndex:0];
  [settingsWindow makeKeyAndOrderFront: self ];
  [NSApp activateIgnoringOtherApps:YES];
  
  NSLog(@"before canBecomeKeyWindow");
  NSLog(@"[settingsWindow canBecomeKeyWindow] = %hhd", [settingsWindow canBecomeKeyWindow]);
  
//  [settingsWindow orderFrontRegardless];
//  [settingsWindow orderFront:nil];

  //[settingsWindow orderWindow:NSWindowAbove relativeTo:[[NSApp mainWindow] windowNumber]];
  //[settingsWindow makeMainWindow];

  
  [NSApp runModalForWindow: settingsWindow];
  [NSApp endSheet: settingsWindow];
  [settingsWindow close];
  NSLog(@"STWindowLauncher - openSettings - completed");



  
  
  
  
  return @"openSettings";
}

+(void)showWindowController:(NSWindowController*)wc withTitle:(NSString*)windowTitle {
  
  
//  [wc showWindow:nil];
//  NSWindow* theWindow = [wc window];
//  [theWindow setTitle:windowTitle];
//  [wc showWindow:theWindow]; //never shows in Word
//  [NSApp activateIgnoringOtherApps:YES];
//  [theWindow setLevel:NSFloatingWindowLevel];
//  [theWindow makeKeyAndOrderFront: self ];
  
  
  NSWindow* theWindow = [wc window];
  [theWindow setTitle:windowTitle];
  //  [updateOutputController showWindow:self]; //never shows in Word
  [NSApp activateIgnoringOtherApps:YES];
  [theWindow setLevel:NSFloatingWindowLevel];
  [theWindow makeKeyAndOrderFront: self ];
  [theWindow orderWindow:NSWindowAbove relativeTo:[[NSApp mainWindow] windowNumber]];
  [theWindow makeMainWindow];

  [NSApp runModalForWindow: theWindow];
  [NSApp endSheet: theWindow];
  [theWindow close];
  NSLog(@"STWindowLauncher - openUpdateOutput - completed");

}

+(NSString*)openUpdateOutput {
  NSLog(@"STWindowLauncher - openUpdateOutput - started");

  if(updateOutputController == nil)
    updateOutputController = [[STUpdateOutputController alloc] initWithWindowNibName:@"STUpdateOutputController"];
  
  [self showWindowController:updateOutputController withTitle:@"Update Tags"];
  NSLog(@"done with opening window - openUpdateOutput");
  
//  
//  NSWindow* settingsWindow = [updateOutputController window];
//  //settingsWindow.delegate = self;
//  
//  NSLog(@"before messing with window");
//  
//  [settingsWindow setTitle:@"Settings"];
//  //  [settingsWindow setLevel:NSFloatingWindowLevel];
//  [settingsWindow setLevel:NSModalPanelWindowLevel];
//  //  [settingsWindow setOrderedIndex:0];
//  [settingsWindow makeKeyAndOrderFront: self ];
//  [NSApp activateIgnoringOtherApps:YES];
//  
//  NSLog(@"before canBecomeKeyWindow");
//  NSLog(@"[settingsWindow canBecomeKeyWindow] = %hhd", [settingsWindow canBecomeKeyWindow]);
//  
//  //  [settingsWindow orderFrontRegardless];
//  //  [settingsWindow orderFront:nil];
//  
//  //[settingsWindow orderWindow:NSWindowAbove relativeTo:[[NSApp mainWindow] windowNumber]];
//  //[settingsWindow makeMainWindow];
//  
//  
//  [NSApp runModalForWindow: settingsWindow];
//  [NSApp endSheet: settingsWindow];
//  [settingsWindow close];

  
//  NSWindow* settingsWindow = [updateOutputController window];
//  [settingsWindow setTitle:@"Update Tags"];
////  [updateOutputController showWindow:self]; //never shows in Word
//  [NSApp activateIgnoringOtherApps:YES];
//  [settingsWindow setLevel:NSMainMenuWindowLevel];
//  [settingsWindow makeKeyAndOrderFront: self];
//  
//  [NSApp runModalForWindow: settingsWindow];
//  [NSApp endSheet: settingsWindow];
//  [settingsWindow close];
//  NSLog(@"STWindowLauncher - openUpdateOutput - completed");

  return @"openUpdateOutput";
  
}


+(NSString*)openManageCodeFiles {
  //STManageCodeFilesController
  if(manageCodeFilesController == nil)
    manageCodeFilesController = [[STManageCodeFilesController alloc] initWithWindowNibName:@"STManageCodeFilesController"];

  STMSWord2011Application* app= [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];
  STDocumentManager* dm = [[STDocumentManager alloc] init];
  [dm LoadCodeFileListFromDocument:doc];

  NSLog(@"openManageCodeFiles - doc name is %@", [doc name]);

  
//  [dm AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];

//  for(STCodeFile* file in [dm GetCodeFileList]) {
//    NSLog(@"package : %@, path : %@", [file StatisticalPackage], [file FilePath]);
//  }
  
  manageCodeFilesController.manager = dm;
  manageCodeFilesController.codeFiles = [dm GetCodeFileList];
  
  
  [self showWindowController:manageCodeFilesController withTitle:@"Manage Code Files"];
  NSLog(@"done with opening window - openManageCodeFiles");

  return @"openManageCodeFiles";
}

@end
