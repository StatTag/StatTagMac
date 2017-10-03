//
//  STStataParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STStataParser.h"
#import "STCocoaUtil.h"
#import "STCodeParserUtil.h"


@implementation STStataParserLog

@synthesize LogType = _LogType;
@synthesize LogPath = _LogPath;
@synthesize LiteralLogEntry = _LiteralLogEntry;
@end

@implementation STStataCommentBlock
  @synthesize Start = _Start;
  @synthesize End = _End;
  @synthesize IsNested = _IsNested;
@end

@implementation STStataParser

NSString* const macroChars = @"`'";
NSString* const calcChars = @"*/-+";
NSString* const CommentStart = @"/*";
NSString* const CommendEnd = @"*/";

+(NSCharacterSet*)MacroDelimiters {
  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:macroChars];
  return chars;
}
+(NSCharacterSet*)CalculationOperators {
  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:calcChars];
  return chars;
}

+(NSArray<NSString*>*)MacroDelimitersCharacters {
  return [STCocoaUtil splitStringIntoArray:macroChars];
}
+(NSArray<NSString*>*)CalculationOperatorsCharacters {
  return [STCocoaUtil splitStringIntoArray:calcChars];
}

//MARK: Value regex
+(NSArray<NSString*>*)ValueCommands {
  return [NSArray<NSString*> arrayWithObjects:@"display", @"dis", @"di", nil];
}
+(NSRegularExpression*)ValueKeywordRegex {
  NSError* error;
  NSRegularExpression* regex = [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*(?:%@)\\b", [[[self class] ValueCommands] componentsJoinedByString:@"|"]]
          options:0
          error:&error];
  if(error){
    //NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    //NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommands]);
  }
  return regex;
}
+(NSRegularExpression*)ValueRegex {
  NSError* error;
  
  //original c# value regex template (won't work in obj-c as we don't have the ? if/then/else conditional
  //NSString* valueRegexTemplate = @"^\\s*%@((\\s*\\()|(\\s+))(.*)(?(2)\\))";
  //^\\s*(?:{0})((\\s*\\()|(\\s+))(.*)(?(2)\\))

  NSString* valueRegexTemplate = @"^\\s*(?:%@)\\s*(((?:\\()(.*)(?:\\)\\s*$)+)|((\\()?(.*)))";
  
  NSRegularExpression* regex =  [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:valueRegexTemplate, [[[self class] ValueCommands] componentsJoinedByString:@"|"]]
          options:0
          error:&error];
  if(error){
    //NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    //NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommands]);
  }
  return regex;
}
//MARK: Graph regex
+(NSArray<NSString*>*)GraphCommands {
  return [NSArray<NSString*> arrayWithObjects:@"gr(?:aph)? export", nil];
}
+(NSRegularExpression*)GraphKeywordRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b", [[[[self class] GraphCommands] componentsJoinedByString:@"|"]stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
                                                          options:0
                                                            error:&error];
  if(error){
    //NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    //NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommands]);
  }
  return regex;
}
+(NSRegularExpression*)GraphRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\s+\\\"?([^\\\",]*)[\\\",]?", [[[[self class] GraphCommands]componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:0
          error:&error];
  if(error){
    //NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    //NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommands]);
  }
  return regex;
}

//MARK: Table regex
+(NSArray<NSString*>*)TableCommands {
  return [NSArray<NSString*> arrayWithObjects:@"mat(?:rix)? l(?:ist)?", nil];
}
+(NSRegularExpression*)TableKeywordRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b", [[[[self class] TableCommands]componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:0
          error:nil];
}
+(NSRegularExpression*)TableRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\s+([^,]*?)(?:\\r|\\n|$)", [[[[self class] TableCommands]componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:0
          error:nil];
}

