//
//  STUserSettings.h
//  StatTag
//
//  Created by Eric Whitley on 7/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLogManager.h"

/**
  User preferences and settings for StatTag.
 */
@interface STUserSettings : NSObject {
  NSString* _StataLocation;
  BOOL _EnableLogging;
  NSString* _LogLocation;

  STLogLevel _LogLevel;
  
  NSString* _RepresentMissingValues;
  NSString* _CustomMissingValue;
}

/**
 The full path to the Stata executable on the user's machine.
*/
@property (copy, nonatomic) NSString* StataLocation;
/**
 If the user would like to have debug logging enabled.
 */
@property (nonatomic) BOOL EnableLogging;
/**
 The path of the log file to write to.
 */
@property (copy, nonatomic) NSString* LogLocation;
/**
 Automatically run attached statistical code and update a document when the Word document is opened.
 */
@property BOOL RunCodeOnOpen;

@property STLogLevel LogLevel;


/**
 How StatTag should represent missing values within the Word document.
 The allowed values should come from Constants.MissingValueOption
 */
@property (copy, nonatomic) NSString* RepresentMissingValues;

/**
 If a missing value is represented by a user-defined string, this will
 be the string to use.  It may be set even if another missing value
 option is selected, just to preserve the user's previous choice.
 */
@property (copy, nonatomic) NSString* CustomMissingValue;


@end
