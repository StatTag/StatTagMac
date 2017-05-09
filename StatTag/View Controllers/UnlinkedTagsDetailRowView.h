//
//  UnlinkedTagsDetailRowView.h
//  StatTag
//
//  Created by Eric Whitley on 4/12/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UnlinkedTagsDetailRowView : NSTableCellView

@property (assign) IBOutlet NSTextField *tagName;
@property (assign) IBOutlet NSTextField *tagType;
@property (assign) IBOutlet NSPopUpButton *tagActionPopUpList;



@end
