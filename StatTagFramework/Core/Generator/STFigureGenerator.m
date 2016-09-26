//
//  STFigureGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STFigureGenerator.h"
#import "STTag.h"

@implementation STFigureGenerator


-(NSString*)CreateParameters:(STTag*)tag
{
  // Putting in StringBuilder, assuming more params will be added
  NSMutableString* builder = [[NSMutableString alloc] init];
  [builder appendString:[self GetLabelParameter:tag]];
  [builder appendString:[self GetRunFrequencyParameter:tag]];
  return [self CleanResult:builder];
}


@end
