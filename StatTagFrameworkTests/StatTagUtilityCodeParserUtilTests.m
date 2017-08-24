//
//  StatTagUtilityCodeParserUtilTests.m
//  StatTag
//
//  Created by Rasmussen, Luke on 8/23/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STCodeParserUtil.h"

@interface StatTagUtilityCodeParserUtilTests : XCTestCase

@end

@implementation StatTagUtilityCodeParserUtilTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStripTrailingComments {
  NSString* test = @"First line\r\nSecond line\r\nThird line";
  NSString* result = [STCodeParserUtil StripTrailingComments:test];
  XCTAssertEqualObjects(test, result);

  test = @"First line\r\nSecond line // comment \r\nThird line";
  result = [STCodeParserUtil StripTrailingComments:test];
  XCTAssertEqualObjects(@"First line\r\nSecond line \r\nThird line", result);

  test = @"First line //    blah\r\nSecond line // blah \r\nThird line //blah";
  result = [STCodeParserUtil StripTrailingComments:test];
  XCTAssertEqualObjects(@"First line \r\nSecond line \r\nThird line ", result);

  test = @"First line //    blah\r\nsome_cmd(\"//unc/path\") // blah \r\nThird line //blah";
  result = [STCodeParserUtil StripTrailingComments:test];
  XCTAssertEqualObjects(@"First line \r\nsome_cmd(\"//unc/path\") \r\nThird line ", result);
}


@end
