//
//  UnlinkedTagGroupEntry.m
//  StatTag
//
//  Created by Eric Whitley on 4/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "UnlinkedTagGroupEntry.h"
#import <StatTagFramework/STTag.h>
#import <StatTagFramework/STCodeFile.h>

@implementation UnlinkedTagGroupEntry

-(instancetype)init
{
  self = [super init];
  if(self)
  {
    _isGroup = NO;
  }
  return self;
}

-(instancetype)initWithCodeFile:(STCodeFile*)codeFile andTag:(STTag*)tag isGroup:(BOOL)isGroup
{
  self = [super init];
  if(self)
  {
    _codeFile = codeFile;
    //_title = title;
    _tag = tag;
    _isGroup = isGroup;
    if(codeFile && isGroup)
    {
      _title = [codeFile FileName];
      _subTitle = [codeFile FilePath];
    }
//    if(tag && isGroup)
//    {
//      //_codeFile = [tag CodeFile];
//      _subTitle = [[tag CodeFile] FilePath];
//    }
  }
  return self;
}
-(NSString*)description
{
  return [NSString stringWithFormat:@"Title: %@, SubTitle: %@, isGroup: %hhd, Name: %@", [self title], [self subTitle], [self isGroup], [[self tag] Name]];
}

+(NSArray<UnlinkedTagGroupEntry*>*)initWithUnlinkedTags:(NSDictionary<NSString*, NSArray<STTag*>*>*)unlinkedTags
{
  NSMutableArray<UnlinkedTagGroupEntry*>* tags = [[NSMutableArray<UnlinkedTagGroupEntry*> alloc] init];
  
  //NSMutableDictionary<STTag*, NSArray<STTag*>*>
  //enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))
  for (NSString* cfPath in [unlinkedTags allKeys]) {
    //[tags addObject:[[UnlinkedTagGroupEntry alloc] initWithTitle:cfPath andTag:nil isGroup:YES]];
    int pos = 0;
    for(STTag* i in [unlinkedTags objectForKey:cfPath])
    {
      if(pos == 0)
      {
        //if we are the first record in the list, we're double-adding to create a "group"
        [tags addObject:[[UnlinkedTagGroupEntry alloc] initWithCodeFile:[i CodeFile] andTag:i isGroup:YES]];
      }
      [tags addObject:[[UnlinkedTagGroupEntry alloc] initWithCodeFile:[i CodeFile] andTag:i isGroup:NO]];
      pos = pos + 1;
    }
  }
  
  return tags;
  
  
  //get our list of code files
//  NSMutableArray<NSString*>* codeFilePaths = [[NSMutableArray<NSString*> alloc] init];
//  for (STTag* t in unlinkedTags) {
//    if(![codeFilePaths containsObject:[[t CodeFile] FilePath]])
//    {
//      [codeFilePaths addObject:[[t CodeFile] FilePath]];
//    }
//  }
//  //sort
//  codeFilePaths = [[NSMutableArray<NSString*> alloc] initWithArray:[codeFilePaths sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
//  
//  for (STTag* t in unlinkedTags) {
//    ////NSLog(@"%@ - %@",key,[d objectForKey:key]);
//    [tags addObject:[[UnlinkedTagGroupEntry alloc] initWithTitle:[t Name] andTag:t isGroup:YES]];
//    //apparently we're also using the first tag as the key - and all subsequent tags are the children
//    // so - if you have 2 duplicates, one is the key and one is the child
//    // 3 duplicates, 1 is the key and 2 are the children - and so on
//    // because of that, we're going to add the first parent tag as the group _AND_ as a child
//    [tags addObject:[[UnlinkedTagGroupEntry alloc] initWithTitle:[t Name] andTag:t isGroup:NO]];
//    for(STTag* i in [unlinkedTags objectForKey:t])
//    {
//      [tags addObject:[[UnlinkedTagGroupEntry alloc] initWithTitle:[i Name] andTag:i isGroup:NO]];
//    }
//  }
  
  return tags;
}

@end
