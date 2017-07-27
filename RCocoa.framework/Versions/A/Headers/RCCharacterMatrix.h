//
//  RCCharacterMatrix.h
//  RCocoa
//
//  Created by Luke Rasmussen on 5/3/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCCharacterMatrix_h
#define RCCharacterMatrix_h

#include "RCMatrix.h"

@interface RCCharacterMatrix : RCMatrix<NSString*>
{
    
}

-(NSString*) ElementAt: (int)row column:(int)column;

@end

#endif /* RCCharacterMatrix_h */
