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

-(NSString*)Finalize:(NSString*)value {
  NSCharacterSet *ws = [NSCharacterSet whitespaceCharacterSet];
  return [[value stringByTrimmingCharactersInSet: ws] length] == 0 ? [self GetMissingValue] : value;
}

-(NSString*)GetMissingValue {
  return [[self class] MissingValue];
}


@end
