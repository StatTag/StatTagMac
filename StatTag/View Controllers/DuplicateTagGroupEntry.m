//
//  DuplicateTagGroupEntry.m
//  StatTag
//
//  Created by Eric Whitley on 4/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "DuplicateTagGroupEntry.h"
#import <StatTagFramework/STTag.h>
#import <StatTagFramework/STCodeFile.h>

@implementation DuplicateTagGroupEntry
-(instancetype)init
{
  self = [super init];
  if(self)
  {
    _isGroup = NO;
  }
  return self;
}
-(instancetype)initWithTitle:(NSString*)title andTag:(STTag*)tag isGroup:(BOOL)isGroup
{
  self = [super init];
  if(self)
  {
    _title = title;
    _tag = tag;
    _isGroup = isGroup;
    if(tag)
    {
      _subTitle = [[tag CodeFile] FileName];
    }
  }
  return self;
}
-(NSString*)description
{
  return [NSString stringWithFormat:@"Title: %@, isGroup: %hhd, Name: %@", [self title], [self isGroup], [[self tag] Name]];
}

+(NSArray<DuplicateTagGroupEntry*>*)initWithDuplicateTagResults:(STDuplicateTagResults*)duplicateTags
{
  NSMutableArray<DuplicateTagGroupEntry*>* tags = [[NSMutableArray<DuplicateTagGroupEntry*> alloc] init];
  //NSMutableDictionary<STTag*, NSArray<STTag*>*>
  //enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))
  for (STTag* t in [duplicateTags allKeys]) {
    ////NSLog(@"%@ - %@",key,[d objectForKey:key]);
    [tags addObject:[[DuplicateTagGroupEntry alloc] initWithTitle:[t Name] andTag:t isGroup:YES]];
    //apparently we're also using the first tag as the key - and all subsequent tags are the children
    // so - if you have 2 duplicates, one is the key and one is the child
    // 3 duplicates, 1 is the key and 2 are the children - and so on
    // because of that, we're going to add the first parent tag as the group _AND_ as a child
    [tags addObject:[[DuplicateTagGroupEntry alloc] initWithTitle:[t Name] andTag:t isGroup:NO]];
    for(STTag* i in [duplicateTags objectForKey:t])
    {
      [tags addObject:[[DuplicateTagGroupEntry alloc] initWithTitle:[i Name] andTag:i isGroup:NO]];
    }
  }
  
  return tags;
}

@end
