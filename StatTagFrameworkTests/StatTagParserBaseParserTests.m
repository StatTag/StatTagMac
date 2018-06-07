//
//  STBaseParserTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"
#import <OCMock/OCMock.h>



//MARK: test stub class

@interface StubParser : STBaseParser

@end

@implementation StubParser
-(NSString*)CommentCharacter
{
		return @"*";
}

-(NSTextCheckingResult*)DetectStartTag:(NSString*)line
{
  return [self DetectTag:[self StartTagRegEx] line:line];
}

-(NSTextCheckingResult*)DetectEndTag:(NSString*)line
{
  return [self DetectTag:[self EndTagRegEx] line:line];
}

-(BOOL)IsImageExport:(NSString*)command
{
  [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
  return false;
}

-(BOOL)IsValueDisplay:(NSString*)command
{
  [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
  return false;
}

-(NSString*)GetImageSaveLocation:(NSString*)command
{
  [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
  return nil;
}

-(NSString*) GetValueName:(NSString*)command
{
  [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
  return nil;
}

-(BOOL)IsTableResult:(NSString*)command
{
  [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
  return false;
}

-(NSString*) GetTableName:(NSString*)command
{
  [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
  return nil;
}

-(NSArray<NSString*>*) PreProcessContent:(NSArray<NSString*>*)originalContent
{
  return originalContent;
}
@end


//MARK: test methods

@interface StatTagParserBaseParserTests : XCTestCase

@end

@implementation StatTagParserBaseParserTests


- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}


-(void)testParse_Null_Empty{
  StubParser* parser = [[StubParser alloc] init];
  NSArray<STTag*>* result = [parser Parse:nil];

  XCTAssertNotNil(result);
  XCTAssertEqual(0, [result count]);

  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] init]);

  result = [parser Parse:mock];
  XCTAssertNotNil(result);
  XCTAssertEqual(0, [result count]);
}


-(void)testParse_Simple{
  
  StubParser* parser = [[StubParser alloc] init];
  NSArray<NSString*>* lines = [[NSArray<NSString*> alloc]
              initWithObjects:
                @"**>>>ST:Test",
                @"declare value",
                @"**<<<AM:Test",
                nil];

  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);

  NSArray<STTag*>* result = [parser Parse:mock];

  XCTAssertEqual(1, [result count]);
  XCTAssertEqual(0, [[result[0] LineStart] integerValue]);
  XCTAssertEqual(2, [[result[0] LineEnd] integerValue]);

}

-(void)testParse_StartNoEnd{
 
  StubParser* parser = [[StubParser alloc] init];
  NSArray<NSString*>* lines = [[NSArray<NSString*> alloc]
                               initWithObjects:
                               @"**>>>ST:Test",
                               @"declare value",
                               nil];
  
  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  
  NSArray<STTag*>* result = [parser Parse:mock];
  XCTAssertEqual(0, [result count]);
}

-(void)testParse_TwoStartsOneEnd{
  
  StubParser* parser = [[StubParser alloc] init];
  NSArray<NSString*>* lines = [[NSArray<NSString*> alloc]
                               initWithObjects:
                               @"**>>>ST:Test",
                               @"declare value",
                               @"**>>>ST:Test",
                               @"declare value",
                               @"**<<<AM:Test",
                               nil];
  
  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  
  NSArray<STTag*>* result = [parser Parse:mock];
  XCTAssertEqual(1, [result count]);
  XCTAssertEqual(2, [[result[0] LineStart] integerValue]);
  XCTAssertEqual(4, [[result[0] LineEnd] integerValue]);
}

-(void)testParse_OnDemandFilter{
  
  StubParser* parser = [[StubParser alloc] init];
  NSArray<NSString*>* lines = [[NSArray<NSString*> alloc]
                               initWithObjects:
                               @"declare value",
                               @"**>>>ST:Value(Frequency=\"On Demand\")",
                               @"declare value",
                               @"**<<<",
                               @"**>>>ST:Value",
                               @"declare value2",
                               @"**<<<",
                               nil];
  
  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  
  NSArray<STTag*>* result = [parser Parse:mock filterMode:[STConstantsParserFilterMode ExcludeOnDemand]];
  XCTAssertEqual(1, [result count]);
  XCTAssert([[STConstantsRunFrequency Always] isEqualToString:[result[0] RunFrequency]]);

  result = [parser Parse:mock];
  XCTAssertEqual(2, [result count]);
  XCTAssert([[STConstantsRunFrequency OnDemand] isEqualToString:[result[0] RunFrequency]]);
  XCTAssert([[STConstantsRunFrequency Always] isEqualToString:[result[1] RunFrequency]]);
}

-(void)testParse_TagList{
 
  StubParser* parser = [[StubParser alloc] init];
  NSArray<NSString*>* lines = [[NSArray<NSString*> alloc]
                               initWithObjects:
                               @"declare value",
                               @"**>>>ST:Value(Label=\"Test1\", Frequency=\"On Demand\")",
                               @"declare value",
                               @"**<<<",
                               @"**>>>ST:Value(Label=\"Test2\")",
                               @"declare value2",
                               @"**<<<",
                               nil];
  
  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  OCMStub([mock FilePath]).andReturn(@"Test.do");
  id x;
  OCMStub([mock isEqual:x]).andReturn(true);
  

  NSArray<STTag*>* result = [parser Parse:mock filterMode:[STConstantsParserFilterMode TagList]];
  XCTAssertEqual(2, [result count]);

  NSArray<STTag*>* taglist = [NSArray arrayWithObjects:
                              [STTag tagWithName:@"Test2" andCodeFile:mock andType:[STConstantsTagType Value]]
                               , nil];
  
  result = [parser Parse:mock filterMode:[STConstantsParserFilterMode TagList] tagsToRun:taglist];
  XCTAssertEqual(1, [result count]);
  XCTAssert([@"Test2" isEqualToString:[result[0] Name]]);
}

-(void)testDetectStartTag_Null_Empty{
  
  StubParser* parser = [[StubParser alloc] init];

  //original c# methods
  //Assert.IsFalse(parser.DetectStartTag(null).Success);
  //Assert.IsFalse(parser.DetectStartTag(string.Empty).Success);
  // it appears that it's saying "please test the regex result" (success)
  // which, in our case, would be "did we get a non-nil NSTextCheckingResult?
  XCTAssertNil([parser DetectStartTag:nil]);
  XCTAssertNil([parser DetectStartTag:@""]);
}

-(void)testDetectStartTag_Simple{
  StubParser* parser = [[StubParser alloc] init];
  NSTextCheckingResult* match = [parser DetectStartTag:@"**>>>ST:Test"];
  XCTAssertNotNil(match);
  //NSLog(@"match range : %@", NSStringFromRange([match range]));
  //NSLog(@"match substring : %@", [@"**>>>ST:Test" substringWithRange:[match range]]);
}

-(void)testGetExecutionSteps {
  
  StubParser* parser = [[StubParser alloc] init];
  NSArray<STExecutionStep*>* result;
  NSArray<NSString*>* lines = [[NSArray<NSString*> alloc]
                               initWithObjects:
                               @"declare value1",
                               @"**>>>ST:Value",
                               @"declare value2",
                               @"**<<<",
                               @"declare value3",
                               nil];
  
  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  result = [parser GetExecutionSteps:mock filterMode:[STConstantsParserFilterMode ExcludeOnDemand]];
  XCTAssertEqual(3, [result count]);
  XCTAssertEqual([STConstantsExecutionStepType CodeBlock], [result[0] Type] );
  XCTAssertNil([result[0] Tag]);
  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[1] Type] );
  XCTAssertNotNil([result[1] Tag]);
  XCTAssertEqual([STConstantsExecutionStepType CodeBlock], [result[2] Type] );
  XCTAssertNil([result[2] Tag]);
  
  //***** -> redeclare mock so we nil it out - otherwise we have issues connecting methods to the same object in subsequent tests
  mock = OCMClassMock([STCodeFile class]);
  // Tag at the beginning
  lines = [[NSArray<NSString*> alloc]
           initWithObjects:
           @"**>>>ST:Value",
           @"declare value2",
           @"**<<<",
           @"declare value3",
           nil];
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  result = [parser GetExecutionSteps:mock filterMode:[STConstantsParserFilterMode ExcludeOnDemand]];

  XCTAssertEqual(2, [result count]);
  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[0] Type] );
  XCTAssertNotNil([result[0] Tag]);

  XCTAssertEqual([STConstantsExecutionStepType CodeBlock], [result[1] Type] );
  XCTAssertNil([result[1] Tag]);

  //***** -> redeclare mock so we nil it out - otherwise we have issues connecting methods to the same object in subsequent tests
  mock = OCMClassMock([STCodeFile class]);
  // Tag at the end
  lines = [[NSArray<NSString*> alloc]
           initWithObjects:
           @"declare value2",
           @"**>>>ST:Value",
           @"declare value3",
           @"**<<<",
           nil];
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  result = [parser GetExecutionSteps:mock filterMode:[STConstantsParserFilterMode ExcludeOnDemand]];

  XCTAssertEqual(2, [result count]);
  XCTAssertEqual([STConstantsExecutionStepType CodeBlock], [result[0] Type] );
  XCTAssertNil([result[0] Tag]);
  
  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[1] Type] );
  XCTAssertNotNil([result[1] Tag]);
  
  //***** -> redeclare mock so we nil it out - otherwise we have issues connecting methods to the same object in subsequent tests
  mock = OCMClassMock([STCodeFile class]);
  // Back to back tags
  lines = [[NSArray<NSString*> alloc]
           initWithObjects:
           @"**>>>ST:Value",
           @"declare value1",
           @"**<<<",
           @"**>>>ST:Value",
           @"declare value2",
           @"**<<<",
           @"**>>>ST:Value",
           @"declare value3",
           @"**<<<",
           nil];
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  result = [parser GetExecutionSteps:mock filterMode:[STConstantsParserFilterMode ExcludeOnDemand]];

  XCTAssertEqual(3, [result count]);
  
  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[0] Type] );
  XCTAssertNotNil([result[0] Tag]);
  
  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[1] Type] );
  XCTAssertNotNil([result[1] Tag]);
  
  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[2] Type] );
  XCTAssertNotNil([result[2] Tag]);
}

