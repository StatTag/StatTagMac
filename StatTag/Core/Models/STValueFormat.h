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
  NSString* _FormatType;
  int _DecimalPlaces;
  BOOL _UseThousands;
  NSString* _DateFormat;
  NSString* _TimeFormat;
  BOOL _AllowInvalidTypes;
}

@property (copy, nonatomic) NSString* FormatType;
@property int DecimalPlaces;
@property BOOL UseThousands;
@property (copy, nonatomic) NSString* DateFormat;
@property (copy, nonatomic) NSString* TimeFormat;
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
