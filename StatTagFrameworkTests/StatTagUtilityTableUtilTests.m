//
//  StatTagUtilityTableUtilTests.m
//  StatTag
//
//  Created by Eric Whitley on 12/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>

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
  XCTAssertTrue(false);
//  Assert.IsNull(TableUtil.MergeTableVectorsToArray(null, null, null, 0, 0));
//  Assert.IsNull(TableUtil.MergeTableVectorsToArray(new[] { "Row1" }, new[] { "Col1" }, null, 0, 0));
//  
//  var result = TableUtil.MergeTableVectorsToArray(new[] { "Row1" }, new[] { "Col1" }, new string[] { }, 0, 0);
//  Assert.IsNotNull(result);
//  Assert.AreEqual(0, result.Length);
}

-(void)testMergeTableVectorsToArray_ColumnAndRowNames
{
  XCTAssertTrue(false);

//  var rowNames = new[] { "Row1", "Row2", "Row3" };
//  var colNames = new[] { "Col1", "Col2" };
//  var data = new[] { "0.0", "1.0", "2.0", "3.0", "4.0", "5.0" };
//  var result = TableUtil.MergeTableVectorsToArray(rowNames, colNames, data, 4, 3);
//  Assert.AreEqual(4, result.GetLength(0));
//  Assert.AreEqual(3, result.GetLength(1));
//  Assert.AreEqual("", result[0, 0]);
//  Assert.AreEqual("Col1", result[0, 1]);
//  Assert.AreEqual("Col2", result[0, 2]);
//  Assert.AreEqual("Row1", result[1, 0]);
//  Assert.AreEqual("0.0", result[1, 1]);
//  Assert.AreEqual("1.0", result[1, 2]);
//  Assert.AreEqual("Row2", result[2, 0]);
//  Assert.AreEqual("2.0", result[2, 1]);
//  Assert.AreEqual("3.0", result[2, 2]);
//  Assert.AreEqual("Row3", result[3, 0]);
//  Assert.AreEqual("4.0", result[3, 1]);
//  Assert.AreEqual("5.0", result[3, 2]);
}

-(void)testMergeTableVectorsToArray_ColumnNamesOnly
{
  XCTAssertTrue(false);

//  var rowNames = new string[] { };
//  var colNames = new[] { "Col1", "Col2" };
//  var data = new[] { "0.0", "1.0", "2.0", "3.0", "4.0", "5.0" };
//  var result = TableUtil.MergeTableVectorsToArray(rowNames, colNames, data, 4, 2);
//  Assert.AreEqual(4, result.GetLength(0));
//  Assert.AreEqual(2, result.GetLength(1));
//  Assert.AreEqual("Col1", result[0, 0]);
//  Assert.AreEqual("Col2", result[0, 1]);
//  Assert.AreEqual("0.0", result[1, 0]);
//  Assert.AreEqual("1.0", result[1, 1]);
//  Assert.AreEqual("2.0", result[2, 0]);
//  Assert.AreEqual("3.0", result[2, 1]);
//  Assert.AreEqual("4.0", result[3, 0]);
//  Assert.AreEqual("5.0", result[3, 1]);
}

-(void)testMergeTableVectorsToArray_RowNamesOnly
{
  XCTAssertTrue(false);

//  var rowNames = new[] { "Row1", "Row2", "Row3" };
//  var colNames = new string[] { };
//  var data = new[] { "0.0", "1.0", "2.0", "3.0", "4.0", "5.0" };
//  var result = TableUtil.MergeTableVectorsToArray(rowNames, colNames, data, 3, 3);
//  Assert.AreEqual(3, result.GetLength(0));
//  Assert.AreEqual(3, result.GetLength(1));
//  Assert.AreEqual("Row1", result[0, 0]);
//  Assert.AreEqual("0.0", result[0, 1]);
//  Assert.AreEqual("1.0", result[0, 2]);
//  Assert.AreEqual("Row2", result[1, 0]);
//  Assert.AreEqual("2.0", result[1, 1]);
//  Assert.AreEqual("3.0", result[1, 2]);
//  Assert.AreEqual("Row3", result[2, 0]);
//  Assert.AreEqual("4.0", result[2, 1]);
//  Assert.AreEqual("5.0", result[2, 2]);
}

-(void)testMergeTableVectorsToArray_DataOnly
{
  XCTAssertTrue(false);

//  var rowNames = new string[] { };
//  var colNames = new string[] { };
//  var data = new[] { "0.0", "1.0", "2.0", "3.0", "4.0", "5.0" };
//  var result = TableUtil.MergeTableVectorsToArray(rowNames, colNames, data, 2, 3);
//  Assert.AreEqual(2, result.GetLength(0));
//  Assert.AreEqual(3, result.GetLength(1));
//  Assert.AreEqual("0.0", result[0, 0]);
//  Assert.AreEqual("1.0", result[0, 1]);
//  Assert.AreEqual("2.0", result[0, 2]);
//  Assert.AreEqual("3.0", result[1, 0]);
//  Assert.AreEqual("4.0", result[1, 1]);
//  Assert.AreEqual("5.0", result[1, 2]);
//  
//  result = TableUtil.MergeTableVectorsToArray(rowNames, colNames, data, 3, 2);
//  Assert.AreEqual(3, result.GetLength(0));
//  Assert.AreEqual(2, result.GetLength(1));
//  Assert.AreEqual("0.0", result[0, 0]);
//  Assert.AreEqual("1.0", result[0, 1]);
//  Assert.AreEqual("2.0", result[1, 0]);
//  Assert.AreEqual("3.0", result[1, 1]);
//  Assert.AreEqual("4.0", result[2, 0]);
//  Assert.AreEqual("5.0", result[2, 1]);
}

