//
//  STTagCollisionResult.m
//  StatTag
//
//  Created by Luke Rasmussen on 9/11/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTagCollisionResult.h"
#import "STTag.h"

@implementation STTagCollisionResult : NSObject 

@synthesize CollidingTag = _CollidingTag;
@synthesize Collision = _Collision;

-(instancetype)init {
  self = [super init];
  return self;
}

-(instancetype)init:(STTag*)collidingTag collision:(enum STCollisionType)collision {
  self = [super init];
  if(self) {
    _CollidingTag = collidingTag;
    _Collision = collision;
  }
  return self;
}


@end
