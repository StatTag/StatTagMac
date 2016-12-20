//
//  StatTagModelTableTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"



@interface TestValueFormatter : STBaseValueFormatter
-(NSString*)GetMissingValue;
@end

@implementation TestValueFormatter
-(NSString*)GetMissingValue {
  return @"MISSING";
}
@end

@interface StatTagModelTableFormatTests : XCTestCase

@end

@implementation StatTagModelTableFormatTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

-(NSString*)FormatArrayForChecking:(STTableData*)data
{
  NSMutableArray<NSString*>* flatData = [[NSMutableArray<NSString*> alloc] init];

  NSInteger rows = [data numRows];
  NSInteger columns = [data numColumns];
  for (int row = 0; row < rows; row++)
  {
    for (int column = 0; column < columns; column++)
    {
      [flatData addObject:[data valueAtRow:row andColumn:column]];
    }
  }
  
  return [flatData componentsJoinedByString:@", "];
}


- (void)testFormat_Empty {
  STTableFormat* format = [[STTableFormat alloc] init];
  XCTAssertNotNil([format Format:nil]);
  XCTAssertEqual(0, [[format Format:nil] numItems]);
  XCTAssertNotNil([format Format:[[STTable alloc]init]]);
  XCTAssertEqual(0, [[format Format:[[STTable alloc]init]] numItems]);
}

//- (void)testFormat_DataOnly {
//  STTableFormat* format = [[STTableFormat alloc] init];
//  format.IncludeColumnNames = false;
//  format.IncludeRowNames = false;
//  
//  STTable* table = [[STTable alloc]
//                    init:[NSArray arrayWithObjects:@"Row1", @"Row2", nil] columnNames:[NSArray arrayWithObjects:@"Col1", @"Col2", nil] rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//  XCTAssertEqual(4, [[format Format:table] count]);
//  XCTAssert([@"0, 1, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);
//
//  table = [[STTable alloc]
//           init:nil columnNames:nil rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//  XCTAssertEqual(4, [[format Format:table] count]);
//  XCTAssert([@"0, 1, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);
//}
//
//- (void)testFormat_DataAndColumns {
//  
//  STTableFormat* format = [[STTableFormat alloc] init];
//  format.IncludeColumnNames = true;
//  format.IncludeRowNames = false;
//  
//  STTable* table = [[STTable alloc]
//                    init:[NSArray arrayWithObjects:@"Row1", @"Row2", nil] columnNames:[NSArray arrayWithObjects:@"Col1", @"Col2", nil] rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//
//  XCTAssertEqual(6, [[format Format:table] count]);
//  XCTAssert([@"Col1, Col2, 0, 1, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);
//
//  table = [[STTable alloc]
//           init:nil columnNames:nil rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//  XCTAssertEqual(4, [[format Format:table] count]);
//  XCTAssert([@"0, 1, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);
//}
//
//- (void)testFormat_DataAndRows {
//
//  STTableFormat* format = [[STTableFormat alloc] init];
//  format.IncludeColumnNames = false;
//  format.IncludeRowNames = true;
//  
//  STTable* table = [[STTable alloc]
//                    init:[NSArray arrayWithObjects:@"Row1", @"Row2", nil] columnNames:[NSArray arrayWithObjects:@"Col1", @"Col2", nil] rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//  
//  XCTAssertEqual(6, [[format Format:table] count]);
//  XCTAssert([@"Row1, 0, 1, Row2, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);
//  
//  table = [[STTable alloc]
//           init:nil columnNames:nil rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//  XCTAssertEqual(4, [[format Format:table] count]);
//  XCTAssert([@"0, 1, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);
//}

