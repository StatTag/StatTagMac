//
//  StatTagParserBaseParserStataTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagParserBaseParserStataTests : XCTestCase

@end

@implementation StatTagParserBaseParserStataTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}


-(void)testIsImageExport
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertFalse([parser IsImageExport:@"graph"]);
  XCTAssertTrue([parser IsImageExport:@"graph export"]);
  XCTAssertTrue([parser IsImageExport:@"  graph export  "]);
  XCTAssertTrue([parser IsImageExport:@"  graph    export  "]);   // Stata allows whitespace between commands
  XCTAssertFalse([parser IsImageExport:@"graph exporter"]);
  XCTAssertFalse([parser IsImageExport:@"agraph exporter"]);
  XCTAssertFalse([parser IsImageExport:@"a graph exporter"]);
  XCTAssertTrue([parser IsImageExport:@"graph export file=tmp.pdf"]);
}

-(void)testIsValueDisplay
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertFalse([parser IsValueDisplay:@"displa"]);
  XCTAssertTrue([parser IsValueDisplay:@"display"]);
  XCTAssertTrue([parser IsValueDisplay:@"  display  "]);
  XCTAssertFalse([parser IsValueDisplay:@"displayed"]);
  XCTAssertFalse([parser IsValueDisplay:@"adisplay"]);
  XCTAssertFalse([parser IsValueDisplay:@"a display"]);
  XCTAssertTrue([parser IsValueDisplay:@"display value"]);
  
  //NOTE: note the lack of "s" in "di[s]play"
  XCTAssertFalse([parser IsValueDisplay:@"diplay value"]);// Making sure our optional capture of "s" doesn't cause invalid commands to be accepted

  XCTAssertTrue([parser IsValueDisplay:@"di value"]);  // Handle abbreviated command
  XCTAssertTrue([parser IsValueDisplay:@"dis value"]);  // Handle abbreviated command
}

-(void)testIsMacroDisplayValue
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertFalse([parser IsMacroDisplayValue: @"displa `x'"]);
  XCTAssertTrue([parser IsMacroDisplayValue: @"display `x'"]);
  XCTAssertTrue([parser IsMacroDisplayValue: @"display ` x '"]);
  XCTAssertTrue([parser IsMacroDisplayValue: @"  display   `x'   "]);
  XCTAssertFalse([parser IsMacroDisplayValue: @"display 'x'"]);
  XCTAssertFalse([parser IsMacroDisplayValue: @"display `'"]);

}

-(void)testIsTableResult
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertFalse([parser IsTableResult: @"matri lis"]);
  XCTAssertTrue([parser IsTableResult: @"matrix list"]);
  XCTAssertTrue([parser IsTableResult: @"  matrix   list "]);
  XCTAssertFalse([parser IsTableResult: @"matrix listed"]);
  XCTAssertFalse([parser IsTableResult: @"amatrix list"]);
  XCTAssertFalse([parser IsTableResult: @"a matrix list"]);
  XCTAssertTrue([parser IsTableResult: @"matrix list value"]);
  XCTAssertTrue([parser IsTableResult: @"mat l value"]);  // Handle abbreviated command
  XCTAssertTrue([parser IsTableResult: @"matrix list r(coefs)"]);
}

-(void)testIsTableResult_DataFile
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertTrue([parser IsTableResult:@"estadd using test.csv"]);  // Even though this isn't allowed for data export ("estadd"), we are just checking the presence of file paths
  XCTAssertTrue([parser IsTableResult:@"estout using test.csv"]);
  XCTAssertTrue([parser IsTableResult:@"estout using C:\\test.csv"]);
  XCTAssertTrue([parser IsTableResult:@"estout using /c:/test.csv"]);
  XCTAssertTrue([parser IsTableResult:@"esttab using example.csv, replace wide plain"]);
  XCTAssertTrue([parser IsTableResult:@"  esttab  using  example.csv ,  replace  wide  plain "]);
  XCTAssertFalse([parser IsTableResult:@"estadd using test csv"]);

  // Handle local and global macro values - they MAY contain a filename, so the heuristic check should allow them
  XCTAssertTrue([parser IsTableResult:@"estout using `filename'"]);
  XCTAssertTrue([parser IsTableResult:@"estout using $filename"]);
  XCTAssertFalse([parser IsTableResult:@"estout using $ filename"]);
}

