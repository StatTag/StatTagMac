//
//  SCMarkerHandle.m
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "SCMarkerHandle.h"

@implementation SCMarkerHandle

@synthesize Value = _Value;


/// A read-only field that represents an uninitialized handle.
//public static readonly MarkerHandle Zero;
//@property (strong, nonatomic) NSInteger Value;
+(NSInteger)Zero {
  return 0;
}


//MARK: equality

/// <summary>
/// Returns the hash code for this instance.
/// </summary>
/// <returns>A 32-bit signed integer hash code.</returns>
- (NSUInteger)hash {
  return _Value;
}

/// <summary>
/// Returns a value indicating whether this instance is equal to a specified object.
/// </summary>
/// <param name="obj">An object to compare with this instance or null.</param>
/// <returns>true if <paramref name="obj" /> is an instance of <see cref="MarkerHandle" /> and equals the value of this instance; otherwise, false.</returns>
- (BOOL)isEqual:(id)object {
  //return (obj is IntPtr) && Value == ((MarkerHandle)obj).Value;
  if (![object isKindOfClass:self.class]) {
    return NO;
  }
  return [object Value] == [self Value];
}



@end
