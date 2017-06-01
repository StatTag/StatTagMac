//
//  RCDataFrame.h
//  RCocoa
//
//  Created by Luke Rasmussen on 5/16/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCDataFrame_h
#define RCDataFrame_h

#include "RCVector.h"

@interface RCDataFrame : RCVector<id>
{
}

-(void) SetVector: (NSArray<id>*) values;
- (id)objectAtIndexedSubscript:(int)index;

-(NSArray<NSString*>*) RowNames;
-(NSArray<NSString*>*) ColumnNames;

@end

#endif /* RCDataFrame_h */
