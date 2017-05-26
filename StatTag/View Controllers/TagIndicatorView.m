//
//  TagIndicatorView.m
//  StatTag
//
//  Created by Eric Whitley on 3/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "TagIndicatorView.h"

@interface TagIndicatorView ()

@end


@implementation TagIndicatorView

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
*/

-(instancetype)init
{
  self = [super init];
  if(self){
    
  }
  return self;
}

-(instancetype)initWithType:(TagIndicatorViewTagStyle)tagStyle andLabel:(NSString*)label
{
  self = [super init];
  if(self){
    [self setTagStyle:tagStyle];
    [[self tagLabel] setStringValue:label];
  }
  return self;
}


-(void)setTagStyle:(TagIndicatorViewTagStyle)tagStyle
{
  _tagStyle = tagStyle;
  [self setTagFormat];
}
-(TagIndicatorViewTagStyle)tagStyle
{
  return _tagStyle;
}

-(void)setTagFormat
{
  switch(_tagStyle)
  {
    case TagIndicatorViewTagStyleNormal:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor blueColor]]];
      break;
    case TagIndicatorViewTagStyleWarning:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor orangeColor]]];
      break;
    case TagIndicatorViewTagStyleError:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor redColor]]];
      break;
    default:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor blueColor]]];
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
