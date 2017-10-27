//
//  StatTagWordDocumentFieldTag.m
//  StatTag
//
//  Created by Eric Whitley on 10/24/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "StatTagWordDocumentFieldTag.h"
#import "StatTagFramework.h"

@implementation StatTagWordDocumentFieldTag


-(instancetype)initWithWordField:(STMSWord2011Field*)field andFieldTag:(STFieldTag*)fieldTag andTag:(STTag*)tag
{
  self = [super init];
  if(self)
  {
    [self setField:field];
    [self setFieldTag:fieldTag];
    [self setTag:tag];
  }
  return self;
}

-(NSString*)description
{
  return [NSString stringWithFormat:@"field:(%ld)%@, field tag:%@", (long)[_field entry_index], [[_field fieldCode] content], [_fieldTag Id]];
}

-(instancetype)initWithWordShape:(STMSWord2011Shape*)shape andTag:(STTag*)tag
{
  self = [super init];
  if(self)
  {
    [self setShape:shape];
    [self setTag:tag];
  }
  return self;
}

-(NSString*)fieldType
{
  if([self field] != nil)
  {
    return @"STMSWord2011Field";
  }
  if([ self shape] != nil)
  {
    return @"STMSWord2011Shape";
  }
  return nil;
}

@end
