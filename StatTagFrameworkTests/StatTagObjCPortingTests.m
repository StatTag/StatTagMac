//
//  StatTagObjCPortingTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ObjCPortingScratchPad.h"
#import "StatTagFramework.h"

@interface StatTagObjCPortingTests : XCTestCase

@end

@implementation StatTagObjCPortingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
//  ObjCPortingScratchPad *p = [[ObjCPortingScratchPad alloc] init];
//  NSLog(@"%@", [p myVar]);
  
  NSLog(@"%@", [ObjCPortingScratchPad myVar]);
  [ObjCPortingScratchPad setMyVar:@"2"];
  NSLog(@"%@", [ObjCPortingScratchPad myVar]);

//  NSLog(@"%@", [ObjCPortingScratchPadSubclass myVar]);
}

-(void)testNSScanner {
  
//  double outVal;
//  NSScanner* scanner = [NSScanner scannerWithString:@"a1.0.1"];
//  [scanner scanDouble:&outVal];
//  NSLog(@"outVal = %f", outVal);
  BOOL AllowInvalidTypes = true;
  NSString *value = @"0a";
  double numericValue = [value doubleValue];
  NSString *result;
  if(numericValue == 0 && ![value  isEqual: @"0"]) {
    if(AllowInvalidTypes){result = value;}
    else {
      result = [NSString stringWithFormat:@"FAILED: %f", numericValue];
    }
  } else {
    result = [NSString stringWithFormat:@"VALID: %f", numericValue];
  }
  NSLog(@"result: %@", result);
  
}

-(void)testNumberFormattingDecimal {

  NSString *value = @"10000000.23678";
  int DecimalPlaces = 2;
  BOOL UseThousands = true;
  
  double numericValue = [value doubleValue];
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  if(UseThousands){
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  }
  [formatter setMaximumFractionDigits:DecimalPlaces];
  [formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
  NSLog(@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:numericValue]]);

}

-(void)testNumberFormattingPercentag {
  
  NSString *value = @"23.3443534";
  int DecimalPlaces = 2;
  
  double numericValue = [value doubleValue];
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterPercentStyle];
  [formatter setMultiplier:@1.0];//our numbers are already in percentages
  [formatter setMinimumFractionDigits:DecimalPlaces];
  [formatter setMaximumFractionDigits:DecimalPlaces];
  [formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
  NSLog(@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:numericValue]]);
  
}

-(void)testDateExtraction {
  
  NSString *value = @"The date is August 23, 2015 at 4:30pm US Eastern or at least I think it is...";
  
  NSError *error = NULL;
  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeDate error:&error];
  
  NSArray *matches = [detector matchesInString:value options:0 range:NSMakeRange(0, [value length])];
  
  //this is a huge guess re: locale...
  NSLocale* currentLoc = [NSLocale currentLocale];
  for (NSTextCheckingResult *match in matches) {
    if ([match resultType] == NSTextCheckingTypeDate) {
      NSLog(@"Date : %@", [[match date] descriptionWithLocale:currentLoc]);
      NSLog(@"Date 2 : %@", [[match date] description]);
    }
  }

  
}

-(void)testObjectCopy {
  STTag *tag1 = [[STTag alloc] init];
  tag1.RunFrequency = @"run_frequency";
  
  STTag *tag2 = [[STTag alloc] initWithTag:tag1];
  #pragma unused(tag2)
}


-(void)testObjectCast {
  
  id configuration = @"my string";
  NSDictionary<NSString*, STCodeFileAction*>* actions = (NSDictionary<NSString*, STCodeFileAction*> *)configuration;

  if(actions == nil) {
    NSLog(@"actions is NIL");
  } else {
    NSLog(@"actions is valid (which is bad...)");
  }
  
  if([actions isKindOfClass:[NSDictionary class]]) {
    NSLog(@"actions is a dictionary - which is worse...");
  }
  NSLog(@"actions is a... : %@", NSStringFromClass([actions class]));
  
}


-(void)testUpdatePair {
  
  NSString* old = @"old";
  NSString* new = @"new";
  
  STUpdatePair<NSString*>* pair = [[STUpdatePair alloc] init];
  pair.Old = old;
  pair.New = new;

  NSLog(@"old = %@", [pair Old]);
  NSLog(@"new = %@", [pair New]);

  pair = [[STUpdatePair alloc] init:@"old 2" newItem:@"new 2"];
  NSLog(@"old = %@", [pair Old]);
  NSLog(@"new = %@", [pair New]);
  
}

@end
