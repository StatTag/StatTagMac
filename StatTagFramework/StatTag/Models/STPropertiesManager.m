//
//  STPropertiesManager.m
//  StatTag
//
//  Created by Eric Whitley on 8/1/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STPropertiesManager.h"
#import "STProperties.h"
#import "STCocoaUtil.h"

@implementation STPropertiesManager


NSString* const ApplicationKey = @"Software\\Northwestern University\\StatTag";
NSString* const StataLocationKey = @"Stata Location";
NSString* const LogLocationKey = @"Log Location";
NSString* const LogEnabledKey = @"Logging Enabled";
NSString* const RunCodeOnOpenKey = @"Autorun Code";

@synthesize Properties = _Properties;

-(instancetype)init {
  self = [super init];
  if(self) {
    _Properties = [[STProperties alloc] init];
  }
  return self;
}

/**
 Save the properties to the user's registry.
*/
-(void)Save
{

  NSMutableDictionary* prefs = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]]];

  //NSMutableDictionary* prefsDict = [[NSMutableDictionary alloc] init];
  [prefs setValue:[_Properties StataLocation] forKey:StataLocationKey];
  [prefs setValue:[_Properties LogLocation] forKey:LogLocationKey];
  [prefs setValue:[NSNumber numberWithBool:[_Properties EnableLogging]] forKey:LogEnabledKey];
  [prefs setValue:[NSNumber numberWithBool:[_Properties RunCodeOnOpen]] forKey:RunCodeOnOpenKey];

  [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:[STCocoaUtil currentBundleIdentifier]];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
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
  NSLog(@"[STCocoaUtil currentBundleIdentifier] : %@", [STCocoaUtil currentBundleIdentifier]);
  NSDictionary* prefsDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]];
  _Properties.StataLocation = [prefsDict valueForKey:StataLocationKey];
  _Properties.LogLocation = [prefsDict valueForKey:LogLocationKey];
  _Properties.EnableLogging = [[prefsDict objectForKey:LogEnabledKey] boolValue];
  _Properties.RunCodeOnOpen = [[prefsDict objectForKey:RunCodeOnOpenKey] boolValue];

// we can't use the app-based domain because it will be the host app and not the StatTag framework's domain
//  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//  _Properties.StataLocation = [defaults valueForKey:StataLocationKey];
//  _Properties.LogLocation = [defaults valueForKey:LogLocationKey];
//  _Properties.EnableLogging = [defaults boolForKey:LogEnabledKey];
}

@end
