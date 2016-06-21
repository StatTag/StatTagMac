//
//  StatTagModelTableTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

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

- (void)testFormat_Empty {
  
  STTableFormat* format = [[STTableFormat alloc] init];
  XCTAssertNotNil([format Format:nil]);
//  Assert.IsNotNull(format.Format(null));

  XCTAssertEqual(0, [[format Format:nil] count]);
//  Assert.AreEqual(0, format.Format(null).Length);

  
  XCTAssertNotNil([format Format:[[STTable alloc]init]]);
  //  Assert.IsNotNull(format.Format(new Table()));

  
  XCTAssertEqual(0, [[format Format:[[STTable alloc]init]] count]);
  //  Assert.AreEqual(0, format.Format(new Table()).Length);

  
}

@end
