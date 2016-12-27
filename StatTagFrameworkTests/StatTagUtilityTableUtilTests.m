//
//  StatTagUtilityTableUtilTests.m
//  StatTag
//
//  Created by Eric Whitley on 12/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"


@interface StatTagUtilityTableUtilTests : XCTestCase

@end

@implementation StatTagUtilityTableUtilTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}


-(void)testMergeTableVectorsToArray_NoData
{
  XCTAssertNil([STTableUtil MergeTableVectorsToArray:nil columnNames:nil data:nil totalRows:0 totalColumns:0]);
  XCTAssertNil([STTableUtil MergeTableVectorsToArray:@[@"Row1"] columnNames:@[@"Cow1"] data:nil totalRows:0 totalColumns:0]);
  STTableData* result = [STTableUtil MergeTableVectorsToArray:@[@"Row1"] columnNames:@[@"Cow1"] data:@[] totalRows:0 totalColumns:0];
  XCTAssertNotNil(result);
  XCTAssertEqual(0, [result numItems]);
}

-(void)testMergeTableVectorsToArray_ColumnAndRowNames
{

  NSArray<NSString*>* rowNames = @[@"Row1", @"Row2", @"Row3"];
  NSArray<NSString*>* colNames = @[@"Col1", @"Col2"];
  NSArray<NSString*>* data = @[@"0.0", @"1.0", @"2.0", @"3.0", @"4.0", @"5.0"];
  STTableData* result = [STTableUtil MergeTableVectorsToArray:rowNames columnNames:colNames data:data totalRows:4 totalColumns:3];

  XCTAssertEqual(4, [result numRows]);
  XCTAssertEqual(3, [result numColumns]);
  XCTAssert([@"" isEqualToString:[result valueAtRow:0 andColumn:0]]);
  XCTAssert([@"Col1" isEqualToString:[result valueAtRow:0 andColumn:1]]);
  XCTAssert([@"Col2" isEqualToString:[result valueAtRow:0 andColumn:2]]);
  XCTAssert([@"Row1" isEqualToString:[result valueAtRow:1 andColumn:0]]);
  XCTAssert([@"0.0" isEqualToString:[result valueAtRow:1 andColumn:1]]);
  XCTAssert([@"1.0" isEqualToString:[result valueAtRow:1 andColumn:2]]);
  XCTAssert([@"Row2" isEqualToString:[result valueAtRow:2 andColumn:0]]);
  XCTAssert([@"2.0" isEqualToString:[result valueAtRow:2 andColumn:1]]);
  XCTAssert([@"3.0" isEqualToString:[result valueAtRow:2 andColumn:2]]);
  XCTAssert([@"Row3" isEqualToString:[result valueAtRow:3 andColumn:0]]);
  XCTAssert([@"4.0" isEqualToString:[result valueAtRow:3 andColumn:1]]);
  XCTAssert([@"5.0" isEqualToString:[result valueAtRow:3 andColumn:2]]);
  
}

-(void)testMergeTableVectorsToArray_ColumnNamesOnly
{

  NSArray<NSString*>* rowNames = @[];
  NSArray<NSString*>* colNames = @[@"Col1", @"Col2"];
  NSArray<NSString*>* data = @[@"0.0", @"1.0", @"2.0", @"3.0", @"4.0", @"5.0"];
  STTableData* result = [STTableUtil MergeTableVectorsToArray:rowNames columnNames:colNames data:data totalRows:4 totalColumns:2];

  XCTAssertEqual(4, [result numRows]);
  XCTAssertEqual(2, [result numColumns]);
  
  XCTAssert([@"Col1" isEqualToString:[result valueAtRow:0 andColumn:0]]);
  XCTAssert([@"Col2" isEqualToString:[result valueAtRow:0 andColumn:1]]);
  XCTAssert([@"0.0" isEqualToString:[result valueAtRow:1 andColumn:0]]);
  XCTAssert([@"1.0" isEqualToString:[result valueAtRow:1 andColumn:1]]);
  XCTAssert([@"2.0" isEqualToString:[result valueAtRow:2 andColumn:0]]);
  XCTAssert([@"3.0" isEqualToString:[result valueAtRow:2 andColumn:1]]);
  XCTAssert([@"4.0" isEqualToString:[result valueAtRow:3 andColumn:0]]);
  XCTAssert([@"5.0" isEqualToString:[result valueAtRow:3 andColumn:1]]);

}