-(void)testGetDisplayableVector_Empty
{
  XCTAssertTrue(false);

//  var data = new[,] {{"", "Col1", "Col2"}, {"Row1", "0.0", "1.0"}};
}

-(void)testFormat_DataOnly
{
  XCTAssertTrue(false);

//  var format = new TableFormat()
//  {
//    ColumnFilter = new FilterFormat(Constants.FilterPrefix.Column)
//    {
//      Enabled = true, Type = Constants.FilterType.Exclude, Value = "1"
//    },
//    RowFilter = new FilterFormat(Constants.FilterPrefix.Row)
//    {
//      Enabled = true,
//      Type = Constants.FilterType.Exclude,
//      Value = "1"
//    }
//  };
//  var table = new Table(4, 3,
//                        new string[,] { { "", "Col1", "Col2" }, { "Row1", "0", "1" }, { "Row2", "2", "3" }, { "Row3", "4", "5" } });
//  var result = TableUtil.GetDisplayableVector(table.Data, format);
//  Assert.AreEqual(6, result.Length);
//  Assert.AreEqual("0, 1, 2, 3, 4, 5", string.Join(", ", result));
}

-(void)testFormat_DataAndRowNames
{
  XCTAssertTrue(false);

//  var format = new TableFormat()
//  {
//    ColumnFilter = new FilterFormat(Constants.FilterPrefix.Column) { Enabled = false },
//    RowFilter = new FilterFormat(Constants.FilterPrefix.Row)
//    {
//      Enabled = true,
//      Type = Constants.FilterType.Exclude,
//      Value = "1"
//    }
//  };
//  var table = new Table(4, 3,
//                        new string[,] { { "", "Col1", "Col2" }, { "Row1", "0", "1" }, { "Row2", "2", "3" }, { "Row3", "4", "5" } });
//  var result = TableUtil.GetDisplayableVector(table.Data, format);
//  Assert.AreEqual(9, result.Length);
//  Assert.AreEqual("Row1, 0, 1, Row2, 2, 3, Row3, 4, 5", string.Join(", ", result));
}

-(void)testFormat_DataAndColumnNames
{
  XCTAssertTrue(false);

//  var format = new TableFormat()
//  {
//    RowFilter = new FilterFormat(Constants.FilterPrefix.Column) { Enabled = false },
//    ColumnFilter = new FilterFormat(Constants.FilterPrefix.Row)
//    {
//      Enabled = true,
//      Type = Constants.FilterType.Exclude,
//      Value = "1"
//    }
//  };
//  var table = new Table(4, 3,
//                        new string[,] { { "", "Col1", "Col2" }, { "Row1", "0", "1" }, { "Row2", "2", "3" }, { "Row3", "4", "5" } });
//  var result = TableUtil.GetDisplayableVector(table.Data, format);
//  Assert.AreEqual(8, result.Length);
//  Assert.AreEqual("Col1, Col2, 0, 1, 2, 3, 4, 5", string.Join(", ", result));
}

-(void)testFormat_DataIncludeColumnAndRowNames
{
  XCTAssertTrue(false);

//  var format = new TableFormat()
//  {
//    ColumnFilter = new FilterFormat(Constants.FilterPrefix.Column) { Enabled = false },
//    RowFilter = new FilterFormat(Constants.FilterPrefix.Row) { Enabled = false }
//  };
//  var table = new Table(4, 3,
//                        new string[,] { { "", "Col1", "Col2" }, { "Row1", "0", "1" }, { "Row2", "2", "3" }, { "Row3", "4", "5" } });
//  var result = TableUtil.GetDisplayableVector(table.Data, format);
//  Assert.AreEqual(12, result.Length);
//  Assert.AreEqual(", Col1, Col2, Row1, 0, 1, Row2, 2, 3, Row3, 4, 5", string.Join(", ", result));
}

-(void)testFormat_EnabledFilterWithNoValue
{
  XCTAssertTrue(false);

  // Use this to detect for an error situation - the user has somehow specified that a filter should
  // be enabled, but the filter value is left empty.  We will try to guard against this in most
  // circumstances, but technically it could show up in execution.
//  var format = new TableFormat()
//  {
//    ColumnFilter = new FilterFormat(Constants.FilterPrefix.Column) { Enabled = true, Type = "Exclude", Value = "" },
//    RowFilter = new FilterFormat(Constants.FilterPrefix.Row) { Enabled = true, Type = "Exclude", Value = null }
//  };
//  var table = new Table(4, 3,
//                        new string[,] { { "", "Col1", "Col2" }, { "Row1", "0", "1" }, { "Row2", "2", "3" }, { "Row3", "4", "5" } });
//  var result = TableUtil.GetDisplayableVector(table.Data, format);
//  Assert.AreEqual(12, result.Length);
//  Assert.AreEqual(", Col1, Col2, Row1, 0, 1, Row2, 2, 3, Row3, 4, 5", string.Join(", ", result));
}
@end
