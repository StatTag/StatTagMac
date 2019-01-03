//
//  StatTagRParserTests.m
//  StatTag
//
//  Created by Rasmussen, Luke on 8/23/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagRParserTests : XCTestCase

@end

@implementation StatTagRParserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsValueDisplay {
  // We consider anything to be a candidate value, given how R works, so this is just
  // to assert it should always return true.
  STRParser* parser = [[STRParser alloc] init];
  XCTAssertTrue([parser IsValueDisplay:@"Anything can go here"]);
}

- (void)testGetValueName {
  // We are unrestrictive on what can be considered a value, so we don't ever return
  // a value name.  This just asserts it's always an empty string returned.
  STRParser* parser = [[STRParser alloc] init];
  XCTAssertEqualObjects(@"", [parser GetValueName:@"Anything can go here"]);
}

- (void)testIsImageExport {
  STRParser* parser = [[STRParser alloc] init];
  XCTAssertTrue([parser IsImageExport:@"png('test.png')"]);
  XCTAssertTrue([parser IsImageExport:@"png(\"test.png\")"]);
  XCTAssertFalse([parser IsImageExport:@"png(\"test.png\""]);
  XCTAssertTrue([parser IsImageExport:@" png ( \"test.png\" ) "]);
  XCTAssertFalse([parser IsImageExport:@"spng(\"test.png\""]);
  XCTAssertFalse([parser IsImageExport:@"pngs('test.png')"]);
  XCTAssertFalse([parser IsImageExport:@"pn('test.png')"]);
  XCTAssertTrue([parser IsImageExport:@"png\r\n(\r\n\"test.png\"\r\n)\r\n"]);
  XCTAssertTrue([parser IsImageExport:@"png('test, file.png')"]);

  XCTAssertTrue([parser IsImageExport:@"pdf('test.pdf')"]);
  XCTAssertTrue([parser IsImageExport:@"win.metafile('test.wmf')"]);
  XCTAssertTrue([parser IsImageExport:@"jpeg('test.jpg')"]);
  XCTAssertTrue([parser IsImageExport:@"png('test.png')"]);
  XCTAssertTrue([parser IsImageExport:@"bmp('test.bmp')"]);
  XCTAssertTrue([parser IsImageExport:@"postscript('test.ps')"]);
}

