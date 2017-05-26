//
//  DuplicateTagGroupEntry.h
//  StatTag
//
//  Created by Eric Whitley on 4/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StatTagFramework/STDuplicateTagResults.h>
@class STTag;

@interface DuplicateTagGroupEntry:NSObject
{
  NSString* _title;
  NSString* _subTitle;
  BOOL _isGroup;
  STTag* _tag;
}

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* subTitle;
@property BOOL isGroup;
@property (strong, nonatomic) STTag* tag;
+(NSArray<DuplicateTagGroupEntry*>*)initWithDuplicateTagResults:(STDuplicateTagResults*)duplicateTags;

@end
