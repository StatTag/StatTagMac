//
//  STValueFormat.m
//  StatTag
//
//  Created by Eric Whitley on 6/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STValueFormat.h"
#import "STBaseValueFormatter.h"
#import "STConstants.h"
#import "STJSONUtility.h"

@implementation STValueFormat

@synthesize FormatType = _FormatType;
@synthesize DecimalPlaces = _DecimalPlaces;
@synthesize UseThousands = _UseThousands;
@synthesize DateFormat = _DateFormat;
@synthesize TimeFormat = _TimeFormat;
@synthesize AllowInvalidTypes = _AllowInvalidTypes;


//MARK: copying

-(id)copyWithZone:(NSZone *)zone
{
  STValueFormat *format = [[[self class] allocWithZone:zone] init];//[[STValueFormat alloc] init];

  format.FormatType = [_FormatType copyWithZone:zone];
  format.DecimalPlaces = _DecimalPlaces;
  format.UseThousands = _UseThousands;
  format.DateFormat = [_DateFormat copyWithZone:zone];
  format.TimeFormat = [_TimeFormat copyWithZone:zone];
  format.AllowInvalidTypes = _AllowInvalidTypes;

  return format;
}


-(NSString*)Format:(NSString*)value valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter {
  
  if(valueFormatter == nil) {
    valueFormatter = [[STBaseValueFormatter alloc] init];
  }

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([[value stringByTrimmingCharactersInSet: ws] length] == 0){
    return @"";
  }

  if([_FormatType isEqualToString: [STConstantsValueFormatType Numeric]]) {
    value = [self FormatNumeric:value];
  } else if ([_FormatType isEqualToString: [STConstantsValueFormatType Percentage]]) {
    value = [self FormatPercentage:value];
  } else if ([_FormatType isEqualToString: [STConstantsValueFormatType DateTime]]) {
    value = [self FormatDateTime:value];
  }
  
  return [valueFormatter Finalize:value];
  
}
-(NSString*)Format:(NSString*)value {
  return [self Format:value valueFormatter:nil];
}

+(NSString*)Repeat:(NSString*)value count:(int)count {
  if(value != nil) {
    return [@"" stringByPaddingToLength:(count * [value length]) withString:value startingAtIndex:0];
  }
  return @"";
}


/**
 @brief Format a numeric result
 @param value: The string value to be formatted
 */
