//
//  STJSON.m
//  StatTag
//
//  Created by Eric Whitley on 1/25/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import "STBase.h"
#import "STConstants.h"

@implementation STBase


-(id)copyWithZone:(NSZone *)zone
{
  STBase *b = [[[self class] allocWithZone:zone] init];
  
  b.ExtraMetadata = [_ExtraMetadata copy];
  
  return b;
}


-(void)configure {
  self.ExtraMetadata = [[NSMutableDictionary alloc] init];
}



//MARK: JSON
//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict addEntriesFromDictionary:[self ExtraMetadata]];
  return dict;
}

-(bool)setCustomObjectPropertyFromJSONObject:(id)object forKey:(NSString*)key
{
  return false;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  if(dict == nil || [dict isKindOfClass:[[NSNull null] class]])
  {
    return;
  }
  
  for (NSString* key in dict) {
    if([dict valueForKey:key] != nil && [dict valueForKey:key] != [NSNull null])
    {
      if(![self setCustomObjectPropertyFromJSONObject:[dict valueForKey:key] forKey:key])
      {
        [self setUnknownJSONObject:[dict valueForKey:key] forKey:key];
      }
    }
  }
  [self afterSetWithDictionary];
}
-(void)afterSetWithDictionary
{
}

-(void)setUnknownJSONObject:(id)object forKey:(NSString*)key
{
  if ([self respondsToSelector:NSSelectorFromString(key)])
  {
    //NSLog(@"setWithDictionary - setting property for Key '%@' and value '%@'", key, [dict valueForKey:key]);
    [self setValue:object forKey:key];
  } else {
    //archive our property info, even if unknown
    // we want to avoid "shaving off" unused properties that may break document compatibility
    // EX: if there is a property in a newer version of the StatTag content format we might just not know about it - so let's not toss
    // everything out
    // we're going to make the assumption (whether right or wrong) that a given key can exist ONCE and ONLY ONCE
    // if we have a second instance of that key, it will overwrite the existing value
    //NSLog(@"setWithDictionary - setting ExtraMetadata for Key '%@' and value '%@'", key, [dict valueForKey:key]);
    //NSLog(@"ExtraMetadata class = %@", [[self ExtraMetadata] class]);
    [[self ExtraMetadata] setObject:object forKey:key];
  }
}

-(void)BeforeSerialize
{
}

-(NSString*)Serialize:(NSError**)error
{
  [self BeforeSerialize];
  return [STJSONUtility SerializeObject:self error:nil];
}

/**
 Utility method to serialize the list of code files into a JSON array.
 */
+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
  return [STJSONUtility SerializeList:list error:nil];
}

/**
 Create a new Tag object given a JSON string
 */
+(instancetype)Deserialize:(NSString*)json error:(NSError**)outError
{
  NSError* error;
  return [[[self class] alloc] initWithJSONString:json error:&error];
}


/**
 Utility method to take a JSON array string and convert it back into a list of
 CodeFile objects.  This does not resolve the list of tags that may be
 associated with the CodeFile.
 */
//+(NSArray<STCodeFile*>*)DeserializeList:(NSString*)List error:(NSError**)outError
+(NSArray<id>*)DeserializeList:(id)List error:(NSError**)outError
{
  NSMutableArray<id>* ar = [[NSMutableArray<id> alloc] init];
  for(id x in [STJSONUtility DeserializeList:List forClass:[self class] error:nil]) {
    if([x isKindOfClass:[self class]])
    {
      [ar addObject:x];
    }
  }
  return ar;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
  self = [super init];
  if (self) {
    if(dict != nil  && ![dict isKindOfClass:[[NSNull null] class]])
    {
      [self configure];
      [self setWithDictionary:dict];
    }
  }
  return self;
}

-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
{
  self = [super init];
  if (self) {
    [self configure];
    
    NSError *error = nil;
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (!error && JSONDictionary) {
      [self setWithDictionary:JSONDictionary];
    } else {
      if (outError) {
        *outError = [NSError errorWithDomain:STStatTagErrorDomain
                                        code:[error code]
                                    userInfo:@{NSUnderlyingErrorKey: error}];
      }
    }
  }
  return self;
}




@end
