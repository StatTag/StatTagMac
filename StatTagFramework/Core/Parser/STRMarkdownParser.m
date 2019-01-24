//
//  STRMarkdownParser.m
//  StatTag
//
//  Created by Luke Rasmussen on 12/18/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "STRMarkdownParser.h"
#include "STFileHandler.h"


@implementation STRMarkdownParser


@synthesize FileHandler = _FileHandler;

+(NSRegularExpression*)KableCommand {
  NSError* error;
  NSRegularExpression* regex =   [NSRegularExpression
                                  regularExpressionWithPattern:@"(knitr::)?kable\\s*\\("
                                  options:0
                                  error:&error];
  return regex;
}

NSString* const TempFileSuffix = @".st-tmp";

-(id)init {
  self = [super init];
  if(self) {
    _FileHandler = [[STFileHandler alloc] init];
  }
  return self;
}


// Convert some knitr-specific commands that may exist to ones that will work better
// with StatTag.  Note that we are doing this in-memory, not modifying the code file
// directly.
-(NSArray<NSString*>*)ReplaceKnitrCommands:(NSArray<NSString*>*)commands
{
  if (commands == nil) {
    return nil;
  }
  
  long commandCount = [commands count];
  NSMutableArray<NSString*>* replacedResults = [[NSMutableArray alloc] initWithCapacity:commandCount];
  for (int index = 0; index < commandCount; index++) {
    NSString* command = [commands objectAtIndex:index];
    [replacedResults addObject:[[STRMarkdownParser KableCommand] stringByReplacingMatchesInString:command
                                                                                          options:0
                                                                                          range:NSMakeRange(0, [command length])
                                                                                          withTemplate:@"print("]];
  }
  return replacedResults;
}

-(void)RaiseException:(NSString*)title withDetails:(NSString*) details
{
  NSDictionary* errorInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"ErrorCode",
                             [STConstantsStatisticalPackages RMarkdown], @"StatisticalPackage",
                             details, @"ErrorDescription",
                             nil];
  @throw [NSException exceptionWithName:NSGenericException
                                 reason:title
                               userInfo:errorInfo];
}

// Used to convert the R Markdown document into just an R code file
-(NSArray<NSString*>*)PreProcessFile:(STCodeFile*)file automation:(NSObject<STIStatAutomation>*) automation
{
  if (automation == nil) {
    [self RaiseException:@"No R Environment"
                withDetails:@"The R environment is needed to process R Markdown files.  Unfortunately, no R environment was provided."];
  }
  
  if (![[[file FilePath] lowercaseString] hasSuffix:@"rmd"]) {
    [self RaiseException:@"R Markdown Extension" withDetails:@"StatTag is only able to process R Markdown files with the .Rmd extension"];
  }
  
  // Trim off the "md" to get our .R file name
  NSString* generatedCodeFilePath = [NSMutableString stringWithString:[[file FilePath] substringToIndex:[[file FilePath] length] - 2]];
  
  // As a guard, check to see if the .R version of the file already exists.  We will clean the code file up when we're done, so we
  // know we didn't create it.  Unfortunately we will need the user to intervene.
  if ([[self FileHandler] Exists:[NSURL fileURLWithPath:generatedCodeFilePath] error:nil]) {
    [self RaiseException:@"R file already exists" withDetails:[NSString stringWithFormat:@"StatTag tries to generate an R file from your R Markdown document, and a file already exists at %@.\r\n\r\nTo avoid deleting code that you wish to keep, StatTag cannot continue.  If you don't need %@, please delete that file and try running again.", generatedCodeFilePath, generatedCodeFilePath]];
  }
  
  NSString* filePath = [[file FilePath] stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
  
  NSArray<NSString*>* purlCommands = [NSArray<NSString*> arrayWithObjects: @"library(knitr)",
                                      [NSString stringWithFormat:@"purl(\"%@\")", filePath],
                                      nil];
  [automation RunCommands:purlCommands];

  // At this point, we need the generated R file to be there.  If not, something happened during the purl() process.
  // Move will throw an error if the file doesn't exist, so that will be our implied error check.
  // Let's give the generated file a new name, just to help us identify that it was created by StatTag
  NSString* updatedCodeFilePath = [NSString stringWithFormat:@"%@%@", generatedCodeFilePath, TempFileSuffix];
  NSURL* sourceURL = [NSURL URLWithString:[generatedCodeFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSURL* destURL = [NSURL URLWithString:[updatedCodeFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  [[self FileHandler] Move:sourceURL destFileName:destURL error:nil];
  generatedCodeFilePath = updatedCodeFilePath;
  
  STCodeFile* tempCodeFile = [[STCodeFile alloc] init];
  [tempCodeFile setFilePath:generatedCodeFilePath];
  [tempCodeFile setStatisticalPackage:[STConstantsStatisticalPackages R]];
  NSArray<NSString*>* processedFileResults = [super PreProcessFile:tempCodeFile automation:automation];
  
  // Clean up the generated R file
  [[self FileHandler] Delete:[NSURL URLWithString:[generatedCodeFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] error:nil];
  return [self ReplaceKnitrCommands:processedFileResults];
}


@end
