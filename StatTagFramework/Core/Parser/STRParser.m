//
//  STStataParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STRParser.h"
#import "STCodeParserUtil.h"

@implementation STRParserFunctionParam

@synthesize Index = _Index;
@synthesize Key = _Key;
@synthesize Value = _Value;

@end

@implementation STRParser

//MARK: Value regex
+(NSArray<NSString*>*)FigureCommands {
  return [NSArray<NSString*> arrayWithObjects:@"pdf", @"win.metafile", @"png", @"jpeg", @"bmp", @"postscript", nil];
}

+(NSRegularExpression*)FigureRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
                                  regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*(?:%@)\\s*\\((\\s*?[\\s\\S]*)\\)", [[[self class] FigureCommands]componentsJoinedByString:@"|"]]
                                  options:0
                                  error:&error];
  if(error){
    //NSLog(@"R - FigureRexec : %@", [error localizedDescription]);
    //NSLog(@"R - [[self class] FigureCommand] : %@", [[self class] FigureCommands]);
  }
  return regex;
}

+(NSRegularExpression*)FigureParameterRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
                                  regularExpressionWithPattern:@"(?:([\\w]*?)\\s*=\\s*)?(?:([\\w]+\\s*\\(.+\\))|([^\\(\\)]+?))(?:,|$)\\s*"
                                  options:NSRegularExpressionDotMatchesLineSeparators
                                  error:&error];
  if(error){
    //NSLog(@"R - FigureParameterRegex : %@", [error localizedDescription]);
    //NSLog(@"R - [[self class] FigureCommand] : %@", [[self class] FigureCommands]);
  }
  return regex;
}


unichar const KeyValueDelimiter = '=';
unichar const ArgumentDelimiter = ',';
unichar const CommandDelimiter = ';';
NSString* const FileParameterName = @"filename";

