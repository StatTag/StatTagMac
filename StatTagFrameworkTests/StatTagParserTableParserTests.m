//
//  StatTagParserTableParameterParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagParserTableParserTests : XCTestCase

@end

@implementation StatTagParserTableParserTests

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
  XCTAssertEqual([STConstantsTableParameterDefaults ColumnNames], [[tag TableFormat] IncludeColumnNames]);
  XCTAssertEqual([STConstantsTableParameterDefaults RowNames], [[tag TableFormat] IncludeRowNames]);
  
}

- (void)testParse_SingleParams {
  
  // Check each parameter by itself to ensure there are no spacing/boundary errors in our regex
  STTag* tag = [[STTag alloc] init];
  
  [STTableParameterParser Parse:@"Table(Label=\"Test\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);

  [STTableParameterParser Parse:@"Table(ColumnNames=True)" tag:tag];
  XCTAssertTrue([[tag TableFormat] IncludeColumnNames]);

  [STTableParameterParser Parse:@"Table(RowNames=True)" tag:tag];
  XCTAssertTrue([[tag TableFormat] IncludeRowNames]);
  
}

- (void)testParse_AllParams {
  
  STTag* tag = [[STTag alloc] init];
  
  [STTableParameterParser Parse:@"Table(Label=\"Test\", ColumnNames=True, RowNames=False)" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[tag TableFormat] IncludeColumnNames]);
  XCTAssertFalse([[tag TableFormat] IncludeRowNames]);

  
  // Run it again, flipping the order of parameters to test it works in any order
  [STTableParameterParser Parse:@"Table(RowNames=True, ColumnNames=False, Label=\"Test\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertFalse([[tag TableFormat] IncludeColumnNames]);
  XCTAssertTrue([[tag TableFormat] IncludeRowNames]);
  
  // Run one more time, playing around with spacing
  [STTableParameterParser Parse:@"Table( RowNames = True , ColumnNames = True , Label = \"Test\" ) " tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssertTrue([[tag TableFormat] IncludeColumnNames]);
  XCTAssertTrue([[tag TableFormat] IncludeRowNames]);

  
}


@end
