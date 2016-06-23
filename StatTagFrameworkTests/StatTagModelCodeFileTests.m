//
//  StatTagSTCodeFileTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/19/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STCodeFile.h"

@interface StatTagModelCodeFileTests : XCTestCase

@end

@implementation StatTagModelCodeFileTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}


//MARK: c# test methods




//MARK: JSON testing - not in original C#


- (void)testJSONEncoding {
  STCodeFile *f = [[STCodeFile alloc] init];
  f.StatisticalPackage = @"R";
  f.FilePath = [[NSURL alloc] initWithString:@"/Applications/SomePath/somefile.txt"];
  f.LastCached = [NSDate date];
  
  NSLog(@"f: %@", f);
 
  NSError *error;
  NSString *json = [STJSONUtility SerializeObject:f error:&error];
  NSLog(@"JSON: %@", json);
  NSLog(@"error: %@", error);
}

- (void)testJSONListEncoding {
  
  NSMutableArray<STCodeFile*> *files = [[NSMutableArray<STCodeFile*> alloc] init];
  
  for(int i = 0; i < 5; i++) {
    STCodeFile *f = [[STCodeFile alloc] init];
    f.StatisticalPackage = [NSString stringWithFormat:@"R %d", i];
    f.FilePath = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"/Applications/SomePath/somefile___%d.txt", i]];
    [files addObject:f];
  }
  
  NSError *error;
  NSString *json = [STCodeFile SerializeList:files error:&error];
  
  NSLog(@"JSON: %@", json);
  NSLog(@"error: %@", error);
}

- (void)testJSONInit {
  //-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error
  NSString* jsonString = @"{\"StatisticalPackage\" : \"R 0\",\"FilePath\" : \"/Applications/SomePath/somefile___0.txt\",\"LastCached\":\"06/20/2016, 09:18:29 -0500\"}";
  NSError* error;
  STCodeFile* f = [[STCodeFile alloc] initWithJSONString:jsonString error:&error];
  NSLog(@"error: %@", error);
  NSLog(@"f: %@", f);
  NSLog(@"f (StatisticalPackage): %@", [f StatisticalPackage]);
  NSLog(@"f (LastCached): %@", [f LastCached]);
}

- (void)testJSONArrayInit {
  NSString* jsonString = @"[{\"StatisticalPackage\" : \"R 0\",\"FilePath\" : \"/Applications/SomePath/somefile___0.txt\"},{\"StatisticalPackage\" : \"R 1\",\"FilePath\" : \"/Applications/SomePath/somefile___1.txt\"},{\"StatisticalPackage\" : \"R 2\",\"FilePath\" : \"/Applications/SomePath/somefile___2.txt\"},{\"StatisticalPackage\" : \"R 3\",\"FilePath\" : \"/Applications/SomePath/somefile___3.txt\"},{\"StatisticalPackage\" : \"R 4\",\"FilePath\" : \"/Applications/SomePath/somefile___4.txt\"}]";
  NSError* error;
  NSArray<STCodeFile*>* list = [STCodeFile DeserializeList:jsonString error:&error];
  NSLog(@"error: %@", error);
  NSLog(@"f: %@", list);
}


//MARK: Object copy/dictionary

- (void)testBasicObjectForKey {
  STCodeFile *f = [[STCodeFile alloc] init];
  f.FilePath = [[NSURL alloc] initWithString:@"afile"];
  
  NSMutableDictionary<STCodeFile*, NSNumber*>* d = [[NSMutableDictionary<STCodeFile*, NSNumber*> alloc] init];
  [d setObject:@1 forKey:f];
  NSLog(@"f(FilePath): %@", [[f FilePath] path]);
  NSLog(@"d: %@", d);
  NSLog(@"d(value): %@", [d objectForKey:f]);
}


@end
