//
//  RCIntegerMatrix.h
//  RCocoa
//
//  Created by Luke Rasmussen on 5/16/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCIntegerMatrix_h
#define RCIntegerMatrix_h

#include "RCMatrix.h"

@interface RCIntegerMatrix : RCMatrix<NSNumber*>
{
    
}

-(int) ElementAt: (int)row column:(int)column;

@end

#endif /* RCIntegerMatrix_h */