-(void)testIsStartingLog
{
  STStataParser* parser = [[STStataParser alloc] init];

  XCTAssertFalse([parser IsStartingLog: @"*log using tmp.txt"]);
  XCTAssertFalse([parser IsStartingLog: @"*cmdlog using tmp.txt"]);
  XCTAssertFalse([parser IsStartingLog: @"  *  log using tmp.txt  "]);
  XCTAssertFalse([parser IsStartingLog: @"  *  cmdlog using tmp.txt  "]);
  XCTAssertFalse([parser IsStartingLog: @"l og using tmp.txt  "]);
  XCTAssertFalse([parser IsStartingLog: @"logs using tmp.txt  "]);
  XCTAssertFalse([parser IsStartingLog: @"cmdlogs using tmp.txt  "]);
  XCTAssertFalse([parser IsStartingLog: @"cmd log using tmp.txt  "]);
  XCTAssertTrue([parser IsStartingLog: @"log using tmp.txt"]);
  XCTAssertTrue([parser IsStartingLog: @" log   using   tmp.txt   "]);
  XCTAssertTrue([parser IsStartingLog: @"cmdlog using tmp.txt"]);
  XCTAssertTrue([parser IsStartingLog: @" cmdlog   using   tmp.txt   "]);
  XCTAssertTrue([parser IsStartingLog: @"*comment line followed by command\r\ncmdlog   using   tmp.txt   "]);

}

-(void) ValidateFoundLogs:(NSArray<NSString*>*)expected received:(NSArray<NSString*>*)received
{
  //NSLog(@"ValidateFoundLogs - expected: %@, received: %@", expected, received);
  XCTAssertEqual([expected count], [received count]);
  for(NSString* log in expected) {
      XCTAssertTrue([received containsObject:log]);
  }
}

-(void)testGetLogType
{
  STStataParser* parser = [[STStataParser alloc] init];

  XCTAssertNil([parser GetLogType: @"*log using tmp.txt"]);
  XCTAssertNil([parser GetLogType: @"*cmdlog using tmp.txt"]);
  XCTAssertNil([parser GetLogType: @"  *  log using tmp.txt  "]);
  XCTAssertNil([parser GetLogType: @"  *  cmdlog using tmp.txt  "]);
  XCTAssertNil([parser GetLogType: @"l og using tmp.txt  "]);
  XCTAssertNil([parser GetLogType: @"logs using tmp.txt  "]);
  XCTAssertNil([parser GetLogType: @"cmdlogs using tmp.txt  "]);
  XCTAssertNil([parser GetLogType: @"cmd log using tmp.txt  "]);

  [self ValidateFoundLogs:@[@"log"] received:[parser GetLogType: @"log using tmp.txt"]];
  [self ValidateFoundLogs:@[@"log"] received:[parser GetLogType: @" log   using   tmp.txt   "]];
  [self ValidateFoundLogs:@[@"cmdlog"] received:[parser GetLogType: @"cmdlog using tmp.txt"]];
  [self ValidateFoundLogs:@[@"cmdlog"] received:[parser GetLogType: @" cmdlog   using   tmp.txt   "]];
  [self ValidateFoundLogs:@[@"log"] received:[parser GetLogType: @"log   using   log using 2.txt   "]];
  [self ValidateFoundLogs:@[@"log", @"cmdlog"] received:[parser GetLogType: @"log using log.txt\r\ncmdlog using cmdlog.txt"]];
  [self ValidateFoundLogs:@[@"log", @"cmdlog"] received:[parser GetLogType: @"cmdlog using cmdlog.txt\r\nlog using log.txt"]];
  [self ValidateFoundLogs:@[@"log"] received:[parser GetLogType: @"*cmdlog using cmdlog.txt\r\nlog using log.txt"]];
  [self ValidateFoundLogs:@[@"log", @"log"] received:[parser GetLogType: @"log using log.txt\r\nlog using log2.txt"]];
}

-(void)testGetImageSaveLocation
{
  STStataParser* parser = [[STStataParser alloc] init];

  XCTAssert([@"C:\\Development\\Stats\\bpgraph.pdf" isEqualToString:[parser GetImageSaveLocation:@"graph export \"C:\\Development\\Stats\\bpgraph.pdf\", as(pdf) replace"]]);

  XCTAssert([@"C:\\Development\\Stats\\bpgraph.pdf" isEqualToString: [parser GetImageSaveLocation: @" graph   export   \"C:\\Development\\Stats\\bpgraph.pdf\" ,  as(pdf)  replace"]]);
  XCTAssert([@"" isEqualToString: [parser GetImageSaveLocation: @"agraph export \"C:\\Development\\Stats\\bpgraph.pdf\", as(pdf) replace"]]);
  XCTAssert([@"mygraph.pdf" isEqualToString: [parser GetImageSaveLocation: @"graph export mygraph.pdf"]]);
  XCTAssert([@"mygraph.pdf" isEqualToString: [parser GetImageSaveLocation: @"graph export mygraph.pdf, as(pdf)"]]);
  XCTAssert([@"mygraph.pdf" isEqualToString: [parser GetImageSaveLocation: @"gr export mygraph.pdf"]]); // "gr" shortcut
  XCTAssertFalse( [@"mygraph.pdf" isEqualToString: [parser GetImageSaveLocation: @"gra export mygraph.pdf"]]);
  XCTAssert([@"C:\\Development\\Stats\\bpgraph.pdf" isEqualToString: [parser GetImageSaveLocation: @"gr export \"C:\\Development\\Stats\\bpgraph.pdf\", as(pdf) replace"]]);

  // Test paths with single quotes
  XCTAssert([@"C:\\Test\\Stat's\\bpgraph.pdf" isEqualToString: [parser GetImageSaveLocation: @"gr export \"C:\\Test\\Stat's\\bpgraph.pdf\", as(pdf) replace"]]);
}

