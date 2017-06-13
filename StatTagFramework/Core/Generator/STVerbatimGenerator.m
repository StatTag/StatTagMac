//
//  STTableGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STVerbatimGenerator.h"
#import "STConstants.h"
#import "STTag.h"
#import "STValueFormat.h"

@implementation STVerbatimGenerator


-(NSString*)CreateParameters:(STTag*)tag
{
  // Putting in StringBuilder, assuming more params will be added
  NSMutableString* builder = [[NSMutableString alloc] init];
  [builder appendString:[self GetLabelParameter:tag]];
  [builder appendString:[self GetRunFrequencyParameter:tag]];
  return [self CleanResult:builder];
}


@end
