//
//  StatTagModelStataTests.m
//  StatTag
//
//  Created by Eric Whitley on 12/19/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagModelStataTests : XCTestCase

@end

@implementation StatTagModelStataTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

-(void)testCommentCharacter
{
  XCTAssertEqual([STConstantsCodeFileComment Stata], [[[STStataParser alloc] init] CommentCharacter]);
}


@end
