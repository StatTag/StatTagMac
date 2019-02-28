//
//  WordDocProperty.m
//  StatTag
//
//  Created by Eric Whitley on 2/27/19.
//  Copyright © 2019 StatTag. All rights reserved.
//

#import "WordDocProperty.h"

@implementation WordDocProperty

@synthesize propertyName;
@synthesize propertyValue;
@synthesize propertyType;
@synthesize propertyData;


-(instancetype)init
{
  self = [super init];
  if (self != nil)
  {
    self.propertyName = @"";
    self.propertyValue = @"";
  }
  return self;
}

-(instancetype)initWithName:(NSString*)name andValue:(NSString*)value forType:(NSString*)type
{
  self = [super init];
  if (self != nil)
  {
    self.propertyName = name;
    self.propertyValue = value;
    self.propertyType = type;
  }
  return self;
}


@end
