//
//  StatTagParserBaseParameterParserTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagParserBaseParameterParserTests : XCTestCase

@end

@implementation StatTagParserBaseParameterParserTests

NSString* DefaultStringValue = @"DEFAULT";
NSNumber* DefaultIntValue;// = @9999; //no compile-time NSNumber constants... so do it in setup
BOOL DefaultBoolValue = true;

- (void)setUp {
  [super setUp];
  DefaultIntValue = @9999;
}

- (void)tearDown {
  [super tearDown];
}

- (void)testParse_EmptyParams {
  NSString* tagText = @"()";
  STTag* tag = [[STTag alloc] init];
  [STBaseParameterParser Parse:tagText Tag:tag];
  XCTAssert([@"" isEqualToString:[tag Name]]);
  XCTAssert([[STConstantsRunFrequency Always] isEqualToString:[tag RunFrequency]]);
}

- (void)testParse_Values {
  NSString* tagText = @"(Label=\"test\", Frequency=\"On Demand\")";
  STTag* tag = [[STTag alloc] init];
  [STBaseParameterParser Parse:tagText Tag:tag];
  XCTAssert([@"test" isEqualToString:[tag Name]]);
  XCTAssert([[STConstantsRunFrequency OnDemand] isEqualToString:[tag RunFrequency]]);
}

- (void)testGetStringParameter_Normal {
  XCTAssert([@"OK" isEqualToString:[STBaseParameterParser GetStringParameter:@"Test" text:@"(Test=\"OK\")" defaultValue:DefaultStringValue]]);
}

- (void)testGetStringParameter_MissingValue {
  XCTAssert([DefaultStringValue isEqualToString:[STBaseParameterParser GetStringParameter:@"Test" text:@"(Test=)" defaultValue:DefaultStringValue]]);
}

- (void)testGetStringParameter_EmptyValue {
  XCTAssert([@"" isEqualToString:[STBaseParameterParser GetStringParameter:@"Test" text:@"(Test=\"\")" defaultValue:DefaultStringValue]]);
}

- (void)testGetIntParameter_Normal {
  XCTAssertEqual(50, [[STBaseParameterParser GetIntParameter:@"Test" text:@"(Test=50)" defaultValue:DefaultIntValue] integerValue]);
}

- (void)testGetIntParameter_MissingValue {
  XCTAssertEqual(DefaultIntValue, [STBaseParameterParser GetIntParameter:@"Test" text:@"(Test=)" defaultValue:DefaultIntValue]);
}

- (void)testGetIntParameter_Quoted {
  XCTAssertEqual(DefaultIntValue, [STBaseParameterParser GetIntParameter:@"Test" text:@"(Test=\"50\")" defaultValue:DefaultIntValue]);
}

- (void)testGetBoolParameter_Normal {
  XCTAssertEqual(false, [STBaseParameterParser GetBoolParameter:@"Test" text:@"(Test=false)" defaultValue:DefaultBoolValue]);
  XCTAssertEqual(false, [STBaseParameterParser GetBoolParameter:@"Test" text:@"(Test=False)" defaultValue:DefaultBoolValue]);
}

- (void)testGetBoolParameter_MissingValue {
  XCTAssertEqual(DefaultBoolValue, [STBaseParameterParser GetBoolParameter:@"Test" text:@"(Test=)" defaultValue:DefaultBoolValue]);
}

- (void)testGetBoolParameter_Quoted {
  XCTAssertEqual(DefaultBoolValue, [STBaseParameterParser GetBoolParameter:@"Test" text:@"(Test=\"false\")" defaultValue:DefaultBoolValue]);
}


@end