-(void) testGetImageSaveLocation {
  STRParser* parser = [[STRParser alloc] init];
  XCTAssertEqualObjects(@"\"test.pdf\"", [parser GetImageSaveLocation:@"pdf(\"test.pdf\")"]);
  XCTAssertEqualObjects(@"\"test.pdf\"", [parser GetImageSaveLocation:@"pdf(\"test.pdf\",100,100)"]);
  XCTAssertEqualObjects(@"\"test.png\"", [parser GetImageSaveLocation:@"png(width = 100, height=100, \r\n\tfile=\r\n\t\t\"test.png\")"]);
  XCTAssertEqualObjects(@"\"test.png\"", [parser GetImageSaveLocation:@"png(\"test.png\", width=100,height=100)"]);
  XCTAssertEqualObjects(@"\"test.png\"", [parser GetImageSaveLocation:@"png(width=100, \"test.png\", height=100)"]); // First unnamed parameter is file
  XCTAssertEqualObjects(@"\"test.png\"", [parser GetImageSaveLocation:@"png (width=100,height=100,fi=\r\n\t\"test.png\")"]);
  XCTAssertEqualObjects(@"\"test.png\"", [parser GetImageSaveLocation:@"png (width=100,height=100,FILE=\r\n\t\"test.png\")"]); // Check capitalization is ignored
  XCTAssertEqualObjects(@"\"test.png\"", [parser GetImageSaveLocation:@"png(width=100,f=\"test.png\",height=100)"]);
  XCTAssertEqualObjects(@"'test.png'", [parser GetImageSaveLocation:@"png(width=100,file='test.png',height=100)"]);
  XCTAssertEqualObjects(@"\"C:\\\\Test\\\\Path with spaces\\\\test.pdf\"", [parser GetImageSaveLocation:@"pdf(\"C:\\\\Test\\\\Path with spaces\\\\test.pdf\")"]);
  XCTAssertEqualObjects(@"\"C:\\\\Test\\\\Path's\\\\test.pdf\"", [parser GetImageSaveLocation:@"pdf(\"C:\\\\Test\\\\Path's\\\\test.pdf\")"]);
  XCTAssertEqualObjects(@"", [parser GetImageSaveLocation:@"png(width=100, height=100)"]); // Here there is no unnamed parameter or file parameter (this would be an error in R)
  XCTAssertEqualObjects(@"", [parser GetImageSaveLocation:@"spng(width=100,'test.png',height=100)"]);
  XCTAssertEqualObjects(@"\"test, file.png\"", [parser GetImageSaveLocation:@"png(width = 100, height=100, filename=\"test, file.png\")"]);

  // Allow paste command to be used for file name parameter.  Make sure nested functions are processed correctly too.
  XCTAssertEqualObjects(@"paste(\"test\", \".pdf\")", [parser GetImageSaveLocation:@"pdf(file=paste(\"test\", \".pdf\"))"]);
  XCTAssertEqualObjects(@"paste(\"test\", paste(\".\", \"pdf\"))", [parser GetImageSaveLocation:@"pdf(file=paste(\"test\", paste(\".\", \"pdf\")))"]);
  XCTAssertEqualObjects(@"paste(\"test\", \".pdf\")", [parser GetImageSaveLocation:@"pdf(paste(\"test\", \".pdf\"))"]);
  XCTAssertEqualObjects(@"paste(\"test\", \".pdf\", sep=\"\")", [parser GetImageSaveLocation:@"pdf(paste(\"test\", \".pdf\", sep=\"\"))"]);
  XCTAssertEqualObjects(@"paste(\"test\", paste(\".\", \"pdf\"))", [parser GetImageSaveLocation:@"pdf(paste(\"test\", paste(\".\", \"pdf\")))"]);

  // Variable names should be allowed for file name parameter too
  XCTAssertEqualObjects(@"file_path", [parser GetImageSaveLocation:@"pdf(file=file_path)"]);

  // Some duplication, but verifies each file type works
  XCTAssertEqualObjects(@"\"test.pdf\"", [parser GetImageSaveLocation:@"pdf(\"test.pdf\")"]);
  XCTAssertEqualObjects(@"\"test.wmf\"", [parser GetImageSaveLocation:@"win.metafile(\"test.wmf\")"]);
  XCTAssertEqualObjects(@"\"test.jpeg\"", [parser GetImageSaveLocation:@"jpeg(\"test.jpeg\")"]);
  XCTAssertEqualObjects(@"\"test.png\"", [parser GetImageSaveLocation:@"png(\"test.png\")"]);
  XCTAssertEqualObjects(@"\"test.bmp\"", [parser GetImageSaveLocation:@"bmp(\"test.bmp\")"]);
  XCTAssertEqualObjects(@"\"test.ps\"", [parser GetImageSaveLocation:@"postscript(\"test.ps\")"]);

  // If we have two image commands in the same text block, we will get the first one
  XCTAssertEqualObjects(@"\"test.pdf\"", [parser GetImageSaveLocation:@"pdf(\"test.pdf\");png(\"test.png\")"]);
}


-(void) testIsTableResult
{
  // Right now we assume anything could be a table, so IsTableResult will always return true
  STRParser* parser = [[STRParser alloc] init];
  XCTAssertTrue([parser IsTableResult:@"doesn't matter what i put here"]);
}


-(void) testGetTableName
{
  // Same as with IsTableResult we are ignoring finding table names, so this always returns an empty string.
  STRParser* parser = [[STRParser alloc] init];
  XCTAssertEqualObjects(@"", [parser GetTableName:@"doesn't matter what i put here"]);
}


-(void) testCollapseMultiLineCommands
{
  STRParser* parser = [[STRParser alloc] init];

  // No commands to collapse
  NSArray<NSString*>* text = [NSArray<NSString*> arrayWithObjects:@"line 1", @"line 2", @"line 3", nil];

  NSArray<NSString*>* modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(3, [modifiedText count]);


  // Simple multiline and single line combined
  text = [NSArray<NSString*> arrayWithObjects:
          @"cmd(",
          @"  param",
          @")",
          @"cmd2()", nil];
  modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(2, [modifiedText count]);
  XCTAssertEqualObjects(@"cmd(    param  )", modifiedText[0]);
  XCTAssertEqualObjects(@"cmd2()", modifiedText[1]);

  // Nested multiline
  text = [NSArray<NSString*> arrayWithObjects:
          @"cmd(",
          @"\tparam(tmp(), (",
          @")))", nil];
  modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(1, [modifiedText count]);
  XCTAssertEqualObjects(@"cmd(  \tparam(tmp(), (  )))", modifiedText[0]);

  // Nested and unbalanced (not enough closing parens)
  text = [NSArray<NSString*> arrayWithObjects:
          @"cmd(",
          @"\tparam(tmp(), (",
          @"))", nil];
  modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(3, [modifiedText count]);

  // Parens at the bounds
  text = [NSArray<NSString*> arrayWithObjects:@"()", nil];
  modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(1, [modifiedText count]);
  XCTAssertEqualObjects(text[0], modifiedText[0]);

  // Unbalanced (not enough opening parens)
  text = [NSArray<NSString*> arrayWithObjects:
          @"cmd(",
          @"))", nil];
  modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(1, [modifiedText count]);
  XCTAssertEqualObjects(@"cmd(  ))", modifiedText[0]);
}

