//
//  StatTagModelFieldTagTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagModelFieldTagTests : XCTestCase

@end

@implementation StatTagModelFieldTagTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testConstructor_Empty {
  STFieldTag *fieldTag = [[STFieldTag alloc] init];
  XCTAssertNil([fieldTag TableCellIndex]);  
}

- (void)testConstructor_Tag {
  STTag* tag = [STTag tagWithName:@"Test" andCodeFile:nil andType:[STConstantsTagType Value]];
  STFieldTag* fieldTag = [[STFieldTag alloc] initWithTag:tag];

  NSLog(@"[tag Name] : %@, [fieldTag Name] : %@", [tag Name], [fieldTag Name]);
  XCTAssert([[tag Name] isEqualToString:[fieldTag Name]]);
  NSLog(@"[tag Type] : %@, [fieldTag Type] : %@", [tag Type], [fieldTag Type]);
  XCTAssert([[tag Type] isEqualToString:[fieldTag Type]]);
  NSLog(@"[fieldTag class] : %@", [fieldTag class]);
  XCTAssertNil([fieldTag TableCellIndex]);
}

- (void)testConstructor_TagWithIndex {
  
  STTag* tag = [STTag tagWithName:@"Test" andCodeFile:nil andType:[STConstantsTagType Table]];

  STFieldTag* fieldTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:@10];

  XCTAssert([[tag Name] isEqualToString:[fieldTag Name]]);
  XCTAssert([[tag Type] isEqualToString:[fieldTag Type]]);
  XCTAssertEqual(10, [[fieldTag TableCellIndex] integerValue]);

  fieldTag = [[STFieldTag alloc] initWithTag:tag];
  XCTAssertNil([fieldTag TableCellIndex]);
}

- (void)testConstructor_TagWithFieldTag {
}

- (void)testConstructor_NullTagWithFieldTag {
}

- (void)testConstructor_TagWithIndex_TableCell {
}

- (void)testConstructor_Copy {
}

- (void)testSerialize_Deserialize {
}

- (void)testLinkToCodeFile_Found {
}

- (void)testLinkToCodeFile_NotFound {
}


@end
