//
//  StatTagModelTagTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/27/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagModelTagTests : XCTestCase

@end

@implementation StatTagModelTagTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCopyCtor_Normal {
  XCTAssertFalse(true);
}

- (void)testCopyCtor_Null {
  XCTAssertFalse(true);
}

- (void)testEquals_Match {
  XCTAssertFalse(true);
}

- (void)testEquals_NoMatch {
  XCTAssertFalse(true);
}

- (void)testEqualsWithPosition {
  XCTAssertFalse(true);
}

- (void)testFormattedResult_Empty {
  STTag* tag = [[STTag alloc] init];
  XCTAssert([[STConstantsPlaceholders EmptyField] isEqualToString:[tag FormattedResult]]);

  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  tag.CachedResult = [[NSMutableArray<STCommandResult*> alloc] init];
  XCTAssert([[STConstantsPlaceholders EmptyField] isEqualToString:[tag FormattedResult]]);
}

- (void)testFormattedResult_Values {
  
  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test 1";
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  XCTAssert([@"Test 1" isEqualToString:[tag FormattedResult]]);
  
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  STCommandResult* cr1 = [[STCommandResult alloc] init];
  cr1.ValueResult = @"Test 1";
  STCommandResult* cr2 = [[STCommandResult alloc] init];
  cr2.ValueResult = @"Test 2";
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr1, cr2, nil];
  XCTAssert([@"Test 2" isEqualToString:[tag FormattedResult]]);

  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  cr1 = [[STCommandResult alloc] init];
  cr1.ValueResult = @"1234";
  cr2 = [[STCommandResult alloc] init];
  cr2.ValueResult = @"456789";
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr1, cr2, nil];
  tag.Type = [STConstantsTagType Value];
  STValueFormat* vf = [[STValueFormat alloc] init];
  vf.FormatType = [STConstantsValueFormatType Numeric];
  vf.UseThousands = true;
  tag.ValueFormat = vf;
  NSLog(@"[tag FormattedResult] : %@", [tag FormattedResult]);
  XCTAssert([@"456,789" isEqualToString:[tag FormattedResult]]);
}

- (void)testFormattedResult_ValuesBlank {
  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"";
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  XCTAssert([[STConstantsPlaceholders EmptyField] isEqualToString:[tag FormattedResult]]);
  
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  STCommandResult* cr1 = [[STCommandResult alloc] init];
  cr1.ValueResult = @"    ";
  STCommandResult* cr2 = [[STCommandResult alloc] init];
  cr2.ValueResult = @"         ";
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr1, cr2, nil];
  XCTAssert([[STConstantsPlaceholders EmptyField] isEqualToString:[tag FormattedResult]]);
}

- (void)testToString_Tests {
  STTag* tag = [[STTag alloc] init];
  XCTAssert([@"STTag" isEqualToString:[tag ToString]]);

  tag.Type = [STConstantsTagType Figure];
  XCTAssert([@"Figure" isEqualToString:[tag ToString]]);

  tag.Name = @"Test";
  XCTAssert([@"Test" isEqualToString:[tag ToString]]);
}

- (void)testSerialize_Deserialize {

  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test 1";
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  
  NSString* serialized = [tag Serialize:nil];
  STTag* recreatedTag = [STTag Deserialize:serialized error:nil];
  
  //  Assert.AreEqual(tag.CodeFile, recreatedTag.CodeFile);
  XCTAssertNil([tag CodeFile]);
  XCTAssertNil([recreatedTag CodeFile]);

//  Assert.AreEqual(tag.FigureFormat, recreatedTag.FigureFormat);
  XCTAssertNil([tag FigureFormat]);
  XCTAssertNil([recreatedTag FigureFormat]);

  XCTAssert([[tag FormattedResult] isEqualToString:[recreatedTag FormattedResult]]);

  XCTAssertEqual([[tag LineEnd] integerValue], [[recreatedTag LineEnd] integerValue]);
  XCTAssertEqual([[tag LineStart] integerValue], [[recreatedTag LineStart] integerValue]);

  XCTAssert([[tag Name] isEqualToString:[recreatedTag Name]]);
  XCTAssertNil([tag RunFrequency]);
  XCTAssertNil([recreatedTag RunFrequency]);
  
  //XCTAssert([[tag RunFrequency] isEqualToString:[recreatedTag RunFrequency]]);

  XCTAssert([[tag Type] isEqualToString:[recreatedTag Type]]);

//  Assert.AreEqual(tag.ValueFormat, recreatedTag.ValueFormat);
  XCTAssertNil([tag ValueFormat]);
  XCTAssertNil([recreatedTag ValueFormat]);

//  Assert.AreEqual(tag.FigureFormat, recreatedTag.FigureFormat);
  XCTAssertNil([tag FigureFormat]);
  XCTAssertNil([recreatedTag FigureFormat]);

//  Assert.AreEqual(tag.TableFormat, recreatedTag.TableFormat);
  XCTAssertNil([tag TableFormat]);
  XCTAssertNil([recreatedTag TableFormat]);


}

- (void)testNormalizeName_Blanks {
  XCTAssertTrue([@"" isEqualToString:[STTag NormalizeName: nil]]);
  XCTAssertTrue([@"" isEqualToString:[STTag NormalizeName: @""]]);
  XCTAssertTrue([@"" isEqualToString:[STTag NormalizeName: @"   "]]);
}

