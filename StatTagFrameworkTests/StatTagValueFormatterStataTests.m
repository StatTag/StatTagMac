//
//  StatTagValueFormatterStata.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STStataBaseValueFormatter.h"

@interface StatTagValueFormatterStataTests : XCTestCase

@end

@implementation StatTagValueFormatterStataTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCheckMissingValue {
  //NSLog(@"1: %@", [STStataBaseValueFormatter MissingValue]);
  //NSLog(@"2: %@", [[[STStataBaseValueFormatter alloc] init] GetMissingValue]);
  XCTAssertEqual([STStataBaseValueFormatter MissingValue], [[[STStataBaseValueFormatter alloc] init] GetMissingValue]);
}


@end
