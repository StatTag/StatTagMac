//
//  StatTagUtilityTagUtilTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

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
  cf.FilePath = @"Test1";
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
  cf.FilePath = @"Test2";
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
  cf.FilePath = @"Test1";
  cf.Tags = [[NSMutableArray<STTag*> alloc] init];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  [cf.Tags addObject:tag];
  
  tag = [[STTag alloc] init];
  tag.Name = @"Test2";
  [cf.Tags addObject:tag];

  tag = [[STTag alloc] init];
  tag.Name = @"test1";
  [cf.Tags addObject:tag];

  [DuplicateTags addObject:cf];

  // test 1 --------
  cf = [[STCodeFile alloc] init];
  cf.FilePath = @"Test2";
  cf.Tags = [[NSMutableArray<STTag*> alloc] init];
  
  tag = [[STTag alloc] init];
  tag.Name = @"test1";
  [cf.Tags addObject:tag];
  
  tag = [[STTag alloc] init];
  tag.Name = @"test2";
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
  XCTAssert([@"Test2" isEqualToString:[[tags[0] CodeFile] FilePath] ]);
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
  cf.FilePath = @"NewCodeFile.r";
  tag.CodeFile = cf;
  tag.CodeFile = [DistinctTags firstObject];
  results = [STTagUtil CheckForDuplicateLabels:tag files:DistinctTags];
  XCTAssertEqual(1, [results count]);

  //original c# - translation: "get the first key (STCodeFile) - then get it's FilePath"
  //Assert.AreEqual("Test1", results.First().Key.FilePath);
  XCTAssert([@"Test1" isEqualToString:[[[results allKeys] firstObject] FilePath]]);
  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] firstObject]] objectAtIndex:0] integerValue]);
  XCTAssertEqual(0, [[[results objectForKey:[[results allKeys] firstObject]] objectAtIndex:1] integerValue]);
  
  // Finally, look for the same label but case insensitive
  tag = [[STTag alloc] init];
  tag.Name = @"test1";  //NOTE: case insensitive "test" (not "T"est)
  cf = [[STCodeFile alloc] init];
  cf.FilePath = @"NewCodeFile.r";
  results = [STTagUtil CheckForDuplicateLabels:tag files:DistinctTags];

  XCTAssert([@"Test1" isEqualToString:[[[results allKeys] firstObject] FilePath]]);
  XCTAssertEqual(0, [[[results objectForKey:[[results allKeys] firstObject]] objectAtIndex:0] integerValue]);
  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] firstObject]] objectAtIndex:1] integerValue]);
}

  
- (void)testCheckForDuplicateLabels_MultipleResults {
  
  // Here we simulate creating a new tag object in an existing file, which is going to have
  // the same name as an existing tag.  We will also identify those tags that have
  // case-insensitive name matches.  All of these should be identified by the check.
  
  STTag* tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  tag.CodeFile = [DuplicateTags firstObject];

  NSDictionary<STCodeFile*, NSArray<NSNumber*>*>* results = [STTagUtil CheckForDuplicateLabels:tag files:DuplicateTags];
  XCTAssertEqual(2, [results count]);

  STCodeFile* fileKey = [DuplicateTags objectAtIndex:0];
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:0] integerValue]);
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:1] integerValue]);

  fileKey = [DuplicateTags objectAtIndex:1];
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:0] integerValue]);
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:1] integerValue]);
  
  // Next find those with matching labels (both exact and non-exact) even if we're in another file
  tag = [[STTag alloc] init];
  tag.Name = @"Test1";
  STCodeFile *f = [[STCodeFile alloc] init];
  f.FilePath = @"NewCodeFile.r";
  tag.CodeFile = f;

  results = [STTagUtil CheckForDuplicateLabels:tag files:DuplicateTags];
  XCTAssertEqual(2, [results count]);
  fileKey = [DuplicateTags objectAtIndex:0];
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:0] integerValue]);
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:1] integerValue]);
  
  fileKey = [DuplicateTags objectAtIndex:1];
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:0] integerValue]);
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:1] integerValue]);

  
  //  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] objectAtIndex:0]] objectAtIndex:0] integerValue]);
