//
//  StatTagSTCodeFileTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/19/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "STCodeFile.h"
#import "StatTag.h"
#import "MockIFileHandler.h"
#import <OCMock/OCMock.h>


//MARK: Test cases

@interface StatTagModelCodeFileTests : XCTestCase

@end

@implementation StatTagModelCodeFileTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  
//  STCodeFile sh
//  
//  STCodeFile* aCodeFile = [[STCodeFile alloc] init];
//  [aCodeFile Content] = nil;
  
  [super tearDown];
}


//Extra obj-c methods for NURL <-> NSString
-(void)testNSURLToFilePath {
  NSURL* url;
  STCodeFile* cf = [[STCodeFile alloc] init];
  
  url = [[NSURL alloc] initWithString:@"file1.txt"];
  cf.FilePathURL = url;
  XCTAssert([@"file1.txt" isEqualToString:[[cf FilePathURL] lastPathComponent]]);
  XCTAssert([@"file1.txt" isEqualToString:[cf FilePath]]);

  url = [[NSURL alloc] initWithString:@"C:\\temp\\file1.txt"];
  cf.FilePathURL = url;
  XCTAssertNil([cf FilePath]);
  XCTAssertNil([cf FilePathURL]);
}

-(void)testFilePathToNSURL {
//  NSURL* url;
  STCodeFile* cf = [[STCodeFile alloc] init];
  
  cf.FilePath = @"file1.txt";
  XCTAssert([@"file1.txt" isEqualToString:[[cf FilePathURL] lastPathComponent]]);
  XCTAssert([@"file1.txt" isEqualToString:[cf FilePath]]);

  cf.FilePath = @"C:\\temp\\file1.txt";
  XCTAssert([[cf FilePath] isEqualToString:@"C:\\temp\\file1.txt"]);
  XCTAssert([[[cf FilePathURL] path] isEqualToString:@"/private/tmp/C:\\temp\\file1.txt"]);
  //XCTAssertNil([cf FilePathURL]);
  
}


//MARK: c# test methods
-(void)testDefault_ToString {

  STCodeFile* file = [[STCodeFile alloc] init];
  XCTAssert([@"" isEqualToString:[file ToString]]);

  NSURL* url = [[NSURL alloc] initWithString:@"C:\\Test.txt"];
  NSLog(@"url : %@", url);
  
  file.FilePath = @"C:\\Test.txt";
  file.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  
  NSLog(@"[file ToString] : %@", [file ToString]);
  XCTAssert([@"C:\\Test.txt" isEqualToString:[file ToString]]);

  file.FilePath = @"C:\\Test2.txt";
  NSLog(@"[file ToString] : %@", [file ToString]);
  XCTAssert([@"C:\\Test2.txt" isEqualToString:[file ToString]]);
}

-(void)testLoadTagsFromContent_Empty {

  //  id mock = OCMClassMock([STCodeFile class]);

  id x;
  id mock = OCMProtocolMock(@protocol(STIFileHandler));
  OCMStub([mock ReadAllLines:x error:nil]).andReturn([[NSArray<NSString*> alloc] init]);

  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  [codeFile LoadTagsFromContent];
  XCTAssertEqual(0, [[codeFile Tags] count]);
}

-(void)testLoadTagsFromContent_UnknownType {
  
  // Couldn't seem to get the protocol-based mocks to work, so using the hard class mock
  //
  //  id x;
  //  id mock = OCMProtocolMock(@protocol(STIFileHandler));
  //  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
  //  @"**>>>ST:Test(Type=\"Default\")",
  //  @"some code here",
  //  @"**<<<",
  //  OCMStub([mock ReadAllLines:x error:nil]).andReturn(lines);
  //
  //  NSLog(@"mock.ReadAllLines: %@", [mock ReadAllLines:x error:nil]);

  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"**>>>ST:Test(Type=\"Default\")",
                               @"some code here",
                               @"**<<<",
                               nil];
  mock.lines = lines;

  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];
  XCTAssertEqual(0, [[codeFile Tags] count]);
}

-(void)testLoadTagsFromContent_Normal {
  

  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"**>>>ST:Value(Type=\"Default\")",
                               @"some code here",
                               @"**<<<",
                               nil];
  mock.lines = lines;

  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssert([[STConstantsTagType Value] isEqualToString:[[codeFile Tags][0] Type]]);
  XCTAssertEqual(codeFile, [[codeFile Tags][0] CodeFile]);
}

