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
@class STCommandResult;
@class STTable;

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

//+ (instancetype)sharedInstance;

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

-(void)Show;
-(void)Hide;

-(BOOL)Initialize;

/**
 Determine if a command is one that would return a result of some sort.
 @param command : The command to evaluate
 */
-(BOOL)IsReturnable:(NSString*)command;

-(NSArray<STCommandResult*>*)CombineAndRunCommands:(NSArray<NSString*>*) commands;

/**
 Run a collection of commands and provide all applicable results.
 */
-(NSArray<STCommandResult*>*)RunCommands:(NSArray<NSString*>*)commands;

/**
 Determine the string result for a command that returns a single value.  This includes
 macros and scalars.
 */
-(NSString*)GetDisplayResult:(NSString*) command;

/**
 Combines the different components of a matrix command into a single structure.
 */
-(STTable*)GetTableResult:(NSString*) command;


/**
 Identify missing values from the Stata API and explicitly set them to a null result.
 
 @remark Stata represents missing values as very large integers.  If we don't account for
 those results, we will display large integers as a result.  To clean up the results, we
 will detect missing values and set them to null.
 */
-(NSArray<NSNumber*>*)ProcessForMissingValues:(NSArray<NSNumber*>*)data;

/**
 Run a Stata command and provide the result of the command (if one should be returned).
 @param command: The command to run, taken from a Stata do file
 @returns The result of the command, or null if the command does not provide a result.
 */
-(STCommandResult*)RunCommand:(NSString*) command;

+(BOOL)UnregisterAutomationAPI:(NSString*) path;
+(BOOL)RegisterAutomationAPI:(NSString*) path;


@end
