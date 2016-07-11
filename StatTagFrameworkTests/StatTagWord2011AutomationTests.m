//
//  StatTagWord2011AutomationTests.m
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagWord2011AutomationTests : XCTestCase

@end

@implementation StatTagWord2011AutomationTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testExample {

  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  NSLog(@"app : %@", app);

  NSLog(@"app -> isRunning : %hhd", [app isRunning]);
  
  STMSWord2011Document* doc = [app activeDocument];
  NSLog(@"doc : %@", doc);
  
  NSLog(@"doc -> fullname : %@", [doc fullName]);
  NSLog(@"doc -> variables (count) : %lu", (unsigned long)[[doc variables] count]);
  NSLog(@"doc -> variables : %@", [doc variables]);

  STDocumentManager* manager = [[STDocumentManager alloc] init];
  
  
  [manager LoadCodeFileListFromDocument:doc];
  NSLog(@"%@", [manager GetCodeFileList]);
  [manager AddCodeFile:@"file2.txt"];
  [manager AddCodeFile:@"file3.txt"];
  NSLog(@"%@", [manager GetCodeFileList]);
  
  
}


@end