//MARK: additional regex properties
+(NSRegularExpression*)LogKeywordRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:@"^\\s*((?:cmd)?log)\\s*using\\b"
          options:NSRegularExpressionAnchorsMatchLines //should match c# RegexOptions.Multiline
          error:nil];
  // static Regex LogKeywordRegex = new Regex("^\\s*((?:cmd)?log)\\s*using\\b", RegexOptions.Multiline);
}
//
//+(NSArray<NSRegularExpression*>*)MultiLineIndicators {
//  
//  return [NSArray<NSRegularExpression*> arrayWithObjects:
//          [NSRegularExpression
//           regularExpressionWithPattern:@"[/]{3,}.*\\s*"
//           options:0//NSRegularExpressionAnchorsMatchLines //should match c# RegexOptions.Multiline
//           error:nil],
//          [NSRegularExpression
//           regularExpressionWithPattern:@"/\\*.*\\*/\\s?"
//           options:NSRegularExpressionDotMatchesLineSeparators //default options should be single line?
//           error:nil]
//          , nil];
//  
//}

+(NSRegularExpression*)MultiLineIndicator {
  return [NSRegularExpression
          regularExpressionWithPattern:@"[/]{3,}.*\\s*"
          options:0 //should match c# RegexOptions.Multiline
          error:nil];
}

+(NSRegularExpression*)MacroRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:@"`([\\S]*?)'"
          options:NSRegularExpressionAnchorsMatchLines
          error:nil];
}


/**
This is used to test/extract a macro display value.
@remark It assumes the rest of the display command has been extracted, and only the value name remains.
*/
+(NSRegularExpression*)MacroValueRegex {
  return [NSRegularExpression
   regularExpressionWithPattern:@"^\\s*`(.+)'"
   options:0
   error:nil];
}

/// <summary>
/// Determine if a string represents a numeric constant.  Used when testing display
/// value results to determine appropriate processing.
/// <remarks>It assumes the rest of the display command has been extracted,
/// and only the value name remains.</remarks>
/// </summary>
+(NSRegularExpression*)NumericConstantRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:@"^(\\d*)(\\.)?(\\d+)?(e-?(0|[1-9]\\d*))?$"
          options:0 //should match c# RegexOptions.Multiline
          error:nil];
}

-(NSString*)CommentCharacter {
  return [STConstantsCodeFileComment Stata];
}


//MARK: regex helper methods - MOVE THESE

//FIXME: Move this somewhere else - this is general regex functionality
//+(BOOL)regexIsMatch:(NSRegularExpression*)regex inString:(NSString*)string {
//  NSRange textRange = NSMakeRange(0, string.length);
//  //NSMatchingReportProgress
//  NSRange matchRange = [regex rangeOfFirstMatchInString:string options:0 range:textRange];
//  
//  if (matchRange.location != NSNotFound)
//    return true;
//  
//  return false;
//}


//MARK: regex override methods


/**
 Determine if a command is for exporting an image
 */
-(BOOL) IsImageExport:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] GraphKeywordRegex] inString:command];
}

/**
 Determine if a command is for displaying a result
 */
-(BOOL) IsValueDisplay:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] ValueKeywordRegex] inString:command];
}

/**
 Determine if a display value is a macro type.
 
 @remark Assumes that you have already verified the command contains a display value.
 */
-(BOOL) IsMacroDisplayValue:(NSString*)command
{
  NSString* value = [self GetValueName:command];
  return [[self class] regexIsMatch:[[self class] MacroValueRegex] inString:value];
  //return MacroValueRegex.IsMatch(value);
}

/**
 Determine if a command is starting a log in the Stata session
 
 @returns true if it is starting a log, false otherwise
 */
-(BOOL) IsStartingLog:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] LogKeywordRegex] inString:command];
}

/**
 Determine if a command is for displaying a result
 
 @returns A string describing the type of log (log or cmdlog), or a blank string if this is not a logging command
 */
-(NSArray<NSString*>*) GetLogType:(NSString*)command
{
  return [self GlobalMatchRegexReturnGroup:command regex:[[self class] LogKeywordRegex] groupNum:1];
}

-(NSArray<NSString*>*) GetLogFile:(NSString*)command
{
  return [self GlobalMatchRegexReturnGroup:command regex:[[self class] LogKeywordRegex] groupNum:2];
}

