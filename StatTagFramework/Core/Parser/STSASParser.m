//
//  STStataParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STSASParser.h"

@implementation STSASParser


//+(NSCharacterSet*)MacroDelimiters {
//  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:@"`'"];
//  return chars;
//}
//+(NSCharacterSet*)CalculationOperators {
//  NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:@"*/-+"];
//  return chars;
//}
//MARK: Value regex
+(NSArray<NSString*>*)ValueCommands {
  return [NSArray<NSString*> arrayWithObjects:@"%put", nil];
}
+(NSRegularExpression*)ValueKeywordRegex {
  NSError* error;
  NSRegularExpression* regex = [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b", [[[self class] ValueCommands] componentsJoinedByString:@"|"]]
          options:NSRegularExpressionCaseInsensitive
          error:&error];
  if(error){
    //NSLog(@"SAS - ValueKeywordRegex : %@", [error localizedDescription]);
    //NSLog(@"SAS - [[self class] ValueCommand] : %@", [[self class] ValueCommands]);
  }
  return regex;
}
+(NSRegularExpression*)ValueRegex {
  NSError* error;
  
  //original c# value regex template (won't work in obj-c as we don't have the ? if/then/else conditional
  //NSString* valueRegexTemplate = @"^\\s*%@((\\s*\\()|(\\s+))(.*)(?(2)\\))";

  NSString* valueRegexTemplate = @"^\\s*(?:%@)\\s+([^;]*";
  
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
//MARK: Figure regex
+(NSArray<NSString*>*)FigureCommands {
  return [[NSArray<NSString*> alloc] initWithObjects:@"ods pdf", nil];
}
+(NSRegularExpression*)FigureKeywordRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
                                  regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b[\\S\\s]*file", [[[[self class] FigureCommands] componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
  if(error){
    //NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    //NSLog(@"Stata - [[self class] FigureCommand] : %@", [[self class] FigureCommands]);
  }
  return regex;
}
+(NSRegularExpression*)FigureRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
                                  regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b[\\S\\s]*file\\s*=\\s*\"(.*)\"[\\S\\s]*;", [[[[self class] FigureCommands] componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
  if(error){
    //NSLog(@"Stata - FigureRexec : %@", [error localizedDescription]);
    //NSLog(@"Stata - [[self class] FigureCommand] : %@", [[self class] FigureCommands]);
  }
  return regex;
}


//MARK: Graph regex
+(NSArray<NSString*>*)GraphCommands {
  return [NSArray arrayWithObjects:@"gr(?:aph)? export", nil];
}
+(NSRegularExpression*)GraphKeywordRegex {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b", [[[[self class] GraphCommands] componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
                                                          options:NSRegularExpressionCaseInsensitive
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
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\s+\\\"?([^\\\",]*)[\\\",]?", [[[[self class] GraphCommands] componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:NSRegularExpressionCaseInsensitive
          error:&error];
  if(error){
    //NSLog(@"Stata - ValueKeywordRegex : %@", [error localizedDescription]);
    //NSLog(@"Stata - [[self class] ValueCommand] : %@", [[self class] ValueCommands]);
  }
  return regex;
}

//MARK: Table regex
+(NSArray<NSString*>*)TableCommands {
  return [NSArray arrayWithObjects:@"ods csv", nil];
}
+(NSRegularExpression*)TableKeywordRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b[\\S\\s]*file", [[[[self class] TableCommands] componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:NSRegularExpressionCaseInsensitive
          error:nil];
}
+(NSRegularExpression*)TableRegex {
  return [NSRegularExpression
          regularExpressionWithPattern:[NSString stringWithFormat:@"^\\s*%@\\b[\\S\\s]*file\\s*=\\s*\"(.*)\"[\\S\\s]*;", [[[[self class] TableCommands] componentsJoinedByString:@"|"] stringByReplacingOccurrencesOfString:@" " withString:@"\\s+" ]]
          options:NSRegularExpressionCaseInsensitive
          error:nil];
}

-(NSString*)MacroIndicator
{
  return @"&";
}

////MARK: additional regex properties
//+(NSRegularExpression*)LogKeywordRegex {
//  return [NSRegularExpression
//          regularExpressionWithPattern:@"^\\s*((?:cmd)?log)\\s*using\\b"
//          options:NSRegularExpressionAnchorsMatchLines //should match c# RegexOptions.Multiline
//          error:nil];
//  // static Regex LogKeywordRegex = new Regex("^\\s*((?:cmd)?log)\\s*using\\b", RegexOptions.Multiline);
//}

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
//
//+(NSRegularExpression*)MacroRegex {
//  return [NSRegularExpression
//          regularExpressionWithPattern:@"`([\\S]*?)'"
//          options:NSRegularExpressionAnchorsMatchLines
//          error:nil];
//}
//

///**
//This is used to test/extract a macro display value.
//@remark It assumes the rest of the display command has been extracted, and only the value name remains.
//*/
//+(NSRegularExpression*)MacroValueRegex {
//  return [NSRegularExpression
//   regularExpressionWithPattern:@"^\\s*`(.+)'"
//   options:0
//   error:nil];
//}

-(NSString*)CommentCharacter {
  return [STConstantsCodeFileComment SAS];
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
 Determine if a command has character(s) that indicate a macro value may be included within.  This is primarily intended for use when a filename is used and we need to resolve the path to a literal value.
 */
-(BOOL)HasMacroIndicator:(NSString*)command
{
  return [command containsString:[self MacroIndicator]];
}


/**
 Returns the name of the variable/scalar to display.
 
 @remark Assumes that you have verified this is a display command using
 IsValueDisplay first.
 */
-(NSString*) GetValueName:(NSString*)command
{
  return [self MatchRegexReturnGroup:command regex:[[self class] ValueRegex] groupNum:1];
}

-(BOOL) IsTableResult:(NSString*)command
{
  return [[self class] regexIsMatch:[[self class] TableKeywordRegex] inString:command];
}

-(NSString*) GetTableName:(NSString*)command
{
  return [self MatchRegexReturnGroup:command regex:[[self class] TableRegex] groupNum:1];
}

/**
 To prepare for use, we need to collapse down some of the text.  This includes:
  - Collapsing commands that span multiple lines into a single line
*/
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*)originalContent automation:(NSObject<STIStatAutomation>*)automation
{
  return originalContent;
}


@end
