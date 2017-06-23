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
#import "DuplicateTagRenameViewController.h"

//#import "STDuplicateTagResults.h"
@class STDocumentManager;
@class STTag;
@class TagCodePeekViewController;

@class DuplicateTagsViewController;
@protocol DuplicateTagManagerDelegate <NSObject>
-(void)duplicateTagsDidChange:(nonnull DuplicateTagsViewController*)controller;
@end

@interface DuplicateTagsViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, DuplicateTagRenameViewControllerDelegate, NSPopoverDelegate>
{
  STDocumentManager* _documentManager;
  STDuplicateTagResults* _duplicateTags;
  NSArray<DuplicateTagGroupEntry*>* _tagGroupEntries;
  NSString* _peekTitle;
}


@property (nonatomic, weak, nullable) id<DuplicateTagManagerDelegate> delegate;

@property (strong, nonatomic, nonnull) STDocumentManager* documentManager;

@property (strong, nonatomic, nonnull)STDuplicateTagResults* duplicateTags;
@property (strong, nonnull)NSArray<DuplicateTagGroupEntry*>* tagGroupEntries;

@property (weak, nullable) IBOutlet NSTableView* duplicateTagTableView;



@property (strong, nonnull) IBOutlet TagCodePeekViewController *popoverViewController;
@property (strong, nonnull) IBOutlet NSPopover *popoverView;
@property (strong, nonatomic, nonnull) NSString* peekTitle;


@end
