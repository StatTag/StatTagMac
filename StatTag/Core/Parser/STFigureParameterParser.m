//
//  STFigureParameterParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STFigureParameterParser.h"
#import "STTag.h"
#import "STFigureFormat.h"
#import "STConstants.h"

@implementation STFigureParameterParser


+(void) Parse:(NSString*)tagText tag:(STTag*)tag
{
  tag.FigureFormat = [[STFigureFormat alloc] init];

  // If no parameters are set, fill in default values
  if ([tagText rangeOfString:[STConstantsTagTags ParamStart]].location == NSNotFound) {
    tag.RunFrequency = [STConstantsRunFrequency Always];
    return;
  }
  
  [STBaseParameterParser Parse:tagText Tag:tag];
}


@end
