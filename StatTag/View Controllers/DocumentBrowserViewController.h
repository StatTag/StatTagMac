//
//  DocumentBrowserViewController.h
//  StatTag
//
//  Created by Eric Whitley on 3/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DocumentBrowserCodeFilesViewController.h"

@class DocumentBrowserCodeFilesViewController;
@class UnlinkedTagsViewController;

@interface DocumentBrowserViewController : NSViewController <NSTableViewDelegate, DocumentBrowserCodeFilesDelegate> {
  STDocumentManager* _documentManager;
}

@property (strong, nonatomic) STDocumentManager* documentManager;

@property (strong) IBOutlet NSArrayController *documentsArrayController;

@property (weak) IBOutlet NSTableView *documentsTableView;

@property (strong) IBOutlet DocumentBrowserCodeFilesViewController *codeFilesViewController;
@property (weak) IBOutlet NSView *codeFilesView;


@property (weak) IBOutlet NSView *focusView;

@property (strong) IBOutlet UpdateOutputViewController *tagListViewController;


@property (strong) IBOutlet UnlinkedTagsViewController *unlinkedTagsViewController;



@end
