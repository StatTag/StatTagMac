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
#import "STBaseParserSAS.h"
#import "STBaseParserR.h"
#import "STBaseGenerator.h"
#import "STStataBaseGenerator.h"
#import "STStataBaseValueFormatter.h"

@implementation STFactories

+(NSObject<STICodeFileParser>*)GetParser:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
      return [[STStataParser alloc] init];
    } else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages SAS] ]) {
      return [[STBaseParserSAS alloc] init];
    } else if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages R] ]) {
      return [[STBaseParserR alloc] init];
    }
  }
  return nil;
}


+(NSObject<STIGenerator>*)GetGenerator:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
       return [[STStataBaseGenerator alloc] init];
    }
  }
  return nil;
}

+(NSObject<STIValueFormatter>*)GetValueFormatter:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
      return [[STStataBaseValueFormatter alloc] init];
    }
  }
  return [[STBaseValueFormatter alloc] init];
}


@end
