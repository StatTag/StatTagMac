//
//  STRMarkdownAutomation.m
//  StatTag
//
//  Created by Luke Rasmussen on 12/18/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import "StatTagFramework.h"
#import "STRMarkdownAutomation.h"
#import "STRMarkdownParser.h"
#import "STCommandResult.h"
#import "STTag.h"
#import "STGeneralUtil.h"
#import <RCocoa/RCocoa.h>


@implementation STRMarkdownAutomation

-(instancetype)init
{
  self = [super init];
  if(self) {
    Parser = [[STRMarkdownParser alloc] init];
  }
  return self;
}

-(BOOL)Initialize:(STCodeFile*)codeFile withLogManager:(STLogManager*)logManager
{
  if (![super Initialize:codeFile withLogManager:logManager]) {
    return NO;
  }
  
  //TODO - 306 - Port this C# code
  // We require that the knitr package be installed if a user wants to run R Markdown.
  // This is because we use the purl() command from knitr to extract the R code.
  // We think this is a fair assumption because the recommendation from StatTag is to
  // run your code to completion before running it in StatTag.  That means the user
  // should have knitted their R Markdown document.
  RCSymbolicExpression* expression = [Engine Evaluate:@"require('knitr')"];
  if (expression != nil) {
    NSArray<NSNumber*>* logicalResult = [expression AsLogical];
    if (logicalResult != nil && [logicalResult count] > 0) {
      NSNumber* resultValue = [logicalResult objectAtIndex:0];
      if ([resultValue boolValue]) {
        return YES;
      }
    }
  }

  NSDictionary* errorInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"ErrorCode",
                             [STConstantsStatisticalPackages R], @"StatisticalPackage",
                             @"To run R Markdown documents, StatTag requires that you have the knitr package installed.\r\n\r\nPlease see the User’s Guide for more information.", @"ErrorDescription",
                             nil];
  @throw [NSException exceptionWithName:NSGenericException
                                 reason:@"R Markdown not found"
                               userInfo:errorInfo];
  return NO;
}

@end
