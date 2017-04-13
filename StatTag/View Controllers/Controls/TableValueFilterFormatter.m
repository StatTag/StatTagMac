//
//  TableValueFilterFormatter.m
//  StatTag
//
//  Created by Eric Whitley on 12/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TableValueFilterFormatter.h"

@implementation TableValueFilterFormatter {
  NSRegularExpression* _finalValueRegex;
  NSRegularExpression* _allowedCharsRegex;
  NSError* _invalidEntryError;
}

-(id)init {
  if(self = [super init]){
    [self configure];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self configure];
  }
  return self;
}

-(void)configure
{
  NSDictionary *errorInfo = @{
                             NSLocalizedDescriptionKey: NSLocalizedString(@"Text not allowed", nil),
                             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Invalid data entry", nil),
                             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Enter the values or ranges to exclude, separated by commas: (e.g. 1, 3, 8-10)", nil)};

  //FIXME: need error domain
  _invalidEntryError = [NSError errorWithDomain:@"FIXME" code:-1 userInfo:errorInfo];
  
  NSError* err;
  //_allowedCharsRegex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9\\s,-]*" options:NSRegularExpressionCaseInsensitive error:&err];
  _allowedCharsRegex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9\\s-,]+" options:NSRegularExpressionCaseInsensitive error:&err];
  _finalValueRegex = [NSRegularExpression regularExpressionWithPattern:@"^(?:\\d+)(?:\\s*-\\s*(?:\\d+))?(?:\\s*,\\s*(?:\\d+)(?:\\s*-\\s*(?:\\d+))?)*\\s*$" options:NSRegularExpressionCaseInsensitive error:&err];
}

-(NSString*)stringForObjectValue:(id)object {
  NSString *stringValue = nil;
  if ([object isKindOfClass:[NSString class]]) {
    stringValue = [NSString stringWithString:object];
  }
  return stringValue;
}

//final validation
//http://www.cocoabuilder.com/archive/cocoa/123473-final-string-validation-in-custom-nsformatter.html
//http://www.cocoabuilder.com/archive/cocoa/217697-using-control-didfailtoformatstring-errordescription.html
//http://stackoverflow.com/questions/19377563/nstextfield-with-nsformatter-results-in-broken-continuous-binding?rq=1
- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error {

  // full match - can't use this because typing isn't complete...
  //  ^(?:\d+)(?:\s*-\s*(?:\d+))?(?:\s*,\s*(?:\d+)(?:\s*-\s*(?:\d+))?)*\s*$

  BOOL valid = YES;
  *object = [NSString stringWithString:string];

  if(_finalValueRegex != nil && [string length] > 0)
  {
    NSRange firstMatch = [_finalValueRegex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if(firstMatch.location == NSNotFound)
    {
      if(_invalidEntryError != nil)
      {
        if(error)
        {
          *error = [_invalidEntryError localizedRecoverySuggestion];
        }
      }
      valid = NO;
    }
  }
  
  return valid;
}

//continuous validation - filter disallowed characters
// we don't directly show an error mesage here - our delegate handles it
- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString **)error {
  
  if(_allowedCharsRegex != nil)
  {
    NSRange firstMatch = [_allowedCharsRegex rangeOfFirstMatchInString:*partialStringPtr options:0 range:NSMakeRange(0, [*partialStringPtr length])];
    
    if(firstMatch.location != NSNotFound)
    {
      NSString* foundModel = [*partialStringPtr substringWithRange:firstMatch];
      //NSLog(@"found : '%@'", foundModel);
      
      if(_invalidEntryError != nil)
      {
        *error = [_invalidEntryError localizedRecoverySuggestion];
      }
      return NO;
    }
  }
  return YES;
}




@end
