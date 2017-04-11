//
//  STTag+STTag_TagContent.m
//  StatTag
//
//  Created by Eric Whitley on 4/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "STTag+TagContent.h"

@implementation STTag (TagContent)

-(NSString*)tagContent
{
  NSString* tagContent;
  if([self LineStart] != nil && [self LineEnd] != nil)
  {
    //NSString* linePreview;
    NSArray<NSString*>* content = [[self CodeFile] Content];
    
    NSInteger startIndex = [[self LineStart] integerValue] + 1; //begin tag line
    NSInteger endIndex = [[self LineEnd] integerValue] ; //end tag line
    NSInteger rows = endIndex - startIndex;
    if([content count] > 0 && rows >= 0)
    {
      NSInteger count = MIN( [content count] - startIndex, rows );
      NSArray<NSString*>* contentRows = [content subarrayWithRange: NSMakeRange( startIndex, count )];
      tagContent = [contentRows componentsJoinedByString:@"\n"];
    }
  }
  return tagContent;
}

@end
