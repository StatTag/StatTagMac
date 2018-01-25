//
//  STDocumentMetadata.m
//  StatTag
//
//  Created by Eric Whitley on 1/18/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import "STDocumentMetadata.h"
#import "STConstants.h"

@implementation STDocumentMetadata

@synthesize MetadataFormatVersion = _MetadataFormatVersion;
@synthesize TagFormatVersion = _TagFormatVersion;
@synthesize StatTagVersion = _StatTagVersion;
@synthesize RepresentMissingValues = _RepresentMissingValues;
@synthesize CustomMissingValue = _CustomMissingValue;
//@synthesize ExtraMetadata = _ExtraMetadata;

-(instancetype)init
{
  self = [super init];
  if(self)
  {
    [self configure];
  }
  return self;
}

+(NSString*)CurrentMetadataFormatVersion {
  //FIXME: put this into a plist. We don't want to change code to publish a format change.
  return @"1.0.0";
}


-(NSString*) GetMissingValueReplacementAsString
{
  if([[self RepresentMissingValues] isEqualToString:[STConstantsMissingValueOption BlankString]])
  {
    return @"an empty (blank) string";
  } else if([[self RepresentMissingValues] isEqualToString:[STConstantsMissingValueOption StatPackageDefault]])
  {
    return @"the statistical program's default";
  } else if([[self RepresentMissingValues] isEqualToString:[STConstantsMissingValueOption CustomValue]])
  {
    return [NSString stringWithFormat:@"'%@'", [self CustomMissingValue]];//string.Format("'{0}'", CustomMissingValue);
  } else {
    return @"an unspecified value";
  }
}

//MARK: copy

-(id)copyWithZone:(NSZone *)zone
{
//  STDocumentMetadata *m = [[[self class] allocWithZone:zone] init];
  STDocumentMetadata *m = (STDocumentMetadata*)[super copyWithZone:zone];

  
  m.MetadataFormatVersion = [_MetadataFormatVersion copy];
  m.TagFormatVersion = [_TagFormatVersion copy];
  m.StatTagVersion = [_StatTagVersion copy];
  m.RepresentMissingValues = [_RepresentMissingValues copy];
  m.CustomMissingValue = [_CustomMissingValue copy];

  return m;
}


//MARK: JSON methods

-(NSDictionary *)toDictionary {
  
  //NSError* error;
  
  NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[super toDictionary]];
  
  [dict setValue:_MetadataFormatVersion forKey:@"MetadataFormatVersion"];
  [dict setValue:_TagFormatVersion forKey:@"TagFormatVersion"];
  [dict setValue:_StatTagVersion forKey:@"StatTagVersion"];
  [dict setValue:_RepresentMissingValues forKey:@"RepresentMissingValues"];
  [dict setValue:_CustomMissingValue forKey:@"CustomMissingValue"];

  //retain any unknown / unsupported keys/values we may have
  //these might be legacy StatTag items or newer items we don't yet know about - we don't want to break document compatibility
  //NSLog(@"toDictionary ExtraMetadata : %@", [self ExtraMetadata]);
  
  return dict;
  
}

