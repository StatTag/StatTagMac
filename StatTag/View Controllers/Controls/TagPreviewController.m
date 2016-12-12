//
//  TagPreviewController.m
//  StatTag
//
//  Created by Eric Whitley on 10/6/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagPreviewController.h"
#import "StatTagFramework.h"
#import "TagGridView.h"
#import "StatTagShared.h"

@interface TagPreviewController ()

@end

@implementation TagPreviewController

static void *TagTypeContext = &TagTypeContext;
static void *TagFormatContext = &TagFormatContext;
static void *TagTableFormatContext = &TagTableFormatContext;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
}

-(void)viewDidAppear {
  [self generatePreviewImage];
  [self generatePreviewText];
  [self startObservingTagChanges];
}

//graph preview
/**
 1) colum headers?
 2) row headers?
 */

-(void) dealloc {
  [self stopObservingTagChanges];
}

-(void) startObservingTagChanges {
  [self addObserver:self
            forKeyPath:@"tag.Type"
               options:(NSKeyValueObservingOptionNew |
                        NSKeyValueObservingOptionOld)
               context:TagTypeContext];

  [self addObserver:self
         forKeyPath:@"tag.TableFormat.IncludeColumnNames"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagTableFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.TableFormat.IncludeRowNames"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagTableFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.ValueFormat.DecimalPlaces"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.ValueFormat.UseThousands"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.ValueFormat.DateFormat"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.ValueFormat.TimeFormat"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagFormatContext];

}

-(void) stopObservingTagChanges {
  [self removeObserver:self
               forKeyPath:@"tag.Type"
                  context:TagTypeContext];
  [self removeObserver:self
            forKeyPath:@"tag.TableFormat.IncludeColumnNames"
               context:TagTableFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.TableFormat.IncludeRowNames"
               context:TagTableFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.ValueFormat.DecimalPlaces"
               context:TagFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.ValueFormat.UseThousands"
               context:TagFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.ValueFormat.DateFormat"
               context:TagFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.ValueFormat.TimeFormat"
               context:TagFormatContext];

}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  //https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOBasics.html
  
  if (context == TagTypeContext || context == TagTableFormatContext) {
    //we don't want to regenerate images for just "text" changes, so catch this up here
    [self generatePreviewText];
    [self generatePreviewImage];
  } else if (context == TagFormatContext) {
    [self generatePreviewText];
    //[self generatePreviewImage]; //explicitly commenting this out so we remember to NOT do this
    //we don't need to regenerate the table if we only changed text stuff
  } else {
    // Any unrecognized context must belong to super
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
  }
}

+(NSString*)generatePreviewTextFromTag:(STTag*)tag {
  
  NSString* previewText;
  
  if([[[tag ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType Numeric]] ) {
    NSString* result = [[[tag CachedResult] lastObject] ValueResult];
    if(result == nil) {
      result = @"100000";
    }
    
    previewText = [[tag ValueFormat] Format:result];
  }
  else if([[[tag ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType DateTime]] ) {
    previewText = [[tag ValueFormat] Format:@"March 14, 2001 19:30:50"];
  }
  else if([[[tag ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType Percentage]] ) {
    NSString* result = [[[tag CachedResult] lastObject] ValueResult];
    if(result == nil) {
      result = @"1";
    }
    previewText = [[tag ValueFormat] Format:result];
  } else {
    previewText = @"(Exactly as Generated)";
  }
  
  return previewText;
  

}

-(void)generatePreviewText {
  
  //FIXME: NOTE this needs to be refactored to move the formatters into the singletone
  //super expensive
  if ([[self tag] Type] == [STConstantsTagType Figure]) {
    [self setShowsPreviewText:NO];
  } else {
    NSString* previewText = [[self class] generatePreviewTextFromTag:[self tag]];
    if(previewText == nil) {
      [self setShowsPreviewText:NO];
    } else {
      [[self previewText] setStringValue:previewText];
      [self setShowsPreviewText:YES];
    }
  }
}

+(NSImage*)generatePreviewImageFromTag:(STTag*)tag forRect:(NSRect)rect {
  
  NSImage* preview;
  
  if([tag Type] == [STConstantsTagType Table]) {
    TagGridView* grid = [[TagGridView alloc] initWithFrame:rect];
    grid.useColumnLabels = [[tag TableFormat] IncludeColumnNames];
    grid.useRowLabels = [[tag TableFormat] IncludeRowNames];
    grid.gridSize = 6;
    //FIXME: move color
    grid.headerFillColor = [StatTagShared colorFromRGBRed:0 green:125 blue:255 alpha:1.0];
    preview = [[NSImage alloc] initWithData:[grid dataWithPDFInsideRect:[grid bounds]]];
  } else if ([tag Type] == [STConstantsTagType Figure]) {
    //FIXME: move property
    //check the latest image result
    preview = [[NSImage alloc] initWithContentsOfFile:[tag FormattedResult]];
    if(preview == nil) {
      //then try the cached result
      preview = [[NSImage alloc] initWithContentsOfFile: [[[tag CachedResult] lastObject] FigureResult]];
    }
    if(preview == nil) {
      //if we can't access our original image (or we can't interpret the format)
      // then just use the default placeholder image
      preview = [NSImage imageNamed:@"figure_preview"]; //move this to a property later
    }
  }
  
  return preview;
  
}

-(void)generatePreviewImage {
  
  NSImage* preview;
  preview = [[self class] generatePreviewImageFromTag:[self tag] forRect:[[self previewImageView] bounds]];
  if(preview) {
    _previewImage = preview;
    [self setShowsPreviewImage:YES];
    self.previewImageView.image = _previewImage;
  } else {
    //we can't show anything, so don't
    [self setShowsPreviewImage:NO];
  }
  
}

@end