-(void)testGetValueName
{
  STStataParser* parser = [[STStataParser alloc] init];
  //NSLog(@"TEST VALUE: [parser GetValueName: \"display (5*2)\"] :  %@", [parser GetValueName: @"display (5*2)"]);
  
  XCTAssert([ @"test" isEqualToString: [parser GetValueName: @"display test"]]);
  XCTAssert([ @"`x2'" isEqualToString: [parser GetValueName: @"display  `x2'"]]);
  XCTAssert([ @"test" isEqualToString: [parser GetValueName: @" display   test  "]]);
  
  //NSLog(@"TEST VALUE: [parser GetValueName: \"adisplay test\"] :  %@", [parser GetValueName: @"adisplay test"]);
  XCTAssert([ @"" isEqualToString: [parser GetValueName: @"adisplay test"]]);
  XCTAssert([ @"test" isEqualToString: [parser GetValueName: @"display (test)"]]);
  XCTAssert([ @"test" isEqualToString: [parser GetValueName: @"display(test)"]]);
  XCTAssert([ @"r(n)" isEqualToString: [parser GetValueName: @"display r(n)"]]);
  XCTAssert([ @"n*(3)" isEqualToString: [parser GetValueName: @"display n*(3)"]]);
  XCTAssert([ @"r(n)" isEqualToString: [parser GetValueName: @"display r(n)\r\n\r\n*Some comments following"]]);
  XCTAssert([ @"2" isEqualToString: [parser GetValueName: @"display 2 \r\n \r\n*Some comments following"]]);
  XCTAssert([ @"5*2" isEqualToString: [parser GetValueName: @"display (5*2)"]]); // Handle calculations as display parameters
  XCTAssert([ @"5*2+(7*8)" isEqualToString: [parser GetValueName: @"display(5*2+(7*8))"]]); // Handle calculations with nested parentheses
  
  //NOTE: this test should fail. In the original C# the regex approach is different
  // we can't do exactly the same thing (at the moment) with the obj-c version, so we're going to fail this test case. Leaving it as a failure so it's clear where/how/why we deviate
  //XCTAssert([ @"(5*2" isEqualToString: [parser GetValueName: @"display (5*2"]]); // Mismatched parentheses.  We want to grab it, even though it'll be an error in Stata
  //NSLog(@"TEST VALUE: [parser GetValueName: \"display (5*2\"] :  %@", [parser GetValueName: @"display (5*2"]);

  XCTAssert([ @"7   *    8   +   ( 5 * 7 )" isEqualToString: [parser GetValueName: @"  display   (  7   *    8   +   ( 5 * 7 )  )   "]]);
  // Stata does not appear to support multiple commands on one line, even in a do file, so this shouldn't work.  We are just asserting that we don't
  // support this functionality.
  XCTAssertFalse([ @"test" isEqualToString: [parser GetValueName: @"display test; display test"]]);

}

-(void)testIsCalculatedDisplayValue
{
  STStataParser* parser = [[STStataParser alloc] init];

  XCTAssertFalse([parser IsCalculatedDisplayValue: nil]);
  XCTAssertFalse([parser IsCalculatedDisplayValue: @""]);
  XCTAssertFalse([parser IsCalculatedDisplayValue: @"2*3"]);
  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display (5*2)"]);
  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display(5*2+(7*8])"]);
  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display 5*2"]);
  XCTAssertFalse([parser IsCalculatedDisplayValue: @"display r[n]"]);

  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display 5"]);
  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display 00005"]);
  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display 5."]);
  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display 0.3059"]);
  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display .3059"]);
  XCTAssertTrue([parser IsCalculatedDisplayValue: @"display 5e-10"]);
  XCTAssertFalse([parser IsCalculatedDisplayValue: @"display 5test"]);
  XCTAssertFalse([parser IsCalculatedDisplayValue: @"display 5,000"]);
}

