//
//  StatTagWord2011AutomationTests.m
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagWord2011AutomationTests : XCTestCase

@end

@implementation StatTagWord2011AutomationTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testExample {

  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  NSLog(@"app : %@", app);

  NSLog(@"app -> isRunning : %hhd", [app isRunning]);
  
  STMSWord2011Document* doc = [app activeDocument];
  NSLog(@"doc : %@", doc);
  
  NSLog(@"doc -> fullname : %@", [doc fullName]);
  NSLog(@"doc -> variables (count) : %lu", (unsigned long)[[doc variables] count]);
  NSLog(@"doc -> variables : %@", [doc variables]);

  STDocumentManager* manager = [[STDocumentManager alloc] init];
  
  [manager LoadCodeFileListFromDocument:doc];
  NSLog(@"GetCodeFileList : %@", [manager GetCodeFileList]);
  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];
  NSLog(@"GetCodeFileList : %@", [manager GetCodeFileList]);
  
  NSLog(@"GetTags : %@", [manager GetTags]);
  
  STStatsManager* stats = [[STStatsManager alloc] init:manager];
  for(STCodeFile* cf in [manager GetCodeFileList]) {
    NSLog(@"codeFile content: %@", [cf Content]);
    NSLog(@"original codeFile tags");
    NSLog(@"======================");
    for(STTag* tag in [cf Tags]) {
      NSLog(@"original codeFile tag -> name: %@, type: %@", [tag Name], [tag Type]);
      NSLog(@"original codeFile tag -> formatted result: %@", [tag FormattedResult]);
    }
    
    //STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf];
    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
    
    //[STConstantsParserFilterMode ExcludeOnDemand]
    
    NSLog(@"new codeFile tags");
    NSLog(@"======================");
    for(STTag* tag in [cf Tags]) {
      NSLog(@"new codeFile tag -> name: %@, type: %@", [tag Name], [tag Type]);
      NSLog(@"new codeFile tag -> formatted result: %@", [tag FormattedResult]);
    }

    
    NSLog(@"result length : %lu", (unsigned long)[[result UpdatedTags] count]);
    for(STTag* tag in [result UpdatedTags]) {
      NSLog(@"tag -> name: %@, type: %@", [tag Name], [tag Type]);
      NSLog(@"tag -> formatted result: %@", [tag FormattedResult]);
      //FormattedResult
    }
    
  }
  
}


@end
