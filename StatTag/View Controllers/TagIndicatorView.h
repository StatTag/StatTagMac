//
//  TagIndicatorView.h
//  StatTag
//
//  Created by Eric Whitley on 3/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// ClassB.h
typedef enum {
  TagIndicatorViewTagTypeNormal,
  TagIndicatorViewTagTypeWarning,
  TagIndicatorViewTagTypeError
} TagIndicatorViewTagType;


@interface TagIndicatorView : NSTableCellView {
  TagIndicatorViewTagType _tagType;
}

@property (weak) IBOutlet NSImageView *tagImageView;
@property (weak) IBOutlet NSTextField *tagLabel;

@property TagIndicatorViewTagType tagType;
-(instancetype)initWithType:(TagIndicatorViewTagType)tagType andLabel:(NSString*)label;
+ (NSImage *)colorImage:(NSImage*)image forTagIndicatorViewTagType:(TagIndicatorViewTagType)type;

+ (NSImage *)colorImage:(NSImage*)image withTint:(NSColor *)tint;


@end
