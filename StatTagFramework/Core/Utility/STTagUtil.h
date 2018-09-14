//
//  STTagUtil.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STTag;
@class STCodeFile;
@class STTagCollisionResult;

@interface STTagUtil : NSObject

/**
 Find all tags with a matching tag name (regardless of case).
 
 @param outputLabel The tag name to search for
 @param files The list of code files the tag should be contained in.
 */
+(NSArray<STTag*>*)FindTagsByName:(NSString*)outputLabel files:(NSArray<STCodeFile*>*) files;

/**
 Determine if we need to perform a check for possible conflicting tag name names.
 */
+(BOOL)ShouldCheckForDuplicateLabel:(STTag*)oldTag newTag:(STTag*)newTag;

/**
 Looks across all tags in a collection of code files to find those that have
 the same tag name.
 */
+(NSDictionary<STCodeFile*, NSArray<NSNumber*>*>*)CheckForDuplicateLabels:(STTag*)tag files:(NSArray<STCodeFile*>*)files;

/**
 This is expected to be paired with the results of CheckForDuplicateLabels to determine if the tag
 has duplicates that appear in the results.  It assumes we have asserted a duplicate may exist.
 */
+(BOOL)IsDuplicateLabelInSameFile:(STTag*)tag result:(NSDictionary<STCodeFile*, NSArray<NSNumber*>*>*)result;

+(STTagCollisionResult*) DetectTagCollision:(NSArray<STTag*>*) allTags tag:(STTag*)tag;
+(STTagCollisionResult*) DetectTagCollision:(STTag*)tag;
+(STTagCollisionResult*) DetectTagCollision:(STTag*)tag1 tag2:(STTag*)tag2;
@end
