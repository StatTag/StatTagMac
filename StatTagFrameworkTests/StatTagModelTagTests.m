//
//  StatTagModelTagTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/27/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

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
  STTag* tag1 = [[STTag alloc] init];
  tag1.Name = @"Test";
  tag1.Type = [STConstantsTagType Value];
  tag1.LineStart = @1;
  tag1.LineEnd = @2;

  STTag* tag2 = [[STTag alloc] initWithTag:tag1];
  XCTAssert([tag1 isEqual:tag2]);
}

- (void)testCopyCtor_Null {
  STTag* tag = [[STTag alloc] init];
  XCTAssertNil([tag CodeFile]);
  XCTAssertNil([tag CachedResult]);
  //TEST CASE DEVIATION
  XCTAssertNotNil([tag FigureFormat]);//original execpted NIL
  XCTAssertNil([tag LineEnd]);
  XCTAssertNil([tag LineStart]);
  //TEST CASE DEVIATION
  XCTAssertNotNil([tag Name]);//original execpted NIL
  XCTAssertNil([tag RunFrequency]);
  //TEST CASE DEVIATION
  XCTAssertNotNil([tag TableFormat]);//original execpted NIL
  XCTAssertNil([tag Type]);
  //TEST CASE DEVIATION
  XCTAssertNotNil([tag ValueFormat]);//original execpted NIL
}

- (void)testEquals_Match {

  STCodeFile* file1 = [[STCodeFile alloc] init];
  NSString* url = @"File1.txt";
  file1.FilePath = url;

  STTag* tag1 = [[STTag alloc] init];
  tag1.Name = @"Test";
  tag1.Type = [STConstantsTagType Value];
  tag1.LineStart = @1;
  tag1.LineEnd = @2;
  tag1.CodeFile = file1;
  
  STTag* tag2 = [[STTag alloc] init];
  tag2.Name = @"Test";
  tag2.Type = [STConstantsTagType Value];
  tag2.LineStart = @3;
  tag2.LineEnd = @4;
  tag2.CodeFile = file1;

  XCTAssert([tag1 isEqual:tag2]);
  XCTAssert([tag2 isEqual:tag1]);
  
  // Even if the file object changes, if the file is the same (based on the path) the
  // tags should remain as equal
  STCodeFile* file2 = [[STCodeFile alloc] init];
  NSString* url2 = @"File1.txt";
  file2.FilePath = url2;

  tag2.CodeFile = file2;
  XCTAssert([tag1 isEqual:tag2]);
  XCTAssert([tag2 isEqual:tag1]);

}

- (void)testEquals_NoMatch {

  STCodeFile* file1 = [[STCodeFile alloc] init];
  NSString* url = @"File1.txt";
  file1.FilePath = url;

  STCodeFile* file2 = [[STCodeFile alloc] init];
  NSString* url2 = @"File2.txt";
  file2.FilePath = url2;

  STTag* tag1 = [[STTag alloc] init];
  tag1.Name = @"Test";
  tag1.Type = [STConstantsTagType Value];
  tag1.LineStart = @1;
  tag1.LineEnd = @2;
  tag1.CodeFile = file1;
  
  STTag* tag2 = [[STTag alloc] init];
  tag2.Name = @"Test2";
  tag2.Type = [STConstantsTagType Value];
  tag2.LineStart = @1;
  tag2.LineEnd = @2;
  tag2.CodeFile = file1;

  STTag* tag3 = [[STTag alloc] init];
  tag3.Name = @"Test";
  tag3.Type = [STConstantsTagType Value];
  tag3.LineStart = @3;
  tag3.LineEnd = @4;
  tag3.CodeFile = file2;

  XCTAssertFalse([tag1 isEqual:tag2]);
  XCTAssertFalse([tag2 isEqual:tag1]);
  XCTAssertFalse([tag1 isEqual:tag3]);
  XCTAssertFalse([tag3 isEqual:tag1]);
  XCTAssertFalse([tag2 isEqual:tag3]);
  XCTAssertFalse([tag3 isEqual:tag2]);
}

