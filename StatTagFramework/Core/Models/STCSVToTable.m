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
  
  [NSException raise:@"NOT YET IMPLEMENTED - STCSVToTable GetTableResultForPath" format:@"NOT YET IMPLEMENTED - STCSVToTable GetTableResultForPath"];
  
  STTable* table = [[STTable alloc] init];

  if(tableFilePath != nil)
  {
    NSError* err;
    if(![STFileHandler Exists:tableFilePath error:&err])
    {
      return table;
    }

    NSArray<NSNumber*>* dimensions = [STCSVToTable GetTableDimensionsForPath:tableFilePath];
    
    //FIXME: this is a mess
    if(dimensions == nil || [dimensions indexOfObject: [NSNumber numberWithInteger:0] inSortedRange:NSMakeRange(0, dimensions.count) options:NSBinarySearchingFirstEqual | NSBinarySearchingInsertionIndex
                                 usingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
                                   return [obj1 compare:obj2];
                                 }] != nil)
    {
      return table;
    }

    
    NSArray* csv_data = [NSArray arrayWithContentsOfDelimitedURL:tableFilePath options:CHCSVParserOptionsSanitizesFields delimiter:','];
    
    if(csv_data != nil)
    {
      NSInteger row = 0;
      NSMutableArray<NSMutableArray<NSString*>*>* data = [[NSMutableArray<NSMutableArray<NSString*>*> alloc] init];
      
//      NSMutableArray<NSString*>* data = [[NSMutableArray<NSString*> alloc] initWithObjects:[NSString stringWithFormat:@"%@", [dimensions objectAtIndex:0]], [NSString stringWithFormat:@"%@", [dimensions objectAtIndex:1]], nil];

      for(NSArray<NSArray*>* a in csv_data)
      {
        NSInteger column = 0;

        for(NSInteger index = 0; index < [a count]; index++)
        {
          //          data[row, index] = fields[index];
          //  return [[data objectAtIndex:(index / columns)] objectAtIndex:(index % columns)];

          
        }
        //        for (int index = 0; index < fields.Length; index++)
        //        {
        //        }
        //
        //      int fieldsLength = (fields == null ? 0 : fields.Length);
        //      // If this is an unbalanced row, balance it with empty strings
        //      if (fieldsLength < dimensions[1])
        //      {
        //        for (int index = fieldsLength; index < dimensions[1]; index++)
        //        {
        //          data[row, index] = string.Empty;
        //        }
        //      }
        //
        //      row++;

      }
      
//      [table setRowSize:[[dimensions objectAtIndex:0] integerValue]];
//      [table setColumnSize:[[dimensions objectAtIndex:1] integerValue]];
//      [table setData:outer];
    }


  }
  return table;
}



@end
