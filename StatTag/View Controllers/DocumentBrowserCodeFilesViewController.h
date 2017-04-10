//
//  DocumentBrowserCodeFilesViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class STCodeFile;
@class STDocumentManager;
@class STMSWord2011Document;

@class DocumentBrowserCodeFilesViewController;
@protocol DocumentBrowserCodeFilesDelegate <NSObject>
//- (void)selectedCodeFileDidChange:(DocumentBrowserCodeFilesViewController*)controller;
//- (void)selectedTagSummaryDidChange:(DocumentBrowserCodeFilesViewController*)controller;
-(void)codeFilesSetFocusOnTags:(DocumentBrowserCodeFilesViewController*)controller;
-(void)codeFilesSetFocusOnDuplicateTags:(DocumentBrowserCodeFilesViewController*)controller;
-(void)codeFilesSetFocusOnUnlinkedTags:(DocumentBrowserCodeFilesViewController*)controller;
@end


static NSString* const allowedExtensions_CodeFiles = @"do/DO";

@interface DocumentBrowserCodeFilesViewController : NSViewController <NSTableViewDelegate> {
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


@property (nonatomic, weak) id<DocumentBrowserCodeFilesDelegate> delegate;


-(void)configure;
-(void)updateTagSummary;
-(void)viewAllTags;

@end
