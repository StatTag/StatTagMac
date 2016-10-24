//
//  STCodeFile+TagInfo.m
//  StatTag
//
//  Created by Eric Whitley on 10/24/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCodeFile+TagInfo.h"

@implementation STCodeFile (TagInfo)


-(NSInteger) numberOfTags
{
  return [[self Tags] count];
}

@end
