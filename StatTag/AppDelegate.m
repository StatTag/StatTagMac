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

#import <QuartzCore/QuartzCore.h>
#import <CoreVideo/CoreVideo.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize preferencesWindowController = _preferencesWindowController;
@synthesize aboutWindowController = _aboutWindowController;

//@synthesize manager = _manager;
//@synthesize doc = _doc;
//@synthesize app = _app;
//@synthesize mainVC = _mainVC;
//@synthesize mainWindow = _mainWindow;

@synthesize dockTileView = _dockTileView;


//http://stackoverflow.com/questions/36681587/os-x-storyboard-calls-viewdidload-before-applicationdidfinishlaunching
//https://jamesdevnote.wordpress.com/2015/04/22/nswindow-nswindowcontroller-programmatically/
//http://stackoverflow.com/questions/8186375/storyboard-refer-to-viewcontroller-in-appdelegate
//http://stackoverflow.com/questions/15694510/programatically-create-initial-window-of-cocoa-app-os-x/21987979#21987979
//http://stackoverflow.com/questions/24193238/appdelegate-for-cocoa-app-using-storyboards-in-xcode-6/24543911#24543911
//http://stackoverflow.com/questions/30492512/reference-outlet-to-main-nswindow-in-appdelegate-osx

-(instancetype)init
{
  self = [super init];
  if(self)
  {
    [self runStatTagWithDocumentBrowser];
  }
  return self;
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

  #if !defined(MAC_OS_X_VERSION_10_12_2) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_12_2
    if ([[NSApplication sharedApplication] respondsToSelector:@selector(isAutomaticCustomizeTouchBarMenuItemEnabled)])
    {
      [NSApplication sharedApplication].automaticCustomizeTouchBarMenuItemEnabled = YES;
    }
  #endif

  if([[StatTagShared sharedInstance] isFirstLaunch])
  {
    [MacroInstallerUtility installMacros];
  }

//  [self runStatTagWithDocumentBrowser];

/*
  _window = [[[NSApplication sharedApplication] windows] firstObject];
  [[StatTagShared sharedInstance] setWindow:_window];
  [[StatTagShared sharedInstance] initializeWordViews];

  [AppEventListener startListening];
  //[[StatTagShared sharedInstance] logAppStartup];
  
  if([[StatTagShared sharedInstance] isFirstLaunch])
  {
    [MacroInstallerUtility installMacros];
  }
*/
  
  //NSDockTile* dockTile = [[NSApplication sharedApplication] dockTile];
  //[self animateDockTileStart];
//  //example of logging with a string
//  LOG_STATTAG_MESSAGE(@"StatTag Finished Launching");

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

-(void)runStatTagWithDocumentBrowser
{
  [[StatTagShared sharedInstance] configureBasicProperties];
}
-(void)runStatTagWithTabs
{
  _window = [[[NSApplication sharedApplication] windows] firstObject];
  [[StatTagShared sharedInstance] setWindow:_window];
  [[StatTagShared sharedInstance] initializeWordViews];
  
  [AppEventListener startListening];
  //[[StatTagShared sharedInstance] logAppStartup];
  
  if([[StatTagShared sharedInstance] isFirstLaunch])
  {
    [MacroInstallerUtility installMacros];
  }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification{
  //Posted immediately after the app becomes active.
  //we're going to check to see if word is active + our active word document collection, etc. here
  //we're going to replace the active polling method
}

- (void)applicationDidResignActive:(NSNotification *)notification {
  //Posted immediately after the app gives up its active status to another app.
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application  
  [AppEventListener stopListening];
}

// in our case - yes - let's quit if the last window is closed
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
  // We want the app to close, but in order to get window position to save appropriately we will return
  // NO from this method and signal the app to terminate separately.
  [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
  return NO;
}

//FIXME: not yet implemented
-(IBAction)openPreferences:(id)sender {
  [self openPreferences];
}

-(void)openPreferences {
  //https://developer.apple.com/library/content/qa/qa1552/_index.html
  //  if (![[StatTagShared sharedInstance] settingsViewController])
  //  {
  //   // SettingsViewController* _settingsVC = [[SettingsViewController alloc] init];
  //  } else {
  //    //[[StatTagShared sharedInstance] settingsViewController] showW
  //    //[[[StatTagShared sharedInstance] settingsViewController] showWindow:self];
  //  }
  NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
  self.preferencesWindowController = [storyBoard instantiateControllerWithIdentifier:@"preferencesWindowController"]; // instantiate your window controller
  
  SettingsViewController* settings = (SettingsViewController*)self.preferencesWindowController.contentViewController;
  
  StatTagShared* shared = [StatTagShared sharedInstance];
  settings.propertiesManager = [shared propertiesManager];
  settings.logManager = [shared logManager];
  [[settings propertiesManager] Load];
  settings.properties = [[shared propertiesManager] Properties]; //just for setup
  
  [[self preferencesWindowController] showWindow:self]; // show the window
  
  
  //NSLog(@"open preferences");
}


-(IBAction)openAboutWindow:(id)sender {
  [self openAboutWindow];
}

-(void)openAboutWindow
{
  NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
  self.aboutWindowController = [storyBoard instantiateControllerWithIdentifier:@"aboutWindowController"]; // instantiate your window controller
  [[self aboutWindowController] contentViewController];
  
  [[self aboutWindowController] showWindow:self]; // show the window
  
  //NSLog(@"open about");

}

- (IBAction)openSamplesInstallerWindow:(id)sender {

  // get a reference to the storyboard
  NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];

  // instantiate your window controller
  self.samplesWindowController = [storyBoard instantiateControllerWithIdentifier:@"samplesWindowController"];
  [[self samplesWindowController] contentViewController];
  
  // show the window
  [[self samplesWindowController] showWindow:self];

}


- (IBAction)installWordMacros:(id)sender {
  [MacroInstallerUtility installMacros];
}

- (IBAction)removeWordMacros:(id)sender {
  [MacroInstallerUtility removeMacros];
}


@end
