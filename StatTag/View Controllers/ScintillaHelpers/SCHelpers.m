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

+(long)Clamp:(long)value min:(long)min max:(long) max
{
  if (value < min)
    return min;
  
  if (value > max)
    return max;
  
  return value;
}


+(long)ClampMin:(long)value min:(long) min
{
  if (value < min)
    return min;
  
  return value;
}



@end
