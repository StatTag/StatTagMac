//
//  StatTagModelFieldTagTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

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
  
  STCodeFile* codeFile = [[STCodeFile alloc] init];
  codeFile.FilePath = @"Test.do";
  STTag* tag = [STTag tagWithName:@"Test" andCodeFile:codeFile andType:[STConstantsTagType Table]];
  STFieldTag* fieldTag = [[STFieldTag alloc] init];
  fieldTag.TableCellIndex = @10;
  
  STFieldTag *newFieldTag = [[STFieldTag alloc] initWithTag:tag andFieldTag:fieldTag];

  XCTAssert([[tag Name] isEqualToString:[newFieldTag Name]]);
  XCTAssert([[tag Type] isEqualToString:[newFieldTag Type]]);
  XCTAssertEqual(10, [[newFieldTag TableCellIndex] integerValue]);
  XCTAssert([@"Test.do" isEqualToString: [newFieldTag CodeFilePath] ]);
}

- (void)testConstructor_NullTagWithFieldTag {
  
  STFieldTag* fieldTag = [[STFieldTag alloc] init];
  fieldTag.Name = @"Test";
  fieldTag.Type = [STConstantsTagType Table];
  fieldTag.CodeFilePath = @"Test.do";
  fieldTag.TableCellIndex = @10;

  STFieldTag *newFieldTag = [[STFieldTag alloc] initWithTag:nil andFieldTag:fieldTag];

  XCTAssert([[fieldTag Name] isEqualToString:[newFieldTag Name]]);
  XCTAssert([[fieldTag Type] isEqualToString:[newFieldTag Type]]);
  XCTAssertEqual([[fieldTag TableCellIndex] integerValue], [[newFieldTag TableCellIndex] integerValue]);
  XCTAssert([[fieldTag CodeFilePath] isEqualToString: [newFieldTag CodeFilePath] ]);

}

- (void)testConstructor_TagWithIndex_TableCell {

  STTableFormat* tf = [[STTableFormat alloc] init];
  tf.ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  tf.ColumnFilter.Enabled = false;
  tf.RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
  tf.RowFilter.Enabled = false;
  

  
  STTable* t = [[STTable alloc] init];
  //t.ColumnNames = [NSMutableArray arrayWithObjects:@"c1",@"c2", nil];
  //t.RowNames = [NSMutableArray arrayWithObjects:@"r1",@"r2", nil];
  t.ColumnSize = 2;
  t.RowSize = 2;
  t.Data = [[STTableData alloc] initWithData:@[@[@"", @"c1", @"c2"], @[@"r1", @"1.0", @"2.0"], @[@"r2", @"3.0", @"4.0"]]];
  t.FormattedCells = [[STTableData alloc] initWithData:@[@[@"", @"c1", @"c2"], @[@"r1", @"1.0", @"2.0"], @[@"r2", @"3.0", @"4.0"]]];

  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.TableResult = t;

  NSMutableArray<STCommandResult*>* crList = [NSMutableArray<STCommandResult*> arrayWithObject:cr];

  STTag* tag = [STTag tagWithName:@"Test" andCodeFile:nil andType:[STConstantsTagType Table]];
  tag.CachedResult = crList;

  
  STFieldTag* fieldTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:@0];
  XCTAssertEqual(0, [[fieldTag TableCellIndex] integerValue]);
  XCTAssert([@"" isEqualToString:[fieldTag FormattedResult]]);

  fieldTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:@3];
  XCTAssertEqual(3, [[fieldTag TableCellIndex] integerValue]);
  XCTAssert([@"r1" isEqualToString:[fieldTag FormattedResult]]);

  fieldTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:@7];
  XCTAssertEqual(7, [[fieldTag TableCellIndex] integerValue]);
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


-(void)testSerialize_NormalizesObjectName
{
  // The Serialize function will modify the Name property to a normalized value.
  // We expect this and explicitly confirm it's intended behavior.
  STFieldTag* tag = [[STFieldTag alloc] init];
  
  //Test case deviation!
  [tag setName:nil]; //we're testing the serialization - not the object, so this is OK for the moment

  XCTAssertNil([tag Name]);
  NSError* err;
  NSString* serialized __unused = [tag Serialize:&err];
  XCTAssertNotNil([tag Name]);
}

//TODO: Test serialize/deserialize with a TableResult in the CachedResult collection


