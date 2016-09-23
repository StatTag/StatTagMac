//
//  UpdateOutputViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class STTag;
@class STDocumentManager;

IB_DESIGNABLE

@interface UpdateOutputViewController : NSViewController {
  __weak NSTextField *labelOnDemandSearchText;
  __weak NSButton *buttonOnDemandSelectAll;
  __weak NSButton *buttonOnDemandSelectNone;
  __weak NSTableView *tableViewOnDemand;
  __weak NSButton *buttonRefresh;
  __weak NSButton *buttonCancel;
  NSArrayController *onDemandTags;
  NSMutableArray<STTag*>* _documentTags;
  
  STDocumentManager* _documentManager;

}

@property (weak) IBOutlet NSTextField *labelOnDemandSearchText;
@property (weak) IBOutlet NSButton *buttonOnDemandSelectAll;
@property (weak) IBOutlet NSButton *buttonOnDemandSelectNone;
@property (weak) IBOutlet NSTableView *tableViewOnDemand;
@property (weak) IBOutlet NSButton *buttonRefresh;

@property (strong) IBOutlet NSArrayController *onDemandTags;

@property (strong, nonatomic) STDocumentManager* documentManager;

@property (strong, nonatomic) NSMutableArray<STTag*>* documentTags;


@end
