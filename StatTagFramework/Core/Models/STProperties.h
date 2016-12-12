//
//  STProperties.h
//  StatTag
//
//  Created by Eric Whitley on 7/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  User preferences and settings for StatTag.
 */
@interface STProperties : NSObject {
  NSString* _StataLocation;
  BOOL _EnableLogging;
  NSString* _LogLocation;
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


@end
