//
//  TagPreviewController.h
//  StatTag
//
//  Created by Eric Whitley on 10/6/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STTag;

@interface TagPreviewController : NSViewController {
  STTag* _tag;
}

@property STTag* tag;

@property (weak) IBOutlet NSTextField *formatLabel;

@property (weak) IBOutlet NSTextField *previewText;
@property (weak) IBOutlet NSImageView *previewImageView;

@property BOOL showsPreviewText;
@property BOOL showsPreviewImage;
@property (strong, nonatomic) NSImage* previewImage;

@property (strong, nonatomic) NSString* previewString;

+(NSString*)generatePreviewTextFromTag:(STTag*)tag;
+(NSImage*)generatePreviewImageFromTag:(STTag*)tag forRect:(NSRect)rect;

@end