-(void)testLoadTagsFromContent_RestoreCache {
  
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"**>>>ST:Value(Type=\"Default\")",
                               @"some code here",
                               @"**<<<",
                               nil];
  mock.lines = lines;

  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];

  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test result 1";
  codeFile.Tags[0].CachedResult = [NSMutableArray<STCommandResult*> arrayWithObject:cr];

  // Now restore and preserve the cahced value result
  [codeFile LoadTagsFromContent];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssert([[STConstantsTagType Value] isEqualToString:[[codeFile Tags][0] Type]]);
  STCommandResult* cachedResult = codeFile.Tags[0].CachedResult[0];
  XCTAssert([@"Test result 1" isEqualToString:[cachedResult ValueResult]]);

  // Restore again but do not preserve the cahced value result
  [codeFile LoadTagsFromContent:false];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssert([[STConstantsTagType Value] isEqualToString:[[codeFile Tags][0] Type]]);
  XCTAssertNil(codeFile.Tags[0].CachedResult);
}

-(void)testSaveBackup_AlreadyExists {
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  mock.exists = true;
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  [codeFile SaveBackup:nil];
  
  XCTAssertEqual([mock Copy_wasCalled], 0);
  //mock.Verify(file => file.Copy(It.IsAny<string>(), It.IsAny<string>()), Times.Never);

}

-(void)testSaveBackup_New {
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  mock.exists = false;
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  [codeFile SaveBackup:nil];
  
  XCTAssertEqual([mock Copy_wasCalled], 1);
}

-(void)testGuessStatisticalPackage_Empty {
  XCTAssert([@"" isEqualToString:[STCodeFile GuessStatisticalPackage:@""]]);
  XCTAssert([@"" isEqualToString:[STCodeFile GuessStatisticalPackage:@"  "]]);
  XCTAssert([@"" isEqualToString:[STCodeFile GuessStatisticalPackage:nil]]);
}

-(void)testGuessStatisticalPackage_Valid {

  XCTAssert([[STConstantsStatisticalPackages Stata] isEqualToString:[STCodeFile GuessStatisticalPackage:@"C:\\test.do"]]);
  XCTAssert([[STConstantsStatisticalPackages Stata] isEqualToString:[STCodeFile GuessStatisticalPackage:@"  C:\\test.do  "]]);
  
  XCTAssert([[STConstantsStatisticalPackages R] isEqualToString:[STCodeFile GuessStatisticalPackage:@"C:\\test.r"]]);
  XCTAssert([[STConstantsStatisticalPackages R] isEqualToString:[STCodeFile GuessStatisticalPackage:@"  C:\\test.r  "]]);

  XCTAssert([[STConstantsStatisticalPackages SAS] isEqualToString:[STCodeFile GuessStatisticalPackage:@"C:\\test.sas"]]);
  XCTAssert([[STConstantsStatisticalPackages SAS] isEqualToString:[STCodeFile GuessStatisticalPackage:@"  C:\\test.sas  "]]);

}

-(void)testGuessStatisticalPackage_Unknown {
  XCTAssert([@"" isEqualToString:[STCodeFile GuessStatisticalPackage:@"C:\\"]]);
  XCTAssert([@"" isEqualToString:[STCodeFile GuessStatisticalPackage:@"C:\\test.txt"]]);
  XCTAssert([@"" isEqualToString:[STCodeFile GuessStatisticalPackage:@"C:\\test.dor"]]);
  XCTAssert([@"" isEqualToString:[STCodeFile GuessStatisticalPackage:@"C:\\test.r t"]]);

}

-(void)testContentCache_Load {
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"**>>>ST:Value(Type=\"Default\")",
                               @"some code here",
                               @"**<<<",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];

  NSArray<NSString*>* content = [codeFile Content];

  XCTAssertEqual(3, [content count]);
  XCTAssertEqual([mock ReadAllLines_wasCalled], 1);

  // When called a second time, we should not increment the number of times the file
  // is reloaded.
  content = [codeFile Content];
  XCTAssertEqual(3, [content count]);
  XCTAssertEqual([mock ReadAllLines_wasCalled], 1);
  
  // Forcing the cache to null will cause a reload
  codeFile.Content = nil;
  content = [codeFile Content];
  XCTAssertNotNil(content);
  XCTAssertEqual(3, [content count]);
  XCTAssertEqual([mock ReadAllLines_wasCalled], 2);
}

