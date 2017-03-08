//
//  AppDelegate.m
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "AppDelegate.h"

#import "StatTagFramework.h"
#import "MainTabViewController.h"

#import "StatTagShared.h"

#import "ManageCodeFilesViewController.h"
#import "SettingsViewController.h"
#import "UpdateOutputViewController.h"
#import "StatTagNeedsWordViewController.h"

#import "AppEventListener.h"

#import "ViewUtils.h"

#import "MacroInstallerUtility.h"


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
  //[[StatTagShared sharedInstance] logAppStartup];
  
  if([[StatTagShared sharedInstance] isFirstLaunch])
  {
    [MacroInstallerUtility installMacros];
  }

  //example of logging with a string
  LOG_STATTAG_MESSAGE(@"StatTag Finished Launching");

//  //example of logging an error with an exception
//  NSException* exc = [[NSException alloc] initWithName:@"Test Exception" reason:@"Something bad happened" userInfo:@{@"My Key" : @"My Key Value"}];
//  LOG_STATTAG_EXCEPTION(exc);
//
//  //example of logging an error with a string
//  NSString* s = @"Test String Exception";
//  LOG_STATTAG_EXCEPTION(s);
//
//  //example of logging an error with an error
//  NSError* err = [[NSError alloc] initWithDomain:@"StatTag Error" code:1 userInfo:@{NSLocalizedDescriptionKey : @"This is a test error"}];
//  LOG_STATTAG_EXCEPTION(err);
  
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

//in our case - yes - let's quit if the last window is closed
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
  //FIXME: this is just a quick fix. Circle back and fix this to quit the app when the main window closes
  return YES;
}

//FIXME: not yet implemented
-(IBAction)openPreferences:(id)sender {
  //https://developer.apple.com/library/content/qa/qa1552/_index.html
  if (![[StatTagShared sharedInstance] settingsViewController])
  {
   // SettingsViewController* _settingsVC = [[SettingsViewController alloc] init];
  } else {
    //[[StatTagShared sharedInstance] settingsViewController] showW
    //[[[StatTagShared sharedInstance] settingsViewController] showWindow:self];
  }
  NSLog(@"open preferences");
}

- (IBAction)installWordMacros:(id)sender {
  [MacroInstallerUtility installMacros];
}

- (IBAction)removeWordMacros:(id)sender {
  [MacroInstallerUtility removeMacros];
}


@end
