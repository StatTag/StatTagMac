//
//  StatTagValueFormatterBaseValueFormatterTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STBaseValueFormatter.h"

@interface StatTagValueFormatterBaseValueFormatterTests : XCTestCase

@end

@implementation StatTagValueFormatterBaseValueFormatterTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testEmptyNullStrings {
  XCTAssertEqual([STBaseValueFormatter MissingValue], [[[STBaseValueFormatter alloc] init] Finalize:nil]);
  XCTAssertEqual([STBaseValueFormatter MissingValue], [[[STBaseValueFormatter alloc] init] Finalize:@""]);
  XCTAssertEqual([STBaseValueFormatter MissingValue], [[[STBaseValueFormatter alloc] init] Finalize:@"   "]);
}

- (void)testRegularStrings {
  XCTAssertEqual(@"Test", [[[STBaseValueFormatter alloc] init] Finalize:@"Test"]);
}


@end
