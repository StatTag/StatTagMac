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


@end
