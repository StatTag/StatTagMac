//
//  AppDelegate.m
//  StatTagTestUI
//
//  Created by Eric Whitley on 8/3/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "AppDelegate.h"
#import "STSettingsController.h"
#import "StatTag.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

STSettingsController* settingsController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


- (IBAction)openSettings:(id)sender {
  
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
  [NSApp runModalForWindow: settingsWindow];
  [NSApp endSheet: settingsWindow];
  [settingsWindow close];
  
}


@end
