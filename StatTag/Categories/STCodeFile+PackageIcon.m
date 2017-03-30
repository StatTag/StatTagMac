//
//  STCodeFile+STCodeFile_PackageIcon.m
//  StatTag
//
//  Created by Eric Whitley on 3/29/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "STCodeFile+PackageIcon.h"

@implementation STCodeFile (PackageIcon)


-(NSImage*)packageIcon
{
  NSImage* img;
  if([[self StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata]])
  {
    img = [NSImage imageNamed:@"stats_package_stata"];
  } else if ([[self StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages R]])
  {
    img = [NSImage imageNamed:@"stats_package_r"];
  } else if ([[self StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages SAS]])
  {
    img = [NSImage imageNamed:@"stats_package_sas"];
  } else {
    img = [NSImage imageNamed:@"stattag_logo_purple"];
  }
  
  return img;
}

@end
