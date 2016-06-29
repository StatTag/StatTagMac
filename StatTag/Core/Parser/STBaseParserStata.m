//
//  STBaseParserStata.m
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseParserStata.h"

@implementation STBaseParserStata


+(NSCharacterSet*)MacroDelimiters {
  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:@"`'"];
  return chars;
  //return [NSArray<NSString*> arrayWithObjects:@"`", @"'", nil];
}
+(NSCharacterSet*)CalculationOperators {
  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:@"*/-+"];
  return chars;
  //return [NSArray<NSString*> arrayWithObjects:@"*", @"/", @"-", @"+", nil];
}
//MARK: Value regex
+(NSString*)ValueCommand {
  return @"di(?:splay)?";
}
+(NSRegularExpression*)ValueKeywordRegex {
  NSError* error;
  NSRegularExpression* regex = [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b", [[self class] ValueCommand]]
          options:0
          error:&error];
  if(error){
    NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommand]);
  }
  return regex;
}
+(NSRegularExpression*)ValueRegex {
  NSError* error;
  NSRegularExpression* regex =  [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@((\\s*\\()|(\\s+))(.*)(?(2)\\))", [[self class] ValueCommand]]
          options:0
          error:&error];
  if(error){
    NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommand]);
  }
  return regex;
}
//MARK: Graph regex
+(NSString*)GraphCommand {
  return @"gr(?:aph)? export";
}
+(NSRegularExpression*)GraphKeywordRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b", [[[self class] GraphCommand] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
                                                          options:0
                                                            error:&error];
  if(error){
    NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommand]);
  }
  return regex;
}
+(NSRegularExpression*)GraphRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\s+\\\"?([^\\\",]*)[\\\",]?", [[[self class] GraphCommand] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:0
          error:&error];
  if(error){
    NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommand]);
  }
  return regex;
}

//MARK: Table regex
+(NSString*)TableCommand {
  return @"mat(?:rix)? l(?:ist)?";
}
+(NSRegularExpression*)TableKeywordRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b", [[[self class] TableCommand] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:0
          error:nil];
}
+(NSRegularExpression*)TableRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\s+([^,]*?)(?:\\r|\\n|$)", [[[self class] TableCommand] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:0
          error:nil];
}

//MARK: additional regex properties
+(NSRegularExpression*)LogKeywordRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:@"^\\s*((?:cmd)?log)\\s*using\\b"
          options:0//NSRegularExpressionAnchorsMatchLines //should match c# RegexOptions.Multiline
          error:nil];
  // static Regex LogKeywordRegex = new Regex("^\\s*((?:cmd)?log)\\s*using\\b", RegexOptions.Multiline);
}

+(NSArray<NSRegularExpression*>*)MultiLineIndicators {
  
  return [NSArray<NSRegularExpression*> arrayWithObjects:
          [NSRegularExpression
           regularExpressionWithPattern:@"[/]{3,}.*\\s*"
           options:0//NSRegularExpressionAnchorsMatchLines //should match c# RegexOptions.Multiline
           error:nil],
          [NSRegularExpression
           regularExpressionWithPattern:@"/\\*.*\\*/\\s?"
           options:NSRegularExpressionDotMatchesLineSeparators //default options should be single line?
           error:nil]
          , nil];
  
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

-(NSString*)CommentCharacter {
  return [STConstantsCodeFileComment Stata];
}


//MARK: regex helper methods - MOVE THESE

//FIXME: Move this somewhere else - this is general regex functionality
+(BOOL)regexIsMatch:(NSRegularExpression*)regex inString:(NSString*)string {
  NSRange textRange = NSMakeRange(0, string.length);
  //NSMatchingReportProgress
  NSRange matchRange = [regex rangeOfFirstMatchInString:string options:0 range:textRange];
  
  if (matchRange.location != NSNotFound)
    return true;
  
  return false;
}


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

/**
 Returns the file path where an image exported from the statistical package
 is being saved.
 
 @remark Assumes that you have verified this is an image export command
 using IsImageExport first
 */
-(NSString*) GetImageSaveLocation:(NSString*)command
{
  return [self MatchRegexReturnGroup:command regex:[[self class] GraphRegex] groupNum:1];
}

/**
 Returns the name of the variable/scalar to display.
 
 @remark Assumes that you have verified this is a display command using
 IsValueDisplay first.
 */
-(NSString*) GetValueName:(NSString*)command
{
  return [self MatchRegexReturnGroup:command regex:[[self class] ValueRegex] groupNum:4];
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
  NSString* cmd = [self GetValueName:command];
  if([cmd rangeOfCharacterFromSet:[[self class] CalculationOperators]].location != NSNotFound)
  {
    return true;
  }
  return false;
}


-(NSString*)MatchRegexReturnGroup:(NSString*)text regex:(NSRegularExpression*)regex groupNum:(int)groupNum
{
  NSTextCheckingResult* match = [regex firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
  if(match) {
    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange matchRange = [match rangeAtIndex:groupNum];
    NSString *matchString = [[text substringWithRange:matchRange]stringByTrimmingCharactersInSet:ws];
    return matchString;
  }
  return @"";
}

-(NSArray<NSString*>*)GlobalMatchRegexReturnGroup:(NSString*)text regex:(NSRegularExpression*)regex groupNum:(int)groupNum
{
  
  NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
  
  if([matches count] == 0){
    return nil;
  }

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  //if ([[[tag Name] stringByTrimmingCharactersInSet: ws] length] == 0)

  NSMutableArray<NSString*>* results = [[NSMutableArray<NSString*> alloc] init];
  for (NSTextCheckingResult *match in matches)
  {
    NSRange matchRange = [match rangeAtIndex:groupNum];
    NSString *matchString = [[text substringWithRange:matchRange] stringByTrimmingCharactersInSet:ws];
    [results addObject:matchString];
  }

  return results;
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
  NSString* modifiedText = [NSString stringWithString:originalText];

  for(NSRegularExpression* regex in [[self class]MultiLineIndicators])
  {
    modifiedText = [regex stringByReplacingMatchesInString:modifiedText options:0 range:NSMakeRange(0, modifiedText.length) withTemplate:@" "];
    //modifiedText = regex.Replace(modifiedText, " ");
  }
  
  return [modifiedText componentsSeparatedByString:@"\r\n"];
  //return modifiedText.Split(new string[]{"\r\n"}, StringSplitOptions.None).ToList();
}


@end
