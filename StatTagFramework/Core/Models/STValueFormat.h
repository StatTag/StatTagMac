//
//  STValueFormat.h
//  StatTag
//
//  Created by Eric Whitley on 6/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONable.h"

@protocol STIValueFormatter;

@interface STValueFormat : NSObject <NSCopying, STJSONAble> {
  NSString* _FormatType;
  NSInteger _DecimalPlaces;
  BOOL _UseThousands;
  NSString* _DateFormat;
  NSString* _TimeFormat;
  BOOL _AllowInvalidTypes;
}

@property (copy, nonatomic) NSString* FormatType;
@property NSInteger DecimalPlaces;
@property BOOL UseThousands;
@property (copy, nonatomic) NSString* DateFormat;
@property (copy, nonatomic) NSString* TimeFormat;
@property BOOL AllowInvalidTypes;


/**
 @brief Formats a result given the current configuration
 @param value The string value to be formatted
 */
-(NSString*)Format:(NSString*)value valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter;
/**
 @brief Formats a result given the current configuration
 @param value The string value to be formatted
 */
-(NSString*)Format:(NSString*)value;

/**
 @brief Repeat a string value a number of times
 @param value The string to be repeated
 @param count The number of times to repeat the value
 */
+(NSString*)Repeat:(NSString*)value count:(NSInteger)count;



//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
+(NSString*)SerializeList:(NSArray<STValueFormat*>*)list error:(NSError**)error;
+(NSArray<STValueFormat*>*)DeserializeList:(NSString*)List error:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;



@end
