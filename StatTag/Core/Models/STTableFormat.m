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

@synthesize IncludeColumnNames = _IncludeColumnNames;
@synthesize IncludeRowNames = _IncludeRowNames;


//MARK: copying

-(id)copyWithZone:(NSZone *)zone
{
  STTableFormat *format = [[STTableFormat alloc] init];
  
  format.IncludeColumnNames = _IncludeColumnNames;
  format.IncludeRowNames = _IncludeRowNames;
  
  return format;
}

//This is going to start out assuming left to right filling.  In the future
//this will have different fill options.
-(NSArray<NSString*>*)Format:(STTable*)tableData valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter {
  
  //            valueFormatter = valueFormatter ?? new BaseValueFormatter();
  
  if(valueFormatter == nil) {
    valueFormatter = [[STBaseValueFormatter alloc] init];
  }
  
  NSMutableArray<NSString*> *formattedResults = [[NSMutableArray<NSString*> alloc] init];
  
  if (tableData == nil || [tableData Data] == nil)
  {
    return formattedResults;
  }

  BOOL canIncludeColumnNames = (_IncludeColumnNames && [tableData ColumnNames] != nil && [[tableData ColumnNames] count] > 0);

  if (canIncludeColumnNames)
  {
    [formattedResults addObjectsFromArray:[tableData ColumnNames]];
//    NSLog(@"[tableData ColumnNames] = %@", [tableData ColumnNames]);
  }

  BOOL canIncludeRowNames = (_IncludeRowNames && [tableData RowNames] != nil && [[tableData RowNames] count] > 0);
//  NSLog(@"tableData.RowNames = %@", tableData.RowNames);
//  NSLog(@"tableData.RowSize = %d", tableData.RowSize);
  for (int rowIndex = 0; rowIndex < [tableData RowSize]; rowIndex++)
  {
    if (canIncludeRowNames)
    {
      [formattedResults addObject:[tableData RowNames][rowIndex]];
    }
    for (int columnIndex = 0; columnIndex < tableData.ColumnSize; columnIndex++)
    {
      int index = (rowIndex * tableData.ColumnSize) + columnIndex;
      //NSLog(@"about to add value : %@", [tableData Data][index]);
      //NOTE: we can send in [NSNull null] - if that happens, do an extra check and replace with empty string - otherwise, we get the string literal "<null>"
      //NSLog(@"value: %@, [[tableData Data][index] isEqual:[NSNull null]] = %hhd", [tableData Data][index], [[tableData Data][index] isEqual:[NSNull null]]);
      [formattedResults addObject:[NSString stringWithFormat:@"%@", ([[tableData Data][index] isEqual:[NSNull null]] ? @"" : [tableData Data][index])]];
    }
  }

  //NSLog(@"formattedResults : %@", formattedResults);

  //formattedResults = formattedResults.Select(x => valueFormatter.Finalize(x)).ToList();
  
  /*
   Leaving this in here for reference
   not exactly sure why we can't update the string object directly if it's a pointer to the item in the array
      for (NSString* fr __strong in formattedResults) {
        NSLog(@"fr: %@", fr);
        fr = [valueFormatter Finalize:fr];
        NSLog(@"fr (finalized): %@", fr);
      }  
   */
  for(int i = 0; i < [formattedResults count]; i++) {
    NSString* fr = [valueFormatter Finalize:[formattedResults objectAtIndex:i]];
    [formattedResults replaceObjectAtIndex:i withObject:fr];
  }

  //NSLog(@"formattedResults : %@", formattedResults);
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
