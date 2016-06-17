//
//  STCommandResult.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCommandResult.h"
#import "STTable.h"

@implementation STCommandResult

@synthesize ValueResult;
@synthesize FigureResult;
@synthesize TableResult;

-(BOOL)IsEmpty {
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return (
      [[ValueResult stringByTrimmingCharactersInSet: ws] length] == 0
      && [[FigureResult stringByTrimmingCharactersInSet: ws] length] == 0
      && TableResult == nil
      && [TableResult isEmpty]
  );
}
-(NSString*)ToString {  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([[ValueResult stringByTrimmingCharactersInSet: ws] length] > 0) {
    return ValueResult;
  }
  if ([[FigureResult stringByTrimmingCharactersInSet: ws] length] > 0) {
    return FigureResult;
  }
  if(TableResult != nil){
    return [TableResult ToString];
  }
  return @"";
}


@end
