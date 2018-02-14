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

@synthesize isLoading = _isLoading;

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
*/

//fixme a LOT of this should be done lazily and stored. We're dynamically recreating images on the fly here (bad)

-(instancetype)init
{
  NSLog(@"lading TagIndicatorView - init()");
  self = [super init];
  if(self){
    
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
}

-(instancetype)initWithStyle:(TagIndicatorViewTagStyle)tagStyle andLabel:(NSString*)label
{
  NSLog(@"lading TagIndicatorView - initWithStyle()");

  self = [super init];
  if(self){
    [self setTagStyle:tagStyle];
    [[self tagLabel] setStringValue:label];
  }
  return self;
}

-(BOOL)isLoading
{
  return _isLoading;
}

-(void)setIsLoading:(BOOL)loading;
{
  _isLoading = loading;
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
    case TagIndicatorViewTagStyleUnlinked:
      [[self tagImageView] setImage:[[self class] colorImage:[[self unlinkedTagImageView] image] withTint:[NSColor blueColor]]];
      break;
    default:
      [[self tagImageView] setImage:[[self class] colorImage:[[self tagImageView] image] withTint:[NSColor blueColor]]];
      break;
  }
  [[self unlinkedTagImageView] setHidden:TRUE];
}

//+ (nonnull NSColor*)colorFromRGBRed:(CGFloat)r  green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;
+(NSColor*)greenColor
{
  return [StatTagShared colorFromRGBRed:30.0 green:206.0 blue:66.0 alpha:1.0];
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
