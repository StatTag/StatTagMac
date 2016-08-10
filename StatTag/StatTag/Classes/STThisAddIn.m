//
//  STThisAddIn.m
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STThisAddIn.h"
#import "STMSWord2011.h"
#import "STCocoaUtil.h"
#import "STLogManager.h"

@implementation STThisAddIn

@synthesize AppBundleIdentifier = _AppBundleIdentifier;
@synthesize Application = _Application;
@synthesize LogManager = _LogManager;

+(NSArray<NSString*>*) ProcessNames {
  return [NSArray arrayWithObjects:
          @"com.microsoft.Word",
          nil];
}

+(NSString*)determineInstalledAppBundleIdentifier {
  for(NSString* bundleID in [[self class]ProcessNames]) {
    if ([STCocoaUtil appIsPresentForBundleID:bundleID]) {
      return bundleID;
    }
  }
  return nil;
}

-(instancetype)init {
  self = [super init];
  if(self) {
    _AppBundleIdentifier = [[self class] determineInstalledAppBundleIdentifier];
    if([[self class] IsAppInstalled]){
      _Application = [SBApplication applicationWithBundleIdentifier:_AppBundleIdentifier];
      _LogManager = [[STLogManager alloc] init];
    }
  }
  return self;
}

+(BOOL)IsAppInstalled {
  return [STCocoaUtil appIsPresentForBundleID:[[self class] determineInstalledAppBundleIdentifier]];
}

+(BOOL)IsAppRunning {
  STMSWord2011Application *s = [SBApplication applicationWithBundleIdentifier:[[self class] determineInstalledAppBundleIdentifier]];
  if([s isRunning]) {
    return true;
  }
  return false;
}

+(NSURL*)AppPath {
  return [STCocoaUtil appURLForBundleId:[[self class] determineInstalledAppBundleIdentifier]];
}

-(NSArray<NSRunningApplication*>*)getRunningApps {
  if(_AppBundleIdentifier != nil) {
    return [NSRunningApplication runningApplicationsWithBundleIdentifier:_AppBundleIdentifier];
  }
  return nil;
}



//FIXME: incomplete implementation - just stubbing this out to test Word

/**
 Perform a safe get of the active document.  There is no other way to safely
 check for the active document, since if it is not set it throws an exception.
*/
-(STMSWord2011Document*)SafeGetActiveDocument {
  @try {
    return [[self Application] activeDocument];
  }
  @catch (NSException* exception) {
    NSLog(@"%@", exception.reason);
    NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    NSLog(@"%@", [NSThread callStackSymbols]);

    NSLog(@"Getting ActiveDocument threw an exception : %@", exception.reason);
  }
  @finally {
  }
  return nil;
}


@end
