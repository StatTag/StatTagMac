//
//  STFigureFormat.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STFigureFormat.h"

@implementation STFigureFormat

//MARK: copying

-(id)copyWithZone:(NSZone *)zone
{
  STFigureFormat *format = [[[self class] allocWithZone:zone] init];//[[STFigureFormat alloc] init];
  
  return format;
}


@end
