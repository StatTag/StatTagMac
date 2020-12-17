//
//  STTagUtil.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTagUtil.h"
#import "STTag.h"
#import "STCodeFile.h"
#import "STTagCollisionResult.h"
#import "STGeneralUtil.h"

@implementation STTagUtil


/**
 Find all tags with a matching tag name (regardless of case).

  @param name:outputLabel The tag name to search for
  @param name:files The list of code files the tag should be contained in.
 */
+(NSArray<STTag*>*)FindTagsByName:(NSString*)outputLabel files:(NSArray<STCodeFile*>*) files
{
  if (files == nil || [files count] == 0)
  {
    return nil;
  }
  
  NSPredicate *tagPredicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
    //note the case insensitive comparison...
    return [[aTag Name] caseInsensitiveCompare:outputLabel] == NSOrderedSame;
  }];

  //this is heavy-handed, but... I'm not sure of a better way to do this w/ our target
  NSMutableArray<STTag*>* allTags = [[NSMutableArray alloc] init];
  for (NSInteger i = 0; i < [files count] ; i++)
  {
    [allTags addObjectsFromArray:[[files objectAtIndex:i] Tags]];
  }
  
  return [allTags filteredArrayUsingPredicate:tagPredicate];
}

/**
 Determine if we need to perform a check for possible conflicting tag name names.
*/
+(BOOL)ShouldCheckForDuplicateLabel:(STTag*)oldTag newTag:(STTag*)newTag
{
  if (oldTag == nil && newTag != nil)
  {
    return true;
  }
  
  if (newTag == nil)
  {
    return false;
  }
  
  return ![[oldTag Name] isEqualToString:[newTag Name]];
}

/**
 Looks across all tags in a collection of code files to find those that have
 the same tag name.
*/
+(NSDictionary<STCodeFile*, NSArray<NSNumber*>*>*)CheckForDuplicateLabels:(STTag*)tag files:(NSArray<STCodeFile*>*)files
{
  if (tag == nil)
  {
    return nil;
  }
  
  NSArray<STTag*>* tags = [self FindTagsByName:[tag Name] files:files];
  if (tags == nil || [tags count] == 0)
  {
    return nil;
  }
  
  NSMutableDictionary<STCodeFile*, NSMutableArray<NSNumber*>*>* duplicateCount = [[NSMutableDictionary<STCodeFile*, NSMutableArray<NSNumber*>*> alloc] init];
  for (STTag* otherTag in tags)
  {
    // If the tag is the exact some object, skip it.
    //if (object.ReferenceEquals(otherTag, tag))
    if(otherTag == tag)
    {
      continue;
    }
    
    if([duplicateCount objectForKey:[otherTag CodeFile] ] == nil)
    {
      [duplicateCount setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0], nil] forKey:[otherTag CodeFile]];
    }
    
    // If the tag names are an exact match, they go into the first bucket.
    // Otherwise, they are a case-insensitive match and go into the second bucket.
    if ([[tag Name] isEqualToString:[otherTag Name]])
    {
      NSMutableArray* a = [duplicateCount objectForKey:[otherTag CodeFile]];
      NSNumber* i = [NSNumber numberWithInteger:[[a objectAtIndex: 0] integerValue] + 1];
      [a setObject:i atIndexedSubscript:0];
      [duplicateCount setObject:a forKey:[otherTag CodeFile]];
    }
    else
    {
      NSMutableArray* a = [duplicateCount objectForKey:[otherTag CodeFile]];
      NSNumber* i = [NSNumber numberWithInteger:[[a objectAtIndex: 1] integerValue] + 1];
      [a setObject:i atIndexedSubscript:1];
      [duplicateCount setObject:a forKey:[otherTag CodeFile]];
    }
  }
  
  return duplicateCount;
}

