//
//  SCPerLine.m
//  StatTag
//
//  Created by Eric Whitley on 10/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "SCPerLine.h"


@implementation SCPerLine

-(instancetype) init {
  self = [super init];
  if(self) {
    
  }
  return self;
}

-(instancetype) initWithStart:(NSInteger)start andContainsMultibyte:(ContainsMultibyte)mb {
  self = [super init];
  if(self) {
    [self setStart:start];
    [self setContainsMultibyte:mb];
  }
  return self;
}

@end
