//
//  STProperties.m
//  StatTag
//
//  Created by Eric Whitley on 7/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STProperties.h"

@implementation STProperties

@synthesize StataLocation = _StataLocation;
@synthesize EnableLogging = _EnableLogging;
@synthesize LogLocation = _LogLocation;

-(instancetype)init {
  self = [super init];
  if(self) {
    _StataLocation = @"";
    _LogLocation = @"";
  }
  return self;
}



@end
