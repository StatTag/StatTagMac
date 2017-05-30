//
//  STCSVToTable.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCSVToTable.h"
#import "STTable.h"
#import "CHCSVParser.h"
#import "STFileHandler.h"
#import "STTableData.h"

@implementation STCSVToTable


/**
 returns: An array containing the dimensions (R x C), or NULL if it could not determine the table size.
 */
+(NSArray<NSNumber*>*)GetTableDimensions:(NSString*)tableFilePath
{
  if(tableFilePath != nil){
    NSURL* p = [NSURL fileURLWithPath:tableFilePath];
    return [STCSVToTable GetTableDimensionsForPath:p];
  }
  return nil;
}

/**
 returns: An array containing the dimensions (R x C), or NULL if it could not determine the table size.
 */
//public static int[] GetTableDimensions(string tableFilePath)
+(NSArray<NSNumber*>*)GetTableDimensionsForPath:(NSURL*)tableFilePath
{
  
  NSError* err;
  if(![STFileHandler Exists:tableFilePath error:&err])
  {
    return nil;
  }

  NSInteger rows = 0;
  NSInteger columns = 0;

  //NSString* csvString = [STFileHandler ReadAllLinesAsStringBlock:tableFilePath error:&err];

  //CHCSVParserOptionsSanitizesFields -> per docs, sets "quoted" (and a lot more, so be careful)
  NSArray* csv_data = [NSArray arrayWithContentsOfDelimitedURL:tableFilePath options:CHCSVParserOptionsSanitizesFields delimiter:','];

  if(csv_data != nil)
  {

    for(NSArray<NSArray*>* a in csv_data)
    {
      rows++;
      columns = MAX(columns, [a count]);
    }

    return [[NSArray<NSNumber*> alloc] initWithObjects:[NSNumber numberWithInteger:rows], [NSNumber numberWithInteger:columns], nil];
  }
  
  return nil;
}

/**
 Combines the different components of a matrix command into a single structure.
 */
+(STTable*)GetTableResult:(NSString*)tableFilePath
{
  if(tableFilePath != nil){
    NSURL* p = [NSURL fileURLWithPath:tableFilePath];
    return [STCSVToTable GetTableResultForPath:p];
  }
  return nil;
}

/**
 Combines the different components of a matrix command into a single structure.
 */
+(STTable*)GetTableResultForPath:(NSURL*)tableFilePath
{
  
  //[NSException raise:@"NOT YET IMPLEMENTED - STCSVToTable GetTableResultForPath" format:@"NOT YET IMPLEMENTED - STCSVToTable GetTableResultForPath"];
  
  STTable* table = [[STTable alloc] init];

  if(tableFilePath != nil)
  {
    NSError* err;
    if(![STFileHandler Exists:tableFilePath error:&err])
    {
      return table;
    }

    NSArray<NSNumber*>* dimensions = [STCSVToTable GetTableDimensionsForPath:tableFilePath];
    
    if(dimensions == nil || [dimensions containsObject:@0] || [dimensions count] < 2)
    {
      return table;
    }

    
    NSArray* csv_data = [NSArray arrayWithContentsOfDelimitedURL:tableFilePath options:CHCSVParserOptionsSanitizesFields delimiter:','];
    
    if(csv_data != nil)
    {
      NSInteger row = 0;
      STTableData* data = [[STTableData alloc] initWithRows:[[dimensions objectAtIndex:0] integerValue] andCols:[[dimensions objectAtIndex:1] integerValue]];
      
      for(NSArray<NSString*>* rows in csv_data)
      {
        //row array
        
        NSInteger column = 0;
        for(NSString* columns in rows)
        {
          //column array (in row "rows")
          [data addValue:columns atRow:row andColumn:column];
          column = column + 1;
        }
        row = row + 1;
      }
      
      //move the C# "balance data" approach into the STTableData class - "balanceData" selector

      [table setRowSize:[[dimensions objectAtIndex:0] integerValue]];
      [table setColumnSize:[[dimensions objectAtIndex:1] integerValue]];
      [table setData:data];
      [[table Data] balanceData]; //balance the data
    }


  }
  return table;
}



@end
