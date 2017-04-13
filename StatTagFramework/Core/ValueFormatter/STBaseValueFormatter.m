//
//  BaseValueFormatter.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseValueFormatter.h"

@implementation STBaseValueFormatter

+(NSString*)MissingValue {
  return @"";
}

-(NSString*)GetMissingValue {
  //NSLog(@"GetMissingValue for class: %@", [self class]);
  return [[self class] MissingValue];
}

-(NSString*)Finalize:(NSString*)value {
  if(value == nil || [value isKindOfClass:[[NSNull null] class]])
  {
    return [self GetMissingValue];
  }  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return [[value stringByTrimmingCharactersInSet: ws] length] == 0 ? [self GetMissingValue] : value;
}



@end
