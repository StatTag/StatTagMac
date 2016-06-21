//
//  STBaseParameterParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/15/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseParameterParser.h"

@implementation STBaseParameterParser

+(NSString *)StringValueMatch {
  return @".*?";
}
+(NSString *)IntValueMatch{
  return @"\\d+";
}
+(NSString *)BoolValueMatch{
  return @"true|false|True|False";
}

//static NSMutableDictionary<NSString*,NSRegularExpression*>* RegexCache;
//+ (NSMutableDictionary<NSString*,NSRegularExpression*>*)RegexCache { return RegexCache; }
//+ (void)setRegexCache:(NSMutableDictionary<NSString*,NSRegularExpression*>*)cache { RegexCache = cache; }

NSMutableDictionary<NSString*,NSRegularExpression*>* RegexCache;

+ (instancetype)sharedInstance
{
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
    RegexCache = [[NSMutableDictionary<NSString*,NSRegularExpression*> alloc] init];
  });
  return sharedInstance;
}

+(void)Parse:(NSString*)tagText Tag:(STTag*)tag
{
  //FIXME: incomplete implementation
//  tag.Name = Tag.NormalizeName(GetStringParameter(Constants.TagParameters.Label, tagText));
//  tag.RunFrequency = GetStringParameter(Constants.TagParameters.Frequency, tagText, Constants.RunFrequency.Always);
}

/**
  @brief Build the regex to identify and extract a parameter from an tag string.
  Internally this uses a cache to save created regexes.  These are keyed by the
  parameters, as that will uniquely create the regex string.
 */
+(NSRegularExpression*) BuildRegex:(NSString*)name valueMatch:(NSString*)valueMatch  isQuoted:(BOOL)isQuoted {
  //FIXME: incomplete implementation
  //            string key = string.Format("{0}-{1}-{2}", name, valueMatch, isQuoted);
  NSString *key = [NSString stringWithFormat:@"%@-%@-%hhd", name, valueMatch, isQuoted];
  if([RegexCach])
  
  return nil;
}

+(NSString*)GetParameter:(NSString*) name valueMatch:(NSString*)valueMatch text:(NSString*)text defaultValue:(NSString*)defaultValue quoted:(BOOL)quoted {
  if (defaultValue == nil){
    defaultValue = @"";
  }
  return nil;
}

+(NSString*)GetParameter:(NSString*) name valueMatch:(NSString*)valueMatch text:(NSString*)text defaultValue:(NSString*)defaultValue {
  return [self GetParameter:name valueMatch:valueMatch text:text defaultValue:defaultValue quoted:YES];
}




@end
