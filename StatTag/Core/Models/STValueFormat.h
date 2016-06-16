//
//  STValueFormat.h
//  StatTag
//
//  Created by Eric Whitley on 6/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STIValueFormatter;

@interface STValueFormat : NSObject {
  NSString* FormatType;
  int DecimalPlaces;
  BOOL UseThousands;
  NSString* DateFormat;
  NSString* TimeFormat;
  BOOL AllowInvalidTypes;
}

@property NSString* FormatType;
@property int DecimalPlaces;
@property BOOL UseThousands;
@property NSString* DateFormat;
@property NSString* TimeFormat;
@property BOOL AllowInvalidTypes;


/**
 @brief Formats a result given the current configuration
 @param value: The string value to be formatted
 */
-(NSString*)Format:(NSString*)value valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter;
/**
 @brief Formats a result given the current configuration
 @param value: The string value to be formatted
 */
-(NSString*)Format:(NSString*)value;

/**
 @brief Repeat a string value a number of times
 @param value: The string to be repeated
 @param count: The number of times to repeat the value
 */
+(NSString*)Repeat:(NSString*)value count:(int)count;


@end
