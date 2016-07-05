//
//  STStataAutomation.h
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STStataCommands.h"
@class STStataApplication;
@class STBaseParserStata;

@interface STStataAutomation : NSObject {
  STStataApplication* Application;
  STBaseParserStata* Parser;
  NSMutableArray<NSString*>* OpenLogs;
  
  const int StataHidden;
  const int MinimizeStata;
  const int ShowStata;

  NSString* _AppBundleIdentifier;
}

@property NSString* AppBundleIdentifier;

+ (instancetype)sharedInstance;

extern NSString *const LocalMacroPrefix;
/**
  This is a special local macro name that is being used within StatTag.
*/
extern NSString *const StatTagTempMacroName;
extern NSString *const DisablePagingCommand;
// The following are constants used to manage the Stata Automation API
extern NSString *const RegisterParameter;
extern NSString *const UnregisterParameter;

/**
 Our list of Cocoa bundle identifiers
 
 From the c#:
 ---
 The collection of all possible Stata process names.  These are converted to
 lower case here because the comparison we do later depends on conversion to
 lower case.
 */
+(NSArray<NSString*>*) StataProcessNames;


/**
 Determine if a copy of Stata is running
 */
+(BOOL)IsAppRunning;
+(BOOL)IsAppInstalled;
+(NSURL*)AppPath;
+(NSString*)InstalledAppBundleIdentifier;

-(void)Show;
-(void)Hide;

-(BOOL)Initialize;

@end