-(NSArray<STStataParserLog*>*)GetLogs:(NSString*)command
{
  NSMutableArray<STStataParserLog*>* logs = [[NSMutableArray<STStataParserLog*> alloc] init];
  NSArray* textMatches = [[[self class] LogKeywordRegex] matchesInString:command options:0 range:NSMakeRange(0, command.length)];
  
  if ([textMatches count] == 0)
  {
    return nil;
  }

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  //NSMutableArray<NSString*>* matches = [[NSMutableArray<NSString*> alloc] init];
  if ([textMatches count] > 0)
  {
    for (int index = 0; index < [textMatches count]; index++)
    {
      //macroNames.Add(matches[index].Groups[1].Value);
      STStataParserLog* spl = [[STStataParserLog alloc] init];
      [spl setLogType: [[command substringWithRange:[[textMatches objectAtIndex:index] rangeAtIndex:1]] stringByTrimmingCharactersInSet:ws]];
      NSString* logPath = [command substringWithRange:[[textMatches objectAtIndex:index] rangeAtIndex:2]];
      logPath = [[logPath stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByTrimmingCharactersInSet:ws];
      
      [spl setLiteralLogEntry: [command substringWithRange:[[textMatches objectAtIndex:index] rangeAtIndex:2]]];
    }
  }

  
  return logs;

   /*
   matches.OfType<Match>().Select(match => new Log()
                             {
                               LogType = match.Groups[1].Value.Trim(),
                               LogPath = match.Groups[2].Value.Replace("\"", "").Trim(),
                               LiteralLogEntry = match.Groups[2].Value
                             }).ToArray();
    */
}

/**
 Returns the file path where an image exported from the statistical package
 is being saved.
 
 @remark Assumes that you have verified this is an image export command
 using IsImageExport first
 */
-(NSString*) GetImageSaveLocation:(NSString*)command
{
//  command = [command string]
  return [self MatchRegexReturnGroup:command regex:[[self class] GraphRegex] groupNum:1];
}

/**
 Returns the name of the variable/scalar to display.
 
 @remark Assumes that you have verified this is a display command using
 IsValueDisplay first.
 */
-(NSString*) GetValueName:(NSString*)command
{
  //NOTE: different for the objective-c version because we don't support conditional if-then-else regex
  // we have do do this by using a different regex and looping through matches because we don't know which group to use. "The last valid one" is what we're going to use
  
  NSTextCheckingResult* last_match = [[[[self class] ValueRegex] matchesInString:command options:0 range:NSMakeRange(0, command.length)] lastObject];

  NSString* matchString = @""; // default return is empty string in c#

  if(last_match == nil){
    return matchString;
  }
  
  if ([last_match numberOfRanges] > 0) {
    for (NSInteger j = 0; j < last_match.numberOfRanges; j++) {
      NSRange range = [last_match rangeAtIndex:j];
      if(range.location != NSNotFound) {
        NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        matchString = [[command substringWithRange:range] stringByTrimmingCharactersInSet:ws];
        ////NSLog(@"position: %d, match.range : %@, current_range: %@, command: %@, matchString: %@",j,  NSStringFromRange(last_match.range), NSStringFromRange(range), command, matchString);
      }
    }
  }
  return matchString;
}

/**
 A specialized version of GetValueName that prepares a macro display value
 for use.
 */
-(NSString*) GetMacroValueName:(NSString*)command
{
  return [[self GetValueName:command] stringByTrimmingCharactersInSet:[[self class] MacroDelimiters]];
  //return GetValueName(command).Trim(MacroDelimiters);
}


-(BOOL) IsTableResult:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] TableKeywordRegex] inString:command];
}

-(NSString*) GetTableName:(NSString*)command
{
  return [self MatchRegexReturnGroup:command regex:[[self class] TableRegex] groupNum:1];
}

-(BOOL) IsCalculatedDisplayValue:(NSString*)command
{
  if ([command length] == 0) {
    return false;
  }

  NSString* valueName = [self GetValueName:command];
  if ([valueName length] == 0) {
    return false;
  }

  if([valueName rangeOfCharacterFromSet:[[self class] CalculationOperators]].location != NSNotFound) {
    return true;
  }

  return [[self class] regexIsMatch:[[self class] NumericConstantRegex] inString:valueName];

  //return false;
}




