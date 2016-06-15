//
//  STBaseParserTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STBaseParser.h"

@interface STBaseParserTests : XCTestCase

@end

@implementation STBaseParserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

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
