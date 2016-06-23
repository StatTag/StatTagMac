//
//  StatTagFrameworkTests.m
//  StatTagFrameworkTests
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//
//  http://stackoverflow.com/questions/28076986/xcode-tests-pass-in-isolation-fail-when-run-with-other-tests

#import <XCTest/XCTest.h>
#import "STFileHandler.h"

@interface StatTagModelFileHandlerTests : XCTestCase

@end

@implementation StatTagModelFileHandlerTests

NSBundle *bundle;
NSURL *sourceFileUrl;
NSURL *destFileUrl;


- (void)setUp {
  [super setUp];

  bundle = [NSBundle bundleForClass:[self class]];
  
  NSString *sourceFilePath = [bundle pathForResource:@"TestSourceTextFile" ofType:@"txt"];
  sourceFileUrl = [[NSURL alloc] initWithString:sourceFilePath];
  NSLog(@"Setup sourceFileUrl: %@", [sourceFileUrl path]);
  
  NSString *destFilePath = [bundle pathForResource:@"TestDestinationTextFile" ofType:@"txt"];
  destFileUrl = [[NSURL alloc] initWithString:destFilePath];
  NSLog(@"Setup destFileUrl: %@", [destFileUrl path]);
  [self resetDestinationFile];
  
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)resetDestinationFile {
  NSFileHandle *file;
  
  file = [NSFileHandle fileHandleForUpdatingAtPath: [destFileUrl path]];
  
  if (file == nil)
    NSLog(@"Failed to open file");
  
  [file truncateFileAtOffset: 0];
  [file closeFile];
}

- (void)testFileExists {
  STFileHandler *f = [[STFileHandler alloc] init];
  NSError *error;
  BOOL success = [f Exists:sourceFileUrl error:&error];
  if(!success) {
    NSLog(@"testFileExists -> file exists: %hhd", success);
    NSLog(@"testFileExists -> error = %@", error);
  }
  XCTAssertTrue(success);
}

- (void)testFileReadAsStringArray {
  STFileHandler *f = [[STFileHandler alloc] init];
  NSError *err;
  NSArray *lines = [f ReadAllLines:sourceFileUrl error:&err];
  if(err){
    NSLog(@"testFileReadAsStringArray -> lines = %@", lines);
    NSLog(@"testFileReadAsStringArray ->err = %@", err);
  }
  XCTAssertTrue([lines count] == 3);
}

- (void)testFileWriteFromString {
  STFileHandler *f = [[STFileHandler alloc] init];
  NSError *err;
  NSArray *lines = [f ReadAllLines:sourceFileUrl error:&err];
  
  //join with newlines
  NSString *contentString = [lines componentsJoinedByString:@"\n"];
  [f WriteAllText:destFileUrl withContent:contentString error:&err];

  NSLog(@"WriteAllLines destLines err = %@", err);

  NSArray *destLines = [f ReadAllLines:destFileUrl error:&err];
  NSLog(@"destLines err = %@", err);
  XCTAssertTrue([destLines count] == 3);

}

- (void)testFileWriteFromArray {
  STFileHandler *f = [[STFileHandler alloc] init];
  NSError *err;
  NSArray *lines = [f ReadAllLines:sourceFileUrl error:&err];
  NSLog(@"lines err = %@", err);
  NSLog(@"lines = %@", lines);
  
  //let's try writing to the file from an array
  [f WriteAllLines:destFileUrl withContent:lines error:&err];
  NSLog(@"WriteAllLines destLines err = %@", err);
  
  NSArray *destLines = [f ReadAllLines:destFileUrl error:&err];
  NSLog(@"destLines err = %@", err);
  XCTAssertTrue([destLines count] == 3);
  
}

- (void)testFileCopy {
  STFileHandler *f = [[STFileHandler alloc] init];
  NSError *err;
  [f Copy:sourceFileUrl toDestinationFile:destFileUrl error:&err];
  
  if(err){
    NSLog(@"testFileCopy ->err = %@", err);
    XCTAssert(NO);
  } else {
    //NSLog(@"testFileCopy -> destFileUrl:%@", [destFileUrl path]);
    NSArray *lines = [f ReadAllLines:destFileUrl error:&err];
    //NSLog(@"testFileCopy -> lines = %@", lines);
    XCTAssertTrue([lines count] == 3);
  }
}


@end