/**
  This is expected to be paired with the results of CheckForDuplicateLabels to determine if the tag
  has duplicates that appear in the results.  It assumes we have asserted a duplicate may exist.
*/
+(BOOL)IsDuplicateLabelInSameFile:(STTag*)tag result:(NSDictionary<STCodeFile*, NSArray<NSNumber*>*>*)result
{
  // If the tag itself is null, or it has no code file reference, we will assume this isn't in the same file (or that no
  // file exists for it to be the "same" in).  Likewise, if our result structure is null, we have nothing to check so we are done.
  if (tag == nil || result == nil || [tag CodeFile] == nil)
  {
    return false;
  }
  
  // Look in the list of code files that had matching results of some degree to see if this tag's code file is represented.
  //var codeFileResult = result.Where(x => x.Key.Equals(tag.CodeFile)).Select(x => (KeyValuePair<CodeFile, int[]>?)x).FirstOrDefault();
  //The above appears to just be pulling the first array value for a matching key?
  NSArray<NSNumber*>* codeFileResult = [result objectForKey:[tag CodeFile]];

  // This really shouldn't happen, but as a guard we'll look to see if the code file exists.  If not, we will assume that there
  // is no duplicate label in this file.
  if (codeFileResult == nil)
  {
    return false;
  }
  
  // The last check is if the code file has any duplicate entries that are found.  We consider matches - even not with exact
  // case - as duplicates.
  // EWW: NOTE - these are NSNumber, so make sure you access the integerValue or you might get the wrong result (ex: it might just do a bool check)
  return ([codeFileResult[0] integerValue] > 0 || [codeFileResult[1] integerValue] > 0);
}

/// <summary>
/// Checks if tag1 and tag2 are completely outside of each other (they have
/// no overlap)
/// </summary>
/// <param name="tag1"></param>
/// <param name="tag2"></param>
/// <returns></returns>
+(BOOL)TagsOutsideEachOther:(STTag*) tag1 tag2:(STTag*)tag2
{
  return (tag1.LineStart.integerValue > tag2.LineEnd.integerValue && tag1.LineEnd.integerValue > tag2.LineEnd.integerValue)
  || (tag1.LineStart.integerValue < tag2.LineStart.integerValue && tag1.LineEnd.integerValue < tag2.LineStart.integerValue);
}

/// <summary>
/// Checks if tag1 and tag2 overlap exactly
/// </summary>
/// <param name="tag1"></param>
/// <param name="tag2"></param>
/// <returns></returns>
+(BOOL)TagsOverlapExact:(STTag*) tag1 tag2:(STTag*)tag2
{
  return (tag1.LineStart.integerValue == tag2.LineStart.integerValue && tag1.LineEnd.integerValue == tag2.LineEnd.integerValue && !([[tag1 Id] isEqualToString:[tag2 Id]]));
}

/// <summary>
/// Checks if tag1 is completedly embedded within tag2
/// </summary>
/// <param name="tag1"></param>
/// <param name="tag2"></param>
/// <returns></returns>
+(BOOL)TagEmbeddedWithin:(STTag*) tag1 tag2:(STTag*)tag2
{
  return (tag1.LineStart.integerValue >= tag2.LineStart.integerValue && tag1.LineEnd.integerValue <= tag2.LineEnd.integerValue)
  && !([self TagsOverlapExact:tag1 tag2:tag2]);
}

/// <summary>
/// Checks if tag1 starts before tag2 starts, and ends before or at the
/// same point as tag2.
/// </summary>
/// <param name="tag1"></param>
/// <param name="tag2"></param>
/// <returns></returns>
+(BOOL)TagOverlapsFront:(STTag*) tag1 tag2:(STTag*)tag2
{
  return (tag1.LineStart.integerValue < tag2.LineStart.integerValue && tag1.LineEnd.integerValue <= tag2.LineEnd.integerValue && tag1.LineEnd.integerValue >= tag2.LineStart.integerValue);
}

