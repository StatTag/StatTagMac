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

-(BOOL)IsEmpty {
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return (
      [[_ValueResult stringByTrimmingCharactersInSet: ws] length] == 0
      && [[_FigureResult stringByTrimmingCharactersInSet: ws] length] == 0
      && (_TableResult == nil || [_TableResult isEmpty])
  );
  
  /*
   return (string.IsNullOrWhiteSpace(ValueResult)
   && string.IsNullOrWhiteSpace(FigureResult)
   && (TableResult == null || TableResult.IsEmpty()));

   */
  
}
-(NSString*)ToString {
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([[_ValueResult stringByTrimmingCharactersInSet: ws] length] > 0) {
    return _ValueResult;
  }
  if ([[_FigureResult stringByTrimmingCharactersInSet: ws] length] > 0) {
    return _FigureResult;
  }
  if(_TableResult != nil){
    return [_TableResult ToString];
  }
  return @"";
}



//MARK: JSON
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setValue:[self ValueResult] forKey:@"ValueResult"];
  [dict setValue:[self FigureResult] forKey:@"FigureResult"];
  [dict setValue:@([[NSNumber numberWithBool:[self IsEmpty]] boolValue]) forKey:@"IsEmpty"];
  if([self TableResult] != nil){
    [dict setObject:[[self TableResult] toDictionary] forKey:@"TableResult"]; //this might be a problem
  }
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    if([key isEqualToString:@"IsEmpty"]) {
      //skip
    } else if([key isEqualToString:@"TableResult"]) {
      [self setValue:[[STTable alloc] initWithDictionary:[dict valueForKey:key]] forKey:key];
    } else {
      [self setValue:[dict valueForKey:key] forKey:key];
    }
  }
}

-(NSString*)Serialize:(NSError**)outError
{
  return [STJSONUtility SerializeObject:self error:nil];
}

+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
  return [STJSONUtility SerializeList:list error:nil];
}

+(NSArray<STCommandResult*>*)DeserializeList:(id)List error:(NSError**)outError
{
  NSMutableArray<STCommandResult*>* ar = [[NSMutableArray<STCommandResult*> alloc] init];
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
    [self setWithDictionary:dict];
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
