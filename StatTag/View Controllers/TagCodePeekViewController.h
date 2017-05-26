//
//  TagCodePeekViewController.h
//  StatTag
//
//  Created by Eric Whitley on 4/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STTag;
@class ScintillaEmbeddedViewController;


@interface TagCodePeekViewController : NSViewController
{
  STTag* _tag;
  ScintillaEmbeddedViewController* _sourceEditor;
}

@property (strong, nonatomic) STTag* tag;

@property (weak) IBOutlet NSTextField *tagCodePreview;

@property (weak) IBOutlet NSTextField *tagLabel;


@property (weak) IBOutlet NSView *sourceView;
@property (strong) IBOutlet ScintillaEmbeddedViewController *sourceEditor;


@end
