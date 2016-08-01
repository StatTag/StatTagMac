//
//  STCocoaUtil.h
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCocoaUtil : NSObject

+(NSURL*)appURLForBundleId:(NSString*)bundleID;
+(BOOL)appIsPresentForBundleID:(NSString*)bundleID;

+(NSString*)systemInformation;
+(NSString*)macOSVersion;
+(NSString*)machineModel;

+(NSString*)getApplicationDetailsForBundleID:(NSString*)app;
+(NSString*)bundleVersionInfo;

@end
