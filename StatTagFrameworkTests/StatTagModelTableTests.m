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

- (void)testNestedArray {
  NSMutableArray<NSMutableArray<NSString*>*>* data = [[NSMutableArray<NSMutableArray<NSString*>*> alloc] init];
  NSLog(@"outer array count : %lu", (unsigned long)[data count]);
  NSLog(@"inner array count : %lu", (unsigned long)[[data objectAtIndex:0] count]);
}


@end
