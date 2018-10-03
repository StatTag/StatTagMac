//
//  OverlapingTagsViewController.h
//  StatTag
//
//  Created by Luke Rasmussen on 9/19/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <StatTagFramework/STOverlappingTagResults.h>
#import "OverlappingTagGroupEntry.h"

@class STDocumentManager;
@class STTag;
@class TagCodePeekViewController;

@class OverlappingTagsViewController;
@protocol OverlappingTagManagerDelegate <NSObject>
-(void)overlappingTagsDidChange:(nonnull OverlappingTagsViewController*)controller;
@end

@interface OverlappingTagsViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, NSPopoverDelegate>
{
  STDocumentManager* _documentManager;
  STOverlappingTagResults* _overlappingTags;
  NSArray<OverlappingTagGroupEntry*>* _tagGroupEntries;
  NSString* _peekTitle;
}

@property (nonatomic, weak, nullable) id<OverlappingTagManagerDelegate> delegate;

@property (strong, nonatomic, nonnull) STDocumentManager* documentManager;

@property (strong, nonatomic, nonnull)STOverlappingTagResults* overlappingTags;
@property (strong, nonnull)NSArray<OverlappingTagGroupEntry*>* tagGroupEntries;

@property (weak, nullable) IBOutlet NSTableView* overlappingTagTableView;


@property (strong, nonnull) IBOutlet TagCodePeekViewController *popoverViewController;
@property (strong, nonnull) IBOutlet NSPopover *popoverView;
@property (strong, nonatomic, nonnull) NSString* peekTitle;


@end