/**
Given a command string, extract all macros that are present.  This will remove macro delimiters from the macro names returned.
*/
-(NSArray<NSString*>*)GetMacros:(NSString*)command
{
  NSMutableArray<NSString*>* macroNames = [[NSMutableArray<NSString*> alloc] init];
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  //  temp = [temp stringByTrimmingCharactersInSet: ws];

  if([[command stringByTrimmingCharactersInSet:ws] length] > 0)
  {
    NSArray *matches = [[[self class] MacroRegex] matchesInString:command options:0 range:NSMakeRange(0, command.length)];
    
    if ([matches count] > 0)
    {
      for (int index = 0; index < [matches count]; index++)
      {
        //macroNames.Add(matches[index].Groups[1].Value);
        [macroNames addObject:[command substringWithRange:[[matches objectAtIndex:index] rangeAtIndex:1]]];
      }
    }
  }
  
  return macroNames;
}

/// <summary>
/// Specialized "IndexOfAny" that accepts strings (in this case - our comment
/// start and end values).
/// </summary>
/// <param name="text"></param>
/// <param name="startIndex"></param>
/// <returns></returns>
-(long) IndexOfAnyCommentChar:(NSString*) text startIndex:(long) startIndex
{
//  int nextStart = text.IndexOf(CommentStart, startIndex, StringComparison.CurrentCulture);
  NSRange textRange = NSMakeRange(startIndex, ([text length] - startIndex));
  long nextStart = [text rangeOfString:CommentStart options:NSCaseInsensitiveSearch range:textRange].location;
//  int nextEnd = text.IndexOf(CommentEnd, startIndex, StringComparison.CurrentCulture);
  long nextEnd = [text rangeOfString:CommendEnd options:NSCaseInsensitiveSearch range:textRange].location;
  if (nextStart == NSNotFound && nextEnd == NSNotFound)
  {
    return NSNotFound;
  }
  else if (nextStart == NSNotFound)
  {
    return nextEnd;
  }
  else if (nextEnd == NSNotFound)
  {
    return nextStart;
  }

  return MIN(nextStart, nextEnd);
}

/// <summary>
/// Utility method to take a string of Stata code and remove all of the comment blocks that use
/// /* */ syntax.  This is needed because a regex-based solution did not seem feasible (or advised)
/// given the type of parsing this requires.
/// </summary>
/// <param name="text">The original Stata code</param>
/// <returns>The modified Stata code with all /* */ comments removed </returns>
-(NSString*) RemoveNestedComments:(NSString*) text
{
  // Go through the string, finding any comment starts.  Those get pushed onto a
  // stack, and we keep looking for ending pairs.  When that's all done we will
  // reconcile and pull out the comment blocks.
  long startIndex = [text rangeOfString:CommentStart].location;
  if (startIndex == NSNotFound)
  {
    return text;
  }

  NSMutableArray<NSNumber*>* startIndices = [[NSMutableArray<NSNumber*> alloc] init];
  [startIndices addObject:[NSNumber numberWithLong:startIndex]];
  NSMutableArray<STStataCommentBlock*>* commentBlocks = [[NSMutableArray<STStataCommentBlock*> alloc] init];
  long nextIndex = [self IndexOfAnyCommentChar:text startIndex:(startIndex + 1)];
  while (nextIndex != NSNotFound)
  {
    long findPosition = [text rangeOfString:CommentStart options:NSCaseInsensitiveSearch range:NSMakeRange(nextIndex, ([text length] - nextIndex))].location;
    if (findPosition == nextIndex)
    {
      // We have another comment starting
      [startIndices addObject:[NSNumber numberWithLong:nextIndex]];
    }
    else
    {
      // We found the end of the current comment block.  We add 1 to the nextIndex (as the end index)
      // to capture the "/" character (since our find just gets "*" from "*/").
      STStataCommentBlock* block = [[STStataCommentBlock alloc] init];
      bool isNested = ([startIndices count] > 1);
      NSNumber* lastIndex = [startIndices lastObject]; [startIndices removeLastObject];   // pop
      block.Start = [lastIndex longValue];
      block.End = (nextIndex + 1);
      block.IsNested = isNested ? YES : NO;
      [commentBlocks addObject:block];
    }

    nextIndex = [self IndexOfAnyCommentChar:text startIndex:(nextIndex + 1)];
  }

  // If we get a block of code that has unmatched nested comments, we are going to ignore it
  // and return the original text.  Most likely the code will fail in Stata anyway so we are
  // going to pass it to the API as-is.
  if ([startIndices count] != 0)
  {
    return text;
  }


//  commentBlocks.Sort(delegate(Tuple<int, int, bool> x, Tuple<int, int, bool> y)
//                     {
//                       if (x == null && y == null) { return 0; }
//                       if (x == null) { return 1; }
//                       if (y == null) { return -1; }
//                       return y.Item1.CompareTo(x.Item1);
//                     });

  // Sort the comment blocks by the starting index (descending order).  That way we can remove comment blocks
  // starting at the end and not have to worry about updating string indices.
  NSArray<STStataCommentBlock*> *sortedCommentBlocks;
  sortedCommentBlocks = [commentBlocks sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    STStataCommentBlock *first = (STStataCommentBlock*)a;
    STStataCommentBlock *second = (STStataCommentBlock*)b;
    if (first == nil && second == nil) { return NSOrderedSame; }
    if (first == nil) { return NSOrderedDescending; }
    if (second == nil) { return NSOrderedAscending; }
    return [[[NSNumber alloc] initWithLong:second.Start] compare: [[NSNumber alloc] initWithLong:first.Start]];
  }];

  // Finally, loop through the comment blocks and apply them by removing the commented text.  This makes
  // the assumption sortedCommentBlocks is sorted in descending order, so we can just remove text and not need
  // to worry about adjusting indices.
  for (int index = 0; index < [sortedCommentBlocks count]; index++)
  {
    // Our commentBlocks contains all unique comment locations.  Some locations many be nested inside
    // other comments (not sure why you would, but it could happen!)  We will check to see if we have
    // some type of inner comment and skip it if that's the case, since the outer one will remove it.
    if (sortedCommentBlocks[index].IsNested)
    {
      continue;
    }

    long length = sortedCommentBlocks[index].End - sortedCommentBlocks[index].Start + 1;
    text = [text stringByReplacingCharactersInRange:NSMakeRange(sortedCommentBlocks[index].Start, length) withString:@""];
  }

  return text;
}

