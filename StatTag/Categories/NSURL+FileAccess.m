//
//  NSURL+FileAccess.m
//  StatTag
//
//  Created by Eric Whitley on 5/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "NSURL+FileAccess.h"
#include <unistd.h>

@implementation NSURL (FileAccess)

//https://stackoverflow.com/questions/11493882/how-to-detect-if-a-nsurl-can-be-accessed-on-a-sandboxed-app


-(bool)canReadFileAtPath
{
  if (access([[self path] UTF8String], R_OK) == 0)
  {
    return YES;
  }
  return NO;
}

-(bool)canWriteToFileAtPath
{
  if (access([[self path] UTF8String], W_OK) == 0)
  {
    return YES;
  }
  return NO;
}

-(bool)fileExistsAtPath
{
  if (access([[self path] UTF8String], F_OK) == 0)
  {
    return YES;
  }
  return NO;
}


@end