- (void)testSerialize_Deserialize {
  
  STCodeFile* codeFile = [STCodeFile codeFileWithFilePath:@"Test.do"];
  
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test 1";
  NSMutableArray<STCommandResult*>* crList = [NSMutableArray<STCommandResult*> arrayWithObject:cr];
  
  STFieldTag* tag = [[STFieldTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  tag.TableCellIndex = @10;
  tag.CodeFile = codeFile;
  tag.CachedResult = crList;
  
  NSError* error;
  NSString* serialized = [tag Serialize:nil];
  
  STFieldTag* recreatedTag = [STFieldTag Deserialize:serialized error:&error];
  
  // Assert.AreEqual(tag.FigureFormat, recreatedTag.FigureFormat);
  // how can we test equality? or are they both supposed to be nil?
  // in obj-c, any [nil isEqual: nil] comparison will fail
  // http://stackoverflow.com/questions/5914845/sending-isequal-to-nil-always-returns-no

  //both are nil
  //XCTAssert([[tag FigureFormat] isEqual:[recreatedTag FigureFormat]]);//nil so they won't match
  
  //Test case deviation!
  XCTAssertNotNil([tag FigureFormat]);//original was NIL
  XCTAssertNotNil([recreatedTag FigureFormat]);//original was NIL

  XCTAssert([[tag FormattedResult] isEqualToString:[recreatedTag FormattedResult]]);

  XCTAssertEqual([[tag LineEnd] integerValue], [[recreatedTag LineEnd] integerValue]);
  XCTAssertEqual([[tag LineStart] integerValue], [[recreatedTag LineStart] integerValue]);
  
  //how are these matching if tag.Name is (nil) and the normalized recreatedTag.Name is ""?
  //NOTE: spoke w/ Luke - normalize occurs before we serialize/deserialize, so the value will be "" for both
  XCTAssert([[tag Name] isEqualToString:[recreatedTag Name]]);

  //both are nil
  //XCTAssert([[tag RunFrequency] isEqualToString:[recreatedTag RunFrequency]]);
  XCTAssertNil([tag RunFrequency]);
  XCTAssertNil([recreatedTag RunFrequency]);

  XCTAssert([[tag Type] isEqual:[recreatedTag Type]]);
  
  // how can we test equality? or are they both supposed to be nil?
  //both are nil
  //Test case deviation!
  XCTAssertNotNil([tag ValueFormat]);//original was NIL
  XCTAssertNotNil([recreatedTag ValueFormat]);//original was NIL
  
  //both are nil
  //Test case deviation!
  XCTAssertNotNil([tag TableFormat]);//original was NIL
  XCTAssertNotNil([recreatedTag TableFormat]);//original was NIL

  //both are nil
  //Test case deviation!
  XCTAssertNotNil([tag FigureFormat]);//original was NIL
  XCTAssertNotNil([recreatedTag FigureFormat]);//original was NIL

  XCTAssertEqual([[tag TableCellIndex] integerValue], [[recreatedTag TableCellIndex] integerValue]);
  // The recreated tag doesn't truly recreate the code file object.  We attempt to restore it the best we can with the file path.

  XCTAssert([[tag CodeFilePath]  isEqual:[[recreatedTag CodeFile] FilePath] ]);
  XCTAssert([[tag CodeFilePath]  isEqual:[recreatedTag CodeFilePath] ]);
}

//
//- (void)testSerialize_Deserialize_Table {
//  
//  STTable* t = [[STTable alloc] init];
//  t.ColumnNames = [NSMutableArray arrayWithObjects:@"c1",@"c2", nil];
//  t.RowNames = [NSMutableArray arrayWithObjects:@"r1",@"r2", nil];
//  t.ColumnSize = 2;
//  t.RowSize = 2;
//  t.Data = [NSMutableArray<NSNumber*> arrayWithObjects:@1.0, @2.0, @3.0, @4.0, nil];
//  t.FormattedCells = [NSMutableArray<NSString*> arrayWithObjects:@"1.0", @"2.0", @"3.0", @"4.0", nil];
//  
//  STCommandResult* cr = [[STCommandResult alloc] init];
//  cr.TableResult = t;
//  
//  NSMutableArray<STCommandResult*>* crList = [NSMutableArray<STCommandResult*> arrayWithObject:cr];
//  
//  STTag* tag = [STTag tagWithName:@"Test" andCodeFile:nil andType:[STConstantsTagType Table]];
//  tag.CachedResult = crList;
//
//  
//  NSError* error;
//  NSLog(@"formatted result : %@", [tag FormattedResult]);
//  NSString* serialized = [tag Serialize:nil];
//  NSLog(@"%@", serialized);
//  
//  STFieldTag* recreatedTag = [STFieldTag Deserialize:serialized error:&error];
//  NSLog(@"%@", [recreatedTag Serialize:nil]);
//  
//  
//  
//  STTagManager* tagManager = [[STTagManager alloc] init];
//
//  STFieldTag* secondTag = [[STFieldTag alloc] initWithTag:tag andFieldTag:recreatedTag];
//  NSLog(@"%@", [secondTag Serialize:nil]);
//
//  
//  STFieldTag* secondFieldTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:@0];
//  NSLog(@"formatted result : %@", [secondFieldTag FormattedResult]);
//  NSLog(@"%@", [secondFieldTag Serialize:nil]);
//
//
//  STFieldTag* thirdFieldTag = [[STFieldTag alloc] initWithTag:tag andFieldTag:secondFieldTag];
//  NSLog(@"%@", [thirdFieldTag Serialize:nil]);
//  
//  
//  
//  /*
//  // Assert.AreEqual(tag.FigureFormat, recreatedTag.FigureFormat);
//  // how can we test equality? or are they both supposed to be nil?
//  // in obj-c, any [nil isEqual: nil] comparison will fail
//  // http://stackoverflow.com/questions/5914845/sending-isequal-to-nil-always-returns-no
//  
//  //both are nil
//  //XCTAssert([[tag FigureFormat] isEqual:[recreatedTag FigureFormat]]);//nil so they won't match
//  XCTAssertNil([tag FigureFormat]);
//  XCTAssertNil([recreatedTag FigureFormat]);
//  
//  XCTAssert([[tag FormattedResult] isEqualToString:[recreatedTag FormattedResult]]);
//  //XCTAssertNil([tag FormattedResult]);
//  //XCTAssertNil([recreatedTag FormattedResult]);
//  
//  XCTAssertEqual([[tag LineEnd] integerValue], [[recreatedTag LineEnd] integerValue]);
//  XCTAssertEqual([[tag LineStart] integerValue], [[recreatedTag LineStart] integerValue]);
//  
//  //how are these matching if tag.Name is (nil) and the normalized recreatedTag.Name is ""?
//  //NOTE: spoke w/ Luke - normalize occurs before we serialize/deserialize, so the value will be "" for both
//  XCTAssert([[tag Name] isEqualToString:[recreatedTag Name]]);
//  
//  //both are nil
//  //XCTAssert([[tag RunFrequency] isEqualToString:[recreatedTag RunFrequency]]);
//  XCTAssertNil([tag RunFrequency]);
//  XCTAssertNil([recreatedTag RunFrequency]);
//  
//  XCTAssert([[tag Type] isEqual:[recreatedTag Type]]);
//  
//  // how can we test equality? or are they both supposed to be nil?
//  //both are nil
//  //NSLog(@"[tag ValueFormat] : %@", [tag ValueFormat]);
//  //NSLog(@"[recreatedTag ValueFormat] : %@", [recreatedTag ValueFormat]);
//  //XCTAssert([[tag ValueFormat] isEqual:[recreatedTag ValueFormat]]);
//  XCTAssertNil([tag ValueFormat]);
//  XCTAssertNil([recreatedTag ValueFormat]);
//  
//  //both are nil
//  //NSLog(@"[tag TableFormat] : %@", [tag TableFormat]);
//  //NSLog(@"[recreatedTag TableFormat] : %@", [recreatedTag TableFormat]);
//  //XCTAssert([[tag TableFormat] isEqual:[recreatedTag TableFormat]]);
//  XCTAssertNil([tag TableFormat]);
//  XCTAssertNil([recreatedTag TableFormat]);
//  
//  //both are nil
//  //NSLog(@"[tag FigureFormat] : %@", [tag FigureFormat]);
//  //NSLog(@"[recreatedTag FigureFormat] : %@", [recreatedTag FigureFormat]);
//  //XCTAssert([[tag FigureFormat] isEqual:[recreatedTag FigureFormat]]); //duplicate test
//  XCTAssertNil([tag FigureFormat]);
//  XCTAssertNil([recreatedTag FigureFormat]);
//  
//  XCTAssertEqual([[tag TableCellIndex] integerValue], [[recreatedTag TableCellIndex] integerValue]);
//  // The recreated tag doesn't truly recreate the code file object.  We attempt to restore it the best we can with the file path.
//  
//  XCTAssert([[tag CodeFilePath]  isEqual:[[recreatedTag CodeFile] FilePath] ]);
//  XCTAssert([[tag CodeFilePath]  isEqual:[recreatedTag CodeFilePath] ]);
//   */
//}
//


- (void)testLinkToCodeFile_Found {
  
  STCodeFile* cf = [STCodeFile codeFileWithFilePath:@"Test.do"];
  NSMutableArray<STCommandResult*>* ar_cr = [[NSMutableArray<STCommandResult*> alloc] init];
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test 1";
  STFieldTag* tag = [STFieldTag tagWithName:nil andCodeFile:cf andType:[STConstantsTagType Table]];
  tag.CachedResult = ar_cr;
  tag.TableCellIndex = @10;

  NSString* url = @"Test.do";
  STCodeFile* cf_1 = [STCodeFile codeFileWithFilePath:url];
  url = @"Test2.do";
  STCodeFile* cf_2 = [STCodeFile codeFileWithFilePath:url];
  NSMutableArray<STCodeFile*>* files = [NSMutableArray<STCodeFile*> arrayWithObjects:cf_1, cf_2, nil];
  
  [STFieldTag LinkToCodeFile:tag CodeFile:files];
  XCTAssertEqual(files[0], [tag CodeFile]);

  url = [[files[0] FilePath] uppercaseString];
  files[0].FilePath = url;
  [STFieldTag LinkToCodeFile:tag CodeFile:files];
  XCTAssertEqual(files[0], [tag CodeFile]);
  //EWW - for the above... we should be careful about OSX case sensitivity with paths
}

- (void)testLinkToCodeFile_NotFound {
  NSMutableArray<STCommandResult*>* ar_cr = [[NSMutableArray<STCommandResult*> alloc] init];
  STCommandResult* cr = [[STCommandResult alloc] init];
  cr.ValueResult = @"Test 1";
  STFieldTag* tag = [STFieldTag tagWithName:nil andCodeFile:nil andType:[STConstantsTagType Table]];
  tag.CachedResult = ar_cr;
  tag.TableCellIndex = @10;

  NSString* url = @"Test.do";
  STCodeFile* cf_1 = [STCodeFile codeFileWithFilePath:url];
  url = @"Test2.do";
  STCodeFile* cf_2 = [STCodeFile codeFileWithFilePath:url];
  NSMutableArray<STCodeFile*>* files = [NSMutableArray<STCodeFile*> arrayWithObjects:cf_1, cf_2, nil];

  
  // Check against a null list.
  [STFieldTag LinkToCodeFile:tag CodeFile:nil];
  XCTAssertNil([tag CodeFile]);
  
  // Check against the real list.
  [STFieldTag LinkToCodeFile:tag CodeFile:files];
  XCTAssertNil([tag CodeFile]);
  
  // Should match with case differences
  STCodeFile* cf = [STCodeFile codeFileWithFilePath:@"Test3.do"];
  tag.CodeFile = cf;
  [STFieldTag LinkToCodeFile:tag CodeFile:files];
  XCTAssertNotEqual(files[0], [tag CodeFile]);
  XCTAssertNotEqual(files[1], [tag CodeFile]);
  
}

-(void)testMacroContentEscaping
{
  
  NSLog(@"%@", [STFieldGenerator escapeMacroContent:@"hello"]);
  NSLog(@"%@", [STFieldGenerator escapeMacroContent:@"hello > 0.1"]);
  NSLog(@"%@", [STFieldGenerator escapeMacroContent:@"hello < 0.1"]);
  NSLog(@"%@", [STFieldGenerator escapeMacroContent:@"\"hello!\" he said"]);
  NSLog(@"%@", [STFieldGenerator escapeMacroContent:@"hello 0.0 < 0.1 and 0.2 > 0.1"]);
  NSLog(@"%@", [STFieldGenerator escapeMacroContent:@"hello 0.0 < 0.1 and 0.2 > 0.1 but {something} said \"HELLO!\""]);
  
}


@end