/// <summary>
/// Checks if tag1 starts before or at the same time as tag2 ends, and ends after
/// the end of
/// </summary>
/// <param name="tag1"></param>
/// <param name="tag2"></param>
/// <returns></returns>
+(BOOL)TagOverlapsBack:(STTag*) tag1 tag2:(STTag*)tag2
{
  return (tag1.LineEnd.integerValue > tag2.LineEnd.integerValue && tag1.LineStart.integerValue <= tag2.LineEnd.integerValue && tag1.LineStart.integerValue >= tag2.LineStart.integerValue);
}

+(STTagCollisionResult*) DetectTagCollision:(STTag*)tag1 tag2:(STTag*)tag2
{
  // 1. Overlaps exact
  //    [ - Tag 1 - ]
  //    [ - Tag 2 - ]
  if ([self TagsOverlapExact:tag1 tag2:tag2]) {
    return [[STTagCollisionResult alloc] init:tag2 collision:OverlapsExact];
  }
  // 2. Embedded within
  //     [ --- Tag 1 --- ]
  //       [ - Tag 2 - ]
  // Note the order of parameters here, we want to see if our new tag (tag) is embedded within an existing tag (x)
  else if ([self TagEmbeddedWithin:tag1 tag2:tag2]) {
    return [[STTagCollisionResult alloc] init:tag2 collision:EmbeddedWithin];
  }
  // 3. Overlap front
  //       [ - Tag 1 - ]
  //    [ -- Tag 2 -- ]
  else if ([self TagOverlapsFront:tag1 tag2:tag2]) {
    return [[STTagCollisionResult alloc] init:tag2 collision:OverlapsFront];
  }
  // 4. Overlap back
  //    [ - Tag 1 - ]
  //         [ - Tag 2 - ]
  else if ([self TagOverlapsBack:tag1 tag2:tag2]) {
    return [[STTagCollisionResult alloc] init:tag2 collision:OverlapsBack];
  }
  // 5. Embeds
  //       [ - Tag 1 - ]
  //     [ --- Tag 2 --- ]
  // Note the order of parameters here, we want to see if an existing tag (x) is embedded within our new tag (tag)
  // Said another way, we check if our new tag (tag) embeds an existing tag (x) within it
  else if ([self TagEmbeddedWithin:tag2 tag2:tag1]) {
    return [[STTagCollisionResult alloc] init:tag2 collision:Embeds];
  }

  return nil;
}

