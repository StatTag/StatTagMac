//
//  STCSVToTable.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STDataFileToTable.h"
#import "STTable.h"
#import "CHCSVParser.h"
#import "STFileHandler.h"
#import "STTableData.h"
#import "BRAOfficeDocumentPackage.h"

@implementation STDataFileToTable


/**
 returns: An array containing the dimensions (R x C), or NULL if it could not determine the table size.
 */
+(NSArray<NSNumber*>*)GetCSVTableDimensions:(NSString*)tableFilePath
{
  if(tableFilePath != nil){
    NSURL* p = [NSURL fileURLWithPath:tableFilePath];
    return [STDataFileToTable GetCSVTableDimensionsForPath:p];
  }
  return nil;
}

/**
 returns: An array containing the dimensions (R x C), or NULL if it could not determine the table size.
 */
//public static int[] GetTableDimensions(string tableFilePath)
+(NSArray<NSNumber*>*)GetCSVTableDimensionsForPath:(NSURL*)tableFilePath
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
    return [STDataFileToTable GetTableResultForPath:p];
  }
  return nil;
}

/**
 Combines the different components of a matrix command into a single structure.
 */
+(STTable*)GetTableResultForPath:(NSURL*)tableFilePath
{
  if ([[tableFilePath pathExtension] isEqualToString:@"xlsx"]) {
    return [STDataFileToTable GetXLSXTableResultForPath:tableFilePath];
  }
  else if ([[tableFilePath pathExtension] isEqualToString:@"xls"]) {
    NSException* exc = [NSException
        exceptionWithName:@"FileNotSupportedException"
        reason:@"StatTag is unable to import data from older Excel files (those ending in .XLS).  If possible, please use the newer .XLSX format, or use a .CSV"
        userInfo:nil];
    @throw exc;
  }
  else {
    return [STDataFileToTable GetCSVTableResultForPath:tableFilePath];
  }
}

+(NSString*)CellReferenceFromPositions:(long)row column:(long)column
{
  long dividend = column + 1;
  long modulo;
  NSMutableString* columnName = [[NSMutableString alloc] init];
  while (dividend > 0) {
    modulo = (dividend - 1) % 26;
    [columnName appendString:[NSString stringWithFormat:@"%c", (int)(65 + modulo)]];
    dividend = (int)((dividend - modulo) / 26);
  }

  return [NSString stringWithFormat:@"%@%ld", columnName, (row + 1)];
}


+(STTable*)GetXLSXTableResultForPath:(NSURL*)tableFilePath
{
  STTable* table = [[STTable alloc] init];
  if ([[NSFileManager defaultManager] fileExistsAtPath:[tableFilePath absoluteString]]) {
    return table;
  }
  BRAOfficeDocumentPackage* spreadsheet = [BRAOfficeDocumentPackage open:[tableFilePath path]];
  if (spreadsheet == nil || spreadsheet.workbook == nil || spreadsheet.workbook.worksheets == nil || [spreadsheet.workbook.worksheets count] == 0) {
    return table;
  }

  // Right now, we will only use the first sheet in a workbook
  BRAWorksheet* sheet = spreadsheet.workbook.worksheets[0];

  // If any of the necessary objects (sheet, cells, etc.) are null, we will assume the data in
  // the workbook is empty, and we can just return a blank table structre.
  if (sheet == nil || sheet.cells == nil || [sheet.cells count] == 0) {
    return table;
  }

  // Dimensions will give you top/bottom and left/right indices
  BRACellRange* dimensions = sheet.dimension;
  long columnCount = dimensions.rightColumnIndex - dimensions.leffColumnIndex + 1;
  long rowCount = dimensions.bottomRowIndex - dimensions.topRowIndex + 1;

  STTableData* data = [[STTableData alloc] initWithRows:rowCount andCols:columnCount];
  for (long row = 0; row < rowCount; row++) {
    for (long column = 0; column < columnCount; column++) {
      NSString* ref = [STDataFileToTable CellReferenceFromPositions:row column:column];
      BRACell* cell = [sheet cellForCellReference:ref shouldCreate:FALSE];
      if (cell != nil) {
        [data addValue:[cell stringValue] atRow:row andColumn:column];
      }
      else {
        [data addValue:@"" atRow:row andColumn:column];
      }
    }
  }

  [table setRowSize:rowCount];
  [table setColumnSize:columnCount];
  [table setData:data];
  [[table Data] balanceData]; //balance the data
  
  return table;
}


/**
 Combines the different components of a matrix command into a single structure.
 */
+(STTable*)GetCSVTableResultForPath:(NSURL*)tableFilePath
{
  STTable* table = [[STTable alloc] init];

  if(tableFilePath != nil)
  {
    NSError* err;
    if(![STFileHandler Exists:tableFilePath error:&err])
    {
      return table;
    }

    NSArray<NSNumber*>* dimensions = [STDataFileToTable GetCSVTableDimensionsForPath:tableFilePath];
    
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
