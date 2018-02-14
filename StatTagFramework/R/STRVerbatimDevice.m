//
//  STRVerbatimDevice.m
//  StatTag
//
//  Created by Rasmussen, Luke on 7/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "STRVerbatimDevice.h"

@implementation STRVerbatimDevice

static STRVerbatimDevice* _mainDevice = nil;

+ (STRVerbatimDevice*) GetInstance
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _mainDevice = [[STRVerbatimDevice alloc] init];
  });

  return _mainDevice;
}

-(id)init
{
  Cache = [[NSMutableArray alloc] init];
  return self;
}

-(void)StartCache
{
  CacheEnabled = true;
  [Cache removeAllObjects];
}

-(void)StopCache
{
  CacheEnabled = false;
}

-(NSArray<NSString*>*)GetCache
{
  return Cache;
}

-(void)WriteConsole:(const char*)buffer length:(int)length
{
  [self WriteConsoleEx:buffer length:length otype:0];
}

-(void) WriteConsoleEx:(const char*)buffer length:(int)length otype:(int)otype
{
  if (CacheEnabled) {
    NSString* string = [[NSString alloc] initWithBytes:buffer length:length encoding:NSUTF8StringEncoding];
    [Cache addObject:string];
  }
}

@end
