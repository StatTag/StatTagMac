//
//  STCocoaUtil.m
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCocoaUtil.h"
#import <ApplicationServices/ApplicationServices.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/sysctl.h>
//#import <AppleScriptObjC/AppleScriptObjC.h>
#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>

@implementation STCocoaUtil

+(NSURL*)appURLForBundleId:(NSString*)bundleID {
  NSURL *url;
  if(bundleID != nil) {
    
    CFURLRef appURL = NULL;
    OSStatus result = LSFindApplicationForInfo (
                                                kLSUnknownCreator,
                                                (__bridge CFStringRef)bundleID,
                                                NULL,
                                                NULL,
                                                &appURL
                                                );
    switch(result)
    {
      case noErr:
        //NSLog(@"the app's URL is: %@",appURL);
        url = (__bridge NSURL *)appURL;
        break;
      case kLSApplicationNotFoundErr:
        NSLog(@"app not found");
        break;
      default:
        NSLog(@"an error occurred: %ld",(long)result);
        break;
    }
    
    if(appURL) {
      CFRelease(appURL);
    }
    
  }
  
  return url;
}

+(BOOL)appIsPresentForBundleID:(NSString*)bundleID {
  return [[self class] appURLForBundleId:bundleID] != nil;
}


//Kudos to http://stackoverflow.com/questions/8299087/getting-the-machine-type-and-other-hardware-details-through-cocoa-api
+(NSString*)machineModel
{
  size_t len = 0;
  sysctlbyname("hw.model", NULL, &len, NULL, 0);
  
  if (len)
  {
    char *model = malloc(len*sizeof(char));
    sysctlbyname("hw.model", model, &len, NULL, 0);
    NSString *model_ns = [NSString stringWithUTF8String:model];
    free(model);
    return model_ns;
  }
  
  return @"Unknown macOS Device";
}

+(NSString*)macOSVersion
{
  NSOperatingSystemVersion osV = [[NSProcessInfo processInfo] operatingSystemVersion];
  NSString* osVersion = [NSString stringWithFormat:@"macOS (%ld.%ld.%ld)", (long)osV.majorVersion, (long)osV.minorVersion, (long)osV.patchVersion];
  return osVersion;
}

+(NSString*)systemInformation {
  return [NSString stringWithFormat:@"System: %@, Device Profile: %@", [[self class] macOSVersion], [[self class] machineModel]];
}

//https://developer.apple.com/reference/foundation/nsprocessinfo
+(NSInteger)physicalMemoryInBytes
{
  return [[NSProcessInfo processInfo] physicalMemory];
}

+(NSString*)physicalMemory
{
  return [NSString stringWithFormat:@"%llu GB", ([[NSProcessInfo processInfo] physicalMemory] / 1024 / 1024 / 1024)];
}

//if we need further info, go look at these - _fantastic_ examples
//http://stackoverflow.com/questions/1702870/how-to-collect-system-info-in-osx-using-objective-c
//http://www.cocoawithlove.com/blog/2016/03/08/swift-wrapper-for-sysctl.html

+(NSArray<NSString*>*)splitStringIntoArrray:(NSString*)str {
  NSMutableArray *chars = [[NSMutableArray alloc] initWithCapacity:[str length]];
  for (int i=0; i < [str length]; i++) {
    [chars addObject:[NSString stringWithFormat:@"%c", [str characterAtIndex:i]]];
  }
  return chars;
}
+(NSString*)currentBundleIdentifier {
  NSBundle* bundle = [NSBundle bundleForClass:[self class]];
  NSString * bundleName = [bundle bundleIdentifier];
  return bundleName;
}

+(NSString*)bundleVersionInfo {
  //http://stackoverflow.com/questions/3015796/how-to-programmatically-display-version-build-number-of-target-in-ios-app
  
  NSBundle* bundle = [NSBundle bundleForClass:[self class]];
  
  NSString * bundleIdentifier = [bundle bundleIdentifier];
  //NSString * bundleName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
  NSString * appVersionString = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  NSString * appBuildString = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
  
  NSString * versionBuildString = [NSString stringWithFormat:@"Version (%@): %@ (%@)", bundleIdentifier, appVersionString, appBuildString];
  
  return versionBuildString;
}

+(NSString*)getApplicationDetailsForBundleID:(NSString*)bundleID {
  //http://stackoverflow.com/questions/26829104/how-to-retrieve-an-applications-version-string
  
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    NSArray *apps = [ws runningApplications];
    for (NSRunningApplication *app in apps)
    {
      //[app displayIdentifier];
      if([[app bundleIdentifier] isEqualToString:bundleID]) {      
        pid_t pid = [app processIdentifier ];
        NSBundle *bundle = [NSBundle bundleWithURL:[app bundleURL]];
        NSDictionary *info = [bundle infoDictionary];
        
        NSString* name = info[@"CFBundleName"];
        NSString* identifier = info[@"CFBundleIdentifier"];
        NSString* version = info[@"CFBundleVersion"];
        NSString* shortVersion = info[@"CFBundleShortVersionString"];
        NSString* appInfo = [NSString stringWithFormat:@"PID: %ld, Name: %@, Identifier: %@, Version: %@ (%@)", (long)pid, name, identifier, version, shortVersion];
        return appInfo;
      }
    }
  
  return nil;
}


@end
