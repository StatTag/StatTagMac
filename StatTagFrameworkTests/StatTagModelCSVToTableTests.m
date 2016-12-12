//
//  StatTagModelCSVToTableTests.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"
#import "CHCSVParser.h"

@interface StatTagModelCSVToTableTests : XCTestCase {
  NSBundle *bundle;
  NSURL *sourceFileUrl;
  NSURL *destFileUrl;
}


@end

@implementation StatTagModelCSVToTableTests


- (void)setUp {
  [super setUp];
  bundle = [NSBundle bundleForClass:[self class]];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testOpeningCSVFile {
  NSString *sourceFilePath = [bundle pathForResource:@"testArrayFile" ofType:@"txt"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];

  NSArray* a = [NSArray arrayWithContentsOfDelimitedURL:sourceFileUrl options:CHCSVParserOptionsSanitizesFields delimiter:','];
  
  XCTAssertNotNil(a);
}

- (void)testBasicCSVFileRowsAndCols {
  NSString *sourceFilePath = [bundle pathForResource:@"testArrayFile" ofType:@"txt"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  NSArray<NSNumber*>* n = [STCSVToTable GetTableDimensionsForPath:sourceFileUrl];
  XCTAssertEqual(6, [[n objectAtIndex:0] integerValue]);
  XCTAssertEqual(7, [[n objectAtIndex:1] integerValue]);
}


- (void) testGetTableDimensions_NonExistant
{
  NSString *sourceFilePath = [bundle pathForResource:@"notarealfile.csv" ofType:@"csv"];
  NSArray<NSNumber*>* n = [STCSVToTable GetTableDimensions:sourceFilePath];
  XCTAssertNil(n);
}

//  +(STTable*)GetTableResultForPath:(NSURL*)tableFilePath

- (void) testGetTableDimensions_Empty
{
  NSString *sourceFilePath = [bundle pathForResource:@"empty" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  NSArray<NSNumber*>* n = [STCSVToTable GetTableDimensionsForPath:sourceFileUrl];
  XCTAssertEqual(0, [[n objectAtIndex:0] integerValue]);
  XCTAssertEqual(0, [[n objectAtIndex:1] integerValue]);
}

- (void) testGetTableDimensions_Unbalanced
{
  NSString *sourceFilePath = [bundle pathForResource:@"unbalanced" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  NSArray<NSNumber*>* n = [STCSVToTable GetTableDimensionsForPath:sourceFileUrl];
  XCTAssertEqual(10, [[n objectAtIndex:0] integerValue]);
  XCTAssertEqual(5, [[n objectAtIndex:1] integerValue]);
  //ar folder = TestUtil.GetTestDataFolder("CSV");
  //ar dimensions = CSVToTable.GetTableDimensions(Path.Combine(folder, "unbalanced.csv"));
  //Assert.AreEqual(10, dimensions[0]);
  //Assert.AreEqual(5, dimensions[1]);
}

- (void) testGetTableDimensions_Balanced
{
  NSString *sourceFilePath = [bundle pathForResource:@"balanced" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  NSArray<NSNumber*>* n = [STCSVToTable GetTableDimensionsForPath:sourceFileUrl];
  XCTAssertEqual(4, [[n objectAtIndex:0] integerValue]);
  XCTAssertEqual(4, [[n objectAtIndex:1] integerValue]);
  //ar folder = TestUtil.GetTestDataFolder("CSV");
  //ar dimensions = CSVToTable.GetTableDimensions(Path.Combine(folder, "balanced.csv"));
  //Assert.AreEqual(4, dimensions[0]);
  //Assert.AreEqual(3, dimensions[1]);
}

- (void) testGetTableResults_NonExistant
{
  NSString *sourceFilePath = [bundle pathForResource:@"notarealfile" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  STTable* table = [STCSVToTable GetTableResultForPath:sourceFileUrl];
  XCTAssertEqual(0, [table RowSize]);
  XCTAssertEqual(0, [table ColumnSize]);
  //ar folder = TestUtil.GetTestDataFolder("CSV");
  //ar table = CSVToTable.GetTableResult(Path.Combine(folder, "notarealfile.csv"));
  //Assert.AreEqual(0, table.RowSize);
  //Assert.AreEqual(0, table.ColumnSize);
  //Assert.IsNull(table.Data);
}

- (void) testGetTableResultss_Empty
{
  NSString *sourceFilePath = [bundle pathForResource:@"empty" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  STTable* table = [STCSVToTable GetTableResultForPath:sourceFileUrl];
  XCTAssertEqual(0, [table RowSize]);
  XCTAssertEqual(0, [table ColumnSize]);
  //ar folder = TestUtil.GetTestDataFolder("CSV");
  //ar table = CSVToTable.GetTableResult(Path.Combine(folder, "empty.csv"));
  //Assert.AreEqual(0, table.RowSize);
  //Assert.AreEqual(0, table.ColumnSize);
  //Assert.IsNull(table.Data);
}

- (void) testGetTableResults_Unbalanced
{
  NSString *sourceFilePath = [bundle pathForResource:@"unbalanced" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  STTable* table = [STCSVToTable GetTableResultForPath:sourceFileUrl];

  XCTAssertEqual(10, [table RowSize]);
  XCTAssertEqual(5, [table ColumnSize]);
  XCTAssertEqual([table RowSize] * [table ColumnSize], [[table Data] count]);

  //ar folder = TestUtil.GetTestDataFolder("CSV");
  //ar table = CSVToTable.GetTableResult(Path.Combine(folder, "unbalanced.csv"));

  //Assert.AreEqual(10, table.RowSize);
  //Assert.AreEqual(5, table.ColumnSize);
  //Assert.AreEqual((table.RowSize * table.ColumnSize), table.Data.Length);
  //Assert.AreEqual(string.Empty, table.Data[0,0]);
  //Assert.AreEqual("Frequency", table.Data[0,1]);
  //Assert.AreEqual(string.Empty, table.Data[0,2]);
  //Assert.AreEqual(string.Empty, table.Data[0,3]);
  //Assert.AreEqual(string.Empty, table.Data[0,4]);
  //Assert.AreEqual("Table of role_name by Status", table.Data[1,0]);
}

- (void) testGetTableResults_Balanced
{
  //ar folder = TestUtil.GetTestDataFolder("CSV");
  //ar table = CSVToTable.GetTableResult(Path.Combine(folder, "balanced.csv"));
  //Assert.AreEqual(4, table.RowSize);
  //Assert.AreEqual(3, table.ColumnSize);
  //Assert.AreEqual((table.RowSize * table.ColumnSize), table.Data.Length);
  //Assert.AreEqual("Status", table.Data[0,0]);
  //Assert.AreEqual("11.54", table.Data[3,2]);
}


@end
