//
//  STFactories.m
//  StatTag
//
//  Created by Eric Whitley on 6/17/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STFactories.h"
#import "STConstants.h"
#import "STCodefile.h"
#import "STICodeFileParser.h"
#import "STBaseValueFormatter.h"
#import "STStataParser.h"
#import "STSASParser.h"
#import "STRParser.h"
#import "STRMarkdownParser.h"
#import "STBaseGenerator.h"
#import "STStataBaseGenerator.h"
#import "STRBaseGenerator.h"
#import "STRMarkdownGenerator.h"
#import "STStataBaseValueFormatter.h"
#import "STRBaseValueFormatter.h"
#import "STRMarkdownValueFormatter.h"

@implementation STFactories

+(id<STICodeFileParser>)GetParser:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
      return [[STStataParser alloc] init];
//    } else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages SAS] ]) {
//      return [[STSASParser alloc] init];
    }
    else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages R] ]) {
      return [[STRParser alloc] init];
    }
    else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages RMarkdown] ]) {
      return [[STRMarkdownParser alloc] init];
    }
  }
  return nil;
}


+(id<STIGenerator>)GetGenerator:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
       return [[STStataBaseGenerator alloc] init];
    }
    else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages R] ]) {
        return [[STRBaseGenerator alloc] init];
    }
    else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages RMarkdown] ]) {
      return [[STRMarkdownGenerator alloc] init];
    }
  }
  return nil;
}

+(id<STIValueFormatter>)GetValueFormatter:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
      return [[STStataBaseValueFormatter alloc] init];
    }
    else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages R] ]) {
      return [[STRBaseValueFormatter alloc] init];
    }
    else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages RMarkdown] ]) {
      return [[STRMarkdownValueFormatter alloc] init];
    }
  }
  return [[STBaseValueFormatter alloc] init];
}


@end
