//
//  STBaseManager.m
//  StatTag
//
//  Created by Eric Whitley on 8/1/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseManager.h"
#import "STLogManager.h"


@implementation STBaseManager

@synthesize Logger = _Logger;

/// Wrapper around a LogManager instance.  Since logging is not always enabled/available for this object
/// the wrapper only writes if a logger is accessible.
-(void)Log:(NSString*)text
{
  if (_Logger != nil)
  {
    [_Logger WriteMessage:text];
  }
}

/**
 Wrapper around a LogManager instance.  Since logging is not always enabled/available for this object the wrapper only writes if a logger is accessible.
*/
-(void)LogException:(NSException*) exc
{
  if (_Logger != nil)
  {
    [_Logger WriteException:exc];
  }
}

@end
