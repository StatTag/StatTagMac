//
//  DocumentBrowserCodeFilesViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <StatTagFramework/STDuplicateTagResults.h>
#import <StatTagFramework/STOverlappingTagResults.h>
#import "DocumentBrowserTagSummary.h"

@class STCodeFile;
@class STDocumentManager;
@class STMSWord2011Document;

@protocol DocumentBrowserDocumentDelegate;

@class DocumentBrowserCodeFilesViewController;
@protocol DocumentBrowserCodeFilesDelegate <NSObject>
//- (void)selectedCodeFileDidChange:(DocumentBrowserCodeFilesViewController*)controller;
//- (void)selectedTagSummaryDidChange:(DocumentBrowserCodeFilesViewController*)controller;
-(void)codeFilesSetFocusOnTags:(DocumentBrowserCodeFilesViewController*)controller;
-(void)codeFilesSetFocusOnDuplicateTags:(DocumentBrowserCodeFilesViewController*)controller;
-(void)codeFilesSetFocusOnUnlinkedTags:(DocumentBrowserCodeFilesViewController*)controller;
@end

//FIXME: this is a global... we should move this somewhere else managed by the framework
//static NSString* const allowedExtensions_CodeFiles = @"do/DO";

@interface DocumentBrowserCodeFilesViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
  NSArrayController *arrayController;
  __weak NSTableView *fileTableView;
  
  NSMutableArray<STCodeFile*>* _codeFiles;
  STDocumentManager* _documentManager;
  NSArrayController *tagSummaryArrayController;
}
@property (weak) IBOutlet NSTableView *fileTableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong, nonatomic) NSMutableArray<STCodeFile*>* codeFiles;
@property (strong, nonatomic) STDocumentManager* documentManager;

@property (weak) IBOutlet NSTableView *tagSummaryTableView;

@property (strong) IBOutlet NSArrayController *tagSummaryArrayController;

-(void)beginLoadingUnlinkedTags;
-(void)completeLoadingUnlinkedTags;
@property BOOL loadingUnlinkedTags;

@property (nonatomic, weak) id<DocumentBrowserCodeFilesDelegate> delegate;
//@property (nonatomic, weak) id<DocumentBrowserDocumentDelegate> documentBrowserDelegate;


@property (strong, nonatomic)STDuplicateTagResults* duplicateTags;
@property (strong, nonatomic)STOverlappingTagResults* overlappingTags;
@property (strong, nonatomic)NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags;

-(void)configure;
-(void)updateTagSummary;
-(void)focusOnTags:(TagIndicatorViewTagFocus)tagFocus;

@end
