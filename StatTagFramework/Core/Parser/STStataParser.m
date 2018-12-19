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
#import "STGeneralUtil.h"


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

NSString* const startCommandSegmentChars = @" ,\"(";
NSString* const endCommandSegmentChars = @" ,\")";
NSString* const quotedSegmentChars = @"\"";
NSString* const macroChars = @"`'$";
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
+(NSCharacterSet*)StartCommandSegmentDelimiters {
  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:startCommandSegmentChars];
  return chars;
}
+(NSCharacterSet*)EndCommandSegmentDelimiters {
  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:endCommandSegmentChars];
  return chars;
}
+(NSCharacterSet*)QuotedSegmentDelimiters {
  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:quotedSegmentChars];
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
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\s+([^,]*?)(?:,|\\r|\\n|$)", [[[[self class] TableCommands]componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:0
          error:nil];
}

+(NSRegularExpression*)DataFileRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:@"[\\\\\\/]*(\\.(?:csv|txt|xlsx|xls))"
          options:NSRegularExpressionCaseInsensitive
          error:nil];
}

+(NSRegularExpression*)Table1Regex {
  return [NSRegularExpression
          regularExpressionWithPattern:@"(?:^|\\s+)table1\\s*,"
          options:0
          error:nil];
}

+(NSRegularExpression*)SetMaxvarRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:@"set\\s+maxvar\\s+[\\d]+"
          options:NSRegularExpressionCaseInsensitive
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
          regularExpressionWithPattern:@"`([\\S]*?)'|\\$([\\S]+?\\b)"
          options:NSRegularExpressionAnchorsMatchLines
          error:nil];
}


/**
This is used to test/extract a macro display value.
@remark It assumes the rest of the display command has been extracted, and only the value name remains.
*/
+(NSRegularExpression*)MacroValueRegex {
  return [NSRegularExpression
   regularExpressionWithPattern:@"^\\s*(?:`(.+)'|\\$([\\S]+))"
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

// Determine if a command references some type of table result - either froma  matrix or a data file.
-(BOOL) IsTableResult:(NSString*)command
{
  return [self IsMatrix:command] || [self CommandHasDataFileOrMacroHeuristic:command];
}

-(BOOL) HasMacroInCommand:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] MacroRegex] inString:command];
}

// Determine if a command references a matrix.
// Stata's API has special handling for accessing matrices.  To account for this, we need to detect commands
// that create/access a matrix result.  That tells the rest of the StatTag code to use the API to get results.
// This requires different handling from referencing a data file on disk.
-(BOOL) IsMatrix:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] TableKeywordRegex] inString:command];
}

// Detect if the command references the table1 package.
// This is a very specialized function - we are promoting the use of the table1 package (which is not a core
// Stata command), since it makes generating tables much easier within Stata for StatTag.  Because the table1
// package only allows exporting to Excel, we created this detection so that we can manipulate it and enforce
// XLSX output (as opposed to legacy XLS).
-(BOOL) IsTable1Command:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] Table1Regex] inString:command];
}

-(NSString*)GetMacroAnchorInCommand:(NSString*)command
{
  NSArray<NSString*>* macro = [self GetMacros:command trimDelimiters:FALSE];
  if (macro == nil || [macro count] == 0) {
    return @"";
  }
  return [macro firstObject];
}

-(NSString*)GetFileExtensionAnchorInCommand:(NSString*)command
{
  NSString* extension =  [self MatchRegexReturnGroup:command regex:[[self class] DataFileRegex] groupNum:1];
  return extension;
}

/**
 Given a macro name that appears in a command string, replace it with its expanded value
 */
