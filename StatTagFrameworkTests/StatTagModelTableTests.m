//
//  StatTagModelTableTests.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagModelTableTests : XCTestCase

@end

@implementation StatTagModelTableTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

//- (void)testNestedArray {
//  NSMutableArray<NSMutableArray<NSString*>*>* data = [[NSMutableArray<NSMutableArray<NSString*>*> alloc] init];
//  NSLog(@"outer array count : %lu", (unsigned long)[data count]);
//  NSLog(@"inner array count : %lu", (unsigned long)[[data objectAtIndex:0] count]);
//}

-(void)testEmptyConstructor
{
  STTable* table = [[STTable alloc] init];
  XCTAssertEqual(0, [table RowSize]);
  XCTAssertEqual(0, [table ColumnSize]);
  //TEST CASE DEVIATION
  XCTAssertNotNil([table Data]);//original was expecting NIL
  XCTAssertNil([table FormattedCells]);
}


-(void)testDataConstructor
{
  STTable* table = [[STTable alloc] init:2 columnSize:3 data:[[STTableData alloc] initWithData:@[@[@"1", @"2", @"3" ], @[@"4", @"5", @"6"]]]];
  
  XCTAssertEqual(2, [table RowSize]);
  XCTAssertEqual(3, [table ColumnSize]);
  XCTAssertNotNil([table Data]);
  XCTAssertEqual(6, [[table Data] numItems]);
}


-(void)testDataConstructor_Empty
{
  STTable* table = [[STTable alloc] init:0 columnSize:3 data:nil];
  XCTAssertEqual(0, [table RowSize]);
  XCTAssertEqual(3, [table ColumnSize]);
  XCTAssertNil([table Data]);
}


//[ExpectedException(typeof(Exception))]
-(void)testDataConstructor_Invalid
{
  @try {
    STTable* table __unused = [[STTable alloc] init:2 columnSize:2 data:[[STTableData alloc] initWithData:@[@[@"1", @"2", @"3"], @[@"4", @"5", @"6" ] ]]];
    XCTAssertTrue(false);
  }
  @catch (NSException *exception) {
    XCTAssertTrue(true);
  }
}


-(void)testIsEmpty
{
  
  STTable* table = [[STTable alloc] init:2 columnSize:3 data:[[STTableData alloc] initWithData:@[@[@"1", @"2", @"3"], @[@"4", @"5", @"6" ] ]]];
  XCTAssertFalse([table isEmpty]);

  table = [[STTable alloc] init:0 columnSize:3 data:nil];
  XCTAssert([table isEmpty]);
  
  table = [[STTable alloc] init:3 columnSize:0 data:nil];
  XCTAssert([table isEmpty]);

  table = [[STTable alloc] init];
  XCTAssert([table isEmpty]);
}


@end
