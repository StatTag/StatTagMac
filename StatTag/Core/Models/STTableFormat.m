//
//  STFigureFormat.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTableFormat.h"
#import "STTable.h"
#import "STIValueFormatter.h"
#import "STBaseValueFormatter.h"


@implementation STTableFormat

//This is going to start out assuming left to right filling.  In the future
//this will have different fill options.
-(NSArray<NSString*>*)Format:(STTable*)tableData valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter {
  
  //            valueFormatter = valueFormatter ?? new BaseValueFormatter();
  if(valueFormatter == nil) {
    STBaseValueFormatter *valueFormatter = [[STBaseValueFormatter alloc] init];
  }
  
  NSMutableArray<NSString*> *formattedResults = [[NSMutableArray<NSString*> alloc] init];
  
  if (tableData == nil || [tableData Data] == nil)
  {
    return formattedResults;
  }

  BOOL canIncludeColumnNames = (IncludeColumnNames && [tableData ColumnNames] != nil);

  if (canIncludeColumnNames)
  {
    [formattedResults addObjectsFromArray:[tableData ColumnNames]];
  }

  BOOL canIncludeRowNames = (IncludeRowNames && [tableData RowNames] != nil);
  for (int rowIndex = 0; rowIndex < [tableData RowSize]; rowIndex++)
  {
    if (canIncludeRowNames)
    {
      [formattedResults addObject:tableData.RowNames[rowIndex]];
    }
    for (int columnIndex = 0; columnIndex < tableData.ColumnSize; columnIndex++)
    {
      int index = (rowIndex * tableData.ColumnSize) + columnIndex;
      [formattedResults addObject:[NSString stringWithFormat:@"%@", tableData.Data[index]]];
    }
  }
  
  //formattedResults = formattedResults.Select(x => valueFormatter.Finalize(x)).ToList();
  for (NSString* fr __strong in formattedResults) {
    fr = [valueFormatter Finalize:fr];
  }

  // If we have rows and columns, we want to include a blank first value so
  // it fits nicely into an N x M table.
  // Note that we do NOT use the valueFormatter here.  We absolutely want this to
  // be blank, so we don't touch it.
  if (canIncludeColumnNames && canIncludeRowNames && [formattedResults count] > 0)
  {
    [formattedResults insertObject:@"" atIndex:0];
  }
  
  return formattedResults;  
}
-(NSArray<NSString*>*)Format:(STTable*)tableData {
  return [self Format:tableData valueFormatter:nil];
}



@end
