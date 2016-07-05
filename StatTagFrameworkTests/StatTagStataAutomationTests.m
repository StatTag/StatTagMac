//
//  StatTagStataAutomationTests.m
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagStataAutomationTests : XCTestCase

@end

@implementation StatTagStataAutomationTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testAppRunCommand {
  
}

- (void)testAppShow {
  STStataAutomation* app = [[STStataAutomation alloc] init];
  [app Show];
}

- (void)testAppHide {
  STStataAutomation* app = [[STStataAutomation alloc] init];
  [app Show];
  [NSThread sleepForTimeInterval:3.0f];
  [app Hide];
}

- (void)testInitialize {
  bool passed = [[[STStataAutomation alloc] init] Initialize];
  XCTAssert(passed);
}

- (void)testAppPath {
  NSURL* appPath = [STStataAutomation AppPath];
  NSLog(@"appPath : %@", appPath);
}

- (void)testAppIsRunning {
  BOOL running = false;
  running = [STStataAutomation IsAppRunning];
  //NSLog(@"Stata is running: %hhd", running);
  //this seems to work - not sure we can really test this w/o true manual intervention
}

- (void)testAppInstalled {
  BOOL installed = false;
  installed = [STStataAutomation IsAppInstalled];
  //NSLog(@"Stata is installed: %hhd", installed);
  XCTAssert(installed);
}


@end
