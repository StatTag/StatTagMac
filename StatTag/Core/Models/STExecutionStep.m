//
//  STExecutionStep.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STExecutionStep.h"

@implementation STExecutionStep

@synthesize Type = Type;
@synthesize Code = Code;
@synthesize Result = Result;
@synthesize Tag = Tag;

-(id)init {
  self = [super init];
  if(self){
    Code = [[NSMutableArray alloc] init];
  }
  return self;
}

@end
