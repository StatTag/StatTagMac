//
//  RCVector.h
//  RCocoa
//
//  Created by Luke Rasmussen on 5/3/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCVector_h
#define RCVector_h

#import "RCSymbolicExpression.h"

@class RCEngine;

@interface RCVector<__covariant ObjectType> : RCSymbolicExpression
{
}

-(id) initWithEngineAndExpressionAndLength: (RCEngine*)eng expression: (id)sexp length: (int)len;
-(void) SetVector: (NSArray<ObjectType>*) values;
-(NSArray<NSString*>*) Names;
-(R_xlen_t) Length;
-(ObjectType) ElementAt: (int)index;

@end

#endif /* RCVector_h */
