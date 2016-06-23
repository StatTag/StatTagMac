//
//  STJSONAble.h
//  StatTag
//
//  Created by Eric Whitley on 6/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONUtility.h"

@protocol STJSONAble <NSObject>

@required
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;

@optional
+(NSString*)SerializeList:(NSArray<NSObject*>*) files error:(NSError**)error;
+(NSArray<NSObject*>*)DeserializeList:(NSString*)List error:(NSError**)error;

@end
  