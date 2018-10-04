//
//  NSSegmentedCellNoDelay.m
//  StatTag
//
//  Created by Eric Whitley on 7/25/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

// Kudos to https://stackoverflow.com/a/3346338/5583125
// there doesn't seem to be a simple way to create a clickable segmented control member without delay

#import "NSSegmentedCellNoDelay.h"

@implementation NSSegmentedCellNoDelay

- (SEL)action
{
  //this allows connected menu to popup instantly (because no action is returned for menu button)
  if ([self tagForSegment:[self selectedSegment]]==0) {
    return nil;
  } else {
    return [super action];
  }
}

@end
