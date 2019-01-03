//
//  StatTagConstantsTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STConstants.h"


@interface StatTagModelConstantsTests : XCTestCase

@end

@implementation StatTagModelConstantsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStatisticalPackages {
  //NSLog(@"%@", [STConstantsStatisticalPackages GetList]);
  NSArray *products = [[NSArray alloc] initWithObjects: @"Stata", @"SAS", @"R", @"R Markdown", nil];
//  NSLog(@"%@", products);
//  NSLog(@"%@", [STConstantsStatisticalPackages GetList]);
//  NSLog(@"isEqual = %hhd", [products isEqualToArray: [STConstantsStatisticalPackages GetList] ]);
  XCTAssert([products isEqualToArray: [STConstantsStatisticalPackages GetList] ]);
}


@end
