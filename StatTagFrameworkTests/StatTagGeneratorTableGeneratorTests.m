//
//  StatTagGeneratorTableGeneratorTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/30/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagGeneratorTableGeneratorTests : XCTestCase

@end

@implementation StatTagGeneratorTableGeneratorTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCreateParameters_NoLabel {
  STTableGenerator* generator = [[STTableGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  XCTAssert([@"" isEqualToString:[generator CreateParameters:tag]]);
}

- (void)testCreateParameters_Label {
  STTableGenerator* generator = [[STTableGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Name = @"Test";
  XCTAssert([@"Label=\"Test\"" isEqualToString:[generator CreateParameters:tag]]);
}


@end
