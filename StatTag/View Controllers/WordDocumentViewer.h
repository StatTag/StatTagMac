//
//  WordDocumentViewer.h
//  StatTag
//
//  Created by Eric Whitley on 2/26/19.
//  Copyright © 2019 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatTagShared.h"
#import "STMSWord2011.h"
#import "StatTagWordDocument.h"
#import "WordFieldTreeItem.h"
#import "WordDocProperty.h"

@class WordDocumentViewer;
@protocol WordDocumentViewerDelegate <NSObject>
- (void)dismissWordDocumentViewerController:(WordDocumentViewer*)controller withReturnCode:(StatTagResponseState)returnCode;
@end


@interface WordDocumentViewer : NSViewController <NSTableViewDelegate, NSOutlineViewDelegate> {
  
}

@property StatTagWordDocument* statTagWordDocument;
@property (nonatomic, weak) id<WordDocumentViewerDelegate> delegate;


//properties
@property (weak) IBOutlet NSTableView *propertyListTableView;
@property (unsafe_unretained) IBOutlet NSTextView *propertyContentsTextView;
@property (strong) IBOutlet NSArrayController *propertiesArrayController;


//fields
//@property (weak) IBOutlet NSTableView *documentFieldListTableView;
@property (weak) IBOutlet NSOutlineView *documentFieldListTableView;
@property (unsafe_unretained) IBOutlet NSTextView *fieldContentsTextView;
@property (strong) IBOutlet NSTreeController *fieldsTreeController;


//tag info
@property (weak) IBOutlet NSTableView *tagPropertiesTableView;
@property (strong) IBOutlet NSArrayController *tagPropertiesArrayController;
@property (unsafe_unretained) IBOutlet NSTextView *tagJSONTextView;
@property (unsafe_unretained) IBOutlet NSTextView *cachedResultTextView;


@end
