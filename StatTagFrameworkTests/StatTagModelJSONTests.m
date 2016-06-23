//
//  StatTagModelJSONTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagModelJSONTests : XCTestCase

@end

@implementation StatTagModelJSONTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testCodeFile {
  
  //set up our inital objects
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setCalendar:calendar];
  [components setYear:2016];
  [components setMonth:01];
  [components setDay:01];
  [components setHour:1];
  [components setMinute:2];
  [components setSecond:3];
  
  NSDate *d1 = [calendar dateFromComponents:components];

  [components setYear:2015];
  [components setMonth:06];
  [components setSecond:46];
  NSDate *d2 = [calendar dateFromComponents:components];
  
  STCodeFile* cf = [[STCodeFile alloc] init];
  cf.StatisticalPackage = @"ABC";
  cf.FilePath = [[NSURL alloc] initWithString:@"myfile.txt"];
  cf.LastCached = d1;

  STCodeFile* cf2 = [[STCodeFile alloc] init];
  cf2.StatisticalPackage = @"DEF";
  cf2.FilePath = [[NSURL alloc] initWithString:@"secondfile.txt"];
  cf2.LastCached = d2;
  
  //built the array and serialize it to json
  NSArray<STCodeFile*>* ar1 = [NSArray arrayWithObjects:cf, cf2, nil];
  NSString* json = [STCodeFile SerializeList:ar1 error:nil];
  
  //now from json back to objects -> array
  NSArray* ar = [STCodeFile DeserializeList:json error:nil];

  //validate
  XCTAssert([[ar[0] StatisticalPackage] isEqualToString:@"ABC"]);
  XCTAssert([[[ar[0] FilePath] path] isEqualToString:@"myfile.txt"]);
  XCTAssert([[ar[0] LastCached] isEqualToDate:d1]);

  XCTAssert([[ar[1] StatisticalPackage] isEqualToString:@"DEF"]);
  XCTAssert([[[ar[1] FilePath] path] isEqualToString:@"secondfile.txt"]);
  XCTAssert([[ar[1] LastCached] isEqualToDate:d2]);
}


@end
