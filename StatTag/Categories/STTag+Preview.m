//
//  STTag+Preview.m
//  StatTag
//
//  Created by Eric Whitley on 10/8/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTag+Preview.h"
#import "TagPreviewController.h"

@implementation STTag (Preview)


-(NSString*)textPreview {
//  return @"";
  return [TagPreviewController generatePreviewTextFromTag:self];
}

-(NSImage*)imagePreview {
  NSRect rect = NSMakeRect(0, 0, 50, 50);
  return [TagPreviewController generatePreviewImageFromTag:self forRect:rect];
}


@end