- (void)testFormat_DataColumnsAndRows {
  STTableFormat* format = [[STTableFormat alloc] init];
  format.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  format.ColumnFilter.Enabled = false;
  format.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  format.RowFilter.Enabled = false;
  
  STTable* table = [[STTable alloc] init:3 columnSize:3 data:[[STTableData alloc] initWithData:@[@[ @"", @"Col1", @"Col2" ], @[ @"Row1", @"0", @"1" ], @[ @"Row2", @"2", @"3" ] ]]];

  XCTAssertEqual(9, [[format Format:table] numItems]);
  XCTAssertEqual(@", Col1, Col2, Row1, 0, 1, Row2, 2, 3", [self FormatArrayForChecking:[format Format:table]]);
  

  
//  STTableFormat* format = [[STTableFormat alloc] init];
//  format.IncludeColumnNames = true;
//  format.IncludeRowNames = true;
//  
//  STTable* table = [[STTable alloc]
//                    init:[NSArray arrayWithObjects:@"Row1", @"Row2", nil] columnNames:[NSArray arrayWithObjects:@"Col1", @"Col2", nil] rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//
//  XCTAssertEqual(9, [[format Format:table] count]);
//  XCTAssert([@", Col1, Col2, Row1, 0, 1, Row2, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);
//  
//  table = [[STTable alloc]
//           init:nil columnNames:nil rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//  XCTAssertEqual(4, [[format Format:table] count]);
//  XCTAssert([@"0, 1, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);
}

- (void)testFormat_DataColumnsAndRowsWithMissingValues {

  STTableFormat* format = [[STTableFormat alloc] init];
  format.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  format.ColumnFilter.Enabled = false;
  format.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  format.RowFilter.Enabled = false;
  
  STTable* table = [[STTable alloc] init:3 columnSize:3 data:[[STTableData alloc] initWithData:@[@[ @"", @"Col1", @"Col2" ], @[ @"Row1", @"0", @"1" ], @[ @"Row2", [NSNull null], @"3" ] ]]];
  
  XCTAssertEqual(9, [[format Format:table] numItems]);
  XCTAssertEqual(@", Col1, Col2, Row1, 0, 1, Row2, MISSING, 3", [self FormatArrayForChecking:[format Format:table]]);

  
//  var format = new TableFormat()
//  {
//    ColumnFilter = new FilterFormat(Constants.FilterPrefix.Column) { Enabled = false },
//    RowFilter = new FilterFormat(Constants.FilterPrefix.Row) { Enabled = false }
//  };
//  var table = new Table(3, 3,
//                        new string[,] { { "", "Col1", "Col2" }, { "Row1", "0", "1" }, { "Row2", null, "3" } });
//  Assert.AreEqual(9, format.Format(table).Length);
//  Assert.AreEqual(", Col1, Col2, Row1, 0, 1, Row2, MISSING, 3", FormatArrayForChecking(format.Format(table, new TestValueFormatter())));

  
  
//  STTableFormat* format = [[STTableFormat alloc] init];
//  format.IncludeColumnNames = true;
//  format.IncludeRowNames = true;
//  
//  STTable* table = [[STTable alloc]
//                    init:[NSArray arrayWithObjects:@"Row1", @"Row2", nil] columnNames:[NSArray arrayWithObjects:@"Col1", @"Col2", nil] rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, [NSNull null], @3.0, nil]];
//
//  XCTAssertEqual(9, [[format Format:table] count]);
//  XCTAssert([@", Col1, Col2, Row1, 0, 1, Row2, MISSING, 3" isEqualToString:[[format Format:table valueFormatter:[[TestValueFormatter alloc] init]] componentsJoinedByString:@", "]]);
//  
//  table = [[STTable alloc]
//           init:nil columnNames:nil rowSize:2 columnSize:2 data:[NSArray arrayWithObjects:@0.0, @1.0, @2.0, @3.0, nil]];
//  XCTAssertEqual(4, [[format Format:table] count]);
//  XCTAssert([@"0, 1, 2, 3" isEqualToString:[[format Format:table] componentsJoinedByString:@", "]]);

  
}

@end