//  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] objectAtIndex:0]] objectAtIndex:1] integerValue]);
//  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] objectAtIndex:1]] objectAtIndex:0] integerValue]);
//  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] objectAtIndex:1]] objectAtIndex:1] integerValue]);
  
  // Search with the first tag which is the same object as an existing one.  We should know that
  // they are the same and not count it.
  tag = [[STTag alloc] init];
  tag = [[[DuplicateTags firstObject] Tags] firstObject];
  results = [STTagUtil CheckForDuplicateLabels:tag files:DuplicateTags];
  XCTAssertEqual(2, [results count]);
  //EWW: From what I understand of both C# and Obj-C (well.. Foundation) Dictionaries, accessing by position isn't guaranteed because the dictionary order is non-deterministic.  This works, but... will it always?

  fileKey = [DuplicateTags objectAtIndex:0];
  XCTAssertEqual(0, [[[results objectForKey:fileKey] objectAtIndex:0] integerValue]);
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:1] integerValue]);
  
  fileKey = [DuplicateTags objectAtIndex:1];
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:0] integerValue]);
  XCTAssertEqual(1, [[[results objectForKey:fileKey] objectAtIndex:1] integerValue]);

  //  XCTAssertEqual(0, [[[results objectForKey:[[results allKeys] objectAtIndex:0]] objectAtIndex:0] integerValue]);
//  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] objectAtIndex:0]] objectAtIndex:1] integerValue]);
//  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] objectAtIndex:1]] objectAtIndex:0] integerValue]);
//  XCTAssertEqual(1, [[[results objectForKey:[[results allKeys] objectAtIndex:1]] objectAtIndex:1] integerValue]);
//  Assert.AreEqual(0, results.ElementAt(0).Value[0]);
//  Assert.AreEqual(1, results.ElementAt(0).Value[1]);
//  Assert.AreEqual(1, results.ElementAt(1).Value[0]);
//  Assert.AreEqual(1, results.ElementAt(1).Value[1]);
  
}

- (void)testShouldCheckForDuplicateLabel {
  
  STTag* oldTag;
  STTag* newTag;
  XCTAssertFalse([STTagUtil ShouldCheckForDuplicateLabel:oldTag newTag:newTag]);
  
  // We went from having no tag (null) to a new tag.  It should perform the check.
  newTag = [[STTag alloc] init];
  newTag.Name = @"Test";
  XCTAssertTrue([STTagUtil ShouldCheckForDuplicateLabel:oldTag newTag:newTag]);
  
  // We now have the old tag and the new tag being the same.  It should not do the check.
  oldTag = [[STTag alloc] init];
  oldTag.Name = @"Test";
  XCTAssertFalse([STTagUtil ShouldCheckForDuplicateLabel:oldTag newTag:newTag]);
  
  // The name is slightly different - now it should do the check
  oldTag = [[STTag alloc] init];
  oldTag.Name = @"test";
  XCTAssertTrue([STTagUtil ShouldCheckForDuplicateLabel:oldTag newTag:newTag]);
  
  // Finally, the new tag is null.  There's nothing there, so we do not want to do a check.
  newTag = nil;
  XCTAssertFalse([STTagUtil ShouldCheckForDuplicateLabel:oldTag newTag:newTag]);
  
}