-(void)testAddTag_FlippedIndex {
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"first line",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];

  STTag* tag = [[STTag alloc] init];
  tag.LineStart = @2;
  tag.LineEnd = @1;

  //this should fail because we're putting a linestart that's higher than lineend
  XCTAssertThrows([codeFile AddTag:tag]);
}

-(void)testAddTag_Null {
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"first line",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];

  XCTAssertNil([codeFile AddTag:nil]);
  XCTAssertNil([codeFile AddTag:[[STTag alloc] init]]);
  STTag* tag = [[STTag alloc] init];
  tag.LineStart = @1;
  XCTAssertNil([codeFile AddTag:tag]);
}

-(void)testAddTag_New {

  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"first line",
                               @"second line",
                               @"third line",
                               @"fourth line",
                               @"fifth line",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];

  STTag* tag = [[STTag alloc] init];
  tag.LineStart = @1;
  tag.LineEnd = @2;
  tag.Name = @"Test";
  tag.Type = [STConstantsTagType Value];
  tag.ValueFormat = [[STValueFormat alloc]init];

  STTag* updatedTag = [codeFile AddTag:tag];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssertEqual(1, [[updatedTag LineStart] integerValue]);
  XCTAssertEqual(4, [[updatedTag LineEnd] integerValue]);
  XCTAssertEqual(7, [[codeFile Content] count]); // Two tag lines should be added
  XCTAssert([@"**>>>ST:Value(Label=\"Test\", Type=\"Default\")" isEqualToString:[codeFile Content][[[updatedTag LineStart] integerValue] ]]);
  XCTAssert([@"**<<<" isEqualToString:[codeFile Content][[[updatedTag LineEnd] integerValue] ]]);
  
  // Existing tag should not be modified (we don't check start because that happens to always be the same)
  XCTAssertNotEqual([[updatedTag LineEnd] integerValue], [[tag LineEnd] integerValue]);

  // Insert after an existing tag
  tag = [[STTag alloc] init];
  tag.LineStart = @5;
  tag.LineEnd = @6;
  tag.Name = @"Test2";
  tag.Type = [STConstantsTagType Value];
  tag.ValueFormat = [[STValueFormat alloc]init];
  updatedTag = [codeFile AddTag:tag];

  XCTAssertEqual(2, [[codeFile Tags] count]);
  XCTAssertEqual(5, [[updatedTag LineStart] integerValue]);
  XCTAssertEqual(8, [[updatedTag LineEnd] integerValue]);
  XCTAssertEqual(9, [[codeFile Content] count]); // Two tag lines should be added
  XCTAssert([@"**>>>ST:Value(Label=\"Test2\", Type=\"Default\")" isEqualToString:[codeFile Content][[[updatedTag LineStart] integerValue] ]]);
  XCTAssert([@"**<<<" isEqualToString:[codeFile Content][[[updatedTag LineEnd] integerValue] ]]);

  // Insert before existing tags
  tag = [[STTag alloc] init];
  tag.LineStart = @0;
  tag.LineEnd = @0;
  tag.Name = @"Test3";
  tag.Type = [STConstantsTagType Value];
  tag.ValueFormat = [[STValueFormat alloc]init];
  updatedTag = [codeFile AddTag:tag];


  XCTAssertEqual(3, [[codeFile Tags] count]);
  XCTAssertEqual(0, [[updatedTag LineStart] integerValue]);
  XCTAssertEqual(2, [[updatedTag LineEnd] integerValue]);
  XCTAssertEqual(11, [[codeFile Content] count]); // Two tag lines should be added
  XCTAssert([@"**>>>ST:Value(Label=\"Test3\", Type=\"Default\")" isEqualToString:[codeFile Content][[[updatedTag LineStart] integerValue] ]]);
  XCTAssert([@"**<<<" isEqualToString:[codeFile Content][[[updatedTag LineEnd] integerValue] ]]);

  // Final check that the file content is exactly as we expect:
  XCTAssert([@"**>>>ST:Value(Label=\"Test3\", Type=\"Default\"), first line, **<<<, **>>>ST:Value(Label=\"Test\", Type=\"Default\"), second line, third line, **<<<, **>>>ST:Value(Label=\"Test2\", Type=\"Default\"), fourth line, fifth line, **<<<" isEqualToString:[[codeFile Content] componentsJoinedByString:@ ", "]]);
}

