//
//  STCommandResult.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCommandResult.h"
#import "STTable.h"
#import "STConstants.h"

@implementation STCommandResult

@synthesize ValueResult = _ValueResult;
@synthesize FigureResult = _FigureResult;
@synthesize TableResult = _TableResult;
@synthesize TableResultPromise = _TableResultPromise;
@synthesize VerbatimResult = _VerbatimResult;

-(BOOL)IsEmpty {
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return (
      [[_ValueResult stringByTrimmingCharactersInSet: ws] length] == 0
      && [[_FigureResult stringByTrimmingCharactersInSet: ws] length] == 0
      && [[_VerbatimResult stringByTrimmingCharactersInSet: ws] length] == 0
      && (_TableResult == nil || [_TableResult isEmpty])
      && [[_TableResultPromise stringByTrimmingCharactersInSet: ws] length] <= 0
  );  
}
-(NSString*)ToString {
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([_ValueResult isKindOfClass:[NSString class]] && [[_ValueResult stringByTrimmingCharactersInSet: ws] length] > 0) {
    return _ValueResult;
  }
  if ([_FigureResult isKindOfClass:[NSString class]] && [[_FigureResult stringByTrimmingCharactersInSet: ws] length] > 0) {
    return _FigureResult;
  }
  if ([_VerbatimResult isKindOfClass:[NSString class]] && [[_VerbatimResult stringByTrimmingCharactersInSet: ws] length] > 0) {
    return _VerbatimResult;
  }
  if(_TableResult != nil){
    return [_TableResult ToString];
  }
  if (_TableResultPromise != nil && [_TableResultPromise isKindOfClass:[NSString class]] && [[_TableResultPromise stringByTrimmingCharactersInSet: ws] length] > 0) {
    return [NSString stringWithFormat:@"Table promise: %@", _TableResultPromise];
  }
  return @"";
}

-(NSString*)description {
  return [self ToString];
}

//MARK: JSON
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[super toDictionary]];
  [dict setValue:[self ValueResult] forKey:@"ValueResult"];
  [dict setValue:[self FigureResult] forKey:@"FigureResult"];
  [dict setValue:[self VerbatimResult] forKey:@"VerbatimResult"];
  [dict setValue:@([[NSNumber numberWithBool:[self IsEmpty]] boolValue]) forKey:@"IsEmpty"];

  // Per the comment within this commented block, we do have a problem adding the table results to the object.
  // It ends up making the dictionary unserializable to JSON, which (of course) means downstream problems as
  // we can't serialize the data needed for a field.
  // TODO - We really should fix this, but for now can get by without it. When this issue came up, we found
  // that the result was previously empty anyway.
//  if([self TableResult] != nil){
//    [dict setObject:[[self TableResult] toDictionary] forKey:@"TableResult"]; //this might be a problem
//  }

  return dict;
}

-(bool)setCustomObjectPropertyFromJSONObject:(id)object forKey:(NSString*)key
{
  if([key isEqualToString:@"IsEmpty"]) {
    //skip
  } else if([key isEqualToString:@"TableResult"]) {
    [self setValue:[[STTable alloc] initWithDictionary:object] forKey:key];
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
//    if([key isEqualToString:@"IsEmpty"]) {
//      //skip
//    } else if([key isEqualToString:@"TableResult"]) {
//      [self setValue:[[STTable alloc] initWithDictionary:[dict valueForKey:key]] forKey:key];
//    } else {
//      //we may have new / unexpected results - ex: when we got "verbatim" everything blew up
//      @try {
//        id val = [dict valueForKey:key];
//        if(![val isKindOfClass:[[NSNull null] class]])
//        {
//          [self setValue:[dict valueForKey:key] forKey:key];
//        }
//      }
//      @catch (NSException *exception) {
//        //NSLog(@"Unable to set '%@' value for key '%@'", [self className], key);
//        //NSLog(@"%@", exception.reason);
//      }
//    }
//  }
//}

//-(NSString*)Serialize:(NSError**)outError
//{
//  return [STJSONUtility SerializeObject:self error:nil];
//}
//
//+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
//  return [STJSONUtility SerializeList:list error:nil];
//}
//
//+(NSArray<STCommandResult*>*)DeserializeList:(id)List error:(NSError**)outError
//{
//  NSMutableArray<STCommandResult*>* ar = [[NSMutableArray<STCommandResult*> alloc] init];
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
//    if(dict != nil  && ![dict isKindOfClass:[[NSNull null] class]])
//    {
//      [self setWithDictionary:dict];
//    }
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
