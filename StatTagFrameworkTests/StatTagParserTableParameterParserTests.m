//
//  StatTagParserTableParameterParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagParserTableParameterParserTests : XCTestCase

@end

@implementation StatTagParserTableParameterParserTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testParse_EmptyParams_Defaults {
  
  STTag* tag = [[STTag alloc] init];
  
  [STTableParameterParser Parse:@"Table" tag:tag];
  
  XCTAssert([[STConstantsRunFrequency Always] isEqualToString:[tag RunFrequency]]);
  XCTAssertEqual([STConstantsTableParameterDefaults FilterEnabled], [[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssertEqual([STConstantsTableParameterDefaults FilterEnabled], [[[tag TableFormat] RowFilter] Enabled]);

}

- (void)testParse_SingleParams {
  
  // Check each parameter by itself to ensure there are no spacing/boundary errors in our regex
  STTag* tag = [[STTag alloc] init];
  
  [STTableParameterParser Parse:@"Table(Label=\"Test\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);

  [STTableParameterParser Parse:@"Table(ColumnNames=True)" tag:tag];
  XCTAssertFalse([[[tag TableFormat] ColumnFilter] Enabled]);

  [STTableParameterParser Parse:@"Table(RowNames=True)" tag:tag];
  XCTAssertFalse([[[tag TableFormat] RowFilter] Enabled]);
  

}
//
//- (void)testParse_AllParams {
//
//  STTag* tag = [[STTag alloc] init];
//  
//  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColumnNames=True, RowNames=False)" tag:tag];
//  XCTAssert([@"Test" isEqualToString:[tag Name]]);
//  XCTAssertTrue([[tag TableFormat] IncludeColumnNames]);
//  XCTAssertFalse([[tag TableFormat] IncludeRowNames]);
//
//  
//  // Run it again, flipping the order of parameters to test it works in any order
//  [STTableParameterParser Parse:@"Table(RowNames=True, ColumnNames=False, Label=\"Test\")" tag:tag];
//  XCTAssert([@"Test" isEqualToString:[tag Name]]);
//  XCTAssertFalse([[tag TableFormat] IncludeColumnNames]);
//  XCTAssertTrue([[tag TableFormat] IncludeRowNames]);
//  
//  // Run one more time, playing around with spacing
//  [STTableParameterParser Parse:@"Table( RowNames = True , ColumnNames = True , Label = \"Test\" ) " tag:tag];
//  XCTAssert([@"Test" isEqualToString:[tag Name]]);
//  XCTAssertTrue([[tag TableFormat] IncludeColumnNames]);
//  XCTAssertTrue([[tag TableFormat] IncludeRowNames]);
//
//  
//  XCTAssertTrue(false);
//}


-(void)testParse_ReturnDefaults
{
  // If the table filter values aren't set, make sure we set defaults.
  STTag* tag = [[STTag alloc] init];

  [STTableParameterParser Parse:@"Table(Label=\"Test\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);

  XCTAssertEqual([STConstantsTableParameterDefaults FilterEnabled], [[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([[STConstantsTableParameterDefaults FilterType] isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([[STConstantsTableParameterDefaults FilterValue] isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);

  XCTAssertEqual([STConstantsTableParameterDefaults FilterEnabled], [[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([[STConstantsTableParameterDefaults FilterType] isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssert([[STConstantsTableParameterDefaults FilterValue] isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  
  
}

-(void)testParse_AllParams
{

  STTag* tag = [[STTag alloc] init];
  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColFilterEnabled=True, ColFilterType=\"Exclude\", ColFilterValue=\"1,3-5\", RowFilterEnabled=True, RowFilterType=\"Include\", RowFilterValue=\"2\")" tag:tag];

  XCTAssert([@"Test" isEqualToString:[tag Name]]);

  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"Exclude" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([@"1,3-5" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);

  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"Include" isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssert([@"2" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);

  // Run it again, flipping the order of parameters to test it works in any order

  [STTableParameterParser Parse:@"Table(ColFilterEnabled=True, Label=\"Test\", RowFilterEnabled=True, ColFilterType=\"Exclude\", RowFilterValue=\"2\", ColFilterValue=\"1,3-5\", RowFilterType=\"Include\")" tag:tag];
  
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  
  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"Exclude" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([@"1,3-5" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);
  
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"Include" isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssert([@"2" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  
  // Run one more time, playing around with spacing

  [STTableParameterParser Parse:@"Table( RowNames = True , ColumnNames = True , Label = \"Test\" ) " tag:tag];
  [STTableParameterParser Parse:@"Table ( ColFilterEnabled = True, Label  = \"Test\", RowFilterEnabled=  True, ColFilterType  =\"Exclude\", RowFilterValue=  \"2\", ColFilterValue=\"1,3-5\", RowFilterType=\"Include\")" tag:tag];
  
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  
  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"Exclude" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([@"1,3-5" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);
  
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"Include" isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssert([@"2" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);

}

-(void)testRegexParser
{
 
  NSString* tagName;
  NSString* tagText;

  tagText = @"Table(Label=\"Test\", ColFilterEnabled=True, ColFilterType=\"Exclude\", ColFilterValue=\"1,3-5\")";
  tagName = [STTag NormalizeName:[STBaseParameterParser GetStringParameter:[STConstantsTagParameters Label] text:tagText]];
  XCTAssert([tagName isEqualToString:@"Test"]);

  
  tagText = @"Table(Label=\"Test\", RowFilterEnabled=True, RowFilterType=\"Exclude\", RowFilterValue=\"1,3-5\")";
  tagName = [STTag NormalizeName:[STBaseParameterParser GetStringParameter:[STConstantsTagParameters Label] text:tagText]];
  XCTAssert([tagName isEqualToString:@"Test"]);

}

-(void)testParse_ColFilter
{

  STTag* tag = [[STTag alloc] init];
  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColFilterEnabled=True, ColFilterType=\"Exclude\", ColFilterValue=\"1,3-5\")" tag:tag];
  
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  
  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"Exclude" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([@"1,3-5" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);
  
  // Default value
  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColFilterEnabled=True, ColFilterType=\"Exclude\")" tag:tag];
  
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  
  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"Exclude" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([[STConstantsTableParameterDefaults FilterValue] isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);
  
  
  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColFilterEnabled=True, ColFilterValue=\"1,3-5\")" tag:tag];
  
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  
  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([[STConstantsTableParameterDefaults FilterType] isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([@"1,3-5" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);

  // If someone says a filter is enabled but turns on nothing else, we will allow it.  It's the same as turning off the filter, so maybe we should disable it, but won't do that for now.
  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColFilterEnabled=True)" tag:tag];
  
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  
  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([[STConstantsTableParameterDefaults FilterType] isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([[STConstantsTableParameterDefaults FilterValue] isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);

  // If the filter is not enabled, we are going to ignore that any other parameters exist for the filter
  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColFilterEnabled=False, ColFilterType=\"Exclude\", ColFilterValue=\"1,3-5\")" tag:tag];
  
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  
  XCTAssertFalse([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);

}

-(void)testParse_RowFilter
{
  
  STTag* tag = [[STTag alloc] init];
  [STTableParameterParser Parse:@"Table(Label=\"Test\", RowFilterEnabled=True, RowFilterType=\"Exclude\", RowFilterValue=\"1,3-5\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"Exclude" isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssert([@"1,3-5" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);

  // Default value
  [STTableParameterParser Parse:@"Table(Label=\"Test\", RowFilterEnabled=True, RowFilterType=\"Exclude\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"Exclude" isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssert([[STConstantsTableParameterDefaults FilterValue] isEqualToString: [[[tag TableFormat] RowFilter] Value]]);

  [STTableParameterParser Parse:@"Table(Label=\"Test\", RowFilterEnabled=True, RowFilterValue=\"1,3-5\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([[STConstantsTableParameterDefaults FilterType] isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssert([@"1,3-5" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  
  // If someone says a filter is enabled but turns on nothing else, we will allow it.  It's the same as turning off the filter, so maybe we should disable it, but won't do that for now.
  [STTableParameterParser Parse:@"Table(Label=\"Test\", RowFilterEnabled=True)" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([[STConstantsTableParameterDefaults FilterType] isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssert([[STConstantsTableParameterDefaults FilterValue] isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  
  // If the filter is not enabled, we are going to ignore that any other parameters exist for the filter
  [STTableParameterParser Parse:@"Table(Label=\"Test\", RowFilterEnabled=False, RowFilterType=\"Exclude\", RowFilterValue=\"1,3-5\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertFalse([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);

}

/**
  We moved from row/column name attributes to row/column filters in v2.  We set up a migration path for
  those who created tags in v1, and this verifies that those tags are automatically converted as we would
  expect.  This also verifies we can continue to parse those attributes, even though they won't be
  officially supported going forward.
*/
-(void)testParse_v1_To_v2_Migration
{

  STTag* tag = [[STTag alloc] init];
  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColumnNames=True, RowNames=False)" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"1" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  XCTAssert([[STConstantsFilterType Exclude] isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssertFalse([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);

  // Run it again, flipping the order of parameters to test it works in any order
  [STTableParameterParser Parse:@"Table(RowNames=False, ColumnNames=True, Label=\"Test\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"1" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  XCTAssert([[STConstantsFilterType Exclude] isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssertFalse([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  
  // Playing around with spacing
  [STTableParameterParser Parse:@"Table( RowNames = False , ColumnNames = False , Label = \"Test\" ) " tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"1" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  XCTAssert([[STConstantsFilterType Exclude] isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"1" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  XCTAssert([[STConstantsFilterType Exclude] isEqualToString: [[[tag TableFormat] RowFilter] Type]]);
  
  // Run one more time, with just columns
  [STTableParameterParser Parse:@"Table( RowNames = True , ColumnNames = False , Label = \"Test\" ) " tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[[tag TableFormat] ColumnFilter] Enabled]);
  XCTAssert([@"1" isEqualToString: [[[tag TableFormat] ColumnFilter] Value]]);
  XCTAssert([[STConstantsFilterType Exclude] isEqualToString: [[[tag TableFormat] ColumnFilter] Type]]);
  XCTAssertFalse([[[tag TableFormat] RowFilter] Enabled]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] RowFilter] Value]]);
  XCTAssert([@"" isEqualToString: [[[tag TableFormat] RowFilter] Type]]);

}

@end
