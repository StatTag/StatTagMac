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

+(void)setRange:(STMSWord2011TextRange**)range Start:(int)start end:(int)end {
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];
  //return [doc createRangeStart:start end:end];
  *range = [doc createRangeStart:start end:end];
}

//+(void)replaceRange:(STMSWord2011TextRange**)range Start:(int)start end:(int)end {
//  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
//  STMSWord2011Document* doc = [app activeDocument];
//  *range = [doc createRangeStart:start end:end];
//}


+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range forDoc:(STMSWord2011Document*)doc {
  return [doc createRangeStart:[range startOfContent] end:[range endOfContent]];
}

+(BOOL)FindText:(NSString*)text inRange:(STMSWord2011TextRange*)range{
  BOOL found = false;
  
  /*
    OK, so why is this commented out?
   
   "find" in Word is just totally broken. Even more than noted earlier.
   
   If you have a string ">" as defined by a range
   And you are searching for string ">"
   ...you will get back FALSE
   
   So for now we're just using Obj-C string literal matching (case insensitive)
   
   */
//  //message our sharedInstance so we load applescripts (once)
//  [[self class] sharedInstance];
//  WordASOC *stuff = [[NSClassFromString(@"WordASOC") alloc] init];
//  if(text != nil) {
//    found = [[stuff findText:text atRangeStart:[NSNumber numberWithInt:[range startOfContent]] andRangeEnd:[NSNumber numberWithInt:[range endOfContent]]] boolValue];
//    return found;
//  }
//  return found;
  
  if([[range content] rangeOfString:text options: NSCaseInsensitiveSearch].location != NSNotFound ) {
    found = true;
  }
  
  return found;
  
}


+(void)createDocumentVariableWithName:(NSString*)variableName andValue:(NSString*)variableValue {
  //message our sharedInstance so we load applescripts (once)
  [[self class] sharedInstance];
  WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
  if(variableName != nil) {
    [asoc createDocumentVariableWithName:variableName andValue:variableValue];
  }
}


+(void)updateContent:(NSString*)text inRange:(STMSWord2011TextRange**)range {
  
  //  //- (STMSWord2011TextRange *) moveRangeBy:(STMSWord2011E129)by count:(NSInteger)count;  // Collapses the specified range to its start or end position and then moves the collapsed object by the specified number of units. This method returns the new range object or missing value if an error occurred.
  //  // -> STMSWord2011E129ACharacterItem -> characters
  if(text == nil) {
    text = @"";
  }
  
//  NSLog(@"WordHelpers - updateContent -> at range (%ld,%ld) for text : '%@'", (long)[*range startOfContent], (long)[*range endOfContent], text);
  
  [*range setContent: text];
  
  [WordHelpers setRange:range Start:[*range startOfContent] end:([*range startOfContent] + [text length])];
  
  //*range = [WordHelpers setRange:range Start:[*range startOfContent] end:([*range startOfContent] + [text length])];
  
  
//  NSLog(@"WordHelpers - (DONE) updateContent -> at range (%ld,%ld) for text : '%@'", (long)[*range startOfContent], (long)[*range endOfContent], text);

}


@end