-(NSMutableArray<STRParserFunctionParam*>*) ParseFunctionParameters:(NSString*) arguments
{
  // Move along the sequence of characters until we reach a delimiter (",") or the end of the string
  int parameterIndex = 0;
  bool isInQuote = FALSE;
  int functionCounter = 0;
  bool isInFunction = FALSE;
  int parameterStartIndex = 0;
  int parameterNameDelimiterIndex = -1;
  int doubleQuoteCounter = 0;
  int singleQuoteCounter = 0;
  bool isNamedParameter = false;
  //bool noState = true;  // Set at the beginning, just to track we haven't done any other tracking
  NSMutableArray<STRParserFunctionParam*>* parameters = [[NSMutableArray<STRParserFunctionParam*> alloc] init];

  NSUInteger stringLength = [arguments length];
  unichar buffer[stringLength+1];
  [arguments getCharacters:buffer range:NSMakeRange(0, stringLength)];
  for (int index = 0; index < stringLength; index++) {
    //NSLog(@"%C", buffer[i]);
    unichar argChar = buffer[index];
    if (argChar == '\'') {
      isInQuote = TRUE;
      singleQuoteCounter++;
      if (singleQuoteCounter %2 == 0) {
        // We have closed out of the single quote.  If we are not also in a double
        // quote sentence, we can reset our quote tracker.
        if (doubleQuoteCounter == 0) {
          isInQuote = FALSE;
        }
      }
    }
    else if (argChar == '"') {
      isInQuote = TRUE;
      doubleQuoteCounter++;
      if (doubleQuoteCounter %2 == 0) {
        // We have closed out of the double quote.  If we are not also in a single
        // quote sentence, we can reset our quote tracker.
        if (singleQuoteCounter == 0) {
          isInQuote = FALSE;
        }
      }
    }
    else if (argChar == '(') {
      functionCounter++;
      isInFunction = true;
    }
    else if (isInFunction && argChar == ')') {
      functionCounter--;
      isInFunction = (functionCounter != 0);
    }

    // If we are in a quote or in a function, we are not going to allow processing other characters
    // (since they should be treated as literal characters).
    if (isInQuote) {
      continue;
    }

    if (argChar == KeyValueDelimiter && !isInFunction) {
      isNamedParameter = true;
      parameterNameDelimiterIndex = index;
    }
    // Don't allow the argument delimiter to be processed if we are in the middle of a function, since
    // we want to keep that function in its entirety as a parameter for the image command.
    else if (((!isInFunction) && argChar == ArgumentDelimiter) || argChar == CommandDelimiter || index == (stringLength - 1)) {
      int valueEndIndex = (index == (stringLength - 1)) ? stringLength : index;
      int valueStartIndex = (isNamedParameter ? (parameterNameDelimiterIndex + 1) : parameterStartIndex);

      // We're at an ending sequence, and we need to close out what we've been tracking.
      STRParserFunctionParam* param = [[STRParserFunctionParam alloc] init];
      param.Index = parameterIndex;

      NSRange range = NSMakeRange(parameterStartIndex, (parameterNameDelimiterIndex - parameterStartIndex));
      param.Key = (isNamedParameter ? [arguments substringWithRange:range] : @"");
      param.Key = [param.Key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

      range = NSMakeRange(valueStartIndex, valueEndIndex - valueStartIndex);
      param.Value = [arguments substringWithRange:range];
      param.Value = [param.Value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

      [parameters addObject:param];

      // Reset our state, since we are going to begin on a new parameter (or be done)
      isNamedParameter = false;
      doubleQuoteCounter = 0;
      singleQuoteCounter = 0;
      parameterStartIndex = index + 1;
      parameterNameDelimiterIndex = -1;
      parameterIndex++;
    }
  }

  return parameters;
}

/**
This will return the exact parameter that represents the image save location.  This may be an R function (e.g., paste) to construct the file path, a variable, or a string literal.  String literals will include enclosing quotes.  This is because the output of this method is sent to R as an expression for evaluation.  That way R handles converting everything into an exact file path that we can then utilize.
*/
-(NSString*)GetImageSaveLocation:(NSString*)command
{
  // In order to account for a command string that actually has multiple commands embedded in it,
  // we want to find the right fragment that has the image command.  We will take the first one
  // we find.
  NSArray *match = nil;
  NSArray<NSString*>* commandLines = [command componentsSeparatedByString:[NSString stringWithFormat: @"%C", CommandDelimiter]];
  for (int index = 0; index < [commandLines count]; index++) {
    NSString* commandLine = commandLines[index];
    match = [[[self class] FigureRegex] matchesInString:commandLines[index]
                                                options:0
                                                  range:NSMakeRange(0, [commandLine length])];
    if ([match count] > 0 && ([[match firstObject] numberOfRanges] > 0)) {
      break;
    }
  }

  if([match count] == 0)
  {
    return @"";
  }
  if([[match firstObject] numberOfRanges] == 0)
  {
    return @"";
  }

  NSRange matchRange = [[match firstObject] rangeAtIndex:1];
  NSString* arguments = [command substringWithRange:matchRange];
  NSMutableArray<STRParserFunctionParam*>* parameters = [self ParseFunctionParameters:arguments];
  

//  NSArray *matches = [[[self class] FigureParameterRegex] matchesInString:arguments
//                                                       options:0
//                                                         range:NSMakeRange(0, [arguments length])];
//  if([matches count] == 0)
//  {
//    return @"";
//  }
//  NSRange matchRange = [[match firstObject] rangeAtIndex:1];
//  NSString* arguments = [command substringWithRange:matchRange];

//  NSMutableArray<STRParserFunctionParam*>* parameters = [[NSMutableArray<STRParserFunctionParam*> alloc] init];
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//
//  for (NSInteger index = 0; index < [matches count]; index++)
//  {
//    NSTextCheckingResult* tc = [matches objectAtIndex:index];
//    //we can't continue if we don't have 3 - we'll explode
//    if([tc numberOfRanges] < 3)
//    {
//      continue;
//    }
//
//    NSString* t1 = @"";
//    NSString* t2 = @"";
//    NSString* t3 = @"";
//    NSRange m1 = [tc rangeAtIndex:1];
//      if (m1.length > 0) {
//          t1 = [arguments substringWithRange:m1];
//      }
//
//    NSRange m2 = [tc rangeAtIndex:2];
//      if (m2.length > 0) {
//          t2 = [arguments substringWithRange:m2];
//      }
//
//    NSRange m3 = [tc rangeAtIndex:3];
//      if (m3.length > 0) {
//          t3 = [arguments substringWithRange:m3];
//      }
//
//    STRParserFunctionParam* fp = [[STRParserFunctionParam alloc] init];
//    [fp setIndex:index];
//    [fp setKey:t1];
//    [fp setValue:([[t2 stringByTrimmingCharactersInSet:ws] length] > 0 ? t2 : t3)];
//
//    [parameters addObject:fp];
//  }

  // Follow R's approach to argument matching (http://adv-r.had.co.nz/Functions.html#function-arguments)
  
  STRParserFunctionParam* matchingArg;
  for(STRParserFunctionParam* p in parameters)
  {
    if([p.Key caseInsensitiveCompare:FileParameterName] == NSOrderedSame)
    {
      // First, look for exact name (perfect matching)
      matchingArg = p;
      return [p Value];
      break;
    } else if ([[[p Key] stringByTrimmingCharactersInSet:ws] length] > 0 && [FileParameterName hasPrefix:[p.Key lowercaseString]]) {
      // Next look by prefix matching
      matchingArg = p;
      return [p Value];
      break;
    }
  }
  if (matchingArg != nil)
  {
    return [matchingArg Value];
  }
  
  NSArray<STRParserFunctionParam*>* sortedArray;
  // Finally, look for the first unnamed argument.
  sortedArray = [parameters filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(STRParserFunctionParam* p, NSDictionary *bindings) {
    return [[[p Key] stringByTrimmingCharactersInSet:ws] length] == 0;
  }]];

  sortedArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(STRParserFunctionParam* a, STRParserFunctionParam* b) {
    NSNumber* first = [NSNumber numberWithInteger:[a Index]];
    NSNumber* second = [NSNumber numberWithInteger:[b Index]];
    return [first compare:second];
  }];
  
  STRParserFunctionParam* firstUnnamed = [sortedArray firstObject];
  return firstUnnamed == nil ? @"" : [firstUnnamed Value];
  
  //var filteredParameters = parameters.Where(x => string.IsNullOrWhiteSpace(x.Key)).OrderBy(x => x.Index);
  //var firstUnnamed = filteredParameters.FirstOrDefault();
  //return (firstUnnamed == null) ? string.Empty : firstUnnamed.Value;
}

