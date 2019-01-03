//
//  UIUtility.m
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "UIUtility.h"
#import <StatTagFramework/StatTagFramework.h>
#import "NSAttributedString+Hyperlink.h"


@implementation UIUtility

+(NSObject<STIResultCommandList>*)GetResultCommandList:(STCodeFile*)file resultType:(NSString*)resultType
{
  if (file != nil) {
    NSObject<STIResultCommandFormatter>* formatter = nil;
    if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages Stata]]) {
      formatter = [[STStataCommands alloc] init];
    } else if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages SAS]]) {
      formatter = [[STSASCommands alloc] init];
    } else if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages R]]) {
      formatter = [[STRCommands alloc] init];
    } else if([[file StatisticalPackage] isEqualToString:[STConstantsStatisticalPackages RMarkdown]]) {
      formatter = [[STRCommands alloc] init];
    }
  
    if(formatter != nil) {
      if([resultType isEqualToString:[STConstantsTagType Value]]) {
        return [formatter ValueResultCommands];
      } else if([resultType isEqualToString:[STConstantsTagType Figure]]) {
        return [formatter FigureResultCommands];
      } else if([resultType isEqualToString:[STConstantsTagType Table]]) {
        return [formatter TableResultCommands];
      } else if([resultType isEqualToString:[STConstantsTagType Verbatim]]) {
        return [formatter VerbatimResultCommands];
      }
    }
  }

  return nil;
}



//https://developer.apple.com/library/content/qa/qa1487/_index.html
+(void)setHyperlink:(NSURL*)url withTitle:(NSString*)title inTextField:(NSTextField*)inTextField
{
  // both are needed, otherwise hyperlink won't accept mousedown
  [inTextField setAllowsEditingTextAttributes: YES];
  [inTextField setSelectable: YES];
  
  //NSURL* url = [NSURL URLWithString:@"http://www.apple.com"];
  
  NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
  [string appendAttributedString: [NSAttributedString hyperlinkFromString:title withURL:url]];
  
  // set the attributed string to the NSTextField
  [inTextField setAttributedStringValue: string];
}


@end
