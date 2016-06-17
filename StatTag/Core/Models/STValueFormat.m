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

@implementation STValueFormat

@synthesize FormatType = FormatType;
@synthesize DecimalPlaces = DecimalPlaces;
@synthesize UseThousands = UseThousands;
@synthesize DateFormat = DateFormat;
@synthesize TimeFormat = TimeFormat;
@synthesize AllowInvalidTypes = AllowInvalidTypes;


-(NSString*)Format:(NSString*)value valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter {
  
  if(valueFormatter == nil) {
    valueFormatter = [[STBaseValueFormatter alloc] init];
  }

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([[value stringByTrimmingCharactersInSet: ws] length] == 0){
    return @"";
  }

  if(FormatType == [STConstantsValueFormatType Numeric]) {
    value = [self FormatNumeric:value];
  } else if (FormatType == [STConstantsValueFormatType Percentage]) {
    value = [self FormatPercentage:value];
  } else if (FormatType == [STConstantsValueFormatType DateTime]) {
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
    if(AllowInvalidTypes){return value;}
    return @"";
  }
  
  double numericValue = [aNumber doubleValue];

  
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  if(UseThousands){
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  }
  [formatter setMinimumFractionDigits:DecimalPlaces];
  [formatter setMaximumFractionDigits:DecimalPlaces];
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
    if(AllowInvalidTypes){return value;}
    return @"";
  }
  
  double numericValue = [aNumber doubleValue];
  
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterPercentStyle];
  //[formatter setMultiplier:@1.0];//if our numbers are already in percentages (ex: 10 vs 0.1)
  [formatter setMinimumFractionDigits:DecimalPlaces];
  [formatter setMaximumFractionDigits:DecimalPlaces];
  [formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
  return [formatter stringFromNumber:[NSNumber numberWithDouble:numericValue]];
}

/**
 @brief Format a result as a date and/or time
 @param value: The string value to be formatted
 */
-(NSString*) FormatDateTime:(NSString*) value {

  NSDate *dateValue;
  
  NSError *error = NULL;
  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeDate error:&error];
  
  NSArray *matches = [detector matchesInString:value options:0 range:NSMakeRange(0, [value length])];
  
  for (NSTextCheckingResult *match in matches) {
    if ([match resultType] == NSTextCheckingTypeDate) {
      dateValue = [match date];
    }
  }
  
  if(dateValue == nil) {
    if(AllowInvalidTypes){return value;}
    return @"";
  }
  
  NSString *format = @"";
  NSString *timeSeparator = @"";
  //NOTE: difference from c#. Our date/time formatting isn't going to allow empty spaces in the string, so we want to set up a 'separator' and only populate it and use it if we have both a date and a time
  
  NSLog(@"DateFormat = %@", DateFormat);
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if (!([[DateFormat stringByTrimmingCharactersInSet: ws] length] == 0)){
    if ([DateFormat isEqualToString:[STConstantsDateFormats MMDDYYYY]]
        || [DateFormat isEqualToString:[STConstantsDateFormats MonthDDYYYY]])
    {
      format = DateFormat;
      timeSeparator = @" ";
    }
  }
  if (!([[TimeFormat stringByTrimmingCharactersInSet: ws] length] == 0)){
    if ([TimeFormat isEqualToString:[STConstantsTimeFormats HHMM]]
        || [TimeFormat isEqualToString:[STConstantsTimeFormats HHMMSS]])
    {
      format = [NSString stringWithFormat:@"%@%@%@", format, timeSeparator, TimeFormat];
    }
  }

  if ([[format stringByTrimmingCharactersInSet: ws] length] == 0){
    return @"";
  }
  
  //this is a huge guess... we need to discuss locale handling
  NSLocale* currentLoc = [NSLocale currentLocale];

  //FIXME: date formatter should be moved to a shared global property
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
  //FIXME: locale...
  [formatter setLocale:currentLoc];
  return [formatter stringFromDate:dateValue];

  return nil;
}



//FIXME: test this
//NOTE: apparently isEqual is different in obj-c (compared to Swift or C#), so triple-check this
- (NSUInteger)hash {
  int hashCode = (FormatType != nil ? [FormatType hash] : 0);
  hashCode = (hashCode*397) ^ DecimalPlaces;
  hashCode = (hashCode*397) ^ UseThousands;
  hashCode = (hashCode*397) ^ (DateFormat != nil ? [DateFormat hash] : 0);
  hashCode = (hashCode*397) ^ (TimeFormat != nil ? [TimeFormat hash] : 0);
  hashCode = (hashCode*397) ^ (AllowInvalidTypes ? 1 : 0);
  
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


@end
