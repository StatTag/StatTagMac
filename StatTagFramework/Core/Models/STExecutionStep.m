//
//  STExecutionStep.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STExecutionStep.h"
#import "STConstants.h"
#import "STTag.h"

@implementation STExecutionStep

@synthesize Type = _Type;
@synthesize Code = _Code;
@synthesize Result = _Result;
@synthesize Tag = _Tag;

@synthesize lineStart = _lineStart;
@synthesize lineEnd = _lineEnd;

-(id)init {
  self = [super init];
  if(self){
    _Code = [[NSMutableArray alloc] init];
  }
  return self;
}



//MARK: JSON
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[super toDictionary]];

  [dict setValue:[NSNumber numberWithInteger:[self Type]] forKey:@"Type"];
  [dict setValue:[self Code] forKey:@"Code"];
  [dict setValue:[self Result] forKey:@"Result"];
  if([self Tag] != nil) {
    [dict setObject:[[self Tag] toDictionary] forKey:@"Tag"];
  }
  return dict;
}

-(bool)setCustomObjectPropertyFromJSONObject:(id)object forKey:(NSString*)key
{
  if([key isEqualToString:@"Tag"]) {
    [self setValue:[[STTag alloc] initWithDictionary:object] forKey:key];
  } else {
    return false;
  }
  return true;
}

//-(void)setWithDictionary:(NSDictionary*)dict {
//  if(dict == nil || [dict isKindOfClass:[[NSNull null] class]])
//  {
//    return;
//  }
//
//  for (NSString* key in dict) {
//    if([key isEqualToString:@"Tag"]) {
//      [self setValue:[[STTag alloc] initWithDictionary:[dict valueForKey:key]] forKey:key];
//    } else {
//      [self setValue:[dict valueForKey:key] forKey:key];
//    }
//  }
//}
//
//-(NSString*)Serialize:(NSError**)outError
//{
//  return [STJSONUtility SerializeObject:self error:nil];
//}
//
//+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
//  return [STJSONUtility SerializeList:list error:nil];
//}
//
//+(NSArray<STExecutionStep*>*)DeserializeList:(NSString*)List error:(NSError**)outError
//{
//  NSMutableArray<STExecutionStep*>* ar = [[NSMutableArray<STExecutionStep*> alloc] init];
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
//    [self setWithDictionary:dict];
//  }
//  return self;
//}
//
//-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
//{
//  self = [super init];
//  if (self) {
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





@end
