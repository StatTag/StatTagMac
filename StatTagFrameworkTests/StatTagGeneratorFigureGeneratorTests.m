//
//  StatTagGeneratorFigureGeneratorTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/30/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagGeneratorFigureGeneratorTests : XCTestCase

@end

@implementation StatTagGeneratorFigureGeneratorTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCreateParameters_NoLabel {
  STFigureGenerator* generator = [[STFigureGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  XCTAssert([@"" isEqualToString:[generator CreateParameters:tag]]);
}

- (void)testCreateParameters_Label {
  STFigureGenerator* generator = [[STFigureGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Name = @"Test";
  //NSLog(@"[generator CreateParameters:tag] : %@", [generator CreateParameters:tag]);
  //NSLog(@"expected : Label=\"Test\"");
  XCTAssert([@"Label=\"Test\"" isEqualToString:[generator CreateParameters:tag]]);
}


@end
