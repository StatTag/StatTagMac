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

+(NSColor*)greenColor
{
//  return [StatTagShared colorFromRGBRed:15.0 green:224 blue:57.0 alpha:1.0];
  return [StatTagShared colorFromRGBRed:1 green:196 blue:40 alpha:1.0];
}

+(NSColor*)textColorForTagIndicatorViewTagStyle:(TagIndicatorViewTagStyle)style
{
  switch(style)
  {
    case TagIndicatorViewTagStyleNormal:
      return [NSColor blackColor];
      break;
    case TagIndicatorViewTagStyleWarning:
      return [NSColor whiteColor];
      break;
    case TagIndicatorViewTagStyleError:
      return [NSColor whiteColor];
      break;
    case TagIndicatorViewTagStyleLoading:
      return [NSColor blackColor];
      break;
    default:
      return [NSColor blackColor];
      break;
  }
}

//tinting
+ (NSImage *)colorImage:(NSImage*)image forTagIndicatorViewTagStyle:(TagIndicatorViewTagStyle)style
{
  NSImage* copiedImage;
  switch(style)
  {
    case TagIndicatorViewTagStyleNormal:
      copiedImage = [[self class] colorImage:image withTint:[[self class] greenColor]];
      break;
    case TagIndicatorViewTagStyleWarning:
      copiedImage = [[self class] colorImage:image withTint:[NSColor orangeColor]];
      break;
    case TagIndicatorViewTagStyleError:
      copiedImage = [[self class] colorImage:image withTint:[NSColor redColor]];
      break;
    case TagIndicatorViewTagStyleLoading:
      copiedImage = [[self class] colorImage:image withTint:[NSColor grayColor]];
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
