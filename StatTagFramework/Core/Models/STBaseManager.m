//
//  STBaseManager.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseManager.h"

@implementation STBaseManager


@synthesize Logger = _Logger;

-(instancetype)init {
  self = [super init];
  if(self){
    self.Logger = [STLogManager sharedInstance];
  }
  return self;
}

/** 
 Wrapper around a LogManager instance.  Since logging is not always enabled/available for this object
 the wrapper only writes if a logger is accessible.
 */
-(void)Log:(id)logMessage{
  if ([self Logger] != nil)
  {
    [[self Logger] WriteLog:logMessage logLevel:STLogVerbose];
  }
}
-(void)Log:(id)logMessage logLevel:(STLogLevel)logLevel{
  if ([self Logger] != nil)
  {
    [[self Logger] WriteLog:logMessage logLevel:logLevel];
  }
}


/**
  Wrapper around a LogManager instance.  Since logging is not always enabled/available for this object
  the wrapper only writes if a logger is accessible.
 */
-(void)LogException:(id)logMessage{
  if ([self Logger] != nil)
  {
    [[self Logger] WriteLog:logMessage logLevel:STLogError];
    //[[self Logger] WriteException:exc];
  }
}


@end