-(void)testGetExecutionSteps_OnDemandFilter{
  
  StubParser* parser = [[StubParser alloc] init];
  NSArray<STExecutionStep*>* result;
  NSArray<NSString*>* lines = [[NSArray<NSString*> alloc]
                               initWithObjects:
                               @"declare value",
                               @"**>>>ST:Value(Frequency=\"On Demand\")",
                               @"declare value",
                               @"**<<<",
                               @"**>>>ST:Value",
                               @"declare value2",
                               @"**<<<",
                               nil];
  
  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  result = [parser GetExecutionSteps:mock filterMode:[STConstantsParserFilterMode ExcludeOnDemand]];
  
  //need to go and look at the "excludeondemand" portion o fthe getexecutionsteps method
  XCTAssertEqual(2, [result count]);
  
  XCTAssertEqual([STConstantsExecutionStepType CodeBlock], [result[0] Type] );
  XCTAssertNil([result[0] Tag]);

  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[1] Type] );
  XCTAssertNotNil([result[1] Tag]);
  
  result = [parser GetExecutionSteps:mock];

  XCTAssertEqual(3, [result count]);

  XCTAssertEqual([STConstantsExecutionStepType CodeBlock], [result[0] Type] );
  XCTAssertNil([result[0] Tag]);

  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[1] Type] );
  XCTAssertNotNil([result[1] Tag]);

  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[2] Type] );
  XCTAssertNotNil([result[2] Tag]);

}

