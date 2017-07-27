//
//  STStataParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STRParser.h"

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


NSString* const ParameterDelimiter = @"=";
NSString* const ArgumentDelimiter = @",";
NSString* const FileParameterName = @"file";

/**
This will return the exact parameter that represents the image save location.  This may be an R function (e.g., paste) to construct the file path, a variable, or a string literal.  String literals will include enclosing quotes.  This is because the output of this method is sent to R as an expression for evaluation.  That way R handles converting everything into an exact file path that we can then utilize.
*/
-(NSString*)GetImageSaveLocation:(NSString*)command
{
  
  NSArray *match = [[[self class] FigureRegex] matchesInString:command
                                             options:0
                                               range:NSMakeRange(0, [command length])];
  if([match count] == 0)
  {
    return @"";
  }
  if([[match firstObject] numberOfRanges] == 0)
  {
    return @"";
  }

  NSRange mr = [[match firstObject] rangeAtIndex:1];
  NSString* arguments = [command substringWithRange:mr];
  

  NSArray *matches = [[[self class] FigureParameterRegex] matchesInString:arguments
                                                       options:0
                                                         range:NSMakeRange(0, [arguments length])];
  if([matches count] == 0)
  {
    return @"";
  }
//  NSRange mr = [[match firstObject] rangeAtIndex:1];
//  NSString* arguments = [command substringWithRange:mr];

  NSMutableArray<STRParserFunctionParam*>* parameters = [[NSMutableArray<STRParserFunctionParam*> alloc] init];
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  for (NSInteger index = 0; index < [matches count]; index++)
  {
    NSTextCheckingResult* tc = [matches objectAtIndex:index];
    //we can't continue if we don't have 3 - we'll explode
    if([tc numberOfRanges] < 3)
    {
      continue;
    }

    NSString* t1 = @"";
    NSString* t2 = @"";
    NSString* t3 = @"";
    NSRange m1 = [tc rangeAtIndex:1];
      if (m1.length > 0) {
          t1 = [arguments substringWithRange:m1];
      }

    NSRange m2 = [tc rangeAtIndex:2];
      if (m2.length > 0) {
          t2 = [arguments substringWithRange:m2];
      }

    NSRange m3 = [tc rangeAtIndex:3];
      if (m3.length > 0) {
          t3 = [arguments substringWithRange:m3];
      }

    STRParserFunctionParam* fp = [[STRParserFunctionParam alloc] init];
    [fp setIndex:index];
    [fp setKey:t1];
    [fp setValue:([[t2 stringByTrimmingCharactersInSet:ws] length] > 0 ? t2 : t3)];

    [parameters addObject:fp];
  }
  
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
 To prepare for use, we need to collapse down some of the text.  This includes:
  - Collapsing commands that span multiple lines into a single line
*/
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*)originalContent
{
  return originalContent;
}


@end