-(void)testGetMacroValueName
{
  STStataParser* parser = [[STStataParser alloc] init];

  XCTAssertTrue([ @"x2" isEqualToString: [parser GetMacroValueName: @"display  `x2'"]]);
  XCTAssertTrue([ @"x2" isEqualToString: [parser GetMacroValueName: @"display  $x2"]]);
  XCTAssertTrue([ @"x2" isEqualToString: [parser GetMacroValueName: @"display  `x2'\r\n\r\n*Some comments following"]]);
  XCTAssertTrue([ @"test" isEqualToString: [parser GetMacroValueName: @"display test"]]);   // This isn't a proper Stata macro value, but is the expected return
}

-(void)testGetTableName
{
  STStataParser* parser = [[STStataParser alloc] init];
  
  XCTAssert([@"test_matrix" isEqualToString: [parser GetTableName: @"matrix list test_matrix"]]);
  XCTAssert([@"test_matrix" isEqualToString: [parser GetTableName: @"   matrix   list    test_matrix  "]]);
  XCTAssert([@"test  value" isEqualToString: [parser GetTableName: @"   matrix   list    test  value  "]]);  // Not sure if this is valid for Stata, but it's what we should pull out
  XCTAssert([@"" isEqualToString: [parser GetTableName: @"amatrix list test"]]);
  XCTAssert([@"test" isEqualToString: [parser GetTableName: @"mat list test"]]);
  XCTAssert([@"test" isEqualToString: [parser GetTableName: @"mat l test"]]);
  XCTAssert([@"r(coefs)" isEqualToString: [parser GetTableName: @"mat l r(coefs)"]]);
  XCTAssert([@"test" isEqualToString: [parser GetTableName: @"mat l test, format(%5.0g)"]]);
  XCTAssert([@"r ( coefs )" isEqualToString: [parser GetTableName: @"mat list r ( coefs ) "]]);
  XCTAssert([@"B" isEqualToString: [parser GetTableName: @"matrix list B\r\n\r\n*Some comments following"]]);
}

-(void)testGetTableDataPath
{
  STStataParser* parser = [[STStataParser alloc] init];

  // Check for file names
  XCTAssert([@"example.csv" isEqualToString: [parser GetTableDataPath: @"esttab using example.csv, replace wide plain"]]);
  XCTAssert([@"example.csv" isEqualToString: [parser GetTableDataPath: @"esttab using example.csv , replace wide plain"]]);
  XCTAssert([@"example 2.csv" isEqualToString: [parser GetTableDataPath: @"esttab using \"example 2.csv\", replace wide plain"]]);

  // Check for file paths
  XCTAssert([@"C:\\example.csv" isEqualToString: [parser GetTableDataPath: @"esttab using C:\\example.csv, replace wide plain"]]);
  XCTAssert([@"C:\\data path\\example.csv" isEqualToString: [parser GetTableDataPath: @"esttab using \"C:\\data path\\example.csv\", replace wide plain"]]);
  XCTAssert([@"..\\example.csv" isEqualToString: [parser GetTableDataPath: @"esttab using ..\\example.csv, replace wide plain"]]);
  XCTAssert([@"C:/example.csv" isEqualToString: [parser GetTableDataPath: @"esttab using C:/example.csv, replace wide plain"]]);

  // File paths with single quotes
  XCTAssert([@"C:\\data's path\\example.csv" isEqualToString: [parser GetTableDataPath: @"esttab using \"C:\\data's path\\example.csv\", replace wide plain"]]);

  // Commands with parentheses
  XCTAssert([@"testing.csv" isEqualToString: [parser GetTableDataPath: @"table1, vars(gender cat \\ race cat \\ ridageyr contn %4.2f \\ married cat \\ income cat \\ education cat \\ bmxht contn %4.2f \\ bmxwt conts \\ bmxbmi conts \\ bmxwaist contn %4.2f \\ lbdhdd contn %4.2f \\ lbdldl contn %4.2f \\ lbxtr conts \\ lbxglu conts \\ lbxin conts) saving(testing.csv, replace)"]]);
  XCTAssert([@"testing.csv" isEqualToString: [parser GetTableDataPath: @"table1, vars(gender cat \\ race cat \\ ridageyr contn %4.2f \\ married cat \\ income cat \\ education cat \\ bmxht contn %4.2f \\ bmxwt conts \\ bmxbmi conts \\ bmxwaist contn %4.2f \\ lbdhdd contn %4.2f \\ lbdldl contn %4.2f \\ lbxtr conts \\ lbxglu conts \\ lbxin conts) saving(  testing.csv , replace)"]]);
  XCTAssert([@"testing 2.csv" isEqualToString: [parser GetTableDataPath: @"table1, vars(gender cat \\ race cat \\ ridageyr contn %4.2f \\ married cat \\ income cat \\ education cat \\ bmxht contn %4.2f \\ bmxwt conts \\ bmxbmi conts \\ bmxwaist contn %4.2f \\ lbdhdd contn %4.2f \\ lbdldl contn %4.2f \\ lbxtr conts \\ lbxglu conts \\ lbxin conts) saving(\"testing 2.csv\", replace)"]]);

  // Check for macros
  XCTAssert([@"`filename'" isEqualToString: [parser GetTableDataPath: @"esttab using `filename', replace wide plain"]]);
  XCTAssert([@"$filename" isEqualToString: [parser GetTableDataPath: @"esttab using $filename, replace wide plain"]]);

  // Don't forget you can mix paths and macros
  XCTAssert([@"C:\\`file'" isEqualToString: [parser GetTableDataPath: @"esttab using C:\\`file', replace wide plain"]]);
  XCTAssert([@"C:\\data path\\`file'" isEqualToString: [parser GetTableDataPath: @"esttab using \"C:\\data path\\`file'\", replace wide plain"]]);
}

