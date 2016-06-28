//
//  STBaseParserTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"
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
  XCTAssertEqual(@0, [result[0] LineStart]);
  XCTAssertEqual(@2, [result[0] LineEnd]);

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
  XCTAssertEqual(@2, [result[0] LineStart]);
  XCTAssertEqual(@4, [result[0] LineEnd]);
}

-(void)testParse_OnDemandFilter{
  
}

-(void)testParse_TagList{
  
}

-(void)testDetectStartTag_Null_Empty{
  
}

-(void)testDetectStartTag_Simple{
  
}

-(void)testGetExecutionSteps_OnDemandFilter{
  
}

-(void)testGetExecutionSteps_TagList{
  
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