-(NSString*)ReplaceMacroWithValue:(NSString*)originalString macro:(NSString*)macro value:(NSString*)value;
{
  NSString* localMacro = [NSString stringWithFormat:@"%@%@%@", [[STStataParser MacroDelimitersCharacters] objectAtIndex:0], macro, [[STStataParser MacroDelimitersCharacters] objectAtIndex:1]];
  NSString* globalMacro = [NSString stringWithFormat:@"%@%@", [[STStataParser MacroDelimitersCharacters] objectAtIndex:2], macro];

  NSString* modifiedString = [[originalString stringByReplacingOccurrencesOfString:localMacro withString:value]
                              stringByReplacingOccurrencesOfString:globalMacro withString:value];
  return modifiedString;
}

// Determines the path of a file where table data is located.
-(NSString*)GetTableDataPath:(NSString*)command
{
  // How do we detect filenames?  There are a few easy ways that we could do with regex, but we
  // will walk through the command string for some trigger strings, since in some situations we
  // may need to back-track.

  // A file must have either: a) one of our expected file extensions, or b) a macro.  This is going
  // to be our anchor.
  NSString* macro = [self GetMacroAnchorInCommand:command];
  if (macro == nil) {
    macro = @"";
  }
  NSString* fileExt = [self GetFileExtensionAnchorInCommand:command];
  if (fileExt == nil) {
    fileExt = @"";
  }

  if (![STGeneralUtil IsStringNullOrEmpty:macro] || ![STGeneralUtil IsStringNullOrEmpty:fileExt]) {
    NSRange anchorRange = [command rangeOfString:fileExt options:NSCaseInsensitiveSearch];
    if (anchorRange.location == NSNotFound || [STGeneralUtil IsStringNullOrEmpty:fileExt]) {
      anchorRange = [command rangeOfString:macro options:NSCaseInsensitiveSearch];
    }
    int anchorIndex = anchorRange.location;

    // Look ahead to some delimiter that indicates we're at the end of a file path.  This could be
    // whitespace, a comma or a closing quote.  If no end index is found, assume the end of our
    // file extension is the end index.
    NSRange searchRange = NSMakeRange(anchorIndex, [command length] - anchorIndex);
    NSRange endRange = [command rangeOfCharacterFromSet:[STStataParser EndCommandSegmentDelimiters] options:0 range:searchRange];
    int endIndex = endRange.location;
    if (endRange.location == NSNotFound) {
      endIndex = anchorIndex + [fileExt length];
    }

    // Now look behind to find the beginning of the file name.  This could be from the same list
    // of delimiters too.  If for some reason we don't find anything, we're going to assume that
    // we need to start at the beginning of the string.  This seems highly unlikely that it will
    // be correct, but it gives us a response we can send back, and the downstream failure should
    // be handled when we try to expand the path or find the file.
    unichar foundChar = [command characterAtIndex:endIndex];
    BOOL isQuoted = [[STStataParser QuotedSegmentDelimiters] characterIsMember:foundChar];
    NSCharacterSet* searchSet = (isQuoted == TRUE) ? [STStataParser QuotedSegmentDelimiters] : [STStataParser StartCommandSegmentDelimiters];
    NSRange backSearchRange = NSMakeRange(0, anchorIndex);
    NSRange startRange = [command rangeOfCharacterFromSet:searchSet options:NSBackwardsSearch range:backSearchRange];
    int startIndex = startRange.location;
    if (startRange.location == NSNotFound) {
      startIndex = 0;
    }

    NSRange range = NSMakeRange(startIndex + 1, (endIndex - startIndex - 1));
    return [[command substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  }

  return @"";
}

// Determine if a command may contain a reference to a data file that we could use within a table.
// We perform simple heuristic checks for simplicity.
-(BOOL)CommandHasDataFileOrMacroHeuristic:(NSString*)command
{
  // Determine if the command looks like a data file is referenced, because there is a file extension we associate
  // with data files present.
  if ([[self class] regexIsMatch:[[self class] DataFileRegex] inString:command]) {
    return true;
  }

  // Otherwise, if there is a macro present, be optimistic in that it will expand to a file path.
  NSArray<NSString*>* macros = [self GetMacros:command];
  return (macros != nil) && ([macros count] > 0);
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
  return [self GetMacros:command trimDelimiters:true];
}

-(NSArray<NSString*>*)GetMacros:(NSString*)command trimDelimiters:(BOOL)trimDelimiters
{
  NSMutableArray<NSString*>* macroNames = [[NSMutableArray<NSString*> alloc] init];
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if([[command stringByTrimmingCharactersInSet:ws] length] > 0) {
    NSArray *matches = [[[self class] MacroRegex] matchesInString:command options:0 range:NSMakeRange(0, command.length)];
    int count = [matches count];
    if (count > 0) {
      for (int index = 0; index < count; index++) {
        NSMutableString* macroName = [[NSMutableString alloc] init];
        NSTextCheckingResult* result = [matches objectAtIndex:index];
        NSRange firstRange = [result rangeAtIndex:1];
        NSRange secondRange = [result rangeAtIndex:2];
        if (firstRange.location == NSNotFound) {
          if (!trimDelimiters) {
            [macroName appendString:@"$"];
          }
          [macroName appendString:[command substringWithRange:secondRange]];
        }
        else {
          if (!trimDelimiters) {
            [macroName appendString:@"`"];
          }
          [macroName appendString:[command substringWithRange:firstRange]];
          if (!trimDelimiters) {
            [macroName appendString:@"'"];
          }
        }

        //NSRange matchRange = [[matches objectAtIndex:index] rangeAtIndex:1];
        //NSRange matchRange2 = [[matches objectAtIndex:index] rangeAtIndex:2];
        //if (matchRange.location != NSNotFound) {
        //  [macroNames addObject:[command substringWithRange:[[matches objectAtIndex:index] rangeAtIndex:1]]];
        //}
        [macroNames addObject:macroName];
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
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*)originalContent automation:(NSObject<STIStatAutomation>*)automation
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

// Determine if the command should be treated specially within our capture/noisily blocks.
// This was created to deal with a known issue in Stata when capture/noisily is wrapped around a set maxvar command
-(BOOL) IsCapturableBlock:(NSString*) command
{
  if (command == nil || [[command stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
    return false;
  }

  return ![[self class] regexIsMatch:[[self class] SetMaxvarRegex] inString:command];
}

// Provides a hook to perform any processing on a block of code (one or more
// lines) before it is executed by the statistical software.  The default
// behavior is to return the parameter untouched.
-(NSArray<NSString*>*) PreProcessExecutionStepCode:(STExecutionStep*) step
{
  NSArray<NSString*>* code = [super PreProcessExecutionStepCode:step];
  if (code == nil) {
    return nil;
  }

  if ([code count] == 0) {
    return code;
  }

  NSMutableArray<NSString*>* setMaxvarLines = [[NSMutableArray alloc] init];
  NSMutableArray<NSString*>* otherLines = [[NSMutableArray alloc] init];
  NSCharacterSet* ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  for (NSString* codeLine in code) {
    NSString* modifiedCodeLine = codeLine;
    NSArray *matches = [[[self class] SetMaxvarRegex] matchesInString:modifiedCodeLine options:0 range:NSMakeRange(0, modifiedCodeLine.length)];

    if([matches count] > 0){
      for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *matchString = [[modifiedCodeLine substringWithRange:matchRange] stringByTrimmingCharactersInSet:ws];
        [setMaxvarLines addObject:matchString];
      }

      modifiedCodeLine = [[[[self class] SetMaxvarRegex] stringByReplacingMatchesInString:modifiedCodeLine options:0 range:NSMakeRange(0, [modifiedCodeLine length]) withTemplate:@""] stringByTrimmingCharactersInSet:ws];
    }

    // If modifiedCodeLine is NOT (null or whitespace only), add it to the array of lines
    if ((modifiedCodeLine != nil)
             && !([[modifiedCodeLine stringByTrimmingCharactersInSet: ws] isEqualToString:@""])) {
      [otherLines addObject:modifiedCodeLine];
    }
  }

  [setMaxvarLines addObjectsFromArray:otherLines];
  return setMaxvarLines;
}

@end
