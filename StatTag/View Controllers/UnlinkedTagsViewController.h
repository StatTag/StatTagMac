//
//  UnlinkedTagsViewController.h
//  StatTag
//
//  Created by Eric Whitley on 3/30/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STTag;
@class STDocumentManager;

@interface UnlinkedTagsViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
{
  NSMutableArray<STTag*>* _unlinkedTagsArray;
  NSDictionary<NSString*, NSArray<STTag*>*>* _unlinkedTags;
}


@property (strong) IBOutlet NSArrayController *unlinkedTagsArrayController;

@property (weak) IBOutlet NSTableView *unlinkedTagsTableView;



@property (strong, nonatomic) NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags;
@property (strong, nonatomic) NSMutableArray<STTag*>* unlinkedTagsArray;



@end
