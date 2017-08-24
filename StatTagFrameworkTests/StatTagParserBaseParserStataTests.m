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
  XCTAssert([@"r ( coefs )" isEqualToString: [parser GetTableName: @"mat list r ( coefs ) "]]);
  XCTAssert([@"B" isEqualToString: [parser GetTableName: @"matrix list B\r\n\r\n*Some comments following"]]);
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
}

@end
