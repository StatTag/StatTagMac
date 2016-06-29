//
//  STBaseParameterParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/15/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseParameterParser.h"
#import "STTag.h"
#import "STConstants.h"

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

@synthesize RegexCache = _RegexCache;

static STBaseParameterParser* sharedInstance = nil;

+ (instancetype)sharedInstance
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  
//  dispatch_once(&once, ^{
//    sharedInstance = [[self alloc] init];
//  });
  return sharedInstance;
}

- (id)init {
  if (self = [super init]) {
    _RegexCache = [[NSMutableDictionary<NSString*,NSRegularExpression*> alloc] init];
  }
  return self;
}

+(void)Parse:(NSString*)tagText Tag:(STTag*)tag
{
  tag.Name = [STTag NormalizeName:[STBaseParameterParser GetStringParameter:[STConstantsTagParameters Label] text:tagText]];
  tag.RunFrequency = [STBaseParameterParser GetStringParameter:[STConstantsTagParameters Frequency] text:tagText defaultValue:[STConstantsRunFrequency Always] ];
}

/**
  @brief Build the regex to identify and extract a parameter from an tag string.
  Internally this uses a cache to save created regexes.  These are keyed by the
  parameters, as that will uniquely create the regex string.
 */
+(NSRegularExpression*) BuildRegex:(NSString*)name valueMatch:(NSString*)valueMatch  isQuoted:(BOOL)isQuoted {
  //STBaseParameterParser* sharedInstance = [STBaseParameterParser sharedInstance];
  NSString *key = [NSString stringWithFormat:@"%@-%@-%hhd", name, valueMatch, isQuoted];
  if([[[self sharedInstance] RegexCache] objectForKey:key] == nil) {

    NSString* regexPattern = [NSString stringWithFormat:@"\\%@.*%@\\s*=\\s*%@(%@)%@.*\\%@",
                                [STConstantsTagTags ParamStart],
                                name,
                                (isQuoted ? @"\\\"" : @""),
                                valueMatch,
                                //name,
                                (isQuoted ? @"\\\"" : @""),
                                [STConstantsTagTags ParamEnd]
                              ];
    /*
     Original parameters: "\\{2}.*{0}\\s*=\\s*{1}({4}){1}.*\\{3}"
     -------
     (0) -> name,
     (1) -> (isQuoted ? "\\\"" : string.Empty),
     (2) -> Constants.TagTags.ParamStart,
     (3) -> Constants.TagTags.ParamEnd,
     (4) -> valueMatch
     */
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:nil];
    [[[self sharedInstance] RegexCache] setObject:regex forKey:key];
  }
  return [[[self sharedInstance] RegexCache] objectForKey:key];
}

+(NSString*)GetParameter:(NSString*)name valueMatch:(NSString*)valueMatch text:(NSString*)text defaultValue:(NSString*)defaultValue quoted:(BOOL)quoted {

  if(text != nil) {
    NSRegularExpression* regex = [[self class] BuildRegex:name valueMatch:valueMatch isQuoted:quoted];
    NSTextCheckingResult* match = [regex firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
    if (match)
    {
      NSRange matchRange = [match rangeAtIndex:1];
      NSString *matchString = [text substringWithRange:matchRange];
      return matchString;
    }
  }
  
  return defaultValue;
  
}

+(NSString*)GetParameter:(NSString*) name valueMatch:(NSString*)valueMatch text:(NSString*)text defaultValue:(NSString*)defaultValue {
  return [self GetParameter:name valueMatch:valueMatch text:text defaultValue:defaultValue quoted:YES];
}
+(NSString*)GetParameter:(NSString*) name valueMatch:(NSString*)valueMatch text:(NSString*)text {
  return [self GetParameter:name valueMatch:valueMatch text:text defaultValue:@"" quoted:YES];
}

+(NSString*)GetStringParameter:(NSString*)name text:(NSString*)text defaultValue:(NSString*)defaultValue quoted:(BOOL)quoted
{
  return [STBaseParameterParser GetParameter:name valueMatch:[STBaseParameterParser StringValueMatch] text:text defaultValue:defaultValue quoted:quoted];
}
+(NSString*)GetStringParameter:(NSString*)name text:(NSString*)text defaultValue:(NSString*)defaultValue {
  return [STBaseParameterParser GetStringParameter:name text:text defaultValue:defaultValue quoted:YES];
}
+(NSString*)GetStringParameter:(NSString*)name text:(NSString*)text {
  return [STBaseParameterParser GetStringParameter:name text:text defaultValue:@"" quoted:YES];
  
}


+(NSNumber*) GetIntParameter:(NSString*)name text:(NSString*)text defaultValue:(NSNumber*)defaultValue
{
  NSString* stringValue = [STBaseParameterParser GetParameter:name valueMatch:[STBaseParameterParser IntValueMatch] text:nil defaultValue:NO];
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([[stringValue stringByTrimmingCharactersInSet: ws] length] == 0) {
    return defaultValue;
  }
  
  NSNumber *value = [NSNumber numberWithInteger:[stringValue integerValue]];
  if(value) {
    return value;
  }
  
  return defaultValue;
}
+(NSNumber*) GetIntParameter:(NSString*)name text:(NSString*)text
{
  return [STBaseParameterParser GetIntParameter:name text:text defaultValue:nil];
}

/*
 NOTE: we can't return nil-able bool values and returning NSNumber (to front a bool) seems like it's going to be really, really confusing to people later on - so we're going to just default to "false" in the event we don't have a default - which will force a bool result
 */
+(BOOL) GetBoolParameter:(NSString*)name text:(NSString*)text defaultValue:(BOOL)defaultValue
{
  NSString* stringValue = [STBaseParameterParser GetParameter:name valueMatch:[STBaseParameterParser BoolValueMatch] text:text defaultValue:nil quoted:false];
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([[stringValue stringByTrimmingCharactersInSet: ws] length] == 0) {
    return defaultValue;
  }
  
  NSNumber* value = [NSNumber numberWithBool:[stringValue boolValue]];
  if(value){
    return [value boolValue];
  }
  
  return defaultValue;
}
+(BOOL) GetBoolParameter:(NSString*)name text:(NSString*)text {
  return [STBaseParameterParser GetBoolParameter:name text:text defaultValue:false];
}

@end
