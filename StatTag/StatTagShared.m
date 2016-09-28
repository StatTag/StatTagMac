//
//  StatTagShared.m
//  StatTag
//
//  Created by Eric Whitley on 9/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "StatTagShared.h"

@implementation StatTagShared

@synthesize docManager = _docManager;
@synthesize doc = _doc;
@synthesize app = _app;
@synthesize mainVC = _mainVC;

@synthesize propertiesManager = _propertiesManager;
@synthesize logManager = _logManager;


static StatTagShared *sharedInstance = nil;

+ (StatTagShared*)sharedInstance {
  if (sharedInstance == nil) {
    sharedInstance = [[super allocWithZone:NULL] init];
  }
  
  return sharedInstance;
}

- (id)init
{
  self = [super init];
  if (self) {
  }
  return self;
}

-(void)dealloc
{
}

+ (id)allocWithZone:(NSZone*)zone {
  return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}


+ (NSColor*)colorFromRGBRed:(CGFloat)r  green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a
{
  CGFloat rFloat = ((int)r) % 255;
  CGFloat gFloat = ((int)g) % 255;
  CGFloat bFloat = ((int)b) % 255;
  
  return [NSColor colorWithCalibratedRed:rFloat green:gFloat blue:bFloat alpha:a];
}

@end
