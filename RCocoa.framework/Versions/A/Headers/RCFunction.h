//
//  RCFunction.h
//  RCocoa
//
//  Created by Rasmussen, Luke on 6/19/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCFunction_h
#define RCFunction_h

#import "RCSymbolicExpression.h"

@class RCEngine;

@interface RCFunction : RCSymbolicExpression
{
}

-(RCSymbolicExpression*) Invoke: (NSArray<RCSymbolicExpression*>*) args;

@end


#endif /* RCFunction_h */
