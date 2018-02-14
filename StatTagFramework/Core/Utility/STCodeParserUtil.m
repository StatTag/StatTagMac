//
//  STCodeParserUtil.m
//  StatTag
//
//  Created by Rasmussen, Luke on 8/23/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STCodeParserUtil.h"

@implementation STCodeParserUtil

+(NSRegularExpression*)TrailingLineComment {
  NSError* error;
  NSRegularExpression* regex = [NSRegularExpression
                                regularExpressionWithPattern:@"(?<![\\*\"'])\\/\\/[^\\r\\n]*"
                                options:0
                                error:&error];
  return regex;
}

/// <summary>
/// Takes trailing comments and strips them from the input string.  This accounts for newlines so that
/// all trailing comments in a single string are managed, and it doesn't remove all of the text after
/// the first comment start it sees.
/// </summary>
/// <example>
/// Input
///     Test line one // comment\r\nTest line two
/// Output
///     Test line one \r\nTest line two
/// </example>
/// <param name="originalText"></param>
/// <returns></returns>
+(NSString*) StripTrailingComments:(NSString*) originalText
{
  if ([originalText length] == 0) {
    return originalText;
  }

  NSString *modifiedString = [[[self class] TrailingLineComment] stringByReplacingMatchesInString:originalText options:0 range:NSMakeRange(0, [originalText length]) withTemplate:@""];
  return modifiedString;
}

@end
