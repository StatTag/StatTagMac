//
//  TagIndicatorView.h
//  StatTag
//
//  Created by Eric Whitley on 3/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DocumentBrowserTagSummary.h"

// ClassB.h


@interface TagIndicatorView : NSTableCellView {
  TagIndicatorViewTagStyle _tagStyle;
}

@property (weak) IBOutlet NSImageView *tagImageView;
@property (weak) IBOutlet NSTextField *tagLabel;

@property TagIndicatorViewTagStyle tagStyle;
-(instancetype)initWithStyle:(TagIndicatorViewTagStyle)tagStyle andLabel:(NSString*)label;
+ (NSImage *)colorImage:(NSImage*)image forTagIndicatorViewTagStyle:(TagIndicatorViewTagStyle)style;

+ (NSImage *)colorImage:(NSImage*)image withTint:(NSColor *)tint;


@end
