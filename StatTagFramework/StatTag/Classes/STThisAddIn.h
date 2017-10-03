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
@class STDocumentManager;
@class STStatsManager;
@class STPropertiesManager;

@interface STThisAddIn : NSObject {
  STMSWord2011Application* _Application;
  STLogManager* _LogManager;
  NSString* _AppBundleIdentifier;
  STDocumentManager* _DocumentManager;
  STStatsManager* _StatsManager;
  STPropertiesManager* _PropertiesManager;
  NSNumber* _applicationVersion;
}

@property NSString* AppBundleIdentifier;
@property STLogManager* LogManager;
@property STMSWord2011Application* Application;
@property STDocumentManager* DocumentManager;
@property STStatsManager* StatsManager;
@property STPropertiesManager* PropertiesManager;
@property NSNumber* applicationVersion;

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


/**
 Perform a safe get of the active document.  There is no other way to safely
 check for the active document, since if it is not set it throws an exception.
 */
-(STMSWord2011Document*)SafeGetActiveDocument;

/**
 Perform some customization to document metadata before the document is actually saved.
 */
-(void)Application_DocumentBeforeSave:(STMSWord2011Document*)doc;

/**
 Handle initialization when a document is opened.  This may be called multiple times in a single Word session.
 */
-(void)Application_DocumentOpen:(STMSWord2011Document*)doc;



@end