/// <summary>
/// Given a tag, look within the same code file to determine if the tag is embedded within (or overlaps with) another tag.
/// If so, provide the tag that we overlap with.  Note that we will only provide the first tag if there are multiple nested
/// tags.  Calling this multiple times would resolve that scenario.
/// </summary>
/// <param name="tag"></param>
/// <returns></returns>
+(STTagCollisionResult*) DetectTagCollision:(NSArray<STTag*>*) allTags tag:(STTag*)tag
{
  // If the tag is null, if the tag has no start or end, or if the list of tags is null or
  // empty, we will return null since there is no way another for us to actually check for
  // tag collisions.
  if (tag == nil || [tag LineStart] == nil || [tag LineEnd] == nil || allTags == nil || [allTags count] == 0)
  {
    return nil;
  }

  // Scenarios.  Tag 1 is an existing tag in the code file, Tag 2 represents the new tag that would be
  //   passed to this method as the tag parameter.

  // 0. No overlap
  //    [ - Tag 1 - ]
  //                 [ - Tag 2 - ]
  BOOL allTagsOutside = TRUE;
  for (int index = 0; index < [allTags count]; index++) {
    
    //NSLog(@"TAG %@ with start/end [%@ , %@]", [tag Name], [tag LineStart], [tag LineEnd]);
    //NSLog(@"COMPARING TO TAG %@ with start/end [%@ , %@]", [[allTags objectAtIndex:index] Name], [[allTags objectAtIndex:index] LineStart], [[allTags objectAtIndex:index] LineEnd]);
    allTagsOutside = allTagsOutside && [self TagsOutsideEachOther:[allTags objectAtIndex:index] tag2:tag];
    //NSLog(@"RESULT %d", allTagsOutside);
  }
  if (allTagsOutside == TRUE) {
    return [[STTagCollisionResult alloc] init:nil collision:NoOverlap];
  }

  for (int index = 0; index < [allTags count]; index++) {
    STTag* arrayTag = [allTags objectAtIndex:index];
    STTagCollisionResult *result = [self DetectTagCollision:tag tag2:arrayTag];
    if (result != nil) {
      return result;
    }
//    // 1. Overlaps exact
//    //    [ - Tag 1 - ]
//    //    [ - Tag 2 - ]
//    if ([self TagsOverlapExact:arrayTag tag2:tag]) {
//      return [[STTagCollisionResult alloc] init:arrayTag collision:OverlapsExact];
//    }
//    // 2. Embedded within
//    //     [ --- Tag 1 --- ]
//    //       [ - Tag 2 - ]
//    // Note the order of parameters here, we want to see if our new tag (tag) is embedded within an existing tag (x)
//    else if ([self TagEmbeddedWithin:tag tag2:arrayTag]) {
//      return [[STTagCollisionResult alloc] init:arrayTag collision:EmbeddedWithin];
//    }
//    // 3. Overlap front
//    //       [ - Tag 1 - ]
//    //    [ -- Tag 2 -- ]
//    else if ([self TagOverlapsFront:tag tag2:arrayTag]) {
//      return [[STTagCollisionResult alloc] init:arrayTag collision:OverlapsFront];
//    }
//    // 4. Overlap back
//    //    [ - Tag 1 - ]
//    //         [ - Tag 2 - ]
//    else if ([self TagOverlapsBack:tag tag2:arrayTag]) {
//      return [[STTagCollisionResult alloc] init:arrayTag collision:OverlapsBack];
//    }
//    // 5. Embeds
//    //       [ - Tag 1 - ]
//    //     [ --- Tag 2 --- ]
//    // Note the order of parameters here, we want to see if an existing tag (x) is embedded within our new tag (tag)
//    // Said another way, we check if our new tag (tag) embeds an existing tag (x) within it
//    else if ([self TagEmbeddedWithin:arrayTag tag2:tag]) {
//      return [[STTagCollisionResult alloc] init:arrayTag collision:Embeds];
//    }
  }

  return nil;
}

+(STTagCollisionResult*) DetectTagCollision:(STTag*)tag
{
  // If the tag is null, if the tag has no code file reference, if the code file has no
  // tags collection, or if the tag has no start or end set we will return null since there
  // is no way another for us to actually check for tag collisions.
  if (tag == nil || [tag LineStart] == nil || [tag LineEnd] == nil ||
      [tag CodeFile] == nil || [[tag CodeFile] Tags] == nil) {
    return nil;
  }

  // We know that we have a tag file that's linked up.  So now, check to see if there are
  // any other code files.  If not, we have no overlap.
  NSArray *allTags = [[tag CodeFile] Tags];
  if ([allTags count] == 0) {
    return nil;
  }

  return [self DetectTagCollision:allTags tag:tag];
}

// Convert a tag name to something we know can be used in a file name.  Any character not allowed
// (we're conservative, and are just allowing letters, digits, whitespace, dash and underscore)
// is stripped entirely, not replaced with anything.
+(NSString*) TagNameAsFileName:(STTag*)tag
{
  if (tag == nil || [STGeneralUtil IsStringNullOrEmpty:[tag Name]]) {
    return @"";
  }
  
  NSMutableCharacterSet* validCharacters = [[NSCharacterSet alphanumericCharacterSet] mutableCopy];
  [validCharacters addCharactersInString:@" _-"];
  NSCharacterSet* invalidCharacters = [validCharacters invertedSet];
  return [[[[tag Name] componentsSeparatedByCharactersInSet:invalidCharacters] componentsJoinedByString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
