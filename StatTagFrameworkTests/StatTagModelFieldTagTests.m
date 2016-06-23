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
  
  
  STTag* tag = [STTag tagWithName:@"Test" andCodeFile:nil andType:[STConstantsTagType Table]];
  STFieldTag* fieldTag = [[STFieldTag alloc] init];
  fieldTag.CodeFilePath = [NSURL fileURLWithPath:@"Test.do"];
  fieldTag.TableCellIndex = @10;
  
  STFieldTag *newFieldTag = [[STFieldTag alloc] initWithTag:tag andFieldTag:fieldTag];

  XCTAssert([[tag Name] isEqualToString:[newFieldTag Name]]);
  XCTAssert([[tag Type] isEqualToString:[newFieldTag Type]]);
  XCTAssertEqual(10, [[newFieldTag TableCellIndex] integerValue]);
  XCTAssert([[[NSURL fileURLWithPath:@"Test.do"]path] isEqualToString: [[newFieldTag CodeFilePath] path]]);
}

- (void)testConstructor_NullTagWithFieldTag {
  
  STFieldTag* fieldTag = [[STFieldTag alloc] init];
  fieldTag.Name = @"Test";
  fieldTag.Type = [STConstantsTagType Table];
  fieldTag.CodeFilePath = [NSURL fileURLWithPath:@"Test.do"];
  fieldTag.TableCellIndex = @10;

  STFieldTag *newFieldTag = [[STFieldTag alloc] initWithTag:nil andFieldTag:fieldTag];

  XCTAssert([[fieldTag Name] isEqualToString:[newFieldTag Name]]);
  XCTAssert([[fieldTag Type] isEqualToString:[newFieldTag Type]]);
  XCTAssertEqual([[fieldTag TableCellIndex] integerValue], [[newFieldTag TableCellIndex] integerValue]);
  XCTAssert([[[fieldTag CodeFilePath] path] isEqualToString: [[newFieldTag CodeFilePath] path]]);

}

- (void)testConstructor_TagWithIndex_TableCell {

  STTable* t = [[STTable alloc] init];
  t.ColumnNames = [NSMutableArray arrayWithObjects:@"c1",@"c2", nil];
  t.RowNames = [NSMutableArray arrayWithObjects:@"r1",@"r2", nil];
  t.ColumnSize = 2;
  t.RowSize = 2;
  t.Data = [NSMutableArray<NSNumber*> arrayWithObjects:@1.0, @2.0, @3.0, @4.0, nil];
  t.FormattedCells = [NSMutableArray<NSString*> arrayWithObjects:@"1.0", @"2.0", @"3.0", @"4.0", nil];

  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.TableResult = t;

  NSMutableArray<STCommandResult*>* crList = [NSMutableArray<STCommandResult*> arrayWithObject:cr];

  STTag* tag = [STTag tagWithName:@"Test" andCodeFile:nil andType:[STConstantsTagType Table]];
  tag.CachedResult = crList;

  
  STFieldTag* fieldTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:@0];
  XCTAssertEqual(0, [[fieldTag TableCellIndex] integerValue]);
  XCTAssert([@"1.0" isEqualToString:[fieldTag FormattedResult]]);
  
  fieldTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:@2];
  XCTAssertEqual(2, [[fieldTag TableCellIndex] integerValue]);
  XCTAssert([@"3.0" isEqualToString:[fieldTag FormattedResult]]);
  
}

- (void)testConstructor_Copy {
  
  STFieldTag* tag = [STFieldTag tagWithName:@"Test" andCodeFile:nil andType:[STConstantsTagType Table]];
  tag.TableCellIndex = @15;
  
  STFieldTag* fieldTag = [[STFieldTag alloc] initWithFieldTag:tag];


  XCTAssert([[tag Name] isEqualToString:[fieldTag Name]]);
  XCTAssert([[tag Type] isEqualToString:[fieldTag Type]]);
  XCTAssertEqual([[tag TableCellIndex] integerValue], [[fieldTag TableCellIndex] integerValue]);
}

