//
//  STValueParameterParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STValueParameterParser.h"
#import "STTag.h"
#import "STValueFormat.h"
#import "STConstants.h"

@implementation STValueParameterParser

+(void) Parse:(NSString*)tagText tag:(STTag*)tag
{
  tag.ValueFormat = [[STValueFormat alloc] init];
  
  // If no parameters are set, fill in default values
  if ([tagText rangeOfString:[STConstantsTagTags ParamStart]].location == NSNotFound) {
    [tag ValueFormat].FormatType = [STConstantsValueFormatType Default];
    tag.RunFrequency = [STConstantsRunFrequency Always];
    return;
  }
  
  [STBaseParameterParser Parse:tagText Tag:tag];

  [tag ValueFormat].FormatType = [STValueParameterParser GetParameter:[STConstantsValueParameters Type] valueMatch:tagText text:[STConstantsValueFormatType Default]];

  NSNumber *intValue = [STValueParameterParser GetIntParameter:[STConstantsValueParameters Decimals] text:tagText defaultValue:0];
  [tag ValueFormat].DecimalPlaces = [intValue integerValue]; // Since we specify a default, we assume it won't ever be null

  BOOL boolValue = [STValueParameterParser GetBoolParameter:[STConstantsValueParameters UseThousands] text:tagText defaultValue:false];
  [tag ValueFormat].UseThousands = boolValue;// Since we specify a default, we assume it won't ever be null

  [tag ValueFormat].DateFormat = [STValueParameterParser GetStringParameter:[STConstantsValueParameters DateFormat] text:tagText];
  [tag ValueFormat].TimeFormat = [STValueParameterParser GetStringParameter:[STConstantsValueParameters TimeFormat] text:tagText];


  boolValue = [STValueParameterParser GetBoolParameter:[STConstantsValueParameters AllowInvalidTypes] text:tagText defaultValue:false];
  [tag ValueFormat].AllowInvalidTypes = boolValue; // Since we specify a default, we assume it won't ever be null
  
}



@end
