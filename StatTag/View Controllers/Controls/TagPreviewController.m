//
//  TagPreviewController.m
//  StatTag
//
//  Created by Eric Whitley on 10/6/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagPreviewController.h"
#import "StatTag.h"
#import "TagGridView.h"
#import "StatTagShared.h"

@interface TagPreviewController ()

@end

@implementation TagPreviewController

static void *TagTypeContext = &TagTypeContext;
static void *TagTableFormatColumnNamesContext = &TagTableFormatColumnNamesContext;
static void *TagTableFormatRowNamesContext = &TagTableFormatRowNamesContext;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
}

-(void)viewDidAppear {
  [self generatePreviewImage];
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
            context:TagTableFormatColumnNamesContext];
  [self addObserver:self
         forKeyPath:@"tag.TableFormat.IncludeRowNames"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagTableFormatRowNamesContext];

}

-(void) stopObservingTagChanges {
  [self removeObserver:self
               forKeyPath:@"tag.Type"
                  context:TagTypeContext];
  [self removeObserver:self
            forKeyPath:@"tag.TableFormat.IncludeColumnNames"
               context:TagTableFormatColumnNamesContext];
  [self removeObserver:self
            forKeyPath:@"tag.TableFormat.IncludeRowNames"
               context:TagTableFormatRowNamesContext];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  //https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOBasics.html
  
  if (context == TagTypeContext) {
    NSLog(@"tag type changed");
    [self generatePreviewImage];
  } else if (context == TagTableFormatColumnNamesContext || context == TagTableFormatRowNamesContext ) {
    NSLog(@"column or row changed");
    [self generatePreviewImage];
  } else {
    // Any unrecognized context must belong to super
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
  }
}

-(void)generatePreviewImage {
  
  NSImage* preview;
  
  if([[self tag] Type] == [STConstantsTagType Table]) {
    TagGridView* grid = [[TagGridView alloc] initWithFrame:[[self previewImageView] bounds]];
    grid.useColumnLabels = [[[self tag] TableFormat] IncludeColumnNames];
    grid.useRowLabels = [[[self tag] TableFormat] IncludeRowNames];
    //FIXME: move color
    grid.headerFillColor = [StatTagShared colorFromRGBRed:0 green:125 blue:255 alpha:1.0];
    preview = [[NSImage alloc] initWithData:[grid dataWithPDFInsideRect:[grid bounds]]];
  } else if ([[self tag] Type] == [STConstantsTagType Figure]) {
    //FIXME: move property

    preview = [[NSImage alloc] initWithContentsOfFile:[[self tag] FormattedResult]];
    if(preview == nil) {
      //if we can't access our original image (or we can't interpret the format)
      // then just use the default placeholder image
      preview = [NSImage imageNamed:@"figure_preview"]; //move this to a property later
    }
  }
  
  if(preview) {
    _previewImage = preview;
    [self setShowsPreviewImage:YES];
    self.previewImageView.image = _previewImage;
  } else {
    //we can't show anything, so don't
    [self setShowsPreviewImage:NO];
    //[self setValue:[NSNumber numberWithInt:NO] forKey:@"self.showsPreviewImage"];
  }
  
}

@end
