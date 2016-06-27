//
//  StatTagModelCommandResultTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/27/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagModelCommandResultTests : XCTestCase

@end

@implementation StatTagModelCommandResultTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testIsEmpty {
  
  STCommandResult* result = [[STCommandResult alloc] init];

  XCTAssert([result IsEmpty]);
  
  result.ValueResult = @" ";
  result.FigureResult = @" ";
  XCTAssert([result IsEmpty]);

  result.ValueResult = @"";
  result.FigureResult = @"ok";
  XCTAssertFalse([result IsEmpty]);

  result.ValueResult = @"ok";
  result.FigureResult = @"";
  XCTAssertFalse([result IsEmpty]);

  result.ValueResult = @"";
  result.FigureResult = @"";
  result.TableResult = [[STTable alloc] init];
  XCTAssert([result IsEmpty]);

  result.ValueResult = @"";
  result.FigureResult = @"";
  result.TableResult = [[STTable alloc] init:@[@"Test"] columnNames:@[@"Test"] rowSize:1 columnSize:1 data:@[@0.0]];
  XCTAssertFalse([result IsEmpty]);
}

- (void)testToString_Formatted {
  
  STCommandResult* result = [[STCommandResult alloc] init];

  result.ValueResult = @"";
  result.FigureResult = @"figure ok";
  XCTAssert([@"figure ok" isEqualToString:[result ToString]]);
  
  result.ValueResult = @"value ok";
  result.FigureResult = @"";
  XCTAssert([@"value ok" isEqualToString:[result ToString]]);

  result.ValueResult = @"";
  result.FigureResult = @"";
  result.TableResult = [[STTable alloc] init:@[@"Test"] columnNames:@[@"Test"] rowSize:1 columnSize:1 data:@[@0.0]];
  XCTAssert([@"STTable" isEqualToString:[result ToString]]);
}


@end
