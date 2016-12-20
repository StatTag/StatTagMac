//
//  StatTagModelFilterFormatTests.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STFilterFormat.h"


@interface StatTagModelFilterFormatTests : XCTestCase

@end

@implementation StatTagModelFilterFormatTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

-(void) testEquals
{
  STFilterFormat* filter1 = [[STFilterFormat alloc] initWithPrefix:@"A"];
  [filter1 setEnabled: YES];
  [filter1 setType:@"1"];
  [filter1 setValue:@"1"];
  
  STFilterFormat* filter2 = [[STFilterFormat alloc] initWithPrefix:@"A"];
  [filter2 setEnabled: NO];
  [filter2 setType:@"2"];
  [filter2 setValue:@"2"];
  
  STFilterFormat* filter3 = [[STFilterFormat alloc] initWithPrefix:@"B"];
  [filter2 setEnabled: YES];
  [filter2 setType:@"1"];
  [filter2 setValue:@"1"];
  
  STFilterFormat* filter4 = [[STFilterFormat alloc] initWithPrefix:@"A"];
  [filter4 setEnabled: YES];
  [filter4 setType:@"1"];
  [filter4 setValue:@"1"];
  
  XCTAssert([filter1 isEqualTo:filter1]);
  XCTAssert([filter1 isEqualTo:filter2]);
  //XCTAssertNotEqual(nil, filter1);
  //XCTAssertNotEqual(filter1, nil);
  XCTAssertFalse([filter1 isEqualTo:filter3]);
  XCTAssert([filter1 isEqualTo:filter4]);
}

-(void) testExpandValue_Empty
{
  STFilterFormat* format = [[STFilterFormat alloc] initWithPrefix:@"Test"];
  [format setValue:nil];
  
  XCTAssertNil([format ExpandValue]);
  
  [format setValue: @""];
  XCTAssertNil([format ExpandValue]);
  
  [format setValue: @"     "];
  XCTAssertNil([format ExpandValue]);
}

/*
 [ExpectedException(typeof(InvalidDataException))]
 -(void) testExpandValue_NonNumeric
 {
 var format = new FilterFormat("Test") {Value = "A"};
 [format ExpandValue];
 }
 
 [ExpectedException(typeof(InvalidDataException))]
 -(void) testExpandValue_UnfinishedRange
 {
 var format = new FilterFormat("Test") {Value = "1-"};
 [format ExpandValue];
 }
 
 [ExpectedException(typeof(InvalidDataException))]
 -(void) testExpandValue_NegativeValues
 {
 var format = new FilterFormat("Test") {Value = "-2-5"};
 [format ExpandValue];
 }
 
 [ExpectedException(typeof(InvalidDataException))]
 -(void) testExpandValue_BlankComponent
 {
 var format = new FilterFormat("Test") {Value = ",2-5"};
 [format ExpandValue];
 }
 
 [ExpectedException(typeof(InvalidDataException))]
 -(void) testExpandValue_ZeroValue
 {
 var format = new FilterFormat("Test") {Value = "0"};
 [format ExpandValue];
 }
 */

-(void) testExpandValue_SingleValues
{
  STFilterFormat* format = [[STFilterFormat alloc] initWithPrefix:@"Test"];
  [format setValue:@"1"];
  
  NSArray<NSNumber*>* values = [format ExpandValue];
  XCTAssertEqual(1, [values count]);
  XCTAssertEqual(0, [values[0] intValue]);
  
  // Throwing in some extra spaces for fun
  format.Value = @"  1,3, 5 ";
  values = [format ExpandValue];
  XCTAssertEqual(3, [values count]);
  XCTAssertEqual(0, [values[0] intValue]);
  XCTAssertEqual(2, [values[1] intValue]);
  XCTAssertEqual(4, [values[2] intValue]);
  
  // Make sure it will sort the values
  format.Value = @"5,1,3";
  values = [format ExpandValue];
  XCTAssertEqual(3, [values count]);
  XCTAssertEqual(0, [values[0] intValue]);
  XCTAssertEqual(2, [values[1] intValue]);
  XCTAssertEqual(4, [values[2] intValue]);
  
  // Make sure we remove duplicates
  format.Value = @"5,1,3,5,1,3,3,3";
  values = [format ExpandValue];
  XCTAssertEqual(3, [values count]);
  XCTAssertEqual(0, [values[0] intValue]);
  XCTAssertEqual(2, [values[1] intValue]);
  XCTAssertEqual(4, [values[2] intValue]);
}

-(void) testExpandValue_Ranges
{
  STFilterFormat* format = [[STFilterFormat alloc] initWithPrefix:@"Test"];
  [format setValue:@"3-5"];

  NSArray<NSNumber*>* values = [format ExpandValue];
  XCTAssertEqual(3, [values count]);
  XCTAssertEqual(2, [values[0] intValue]);
  XCTAssertEqual(3, [values[1] intValue]);
  XCTAssertEqual(4, [values[2] intValue]);
  
  // Flipped range
  format.Value = @"5-3";
  values = [format ExpandValue];
  XCTAssertEqual(3, [values count]);
  XCTAssertEqual(2, [values[0] intValue]);
  XCTAssertEqual(3, [values[1] intValue]);
  XCTAssertEqual(4, [values[2] intValue]);
  
  // Single value range (we will allow this)
  format.Value = @"3-3";
  values = [format ExpandValue];
  XCTAssertEqual(1, [values count]);
  XCTAssertEqual(2, [values[0] intValue]);
  
  // Multiple ranges, no overlap
  format.Value = @"3-4,6-7";
  values = [format ExpandValue];
  XCTAssertEqual(4, [values count]);
  XCTAssertEqual(2, [values[0] intValue]);
  XCTAssertEqual(3, [values[1] intValue]);
  XCTAssertEqual(5, [values[2] intValue]);
  XCTAssertEqual(6, [values[3] intValue]);
  
  // Multiple ranges, with overlap
  format.Value = @"3-6,4-7";
  values = [format ExpandValue];
  XCTAssertEqual(5, [values count]);
  XCTAssertEqual(2, [values[0] intValue]);
  XCTAssertEqual(3, [values[1] intValue]);
  XCTAssertEqual(4, [values[2] intValue]);
  XCTAssertEqual(5, [values[3] intValue]);
  XCTAssertEqual(6, [values[4] intValue]);
}

-(void) testExpandValue_ValuesAndRanges
{
  STFilterFormat* format = [[STFilterFormat alloc] initWithPrefix:@"Test"];
  [format setValue:@"1,3-5"];

  NSArray<NSNumber*>* values = [format ExpandValue];
  XCTAssertEqual(4, [values count]);
  XCTAssertEqual(0, [values[0] intValue]);
  XCTAssertEqual(2, [values[1] intValue]);
  XCTAssertEqual(3, [values[2] intValue]);
  XCTAssertEqual(4, [values[3] intValue]);
  
  // Overlap
  format.Value = @"3-5, 4, 5-5, 6-3";
  values = [format ExpandValue];
  XCTAssertEqual(4, [values count]);
  XCTAssertEqual(2, [values[0] intValue]);
  XCTAssertEqual(3, [values[1] intValue]);
  XCTAssertEqual(4, [values[2] intValue]);
  XCTAssertEqual(5, [values[3] intValue]);
}

@end
