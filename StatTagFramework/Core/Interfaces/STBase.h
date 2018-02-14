//
//  STJSON.h
//  StatTag
//
//  Created by Eric Whitley on 1/25/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STJSONAble.h"


@interface STBase : NSObject <STJSONAble, NSCopying> {
  
  NSMutableDictionary* _ExtraMetadata;

}


@property (strong, nonatomic) NSMutableDictionary* ExtraMetadata;

-(void)configure;

//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;

-(void)setUnknownJSONObject:(id)object forKey:(NSString*)key;
-(void)setWithDictionary:(NSDictionary*)dict;
-(bool)setCustomObjectPropertyFromJSONObject:(id)object forKey:(NSString*)key;
-(void)afterSetWithDictionary;


/**
 Utility method to serialize the list of code files into a JSON array.
 */
+(NSString*)SerializeList:(NSArray<id>*)list error:(NSError**)error;

/**
 Create a new Tag object given a JSON string
 */
+(instancetype)Deserialize:(NSString*)json error:(NSError**)outError;

/**
 Utility method to take a JSON array string and convert it back into a list of
 CodeFile objects.  This does not resolve the list of tags that may be
 associated with the CodeFile.
 */
+(NSArray<id>*)DeserializeList:(id)List error:(NSError**)error;


@end
