//
//  STFilterFormat.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STFilterFormat.h"
#import "STConstants.h"

@implementation STFilterFormat


NSString* const InvalidFilterExceptionMessage = @"The filter value is invalid.  Please use a comma-separated list of values and/or ranges (e.g. 1, 2-5)";

@synthesize Prefix = _Prefix;
@synthesize Enabled = _Enabled;
@synthesize Type = _Type;
@synthesize Value = _Value;

/**
 The prefix is used when generating the filter out to a tag, so we can have multiple filters in a single tag that are uniquely identified.
*/
-(instancetype)init
{
  self = [super init];
  return self;
}
-(instancetype)initWithPrefix:(NSString*) prefix
{
  self = [super init];
  if(self)
  {
    [self setPrefix:prefix ];
    [self setType: @""];
    [self setValue: @""];
  }
  return self;
}


//MARK: equality
- (NSUInteger)hash {

  NSUInteger hashCode = (_Prefix != nil ? [_Prefix hash] : 0);
  hashCode = (hashCode*397) ^ _Type.hash;
  hashCode = (hashCode*397) ^ _Value.hash;
  hashCode = (hashCode*397) ^ _Enabled;
  
  return (NSUInteger)(hashCode);

}


- (BOOL)isEqual:(id)object
{
  if(object == nil)
  {
    return NO;
  }
  if (![object isKindOfClass:self.class]) {
    return NO;
  }
  
  if([self hash] == [object hash])
  {
    return YES;
    
//    return other.Prefix.Equals(this.Prefix)
//    && other.Enabled == this.Enabled
//    && other.Type.Equals(this.Type)
//    && other.Value.Equals(this.Value);
    
  }
  return NO;
}

- (NSString*)ToString {
  return [self description];
}


-(NSInteger)GetValueFromString:(NSString*)value
{
  NSInteger numericValue = 0;
  numericValue = [value intValue];
  //go back and review ways to improve this
  //http://stackoverflow.com/questions/6091414/finding-out-whether-a-string-is-numeric-or-not

  //NSScanner *scanner = [NSScanner scannerWithString:testString];
  //BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];

  if (numericValue < 1)
  {
    [NSException raise:InvalidFilterExceptionMessage format:@"%@", InvalidFilterExceptionMessage];
  }

  // Convert to 0-based index
  return (numericValue - 1);
}

/**
 Expand the value string into an array of index values.
 The value string will be expressed as 1-based indices, and this will convert them to a unique, sorted list of 0-based indices.
 */
-(NSArray<NSNumber*>*)ExpandValue
{
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if([[[self Value] stringByTrimmingCharactersInSet:ws] length] <= 0) {
    return nil;
  }
  
//  NSRange r = [[self Value] rangeOfCharacterFromSet:ws];
//  if (r.location != NSNotFound) {
//    return nil;
//  }
  
  NSArray<NSString*>* components = [[self Value] componentsSeparatedByString:[STConstantsReservedCharacters ListDelimiter]];

  if([components count] == 0)
  {
    return nil;
  }
  
  //NSMutableSet<NSNumber*>* valueList = [[NSMutableSet<NSNumber*> alloc] init];
  NSMutableArray<NSNumber*>* valueList = [[NSMutableArray<NSNumber*> alloc] init];
  
  for(NSString* component in components)
  {
    NSInteger value = 0;
    #pragma unused(value)

    NSArray<NSString*>* values = [component componentsSeparatedByString:[STConstantsReservedCharacters RangeDelimiter]];
    switch([values count])
    {
      case 1:
        [valueList addObject:[NSNumber numberWithInteger:[self GetValueFromString:(values[0])]]];
        break;
      case 2:
        {
          NSInteger rangeStartValue = [self GetValueFromString:(values[0])];
          NSInteger rangeEndValue = [self GetValueFromString:(values[1])];
          // We'll assume at some point somebody will put stuff in the wrong order, so we'll make sure
          // to flip it if that's the case instead of throwing an exception.
          NSInteger rangeStart = MIN(rangeStartValue, rangeEndValue);
          NSInteger rangeEnd = MAX(rangeStartValue, rangeEndValue);
          for (NSInteger index = rangeStart; index <= rangeEnd; index++)
          {
            [valueList addObject:[NSNumber numberWithInteger:index]];
          }
        }
        break;
      default:
        [NSException raise:InvalidFilterExceptionMessage format:@"%@", InvalidFilterExceptionMessage];
    }

  }
  
  //why don't we just use NSSet? - electing NOT to do this in case we change how this works later
  valueList = [[valueList valueForKeyPath:@"@distinctUnionOfObjects.self"] mutableCopy];
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: @"self" ascending: YES];
  [valueList sortUsingDescriptors: @[sort]];
  
  return valueList;
  //return [valueList array];
}


//MARK: Copy
-(id)copyWithZone:(NSZone *)zone
{
  STFilterFormat *format = [[[self class] allocWithZone:zone] init];
  
  format.Prefix = [_Prefix copy];
  format.Enabled = _Enabled;
  format.Type = [_Type copy];
  format.Value = [_Value copy];
  
  return format;
}

//MARK: JSON
//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setValue:[self Prefix]  forKey:@"Prefix"];
  [dict setValue:[NSNumber numberWithInteger:[self Enabled]]  forKey:@"Enabled"];
  [dict setValue:[self Type]  forKey:@"Type"];
  [dict setValue:[self Value]  forKey:@"Value"];
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    [self setValue:[dict valueForKey:key] forKey:key];
  }
}

-(NSString*)Serialize:(NSError**)outError
{
  return [STJSONUtility SerializeObject:self error:nil];
}

+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
  return [STJSONUtility SerializeList:list error:nil];
}

+(NSArray<STFilterFormat*>*)DeserializeList:(NSString*)List error:(NSError**)outError
{
  NSMutableArray<STFilterFormat*>* ar = [[NSMutableArray<STFilterFormat*> alloc] init];
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
    if(dict != nil  && ![dict isKindOfClass:[[NSNull null] class]])
    {
      [self setWithDictionary:dict];
    }
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