-(void)testGetExecutionSteps_TagList{
 
  
  StubParser* parser = [[StubParser alloc] init];
  NSArray<STExecutionStep*>* result;
  NSArray<NSString*>* lines = [[NSArray<NSString*> alloc]
                               initWithObjects:
                               @"declare value",
                               @"**>>>ST:Value(Label=\"Test1\", Frequency=\"On Demand\")",
                               @"declare value",
                               @"**<<<",
                               @"**>>>ST:Value(Label=\"Test2\")",
                               @"declare value2",
                               @"**<<<",
                               nil];
  
  id mock = OCMClassMock([STCodeFile class]);
  OCMStub([mock LoadFileContent]).andReturn([[NSArray<NSString*> alloc] initWithArray:lines]);
  id x;
  OCMStub([mock isEqual:x]).andReturn(true);
  result = [parser GetExecutionSteps:mock filterMode:[STConstantsParserFilterMode TagList]];

  XCTAssertEqual(3, [result count]);

  NSArray<STTag*>* taglist = [NSArray arrayWithObjects:
                              [STTag tagWithName:@"Test1" andCodeFile:mock andType:[STConstantsTagType Value]]
                              , nil];
  result = [parser GetExecutionSteps:mock filterMode:[STConstantsParserFilterMode TagList] tagsToRun:taglist];

  XCTAssertEqual(2, [result count]);

  XCTAssertEqual([STConstantsExecutionStepType CodeBlock], [result[0] Type] );
  XCTAssertNil([result[0] Tag]);

  XCTAssertEqual([STConstantsExecutionStepType Tag], [result[1] Type] );
  XCTAssertNotNil([result[1] Tag]);

  XCTAssert([ @"Test1" isEqualToString:[[result[1] Tag] Name]]);
  
}

