//
//  StatTageGeneratorBaseGeneratorTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/30/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"


@interface StubGenerator : STBaseGenerator
-(NSString*)CommentCharacter;
@end

@implementation StubGenerator
-(NSString*)CommentCharacter {
  return @"*";
}
@end

@interface StatTagGeneratorBaseGeneratorTests : XCTestCase

@end

@implementation StatTagGeneratorBaseGeneratorTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCreateOpenTagBase {
  StubGenerator* generator = [[StubGenerator alloc] init];
  XCTAssert([@"**>>>ST:" isEqualToString:[generator CreateOpenTag:nil]]);
}

- (void)testCreateClosingTag {
  StubGenerator* generator = [[StubGenerator alloc] init];
  XCTAssert([@"**<<<" isEqualToString:[generator CreateClosingTag]]);
}

- (void)testCreateOpenTag_Value {
  StubGenerator* generator = [[StubGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  tag.ValueFormat = [[STValueFormat alloc] init];
//  NSLog(@"[generator CreateOpenTag:tag] : %@", [generator CreateOpenTag:tag]);
  XCTAssert([@"**>>>ST:Value(Type=\"Default\")" isEqualToString:[generator CreateOpenTag:tag]]);
}

- (void)testCreateOpenTag_Figure {
  StubGenerator* generator = [[StubGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Figure];
  tag.FigureFormat = [[STFigureFormat alloc] init];
//  NSLog(@"[generator CreateOpenTag:tag] : %@", [generator CreateOpenTag:tag]);
  XCTAssert([@"**>>>ST:Figure()" isEqualToString:[generator CreateOpenTag:tag]]);
}

- (void)testCreateOpenTag_Table {
  StubGenerator* generator = [[StubGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
//  NSLog(@"[generator CreateOpenTag:tag] : %@", [generator CreateOpenTag:tag]);
//  NSLog(@"expected : %@", @"**>>>ST:Table(Type=\"Default\")");
  XCTAssert([@"**>>>ST:Table(Type=\"Default\")" isEqualToString:[generator CreateOpenTag:tag]]);

  tag.TableFormat = [[STTableFormat alloc] init];
//  NSLog(@"[generator CreateOpenTag:tag] : %@", [generator CreateOpenTag:tag]);
//  NSLog(@"expected: **>>>ST:Table(ColumnNames=False, RowNames=False, Type=\"Default\")");
  XCTAssert([@"**>>>ST:Table(ColumnNames=False, RowNames=False, Type=\"Default\")" isEqualToString:[generator CreateOpenTag:tag]]);
}

- (void)testCombineValueAndTableParameters {
  
  StubGenerator* generator = [[StubGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Table];
  tag.ValueFormat = [[STValueFormat alloc] init];
  tag.TableFormat = [[STTableFormat alloc] init];
//  NSLog(@"[generator CombineValueAndTableParameters] : %@", [generator CombineValueAndTableParameters:tag]);
//  NSLog(@"expected: ColumnNames=False, RowNames=False, Type=\"Default\"");
  XCTAssert([@"ColumnNames=False, RowNames=False, Type=\"Default\"" isEqualToString:[generator CombineValueAndTableParameters:tag]]);

  tag.ValueFormat.FormatType = [STConstantsValueFormatType Numeric];
  tag.ValueFormat.DecimalPlaces = 2;
//  NSLog(@"[generator CombineValueAndTableParameters] : %@", [generator CombineValueAndTableParameters:tag]);
//  NSLog(@"expected: ColumnNames=False, RowNames=False, Type=\"Numeric\", Decimals=2, Thousands=False");
  XCTAssert([@"ColumnNames=False, RowNames=False, Type=\"Numeric\", Decimals=2, Thousands=False" isEqualToString:[generator CombineValueAndTableParameters:tag]]);
}


@end
