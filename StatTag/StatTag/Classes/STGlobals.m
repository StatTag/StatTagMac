//
//  STGlobals.m
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STGlobals.h"
#import "STThisAddIn.h"

@implementation STGlobals

//@synthesize ThisAddIn = _ThisAddIn;

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
