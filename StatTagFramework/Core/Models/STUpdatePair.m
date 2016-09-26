//
//  STUpdatePair.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STUpdatePair.h"

@implementation STUpdatePair

@synthesize Old = _Old;
@synthesize New = _New;

-(instancetype)init {
  self = [super init];
  return self;
}

-(instancetype)init:(id)oldItem newItem:(id)newItem {
  self = [super init];
  if(self) {
    _Old = oldItem;
    _New = newItem;
  }
  return self;
}


@end