//MARK: scratch pad
- (void)testNSTyupes {
//  NSInteger x;
//  NSLog(@"x: %ld", (long)x);
//  x = 6;
//  NSLog(@"x: %ld", (long)x);
//  x = 7;
//  NSLog(@"x: %ld", (long)x);
//  
//  
//  NSNumber *counter = @0;
//  for (int i=0; i<10; i++) {
//    counter = @([counter intValue] + 1);
//    NSLog(@"%@", counter);
//  }
  

  
  
  NSNumber *LineStart = @(1);
  NSNumber *startIndex = @(2);
  NSNumber *LineEnd = @(3);
  int index = 4;
  LineStart = startIndex;
  LineEnd = @(index);
  startIndex = nil;
  
  NSLog(@"LineStart: %@", LineStart);
  
}

- (void)testSampleRegexMatch {

  //http://stackoverflow.com/questions/9276246/how-to-write-regular-expressions-in-objective-c-nsregularexpression
  //https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSRegularExpression_Class/
  //
  
  NSString *searchedString = @"domain-name.tld.tld2";
  NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
  NSString *pattern = @"(?:www\\.)?((?!-)[a-zA-Z0-9-]{2,63}(?<!-))\\.?((?:[a-zA-Z0-9]{2,})?(?:\\.[a-zA-Z0-9]{2,})?)";
  NSError  *error = nil;
  
  NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
  NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
  NSLog(@"matches : %@", matches);
  for (NSTextCheckingResult* match in matches) {
    NSLog(@"match: %@", match);
    //match: <NSSimpleRegularExpressionCheckingResult: 0x127840>{0, 20}{<NSRegularExpression: 0x129d40> (?:www\.)?((?!-)[a-zA-Z0-9-]{2,63}(?<!-))\.?((?:[a-zA-Z0-9]{2,})?(?:\.[a-zA-Z0-9]{2,})?) 0x0}
    
    //status? success?
    //NSLog(@"%@", [match su])
    
    NSString* matchText = [searchedString substringWithRange:[match range]];
    NSLog(@"match: %@", matchText);
    //match: domain-name.tld.tld2

    NSRange group1 = [match rangeAtIndex:1];
    NSLog(@"group1: %@", [searchedString substringWithRange:group1]);
    //group1: domain-name

    NSRange group2 = [match rangeAtIndex:2];
    NSLog(@"group2: %@", [searchedString substringWithRange:group2]);
    //group2: tld.tld2
    
  }
}


