//
//  RCRealMatrix.h
//  RCocoa
//
//  Created by Luke Rasmussen on 5/16/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCRealMatrix_h
#define RCRealMatrix_h

#include "RCMatrix.h"

@interface RCRealMatrix : RCMatrix<NSNumber*>
{
    
}

-(double) ElementAt: (int)row column:(int)column;

@end

#endif /* RCRealMatrix_h */
