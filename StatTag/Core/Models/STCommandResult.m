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

@synthesize ValueResult = _ValueResult;
@synthesize FigureResult = _FigureResult;
@synthesize TableResult = _TableResult;

-(BOOL)IsEmpty {
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return (
      [[_ValueResult stringByTrimmingCharactersInSet: ws] length] == 0
      && [[_FigureResult stringByTrimmingCharactersInSet: ws] length] == 0
      && _TableResult == nil
      && [_TableResult isEmpty]
  );
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


@end
