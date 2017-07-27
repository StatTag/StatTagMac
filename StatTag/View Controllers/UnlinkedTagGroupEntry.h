//
//  UnlinkedTagGroupEntry.h
//  StatTag
//
//  Created by Eric Whitley on 4/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STTag;
@class STCodeFile;

@interface UnlinkedTagGroupEntry : NSObject
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
@property (strong, nonatomic) STCodeFile* codeFile;
+(NSArray<UnlinkedTagGroupEntry*>*)initWithUnlinkedTags:(NSDictionary<NSString*, NSArray<STTag*>*>*)unlinkedTags;


@end
