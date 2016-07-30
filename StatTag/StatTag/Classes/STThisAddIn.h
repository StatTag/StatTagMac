//
//  STThisAddIn.h
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STMSWord2011Application;
@class STMSWord2011Document;
@class STLogManager;

@interface STThisAddIn : NSObject {
  STMSWord2011Application* _Application;
  STLogManager* _LogManager;
  NSString* _AppBundleIdentifier;
}

@property NSString* AppBundleIdentifier;
@property STLogManager* LogManager;
@property STMSWord2011Application* Application;

/**
 Our list of Cocoa bundle identifiers
 */
+(NSArray<NSString*>*) ProcessNames;


/**
 Determine if app is running
 */
+(BOOL)IsAppRunning;
+(BOOL)IsAppInstalled;
+(NSURL*)AppPath;


-(STMSWord2011Document*)SafeGetActiveDocument;

@end
