//
//  IntegerOnlyNumberFormatter.m
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

//StackOverflow: http://stackoverflow.com/questions/4652689/restrict-nstextfield-input-to-numeric-only-nsnumberformatter

#import "IntegerOnlyNumberFormatter.h"

@implementation IntegerOnlyNumberFormatter

-(BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing  _Nullable *)newString errorDescription:(NSString *__autoreleasing  _Nullable *)error {

  if (newString) { *newString = nil;}
  if (error)     {*error = nil;}
  
  static NSCharacterSet *nonDecimalCharacters = nil;
  if (nonDecimalCharacters == nil) {
    nonDecimalCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet] ;
  }
  
  if ([partialString length] == 0) {
    return YES; // The empty string is okay (the user might just be deleting everything and starting over)
  } else if ([partialString rangeOfCharacterFromSet:nonDecimalCharacters].location != NSNotFound) {
    return NO; // Non-decimal characters aren't cool!
  }
  
  return YES;
}

@end
