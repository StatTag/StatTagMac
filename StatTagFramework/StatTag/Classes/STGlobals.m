//
//  STGlobals.m
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STGlobals.h"
#import "STThisAddIn.h"
#import "STMSWord2011.h"

@implementation STGlobals

static STGlobals* sharedInstance = nil;
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
    _ThisAddIn = [[STThisAddIn alloc] init];
  }
  return self;
}

/**
 Dummy document activator for issues seen when deploying to Word as a framework
 we lose key field data like fieldText if we don't ask Word to bring something up
 */
+(void)activateDocument {
  STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* document = [application activeDocument];
}

-(STThisAddIn*)ThisAddIn {
  return _ThisAddIn;
}
-(void)setThisAddIn:(STThisAddIn *)ThisAddIn {
  if(_ThisAddIn == nil) {
    _ThisAddIn = ThisAddIn;
  } else {
    [NSException raise:@"Not Supported" format:@"Not Supported"];
  }
}




@end
