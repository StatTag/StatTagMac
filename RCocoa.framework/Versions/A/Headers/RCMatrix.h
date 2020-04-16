//
//  RCMatrix.h
//  RCocoa
//
//  Created by Luke Rasmussen on 5/3/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCMatrix_h
#define RCMatrix_h

#import "RCSymbolicExpression.h"

@class RCEngine;

@interface RCMatrix<__covariant ObjectType> : RCSymbolicExpression
{
    NSMutableArray* _values;
}

-(id) initWithEngineAndExpressionAndDimensions: (RCEngine*)eng expression: (id)sexp rowCount: (int)rowCount columnCount: (int)columnCount;
-(int) RowCount;
-(int) ColumnCount;
-(ObjectType) ElementAt: (int)row column:(int)column;
-(void) CheckIndices: (int)row column:(int)column;
-(NSString*)ElementDescriptionAtRow: (int)row andColumn:(int)column;

@end


#endif /* RCMatrix_h */
