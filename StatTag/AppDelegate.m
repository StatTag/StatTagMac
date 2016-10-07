//
//  AppDelegate.m
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "AppDelegate.h"

#import "StatTag.h"
#import "MainTabViewController.h"

#import "StatTagShared.h"

#import "ManageCodeFilesViewController.h"
#import "SettingsViewController.h"
#import "UpdateOutputViewController.h"
#import "StatTagNeedsWordViewController.h"

#import "AppEventListener.h"

#import "ViewUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//@synthesize manager = _manager;
//@synthesize doc = _doc;
//@synthesize app = _app;
//@synthesize mainVC = _mainVC;
//@synthesize mainWindow = _mainWindow;




//http://stackoverflow.com/questions/36681587/os-x-storyboard-calls-viewdidload-before-applicationdidfinishlaunching
//https://jamesdevnote.wordpress.com/2015/04/22/nswindow-nswindowcontroller-programmatically/
//http://stackoverflow.com/questions/8186375/storyboard-refer-to-viewcontroller-in-appdelegate
//http://stackoverflow.com/questions/15694510/programatically-create-initial-window-of-cocoa-app-os-x/21987979#21987979
//http://stackoverflow.com/questions/24193238/appdelegate-for-cocoa-app-using-storyboards-in-xcode-6/24543911#24543911
//http://stackoverflow.com/questions/30492512/reference-outlet-to-main-nswindow-in-appdelegate-osx




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

  //mainWindow was hit or miss, so we're not using it - really unclear to me why this is nil during setup
  //  self.mainVC = (MainTabViewController*)[[[[NSApplication sharedApplication] mainWindow] windowController] contentViewController];//[[NSApp mainWindow] windowController];

  StatTagShared* shared = [StatTagShared sharedInstance];
  
  //get our root view controller
  _window = [[[NSApplication sharedApplication] windows] firstObject];
  shared.mainVC = (MainTabViewController*)[[_window windowController] contentViewController];
  
  
  //set up some of our shared stattag stuff
  shared.app= [[[STGlobals sharedInstance] ThisAddIn] Application];
  shared.doc = [[shared app] activeDocument]; //this will be problematic ongoing when we open / close documents, etc.
  shared.docManager = [[STDocumentManager alloc] init];

  shared.logManager = [[STLogManager alloc] init];
  shared.propertiesManager = [[STPropertiesManager alloc] init];
  
  //get our code file list on startup
//  [[shared docManager] LoadCodeFileListFromDocument:[shared doc]];

  // Set up Code File Manager
  //-----------
  //send over our managers, etc.
  ManageCodeFilesViewController* codeFilesVC = (ManageCodeFilesViewController*)[[[[shared mainVC ] tabView] tabViewItemAtIndex:(StatTagTabIndexes)ManageCodeFiles] viewController];
  shared.codeFilesViewController = codeFilesVC;
  codeFilesVC.documentManager = [shared docManager];
//  codeFilesVC.codeFiles = [[shared docManager] GetCodeFileList]; //just for setup
  
  // Set up Preferences Manager
  //-----------
  SettingsViewController* settingsVC = (SettingsViewController*)[[[[shared mainVC ] tabView] tabViewItemAtIndex:(StatTagTabIndexes)Settings] viewController];
  settingsVC.propertiesManager = [shared propertiesManager];
  settingsVC.logManager = [shared logManager];
  [[settingsVC propertiesManager] Load];
  settingsVC.properties = [[shared propertiesManager] Properties]; //just for setup
  //  [propertiesManager Load];

  
  // Set up Code File Manager
  //-----------
  //send over our managers, etc.
  UpdateOutputViewController* updateOutputVC = (UpdateOutputViewController*)[[[[shared mainVC ] tabView] tabViewItemAtIndex:(StatTagTabIndexes)UpdateOutput] viewController];
  updateOutputVC.documentManager = [shared docManager];
  //updateOutputVC.codeFiles = [[shared docManager] GetCodeFileList]; //just for setup

  
  NSStoryboard* storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
  if(storyBoard != nil) {
    StatTagNeedsWordViewController* wc = [storyBoard instantiateControllerWithIdentifier:@"StatTagNeedsWordViewController"];
    shared.needsWordController = wc;

  
  [AppEventListener startListening];
  
  
  if([AppEventListener wordIsOK]) {
    [[shared docManager] LoadCodeFileListFromDocument:[shared doc]];
    codeFilesVC.codeFiles = [[shared docManager] GetCodeFileList]; //just for setup
    [[_window windowController] setContentViewController:shared.mainVC ];
  } else {
    [[_window windowController] setContentViewController:shared.needsWordController ];
  }

  
  //StatTagNeedsWordViewController* needsWordController
  
//  [[[_window windowController] contentViewController] view]
  
//  [[_window windowController] setContentViewController:xxxxx];
  /*
   let storyboard = NSStoryboard(name: "Main", bundle: nil)
   if let homeViewController = (storyboard.instantiateControllerWithIdentifier("HomeViewController") as? NSViewController){
   let windowController = NSWindowController(window: Constants.appDelegate!.window)
   windowController.contentViewController = homeViewController
   windowController.showWindow(Constants.appDelegate!.window)
   }
   */
  
  //http://stackoverflow.com/questions/5056374/nswindowcontroller-and-nsviewcontroller
  
    //[[_window windowController] showWindow:nil];
    //self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    //[self.window.contentView replaceSubview:self.window.contentView.view with:wc.view];
  }
  
  //appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
  
  
}


- (void)applicationDidBecomeActive:(NSNotification *)notification{
  //Posted immediately after the app becomes active.
}

- (void)applicationDidResignActive:(NSNotification *)notification {
  //Posted immediately after the app gives up its active status to another app.
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
  
  [AppEventListener stopListening];

}


@end
