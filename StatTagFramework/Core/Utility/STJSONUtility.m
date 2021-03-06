//
//  STJSONUtility.m
//  StatTag
//
//  Created by Eric Whitley on 6/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STJSONUtility.h"
#import "STValueFormat.h"
#import "STJSONAble.h"
#import "STConstants.h"

@implementation STJSONUtility

//MARK: date handling

+ (NSDate*)dateFromString:(NSString*)dateString {
  
  if(dateString == nil || [dateString isKindOfClass:[NSNull class]]) {
    return nil;
  }

  /*
   Step 1: See if we have a known fixed time format (see below on why) - using NSDateFormatter
   Step 2: Catch-all using NSDataDetector
   
   Why are we doing this two different ways? Why not just one?
   
   We don't know any of the date/time formats (not really), so using fixed date formatters and extracting the datetime from the string really isn't likely to be effective.  Could be "06/01/2016" or could be "June 1, 2016" or even "June First, 2016" - we just don't know.
   
   We also don't know based on the locale how we should anticipate the string format.
   
     EX: "June 1, 2016"
     - is it 01/06
     - or is it 06/01
   
   We could detect the locale and guess based on that (which is what we're really going to be doing anyway), but then we're still having to do fixed formats
   
     http://stackoverflow.com/questions/5135482/how-to-determine-if-locales-date-format-is-month-day-or-day-month
     BOOL dayFirst = [[NSDateFormatter dateFormatFromTemplate:@"MMMMd" options:0 locale:[NSLocale currentLocale]] hasPrefix:@"d"];
   
   OK, so if we don't know the formats, let's try NSDataDetector.
   
   That seems to work fine... but... if we supply _ONLY_ a time (no date) we see weirdness when crossing UTC days. For some reason I can't fathom, when we cross a UTC date, the date seems to _shift_ and the timezones do something odd. If we cross the day boundary, the "date" portion of the datetime shifts and we move from AM to PM.
   
   EX:
   
   If I set my system clock time to: **06:01AM**, **07:01AM**, or **08:01AM**  (all the same results) These look "right" as the times seem to be inferred consistently.
   -------------
   - original:07:30 got_date:2016-06-18 12:30:00 +0000 formatted_time:07:30
   - original:8:30 got_date:2016-06-18 13:30:00 +0000 formatted_time:08:30
   - original:9:30 got_date:2016-06-18 14:30:00 +0000 formatted_time:09:30
   - original:10:30 got_date:2016-06-18 15:30:00 +0000 formatted_time:10:30
   - original:11:30 got_date:2016-06-18 16:30:00 +0000 formatted_time:11:30

   System clock time: **09:01AM US Central** The 8:30 date is shifted (but not 7:30, 9:30, 10:30, or 11:30)
   -------------
   - original:07:30 got_date:2016-06-17 12:30:00 +0000 formatted_time:07:30
   - original:8:30 got_date:**2016-06-18 01:30:00 +0000** formatted_time:**20:30**
   - original:9:30 got_date:2016-06-17 14:30:00 +0000 formatted_time:09:30
   - original:10:30 got_date:2016-06-17 15:30:00 +0000 formatted_time:10:30
   - original:11:30 got_date:2016-06-17 16:30:00 +0000 formatted_time:11:30

   System clock time: **10:01AM US Central** (and now 8:30, and 9:30 are shifted, but not the others)
   -------------
   - original:07:30 got_date:2016-06-17 12:30:00 +0000 formatted_time:07:30
   - original:8:30 got_date:**2016-06-18 01:30:00 +0000** formatted_time:**20:30**
   - original:9:30 got_date:**2016-06-18 02:30:00 +0000** formatted_time:**21:30**
   - original:10:30 got_date:2016-06-17 15:30:00 +0000 formatted_time:10:30
   - original:11:30 got_date:2016-06-17 16:30:00 +0000 formatted_time:11:30

   (Now that you've read all of that...)
   
   To recover from this (and - honestly - it's probably something I'm not understanding about data detectors and date timezones), we say "look, try to parse the _time_ using a known format" - BEFORE we then use the data detector. Using NSDateFormatter seems to produce the "correct" date without timezone impact.
   */
  
  NSDate *dateValue;

  //---------------------------
  //First - let's see if we have one of those fixed time formats (without a date)
  //  **** See above note on why ****
  //---------------------------
  NSArray *dateFormats = @[@"hh:mm a", @"hh:mm", @"hh:mm:ss a", @"hh:mm:ss", @"YYYY-MM-dd'T'HH:mm:ssZZZ"];
  NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
  for (NSString *dateFormat in dateFormats) {
    [formatter setDateFormat:dateFormat];
    dateValue = [formatter dateFromString:dateString];
    if (dateValue) {
      return dateValue;
    }
  }
  
  //---------------------------
  //Failing that, let's see if we can detect the date using a data detector
  //---------------------------
  NSError *error = NULL;
  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeDate error:&error];
  
  NSArray *matches = [detector matchesInString:dateString options:0 range:NSMakeRange(0, [dateString length])];
  
  for (NSTextCheckingResult *match in matches) {
    if ([match resultType] == NSTextCheckingTypeDate) {
      dateValue = [match date];
      if(dateValue) {
        return dateValue;
      }
    }
  }

  //last-ditch...milliseconds since 1970 - since that's more of a universal json thing
  NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
  BOOL isNumeric = [nf numberFromString:dateString] != nil;
  if(isNumeric) {
    NSNumber* n = [NSNumber numberWithDouble:[dateString doubleValue]];
    NSDate* aDate = [NSDate dateWithTimeIntervalSince1970:[n doubleValue]];
    if(aDate){
      return aDate;
    }
  }
  
  //nothing detected
  return dateValue;  
}

