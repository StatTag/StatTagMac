//
//  UnlinkedTagGroupEntry.m
//  StatTag
//
//  Created by Eric Whitley on 4/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "OverlappingTagGroupEntry.h"
#import <StatTagFramework/STTag.h>
#import <StatTagFramework/STCodeFile.h>
#import <StatTagFramework/STOverlappingTagResults.h>

@implementation OverlappingTagGroupEntry

-(instancetype)init
{
  self = [super init];
  if(self)
  {
    _isGroup = NO;
    _tags = nil;
    _codeFile = nil;
  }
  return self;
}

-(instancetype)initWithTag:(STTag*)tag andCodeFile:(STCodeFile*)codeFile
{
  self = [super init];
  if(self) {
    _codeFile = codeFile;
    _tags = @[tag];
    _isGroup = NO;
    
    _title = [tag Name];
    _subTitle = [tag FormatLineNumberRange];
    _startIndex = [tag LineStart];
    _endIndex = [tag LineEnd];
  }
  return self;
}

-(instancetype)initWithGroupName:(NSString*)groupName andCodeFile:(STCodeFile*)codeFile andTags:(NSArray<STTag*>*)tags andStartIndex:(NSNumber*)startIndex andEndIndex:(NSNumber*)endIndex
{
  self = [super init];
  if(self) {
    _codeFile = codeFile;
    _tags = tags;
    _isGroup = YES;
    
    _title = groupName;
    _subTitle = [codeFile FileName];
    _startIndex = startIndex;
    _endIndex = endIndex;
  }
  return self;
}

-(NSString*)description
{
  return [NSString stringWithFormat:@"Title: %@, SubTitle: %@, isGroup: %hhd", [self title], [self subTitle], [self isGroup]];
}

-(NSArray<NSString*>*)getTagNames
{
  NSMutableArray<NSString*>* tagNames = [[NSMutableArray alloc] init];
  if (_tags == nil || [_tags count] == 0) {
    return tagNames;
  }
  
  for (STTag* tag in _tags) {
    [tagNames addObject:[tag Name]];
  }
  
  return tagNames;
}

+(NSArray<OverlappingTagGroupEntry*>*)initWithOverlappingTags:(STOverlappingTagResults*)overlappingTags
{
  NSMutableArray<OverlappingTagGroupEntry*>* tags = [[NSMutableArray<OverlappingTagGroupEntry*> alloc] init];
  for (STCodeFile* codeFile in [overlappingTags allKeys]) {
    NSMutableArray<NSMutableArray<STTag*>*>* groupCollection = [overlappingTags objectForKey:codeFile];
    for (int groupIndex = 0; groupIndex < [groupCollection count]; groupIndex++) {
      NSMutableArray<STTag*>* group = [groupCollection objectAtIndex:groupIndex];
      // We only allow groups where we know there are >=2 tags.  Otherwise, it makes no sense to show them
      if ([group count] >= 2) {
        STTag* firstTag = [group objectAtIndex:0];
        // The way the groups are packed up, the first tag in the group will always have the minimum and maximum line range
        [tags addObject:[[OverlappingTagGroupEntry alloc] initWithGroupName:[NSString stringWithFormat:@"Overlapping Group #%d (%d tags)", (groupIndex+1), (int)[group count]]
                                                                andCodeFile:codeFile andTags:group andStartIndex:[firstTag LineStart] andEndIndex:[firstTag LineEnd]]];
        for (STTag* tag in group) {
          [tags addObject:[[OverlappingTagGroupEntry alloc] initWithTag:tag andCodeFile:codeFile]];
        }
      }
    }
  }
  
  return tags;
}

@end
