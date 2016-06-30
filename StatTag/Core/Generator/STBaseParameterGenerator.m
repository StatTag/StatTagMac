//
//  STBaseParameterGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseParameterGenerator.h"
#import "STTag.h"
#import "STConstants.h"

@implementation STBaseParameterGenerator


-(NSString*) GetLabelParameter:(STTag*)tag
{
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([tag Name] != nil && [[[tag Name] stringByTrimmingCharactersInSet: ws] length] > 0)
  {
    return [NSString stringWithFormat:@"%@=\"%@\", ", [STConstantsTagParameters Label], [tag Name]];
  }
  return @"";
}

-(NSString*) GetRunFrequencyParameter:(STTag*)tag
{
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([tag RunFrequency] != nil && [[[tag RunFrequency] stringByTrimmingCharactersInSet: ws] length] > 0)
  {
    return [NSString stringWithFormat:@"%@=\"%@\", ", [STConstantsTagParameters Frequency], [tag RunFrequency]];
  }
  return @"";
}

-(NSString*) CleanResult:(NSString*)result
{
  //remove the normal whitespace characters (trim)
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  result = [result stringByTrimmingCharactersInSet: ws];

  //them remove any additional prefix/suffix commas (or whatever) (trim) - NOT wholesale replace
  NSCharacterSet *otherChars = [NSCharacterSet characterSetWithCharactersInString:@","];
  result = [result stringByTrimmingCharactersInSet:otherChars];

  return result;
}


@end
