//
//  StatTagParserValueParserTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagParserValueParserTests : XCTestCase

@end

@implementation StatTagParserValueParserTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testParse_EmptyParams_Defaults {
  
  STTag* tag = [[STTag alloc] init];
  
  [STValueParameterParser Parse:@"Value" tag:tag];

  XCTAssert([[STConstantsValueFormatType Default] isEqualToString:[[tag ValueFormat] FormatType]]);
  XCTAssert([[STConstantsRunFrequency Always] isEqualToString:[tag RunFrequency]]);
}

- (void)testParse_SingleParams {
  
  // Check each parameter by itself to ensure there are no spacing/boundary errors in our regex

  STTag* tag = [[STTag alloc] init];
  
  [STValueParameterParser Parse:@"Value(Label=\"Test\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);

  [STValueParameterParser Parse:@"Value(Type=\"Numeric\")" tag:tag];
  XCTAssert([@"Numeric" isEqualToString:[[tag ValueFormat] FormatType]]);

  
  [STValueParameterParser Parse:@"Value(Decimals=5)" tag:tag];
  XCTAssertEqual(5, [[tag ValueFormat] DecimalPlaces]);
  
  [STValueParameterParser Parse:@"Value(Thousands=true)" tag:tag];
  XCTAssertTrue([[tag ValueFormat] UseThousands]);

  [STValueParameterParser Parse:@"Value(DateFormat=\"MM-DD-YYYY\")" tag:tag];
  XCTAssert([@"MM-DD-YYYY" isEqualToString:[[tag ValueFormat] DateFormat]]);

  [STValueParameterParser Parse:@"Value(TimeFormat=\"HH:MM:SS\")" tag:tag];
  XCTAssert([@"HH:MM:SS" isEqualToString:[[tag ValueFormat] TimeFormat]]);
  
}

- (void)testParse_AllParams {
  
  STTag* tag = [[STTag alloc] init];
  [STValueParameterParser Parse:@"Value(Label=\"Test\", Type=\"Numeric\", Decimals=5, Thousands=true, DateFormat=\"MM-DD-YYYY\", TimeFormat=\"HH:MM:SS\")" tag:tag];

  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssert([@"Numeric" isEqualToString:[[tag ValueFormat] FormatType]]);
  XCTAssertEqual(5, [[tag ValueFormat] DecimalPlaces]);
  XCTAssertTrue([[tag ValueFormat] UseThousands]);
  XCTAssert([@"MM-DD-YYYY" isEqualToString:[[tag ValueFormat] DateFormat]]);
  XCTAssert([@"HH:MM:SS" isEqualToString:[[tag ValueFormat] TimeFormat]]);
  
  // Run it again, flipping the order of parameters to test it works in any order
  [STValueParameterParser Parse:@"Value(Type=\"Numeric\", TimeFormat=\"HH:MM:SS\", Label=\"Test\", Thousands=true, Decimals=5, DateFormat=\"MM-DD-YYYY\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssert([@"Numeric" isEqualToString:[[tag ValueFormat] FormatType]]);
  XCTAssertEqual(5, [[tag ValueFormat] DecimalPlaces]);
  XCTAssertTrue([[tag ValueFormat] UseThousands]);
  XCTAssert([@"MM-DD-YYYY" isEqualToString:[[tag ValueFormat] DateFormat]]);
  XCTAssert([@"HH:MM:SS" isEqualToString:[[tag ValueFormat] TimeFormat]]);

  // Run one more time, playing around with spacing
  [STValueParameterParser Parse:@"Value(Type=\"Numeric\", TimeFormat=\"HH:MM:SS\", Label=\"Test\", Thousands=true, Decimals=5, DateFormat=\"MM-DD-YYYY\")" tag:tag];
  XCTAssert([@"Test" isEqualToString:[tag Name]]);
  XCTAssert([@"Numeric" isEqualToString:[[tag ValueFormat] FormatType]]);
  XCTAssertEqual(5, [[tag ValueFormat] DecimalPlaces]);
  XCTAssertTrue([[tag ValueFormat] UseThousands]);
  XCTAssert([@"MM-DD-YYYY" isEqualToString:[[tag ValueFormat] DateFormat]]);
  XCTAssert([@"HH:MM:SS" isEqualToString:[[tag ValueFormat] TimeFormat]]);

}



@end
