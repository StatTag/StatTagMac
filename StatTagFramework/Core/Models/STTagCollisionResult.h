//
//  STTagCollisionResult.h
//  StatTag
//
//  Created by Luke Rasmussen on 9/11/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTag.h"

#ifndef STTagCollisionResult_h
#define STTagCollisionResult_h

enum STCollisionType { NoOverlap, OverlapsExact, EmbeddedWithin, OverlapsFront, OverlapsBack, Embeds };

@interface STTagCollisionResult : NSObject {
  STTag* _CollidingTag;
  enum STCollisionType _Collision;
}

@property (copy, nonatomic) STTag* CollidingTag;
@property (nonatomic) enum STCollisionType Collision;

-(instancetype)init;
-(instancetype)init:(STTag*)collidingTag collision:(enum STCollisionType)collision;

@end

#endif /* STTagCollisionResult_h */
