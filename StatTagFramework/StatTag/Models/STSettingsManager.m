//
//  STSettingsManager.m
//  StatTag
//
//  Created by Eric Whitley on 8/1/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STSettingsManager.h"
#import "STUserSettings.h"
#import "STCocoaUtil.h"
#import "STLogManager.h"

@implementation STSettingsManager

//NSString* const ApplicationKey = @"Software\\Northwestern University\\StatTag";
static NSString* const StataLocationKey = @"Stata Location";
static NSString* const LogLocationKey = @"Log Location";
static NSString* const LogEnabledKey = @"Logging Enabled";
static NSString* const RunCodeOnOpenKey = @"Autorun Code";
static NSString* const LogLevelKey = @"Log Level";

@synthesize Settings = _Settings;

-(instancetype)init {
  self = [super init];
  if(self) {
    _Settings = [[STUserSettings alloc] init];
  }
  return self;
}

-(NSString*)description {
  return [NSString stringWithFormat:@"Settings: %@ = %@; %@ = %hhd; %@ = %ld", LogLocationKey, [_Settings LogLocation], LogEnabledKey, [_Settings EnableLogging], LogLevelKey, (long)[_Settings LogLevel]];
}

/**
 Save the properties to the user's registry.
*/
-(void)Save
{

  NSMutableDictionary* prefs = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]]];

  //NSMutableDictionary* prefsDict = [[NSMutableDictionary alloc] init];
  [prefs setValue:[_Settings StataLocation] forKey:StataLocationKey];
  [prefs setValue:[_Settings LogLocation] forKey:LogLocationKey];

  [prefs setValue:[NSNumber numberWithInteger:[_Settings LogLevel]] forKey:LogLevelKey];

  
  [prefs setValue:[NSNumber numberWithBool:[_Settings EnableLogging]] forKey:LogEnabledKey];
  [prefs setValue:[NSNumber numberWithBool:[_Settings RunCodeOnOpen]] forKey:RunCodeOnOpenKey];

  [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:[STCocoaUtil currentBundleIdentifier]];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  LOG_STATTAG_DEBUG(@"Saving Settings");
  LOG_STATTAG_DEBUG([self description]);
  //[[STLogManager sharedInstance] setLogLevel:[_Settings LogLevel]];
  
  
// we can't use the app-based domain because it will be the host app and not the StatTag framework's domain
//  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//  [defaults setValue:[_Properties StataLocation] forKey:StataLocationKey];
//  [defaults setValue:[_Properties LogLocation] forKey:LogLocationKey];
//  [defaults setBool:[_Properties EnableLogging] forKey:LogEnabledKey];
//  [defaults synchronize];

}

/**
 Load the properties from the user's registry.
*/
-(void)Load
{
  //NSLog(@"[STCocoaUtil currentBundleIdentifier] : %@", [STCocoaUtil currentBundleIdentifier]);
  NSDictionary* prefsDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]];
  _Settings.StataLocation = [prefsDict valueForKey:StataLocationKey];
  _Settings.LogLocation = [prefsDict valueForKey:LogLocationKey];
  _Settings.LogLevel = [[prefsDict objectForKey:LogLevelKey] integerValue];
  _Settings.EnableLogging = [[prefsDict objectForKey:LogEnabledKey] boolValue];
  _Settings.RunCodeOnOpen = [[prefsDict objectForKey:RunCodeOnOpenKey] boolValue];

  LOG_STATTAG_DEBUG(@"Loaded Settings");
  LOG_STATTAG_DEBUG([self description]);
  //[[STLogManager sharedInstance] setLogLevel:[_Settings LogLevel]];

// we can't use the app-based domain because it will be the host app and not the StatTag framework's domain
//  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//  _Properties.StataLocation = [defaults valueForKey:StataLocationKey];
//  _Properties.LogLocation = [defaults valueForKey:LogLocationKey];
//  _Properties.EnableLogging = [defaults boolForKey:LogEnabledKey];
}

@end
