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


@interface StatTagModelValueFormatTests : XCTestCase

@end

@implementation StatTagModelValueFormatTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


//MARK: C# tests

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


-(void) testFormatNumericEuropean
{
  
  //force us-english for the app so we know our starting point
  [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en_US", @"en", nil] forKey:@"AppleLanguages"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  STValueFormat* format = [[STValueFormat alloc] init];
  format.FormatType = [STConstantsValueFormatType Numeric];
  format.CurrentLocale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];
  //    Thread.CurrentThread.CurrentCulture = new CultureInfo("de-DE");

  XCTAssert([@"" isEqualToString:[format Format:@"Not a number"]]);
  XCTAssert([@"0" isEqualToString:[format Format:@"0,0"]]);
  XCTAssert([@"1" isEqualToString:[format Format:@"1,11"]]); // Default numeric format
  XCTAssert([@"1235" isEqualToString:[format Format:@"1234,56789"]]);
  
  format.DecimalPlaces = 2;
  XCTAssert([@"1234,57" isEqualToString:[format Format:@"1234,56789"]]);// Rounds up with decimal places
  
  format.DecimalPlaces = 10;
  XCTAssert([@"1234,5678900000" isEqualToString:[format Format:@"1234,56789"]]);// Rounds up with decimal places

  format.DecimalPlaces = 0;
  format.UseThousands = YES;
  XCTAssert([@"1.234" isEqualToString:[format Format:@"1234"]]);

  format.DecimalPlaces = 2;
  XCTAssert([@"1.234,57" isEqualToString:[format Format:@"1234,57"]]);

  format.DecimalPlaces = 1;
  XCTAssert([@"1,0" isEqualToString:[format Format:@"1"]]);
  
  format.DecimalPlaces = 0;
  XCTAssert([@"1.234.567.890" isEqualToString:[format Format:@"1234567890"]]);

  format.AllowInvalidTypes = YES;
  XCTAssert([@"test" isEqualToString:[format Format:@"test"]]);
}

- (void)testFormatPercentage {
  STValueFormat *format = [[STValueFormat alloc] init];
  format.FormatType = [STConstantsValueFormatType Percentage];

  XCTAssertEqualObjects(@"", [format Format:@"Not a number"]);
  XCTAssertEqualObjects(@"111%", [format Format:@"1.11"]);
  XCTAssertEqualObjects(@"12%", [format Format:@"0.1234"]);
  format.DecimalPlaces = 2;
  XCTAssertEqualObjects(@"12.35%", [format Format:@"0.123456789"]); // Rounds up with decimal places
  format.DecimalPlaces = 10;
  XCTAssertEqualObjects(@"12.3400000000%", [format Format:@"0.1234"]); // Rounds up with decimal places
  
  format.AllowInvalidTypes = true;
  XCTAssertEqualObjects(@"test", [format Format:@"test"]);
  
}


