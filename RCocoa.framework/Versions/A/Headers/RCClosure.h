//
//  RCClosure.h
//  RCocoa
//
//  Created by Rasmussen, Luke on 6/19/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCClosure_h
#define RCClosure_h

#import "RCFunction.h"

@class RCEngine;

@interface RCClosure : RCFunction
{
}

-(RCSymbolicExpression*) Invoke:(NSArray<RCSymbolicExpression *> *)args;

@end


#endif /* RCClosure_h */
