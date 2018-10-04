//
//  OverlappingTagsGroupRowView.h
//  StatTag
//
//  Created by Eric Whitley on 4/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatTagFramework/STTag.h"

@interface OverlappingTagsGroupRowView : NSTableCellView

@property (assign) IBOutlet NSTextField *groupName;
@property (assign) IBOutlet NSTextField *codeFileName;
@property (assign) IBOutlet NSPopUpButton *groupActionPopUpList;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* groupPopUpWidth;

@end
