//
//  DocumentBrowserViewController.h
//  StatTag
//
//  Created by Eric Whitley on 3/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DocumentBrowserCodeFilesViewController.h"

@class DocumentBrowserDocumentViewController;


@interface DocumentBrowserViewController : NSViewController <NSTableViewDelegate, DocumentBrowserCodeFilesDelegate> {
  STDocumentManager* _documentManager;
}

@property (strong, nonatomic) STDocumentManager* documentManager;

//left-hand documents list
@property (strong) IBOutlet NSArrayController *documentsArrayController;
@property (weak) IBOutlet NSTableView *documentsTableView;

//right document view
@property (strong) IBOutlet DocumentBrowserDocumentViewController *documentBrowserDocumentViewController;
@property (weak) IBOutlet NSView *documentBrowserDocumentView;


@end