-(void)testAddTag_NoChange {
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
                               @"first line",
                               @"second line",
                               @"**<<<",
                               @"third line",
                               @"fourth line",
                               @"fifth line",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];
  
  // Overlap the new selection with the existing opening tag tag
  STTag* oldTag = [codeFile Tags][0];
  STTag* newTag = [[STTag alloc] init];
  newTag.LineStart = @0;
  newTag.LineEnd = @3;
  newTag.Name = @"Test";
  newTag.Type = [STConstantsTagType Value];
  newTag.ValueFormat = [[STValueFormat alloc]init];

  STTag* updatedTag = [codeFile AddTag:newTag oldTag:oldTag];
  
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssertEqual(0, [[updatedTag LineStart] integerValue]);
  XCTAssertEqual(3, [[updatedTag LineEnd] integerValue]);
  XCTAssertEqual(7, [[codeFile Content] count]);
  XCTAssert([@"**>>>ST:Value(Label=\"Test\", Type=\"Default\")" isEqualToString:[codeFile Content][[[updatedTag LineStart] integerValue] ]]);
  XCTAssert([@"**<<<" isEqualToString:[codeFile Content][[[updatedTag LineEnd] integerValue] ]]);
}

-(void)testAddTag_Update {
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"first line",
                               @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
                               @"second line",
                               @"third line",
                               @"**<<<",
                               @"fourth line",
                               @"fifth line",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];

  // Overlap the new selection with the existing opening tag tag
  STTag* oldTag = [codeFile Tags][0];
  STTag* newTag = [[STTag alloc] init];
  newTag.LineStart = @0;
  newTag.LineEnd = @2;
  newTag.Name = @"Test";
  newTag.Type = [STConstantsTagType Value];
  newTag.ValueFormat = [[STValueFormat alloc]init];
  
  STTag* updatedTag = [codeFile AddTag:newTag oldTag:oldTag];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssertEqual(0, [[updatedTag LineStart] integerValue]);
  XCTAssertEqual(3, [[updatedTag LineEnd] integerValue]);
  XCTAssertEqual(7, [[codeFile Content] count]);
  XCTAssert([@"**>>>ST:Value(Label=\"Test\", Type=\"Default\")" isEqualToString:[codeFile Content][[[updatedTag LineStart] integerValue] ]]);
  XCTAssert([@"**<<<" isEqualToString:[codeFile Content][[[updatedTag LineEnd] integerValue] ]]);

  
  
  // Now select the last two lines and update that tag
  oldTag = [codeFile Tags][0];
  newTag = [[STTag alloc] init];
  newTag.LineStart = @5;
  newTag.LineEnd = @6;
  newTag.Name = @"Test";
  newTag.Type = [STConstantsTagType Value];
  newTag.ValueFormat = [[STValueFormat alloc]init];
  updatedTag = [codeFile AddTag:newTag oldTag:oldTag];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssertEqual(3, [[updatedTag LineStart] integerValue]);
  XCTAssertEqual(6, [[updatedTag LineEnd] integerValue]);
  XCTAssertEqual(7, [[codeFile Content] count]);
  XCTAssert([@"**>>>ST:Value(Label=\"Test\", Type=\"Default\")" isEqualToString:[codeFile Content][[[updatedTag LineStart] integerValue] ]]);
  XCTAssert([@"**<<<" isEqualToString:[codeFile Content][[[updatedTag LineEnd] integerValue] ]]);
  
  
  // Select an tag that's entirely before the existing tag
  oldTag = [codeFile Tags][0];
  newTag = [[STTag alloc] init];
  newTag.LineStart = @1;
  newTag.LineEnd = @2;
  newTag.Name = @"Test";
  newTag.Type = [STConstantsTagType Value];
  newTag.ValueFormat = [[STValueFormat alloc]init];
  updatedTag = [codeFile AddTag:newTag oldTag:oldTag];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssertEqual(1, [[updatedTag LineStart] integerValue]);
  XCTAssertEqual(4, [[updatedTag LineEnd] integerValue]);
  XCTAssertEqual(7, [[codeFile Content] count]);
  XCTAssert([@"**>>>ST:Value(Label=\"Test\", Type=\"Default\")" isEqualToString:[codeFile Content][[[updatedTag LineStart] integerValue] ]]);
  XCTAssert([@"**<<<" isEqualToString:[codeFile Content][[[updatedTag LineEnd] integerValue] ]]);
  
  
  // Overlap the selection with the existing closing tag tag
  oldTag = [codeFile Tags][0];
  newTag = [[STTag alloc] init];
  newTag.LineStart = @5;
  newTag.LineEnd = @6;
  newTag.Name = @"Test";
  newTag.Type = [STConstantsTagType Value];
  newTag.ValueFormat = [[STValueFormat alloc]init];
  updatedTag = [codeFile AddTag:newTag oldTag:oldTag];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssertEqual(3, [[updatedTag LineStart] integerValue]);
  XCTAssertEqual(6, [[updatedTag LineEnd] integerValue]);
  XCTAssertEqual(7, [[codeFile Content] count]);
  XCTAssert([@"**>>>ST:Value(Label=\"Test\", Type=\"Default\")" isEqualToString:[codeFile Content][[[updatedTag LineStart] integerValue] ]]);
  XCTAssert([@"**<<<" isEqualToString:[codeFile Content][[[updatedTag LineEnd] integerValue] ]]);

}

