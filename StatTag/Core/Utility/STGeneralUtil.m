//
//  STGeneralUtil.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STGeneralUtil.h"

@implementation STGeneralUtil

/**
 Convert a string array to an object array to avoid potential issues (per ReSharper).

 @param data: The string array to convert
 @Nil if the string array is null, otherwise an object-cast array representation of the original string array.
*/
+(NSArray*)StringArrayToObjectArray:(NSArray<NSString*>*) data
{
  return data;
//  if (data == nil)
//  {
//    return nil;
//  }
//  
//  return data.Select(x => x as object).ToArray();
}



@end
