//
//  STPropertiesManager.m
//  StatTag
//
//  Created by Eric Whitley on 8/1/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STPropertiesManager.h"
#import "STProperties.h"

@implementation STPropertiesManager


NSString* const ApplicationKey = @"Software\\Northwestern University\\StatTag";
NSString* const StataLocationKey = @"Stata Location";
NSString* const LogLocationKey = @"Log Location";
NSString* const LogEnabledKey = @"Logging Enabled";

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
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setValue:[_Properties StataLocation] forKey:StataLocationKey];
  [defaults setValue:[_Properties LogLocation] forKey:LogLocationKey];
  [defaults setBool:[_Properties EnableLogging] forKey:LogEnabledKey];
  [defaults synchronize];
}

/**
 Load the properties from the user's registry.
*/
-(void)Load
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  _Properties.StataLocation = [defaults valueForKey:StataLocationKey];
  _Properties.LogLocation = [defaults valueForKey:LogLocationKey];
  _Properties.EnableLogging = [defaults boolForKey:LogEnabledKey];
}

@end