-(void)testMergeTableVectorsToArray_RowNamesOnly
{

  NSArray<NSString*>* rowNames = @[@"Row1", @"Row2", @"Row3"];
  NSArray<NSString*>* colNames = @[];
  NSArray<NSString*>* data = @[@"0.0", @"1.0", @"2.0", @"3.0", @"4.0", @"5.0"];
  STTableData* result = [STTableUtil MergeTableVectorsToArray:rowNames columnNames:colNames data:data totalRows:3 totalColumns:3];
  
  XCTAssertEqual(3, [result numRows]);
  XCTAssertEqual(3, [result numColumns]);

  XCTAssert([@"Row1" isEqualToString:[result valueAtRow:0 andColumn:0]]);
  XCTAssert([@"0.0" isEqualToString:[result valueAtRow:0 andColumn:1]]);
  XCTAssert([@"1.0" isEqualToString:[result valueAtRow:0 andColumn:2]]);
  XCTAssert([@"Row2" isEqualToString:[result valueAtRow:1 andColumn:0]]);
  XCTAssert([@"2.0" isEqualToString:[result valueAtRow:1 andColumn:1]]);
  XCTAssert([@"3.0" isEqualToString:[result valueAtRow:1 andColumn:2]]);
  XCTAssert([@"Row3" isEqualToString:[result valueAtRow:2 andColumn:0]]);
  XCTAssert([@"4.0" isEqualToString:[result valueAtRow:2 andColumn:1]]);
  XCTAssert([@"5.0" isEqualToString:[result valueAtRow:2 andColumn:2]]);
  
}

-(void)testMergeTableVectorsToArray_DataOnly
{
  NSArray<NSString*>* rowNames = @[];
  NSArray<NSString*>* colNames = @[];
  NSArray<NSString*>* data = @[@"0.0", @"1.0", @"2.0", @"3.0", @"4.0", @"5.0"];
  STTableData* result = [STTableUtil MergeTableVectorsToArray:rowNames columnNames:colNames data:data totalRows:2 totalColumns:3];
  
  XCTAssertEqual(2, [result numRows]);
  XCTAssertEqual(3, [result numColumns]);
  XCTAssert([@"0.0" isEqualToString:[result valueAtRow:0 andColumn:0]]);
  XCTAssert([@"1.0" isEqualToString:[result valueAtRow:0 andColumn:1]]);
  XCTAssert([@"2.0" isEqualToString:[result valueAtRow:0 andColumn:2]]);
  XCTAssert([@"3.0" isEqualToString:[result valueAtRow:1 andColumn:0]]);
  XCTAssert([@"4.0" isEqualToString:[result valueAtRow:1 andColumn:1]]);
  XCTAssert([@"5.0" isEqualToString:[result valueAtRow:1 andColumn:2]]);

  result = [STTableUtil MergeTableVectorsToArray:rowNames columnNames:colNames data:data totalRows:3 totalColumns:2];
  XCTAssertEqual(3, [result numRows]);
  XCTAssertEqual(2, [result numColumns]);
  XCTAssert([@"0.0" isEqualToString:[result valueAtRow:0 andColumn:0]]);
  XCTAssert([@"1.0" isEqualToString:[result valueAtRow:0 andColumn:1]]);
  XCTAssert([@"2.0" isEqualToString:[result valueAtRow:1 andColumn:0]]);
  XCTAssert([@"3.0" isEqualToString:[result valueAtRow:1 andColumn:1]]);
  XCTAssert([@"4.0" isEqualToString:[result valueAtRow:2 andColumn:0]]);
  XCTAssert([@"5.0" isEqualToString:[result valueAtRow:2 andColumn:1]]);

}

//-(void)testGetDisplayableVector_Empty
//{
////  var data = new[,] {{"", "Col1", "Col2"}, {"Row1", "0.0", "1.0"}};
//}

-(void)testFormat_DataOnly
{

  STTableFormat* format = [[STTableFormat alloc] init];
  STFilterFormat* columnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  columnFilter.Enabled = YES;
  columnFilter.Type = [STConstantsFilterType Exclude];
  columnFilter.Value = @"1";
  format.ColumnFilter = columnFilter;
  STFilterFormat* rowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  rowFilter.Enabled = YES;
  rowFilter.Type = [STConstantsFilterType Exclude];
  rowFilter.Value = @"1";
  format.RowFilter = rowFilter;
  
  STTableData* data = [[STTableData alloc] initWithData:@[@[ @"", @"Col1", @"Col2" ], @[ @"Row1", @"0", @"1" ], @[ @"Row2", @"2", @"3" ], @[ @"Row3", @"4", @"5" ]]];
  STTable* table = [[STTable alloc] init:4 columnSize:3 data:data];
  
  NSArray<NSString*>* result = [STTableUtil GetDisplayableVector:[table Data] format:format];
  XCTAssertEqual(6, [result count]);
  XCTAssert([@"0, 1, 2, 3, 4, 5" isEqualToString:[result componentsJoinedByString:@", "]]);
}