- (void)testIsDuplicateLabelInSameFile {
  
  // We will have results for two different code files.  We will have an tag that is represented in one
  // of the code files, and one that isn't.
  NSMutableDictionary<STCodeFile*, NSArray<NSNumber*>*>* results = [[NSMutableDictionary<STCodeFile*, NSArray<NSNumber*>*> alloc] init];

  [results setObject:[NSArray<NSNumber*> arrayWithObjects:@0, @0, nil] forKey:[STCodeFile codeFileWithFilePath:@"Test1.do"]];
  [results setObject:[NSArray<NSNumber*> arrayWithObjects:@0, @0, nil] forKey:[STCodeFile codeFileWithFilePath:@"Test2.do"]];

  STTag* tagInFile = [STTag tagWithName:@"Test" andCodeFile:[[results allKeys] firstObject]];
  STTag* tagNotInFile = [STTag tagWithName:@"Test" andCodeFile:nil];
  STTag* tagInOtherFile = [STTag tagWithName:@"Test" andCodeFile:[STCodeFile codeFileWithFilePath:@"Test3.do"]];
  
  // Check our null conditions first
  XCTAssertFalse([STTagUtil IsDuplicateLabelInSameFile:nil result:results]);
  XCTAssertFalse([STTagUtil IsDuplicateLabelInSameFile:tagInFile result:nil]);
  XCTAssertFalse([STTagUtil IsDuplicateLabelInSameFile:tagNotInFile result:results]);
  
  // If the code file isn't found in the results, it means there is no duplicate.
  XCTAssertFalse([STTagUtil IsDuplicateLabelInSameFile:tagInOtherFile result:results]);
  
  // If the code file is found in the results, it only counts if there are duplicates counted in the results.
  XCTAssertFalse([STTagUtil IsDuplicateLabelInSameFile:tagInFile result:results]);
  
  // It's a duplicate once we have any kind of result.
  [results setObject:[NSArray<NSNumber*> arrayWithObjects:@1, @0, nil] forKey:[[results allKeys] firstObject]];
  XCTAssertTrue([STTagUtil IsDuplicateLabelInSameFile:tagInFile result:results]);
  [results setObject:[NSArray<NSNumber*> arrayWithObjects:@0, @1, nil] forKey:[[results allKeys] firstObject]];
  XCTAssertTrue([STTagUtil IsDuplicateLabelInSameFile:tagInFile result:results]);
  [results setObject:[NSArray<NSNumber*> arrayWithObjects:@1, @1, nil] forKey:[[results allKeys] firstObject]];
  XCTAssertTrue([STTagUtil IsDuplicateLabelInSameFile:tagInFile result:results]);
}

-(void)testDetectTagCollisionNullEmpty {
  XCTAssertNil([STTagUtil DetectTagCollision:nil]);
  XCTAssertNil([STTagUtil DetectTagCollision:[[STTag alloc] init]]);
  STCodeFile* emptyCodeFile = [[STCodeFile alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.CodeFile = emptyCodeFile;
  XCTAssertNil([STTagUtil DetectTagCollision:tag]);
}

-(void)testDetectTagCollisionNoOverlap {
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  codeFile.Tags = [[NSMutableArray<STTag*> alloc] init];

  STTag* existingTag = [STTag tagWithName:@"Test 1" andCodeFile:codeFile];
  existingTag.LineStart = [NSNumber numberWithInteger:5];
  existingTag.LineEnd = [NSNumber numberWithInteger:10];
  [[codeFile Tags] addObject:existingTag];

  // Add the new tag after the first tag
  STTag* newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:15];
  newTag.LineEnd = [NSNumber numberWithInteger:20];

  STTagCollisionResult* result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(NoOverlap, [result Collision]);
  [[codeFile Tags] addObject:newTag];

  // Add another new tag before the first tag
  STTag* tag3 = [STTag tagWithName:@"Test 3" andCodeFile:codeFile];
  tag3.LineStart = [NSNumber numberWithInteger:1];
  tag3.LineEnd = [NSNumber numberWithInteger:4];

  result = [STTagUtil DetectTagCollision:tag3];
  XCTAssertEqual(NoOverlap, [result Collision]);
  [[codeFile Tags] addObject:tag3];

  // Add one more in the middle of existing tags
  STTag* tag4 = [STTag tagWithName:@"Test 4" andCodeFile:codeFile];
  tag4.LineStart = [NSNumber numberWithInteger:11];
  tag4.LineEnd = [NSNumber numberWithInteger:14];

  result = [STTagUtil DetectTagCollision:tag4];
  XCTAssertEqual(NoOverlap, [result Collision]);
  [[codeFile Tags] addObject:tag4];
}

-(void)testDetectTagCollisionEmbeddedWithin {
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  codeFile.Tags = [[NSMutableArray<STTag*> alloc] init];

  STTag* existingTag = [STTag tagWithName:@"Test 1" andCodeFile:codeFile];
  existingTag.LineStart = [NSNumber numberWithInteger:1];
  existingTag.LineEnd = [NSNumber numberWithInteger:10];
  [[codeFile Tags] addObject:existingTag];

  // Add the new tag immediately within the existing tag
  STTag* newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:2];
  newTag.LineEnd = [NSNumber numberWithInteger:9];

  STTagCollisionResult* result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(EmbeddedWithin, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);
  [[codeFile Tags] addObject:newTag];

  // Add the new tag within the 2nd tag (to show we can detect multiple
  // levels of nesting)
  STTag* tag3 = [STTag tagWithName:@"Test 3" andCodeFile:codeFile];
  tag3.LineStart = [NSNumber numberWithInteger:4];
  tag3.LineEnd = [NSNumber numberWithInteger:7];

  result = [STTagUtil DetectTagCollision:tag3];
  XCTAssertEqual(EmbeddedWithin, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);
}

