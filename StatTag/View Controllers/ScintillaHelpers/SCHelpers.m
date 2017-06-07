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

+(int)Clamp:(int)value min:(int)min max:(int) max
{
  if (value < min)
    return min;
  
  if (value > max)// && max > min)//eww changed to add && max > min
    return max;
  
  return (int)value;
}


+(int)ClampMin:(int)value min:(int) min
{
  if (value < min)
    return min;
  
  return value;
}



@end
