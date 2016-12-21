//
//  StatTagGeneratorTableGeneratorTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/30/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagGeneratorTableParameterGeneratorTests : XCTestCase

@end

@implementation StatTagGeneratorTableParameterGeneratorTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCreateParameters_NoLabel {
  STTableParameterGenerator* generator = [[STTableParameterGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  XCTAssert([@"" isEqualToString:[generator CreateParameters:tag]]);
}

- (void)testCreateParameters_Label {
  STTableParameterGenerator* generator = [[STTableParameterGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Name = @"Test";
  XCTAssert([@"Label=\"Test\"" isEqualToString:[generator CreateParameters:tag]]);
}


-(void) testCreateParameters_FiltersDisabled
{
  STTableParameterGenerator* generator = [[STTableParameterGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Name = @"Test";
  
  // Null table format
  XCTAssert([@"Label=\"Test\"" isEqualToString:[generator CreateParameters:tag]]);

  // Row and column filters both disabled
  tag = [[STTag alloc] init];
  tag.Name = @"Test";
  STTableFormat* tableFormat = [[STTableFormat alloc] init];
  STFilterFormat* colFilter = [[STFilterFormat alloc] initWithPrefix:@"Column"];
  colFilter.Enabled = NO;
  tableFormat.ColumnFilter = colFilter;
  STFilterFormat* rowFilter = [[STFilterFormat alloc] initWithPrefix:@"Row"];
  rowFilter.Enabled = NO;
  tableFormat.RowFilter = rowFilter;
  tag.TableFormat = tableFormat;
  XCTAssert([@"Label=\"Test\"" isEqualToString:[generator CreateParameters:tag]]);

}

-(void) testCreateParameters_RowFilter
{
  STTableParameterGenerator* generator = [[STTableParameterGenerator alloc] init];

  STTag* tag = [[STTag alloc] init];
  tag.Name = @"Test";
  STTableFormat* tableFormat = [[STTableFormat alloc] init];
  STFilterFormat* rowFilter = [[STFilterFormat alloc] initWithPrefix:@"Row"];
  rowFilter.Enabled = YES;
  rowFilter.Type = [STConstantsFilterType Exclude];
  rowFilter.Value = @"1";
  tableFormat.RowFilter = rowFilter;
  tag.TableFormat = tableFormat;
  XCTAssert([@"Label=\"Test\", RowFilterEnabled=True, RowFilterType=\"Exclude\", RowFilterValue=\"1\"" isEqualToString:[generator CreateParameters:tag]]);

}

-(void) testCreateParameters_ColumnFilter
{
  
  STTableParameterGenerator* generator = [[STTableParameterGenerator alloc] init];
  
  STTag* tag = [[STTag alloc] init];
  tag.Name = @"Test";
  STTableFormat* tableFormat = [[STTableFormat alloc] init];
  STFilterFormat* columnFilter = [[STFilterFormat alloc] initWithPrefix:@"Column"];
  columnFilter.Enabled = YES;
  columnFilter.Type = [STConstantsFilterType Exclude];
  columnFilter.Value = @"1";
  tableFormat.ColumnFilter = columnFilter;
  tag.TableFormat = tableFormat;
  XCTAssert([@"Label=\"Test\", ColumnFilterEnabled=True, ColumnFilterType=\"Exclude\", ColumnFilterValue=\"1\"" isEqualToString:[generator CreateParameters:tag]]);

}


@end