- (void)testEqualsWithPosition {


  STCodeFile* file1 = [[STCodeFile alloc] init];
  NSString* url = @"File1.txt";
  file1.FilePath = url;

  STTag* tag1 = [[STTag alloc] init];
  tag1.Name = @"Test";
  tag1.Type = [STConstantsTagType Value];
  tag1.LineStart = @1;
  tag1.LineEnd = @2;
  tag1.CodeFile = file1;
  
  STTag* tag2 = [[STTag alloc] init];
  tag2.Name = @"Test";
  tag2.Type = [STConstantsTagType Value];
  tag2.LineStart = @3;
  tag2.LineEnd = @4;
  tag2.CodeFile = file1;
  
  XCTAssertFalse([tag1 EqualsWithPosition:tag2]);
  XCTAssertFalse([tag2 EqualsWithPosition:tag1]);
  
  tag2.LineStart = tag1.LineStart;
  tag2.LineEnd = tag1.LineEnd;

  XCTAssertTrue([tag1 EqualsWithPosition:tag2]);
  XCTAssertTrue([tag2 EqualsWithPosition:tag1]);

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
  //TEST CASE DEVIATION
  XCTAssertNotNil([tag FigureFormat]);//original expected NIL
  //TEST CASE DEVIATION
  XCTAssertNotNil([recreatedTag FigureFormat]);//original expected NIL

  XCTAssert([[tag FormattedResult] isEqualToString:[recreatedTag FormattedResult]]);

  XCTAssertEqual([[tag LineEnd] integerValue], [[recreatedTag LineEnd] integerValue]);
  XCTAssertEqual([[tag LineStart] integerValue], [[recreatedTag LineStart] integerValue]);

  XCTAssert([[tag Name] isEqualToString:[recreatedTag Name]]);
  XCTAssertNil([tag RunFrequency]);
  XCTAssertNil([recreatedTag RunFrequency]);
  
  //XCTAssert([[tag RunFrequency] isEqualToString:[recreatedTag RunFrequency]]);

  XCTAssert([[tag Type] isEqualToString:[recreatedTag Type]]);

//  Assert.AreEqual(tag.ValueFormat, recreatedTag.ValueFormat);
  //TEST CASE DEVIATION
  XCTAssertNotNil([tag ValueFormat]);//original expected NIL
  //TEST CASE DEVIATION
  XCTAssertNotNil([recreatedTag ValueFormat]);//original expected NIL

//  Assert.AreEqual(tag.FigureFormat, recreatedTag.FigureFormat);
  //TEST CASE DEVIATION
  XCTAssertNotNil([tag FigureFormat]);//original expected NIL
  //TEST CASE DEVIATION
  XCTAssertNotNil([recreatedTag FigureFormat]);//original expected NIL

//  Assert.AreEqual(tag.TableFormat, recreatedTag.TableFormat);
  //TEST CASE DEVIATION
  XCTAssertNotNil([tag TableFormat]);//original expected NIL
  //TEST CASE DEVIATION
  XCTAssertNotNil([recreatedTag TableFormat]);//original expected NIL


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
//  STTableFormat* format = [[STTableFormat alloc] init];
//  format.IncludeColumnNames = false;
//  format.IncludeRowNames = false;
//  STTable* table = [[STTable alloc] init:@[@"Row1", @"Row2"] columnNames:@[@"Col1", @"Col2"] rowSize:2 columnSize:1 data:@[@0.0, @1.0, @2.0, @3.0]];
  
  STTableFormat* format = [[STTableFormat alloc] init];
  format.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  format.ColumnFilter.Enabled = true;
  format.ColumnFilter.Type = [STConstantsFilterType Exclude];
  format.ColumnFilter.Value = @"1";
  format.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  format.RowFilter.Enabled = true;
  format.RowFilter.Type = [STConstantsFilterType Exclude];
  format.RowFilter.Value = @"1";
  
  STTable* table = [[STTable alloc] init:3 columnSize:3 data:[[STTableData alloc] initWithData:@[@[@"", @"Col1", @"Col2"], @[@"Row1", @"0.0", @"1.0"], @[@"Row2", @"2.0", @"3.0"]]]];
  
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
//  STTableFormat* format = [[STTableFormat alloc] init];
//  format.IncludeColumnNames = false;
//  format.IncludeRowNames = false;

  STTableFormat* format = [[STTableFormat alloc] init];
  format.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  format.ColumnFilter.Enabled = true;
  format.ColumnFilter.Type = [STConstantsFilterType Exclude];
  format.ColumnFilter.Value = @"1";
  format.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  format.RowFilter.Enabled = true;
  format.RowFilter.Type = [STConstantsFilterType Exclude];
  format.RowFilter.Value = @"1";
  
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  tag.TableFormat = format;
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  XCTAssertNil([tag GetTableDisplayDimensions]);

  // Actual data
  format = [[STTableFormat alloc] init];
  format.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  format.ColumnFilter.Enabled = true;
  format.ColumnFilter.Type = [STConstantsFilterType Exclude];
  format.ColumnFilter.Value = @"1";
  format.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  format.RowFilter.Enabled = true;
  format.RowFilter.Type = [STConstantsFilterType Exclude];
  format.RowFilter.Value = @"1";
  STTable* table = [[STTable alloc] init:3 columnSize:4 data:[[STTableData alloc] initWithData:@[@[ @"", @"Col1", @"Col2", @"Col3" ], @[ @"Row1", @"0.0", @"1.0", @"2.0" ], @[ @"Row2", @"3.0", @"4.0", @"5.0" ]]]];
  
  tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  tag.TableFormat = format;
  cr = [[STCommandResult alloc] init];
  cr.TableResult = table;
  tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithObjects:cr, nil];
  NSArray<NSNumber*>* dimensions = [tag GetTableDisplayDimensions];
  XCTAssertEqual(2, [[dimensions objectAtIndex:[STConstantsDimensionIndex Rows]] integerValue]);
  XCTAssertEqual(3, [[dimensions objectAtIndex:[STConstantsDimensionIndex Columns]] integerValue]);
  
  
  format = [[STTableFormat alloc] init];
  format.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  format.ColumnFilter.Enabled = false;
  format.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  format.RowFilter.Enabled = true;
  format.RowFilter.Type = [STConstantsFilterType Exclude];
  format.RowFilter.Value = @"1";
  tag.TableFormat = format;
  //tag.TableFormat.IncludeColumnNames = true;
  //tag.TableFormat.IncludeRowNames = false;
  dimensions = [tag GetTableDisplayDimensions];
  XCTAssertEqual(2, [[dimensions objectAtIndex:[STConstantsDimensionIndex Rows]] integerValue]);
  XCTAssertEqual(4, [[dimensions objectAtIndex:[STConstantsDimensionIndex Columns]] integerValue]);

  //tag.TableFormat.IncludeColumnNames = true;
  //tag.TableFormat.IncludeRowNames = true;
  format = [[STTableFormat alloc] init];
  format.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  format.ColumnFilter.Enabled = false;
  format.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  format.RowFilter.Enabled = false;
  tag.TableFormat = format;
  dimensions = [tag GetTableDisplayDimensions];
  XCTAssertEqual(3, [[dimensions objectAtIndex:[STConstantsDimensionIndex Rows]] integerValue]);
  XCTAssertEqual(4, [[dimensions objectAtIndex:[STConstantsDimensionIndex Columns]] integerValue]);

  //tag.TableFormat.IncludeColumnNames = false;
  //tag.TableFormat.IncludeRowNames = true;
  format = [[STTableFormat alloc] init];
  format.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  format.RowFilter.Enabled = false;
  format.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  format.ColumnFilter.Enabled = true;
  format.ColumnFilter.Type = [STConstantsFilterType Exclude];
  format.ColumnFilter.Value = @"1";
  tag.TableFormat = format;
  dimensions = [tag GetTableDisplayDimensions];
  XCTAssertEqual(3, [[dimensions objectAtIndex:[STConstantsDimensionIndex Rows]] integerValue]);
  XCTAssertEqual(3, [[dimensions objectAtIndex:[STConstantsDimensionIndex Columns]] integerValue]);
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
