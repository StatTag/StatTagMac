//
//  STStataAutomation.m
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STStataAutomation.h"
#import "StatTag.h"
#import "STCocoaUtil.h"

@implementation STStataAutomation


NSString *const LocalMacroPrefix = @"_";
NSString *const StatTagTempMacroName = @"__st_tmp_display_value";
NSString *const DisablePagingCommand = @"set more off";
NSString *const RegisterParameter = @"/Register";
NSString *const UnregisterParameter = @"/Unregister";
//NSString* StaticAppBundleIdentifier;// = @"com.stata.stata14";
@synthesize AppBundleIdentifier = _AppBundleIdentifier;

+(NSArray<NSString*>*) StataProcessNames {
  return [NSArray arrayWithObjects:
          @"com.stata.stata14",
          nil];
}

+(NSString*)determineInstalledAppBundleIdentifier {
  for(NSString* bundleID in [[self class]StataProcessNames]) {
    if ([STCocoaUtil appIsPresentForBundleID:bundleID]) {
      return bundleID;
    }
  }
  return nil;
}

typedef NS_ENUM(NSInteger, ScalarType) {
  NotFound = 0,
  Numeric = 1,
  String = 2
};

const int StataHidden = 1;
const int MinimizeStata = 2;
const int ShowStata = 3;

//static STStataAutomation* sharedInstance = nil;
//+ (instancetype)sharedInstance
//{
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    sharedInstance = [[self alloc] init];
//    //sharedInstance.AppBundleIdentifier = [[self class] determineInstalledAppBundleIdentifier] ;
//  });
//  return sharedInstance;
//}

-(instancetype)init {
  self = [super init];
  if(self) {
    //id Application;
    STBaseParserStata* parser = [[STBaseParserStata alloc] init];
    NSArray<NSString*>* OpenLogs = [[NSArray<NSString*> alloc] init];
    _AppBundleIdentifier = [[self class] determineInstalledAppBundleIdentifier];
    if([[self class] IsAppInstalled]){
      Application = [SBApplication applicationWithBundleIdentifier:_AppBundleIdentifier];
    }
  }
  return self;
}

+(BOOL)IsAppInstalled {
  return [STCocoaUtil appIsPresentForBundleID:[[self class] determineInstalledAppBundleIdentifier]];
}
  
+(BOOL)IsAppRunning {
  STStataApplication *s = [SBApplication applicationWithBundleIdentifier:[[self class] determineInstalledAppBundleIdentifier]];
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
-(void)Show{
  NSArray *apps = [self getRunningApps];
  if ([apps count] > 0) {
    [(NSRunningApplication *)[apps objectAtIndex:0] activateWithOptions: (NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps)];
  }
}

-(void)Hide{
  NSArray *apps = [self getRunningApps];
  if ([apps count] > 0) {
    [(NSRunningApplication *)[apps objectAtIndex:0] hide];
  }
}



@end
