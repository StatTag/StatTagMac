//
//  STCodeFile+FileHelper.m
//  StatTag
//
//  Created by Eric Whitley on 4/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "STCodeFile+FileHelper.h"
#import <StatTagFramework/STConstants.h>


@implementation STCodeFile (FileHelper)

+(bool)fileIsSupported:(id)filePath
{
  NSString* pathExtension;
  if([filePath isKindOfClass:[NSString class]])
  {
    pathExtension = [(NSString*)filePath pathExtension];
  } else if ([filePath isKindOfClass:[NSURL class]])
  {
    pathExtension = [(NSURL*)filePath pathExtension];
  }
  
  if([[STConstantsFileFilters SupportedFileFiltersArray] containsObject:[pathExtension lowercaseString]])
  {
    return true;
  }
  return false;
}


@end
