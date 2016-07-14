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
#import "ASOC.h"
#import "WordASOC.h"

@implementation WordHelpers

//because we use the WordHelpers to load applescripts from the bundle, we don't want to keep loading them every time. So we're going to use a sharedInstance and just fire off the "load my applescripts" call in the init
static WordHelpers* sharedInstance = nil;
+ (instancetype)sharedInstance
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  if (self = [super init]) {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    [frameworkBundle loadAppleScriptObjectiveCScripts];
    NSLog(@"just set our bundle shared instance");
  }
  return self;
}

+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range {
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];
  return [[self class] DuplicateRange: range forDoc:doc];
}

+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range forDoc:(STMSWord2011Document*)doc {
  return [doc createRangeStart:[range startOfContent] end:[range endOfContent]];
}

+(BOOL)FindText:(NSString*)text inRange:(STMSWord2011TextRange*)range{
  //message our sharedInstance so we load applescripts (once)
  [[self class] sharedInstance];
  WordASOC *stuff = [[NSClassFromString(@"WordASOC") alloc] init];
  if(text != nil) {
    return [[stuff findText:text atRangeStart:[NSNumber numberWithInt:[range startOfContent]] andRangeEnd:[NSNumber numberWithInt:[range endOfContent]]] boolValue];
  }
  return false;
}


@end
