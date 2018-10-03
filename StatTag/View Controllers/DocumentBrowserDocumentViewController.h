//
//  DocumentBrowserDocumentViewController.h
//  StatTag
//
//  Created by Eric Whitley on 4/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DocumentBrowserCodeFilesViewController.h"
#import <StatTagFramework/STDuplicateTagResults.h>
#import <StatTagFramework/STOverlappingTagResults.h>


#import "DuplicateTagsViewController.h"
#import "UpdateOutputViewController.h"
#import "UnlinkedTagsViewController.h"
#import "OverlappingTagsViewController.h"


@class STMSWord2011Document;
@class STDocumentManager;
@class STCodeFile;
@class DocumentBrowserCodeFilesViewController;
@class UnlinkedTagsViewController;
@class DuplicateTagsViewController;
@class OverlappingTagsViewController;
@class STTag;
//@protocol DuplicateTagManagerDelegate;
//@protocol UnlinkedTagsManagerDelegate;
//@protocol AllTagsDelegate;

//@class DocumentBrowserDocumentViewController;
//@protocol DocumentBrowserDocumentDelegate <NSObject>
//-(void)startMonitoringCodeFiles;
//-(void)stopMonitoringCodeFiles;
//@end


@interface DocumentBrowserDocumentViewController : NSViewController <DocumentBrowserCodeFilesDelegate, DuplicateTagManagerDelegate, UnlinkedTagsManagerDelegate, AllTagsDelegate>
{
  STMSWord2011Document* _document;
  STDocumentManager* _documentManager;
  
  NSMutableArray<STTag*>* _tags;
  STDuplicateTagResults* _duplicateTags;
  NSDictionary<NSString*, NSArray<STTag*>*>* _unlinkedTags;
  STOverlappingTagResults* _overlappingTags;
}

@property (nonatomic, strong) STMSWord2011Document* document;
@property (strong, nonatomic) STDocumentManager* documentManager;


@property (strong) IBOutlet DocumentBrowserCodeFilesViewController *codeFilesViewController;
@property (weak) IBOutlet NSView *codeFilesView;
@property (weak) IBOutlet NSView *focusView;
@property (strong) IBOutlet UpdateOutputViewController *tagListViewController;
@property (strong) IBOutlet UnlinkedTagsViewController *unlinkedTagsViewController;
@property (strong) IBOutlet DuplicateTagsViewController *duplicateTagsViewController;
@property (strong) IBOutlet OverlappingTagsViewController *overlappingTagsViewController;

@property (strong, nonatomic)NSMutableArray<STTag*>* tags;
@property (strong, nonatomic)STDuplicateTagResults* duplicateTags;
@property (strong, nonatomic)NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags;
@property (strong, nonatomic)STOverlappingTagResults* overlappingTags;

-(void)startMonitoringCodeFiles;
-(void)stopMonitoringCodeFiles;

-(void)focusOnTags;

/**
 Used by AppleScript to edit the identified tag
 */
-(void)openTagForEditingByName:(NSString*)tagName orID:(NSString*)tagID;
@end
