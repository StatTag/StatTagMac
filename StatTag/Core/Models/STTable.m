//
//  STTable.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTable.h"

@implementation STTable

@synthesize RowNames = RowNames;
@synthesize ColumnNames = ColumnNames;
@synthesize RowSize = RowSize;
@synthesize ColumnSize = ColumnSize;
@synthesize Data = Data; //type is double
@synthesize FormattedCells = FormattedCells;

-(id)init {
  self = [super init];
  if(self) {
    RowNames = [[NSMutableArray alloc] init];
    ColumnNames = [[NSMutableArray alloc] init];
  }
  return self;
}

-(id)init:(NSArray <NSString *>*)rowNames columnNames:(NSArray <NSString *>*)columnNames rowSize:(int)rowSize columnSize:(int)columnSize data:(NSArray <NSNumber *>*)data {
  self = [super init];
  if(self) {
    RowNames = rowNames != nil ? [[NSMutableArray alloc]initWithArray: rowNames] : [[NSMutableArray alloc] init];
    ColumnNames = ColumnNames != nil ? [[NSMutableArray alloc]initWithArray: columnNames] : [[NSMutableArray alloc] init];
    RowSize = rowSize;
    ColumnSize = columnSize;
    Data = [[NSMutableArray alloc] initWithArray:data];
  }
  return self;
}

/**
 @brief Determines if this table is empty - meaning it has no data, or does not have a column or row dimension specified.
 @returns true if empty, false otherwise
 */
-(BOOL)isEmpty {
  return (Data == nil || [Data count] == 0 || RowSize == 0 || ColumnSize == 0);
}

-(NSString*)ToString {
  //FIXME: the original code makes use of ToString in places, but it's not clear how the default implementation works
  return @"";
}
-(NSString*)description {
  return [self ToString];
}

@end
