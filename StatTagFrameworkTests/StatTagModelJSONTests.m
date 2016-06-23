//
//  StatTagModelJSONTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagModelJSONTests : XCTestCase

@end

@implementation StatTagModelJSONTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testCodeFile {
  
  STCodeFile* cf = [[STCodeFile alloc] init];
  cf.StatisticalPackage = @"ABC";
  cf.FilePath = [NSURL fileURLWithPath:@"myfile.txt"];
  cf.LastCached = [NSDate date];

  NSURL* u = [[NSURL alloc] initWithString:@"myFile.txt"];
  NSLog(@"u : %@", [u path]);
  
  STCodeFile* cf2 = [[STCodeFile alloc] init];
  cf2.StatisticalPackage = @"DEF";
  cf2.FilePath = [NSURL fileURLWithPath:@"secondfile.txt"];
  cf2.LastCached = [NSDate date];
  
//  NSLog(@"cf.dict : %@", [cf toDictionary]);
//  
//  NSString* cf_json = [cf Serialize:nil];
//  NSLog(@"cf_json : %@", cf_json);
  
  NSArray<STCodeFile*>* ar1 = [NSArray arrayWithObjects:cf, cf2, nil];
  NSString* json = [STCodeFile SerializeList:ar1 error:nil];
  
  NSArray* ar = [STJSONUtility DeserializeList:json forClass:[cf class] error:nil];
  NSLog(@"ar : %@", ar);
  
  NSLog(@"cf.StatisticalPackage : %@", [ar[0] StatisticalPackage]);
  

  NSArray<STCodeFile*>* ar2 = [STCodeFile DeserializeList:json error:nil];
  XCTAssert([[ar[0] StatisticalPackage] isEqualToString:@"ABC"]);
  XCTAssert([[[ar[0] FilePath] path] isEqualToString:@"myfile.txt"]);
  XCTAssert([ar[0] LastCached] != nil);
  
  NSLog(@"ar2 : %@", ar2);

  //+(NSArray<NSObject<STJSONAble>*>*)DeserializeList:(NSString*)List forClass:(id)c error:(NSError**)outError
  
}


@end
