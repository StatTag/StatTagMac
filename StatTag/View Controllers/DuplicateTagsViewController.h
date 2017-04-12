//
//  DuplicateTagsViewController.h
//  StatTag
//
//  Created by Eric Whitley on 4/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <StatTagFramework/STDuplicateTagResults.h>
#import "DuplicateTagGroupEntry.h"
#import "TagEditorViewController.h"
//#import "STDuplicateTagResults.h"
@class STDocumentManager;
@class STTag;
@class TagCodePeekViewController;

@interface DuplicateTagsViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, TagEditorViewControllerDelegate, NSPopoverDelegate>
{
  STDocumentManager* _documentManager;
  STDuplicateTagResults* _duplicateTags;
  NSArray<DuplicateTagGroupEntry*>* _tagGroupEntries;
  NSString* _peekTitle;
}

@property (strong, nonatomic) STDocumentManager* documentManager;

@property (strong, nonatomic)STDuplicateTagResults* duplicateTags;
@property (strong, nonnull)NSArray<DuplicateTagGroupEntry*>* tagGroupEntries;

@property (weak) IBOutlet NSTableView* duplicateTagTableView;



@property (strong) IBOutlet TagCodePeekViewController *popoverViewController;

@property (strong) IBOutlet NSPopover *popoverView;


@property (strong, nonatomic) NSString* peekTitle;


@end
