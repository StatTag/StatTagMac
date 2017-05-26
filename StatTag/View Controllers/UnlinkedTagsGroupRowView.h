//
//  UnlinkedTagsGroupRowView.h
//  StatTag
//
//  Created by Eric Whitley on 4/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UnlinkedTagsGroupRowView : NSTableCellView

@property (assign) IBOutlet NSTextField *codeFileName;
@property (assign) IBOutlet NSTextField *codeFilePath;
@property (assign) IBOutlet NSPopUpButton *codeFileActionPopUpList;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* codeFilePopUpWidth;

@end
