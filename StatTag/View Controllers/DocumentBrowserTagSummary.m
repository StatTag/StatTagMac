//
//  DocumentBrowserTagSummary.m
//  StatTag
//
//  Created by Eric Whitley on 3/28/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "DocumentBrowserTagSummary.h"

@implementation DocumentBrowserTagSummary

@synthesize tagGroupTitle = _tagGroupTitle;
@synthesize tagStyle = _tagStyle;
@synthesize tagCount = _tagCount;


-(instancetype)init {
  self = [super init];
  if(self){
    _tagGroupTitle = [[NSString alloc] init];
    _tagStyle = TagIndicatorViewTagStyleNormal;
    _tagCount = 0;
  }
  return self;
}

-(instancetype)initWithTitle:(NSString*)title andStyle:(TagIndicatorViewTagStyle)style withFocus:(TagIndicatorViewTagFocus)focus andCount:(NSInteger)count {
  self = [super init];
  if(self){
    _tagStyle = style;
    _tagGroupTitle = title;
    _tagFocus = focus;
    _tagCount = count;
  }
  return self;
}


//tinting
+ (NSImage *)colorImage:(NSImage*)image forTagIndicatorViewTagStyle:(TagIndicatorViewTagStyle)style
{
  NSImage* copiedImage;
  switch(style)
  {
    case TagIndicatorViewTagStyleNormal:
      copiedImage = [[self class] colorImage:image withTint:[NSColor greenColor]];
      break;
    case TagIndicatorViewTagStyleWarning:
      copiedImage = [[self class] colorImage:image withTint:[NSColor orangeColor]];
      break;
    case TagIndicatorViewTagStyleError:
      copiedImage = [[self class] colorImage:image withTint:[NSColor redColor]];
      break;
    default:
      copiedImage = [[self class] colorImage:image withTint:[NSColor blueColor]];
      break;
  }
  
  return copiedImage;
}


+ (NSImage *)colorImage:(NSImage*)image withTint:(NSColor *)tint
{
  NSSize size = [image size];
  NSRect imageBounds = NSMakeRect(0, 0, size.width, size.height);
  
  NSImage *copiedImage = [image copy];
  
  [copiedImage lockFocus];
  
  [tint set];
  NSRectFillUsingOperation(imageBounds, NSCompositeSourceAtop);
  
  [copiedImage unlockFocus];
  
  return copiedImage;
}


@end
