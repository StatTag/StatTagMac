//
//  RCLogicalMatrix.h
//  RCocoa
//
//  Created by Luke Rasmussen on 5/16/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCLogicalMatrix_h
#define RCLogicalMatrix_h

#include "RCMatrix.h"

@interface RCLogicalMatrix : RCMatrix<NSNumber*>
{
    
}

-(BOOL) ElementAt: (int)row column:(int)column;

@end

#endif /* RCLogicalMatrix_h */
