//
//  UIUtility.m
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "UIUtility.h"
#import <StatTagFramework/StatTag.h>

@implementation UIUtility

+(NSObject<STIResultCommandList>*)GetResultCommandList:(STCodeFile*)file resultType:(NSString*)resultType
{
  
  if(file!=nil) {
    NSObject<STIResultCommandFormatter>* formatter = nil;
    if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages Stata]]) {
      formatter = [[STStataCommands alloc] init];
    } else if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages SAS]]) {
      formatter = [[STSASCommands alloc] init];
    } else if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages R]]) {
    }
    
    if(formatter != nil) {
      if([resultType isEqualToString:[STConstantsTagType Value]]) {
        return [formatter ValueResultCommands];
      } else if([resultType isEqualToString:[STConstantsTagType Value]]) {
        return [formatter FigureResultCommands];
      } else if([resultType isEqualToString:[STConstantsTagType Value]]) {
        return [formatter TableResultCommands];
      }
    }
  }

  return nil;
}


@end