- (void)testSerialize_Deserialize {
  
  STCodeFile* codeFile = [STCodeFile codeFileWithFilePath:[NSURL fileURLWithPath:@"Test.do"]];
  
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test 1";
  NSMutableArray<STCommandResult*>* crList = [NSMutableArray<STCommandResult*> arrayWithObject:cr];
  
  STFieldTag* tag = [[STFieldTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  tag.TableCellIndex = @10;
  tag.CodeFile = codeFile;
  tag.CachedResult = crList;
  
  NSError* error;
  NSString* serialized = [tag Serialize];
  
  STFieldTag* recreatedTag = [STFieldTag Deserialize:serialized error:&error];

  //NSLog(@"serialized : %@", serialized);
  //NSLog(@"recreatedTag : %@", recreatedTag);

  NSLog(@"tag : %@", tag);
  NSLog(@"tag Name : %@", [tag Name]);
  NSLog(@"tag FormattedResult : %@", [tag FormattedResult]);
  NSLog(@"tag RunFrequency : %@", [tag RunFrequency]);
  NSLog(@"tag CodeFilePath path : %@", [[tag CodeFilePath] path]);
  NSLog(@"tag dictionary: %@", [tag toDictionary]);
  NSLog(@"tag id: %@", [tag Id]);
  
  //Id should be --Test.do

  NSLog(@"recreatedTag : %@", recreatedTag);
  NSLog(@"recreatedTag Name : %@", [recreatedTag Name]);
  NSLog(@"recreatedTag FormattedResult : %@", [recreatedTag FormattedResult]);
  NSLog(@"recreatedTag RunFrequency : %@", [recreatedTag RunFrequency]);
  NSLog(@"recreatedTag CodeFilePath path : %@", [[recreatedTag CodeFilePath] path]);

  
  // Assert.AreEqual(tag.FigureFormat, recreatedTag.FigureFormat);
  // how can we test equality? or are they both supposed to be nil?
  // in obj-c, any [nil isEqual: nil] comparison will fail
  // http://stackoverflow.com/questions/5914845/sending-isequal-to-nil-always-returns-no
  XCTAssert([[tag FigureFormat] isEqual:[recreatedTag FigureFormat]]);//nil so they won't match
  XCTAssert([[tag FormattedResult] isEqual:[recreatedTag FormattedResult]]);
  XCTAssertEqual([[tag LineEnd] integerValue], [[recreatedTag LineEnd] integerValue]);
  XCTAssertEqual([[tag LineStart] integerValue], [[recreatedTag LineStart] integerValue]);
  
  //how are these matching if tag.Name is (nil) and the rormalized recreatedTag.Name is ""?
  XCTAssert([[tag Name] isEqualToString:[recreatedTag Name]]);
  XCTAssert([[tag RunFrequency] isEqualToString:[recreatedTag RunFrequency]]);
  XCTAssert([[tag Type] isEqual:[recreatedTag Type]]);
  
  // how can we test equality? or are they both supposed to be nil?
  XCTAssert([[tag ValueFormat] isEqual:[recreatedTag ValueFormat]]);
  XCTAssert([[tag TableFormat] isEqual:[recreatedTag TableFormat]]);
  XCTAssert([[tag FigureFormat] isEqual:[recreatedTag FigureFormat]]); //duplicate test

  XCTAssertEqual([[tag TableCellIndex] integerValue], [[recreatedTag TableCellIndex] integerValue]);
  // The recreated tag doesn't truly recreate the code file object.  We attempt to restore it the best we can with the file path.

  XCTAssert([[[tag CodeFilePath] path] isEqual:[[[recreatedTag CodeFile] FilePath] path]]);
  XCTAssert([[[tag CodeFilePath] path] isEqual:[[recreatedTag CodeFilePath] path]]);
  
  /*
  Assert.AreEqual(tag.FormattedResult, recreatedTag.FormattedResult);
  Assert.AreEqual(tag.LineEnd, recreatedTag.LineEnd);
  Assert.AreEqual(tag.LineStart, recreatedTag.LineStart);
  Assert.AreEqual(tag.Name, recreatedTag.Name);
  Assert.AreEqual(tag.RunFrequency, recreatedTag.RunFrequency);
  Assert.AreEqual(tag.Type, recreatedTag.Type);
  Assert.AreEqual(tag.ValueFormat, recreatedTag.ValueFormat);
  Assert.AreEqual(tag.FigureFormat, recreatedTag.FigureFormat);
  Assert.AreEqual(tag.TableFormat, recreatedTag.TableFormat);
  Assert.AreEqual(tag.TableCellIndex, recreatedTag.TableCellIndex);
  // The recreated tag doesn't truly recreate the code file object.  We attempt to restore it the best we can with the file path.
  Assert.AreEqual(tag.CodeFilePath, recreatedTag.CodeFile.FilePath);
  Assert.AreEqual(tag.CodeFilePath, recreatedTag.CodeFilePath);
  */
}

- (void)testLinkToCodeFile_Found {
}

- (void)testLinkToCodeFile_NotFound {
}


@end
