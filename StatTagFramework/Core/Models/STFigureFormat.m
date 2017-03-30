//
//  STFigureFormat.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STFigureFormat.h"
#import "STConstants.h"


@implementation STFigureFormat

//MARK: copying

-(id)copyWithZone:(NSZone *)zone
{
  STFigureFormat *format = [[[self class] allocWithZone:zone] init];//[[STFigureFormat alloc] init];
  
  return format;
}







//MARK: JSON
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//  [dict setValue:[self Label] forKey:@"Label"];
//  [dict setValue:[NSNumber numberWithInteger:[self Action]] forKey:@"Action"];
//  [dict setValue:[self Parameter] forKey:@"Parameter"]; //this might be a problem
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  if(dict == nil || [dict isKindOfClass:[[NSNull null] class]])
  {
    return;
  }

  for (NSString* key in dict) {
    [self setValue:[dict valueForKey:key] forKey:key];
  }
}

-(NSString*)Serialize:(NSError**)outError
{
  return [STJSONUtility SerializeObject:self error:nil];
}

+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
  return [STJSONUtility SerializeList:list error:nil];
}

+(NSArray<STFigureFormat*>*)DeserializeList:(NSString*)List error:(NSError**)outError
{
  NSMutableArray<STFigureFormat*>* ar = [[NSMutableArray<STFigureFormat*> alloc] init];
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
      [self setWithDictionary:dict];
    }
  }
  return self;
}

-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
{
  self = [super init];
  if (self) {
    
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