-(void)testAddTag_ExactLineMatch_NotFound {
  
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"first line",
                               @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
                               @"second line",
                               @"**<<<",
                               @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
                               @"third line",
                               @"**<<<",
                               @"fourth line",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];
  
  // Try to add a new tag that does not have matching line numbers

  STTag* oldTag = [[STTag alloc] init];
  oldTag.LineStart = @4;
  oldTag.LineEnd = @5;

  STTag* newTag = [[STTag alloc] init];
  newTag.LineStart = @0;
  newTag.LineEnd = @2;
  newTag.Name = @"Test";
  newTag.Type = [STConstantsTagType Value];
  newTag.ValueFormat = [[STValueFormat alloc]init];
  
  XCTAssertThrows([codeFile AddTag:newTag oldTag:oldTag matchWithPosition:true]);
}

-(void)testAddTag_ExactLineMatch {
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"first line",
                               @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
                               @"second line",
                               @"**<<<",
                               @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
                               @"third line",
                               @"**<<<",
                               @"fourth line",
                               nil];
  mock.lines = lines;

  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];

  XCTAssertEqual(2, [[codeFile Tags] count]);

  //NSLog(@"tags : %@", [codeFile Tags]);
  
  // Match the second one - this should bypass the first one which matches on name but not on line number.
  STTag* oldTag = [codeFile Tags][1];
  
  STTag* newTag = [[STTag alloc] init];
  newTag.LineStart = @4;
  newTag.LineEnd = @6;
  newTag.Name = @"Test 2";
  newTag.Type = [STConstantsTagType Value];
  newTag.ValueFormat = [[STValueFormat alloc]init];

  STTag* updatedTag = [codeFile AddTag:newTag oldTag:oldTag matchWithPosition:true];
  #pragma unused (updatedTag)

  XCTAssertEqual(2, [[codeFile Tags] count]);
  XCTAssertEqual(8, [[codeFile Content] count]);
  
  // Make sure it didn't modify the first tag - only the second one should be a match.
  
  XCTAssert([@"**>>>ST:Value(Label=\"Test\", Type=\"Default\")" isEqualToString:[codeFile Content][1]]);
  XCTAssert([@"**>>>ST:Value(Label=\"Test 2\", Type=\"Default\")" isEqualToString:[codeFile Content][4]]);
}

-(void)testSave {
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  [codeFile Save:nil];
  XCTAssert([mock WriteAllLines_wasCalled] > 0);
}

