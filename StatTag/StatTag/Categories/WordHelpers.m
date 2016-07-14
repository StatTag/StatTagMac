//
//  WordHelpers.m
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "WordHelpers.h"
#import "STMSWord2011.h"
#import <StatTag/StatTag.h>
#import "WordFind.h"

#import "ASOC.h"

@implementation WordHelpers

+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range {
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];
  return [[self class] DuplicateRange: range forDoc:doc];
}

+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range forDoc:(STMSWord2011Document*)doc {
  return [doc createRangeStart:[range startOfContent] end:[range endOfContent]];
}

+(BOOL)FindText:(NSString*)text inRange:(STMSWord2011TextRange*)range{
  return false;
}

+(void)TestAppleScript {
  
  NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
//  NSString *resourcePath = [frameworkBundle pathForResource:@"an_image" ofType:@"jpeg"];
//  [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
  [frameworkBundle loadAppleScriptObjectiveCScripts];

//  Class myClass = NSClassFromString(@"ASOC");
//  id<ASOC> myInstance = [[myClass alloc] init];
//  [myInstance thinkdifferent];
//  NSLog(@"Result: %@", [myInstance square:@3]);

  
  ASOC *stuff = [[NSClassFromString(@"ASOC") alloc] init];
  NSNumber *result = [stuff square: @3];
  [stuff thinkdifferent];
  NSLog(@"Result: %@", result);
  
//  NSNumber* found = [stuff findText:@"testing" atRangeStart:@1 andRangeEnd:@3];
  
//  [stuff findText:@"testing" atRangeStart:@1 andRangeEnd:@3];
  
  NSLog(@"doSomething : %@", [stuff doSomethingTo:@"hello" andTo:@"goodbye"]);
  
  
  NSLog(@"findText : %hhd", [[stuff findText:@"asdfx" atRangeStart:@0 andRangeEnd:@100] boolValue]);
  
//  WordFind *find = [[WordFind alloc] init];
//  NSNumber *result = [find square: @3];
//  NSLog(@"Result: %@", result);
  
//  WordFind *find = [[NSClassFromString(@"WordFind") alloc] init];
//  NSLog(@"find : %@", find);
//  NSNumber *result = [find square: @3];
//  NSLog(@"Result: %@", result);
//  
//  
//  Class myClass = NSClassFromString(@"WordFindScript");
//  id<WordFindProtocol> myInstance = [[myClass alloc] init];
//  NSNumber *result2 = [myInstance square: @3];
//  NSLog(@"Result2: %@", result2);
  
  
}

@end
