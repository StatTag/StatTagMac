//
//  StatTagUtilityTagUtilTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagUtilityTagUtilTests : XCTestCase

@end

@implementation StatTagUtilityTagUtilTests

NSMutableArray<STCodeFile*>* DuplicateTags;
NSMutableArray<STCodeFile*>* DistinctTags;

-(void)InitializeCodeFiles:(NSArray<STCodeFile*>*)codeFiles
{
  for(STCodeFile* codeFile in codeFiles)
  {
    for(STTag* tag in [codeFile Tags])
    {
      tag.CodeFile = codeFile;
    }
  }
}



- (void)setUp {
  [super setUp];
  
  DuplicateTags = [[NSMutableArray<STCodeFile*> alloc] init];
  DistinctTags = [[NSMutableArray<STCodeFile*> alloc] init];
  
  STCodeFile* cf;
  STTag *tag;
  
  //DistinctTags
  //------------------
  // test 1 --------
  cf = [[STCodeFile alloc] init];
  cf.FilePath = [NSURL URLWithString:@"Test1"];
  cf.Tags = [[NSMutableArray<STTag*> alloc] init];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  [cf.Tags addObject:tag];

  tag = [[STTag alloc] init];
  tag.Name = @"Test2";
  [cf.Tags addObject:tag];

  [DistinctTags addObject:cf];

  // test 2 --------
  cf = [[STCodeFile alloc] init];
  cf.FilePath = [NSURL URLWithString:@"Test2"];
  cf.Tags = [[NSMutableArray<STTag*> alloc] init];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test3";
  [cf.Tags addObject:tag];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test4";
  [cf.Tags addObject:tag];
  
  [DistinctTags addObject:cf];
  //------------------
  
  
  
  //DuplicateTags
  //------------------
  // test 1 --------
  cf = [[STCodeFile alloc] init];
  cf.FilePath = [NSURL URLWithString:@"Test1"];
  cf.Tags = [[NSMutableArray<STTag*> alloc] init];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  [cf.Tags addObject:tag];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test2";
  [cf.Tags addObject:tag];

  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  [cf.Tags addObject:tag];

  [DuplicateTags addObject:cf];

  // test 1 --------
  cf = [[STCodeFile alloc] init];
  cf.FilePath = [NSURL URLWithString:@"Test2"];
  cf.Tags = [[NSMutableArray<STTag*> alloc] init];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  [cf.Tags addObject:tag];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test2";
  [cf.Tags addObject:tag];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
//  NSLog(@"tag.Name = %@", [tag Name]);
  [cf.Tags addObject:tag];
//  NSLog(@"cf.Tags = %@", [cf Tags]);
  
  [DuplicateTags addObject:cf];
  //------------------

  [self InitializeCodeFiles:DistinctTags];
  [self InitializeCodeFiles:DuplicateTags];
  
  
//  NSLog(@"DistinctTags : %@", DistinctTags);
//  NSLog(@"DistinctTags[0] -> Tags : %@", [DistinctTags[0] Tags]);
//  NSLog(@"DistinctTags[1] -> Tags : %@", [DistinctTags[1] Tags]);
//
//  NSLog(@"DuplicateTags : %@", DuplicateTags);
//  NSLog(@"DuplicateTags[0] -> Tags : %@", [DuplicateTags[0] Tags]);
//  NSLog(@"DuplicateTags[1] -> Tags : %@", [DuplicateTags[1] Tags]);
//  NSLog(@"DuplicateTags[1] -> Tags[0] : %@", [DuplicateTags[1] Tags][0]);

//    NSLog(@"DuplicateTags[1] -> Tags[0][Name] : %@", [[DuplicateTags[1] Tags][0] Name]);
  
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testFindTagsByName_NullAndEmpty {
  XCTAssertNil([STTagUtil FindTagsByName:@"" files:nil]);
  XCTAssertNil([STTagUtil FindTagsByName:nil files:[[NSArray<STCodeFile*> alloc] init]]);
}

- (void)testFindTagsByName_SingleResults {
  XCTAssertEqual(0, [[STTagUtil FindTagsByName:@"" files:DistinctTags] count]);
  NSArray<STTag*>* tags = [STTagUtil FindTagsByName:@"Test3" files:DistinctTags];
  XCTAssertEqual(1, [tags count]);
  XCTAssert([@"Test2" isEqualToString:[[[tags[0] CodeFile] FilePath] path]]);
}

- (void)testFindTagsByName_MultipleResults {
  XCTAssertEqual(0, [[STTagUtil FindTagsByName:@"" files:DuplicateTags] count]);
  NSArray<STTag*>* tags = [STTagUtil FindTagsByName:@"test1" files:DuplicateTags];
  XCTAssertEqual(4, [tags count]);
}

- (void)testCheckForDuplicateLabels_Null {
  XCTAssertNil([STTagUtil CheckForDuplicateLabels:nil files:nil]);
  XCTAssertNil([STTagUtil CheckForDuplicateLabels:nil files:[[NSArray<STCodeFile*> alloc] init]]);
  
  STTag* tag = [[STTag alloc] init];
  tag.Name = @"test";
  
  XCTAssertNil([STTagUtil CheckForDuplicateLabels:tag files:[[NSArray<STCodeFile*> alloc] init]]);
  XCTAssertNil([STTagUtil CheckForDuplicateLabels:tag files:nil]);
}

- (void)testCheckForDuplicateLabels_SingleResults {
  
  // Start with an exact match (which gets ignored)
  STTag* tag = [[[DistinctTags firstObject] Tags] firstObject];
  NSDictionary<STCodeFile*, NSArray<NSNumber*>*>* results = [STTagUtil CheckForDuplicateLabels:tag files:DistinctTags];
  XCTAssertEqual(0, [results count]);
  
  // Next find one with an exactly matching label in the same file
  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  tag.CodeFile = [DistinctTags firstObject];
  results = [STTagUtil CheckForDuplicateLabels:tag files:DistinctTags];
  XCTAssertEqual(1, [results count]);

  // Next find one with an exactly matching label in a different file
  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  STCodeFile* cf = [[STCodeFile alloc] init];
  cf.FilePath = [NSURL URLWithString:@"NewCodeFile.r"];
  tag.CodeFile = cf;
  tag.CodeFile = [DistinctTags firstObject];
  results = [STTagUtil CheckForDuplicateLabels:tag files:DistinctTags];
  XCTAssertEqual(1, [results count]);

  //original c# - translation: "get the first key (STCodeFile) - then get it's FilePath"
  //Assert.AreEqual("Test1", results.First().Key.FilePath);
  XCTAssert([@"Test1" isEqualToString:[[[[results allKeys] firstObject] FilePath] path]]);
  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] firstObject]] objectAtIndex:0] integerValue]);
  XCTAssertEqual(0, [[[results objectForKey:[[results allKeys] firstObject]] objectAtIndex:1] integerValue]);
  
  // Finally, look for the same label but case insensitive
  tag = [[STTag alloc] init];
  tag.Name = @"test1";  //NOTE: case insensitive "test" (not "T"est)
  cf = [[STCodeFile alloc] init];
  cf.FilePath = [NSURL URLWithString:@"NewCodeFile.r"];
  results = [STTagUtil CheckForDuplicateLabels:tag files:DistinctTags];

  XCTAssert([@"Test1" isEqualToString:[[[[results allKeys] firstObject] FilePath] path]]);
  XCTAssertEqual(0, [[[results objectForKey:[[results allKeys] firstObject]] objectAtIndex:0] integerValue]);
  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] firstObject]] objectAtIndex:1] integerValue]);
}

  
- (void)testCheckForDuplicateLabels_MultipleResults {
  
}

- (void)testShouldCheckForDuplicateLabel {
}

- (void)testIsDuplicateLabelInSameFile {
}


@end