-(NSString*) FormatNumeric:(NSString*) value {
  
  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
  f.numberStyle = NSNumberFormatterDecimalStyle;
  f.locale = [NSLocale currentLocale]; //this is the default, but explicitly setting this in code so it's clear there may be issues with conflicting locales (what's in data vs. user preference)
  NSNumber *aNumber = [f numberFromString:value];
  
  if(aNumber == nil) {
    if(_AllowInvalidTypes){return value;}
    return @"";
  }
  
  double numericValue = [aNumber doubleValue];

  
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  if(_UseThousands){
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  }
  [formatter setMinimumFractionDigits:_DecimalPlaces];
  [formatter setMaximumFractionDigits:_DecimalPlaces];
  [formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
  return [formatter stringFromNumber:[NSNumber numberWithDouble:numericValue]];
}

/**
 @brief Format a result as a percentage
 @param value: The string value to be formatted
 */
-(NSString*) FormatPercentage:(NSString*) value {
  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
  f.numberStyle = NSNumberFormatterDecimalStyle;
  f.locale = [NSLocale currentLocale]; //this is the default, but explicitly setting this in code so it's clear there may be issues with conflicting locales (what's in data vs. user preference)
  NSNumber *aNumber = [f numberFromString:value];
  
  if(aNumber == nil) {
    if(_AllowInvalidTypes){return value;}
    return @"";
  }
  
  double numericValue = [aNumber doubleValue];
  
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterPercentStyle];
  //[formatter setMultiplier:@1.0];//if our numbers are already in percentages (ex: 10 vs 0.1)
  [formatter setMinimumFractionDigits:_DecimalPlaces];
  [formatter setMaximumFractionDigits:_DecimalPlaces];
  [formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
  return [formatter stringFromNumber:[NSNumber numberWithDouble:numericValue]];
}

/**
 @brief Format a result as a date and/or time
 @param value: The string value to be formatted
 */
-(NSString*) FormatDateTime:(NSString*) value {

  NSDate *dateValue;
  dateValue = [STJSONUtility dateFromString:value];
//  NSTimeZone *timeZone = [NSTimeZone localTimeZone];
//  
//  NSError *error = NULL;
//  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeDate error:&error];
//  
//  NSArray *matches = [detector matchesInString:value options:0 range:NSMakeRange(0, [value length])];
//  
//  for (NSTextCheckingResult *match in matches) {
//    if ([match resultType] == NSTextCheckingTypeDate) {
//      dateValue = [match date];
//      //NSLog(@"timezone: %@", [match timeZone]);
//      //NSLog(@"match: %@", match);
//      if([match timeZone] == nil) {
//        
//      }
//    }
//  }
  
  if(dateValue == nil) {
    if(_AllowInvalidTypes){return value;}
    return @"";
  }
  
  NSString *format = @"";
  NSString *timeSeparator = @"";
  //NOTE: difference from c#. Our date/time formatting isn't going to allow empty spaces in the string, so we want to set up a 'separator' and only populate it and use it if we have both a date and a time
  
  //NSLog(@"DateFormat = %@", DateFormat);
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if (!([[_DateFormat stringByTrimmingCharactersInSet: ws] length] == 0)){
    if ([_DateFormat isEqualToString:[STConstantsDateFormats MMDDYYYY]]
        || [_DateFormat isEqualToString:[STConstantsDateFormats MonthDDYYYY]])
    {
      format = _DateFormat;
      timeSeparator = @" ";
    }
  }
  if (!([[_TimeFormat stringByTrimmingCharactersInSet: ws] length] == 0)){
    if ([_TimeFormat isEqualToString:[STConstantsTimeFormats HHMM]]
        || [_TimeFormat isEqualToString:[STConstantsTimeFormats HHMMSS]])
    {
      format = [NSString stringWithFormat:@"%@%@%@", format, timeSeparator, _TimeFormat];
    }
  }

  if ([[format stringByTrimmingCharactersInSet: ws] length] == 0){
    return @"";
  }
  
  //this is a huge guess... we need to discuss locale handling
  NSLocale* currentLoc = [NSLocale currentLocale];

  NSLog(@"Date: %@", dateValue);
  
  //FIXME: date formatter should be moved to a shared global property
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
  //FIXME: locale...
  [formatter setLocale:currentLoc];
  //  NSTimeZone *timeZone = [NSTimeZone localTimeZone];
  [formatter setTimeZone:[NSTimeZone localTimeZone]];
  return [formatter stringFromDate:dateValue];

  return nil;
}


//MARK: equality
- (NSUInteger)hash {
  int hashCode = (_FormatType != nil ? [_FormatType hash] : 0);
  hashCode = (hashCode*397) ^ _DecimalPlaces;
  hashCode = (hashCode*397) ^ _UseThousands;
  hashCode = (hashCode*397) ^ (_DateFormat != nil ? [_DateFormat hash] : 0);
  hashCode = (hashCode*397) ^ (_TimeFormat != nil ? [_TimeFormat hash] : 0);
  hashCode = (hashCode*397) ^ (_AllowInvalidTypes ? 1 : 0);
  
  return (NSUInteger)abs(hashCode);
}

- (BOOL)isEqual:(id)object
{
  if (![object isKindOfClass:self.class]) {
    return NO;
  }
  STValueFormat *other = object;
  return self.hash == other.hash;
}









//MARK: JSON
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setValue:[self FormatType] forKey:@"FormatType"];
  [dict setValue:@([self DecimalPlaces]) forKey:@"DecimalPlaces"];
  [dict setValue:@([[NSNumber numberWithInteger:[self UseThousands]] boolValue]) forKey:@"UseThousands"];
  [dict setValue:[self DateFormat] forKey:@"DateFormat"];
  [dict setValue:[self TimeFormat] forKey:@"TimeFormat"];
  [dict setValue:@([[NSNumber numberWithInteger:[self AllowInvalidTypes]] boolValue]) forKey:@"AllowInvalidTypes"];
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    //    if([key isEqualToString:@"FilePath"]) {
    //      [self setValue:[NSURL fileURLWithPath:[dict valueForKey:key]] forKey:key];
    //    } else if([key isEqualToString:@"LastCached"]) {
    //      [self setValue:[STJSONUtility dateFromString:[dict valueForKey:key]] forKey:key];
    //    } else {
    [self setValue:[dict valueForKey:key] forKey:key];
    //    }
  }
}

-(NSString*)Serialize:(NSError**)outError
{
  return [STJSONUtility SerializeObject:self error:nil];
}

+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
  return [STJSONUtility SerializeList:list error:nil];
}

+(NSArray<STValueFormat*>*)DeserializeList:(NSString*)List error:(NSError**)outError
{
  NSMutableArray<STValueFormat*>* ar = [[NSMutableArray<STValueFormat*> alloc] init];
  for(id x in [STJSONUtility DeserializeList:List forClass:[self class] error:nil]) {
    if([x isKindOfClass:[self class]])
    {
      [ar addObject:x];
    }
  }
  return ar;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
  self = [super init];
  if (self) {
    [self setWithDictionary:dict];
  }
  return self;
}

-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
{
  self = [super init];
  if (self) {
    
    NSError *error = nil;
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (!error && JSONDictionary) {
      [self setWithDictionary:JSONDictionary];
    } else {
      if (outError) {
        *outError = [NSError errorWithDomain:STStatTagErrorDomain
                                        code:[error code]
                                    userInfo:@{NSUnderlyingErrorKey: error}];
      }
    }
  }
  return self;
}






@end
