//
//  StatTagUtilityGeneralUtilTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagUtilityGeneralUtilTests : XCTestCase

@end

@implementation StatTagUtilityGeneralUtilTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testStringArrayToObjectArray_Null {
  NSArray* result = [STGeneralUtil StringArrayToObjectArray:nil];
  XCTAssertNil(result);
}

- (void)testStringArrayToObjectArray {

  NSArray* result = [STGeneralUtil StringArrayToObjectArray:[NSArray arrayWithObjects:@"Test1", @"Test2", nil]];
  XCTAssertEqual(2, [result count]);
  XCTAssert([@"Test1" isEqualToString:result[0]]);
  XCTAssert([@"Test2" isEqualToString:result[1]]);
}


@end