-(void)testDetectTagCollisionEmbeddedWithinBoundaryConditions {
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  codeFile.Tags = [[NSMutableArray<STTag*> alloc] init];

  STTag* existingTag = [STTag tagWithName:@"Test 1" andCodeFile:codeFile];
  existingTag.LineStart = [NSNumber numberWithInteger:2];
  existingTag.LineEnd = [NSNumber numberWithInteger:4];
  [[codeFile Tags] addObject:existingTag];

  // The new tag starts at the same position as the old tag, and ends within it
  STTag* newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:2];
  newTag.LineEnd = [NSNumber numberWithInteger:3];

  STTagCollisionResult* result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(EmbeddedWithin, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);
  [[codeFile Tags] addObject:newTag];

  // The new tag starts inside the old tag, and ends at the same position as the old tag
  STTag* tag3 = [STTag tagWithName:@"Test 3" andCodeFile:codeFile];
  tag3.LineStart = [NSNumber numberWithInteger:3];
  tag3.LineEnd = [NSNumber numberWithInteger:4];

  result = [STTagUtil DetectTagCollision:tag3];
  XCTAssertEqual(EmbeddedWithin, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);
}

-(void)testDetectTagCollisionOverlapsFront {
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  codeFile.Tags = [[NSMutableArray<STTag*> alloc] init];

  STTag* existingTag = [STTag tagWithName:@"Test 1" andCodeFile:codeFile];
  existingTag.LineStart = [NSNumber numberWithInteger:5];
  existingTag.LineEnd = [NSNumber numberWithInteger:10];
  [[codeFile Tags] addObject:existingTag];

  // First we do a true overlap, where the start and end are at different indexes
  // Note that we are NOT adding these to the code file as we go along, we're replacing
  // each of the tags with a new one for these tests
  STTag* newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:1];
  newTag.LineEnd = [NSNumber numberWithInteger:6];

  STTagCollisionResult* result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(OverlapsFront, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);

  // Next, overlap where the end of the new tag just touches the start of the existing tag
  newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:1];
  newTag.LineEnd = [NSNumber numberWithInteger:5];

  result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(OverlapsFront, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);

  // Finally, overlap where the end of the new tag touches the end of the existing tag
  newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:1];
  newTag.LineEnd = [NSNumber numberWithInteger:10];

  result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(OverlapsFront, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);
}

-(void)testDetectTagCollisionOverlapsBack {
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  codeFile.Tags = [[NSMutableArray<STTag*> alloc] init];

  STTag* existingTag = [STTag tagWithName:@"Test 1" andCodeFile:codeFile];
  existingTag.LineStart = [NSNumber numberWithInteger:5];
  existingTag.LineEnd = [NSNumber numberWithInteger:10];
  [[codeFile Tags] addObject:existingTag];

  // First we do a true overlap, where the start and end are at different indexes
  // Note that we are NOT adding these to the code file as we go along, we're replacing
  // each of the tags with a new one for these tests
  STTag* newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:6];
  newTag.LineEnd = [NSNumber numberWithInteger:11];

  STTagCollisionResult* result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(OverlapsBack, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);

  // Next, overlap where the start of the new tag just touches the start of the existing tag
  newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:5];
  newTag.LineEnd = [NSNumber numberWithInteger:11];

  result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(OverlapsBack, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);

  // Finally, overlap where the start of the new tag touches the end of the existing tag
  newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:10];
  newTag.LineEnd = [NSNumber numberWithInteger:15];

  result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(OverlapsBack, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);
}

