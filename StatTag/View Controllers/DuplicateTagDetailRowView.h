//
//  DuplicateTagDetailRowView.h
//  StatTag
//
//  Created by Eric Whitley on 4/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DuplicateTagDetailRowView : NSTableCellView

@property (assign) IBOutlet NSTextField *tagName;
@property (assign) IBOutlet NSTextField *tagType;
@property (assign) IBOutlet NSTextField *tagLines;
@property (assign) IBOutlet NSTextView *tagContent;


@end
