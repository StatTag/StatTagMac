//
//  STExecutionStep.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STExecutionStep.h"

@implementation STExecutionStep

@synthesize Type = _Type;
@synthesize Code = _Code;
@synthesize Result = _Result;
@synthesize Tag = _Tag;

-(id)init {
  self = [super init];
  if(self){
    _Code = [[NSMutableArray alloc] init];
  }
  return self;
}

@end