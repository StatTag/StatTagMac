//
//  DocumentBrowserDocumentViewController.h
//  StatTag
//
//  Created by Eric Whitley on 4/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DocumentBrowserCodeFilesViewController.h"

@class STMSWord2011Document;
@class STDocumentManager;
@class STCodeFile;
@class DocumentBrowserCodeFilesViewController;
@class UnlinkedTagsViewController;
@class DuplicateTagsViewController;
@class STTag;
@class STDuplicateTagResults;

@interface DocumentBrowserDocumentViewController : NSViewController <DocumentBrowserCodeFilesDelegate>
{
  STMSWord2011Document* _document;
  STDocumentManager* _documentManager;
  
  NSMutableArray<STTag*>* _tags;
  STDuplicateTagResults* _duplicateTags;
  NSDictionary<NSString*, NSArray<STTag*>*>* _unlinkedTags;
}

@property (nonatomic, strong) STMSWord2011Document* document;
@property (strong, nonatomic) STDocumentManager* documentManager;


@property (strong) IBOutlet DocumentBrowserCodeFilesViewController *codeFilesViewController;
@property (weak) IBOutlet NSView *codeFilesView;
@property (weak) IBOutlet NSView *focusView;
@property (strong) IBOutlet UpdateOutputViewController *tagListViewController;
@property (strong) IBOutlet UnlinkedTagsViewController *unlinkedTagsViewController;
@property (strong) IBOutlet DuplicateTagsViewController *duplicateTagsViewController;


@property (strong, nonatomic)NSMutableArray<STTag*>* tags;
@property (strong, nonatomic)STDuplicateTagResults* duplicateTags;
@property (strong, nonatomic)NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags;


-(void)focusOnTags;

/**
 Used by AppleScript to edit the identified tag
 */
-(void)openTagForEditing:(NSString*)tagName;
@end
