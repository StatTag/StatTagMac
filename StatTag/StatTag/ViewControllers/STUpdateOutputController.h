//
//  STUpdateOutputController.h
//  StatTag
//
//  Created by Eric Whitley on 8/4/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface STUpdateOutputController : NSWindowController {
  __weak NSTextField *labelOnDemandSearchText;
  __weak NSButton *buttonOnDemandSelectAll;
  __weak NSButton *buttonOnDemandSelectNone;
  __weak NSTableView *tableViewOnDemand;
  __weak NSButton *buttonRefresh;
  __weak NSButton *buttonCancel;
}

@property (weak) IBOutlet NSTextField *labelOnDemandSearchText;
@property (weak) IBOutlet NSButton *buttonOnDemandSelectAll;
@property (weak) IBOutlet NSButton *buttonOnDemandSelectNone;
@property (weak) IBOutlet NSTableView *tableViewOnDemand;
@property (weak) IBOutlet NSButton *buttonRefresh;
@property (weak) IBOutlet NSButton *buttonCancel;


- (void)windowWillClose:(NSNotification*)notification;
- (void)windowDidBecomeKey:(NSNotification*)notification;


@end