+ (NSString *) convertDateToDateString :(NSDate *) date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
  NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"YYYY-MM-dd'T'HH:mm:ssZZZ" options:0 locale:nil];
  [dateFormatter setDateFormat:dateFormat];
  //note: we're going to avoid doing this for now - our json date will be emitted in standardized format
  //if we set our locale, it overrides the format we specify into the format on the host machine
  //NSLocale *locale = [NSLocale currentLocale];
  //[dateFormatter setLocale:locale];
  NSString *dateString = [dateFormatter stringFromDate:date];
  return dateString;
}

//MARK: object serialization helpers

+(NSString*)SerializeObject:(NSObject<STJSONAble>*)object error:(NSError**)outError
{
  NSError* error;
  NSDictionary* dataDictionary = [object toDictionary];
  if ([NSJSONSerialization isValidJSONObject:dataDictionary]) {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
  }

  return nil;
}

//MARK: list serialization helpers

/**
 Utility method to serialize the list of code files into a JSON array.
 */
+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)files error:(NSError**)outError {
  
  NSData *json;
  NSError *error = nil;
  
  NSMutableArray *fileList = [[NSMutableArray alloc] init];
  for (NSObject<STJSONAble> *o in files){
    [fileList addObject:[o toDictionary]];
  }
  
  if ([NSJSONSerialization isValidJSONObject:fileList])
  {
    json = [NSJSONSerialization dataWithJSONObject:fileList options:NSJSONWritingPrettyPrinted error:&error];
    
    if (json != nil && error == nil)
    {
      return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    
    if (outError) {
      *outError = [NSError errorWithDomain:STStatTagErrorDomain
                                      code:[error code]
                                  userInfo:@{NSUnderlyingErrorKey: error}];
    }
    //NSLog(@"error: %@", [error localizedDescription]);
  } else {
    //NSLog(@"invalid json");
    *outError = [NSError errorWithDomain:STStatTagErrorDomain
                                    code:-1
                                userInfo:@{NSLocalizedDescriptionKey: @"Invalid JSON"}];
    
  }
  return nil;
}



+(NSArray<NSObject<STJSONAble>*>*)DeserializeList:(id)List forClass:(id)c error:(NSError**)outError
{
  NSError *error = nil;
  NSMutableArray *list = [[NSMutableArray<NSObject<STJSONAble>*> alloc] init];
  NSMutableArray *values = [[NSMutableArray alloc] init];
  
  if([List isKindOfClass:[NSString class]] ) {
    //we might have a single json string
    NSData *jsonData = [List dataUsingEncoding:NSUTF8StringEncoding];
    values = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
  } else if ([List isKindOfClass:[NSArray class]]) {
    for(id d in List) {
      if([d isKindOfClass:[NSDictionary class]]){
        //we might have an array of dictionaries
        [values addObject:d];
      }
      if([d isKindOfClass:[NSString class]]){
        //we might have an array of json strings
        NSData *jsonData = [List dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        [values addObjectsFromArray:objs];
      }
    }
  }
  
  if ([values isKindOfClass:[NSArray class]] && error == nil) {
    for(id d in values) {
      if([d isKindOfClass:[NSDictionary class]]){
        if(d != nil && ![d isKindOfClass:[[NSNull null] class]])
        {
          id file = [[[c class] alloc] initWithDictionary:d];
          if(file != nil) {
            [list addObject:file];
          }
        }
      }
    }
  }

  return list;
}

+(NSArray<NSObject<STJSONAble>*>*)DeserializeListFromDictionaryArray:(NSArray<NSDictionary*>*)List forClass:(id)c error:(NSError**)outError
{
  NSMutableArray *list = [[NSMutableArray<NSObject<STJSONAble>*> alloc] init];
  for(NSDictionary* d in List) {
    id file = [[[c class] alloc] initWithDictionary:d];
    if(file != nil) {
      [list addObject:file];
    }
  }
  return list;
}



@end