-(void)testIsTable1Command
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertTrue([parser IsTable1Command:@"table1, vars(gender cat \\ race cat \\ ridageyr contn %4.2f \\ married cat \\ income cat \\ education cat \\ bmxht contn %4.2f \\ bmxwt conts \\ bmxbmi conts \\ bmxwaist contn %4.2f \\ lbdhdd contn %4.2f \\ lbdldl contn %4.2f \\ lbxtr conts \\ lbxglu conts \\ lbxin conts) saving(table1.xls, replace)"]);
  XCTAssertTrue([parser IsTable1Command:@"table1 ,  vars(gender cat \\ race cat \\ ridageyr contn %4.2f \\ married cat \\ income cat \\ education cat \\ bmxht contn %4.2f \\ bmxwt conts \\ bmxbmi conts \\ bmxwaist contn %4.2f \\ lbdhdd contn %4.2f \\ lbdldl contn %4.2f \\ lbxtr conts \\ lbxglu conts \\ lbxin conts) saving(table1.xls, replace)"]);
  XCTAssertFalse([parser IsTable1Command:@"esttab using table1.csv, replace wide plain"]);
  XCTAssertFalse([parser IsTable1Command:@"esttab using $table1, replace wide plain"]);
}

-(void)testPreProcessContent_Empty
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertEqual(0, [[parser PreProcessContent:nil] count]);

  NSArray<NSString*>* emptyList = [[NSArray<NSString*> alloc] init];
  XCTAssertEqual(0, [[parser PreProcessContent:emptyList] count]);
}

-(void)testPreProcessContent_TrailingComment
{
  STStataParser* parser = [[STStataParser alloc] init];
  NSArray<NSString*>* testList;

  // Note that all of the returned arrays have 1 more element than you would
  // expect.  This is because we inject a "clear all" command whenever we
  // pre-process the content and we need to account for it in the output.

  testList = [NSArray<NSString*> arrayWithObjects:
                                  @"First line",
                                  @"Second line",
                                  @"Third line",
                                  nil];
  XCTAssertEqual(4, [[parser PreProcessContent:testList] count]);
  
  testList = [NSArray<NSString*> arrayWithObjects:
              @"First line",
              @"Second line ///",
              @"Third line",
              nil];
  XCTAssertEqual(3, [[parser PreProcessContent:testList] count]);
  /*
   Result:
   "First line",
   "Second line  Third line"
   */
  //NSLog(@"[parser PreProcessContent:testList] : %@", [parser PreProcessContent:testList]);

  testList = [NSArray<NSString*> arrayWithObjects:
              @"First line ///",
              @"Second line ///",
              @"Third line ///",
              nil];
  XCTAssertEqual(2, [[parser PreProcessContent:testList] count]);
  
}

