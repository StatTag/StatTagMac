//
//  StatTagGeneratorValueGeneratorTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/30/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagGeneratorValueGeneratorTests : XCTestCase

@end

@implementation StatTagGeneratorValueGeneratorTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCreateDefaultParameters {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  XCTAssert([@"Type=\"Default\", " isEqualToString:[generator CreateDefaultParameters]]);
             
  // It will only add the AllowInvalidTypes attribute when it is not the default value
  XCTAssert([@"Type=\"Default\", AllowInvalid=True, " isEqualToString:[generator CreateDefaultParameters:[STConstantsValueFormatType Default] invalidTypes:true]]);
}

- (void)testCreatePercentageParameters_Default {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STValueFormat* vf = [[STValueFormat alloc] init];
  XCTAssert([@"Decimals=0" isEqualToString:[generator CreatePercentageParameters:vf]]);
}

- (void)testCreatePercentageParameters_Value {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STValueFormat* vf = [[STValueFormat alloc] init];
  vf.DecimalPlaces = 2;
  XCTAssert([@"Decimals=2" isEqualToString:[generator CreatePercentageParameters:vf]]);
}

- (void)testCreateNumericParameters_Default {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STValueFormat* vf = [[STValueFormat alloc] init];
  NSLog(@"[generator CreateNumericParameters:vf] : %@", [generator CreateNumericParameters:vf]);
  XCTAssert([@"Decimals=0, Thousands=False" isEqualToString:[generator CreateNumericParameters:vf]]);
}

- (void)testCreateNumericParameters_Values {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STValueFormat* vf = [[STValueFormat alloc] init];
  vf.DecimalPlaces = 1;
  XCTAssert([@"Decimals=1, Thousands=False" isEqualToString:[generator CreateNumericParameters:vf]]);

  vf = [[STValueFormat alloc] init];
  vf.UseThousands = true;
  XCTAssert([@"Decimals=0, Thousands=True" isEqualToString:[generator CreateNumericParameters:vf]]);
  
  vf = [[STValueFormat alloc] init];
  vf.DecimalPlaces = 2;
  vf.UseThousands = true;
  XCTAssert([@"Decimals=2, Thousands=True" isEqualToString:[generator CreateNumericParameters:vf]]);
}

- (void)testCreateDateTimeParameters_Default {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STValueFormat* vf = [[STValueFormat alloc] init];
  NSLog(@"[generator CreateDateTimeParameters:vf]: %@", [generator CreateDateTimeParameters:vf]);
  XCTAssert([@"" isEqualToString:[generator CreateDateTimeParameters:vf]]);
}

- (void)testCreateDateTimeParameters_Values {

  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STValueFormat* vf = [[STValueFormat alloc] init];

  vf.DateFormat = @"MM-DD-YYYY";
  NSLog(@"[generator CreateDateTimeParameters:vf]: %@", [generator CreateDateTimeParameters:vf]);
  XCTAssert([@"DateFormat=\"MM-DD-YYYY\"" isEqualToString:[generator CreateDateTimeParameters:vf]]);

  vf = [[STValueFormat alloc] init];
  vf.TimeFormat = @"HH:MM:SS";
  NSLog(@"[generator CreateDateTimeParameters:vf]: %@", [generator CreateDateTimeParameters:vf]);
  XCTAssert([@"TimeFormat=\"HH:MM:SS\"" isEqualToString:[generator CreateDateTimeParameters:vf]]);

  vf = [[STValueFormat alloc] init];
  vf.DateFormat = @"MM-DD-YYYY";
  vf.TimeFormat = @"HH:MM:SS";
  NSLog(@"[generator CreateDateTimeParameters:vf]: %@", [generator CreateDateTimeParameters:vf]);
  XCTAssert([@"DateFormat=\"MM-DD-YYYY\", TimeFormat=\"HH:MM:SS\"" isEqualToString:[generator CreateDateTimeParameters:vf]]);
}

- (void)testCreateParameters_Default {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];

  XCTAssert([@"Type=\"Default\"" isEqualToString:[generator CreateParameters:tag]]);

  STValueFormat* vf = [[STValueFormat alloc] init];
  vf.FormatType = @"Unknown";
  tag = [[STTag alloc] init];
  tag.ValueFormat = vf;
  XCTAssert([@"Type=\"Default\"" isEqualToString:[generator CreateParameters:tag]]);
}

- (void)testCreateParameters_RunFrequency {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];

  tag.RunFrequency = [STConstantsRunFrequency OnDemand];
  XCTAssert([@"Frequency=\"On Demand\", Type=\"Default\"" isEqualToString:[generator CreateParameters:tag]]);

  tag = [[STTag alloc] init];
  tag.Name = @"Test";
  tag.RunFrequency = [STConstantsRunFrequency OnDemand];
  XCTAssert([@"Label=\"Test\", Frequency=\"On Demand\", Type=\"Default\"" isEqualToString:[generator CreateParameters:tag]]);

  STValueFormat* vf = [[STValueFormat alloc] init];
  vf.FormatType = @"Unknown";
  tag = [[STTag alloc] init];
  tag.ValueFormat = vf;
  XCTAssert([@"Type=\"Default\"" isEqualToString:[generator CreateParameters:tag]]);
}

- (void)testCreateParameters_EachType {
  STValueGenerator* generator = [[STValueGenerator alloc] init];
  STValueFormat* vf = [[STValueFormat alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.ValueFormat = vf;
  tag.ValueFormat.FormatType = [STConstantsValueFormatType Numeric];

  XCTAssertTrue([[generator CreateParameters:tag] hasPrefix:@"Type=\"Numeric\""]);
  XCTAssertFalse([@"Type=\"Numeric\"" isEqualToString:[generator CreateParameters:tag]]);// Should be more than the type parameter

  tag.ValueFormat.FormatType = [STConstantsValueFormatType DateTime];
  XCTAssertTrue([[generator CreateParameters:tag] hasPrefix:@"Type=\"DateTime\""]);
  XCTAssertTrue([@"Type=\"DateTime\"" isEqualToString:[generator CreateParameters:tag]]);// Should be just the type parameter by default
  
  tag.ValueFormat.DateFormat = @"MM-DD-YYYY";
  XCTAssertFalse([@"Type=\"DateTime\"" isEqualToString:[generator CreateParameters:tag]]);// Should be more than the type parameter when we have a format

  tag.ValueFormat.FormatType = [STConstantsValueFormatType Percentage];
  XCTAssertTrue([[generator CreateParameters:tag] hasPrefix:@"Type=\"Percentage\""]);
XCTAssertFalse([@"Type=\"Percentage\"" isEqualToString:[generator CreateParameters:tag]]);// Should be more than the type parameter

}


@end
