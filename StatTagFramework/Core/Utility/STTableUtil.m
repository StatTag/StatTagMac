//
//  STTableUtil.m
//  StatTag
//
//  Created by Eric Whitley on 12/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTableUtil.h"
#import "STTableData.h"
#import "STTableFormat.h"
#import "STFilterFormat.h"

@implementation STTableUtil


/**
 Some statistical packages (Stata for sure, but there may be others) give us row names, column names and data as separate flat vectors.  This handles merging them into a 2D array with the data in the appropriate cells.
 
 @param rowNames : An array of row names.  If this is null or empty, no row names are added.
 @param columnNames : An array of the column names.  If this is null or empty, no column names are added.
 @param data : A vector containing the data for the array.  It is assumed this is laid out by row.
 @param totalRows : The total number of rows - this should be a combination of column names and data rows
 @param totalColumns : The total number of columns - this should be a combination of row names and data rows
 */
+(STTableData*)MergeTableVectorsToArray:(NSArray<NSString*>*)rowNames columnNames:(NSArray<NSString*>*)columnNames data:(NSArray<NSString*>*)data totalRows:(NSInteger)totalRows totalColumns:(NSInteger)totalColumns
{
  if (data == nil)
  {
    return nil;
  }
  
  if ([data count] == 0)
  {
    return [[STTableData alloc] init];
  }

  NSInteger currentRow = 0;
  STTableData* arrayData = [[STTableData alloc] initWithRows:totalRows andCols:totalColumns];
  BOOL hasRowNames = (rowNames != nil && [rowNames count] > 0);
  BOOL hasColumnNames = (columnNames != nil && [columnNames count] > 0);

  // If we have column names present, our first order of business is to fill in the
  // first row with all of those names.  We insert a blank cell if we have both row
  // names and column names.

  if (hasColumnNames)
  {
    NSInteger currentColumn = 0;
    if (hasRowNames)
    {
      [arrayData addValue:@"" atRow:currentRow andColumn:currentColumn];
      currentColumn++;
    }
    
    for (NSInteger index = 0; index < [columnNames count]; index++)
    {
      [arrayData addValue:columnNames[index] atRow:currentRow andColumn:currentColumn + index];
    }
    currentRow++;
  }

  // Go through all of the data next.  Insert row names when/if needed.
  NSInteger column = 0;
  NSInteger rowNameIndex = 0;
  for (NSInteger index = 0; index < [data count]; index++)
  {
    if (index != 0 && (column % totalColumns) == 0)
    {
      column = 0;
      currentRow++;
      rowNameIndex++;
    }
    
    // If we have a collection of row names to add, and we are at the data position
    // where we are starting a new row, insert the row name now.
    if (hasRowNames && (column % totalColumns) == 0)
    {
      [arrayData addValue:rowNames[rowNameIndex] atRow:currentRow andColumn:column];
      column++;
    }
    
    [arrayData addValue:data[index] atRow:currentRow andColumn:column];
    column++;
  }
  
  return arrayData;
}

/**
 Our data collections will include all cells - even if the user said they should be excluded.
 
 The purpose of this utility function is to take the 2D data array, remove the columns and rows that need to be excluded, and flatten it into a vector.
 
 The reason we flatten it is Word uses a vector of cells that we will fill, so this eases the mapping into that structure.
 */
+(NSArray<NSString*>*)GetDisplayableVector:(STTableData*)data format:(STTableFormat*)format
{
  NSArray<NSNumber*>* excludeColumnIndices = [[format ColumnFilter] ExpandValue];
  NSArray<NSNumber*>* excludeRowIndices = [[format RowFilter] ExpandValue];

  BOOL useColumnFilter = [[format ColumnFilter] Enabled] && excludeColumnIndices != nil && [excludeColumnIndices count] > 0;

  BOOL useRowFilter = [[format RowFilter] Enabled] && excludeRowIndices != nil && [excludeRowIndices count] > 0;

  NSMutableArray<NSString*>* dataVector = [[NSMutableArray<NSString*> alloc] init];
  for (NSInteger row = 0; row < [data numRows]; row++)
  {
    if(useRowFilter && [excludeRowIndices containsObject:[NSNumber numberWithInteger:row]])
    {
      continue;
    }
    
    for (NSInteger column = 0; column < [data numColumns]; column++)
    {
      if(useColumnFilter && [excludeColumnIndices containsObject:[NSNumber numberWithInteger:column]])
      {
        continue;
      }
      [dataVector addObject:[data valueAtRow:row andColumn:column]];
    }
  }
  
  return dataVector;
}


@end
