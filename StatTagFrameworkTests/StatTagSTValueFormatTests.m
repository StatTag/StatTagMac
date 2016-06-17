//
//  StatTagSTValueFormatTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STValueFormat.h"
#import "STConstants.h"


@interface StatTagSTValueFormatTests : XCTestCase

@end

@implementation StatTagSTValueFormatTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testFormatEmpty {
  STValueFormat *format = [[STValueFormat alloc] init];
  XCTAssertEqualObjects(@"", [format Format:nil]);
  XCTAssertEqualObjects(@"", [format Format:@""]);
  XCTAssertEqualObjects(@"", [format Format:@"    \t \r\n"]);
}

- (void)testFormatDefault {
  STValueFormat *format = [[STValueFormat alloc] init];
  format.FormatType = [STConstantsValueFormatType Default];
  XCTAssertEqualObjects(@"My string", [format Format:@"My string"]);
  XCTAssertEqualObjects(@"1234.56789\r\n", [format Format:@"1234.56789\r\n"]);
}

- (void)testFormatNumeric {

  STValueFormat *format = [[STValueFormat alloc] init];
  format.FormatType = [STConstantsValueFormatType Numeric];

  XCTAssertEqualObjects(@"", [format Format:@"Not a number"]);
  XCTAssertEqualObjects(@"0", [format Format:@"0.0"]);
  XCTAssertEqualObjects(@"1", [format Format:@"1.11"]); // Default numeric format
  XCTAssertEqualObjects(@"1235", [format Format:@"1234.56789"]); // Rounds up
  format.DecimalPlaces = 2;
  XCTAssertEqualObjects(@"1234.57", [format Format:@"1234.56789"]); // Rounds up with decimal places
  format.DecimalPlaces = 10;
  XCTAssertEqualObjects(@"1234.5678900000", [format Format:@"1234.56789"]); // Rounds up with decimal places

  format.DecimalPlaces = 0;
  format.UseThousands = true;
  XCTAssertEqualObjects(@"1,234", [format Format:@"1234"]);
  format.DecimalPlaces = 2;
  XCTAssertEqualObjects(@"1,234.57", [format Format:@"1234.567"]);
  format.DecimalPlaces = 1;
  XCTAssertEqualObjects(@"1.0", [format Format:@"1"]);
  format.DecimalPlaces = 0;
  XCTAssertEqualObjects(@"1,234,567,890", [format Format:@"1234567890"]);

  format.AllowInvalidTypes = true;
  XCTAssertEqualObjects(@"test", [format Format:@"test"]);

}

- (void)testEquals {
  
  STValueFormat *firstObject = [[STValueFormat alloc] init];
  firstObject.DateFormat = @"DateTest";
  firstObject.DecimalPlaces = 1;
  firstObject.FormatType = @"FormatTest";
  firstObject.TimeFormat = @"TimeTest";
  firstObject.UseThousands = true;

  STValueFormat *secondObject = [[STValueFormat alloc] init];
  secondObject.DateFormat = @"DateTest";
  secondObject.DecimalPlaces = 1;
  secondObject.FormatType = @"FormatTest";
  secondObject.TimeFormat = @"TimeTest";
  secondObject.UseThousands = true;

  XCTAssert([firstObject isEqual:secondObject]); //they have the same contents
  XCTAssert([secondObject isEqual:firstObject]); //they have the same contents
  XCTAssertEqualObjects(firstObject, secondObject);
  XCTAssertEqualObjects(secondObject, firstObject);

  XCTAssertNotEqual(firstObject, secondObject);  //but are not the same object
  //these aren't valid comparison operators in obj-c (for this test case)
  // in c# this is a shorthand form of isEqual - in obj-c it's "are they the same object" (in memory)
  //  Assert.IsTrue(firstObject == secondObject);
  //  Assert.IsTrue(secondObject == firstObject);

  secondObject.DateFormat = [NSString stringWithFormat:@"%@1", [secondObject DateFormat]];
  NSLog(@"DateFormat: %@", secondObject.DateFormat);
  XCTAssertFalse([firstObject isEqualTo:secondObject]);
  XCTAssertFalse([secondObject isEqualTo:firstObject]);
  XCTAssertNotEqualObjects(firstObject, secondObject);
  XCTAssertNotEqualObjects(secondObject, firstObject);
  //ditto on not doing these
//  Assert.IsFalse(firstObject == secondObject);
//  Assert.IsFalse(secondObject == firstObject);

  
}

- (void)testRepeat {
  //NSLog([STValueFormat Repeat:@"a" count:5]);
  XCTAssert([@"aaaaa" isEqualToString:[STValueFormat Repeat:@"a" count:5]]);

  //NSLog(@"aA: %@", [STValueFormat Repeat:@"aA" count:3]);
  XCTAssert([@"aAaAaA" isEqualToString:[STValueFormat Repeat:@"aA" count:3]]);

  //NSLog(@"[empty]: %@", [STValueFormat Repeat:@"" count:3]);
  XCTAssert([@"" isEqualToString:[STValueFormat Repeat:@"" count:3]]);

  XCTAssert([@"" isEqualToString:[STValueFormat Repeat:@"test" count:0]]);

  //NSLog(@"[nil]: %@", [STValueFormat Repeat:nil count:5]);
  XCTAssert([@"" isEqualToString:[STValueFormat Repeat:nil count:5]]);

}


@end
