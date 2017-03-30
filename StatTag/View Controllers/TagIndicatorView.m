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

-(instancetype)initWithType:(TagIndicatorViewTagType)tagType andLabel:(NSString*)label
{
  self = [super init];
  if(self){
    [self setTagType:tagType];
    [[self tagLabel] setStringValue:label];
  }
  return self;
}


-(void)setTagType:(TagIndicatorViewTagType)tagType
{
  _tagType = tagType;
  [self setTagFormat];
}
-(TagIndicatorViewTagType)tagType
{
  return _tagType;
}

-(void)setTagFormat
{
  switch(_tagType)
  {
    case TagIndicatorViewTagTypeNormal:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor blueColor]]];
      break;
    case TagIndicatorViewTagTypeWarning:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor orangeColor]]];
      break;
    case TagIndicatorViewTagTypeError:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor redColor]]];
      break;
    default:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor blueColor]]];
      break;
  }
}

//tinting
+ (NSImage *)colorImage:(NSImage*)image forTagIndicatorViewTagType:(TagIndicatorViewTagType)type
{
  NSImage* copiedImage;
  switch(type)
  {
    case TagIndicatorViewTagTypeNormal:
      copiedImage = [[self class] colorImage:image withTint:[NSColor greenColor]];
      break;
    case TagIndicatorViewTagTypeWarning:
      copiedImage = [[self class] colorImage:image withTint:[NSColor orangeColor]];
      break;
    case TagIndicatorViewTagTypeError:
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