-(bool)setCustomObjectPropertyFromJSONObject:(id)object forKey:(NSString*)key
{
  return false;
}
//
//-(void)setWithDictionary:(NSDictionary*)dict {
//  if(dict == nil || [dict isKindOfClass:[[NSNull null] class]])
//  {
//    return;
//  }
//  
//  NSError* error;
//  
//  for (NSString* key in dict) {
//    //we don't want null-value keys
////    if(![[dict valueForKey:key] isEqual: [NSNull null]])
////    {
//      if ([self respondsToSelector:NSSelectorFromString(key)])
//      {
//        //NSLog(@"setWithDictionary - setting property for Key '%@' and value '%@'", key, [dict valueForKey:key]);
//        [self setValue:[dict valueForKey:key] forKey:key];
//      } else {
//        //archive our property info, even if unknown
//        // we want to avoid "shaving off" unused properties that may break document compatibility
//        // EX: if there is a property in a newer version of the StatTag content format we might just not know about it - so let's not toss
//        // everything out
//        // we're going to make the assumption (whether right or wrong) that a given key can exist ONCE and ONLY ONCE
//        // if we have a second instance of that key, it will overwrite the existing value
//        //NSLog(@"setWithDictionary - setting ExtraMetadata for Key '%@' and value '%@'", key, [dict valueForKey:key]);
//        //NSLog(@"ExtraMetadata class = %@", [[self ExtraMetadata] class]);
//        [[self ExtraMetadata] setObject:[dict valueForKey:key] forKey:key];
//      }      
////    }
//  }
//  
//}
//
///**
// Serialize the current object, excluding circular elements like CodeFile
// */
//-(NSString*)Serialize:(NSError**)error
//{
//  return [STJSONUtility SerializeObject:self error:nil];
//}
//
///**
// Create a new Tag object given a JSON string
// */
//+(instancetype)Deserialize:(NSString*)json error:(NSError**)outError
//{
//  //moved to dictionary setup for consistency - that method is called from all deserializers
//  //leaving this here so it's clear why we deviate from the c#
//  //NSError* error;
//  //STTag* tag = [[[self class] alloc] initWithJSONString:json error:&error];
//  //tag.Name = [[self class] NormalizeName:[tag Name]];
//  //return tag;
//  NSError* error;
//  return [[[self class] alloc] initWithJSONString:json error:&error];
//}
//
//+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
//  return [STJSONUtility SerializeList:list error:nil];
//}
//
//+(NSArray<STDocumentMetadata*>*)DeserializeList:(id)List error:(NSError**)outError
//{
//  NSMutableArray<STDocumentMetadata*>* ar = [[NSMutableArray<STDocumentMetadata*> alloc] init];
//  for(id x in [STJSONUtility DeserializeList:List forClass:[self class] error:nil]) {
//    if([x isKindOfClass:[self class]])
//    {
//      [ar addObject:x];
//    }
//  }
//  return ar;
//}
//
//-(instancetype)initWithDictionary:(NSDictionary*)dict
//{
//  self = [super init];
//  if (self) {
//    [self configure];
//    [self setWithDictionary:dict];
//  }
//  return self;
//}
//
//-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
//{
//  self = [super init];
//  if (self) {
//    [self configure];
//    
//    NSError *error = nil;
//    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
//    
//    if (!error && JSONDictionary) {
//      [self setWithDictionary:JSONDictionary];
//    } else {
//      if (outError) {
//        *outError = [NSError errorWithDomain:STStatTagErrorDomain
//                                        code:[error code]
//                                    userInfo:@{NSUnderlyingErrorKey: error}];
//      }
//    }
//  }
//  return self;
//}
//





//MARK: equality
- (NSUInteger)hash {
  return [[self MetadataFormatVersion] hash] ^ [[self TagFormatVersion] hash] ^ [[self StatTagVersion] hash] ^ [[self RepresentMissingValues] hash] ^ [[self CustomMissingValue] hash] ^ [[self ExtraMetadata] hash];
}

- (BOOL)isEqual:(id)object
{
  STDocumentMetadata *o = object;
  if (o == nil)
  {
    return false;
  }

  if(self == object)
  {
    return true;
  }
  
  return false;
}


//MARK: descriptions

- (NSString*)ToString {
  return [self description];
}

- (NSString*)description {
  return [NSString stringWithFormat:@"%@ MetadataFormatVersion=%@ TagFormatVersion=%@ StatTagVersion=%@ RepresentMissingValues=%@ CustomMissingValue=%@ ExtraMetadata=%@", NSStringFromClass([self class]), [self MetadataFormatVersion], [self TagFormatVersion], [self StatTagVersion], [self RepresentMissingValues], [self CustomMissingValue] , [self ExtraMetadata]];
}




@end