- (void)testFormatDateTime {

  // Date only
  STValueFormat *format = [[STValueFormat alloc] init];
  format.FormatType = [STConstantsValueFormatType DateTime];
  XCTAssertEqualObjects(@"", [format Format:@"Not a date"]);
  format.DateFormat = [STConstantsDateFormats MMDDYYYY];
  XCTAssertEqualObjects(@"03/11/2012", [format Format:@"3/11/2012"]);
  XCTAssertEqualObjects(@"11/11/2011", [format Format:@"11/11/11 11:11"]);
  //NSLog(@"FORMAT: %@", [format Format:@"11/11/11 11:11"]);
  format.DateFormat = [STConstantsDateFormats MonthDDYYYY];
  XCTAssertEqualObjects(@"March 11, 2012", [format Format:@"3/11/2012"]);
  XCTAssertEqualObjects(@"November 11, 2011", [format Format:@"11/11/11 11:11:11"]);
  
  // Time only
  format.DateFormat = @"";
  format.TimeFormat = [STConstantsTimeFormats HHMM];

//  NSLog(@"format 1: %@", [format Format:@"01:30:50"]);
//  NSLog(@"format 2: %@", [format Format:@"02:30:50"]);
//  NSLog(@"format 3: %@", [format Format:@"03:30:50"]);
//  NSLog(@"format 4: %@", [format Format:@"04:30:50"]);
//  NSLog(@"format 5: %@", [format Format:@"05:30:50"]);
//  NSLog(@"format 6: %@", [format Format:@"06:30:50"]);
//  NSLog(@"format 7: %@", [format Format:@"07:30:50"]);
//  NSLog(@"format 8: %@", [format Format:@"08:30:50"]);
//  NSLog(@"format 9: %@", [format Format:@"09:30:50"]);
//  NSLog(@"format 10: %@", [format Format:@"10:30:50"]);
//  NSLog(@"format 11: %@", [format Format:@"11:30:50"]);
//  NSLog(@"format 11: %@", [format Format:@"12:30:50"]);

  
  XCTAssertEqualObjects(@"11:30", [format Format:@"11:30:50"]);
  NSLog(@"format: %@", [format Format:@"11:30:50"]);
  format.TimeFormat = [STConstantsTimeFormats HHMMSS];
  XCTAssertEqualObjects(@"15:30:50", [format Format:@"11/11/11 15:30:50"]);
  
  // Date and time
  format.DateFormat = [STConstantsDateFormats MMDDYYYY];
  format.TimeFormat = [STConstantsTimeFormats HHMMSS];
  XCTAssertEqualObjects(@"03/11/2012 11:30:00", [format Format:@"3/11/2012 11:30"]);

  format.AllowInvalidTypes = true;
  XCTAssertEqualObjects(@"test", [format Format:@"test"]);
  
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


//MARK: additional Cocoa date/time tests (to address weirdness with data detectors, etc.


-(NSDate*)extractDate:(NSString*)value {
  
  NSDate *dateValue;
  //NSTimeZone *timeZone = [NSTimeZone localTimeZone];
  
  //Let's see if we can get the formatted date - we should be careful of locale here...
  //http://stackoverflow.com/questions/5135482/how-to-determine-if-locales-date-format-is-month-day-or-day-month
  
  //  BOOL dayFirst = [[NSDateFormatter dateFormatFromTemplate:@"MMMMd" options:0 locale:[NSLocale currentLocale]] hasPrefix:@"d"];
  //
  //  NSArray *likelyFormats = @[
  //              @"dd/MM/yyyy",
  //              @"dd/MM/yyyy hh:mm a",
  //
  //              @"MM/dd/yyyy",
  //              @"MM/dd/yyyy hh:mm a"
  //            ];
  //  NSMutableArray *dateFormats = [[NSMutableArray alloc] init];
  
  NSArray *dateFormats = @[@"hh:mm a", @"hh:mm"];
  
  //add times
  //@[@"dd/MM/yyyy",@"hh:mm a",@"hh:mm",@"dd/MM/yyyy hh:mm a"];
  
  NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
  
  for (NSString *dateFormat in dateFormats) {
    [formatter setDateFormat:dateFormat];
    dateValue = [formatter dateFromString:value];
    if (dateValue) {
      return dateValue;
    }
  }
  
  //failing that, let's see if we can detect the date using a data detector
  NSError *error = NULL;
  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeDate error:&error];
  
  NSArray *matches = [detector matchesInString:value options:0 range:NSMakeRange(0, [value length])];
  
  for (NSTextCheckingResult *match in matches) {
    if ([match resultType] == NSTextCheckingTypeDate) {
      dateValue = [match date];
      if(dateValue) {
        return dateValue;
      }
    }
  }
  
  //nothing
  return dateValue;
}

-(NSString*)extractTime:(NSString*)value {
  
  //  NSError *error = NULL;
  //  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeDate error:&error];
  //
  //  NSArray *matches = [detector matchesInString:value options:0 range:NSMakeRange(0, [value length])];
  //  NSDate *dateValue;
  //
  //  for (NSTextCheckingResult *match in matches) {
  //    if ([match resultType] == NSTextCheckingTypeDate) {
  //      dateValue = [match date];
  //    }
  //  }
  
  NSDate *dateValue = [self extractDate:value];
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"HH:mm"];
  NSString *time = [formatter stringFromDate:dateValue];
  
  NSLog(@"original:%@ got_date:%@ formatted_time:%@", value, dateValue, time);
  
  return time;
}

-(void)testTimeExtraction {
  
  NSArray<NSString*>* times = @[
                                @"00:30", @"1:30", @"2:30", @"3:30", @"4:30", @"5:30", @"6:30",
                                @"07:30", @"8:30", @"9:30", @"10:30", @"11:30", @"12:30", @"13:30",
                                @"14:30", @"15:30", @"16:30", @"17:30", @"18:30", @"19:30", @"20:30",
                                @"21:30", @"22:30", @"23:30", @"01:30pm", @"02:30pm", @"03:30pm"
                                ];
  
  for(NSString *time in times) {
    NSLog(@"%@", [self extractTime:time]);
  }
  
  //try this...
  //http://stackoverflow.com/questions/3485209/how-do-i-parse-a-date-string-in-an-unknown-format-on-iphone/36018114#36018114
  //http://stackoverflow.com/questions/16056310/how-to-parse-varied-string-dates
  
}


@end
