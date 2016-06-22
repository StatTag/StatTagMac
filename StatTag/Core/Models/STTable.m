//
//  STTable.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTable.h"

@implementation STTable

@synthesize RowNames = _RowNames;
@synthesize ColumnNames = _ColumnNames;
@synthesize RowSize = _RowSize;
@synthesize ColumnSize = _ColumnSize;
@synthesize Data = _Data; //type is double
@synthesize FormattedCells = _FormattedCells;

-(id)init {
  self = [super init];
  if(self) {
    _RowNames = [[NSMutableArray alloc] init];
    _ColumnNames = [[NSMutableArray alloc] init];
  }
  return self;
}

-(id)init:(NSArray <NSString *>*)rowNames columnNames:(NSArray <NSString *>*)columnNames rowSize:(int)rowSize columnSize:(int)columnSize data:(NSArray <NSNumber *>*)data {
  self = [super init];
  if(self) {
    //note: original c# passes nil to the row/column name arrays if we send nil arguments
    //originally I had changed this to init the arrays, but this causes issues later with format checks (see STTableFormat where it checks if row/column name arrays are nil
    _RowNames = rowNames == nil ? nil : [[NSMutableArray alloc]initWithArray: rowNames];//[[NSMutableArray alloc] init];
    _ColumnNames = columnNames == nil ? nil : [[NSMutableArray alloc]initWithArray: columnNames];//[[NSMutableArray alloc] init];

    _RowSize = rowSize;
    _ColumnSize = columnSize;
    _Data = [[NSMutableArray alloc] initWithArray:data];
  }
  return self;
}

/**
 @brief Determines if this table is empty - meaning it has no data, or does not have a column or row dimension specified.
 @returns true if empty, false otherwise
 */
-(BOOL)isEmpty {
  return (_Data == nil || [_Data count] == 0 || _RowSize == 0 || _ColumnSize == 0);
}

-(NSString*)ToString {
  //FIXME: the original code makes use of ToString in places, but it's not clear how the default implementation works
  return @"";
}
-(NSString*)description {
  return [self ToString];
}

@end