/**
 To prepare for use, we need to collapse down some of the text.  This includes:
  - Collapsing commands that span multiple lines into a single line
*/
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*)originalContent
{
  if (originalContent == nil || [originalContent count] == 0)
  {
    return [[NSArray<NSString*> alloc] init];
  }

  NSString* originalText = [originalContent componentsJoinedByString:@"\r\n"];
  //because we're not able to explicitly create a stata session (and then close it) per batch of commands, we must (should) first clear the command list before running. This will get rid of any of the existing data that we might have. We want to do this because Stata will complain about "changed" data (and refuse to change it) if we redefine any of the data sets or related variables within the code file between executions.
  NSString* modifiedText = [@"clear all\r\n" stringByAppendingString:originalText];

//  for(NSRegularExpression* regex in [[self class]MultiLineIndicators])
//  {
//    modifiedText = [regex stringByReplacingMatchesInString:modifiedText options:0 range:NSMakeRange(0, modifiedText.length) withTemplate:@" "];
//  }
  modifiedText = [[[self class]MultiLineIndicator] stringByReplacingMatchesInString:modifiedText options:0 range:NSMakeRange(0, modifiedText.length) withTemplate:@" "];

  // Why are we stripping out trailing lines?  There is apparently an issue with the Stata
  // Automation API where having a trailing comment on a valid line causes that command to
  // fail (e.g., "sysuse(bpwide)  //comment").  Our workaround is to strip those comments
  // to users don't have to modify their code.  The issue has been reported to Stata.
  modifiedText = [STCodeParserUtil StripTrailingComments:modifiedText];
  modifiedText = [self RemoveNestedComments:modifiedText];
  modifiedText = [modifiedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  return [modifiedText componentsSeparatedByString:@"\r\n"];
}

// Perform a check to see if a command contains a saved result embedded within it.  These
// are represented as commands that Stata executes, as opposed to being named values.
-(BOOL) IsSavedResultCommand:(NSString*)command
{
  // Note that Stata is case-sensitive for these commands.
  return [command containsString:@"c("]
    || [command containsString:@"r("]
    || [command containsString:@"e("];
}

@end