-(void) testCollapseMultiLineCommands_PlotCommands
{
  STRParser* parser = [[STRParser alloc] init];
  
  // Multiple ggplot commands strung together across multiple lines, with varying
  // whitespace between the segments
  NSArray<NSString*>* text = [NSArray<NSString*> arrayWithObjects:
          @"Plot_DistSpeed <- ggplot(data=cars, aes(x=dist, y=speed)) +",
          @" \t geom_boxplot() +",
          @"geom_point()+",
          @"ggtitle(\"Dist x Speed\") + \t ",
          @"theme(plot.title = element_text(hjust = 0.5))", nil];
  NSArray<NSString*>* modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(1, [modifiedText count]);
  XCTAssertEqualObjects(@"Plot_DistSpeed <- ggplot(data=cars, aes(x=dist, y=speed)) + geom_boxplot() + geom_point() + ggtitle(\"Dist x Speed\") + theme(plot.title = element_text(hjust = 0.5))", modifiedText[0]);
  
  // This mixes multi-line commands as well as strung together commands
  text = [NSArray<NSString*> arrayWithObjects:
          @"Plot_DistSpeed <- ggplot(",
          @"  data=cars, aes(x=dist, y=speed)) +",
          @" \t geom_boxplot() +",
          @"geom_point()+",
          @"ggtitle(\"Dist x Speed\") + \t ",
          @"theme(plot.title = element_text(hjust = 0.5))", nil];
  modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(1, [modifiedText count]);
  XCTAssertEqualObjects(@"Plot_DistSpeed <- ggplot(    data=cars, aes(x=dist, y=speed)) + geom_boxplot() + geom_point() + ggtitle(\"Dist x Speed\") + theme(plot.title = element_text(hjust = 0.5))", modifiedText[0]);
  
  // This isn't valid R, but makes sure we're not collapsing general addition
  text = [NSArray<NSString*> arrayWithObjects:
          @"1 + ",
          @"2 + ",
          @"3+4+5+",
          @"\t6", nil];
  modifiedText = [parser CollapseMultiLineCommands:text];
  XCTAssertEqual(4, [modifiedText count]);
  XCTAssertEqualObjects(@"1 + \r\n2 + \r\n3+4+5+\r\n\t6", [modifiedText componentsJoinedByString:@"\r\n"]);
}


-(void) testPreProcessContent
{
  STRParser* parser = [[STRParser alloc] init];

  // No comments to remove
  NSArray<NSString*>* text = [NSArray<NSString*> arrayWithObjects:@"line 1", @"line 2", @"line 3", nil];
  NSArray<NSString*>* modifiedText = [parser PreProcessContent:text automation:nil];
  XCTAssertEqual([text count], [modifiedText count]);
  for (int index = 0; index < [text count]; index++) {
    XCTAssertEqualObjects(text[index], modifiedText[index]);
  }

  text = [NSArray<NSString*> arrayWithObjects:@"line 1 // comment", @"line 2", @"line 3", nil];
  modifiedText = [parser PreProcessContent:text automation:nil];
  XCTAssertEqual([text count], [modifiedText count]);
  XCTAssertEqualObjects(@"line 1 ", modifiedText[0]);

  text = [NSArray<NSString*> arrayWithObjects:@"line 1 // comment",
    @"hours <- read.csv(file = \"//path/to/data.csv\",header=TRUE, na=\"\") // comment 2",
    @"line 3 // comment 3",
          nil];
  modifiedText = [parser PreProcessContent:text automation:nil];
  XCTAssertEqual([text count], [modifiedText count]);
  XCTAssertEqualObjects(@"line 1 ", modifiedText[0]);
  XCTAssertEqualObjects(@"hours <- read.csv(file = \"//path/to/data.csv\",header=TRUE, na=\"\") ", modifiedText[1]);
  XCTAssertEqualObjects(@"line 3 ", modifiedText[2]);
}

@end