-(void)testFormatCommandListAsNonCapturingGroup
{
  XCTAssert([@"" isEqualToString:[STBaseParser FormatCommandListAsNonCapturingGroup:@[]]]);
  XCTAssert([@"(?:test)" isEqualToString:[STBaseParser FormatCommandListAsNonCapturingGroup:@[@"test"]]]);
  XCTAssert([@"(?:test\\s+cmd)" isEqualToString:[STBaseParser FormatCommandListAsNonCapturingGroup:@[@"test cmd"]]]);
  
  //for reasons I can't figure out, I can't seem to use the short-hand array creation syntax to just create the array inline for the FormatCommandListAsNonCapturingGroup argument
  NSArray<NSString*>* a = @[@"test1", @"test2"];
  XCTAssert([@"(?:test1|test2)" isEqualToString:[STBaseParser FormatCommandListAsNonCapturingGroup:a]]);
  
//  Assert.AreEqual(string.Empty, BaseParser.FormatCommandListAsNonCapturingGroup(new string[0]));
//  Assert.AreEqual("(?:test)", BaseParser.FormatCommandListAsNonCapturingGroup(new[] { "test" }));
//  Assert.AreEqual("(?:test\\s+cmd)", BaseParser.FormatCommandListAsNonCapturingGroup(new[] { "test cmd" }));
//  Assert.AreEqual("(?:test1|test2)", BaseParser.FormatCommandListAsNonCapturingGroup(new[] { "test1", "test2" }));
}

-(void)testIsRelativePath
{
    StubParser* parser = [[StubParser alloc] init];
    XCTAssertFalse([parser IsRelativePath:@"/Users/test/code"]);
    XCTAssertFalse([parser IsRelativePath:@"  /Users/test/code  "]);
    XCTAssertFalse([parser IsRelativePath:@"smb://Users/test/code"]);
    XCTAssertFalse([parser IsRelativePath:@" smb://Users/test/code "]);

    XCTAssert([parser IsRelativePath:@"~/code"]);
    XCTAssert([parser IsRelativePath:@"code"]);
    XCTAssert([parser IsRelativePath:@" code "]);
    XCTAssert([parser IsRelativePath:@"../test/code"]);
}

-(void)testPreProcessExecutionStepCode_Null
{
  StubParser* parser = [[StubParser alloc] init];
  XCTAssertNil([parser PreProcessExecutionStepCode:nil]);
}

-(void)testPreProcessExecutionStepCode_Tag
{
  StubParser* parser = [[StubParser alloc] init];
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

-(void)testPreProcessExecutionStepCode_NoTag
{
  StubParser* parser = [[StubParser alloc] init];
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

@end










//#import <objc/message.h>

//@interface ProxySTCodeFile : NSObject {
//  NSMutableArray<NSString*>* (^_loadFileContent)(void);
//}
//@property (nonatomic, copy) NSMutableArray<NSString*>* (^loadFileContent)(void);
//-(NSMutableArray<NSString *>*) LoadFileContent;
//@end
//
//@implementation ProxySTCodeFile
//@synthesize loadFileContent = _loadFileContent;
//-(NSMutableArray<NSString *>*) LoadFileContent {
//  if(_loadFileContent != nil) {
//    [[self loadFileContent] invoke];
//  }
//  return nil;
//}
//@end

/*
 
 STCodeFile* mock = [[STCodeFile alloc] init];
 
 ProxySTCodeFile* proxy = [[ProxySTCodeFile alloc] init];
 NSMutableArray<NSString*>*(^loadFileContent)(void) = ^(void) {
 NSMutableArray<NSString*>* ar = [[NSMutableArray<NSString*> alloc] init];
 return ar;
 };
 proxy.loadFileContent = loadFileContent;
 
 SEL selector = @selector(LoadFileContent);
 IMP newImp = [ProxySTCodeFile instanceMethodForSelector:@selector(LoadFileContent)];
 Method method = class_getClassMethod([STCodeFile class], selector);
 const char * encoding = method_getTypeEncoding(method);
 class_replaceMethod([STCodeFile class], selector, newImp, encoding);
 
 result = [parser Parse:mock];//parser.Parse(mock.Object);
 
 
 */
