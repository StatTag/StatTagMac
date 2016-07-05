//
//  STCocoaUtil.m
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCocoaUtil.h"
#import <ApplicationServices/ApplicationServices.h>

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
        NSLog(@"the app's URL is: %@",appURL);
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

@end
