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

  _window = [[[NSApplication sharedApplication] windows] firstObject];
  [[StatTagShared sharedInstance] setWindow:_window];
  [[StatTagShared sharedInstance] initializeWordViews];

  [AppEventListener startListening];

  
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