- (void)testNormalizeName_Values {
  XCTAssertTrue([@"Test" isEqualToString:[STTag NormalizeName: @"Test"]]);
  XCTAssertTrue([@"Test" isEqualToString:[STTag NormalizeName: @"|Test"]]);
  XCTAssertTrue([@"Test" isEqualToString:[STTag NormalizeName: @"   |   Test"]]);
  XCTAssertTrue([@"Test" isEqualToString:[STTag NormalizeName: @"Test|"]]);
  XCTAssertTrue([@"Test" isEqualToString:[STTag NormalizeName: @"Test |   "]]);
  XCTAssertTrue([@"Test one" isEqualToString:[STTag NormalizeName: @"Test|one"]]);
}

- (void)testIsTableTag {
  STTag* tag = [[STTag alloc] init];

  tag.Type = [STConstantsTagType Table];
  XCTAssertTrue([tag IsTableTag]);

  tag.Type = [STConstantsTagType Value];
  XCTAssertFalse([tag IsTableTag]);

  tag.Type = @"";
  XCTAssertFalse([tag IsTableTag]);
}

- (void)testHasTableData {

  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  tag.CachedResult = nil;
  XCTAssertFalse([tag HasTableData]);

  // Non-null, but empty, result cache
  tag.CachedResult = [[NSMutableArray<STCommandResult*> alloc] init];
  XCTAssertFalse([tag HasTableData]);
  
  // Non-table data
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test 1";
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  XCTAssertFalse([tag HasTableData]);

  // Actual data
  STTableFormat* format = [[STTableFormat alloc] init];
  format.IncludeColumnNames = false;
  format.IncludeRowNames = false;
  STTable* table = [[STTable alloc] init:@[@"Row1", @"Row2"] columnNames:@[@"Col1", @"Col2"] rowSize:2 columnSize:1 data:@[@0.0, @1.0, @2.0, @3.0]];
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  cr = [[STCommandResult alloc] init];
  cr.TableResult = table;
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  XCTAssert([tag HasTableData]);
}

- (void)testGetTableDisplayDimensions {

  
  // Non-table tag
  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test1";
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  XCTAssertNil([tag GetTableDisplayDimensions]);
  
  // No table format information
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  cr = [[STCommandResult alloc] init];
  cr.TableResult = nil;
  XCTAssertNil([tag GetTableDisplayDimensions]);

  // No table data
  STTableFormat* format = [[STTableFormat alloc] init];
  format.IncludeColumnNames = false;
  format.IncludeRowNames = false;
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  tag.TableFormat = format;
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  XCTAssertNil([tag GetTableDisplayDimensions]);

  // Actual data
  STTable* table = [[STTable alloc] init:@[@"Row1", @"Row2"] columnNames:@[@"Col1", @"Col2", @"Col3"] rowSize:2 columnSize:3 data:@[@0.0, @1.0, @2.0, @3.0, @4.0, @5.0, @6.0]];
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  tag.TableFormat = format;
  cr = [[STCommandResult alloc] init];
  cr.TableResult = table;
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  NSArray<NSNumber*>* dimensions = [tag GetTableDisplayDimensions];
  XCTAssertEqual(@2, [dimensions objectAtIndex:[STConstantsDimensionIndex Rows]]);
  XCTAssertEqual(@3, [dimensions objectAtIndex:[STConstantsDimensionIndex Columns]]);
  
  tag.TableFormat.IncludeColumnNames = true;
  tag.TableFormat.IncludeRowNames = false;
  dimensions = [tag GetTableDisplayDimensions];
  XCTAssertEqual(@3, [dimensions objectAtIndex:[STConstantsDimensionIndex Rows]]);
  XCTAssertEqual(@3, [dimensions objectAtIndex:[STConstantsDimensionIndex Columns]]);

  tag.TableFormat.IncludeColumnNames = true;
  tag.TableFormat.IncludeRowNames = true;
  dimensions = [tag GetTableDisplayDimensions];
  XCTAssertEqual(@3, [dimensions objectAtIndex:[STConstantsDimensionIndex Rows]]);
  XCTAssertEqual(@4, [dimensions objectAtIndex:[STConstantsDimensionIndex Columns]]);

  tag.TableFormat.IncludeColumnNames = false;
  tag.TableFormat.IncludeRowNames = true;
  dimensions = [tag GetTableDisplayDimensions];
  XCTAssertEqual(@2, [dimensions objectAtIndex:[STConstantsDimensionIndex Rows]]);
  XCTAssertEqual(@4, [dimensions objectAtIndex:[STConstantsDimensionIndex Columns]]);
}

- (void)testFormatLineNumberRange {
  STTag* tag = [[STTag alloc] init];
  XCTAssert([@"" isEqualToString:[tag FormatLineNumberRange]]);
  
  tag.LineStart = @1;
  tag.LineEnd = @1;
  XCTAssert([@"1" isEqualToString:[tag FormatLineNumberRange]]);

  tag.LineEnd = @5;
  XCTAssert([@"1 - 5" isEqualToString:[tag FormatLineNumberRange]]);
}


@end