-(NSString*)CommentCharacter {
  return [STConstantsCodeFileComment R];
}

//MARK: regex override methods

/**
 Determine if a command is for exporting an image
 */
-(BOOL) IsImageExport:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] FigureRegex] inString:command];
}

/**
 Determine if a command is for displaying a result
 */
-(BOOL) IsValueDisplay:(NSString*)command
{
  return YES;
}


/**
 Returns the name of the variable/scalar to display.
 
 @remark Assumes that you have verified this is a display command using
 IsValueDisplay first.
 */
-(NSString*) GetValueName:(NSString*)command
{
  return @"";
}

-(BOOL) IsTableResult:(NSString*)command
{
  return YES;
}

-(NSString*) GetTableName:(NSString*)command
{
  return @"";
}

/**
 To ensure the R API gets the full command, we need to collapse multi-line commands.
 This assumes trailing comments have been stripped already.
 
 Params:
   originalContent - an array of command lines
 Returns: An array of commands with multi-line commands on a single line.  The size
    will be <= the size of originalContent.
 */
-(NSArray<NSString*>*)CollapseMultiLineCommands:(NSArray<NSString*>*)originalContent
{
  NSString* originalText = [originalContent componentsJoinedByString:@"\r\n"];
  NSMutableString* modifiedText = originalText;
  int openCount = 0;
  int closedCount = 0;
  long currentStart = -1;
  long currentEnd = -1;

  NSMutableCharacterSet* parenChars = [[NSMutableCharacterSet alloc] init];
  [parenChars addCharactersInString:@"()"];

  // Find opening paren, if any exists.  Although this is a range, we're only giving
  // it single character values so we only ever care about the location value.
  NSRange next = [modifiedText rangeOfString:@"("];
  while (next.location != NSNotFound) {
    if ([modifiedText characterAtIndex:next.location] == '(') {
      openCount++;
      if (openCount == 1) {
        currentStart = next.location;
      }
    }
    else {
      closedCount++;
      currentEnd = next.location;
    }

    // Do we have a balanced match?  If so, we will take this range and clear out newlines
    if (openCount == closedCount) {
      openCount = 0;
      closedCount = 0;

      // Re-compose the string.  Note that we independently replace \r and \n with a space.
      // This allows us to 1) handle different line endings, and 2) preserve indices so we
      // don't have to account for shrinking strings.
      NSRange firstRange;
      firstRange.location = 0;
      firstRange.length = currentStart;
      NSRange secondRange;
      secondRange.location = currentStart;
      secondRange.length = (currentEnd - currentStart);
      modifiedText = [NSMutableString stringWithFormat:@"%@%@%@",
                      [modifiedText substringWithRange:firstRange],
                      [[[modifiedText substringWithRange:secondRange]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@" "]
                          stringByReplacingOccurrencesOfString:@"\n" withString:@" "],
                      [modifiedText substringFromIndex:currentEnd]];
    }

    // Because we're using a substring to search for the next character (is there a way
    // to search in obj-c for a character starting at an index??), if we find a match
    // we need to add back to the position the amount of the string we skipped due to
    // the substring.
    long skipAmount = (next.location + 1);
    next = [[modifiedText substringFromIndex:skipAmount] rangeOfCharacterFromSet:parenChars];
    if (next.location != NSNotFound) {
      next.location += skipAmount;
    }
  }

  return [modifiedText componentsSeparatedByString:@"\r\n"];
}

/**
 To prepare for use, we need to collapse down some of the text.  This includes:
  - Collapsing commands that span multiple lines into a single line
*/
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*)originalContent
{
  if (originalContent == nil || [originalContent count] == 0) {
    return [[NSArray<NSString*> alloc] init];
  }

  NSString* originalText = [originalContent componentsJoinedByString:@"\r\n"];
  NSMutableString* modifiedText = [STCodeParserUtil StripTrailingComments:originalText];
  // Ensure all multi-line function calls are collapsed
  return [modifiedText componentsSeparatedByString:@"\r\n"];
}


@end