-(void)testPreProcessContent_MultiLineComment
{
  STStataParser* parser = [[STStataParser alloc] init];
  NSArray<NSString*>* testList;

  // Note that all of the returned arrays have 1 more element than you would
  // expect.  This is because we inject a "clear all" command whenever we
  // pre-process the content and we need to account for it in the output.

  //1
  testList = [NSArray<NSString*> arrayWithObjects:
              @"First line",
              @"Second line /*",
              @"*/Third line",
              nil];
  NSArray<NSString*>* results = [parser PreProcessContent:testList];
  XCTAssertEqual(3, [results count]);
  XCTAssert([@"clear all\r\nFirst line\r\nSecond line Third line" isEqualToString:[results componentsJoinedByString:@"\r\n"]]);

  //2
  testList = [NSArray<NSString*> arrayWithObjects:
              @"First line /*",
              @"Second line ///",
              @"Third line */",
              nil];
  results = [parser PreProcessContent:testList];
  XCTAssertEqual(2, [results count]);
  XCTAssert([@"clear all\r\nFirst line" isEqualToString:[results componentsJoinedByString:@"\r\n"]]);

  
  //3
  testList = [NSArray<NSString*> arrayWithObjects:
              @"First line /*",
              @"Second line /*",
              @"Third line */",
              @"Fourth line */",
              nil];
  results = [parser PreProcessContent:testList];
  XCTAssertEqual(2, [results count]);
  XCTAssert([@"clear all\r\nFirst line" isEqualToString:[results componentsJoinedByString:@"\r\n"]]);


  // This was in response to an issue reported by a user.  The code file had multiple comments in it, and our regex
  // was being too greedy and pulling extra code out (until it found the last closing comment indicator)
  testList = [NSArray<NSString*> arrayWithObjects:
              @"/*First line*/",
              @"Second line",
              @"/*Third line*/",
              @"Fourth line",
              nil];
  results = [parser PreProcessContent:testList];
  XCTAssertEqual(5, [results count]);
  XCTAssert([@"clear all\r\n\r\nSecond line\r\n\r\nFourth line" isEqualToString:[results componentsJoinedByString:@"\r\n"]]);

  testList = [NSArray<NSString*> arrayWithObjects:
              @"/*First line*/",
              @"/*Second line*/ /*More on the same line*/",
              @"/*Third line*/",
              @"Fourth line",
              nil];
  results = [parser PreProcessContent:testList];
  XCTAssertEqual(5, [results count]);
  XCTAssert([@"clear all\r\n\r\n \r\n\r\nFourth line" isEqualToString:[results componentsJoinedByString:@"\r\n"]]);

  // This is to test unbalanced comments (missing whitespace near the end so it is treated like
  // an unending comment.
  testList = [NSArray<NSString*> arrayWithObjects:
              @"/*First line",
              @"/*Second line*//*More on the same line*/",
              @"/*Third line",
              @"Fourth line*/*/",
              nil];
  results = [parser PreProcessContent:testList];
  XCTAssertEqual(5, [results count]);
  XCTAssert([@"clear all\r\n/*First line\r\n/*Second line*//*More on the same line*/\r\n/*Third line\r\nFourth line*/*/" isEqualToString:[results componentsJoinedByString:@"\r\n"]]);

  testList = [NSArray<NSString*> arrayWithObjects:
              @"/*First line",
              @"/*Second line*/ /*More on the same line*/",
              @"/*Third line",
              @"Fourth line*/ */",
              nil];
  results = [parser PreProcessContent:testList];
  XCTAssertEqual(1, [results count]);
  XCTAssert([@"clear all" isEqualToString:[results componentsJoinedByString:@"\r\n"]]);

  testList = [NSArray<NSString*> arrayWithObjects:
              @"/**/First line",
              nil];
  XCTAssertEqual(2, [[parser PreProcessContent:testList] count]);
  XCTAssert([@"clear all\r\nFirst line" isEqualToString:[[parser PreProcessContent:testList] componentsJoinedByString:@"\r\n"]]);

  testList = [NSArray<NSString*> arrayWithObjects:
              @"First line/**/",
              nil];
  XCTAssertEqual(2, [[parser PreProcessContent:testList] count]);
  XCTAssert([@"clear all\r\nFirst line" isEqualToString:[[parser PreProcessContent:testList] componentsJoinedByString:@"\r\n"]]);
}


-(void) testGetMacros
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertEqual(0, [[parser GetMacros:nil] count]);
  XCTAssertEqual(0, [[parser GetMacros:@""] count]);
  XCTAssertEqual(0, [[parser GetMacros:@"display x"] count]);

  NSArray<NSString*>* result = [parser GetMacros:@"display `x'"];
  XCTAssertEqual(1, [result count]);
  XCTAssert([@"x" isEqualToString:[result firstObject]]);
  
  result = [parser GetMacros:@"display `x'\\`y'"];
  XCTAssertEqual(2, [result count]);
  XCTAssert([@"x" isEqualToString:[result objectAtIndex:0]]);
  XCTAssert([@"y" isEqualToString:[result objectAtIndex:1]]);

  result = [parser GetMacros:@"display `x'\\$y"];
  XCTAssertEqual(2, [result count]);
  XCTAssert([@"x" isEqualToString:[result objectAtIndex:0]]);
  XCTAssert([@"y" isEqualToString:[result objectAtIndex:1]]);
}