-(void)testRemoveTag_Exists {
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"first line",
                               @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
                               @"second line",
                               @"**<<<",
                               @"**>>>ST:Value(Label=\"Test 2\", Type=\"Default\")",
                               @"third line",
                               @"**<<<",
                               @"fourth line",
                               @"fifth line",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];

  [codeFile RemoveTag:[codeFile Tags][0]];
  XCTAssertEqual(1, [[codeFile Tags] count]);
  XCTAssertEqual(7, [[codeFile Content] count]);
  XCTAssertEqual(2, [[[codeFile Tags][0] LineStart] integerValue]);
  XCTAssertEqual(4, [[[codeFile Tags][0] LineEnd] integerValue]);
  
  
  [codeFile RemoveTag:[codeFile Tags][0]];
  XCTAssertEqual(0, [[codeFile Tags] count]);
  XCTAssertEqual(5, [[codeFile Content] count]);

}

-(void)testRemoveTag_DoesNotExist {
  
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"first line",
                               @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
                               @"second line",
                               @"**<<<",
                               @"**>>>ST:Value(Label=\"Test 2\", Type=\"Default\")",
                               @"third line",
                               @"**<<<",
                               @"fourth line",
                               @"fifth line",
                               nil];
  mock.lines = lines;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  [codeFile LoadTagsFromContent];

  [codeFile RemoveTag:nil];
  [codeFile RemoveTag:[STTag tagWithName:@"NotHere" andCodeFile:nil andType:[STConstantsTagType Value]]];
  [codeFile RemoveTag:[STTag tagWithName:@"Test" andCodeFile:nil andType:[STConstantsTagType Value]]];
  XCTAssertEqual(2, [[codeFile Tags] count]);
  XCTAssertEqual(9, [[codeFile Content] count]);
}

-(void)testUpdateContent {
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray arrayWithObjects:
         @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
         @"first line",
         @"second line",
         @"**<<<",
         nil];
  mock.lines = lines;
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
  NSLog(@"tags: %@", [codeFile Tags] );
  NSLog(@"tag count: %d", [[codeFile Tags] count]);
  [codeFile UpdateContent:@"test content" error:nil];
  XCTAssert([mock WriteAllText_wasCalled] > 0);
  XCTAssertEqual(1, [[codeFile Tags] count]);
}

-(void)testFindDuplicateTags_EmptyTags {
  
  // This is when we have code files with null or otherwise empty collections of tags, to ensure we are
  // handling this boundary scenarios appropriately.
  
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  NSString* url = @"Test.do";
  codeFile.FilePath = url;
  codeFile.Tags = nil;
  NSDictionary<STTag*, NSArray<STTag*>*>* result = [codeFile FindDuplicateTags];
  XCTAssertEqual(0, [result count]);

  codeFile = [[STCodeFile alloc] init];
  url = @"Test.do";
  codeFile.FilePath = url;
  result = [codeFile FindDuplicateTags];
  XCTAssertEqual(0, [result count]);

  codeFile = [[STCodeFile alloc] init];
  url = @"Test.do";
  codeFile.FilePath = url;
  codeFile.Tags = [[NSMutableArray<STTag*> alloc] init];
  result = [codeFile FindDuplicateTags];
  XCTAssertEqual(0, [result count]);
}

-(void)testFindDuplicateTags_NoDuplicates {
  
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  NSString* url = @"Test.do";
  codeFile.FilePath = url;
  
  STTag* tag1 = [[STTag alloc] init];
  tag1.Name = @"Test";
  STTag* tag2 = [[STTag alloc] init];
  tag2.Name = @"Test2";

  codeFile.Tags = [NSMutableArray<STTag*> arrayWithObjects:tag1,tag2, nil];

  NSDictionary<STTag*, NSArray<STTag*>*>* result = [codeFile FindDuplicateTags];
  XCTAssertEqual(0, [result count]);

}

