//
//  DocumentBrowserTagSummary.h
//  StatTag
//
//  Created by Eric Whitley on 3/28/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TagIndicatorView.h"

typedef enum {
  TagIndicatorViewTagStyleNormal,
  TagIndicatorViewTagStyleWarning,
  TagIndicatorViewTagStyleError
} TagIndicatorViewTagStyle;

typedef enum {
  TagIndicatorViewTagFocusAllTags,
  TagIndicatorViewTagFocusUnlinkedTags,
  TagIndicatorViewTagFocusDuplicateTags
} TagIndicatorViewTagFocus;


@interface DocumentBrowserTagSummary : NSObject {
  NSString* _tagGroupTitle;
  TagIndicatorViewTagStyle _tagStyle;
  TagIndicatorViewTagFocus _tagFocus;
}

@property (strong) NSString* tagGroupTitle;
@property TagIndicatorViewTagStyle tagStyle;
@property TagIndicatorViewTagFocus tagFocus;
@property NSInteger tagCount;

-(instancetype)init;
-(instancetype)initWithTitle:(NSString*)title andStyle:(TagIndicatorViewTagStyle)type withFocus:(TagIndicatorViewTagFocus)focus andCount:(NSInteger)count;

+ (NSImage *)colorImage:(NSImage*)image forTagIndicatorViewTagStyle:(TagIndicatorViewTagStyle)style;
+ (NSImage *)colorImage:(NSImage*)image withTint:(NSColor *)tint;


@end
