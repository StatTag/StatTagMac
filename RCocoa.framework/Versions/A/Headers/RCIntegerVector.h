//
//  RCIntegerVector.h
//  RCocoa
//
//  Created by Luke Rasmussen on 5/3/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCIntegerVector_h
#define RCIntegerVector_h

#include "RCVector.h"

@interface RCIntegerVector : RCVector<NSNumber*>
{
}

-(void) SetVector: (NSArray<NSNumber*>*) values;
- (NSNumber*)objectAtIndexedSubscript:(int)index;

@end

#endif /* RCIntegerVector_h */