-(void)testFindDuplicateTags_Duplicates {

  STCodeFile* codeFile = [[STCodeFile alloc] init];
  NSString* url = @"Test.do";
  codeFile.FilePath = url;

  STTag* tag1 = [[STTag alloc] init];
  tag1.Name = @"Test";
  STTag* tag2 = [[STTag alloc] init];
  tag2.Name = @"Test2";
  STTag* tag3 = [[STTag alloc] init];
  tag3.Name = @"test";
  STTag* tag4 = [[STTag alloc] init];
  tag4.Name = @"test2";
  STTag* tag5 = [[STTag alloc] init];
  tag5.Name = @"Test";
  
  codeFile.Tags = [NSMutableArray<STTag*> arrayWithObjects:tag1,tag2,tag3,tag4,tag5, nil];
  //NSLog(@"[codeFile Tags] : %@", [codeFile Tags]);
  
  NSDictionary<STTag*, NSArray<STTag*>*>* result = [codeFile FindDuplicateTags];
  //NSLog(@"result : %@", result);

  XCTAssertEqual(2, [result count]);
  XCTAssertEqual(2, [[result objectForKey:([codeFile Tags][0])] count]);
  XCTAssertEqual(1, [[result objectForKey:([codeFile Tags][1])] count]);
}


//MARK: JSON testing - not in original C#
- (void)testJSONEncoding {
  STCodeFile *f = [[STCodeFile alloc] init];
  f.StatisticalPackage = @"R";
  f.FilePath = @"/Applications/SomePath/somefile.txt";
  f.LastCached = [NSDate date];
  
  NSLog(@"f: %@", f);
 
  NSError *error;
  NSString *json = [STJSONUtility SerializeObject:f error:&error];
  NSLog(@"JSON: %@", json);
  NSLog(@"error: %@", error);
}

- (void)testJSONListEncoding {
  
  NSMutableArray<STCodeFile*> *files = [[NSMutableArray<STCodeFile*> alloc] init];
  
  for(int i = 0; i < 5; i++) {
    STCodeFile *f = [[STCodeFile alloc] init];
    f.StatisticalPackage = [NSString stringWithFormat:@"R %d", i];
    f.FilePath = [NSString stringWithFormat:@"/Applications/SomePath/somefile___%d.txt", i];
    [files addObject:f];
  }
  
  NSError *error;
  NSString *json = [STCodeFile SerializeList:files error:&error];
  
  NSLog(@"JSON: %@", json);
  NSLog(@"error: %@", error);
}

- (void)testJSONInit {
  //-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error
  NSString* jsonString = @"{\"StatisticalPackage\" : \"R 0\",\"FilePath\" : \"/Applications/SomePath/somefile___0.txt\",\"LastCached\":\"06/20/2016, 09:18:29 -0500\"}";
  NSError* error;
  STCodeFile* f = [[STCodeFile alloc] initWithJSONString:jsonString error:&error];
  NSLog(@"error: %@", error);
  NSLog(@"f: %@", f);
  NSLog(@"f (StatisticalPackage): %@", [f StatisticalPackage]);
  NSLog(@"f (LastCached): %@", [f LastCached]);
}

- (void)testJSONArrayInit {
  NSString* jsonString = @"[{\"StatisticalPackage\" : \"R 0\",\"FilePath\" : \"/Applications/SomePath/somefile___0.txt\"},{\"StatisticalPackage\" : \"R 1\",\"FilePath\" : \"/Applications/SomePath/somefile___1.txt\"},{\"StatisticalPackage\" : \"R 2\",\"FilePath\" : \"/Applications/SomePath/somefile___2.txt\"},{\"StatisticalPackage\" : \"R 3\",\"FilePath\" : \"/Applications/SomePath/somefile___3.txt\"},{\"StatisticalPackage\" : \"R 4\",\"FilePath\" : \"/Applications/SomePath/somefile___4.txt\"}]";
  NSError* error;
  NSArray<STCodeFile*>* list = [STCodeFile DeserializeList:jsonString error:&error];
  NSLog(@"error: %@", error);
  NSLog(@"f: %@", list);
}


//MARK: Object copy/dictionary
- (void)testBasicObjectForKey {
  STCodeFile *f = [[STCodeFile alloc] init];
  f.FilePath = @"afile";
  
  NSMutableDictionary<STCodeFile*, NSNumber*>* d = [[NSMutableDictionary<STCodeFile*, NSNumber*> alloc] init];
  [d setObject:@1 forKey:f];
  NSLog(@"f(FilePath): %@", [f FilePath]);
  NSLog(@"f(FilePath): %@", [[f FilePathURL] path]);
  NSLog(@"d: %@", d);
  NSLog(@"d(value): %@", [d objectForKey:f]);
}


@end
