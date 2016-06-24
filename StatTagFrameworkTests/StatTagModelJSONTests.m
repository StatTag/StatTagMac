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
  
  //build the array and serialize it to json
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



- (void)testCodeFileAction {
  STCodeFileAction* a1 = [[STCodeFileAction alloc] init];
  a1.Label = @"a1 label";
  a1.Action = 1;
  a1.Parameter = @"a1 parameter";

  STCodeFileAction* a2 = [[STCodeFileAction alloc] init];
  a2.Label = @"a2 label";
  a2.Action = 2;
  a2.Parameter = @"a2 parameter";

  
  //build the array and serialize it to json
  NSArray<STCodeFileAction*>* ar1 = [NSArray arrayWithObjects:a1, a2, nil];
  NSString* json = [STCodeFileAction SerializeList:ar1 error:nil];
  
  //now from json back to objects -> array
  NSArray* ar2 = [STCodeFileAction DeserializeList:json error:nil];
  
  //validate
  XCTAssert([[ar2[0] Label] isEqualToString:@"a1 label"]);
  XCTAssertEqual(1, [ar2[0] Action]);
  XCTAssert([[ar2[0] Parameter] isEqualToString:@"a1 parameter"]);
  
  XCTAssert([[ar2[1] Label] isEqualToString:@"a2 label"]);
  XCTAssertEqual(2, [ar2[1] Action]);
  XCTAssert([[ar2[1] Parameter] isEqualToString:@"a2 parameter"]);
}

- (void)testTable {
  /*
   NSMutableArray<NSString*>* _RowNames;
   NSMutableArray<NSString*>* _ColumnNames;
   int _RowSize;
   int _ColumnSize;
   NSMutableArray<NSNumber*>* _Data; //type is double
   NSMutableArray<NSString*>* _FormattedCells;
   */
  
  STTable* t1 = [[STTable alloc] init];
  t1.RowNames = [NSMutableArray arrayWithArray:@[@"1_row1", @"1_row2"]];
  t1.ColumnNames = [NSMutableArray arrayWithArray:@[@"1_col1", @"1_col2"]];
  t1.Data = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4]];
  t1.RowSize = 2;
  t1.ColumnSize = 2;
  
  NSLog(@"t1.RowNames : %@", [t1 RowNames]);

  STTable* t2 = [[STTable alloc] init];
  t2.RowNames = [NSMutableArray arrayWithArray:@[@"2_row1", @"2_row2"]];
  t2.ColumnNames = [NSMutableArray arrayWithArray:@[@"2_col1", @"2_col2"]];
  t2.Data = [NSMutableArray arrayWithArray:@[@10, @20, @30, @40]];
  t2.RowSize = 2;
  t2.ColumnSize = 2;

  //build the array and serialize it to json
  NSArray<STTable*>* ar1 = [NSArray arrayWithObjects:t1, t2, nil];
  NSString* json = [STTable SerializeList:ar1 error:nil];

  //NSLog(@"json : %@", json);

  //now from json back to objects -> array
  NSArray* ar2 = [STTable DeserializeList:json error:nil];

  //validate
  XCTAssert([[ar2[0] RowNames] isEqualToArray:t1.RowNames]);
  XCTAssert([[ar2[0] ColumnNames] isEqualToArray:t1.ColumnNames]);
  XCTAssert([[ar2[0] Data] isEqualToArray:t1.Data]);
  XCTAssertEqual(t1.RowSize, [ar2[0] RowSize]);
  XCTAssertEqual(t1.ColumnSize, [ar2[0] ColumnSize]);

  XCTAssert([[ar2[1] RowNames] isEqualToArray:t2.RowNames]);
  XCTAssert([[ar2[1] ColumnNames] isEqualToArray:t2.ColumnNames]);
  XCTAssert([[ar2[1] Data] isEqualToArray:t2.Data]);
  XCTAssertEqual(t1.RowSize, [ar2[1] RowSize]);
  XCTAssertEqual(t2.ColumnSize, [ar2[1] ColumnSize]);
  
}

@end
