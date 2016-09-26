//
//  STFigureParameterParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTableParameterParser.h"
#import "STTag.h"
#import "STTableFormat.h"
#import "STConstants.h"

@implementation STTableParameterParser


+(void) Parse:(NSString*)tagText tag:(STTag*)tag
{
  tag.TableFormat = [[STTableFormat alloc] init];

  // If no parameters are set, fill in default values
  if ([tagText rangeOfString:[STConstantsTagTags ParamStart]].location == NSNotFound) {
    tag.RunFrequency = [STConstantsRunFrequency Always];
    return;
  }
  
  [STBaseParameterParser Parse:tagText Tag:tag];
  [tag TableFormat].IncludeColumnNames = [STTableParameterParser GetBoolParameter:[STConstantsTableParameters ColumnNames] text:tagText defaultValue:[STConstantsTableParameterDefaults ColumnNames]];
  [tag TableFormat].IncludeRowNames = [STTableParameterParser GetBoolParameter:[STConstantsTableParameters RowNames] text:tagText defaultValue:[STConstantsTableParameterDefaults RowNames]];
  
}


@end
