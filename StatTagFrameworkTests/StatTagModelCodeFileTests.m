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
  [super tearDown];
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
}

-(void)testLoadTagsFromContent_UnknownType {
}

-(void)testLoadTagsFromContent_Normal {
}

-(void)testLoadTagsFromContent_RestoreCache {
}

-(void)testSaveBackup_AlreadyExists {
}

-(void)testSaveBackup_New {
}

-(void)testGuessStatisticalPackage_Empty {
}

-(void)testGuessStatisticalPackage_Valid {
}

-(void)testGuessStatisticalPackage_Unknown {
}

-(void)testContentCache_Load {
}

-(void)testAddTag_FlippedIndex {
}

-(void)testAddTag_Null {
}

-(void)testAddTag_New {
}

-(void)testAddTag_NoChange {
}

-(void)testAddTag_Update {
}

-(void)testAddTag_ExactLineMatch_NotFound {
}

-(void)testAddTag_ExactLineMatch {
}

-(void)testSave {
}

-(void)testRemoveTag_Exists {
}

-(void)testRemoveTag_DoesNotExist {
}

-(void)testUpdateContent {
  
//  id mock = OCMProtocolMock(@protocol(STIFileHandler));
//  NSURL* url = [[NSURL alloc] initWithString:@""];
//  OCMStub([mock WriteAllText:url withContent:@"" error:nil]);//.andReturn(anObject);
//  NSArray<NSString*>* lines = [NSArray arrayWithObjects:
//         @"**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
//         @"first line",
//         @"second line",
//         @"**<<<",
//         nil];
//  OCMStub([mock ReadAllLines:url error:nil]).andReturn(lines);
//  
//  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
//  codeFile.StatisticalPackage = [STConstantsStatisticalPackages Stata];
//  [codeFile UpdateContent:@"test content" error:nil];
//  //mock.verify?
//  //http://stackoverflow.com/questions/25573992/ocmverify-and-undefined-symbols-for-architecture-i386-armv7-armv7s
//  //http://erik.doernenburg.com/2008/07/testing-cocoa-controllers-with-ocmock/
//  //https://www.bignerdranch.com/blog/making-mockery-mock-objects/
//  //OCMVerify([mockEngine notify]);
//  
//  XCTAssertEqual(1, [[codeFile Tags] count]);
  
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
  [codeFile UpdateContent:@"test content" error:nil];
  NSLog(@"[mock lines] : %@", [mock lines]);
  NSLog(@"[codeFile Tags] : %@", [codeFile Tags]);
  XCTAssertEqual(1, [[codeFile Tags] count]);

  /*
   var mock = new Mock<IFileHandler>();
   mock.Setup(file => file.WriteAllText(It.IsAny<string>(), It.IsAny<string>())).Verifiable();
   mock.Setup(file => file.ReadAllLines(It.IsAny<string>())).Returns(new[]
   {
   "**>>>ST:Value(Label=\"Test\", Type=\"Default\")",
   "first line",
   "second line",
   "**<<<"
   });
   
   var codeFile = new CodeFile(mock.Object);
   codeFile.StatisticalPackage = Constants.StatisticalPackages.Stata;
   codeFile.UpdateContent("test content");
   mock.Verify();
   Assert.AreEqual(1, codeFile.Tags.Count);
   */
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