-(void) testIsSavedResultCommand
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertTrue([parser IsSavedResultCommand:@" c(pwd) "]);
  XCTAssertTrue([parser IsSavedResultCommand:@"e(N)"]);
  XCTAssertTrue([parser IsSavedResultCommand:@"r(N)"]);
  XCTAssertFalse([parser IsSavedResultCommand:@"p(N)"]);
  XCTAssertFalse([parser IsSavedResultCommand:@" c ( N ) "]);  // Not valid in Stata because of the space between c and (
}

-(void)testPreProcessExecutionStepCode_Null
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertNil([parser PreProcessExecutionStepCode:nil]);
}

-(void)testPreProcessExecutionStepCode_Empty
{
  STStataParser* parser = [[STStataParser alloc] init];
  STTag* tag = [[STTag alloc] init];
  NSMutableArray<NSString*>* code = [[NSMutableArray<NSString*> alloc] init];
  STExecutionStep* step = [[STExecutionStep alloc] init];
  step.Code = code;
  step.Tag = tag;
  step.Type = [STConstantsExecutionStepType Tag];
  NSArray<NSString*>* result = [parser PreProcessExecutionStepCode:step];
  XCTAssertNotNil(result);
  XCTAssertEqual(0, [result count]);
}

-(void)testPreProcessExecutionStepCode_Tag_Unchanged
{
  // This test does duplicate the code in BaseParserTests, but we want to ensure we are still receiving
  // the same output
  STStataParser* parser = [[STStataParser alloc] init];
  STTag* tag = [[STTag alloc] init];
  NSMutableArray<NSString*>* code = [[NSMutableArray<NSString*> alloc]
                                     initWithObjects:
                                     @"Line 1",
                                     @"Line 2",
                                     @"Line 3",
                                     @"Line 4",
                                     nil];
  STExecutionStep* step = [[STExecutionStep alloc] init];
  step.Code = code;
  step.Tag = tag;
  step.Type = [STConstantsExecutionStepType Tag];
  NSArray<NSString*>* result = [parser PreProcessExecutionStepCode:step];
  XCTAssertNotNil(result);
  XCTAssertEqual([code count], [result count]);
  for (int index = 0; index < [code count]; index++) {
    XCTAssert([[code objectAtIndex:index] isEqualToString:[result objectAtIndex:index]]);
  }
}

-(void)testPreProcessExecutionStepCode_NoTag_Unchanged
{
  // This test does duplicate the code in BaseParserTests, but we want to ensure we are still receiving
  // the same output
  STStataParser* parser = [[STStataParser alloc] init];
  NSMutableArray<NSString*>* code = [[NSMutableArray<NSString*> alloc]
                                     initWithObjects:
                                     @"Line 1",
                                     @"Line 2",
                                     nil];
  STExecutionStep* step = [[STExecutionStep alloc] init];
  step.Code = code;
  step.Type = [STConstantsExecutionStepType Tag];
  NSArray<NSString*>* result = [parser PreProcessExecutionStepCode:step];
  XCTAssertNotNil(result);
  XCTAssertEqual(1, [result count]);
  XCTAssert([@"Line 1\r\nLine 2" isEqualToString:[result objectAtIndex:0]]);
}

-(void)testPreProcessExecutionStepCode_SetMaxvar_NoTag_Single_SeparateLine
{
  STStataParser* parser = [[STStataParser alloc] init];
  NSMutableArray<NSString*>* code = [[NSMutableArray<NSString*> alloc]
                                     initWithObjects:
                                     @"Line 1",
                                     @"set maxvar 1000",
                                     @"Line 3",
                                     nil];
  STExecutionStep* step = [[STExecutionStep alloc] init];
  step.Code = code;
  step.Type = [STConstantsExecutionStepType Tag];
  NSArray<NSString*>* result = [parser PreProcessExecutionStepCode:step];
  XCTAssertNotNil(result);
  XCTAssertEqual(2, [result count]);
  XCTAssert([@"set maxvar 1000" isEqualToString:[result objectAtIndex:0]]);
  XCTAssert([@"Line 1\r\n\r\nLine 3" isEqualToString:[result objectAtIndex:1]]);
}