-(void)testFormat_DataAndRowNames
{

  STTableFormat* format = [[STTableFormat alloc] init];
  STFilterFormat* columnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  columnFilter.Enabled = NO;
  format.ColumnFilter = columnFilter;
  STFilterFormat* rowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  rowFilter.Enabled = YES;
  rowFilter.Type = [STConstantsFilterType Exclude];
  rowFilter.Value = @"1";
  format.RowFilter = rowFilter;

  STTableData* data = [[STTableData alloc] initWithData:@[@[ @"", @"Col1", @"Col2" ], @[ @"Row1", @"0", @"1" ], @[ @"Row2", @"2", @"3" ], @[ @"Row3", @"4", @"5" ]]];
  STTable* table = [[STTable alloc] init:4 columnSize:3 data:data];

  NSArray<NSString*>* result = [STTableUtil GetDisplayableVector:[table Data] format:format];
  XCTAssertEqual(9, [result count]);
  XCTAssert([@"Row1, 0, 1, Row2, 2, 3, Row3, 4, 5" isEqualToString:[result componentsJoinedByString:@", "]]);
  
}

-(void)testFormat_DataAndColumnNames
{

  STTableFormat* format = [[STTableFormat alloc] init];
  STFilterFormat* rowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  rowFilter.Enabled = NO;
  format.RowFilter = rowFilter;
  STFilterFormat* columnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  columnFilter.Enabled = YES;
  columnFilter.Type = [STConstantsFilterType Exclude];
  columnFilter.Value = @"1";
  format.ColumnFilter = columnFilter;
  
  STTableData* data = [[STTableData alloc] initWithData:@[@[ @"", @"Col1", @"Col2" ], @[ @"Row1", @"0", @"1" ], @[ @"Row2", @"2", @"3" ], @[ @"Row3", @"4", @"5" ]]];
  STTable* table = [[STTable alloc] init:4 columnSize:3 data:data];

  NSArray<NSString*>* result = [STTableUtil GetDisplayableVector:[table Data] format:format];
  XCTAssertEqual(8, [result count]);
  XCTAssert([@"Col1, Col2, 0, 1, 2, 3, 4, 5" isEqualToString:[result componentsJoinedByString:@", "]]);

}

-(void)testFormat_DataIncludeColumnAndRowNames
{

  STTableFormat* format = [[STTableFormat alloc] init];
  STFilterFormat* columnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  columnFilter.Enabled = NO;
  format.ColumnFilter = columnFilter;
  STFilterFormat* rowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  rowFilter.Enabled = NO;
  format.RowFilter = rowFilter;

  STTableData* data = [[STTableData alloc] initWithData:@[@[ @"", @"Col1", @"Col2" ], @[ @"Row1", @"0", @"1" ], @[ @"Row2", @"2", @"3" ], @[ @"Row3", @"4", @"5" ]]];
  STTable* table = [[STTable alloc] init:4 columnSize:3 data:data];

  NSArray<NSString*>* result = [STTableUtil GetDisplayableVector:[table Data] format:format];
  XCTAssertEqual(12, [result count]);
  XCTAssert([@", Col1, Col2, Row1, 0, 1, Row2, 2, 3, Row3, 4, 5" isEqualToString:[result componentsJoinedByString:@", "]]);

}

-(void)testFormat_EnabledFilterWithNoValue
{

  // Use this to detect for an error situation - the user has somehow specified that a filter should
  // be enabled, but the filter value is left empty.  We will try to guard against this in most
  // circumstances, but technically it could show up in execution.
  
  STTableFormat* format = [[STTableFormat alloc] init];
  STFilterFormat* columnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  columnFilter.Enabled = YES;
  columnFilter.Type = [STConstantsFilterType Exclude];
  columnFilter.Value = @"";
  format.ColumnFilter = columnFilter;
  STFilterFormat* rowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  rowFilter.Enabled = YES;
  rowFilter.Type = [STConstantsFilterType Exclude];
  rowFilter.Value = nil;
  format.RowFilter = rowFilter;

  
  STTableData* data = [[STTableData alloc] initWithData:@[@[ @"", @"Col1", @"Col2" ], @[ @"Row1", @"0", @"1" ], @[ @"Row2", @"2", @"3" ], @[ @"Row3", @"4", @"5" ]]];
  STTable* table = [[STTable alloc] init:4 columnSize:3 data:data];

  NSArray<NSString*>* result = [STTableUtil GetDisplayableVector:[table Data] format:format];
  XCTAssertEqual(12, [result count]);
  XCTAssert([@", Col1, Col2, Row1, 0, 1, Row2, 2, 3, Row3, 4, 5" isEqualToString:[result componentsJoinedByString:@", "]]);

}
@end
