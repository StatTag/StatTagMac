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
#import "STFilterFormat.h"

@implementation STTableParameterParser

NSString* const ColumnNames = @"ColumnNames";
NSString* const RowNames = @"RowNames";


+(void) Parse:(NSString*)tagText tag:(STTag*)tag
{
  tag.TableFormat = [[STTableFormat alloc] init];

  // If no parameters are set, fill in default values
  if ([tagText rangeOfString:[STConstantsTagTags ParamStart]].location == NSNotFound) {
    tag.RunFrequency = [STConstantsRunFrequency Always];
    return;
  }
  
  [STBaseParameterParser Parse:tagText Tag:tag];

  // After v1.0, we decided to move away from explicitly including column/row names, since it wasn't universally
  // consistent (in how data is represented) across all statistical packages.  Instead, we moved to row and column
  // filtering which would let the user skip a certain number of rows or columns.  By default then, this includes
  // row names and column names.
  // For backwards compatibility, we will look to see if these values were provided.  Note that we are no longer
  // including a default value for these, because if the attribute isn't present we want to know that. If the
  // attribute is there, we are going to convert it into a filter.
  // We are making the assumption that if this is an old tag that the Include attribute was set.  If not, we will
  // assume this is a newer tag and no conversion is necessary.
  NSNumber* includeColumnNames = [[self class] GetBoolParameter:ColumnNames text:tagText];
  if(includeColumnNames != nil && ![includeColumnNames boolValue])
  {
    tag.TableFormat.ColumnFilter.Enabled = true;
    tag.TableFormat.ColumnFilter.Type = [STConstantsFilterType Exclude];
    tag.TableFormat.ColumnFilter.Value = @"1";
  }

  NSNumber* includeRowNames = [[self class] GetBoolParameter:RowNames text:tagText];
  if(includeRowNames != nil && ![includeRowNames boolValue])
  {
    tag.TableFormat.RowFilter.Enabled = true;
    tag.TableFormat.RowFilter.Type = [STConstantsFilterType Exclude];
    tag.TableFormat.RowFilter.Value = @"1";
  }
  
  // We don't allow mix-and-match from v1 and v2 parameter types.  If we have set a filter that was set from our
  // migration code above, we're done.  Otherwise we will continue processing tags (this is typically what will happen).
  if (tag.TableFormat.ColumnFilter.Enabled || tag.TableFormat.RowFilter.Enabled)
  {
    return;
  }

  [[self class] BuildFilter:[STConstantsFilterPrefix Column] filter:[[tag TableFormat] ColumnFilter] tagText:tagText];
  [[self class] BuildFilter:[STConstantsFilterPrefix Row] filter:[[tag TableFormat] RowFilter] tagText:tagText];
  
  
//  [tag TableFormat].IncludeColumnNames = [STTableParameterParser GetBoolParameter:[STConstantsTableParameters ColumnNames] text:tagText defaultValue:[STConstantsTableParameterDefaults ColumnNames]];
//  [tag TableFormat].IncludeRowNames = [STTableParameterParser GetBoolParameter:[STConstantsTableParameters RowNames] text:tagText defaultValue:[STConstantsTableParameterDefaults RowNames]];
  
}


+(void) BuildFilter:(NSString*)filterPrefix filter:(STFilterFormat*)filter tagText:(NSString*)tagText
{

  filter.Enabled = [[[self class] GetBoolParameter:[NSString stringWithFormat:@"%@%@", filterPrefix, [STConstantsTableParameters FilterEnabled]] text:tagText defaultBOOLValue:[STConstantsTableParameterDefaults FilterEnabled]] boolValue];

  // We are only going to look at other parameters if the filter is enabled.
  if (filter.Enabled)
  {
    filter.Type = [[self class] GetStringParameter:[NSString stringWithFormat:@"%@%@", filterPrefix, [STConstantsTableParameters FilterType]] text:tagText defaultValue:[STConstantsTableParameterDefaults FilterType]];

    filter.Value = [[self class] GetStringParameter:[NSString stringWithFormat:@"%@%@", filterPrefix, [STConstantsTableParameters FilterValue]] text:tagText defaultValue:[STConstantsTableParameterDefaults FilterValue]];

  }
  else
  {
    filter.Type = [STConstantsTableParameterDefaults FilterType];
    filter.Value = [STConstantsTableParameterDefaults FilterValue ];
  }
}

@end
