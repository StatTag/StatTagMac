//
//  StatTagModelDataFileToTableTests.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"
#import "CHCSVParser.h"

@interface StatTagModelDataFileToTableTests : XCTestCase {
  NSBundle *bundle;
  NSURL *sourceFileUrl;
  NSURL *destFileUrl;
}


@end

@implementation StatTagModelDataFileToTableTests


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
  NSArray<NSNumber*>* n = [STDataFileToTable GetCSVTableDimensionsForPath:sourceFileUrl];
  XCTAssertEqual(6, [[n objectAtIndex:0] integerValue]);
  XCTAssertEqual(7, [[n objectAtIndex:1] integerValue]);
}


- (void) testGetTableDimensions_NonExistant
{
  NSString *sourceFilePath = [bundle pathForResource:@"notarealfile.csv" ofType:@"csv"];
  NSArray<NSNumber*>* n = [STDataFileToTable GetCSVTableDimensions:sourceFilePath];
  XCTAssertNil(n);
}

//  +(STTable*)GetTableResultForPath:(NSURL*)tableFilePath

- (void) testGetTableDimensions_Empty
{
  NSString *sourceFilePath = [bundle pathForResource:@"empty" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  NSArray<NSNumber*>* n = [STDataFileToTable GetCSVTableDimensionsForPath:sourceFileUrl];
  XCTAssertEqual(0, [[n objectAtIndex:0] integerValue]);
  XCTAssertEqual(0, [[n objectAtIndex:1] integerValue]);
}

- (void) testGetTableDimensions_Unbalanced
{
  NSString *sourceFilePath = [bundle pathForResource:@"unbalanced" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  NSArray<NSNumber*>* n = [STDataFileToTable GetCSVTableDimensionsForPath:sourceFileUrl];
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
  NSArray<NSNumber*>* n = [STDataFileToTable GetCSVTableDimensionsForPath:sourceFileUrl];
  XCTAssertEqual(4, [[n objectAtIndex:0] integerValue]);
  XCTAssertEqual(3, [[n objectAtIndex:1] integerValue]);
  //ar folder = TestUtil.GetTestDataFolder("CSV");
  //ar dimensions = CSVToTable.GetTableDimensions(Path.Combine(folder, "balanced.csv"));
  //Assert.AreEqual(4, dimensions[0]);
  //Assert.AreEqual(3, dimensions[1]);
}

- (void) testGetTableResults_NonExistant
{
  NSString *sourceFilePath = [bundle pathForResource:@"notarealfile" ofType:@"csv"];
  //sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  STTable* table = [STDataFileToTable GetTableResult:sourceFilePath];
  XCTAssertEqual(0, [table RowSize]);
  XCTAssertEqual(0, [table ColumnSize]);
  //ar folder = TestUtil.GetTestDataFolder("CSV");
  //ar table = CSVToTable.GetTableResult(Path.Combine(folder, "notarealfile.csv"));
  //Assert.AreEqual(0, table.RowSize);
  //Assert.AreEqual(0, table.ColumnSize);
  //Assert.IsNull(table.Data);
}

- (void) testGetTableResults_CSV_Empty
{
  NSString *sourceFilePath = [bundle pathForResource:@"empty" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  STTable* table = [STDataFileToTable GetTableResultForPath:sourceFileUrl];
  XCTAssertEqual(0, [table RowSize]);
  XCTAssertEqual(0, [table ColumnSize]);
}

- (void) testGetTableResults_XLSX_Empty
{
  NSString *sourceFilePath = [bundle pathForResource:@"empty" ofType:@"xlsx"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  STTable* table = [STDataFileToTable GetTableResultForPath:sourceFileUrl];
  XCTAssertEqual(0, [table RowSize]);
  XCTAssertEqual(0, [table ColumnSize]);
}

- (void) testGetTableResults_CSV_Unbalanced
{
  NSString *sourceFilePath = [bundle pathForResource:@"unbalanced" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  
  
  STTable* table = [STDataFileToTable GetTableResultForPath:sourceFileUrl];

  XCTAssertEqual(10, [table RowSize]);
  XCTAssertEqual(5, [table ColumnSize]);
  XCTAssertEqual([table RowSize] * [table ColumnSize], [[table Data] numItems]);

  XCTAssert([@"" isEqualToString:[[table Data] valueAtRow:0 andColumn:0]]);
  XCTAssert([@"Frequency" isEqualToString:[[table Data] valueAtRow:0 andColumn:1]]);
  XCTAssert([@"" isEqualToString:[[table Data] valueAtRow:0 andColumn:2]]);
  XCTAssert([@"" isEqualToString:[[table Data] valueAtRow:0 andColumn:3]]);
  XCTAssert([@"" isEqualToString:[[table Data] valueAtRow:0 andColumn:4]]);
  XCTAssert([@"Table of role_name by Status" isEqualToString:[[table Data] valueAtRow:1 andColumn:0]]);
}

- (void) testGetTableResults_XLSX_Unbalanced
{
  NSString *sourceFilePath = [bundle pathForResource:@"unbalanced" ofType:@"xlsx"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];
  
  
  STTable* table = [STDataFileToTable GetTableResultForPath:sourceFileUrl];

  XCTAssertEqual(10, [table RowSize]);
  XCTAssertEqual(5, [table ColumnSize]);
  XCTAssertEqual([table RowSize] * [table ColumnSize], [[table Data] numItems]);

  XCTAssert([@"" isEqualToString:[[table Data] valueAtRow:0 andColumn:0]]);
  XCTAssert([@"Frequency" isEqualToString:[[table Data] valueAtRow:0 andColumn:1]]);
  XCTAssert([@"" isEqualToString:[[table Data] valueAtRow:0 andColumn:2]]);
  XCTAssert([@"" isEqualToString:[[table Data] valueAtRow:0 andColumn:3]]);
  XCTAssert([@"" isEqualToString:[[table Data] valueAtRow:0 andColumn:4]]);
  XCTAssert([@"Table of role_name by Status" isEqualToString:[[table Data] valueAtRow:1 andColumn:0]]);
}


- (void) testGetTableResults_CSV_Balanced
{
  NSString *sourceFilePath = [bundle pathForResource:@"balanced" ofType:@"csv"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];

  STTable* table = [STDataFileToTable GetTableResultForPath:sourceFileUrl];

  XCTAssertEqual(4, [table RowSize]);
  XCTAssertEqual(3, [table ColumnSize]);
  XCTAssertEqual([table RowSize] * [table ColumnSize], [[table Data] numItems]);
  XCTAssert([@"Status" isEqualToString:[[table Data] valueAtRow:0 andColumn:0]]);
  XCTAssert([@"11.54" isEqualToString:[[table Data] valueAtRow:3 andColumn:2]]);
}

- (void) testGetTableResults_XLSX_Balanced
{
  NSString *sourceFilePath = [bundle pathForResource:@"balanced" ofType:@"xlsx"];
  sourceFileUrl = [[NSURL alloc] initFileURLWithPath:sourceFilePath];

  STTable* table = [STDataFileToTable GetTableResultForPath:sourceFileUrl];

  XCTAssertEqual(4, [table RowSize]);
  XCTAssertEqual(3, [table ColumnSize]);
  XCTAssertEqual([table RowSize] * [table ColumnSize], [[table Data] numItems]);
  XCTAssert([@"Status" isEqualToString:[[table Data] valueAtRow:0 andColumn:0]]);
  XCTAssert([@"11.54" isEqualToString:[[table Data] valueAtRow:3 andColumn:2]]);
}


@end
