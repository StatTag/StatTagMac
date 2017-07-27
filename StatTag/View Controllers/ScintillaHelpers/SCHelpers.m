//
//  SCHelpers.m
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

// partial port of https://github.com/jacobslusser/ScintillaNET/blob/master/src/ScintillaNET/Helpers.cs

#import "SCHelpers.h"

@implementation SCHelpers

//FIXME: fix types - but not now
//for now, leave these types as they are - there's an issue where fixing this to return types breaks selection - it needs to be fixed, but you need to test it. Last time I "fixed" the types it broke all user click event handling.
+(int)Clamp:(NSInteger)value min:(int)min max:(int) max
{
  if (value < min)
    return min;
  
  if (value > max)// && max > min)//eww changed to add && max > min
    return max;
  
  return value;
}


+(int)ClampMin:(int)value min:(int) min
{
  if (value < min)
    return min;
  
  return value;
}



@end
