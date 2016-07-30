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
        NSLog(@"an error occurred: %d",(int)result);
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
  NSString* osVersion = [NSString stringWithFormat:@"macOS (%d.%d.%d)", osV.majorVersion, osV.minorVersion, osV.patchVersion];
  return osVersion;
}

//if we need further info, go look at these - _fantastic_ examples
//http://stackoverflow.com/questions/1702870/how-to-collect-system-info-in-osx-using-objective-c
//http://www.cocoawithlove.com/blog/2016/03/08/swift-wrapper-for-sysctl.html



@end
