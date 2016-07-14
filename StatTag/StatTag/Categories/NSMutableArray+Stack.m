//
//  NSMutableArray+Stack.m
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

-(void)push:(id)item {
  [self addObject:item];
}

-(id)pop {
  id item = nil;
  if ([self count] != 0) {
    item = [self lastObject];
    [self removeLastObject];
  }
  return item;
}

-(id)peek {
  id item = nil;
  if ([self count] != 0) {
    item = [self lastObject];
  }
  return item;
}

@end