-(void)testPreProcessExecutionStepCode_SetMaxvar_NoTag_Multiple_SeparateLine
{
  STStataParser* parser = [[STStataParser alloc] init];
  NSMutableArray<NSString*>* code = [[NSMutableArray<NSString*> alloc]
                                     initWithObjects:
                                     @"Line 1",
                                     @"set maxvar 1000\r\nLine 2\r\nset maxvar 2000",
                                     nil];
  STExecutionStep* step = [[STExecutionStep alloc] init];
  step.Code = code;
  step.Type = [STConstantsExecutionStepType Tag];
  NSArray<NSString*>* result = [parser PreProcessExecutionStepCode:step];
  XCTAssertNotNil(result);
  XCTAssertEqual(3, [result count]);
  XCTAssert([@"set maxvar 1000" isEqualToString:[result objectAtIndex:0]]);
  XCTAssert([@"set maxvar 2000" isEqualToString:[result objectAtIndex:1]]);
  XCTAssert([@"Line 1\r\n\r\nLine 2" isEqualToString:[result objectAtIndex:2]]);
}

-(void)testPreProcessExecutionStepCode_SetMaxvar_NoTag_Multiple_SameLine
{
  STStataParser* parser = [[STStataParser alloc] init];
  NSMutableArray<NSString*>* code = [[NSMutableArray<NSString*> alloc]
                                     initWithObjects:
                                     @"Line 1\r\n set  maxvar  500  ",
                                     @"set maxvar 1000\r\nset maxvar 10000",
                                     @"Line 3\r\nsetmaxvar 100",
                                     nil];
  STExecutionStep* step = [[STExecutionStep alloc] init];
  step.Code = code;
  step.Type = [STConstantsExecutionStepType Tag];
  NSArray<NSString*>* result = [parser PreProcessExecutionStepCode:step];
  XCTAssertNotNil(result);
  XCTAssertEqual(4, [result count]);
  XCTAssert([@"set  maxvar  500" isEqualToString:[result objectAtIndex:0]]);
  XCTAssert([@"set maxvar 1000" isEqualToString:[result objectAtIndex:1]]);
  XCTAssert([@"set maxvar 10000" isEqualToString:[result objectAtIndex:2]]);
  XCTAssert([@"Line 1\r\n   \r\n\r\n\r\nLine 3\r\nsetmaxvar 100" isEqualToString:[result objectAtIndex:3]]);  // It's not a valid "set maxvar", so it should be included with
}

-(void)testPreProcessExecutionStepCode_SetMaxvar_Tag_Multiple_SameLine
{
  STStataParser* parser = [[STStataParser alloc] init];
  NSMutableArray<NSString*>* code = [[NSMutableArray<NSString*> alloc]
                                     initWithObjects:
                                     @"Line 1\r\n set  maxvar  500  ",
                                     @"set maxvar 1000\r\nset maxvar 10000",
                                     @"Line 3\r\nsetmaxvar 100",
                                     nil];
  STExecutionStep* step = [[STExecutionStep alloc] init];
  step.Code = code;
  step.Type = [STConstantsExecutionStepType Tag];
  step.Tag = [[STTag alloc] init];
  NSArray<NSString*>* result = [parser PreProcessExecutionStepCode:step];
  XCTAssertNotNil(result);
  XCTAssertEqual(5, [result count]);
  XCTAssert([@"set  maxvar  500" isEqualToString:[result objectAtIndex:0]]);
  XCTAssert([@"set maxvar 1000" isEqualToString:[result objectAtIndex:1]]);
  XCTAssert([@"set maxvar 10000" isEqualToString:[result objectAtIndex:2]]);
  XCTAssert([@"Line 1" isEqualToString:[result objectAtIndex:3]]);
  XCTAssert([@"Line 3\r\nsetmaxvar 100" isEqualToString:[result objectAtIndex:4]]);  // It's not a valid "set maxvar", so it should be included with
}

-(void)testIsCapturableBlock_NullEmpty
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertFalse([parser IsCapturableBlock:nil]);
  XCTAssertFalse([parser IsCapturableBlock:@""]);
  XCTAssertFalse([parser IsCapturableBlock:@"  \r\n   "]);
}

-(void)testIsCapturableBlock_NoSetMaxvar
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertTrue([parser IsCapturableBlock:@"test 1"]);
  XCTAssertTrue([parser IsCapturableBlock:@"test 1\r\ntest2"]);
  XCTAssertTrue([parser IsCapturableBlock:@"setmaxvar 1000"]);
  XCTAssertTrue([parser IsCapturableBlock:@"set maxvar abcd"]);
  XCTAssertTrue([parser IsCapturableBlock:@"set maxvar"]);
}

-(void)testIsCapturableBlock_SetMaxvar
{
  STStataParser* parser = [[STStataParser alloc] init];
  XCTAssertFalse([parser IsCapturableBlock:@"test 1\r\nset maxvar 100\r\n"]);
  XCTAssertFalse([parser IsCapturableBlock:@"set maxvar 5000000"]);
  XCTAssertFalse([parser IsCapturableBlock:@"set maxvar 1000\r\nset maxvar 1000\r\ntest 1\r\n test2"]);
}

@end
