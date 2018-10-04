//
//  UnlinkedTagGroupEntry.h
//  StatTag
//
//  Created by Eric Whitley on 4/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StatTagFramework/STOverlappingTagResults.h>

@class STTag;
@class STCodeFile;

@interface OverlappingTagGroupEntry : NSObject
{
  NSString* _title;
  NSString* _subTitle;
  NSNumber* _startIndex;
  NSNumber* _endIndex;
  BOOL _isGroup;
  NSArray<STTag*>* _tags;
}

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* subTitle;
@property (strong, nonatomic) NSNumber* startIndex;
@property (strong, nonatomic) NSNumber* endIndex;
@property BOOL isGroup;
@property (strong, nonatomic) NSArray<STTag*>* tags;
@property (strong, nonatomic) STCodeFile* codeFile;
+(NSArray<OverlappingTagGroupEntry*>*)initWithOverlappingTags:(STOverlappingTagResults*)OverlappingTags;

-(NSArray<NSString*>*)getTagNames;

-(instancetype)initWithTag:(STTag*)tag andCodeFile:(STCodeFile*)codeFile;
-(instancetype)initWithGroupName:(NSString*)groupName andCodeFile:(STCodeFile*)codeFile andTags:(NSArray<STTag*>*)tags andStartIndex:(NSNumber*)startIndex andEndIndex:(NSNumber*)endIndex;

@end
