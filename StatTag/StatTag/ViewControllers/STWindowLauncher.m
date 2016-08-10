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
#import "StatTag.h"


@implementation STWindowLauncher

STSettingsController* settingsController;
STUpdateOutputController* updateOutputController;



+(NSString*)openSettings {
  NSLog(@"STWindowLauncher - openSettings - started");
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
  NSLog(@"STWindowLauncher - openSettings - completed");

  return @"openSettings";
}


+(NSString*)openUpdateOutput {
  NSLog(@"STWindowLauncher - openUpdateOutput - started");

  if(updateOutputController == nil)
    updateOutputController = [[STUpdateOutputController alloc] initWithWindowNibName:@"STUpdateOutputController"];
  
  NSWindow* settingsWindow = [updateOutputController window];

  [settingsWindow setTitle:@"Update Tags"];

  [NSApp activateIgnoringOtherApps:YES];
  [settingsWindow setLevel:NSMainMenuWindowLevel];
  [settingsWindow makeKeyAndOrderFront: self];
  
  [NSApp runModalForWindow: settingsWindow];
  [NSApp endSheet: settingsWindow];
  [settingsWindow close];
  NSLog(@"STWindowLauncher - openUpdateOutput - completed");

  return @"openUpdateOutput";
  
}

@end
