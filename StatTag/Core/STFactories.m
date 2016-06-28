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
#import "STBaseValueFormatter.h"

@implementation STFactories

+(NSObject<STIParser>*)GetParser:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
      //FIXME: NOT IMPLEMENTED
      //        return new StatTag.Core.Parser.Stata();
      [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
    }
  }
  return nil;
}


+(NSObject<STIGenerator>*)GetGenerator:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
      [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
      //FIXME: NOT IMPLEMENTED
      //        return new StatTag.Core.Generator.Stata();
    }
  }
  return nil;
}

+(NSObject<STIValueFormatter>*)GetValueFormatter:(STCodeFile*)file {
  if (file != nil)
  {
    if([[file StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata] ]) {
      [NSException raise:@"Not yet implemented" format:@"method not yet implemented"];
      //FIXME: NOT IMPLEMENTED
      //        return new StatTag.Core.ValueFormatter.Stata();
    }
  }
  return [[STBaseValueFormatter alloc] init];
}


@end