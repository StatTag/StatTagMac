//
//  UnlinkedTagsViewController.h
//  StatTag
//
//  Created by Eric Whitley on 3/30/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "UnlinkedFieldCheckProgressViewController.h"


@class STTag;
@class STDocumentManager;
@class UnlinkedTagGroupEntry;
@class STDocumentManager;

@class UnlinkedTagsViewController;
@protocol UnlinkedTagsManagerDelegate <NSObject>
-(void)unlinkedTagsDidChange:(UnlinkedTagsViewController*)controller;
@end


@interface UnlinkedTagsViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, UnlinkedFieldCheckProgressDelegate>
{
  NSArray<UnlinkedTagGroupEntry*>* _unlinkedTagsArray;
  NSDictionary<NSString*, NSArray<STTag*>*>* _unlinkedTags;
  STDocumentManager* _documentManager;
}

@property (nonatomic, weak) id<UnlinkedTagsManagerDelegate> delegate;


@property (strong) IBOutlet NSArrayController *unlinkedTagsArrayController;

@property (weak) IBOutlet NSTableView *unlinkedTagsTableView;

@property (strong, nonatomic) STDocumentManager* documentManager;

@property (strong, nonatomic) NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags;
@property (strong, nonatomic) NSArray<UnlinkedTagGroupEntry*>* unlinkedTagsArray;


- (IBAction)takeActionOnCodeFile:(id)sender;
- (IBAction)takeActionOnTag:(id)sender;



@end
