//
//  STTag+STTag_StatisticalPackage.m
//  StatTag
//
//  Created by Eric Whitley on 6/25/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "STTag+StatisticalPackage.h"

@implementation STTag (StatisticalPackage)

-(NSString*)StatisticalPackage {
  return [[self CodeFile] StatisticalPackage];
}

@end