-(void)testDetectTagCollisionEmbedds {
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  codeFile.Tags = [[NSMutableArray<STTag*> alloc] init];

  STTag* existingTag = [STTag tagWithName:@"Test 1" andCodeFile:codeFile];
  existingTag.LineStart = [NSNumber numberWithInteger:5];
  existingTag.LineEnd = [NSNumber numberWithInteger:10];
  [[codeFile Tags] addObject:existingTag];

  // Add the new tag immediately within the existing tag
  STTag* newTag = [STTag tagWithName:@"Test 2" andCodeFile:codeFile];
  newTag.LineStart = [NSNumber numberWithInteger:4];
  newTag.LineEnd = [NSNumber numberWithInteger:11];

  STTagCollisionResult* result = [STTagUtil DetectTagCollision:newTag];
  XCTAssertEqual(Embeds, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);
  [[codeFile Tags] addObject:newTag];

  // Add the new tag within the 2nd tag (to show we can detect multiple
  // levels of nesting)
  STTag* tag3 = [STTag tagWithName:@"Test 3" andCodeFile:codeFile];
  tag3.LineStart = [NSNumber numberWithInteger:3];
  tag3.LineEnd = [NSNumber numberWithInteger:12];

  result = [STTagUtil DetectTagCollision:tag3];
  XCTAssertEqual(Embeds, [result Collision]);
  XCTAssertEqual(existingTag, [result CollidingTag]);
}

-(void)testTagNameAsFileName_NullEmpty {
  XCTAssertEqualObjects(@"", [STTagUtil TagNameAsFileName:nil]);

  STTag* emptyTag = [STTag tagWithName:nil andCodeFile:nil];
  XCTAssertEqualObjects(@"", [STTagUtil TagNameAsFileName:emptyTag]);
  emptyTag = [STTag tagWithName:@"" andCodeFile:nil];
  XCTAssertEqualObjects(@"", [STTagUtil TagNameAsFileName:emptyTag]);
  emptyTag = [STTag tagWithName:@"   " andCodeFile:nil];
  XCTAssertEqualObjects(@"", [STTagUtil TagNameAsFileName:emptyTag]);
}

-(void)testTagNameAsFileName_Unchanged {
  STTag* tag = [STTag tagWithName:@"Test Tag Name 1" andCodeFile:nil];
  XCTAssertEqualObjects([tag Name], [STTagUtil TagNameAsFileName:tag]);
  tag = [STTag tagWithName:@"123456" andCodeFile:nil];
  XCTAssertEqualObjects([tag Name], [STTagUtil TagNameAsFileName:tag]);
  tag = [STTag tagWithName:@"12-34_56" andCodeFile:nil];
  XCTAssertEqualObjects([tag Name], [STTagUtil TagNameAsFileName:tag]);
}

-(void)testTagNameAsFileName_StripCharacters {
  STTag* tag = [STTag tagWithName:@"Test/Tag/Name_&*@(@#*(#$1" andCodeFile:nil];
  XCTAssertEqualObjects(@"TestTagName_1", [STTagUtil TagNameAsFileName:tag]);
  tag = [STTag tagWithName:@" Figure 1.2 " andCodeFile:nil];
  XCTAssertEqualObjects(@"Figure 12", [STTagUtil TagNameAsFileName:tag]);
  tag = [STTag tagWithName:@"Invalid\r\n\tWhite space" andCodeFile:nil];
  XCTAssertEqualObjects(@"InvalidWhite space", [STTagUtil TagNameAsFileName:tag]);
}

@end
