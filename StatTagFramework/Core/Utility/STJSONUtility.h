//
//  STJSONUtility.h
//  StatTag
//
//  Created by Eric Whitley on 6/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol STJSONAble;

@interface STJSONUtility : NSObject

+ (NSDate*)dateFromString:(NSString*)dateString;
+ (NSString*)convertDateToDateString:(NSDate*)date;

+ (NSString*)SerializeObject:(NSObject<STJSONAble>*)object error:(NSError**)outError;
+ (NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)files error:(NSError**)outError;


+(NSArray<NSObject<STJSONAble>*>*)DeserializeList:(id)List forClass:(id)c error:(NSError**)outError;

@end
