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

#import "UpdateOutputProgressViewController.h" //for protocol UpdateOutputProgressDelegate
#import "TagEditorViewController.h"

#import "STTag+Preview.h"

IB_DESIGNABLE

@interface UpdateOutputViewController : NSViewController <UpdateOutputProgressDelegate, TagEditorViewControllerDelegate, NSTableViewDelegate> {
  __weak NSTextField *labelOnDemandSearchText;
  __weak NSButton *buttonOnDemandSelectAll;
  __weak NSButton *buttonOnDemandSelectNone;
  __weak NSTableView *tableViewOnDemand;
  __weak NSButton *buttonRefresh;
  __weak NSButton *buttonCancel;
  NSArrayController *onDemandTags;
  NSMutableArray<STTag*>* _documentTags;
  
  STDocumentManager* _documentManager;

  NSString* _filterAll;
  NSString* _filterTagFrequency;
  NSString* _filterTagType;
}

@property (weak) IBOutlet NSTextField *labelOnDemandSearchText;
@property (weak) IBOutlet NSButton *buttonOnDemandSelectAll;
@property (weak) IBOutlet NSButton *buttonOnDemandSelectNone;
@property (weak) IBOutlet NSTableView *tableViewOnDemand;
@property (weak) IBOutlet NSButton *buttonRefresh;

@property (strong) IBOutlet NSArrayController *onDemandTags;

@property (strong, nonatomic) STDocumentManager* documentManager;

@property (strong, nonatomic) NSMutableArray<STTag*>* documentTags;

@property (weak) IBOutlet NSButton *buttonEdit;

-(NSString*)tagPreviewText:(STTag*)tag;

@property (strong, nonatomic) NSString* filterAll;
@property (strong, nonatomic) NSString* filterTagFrequency;
@property (strong, nonatomic) NSString* filterTagType;


@property (weak) IBOutlet NSButton *filterButtonAll;


@property (weak) IBOutlet NSButton *addTagButton;
@property (weak) IBOutlet NSButton *removeTagButton;

- (STTag*)selectTagWithName:(NSString*)tagName;
- (IBAction)editTag:(id)sender;

-(void)loadAllTags;
-(void)loadTagsForCodeFiles:(NSArray<STCodeFile*>*)codeFiles;

//-(BOOL)enableAddTagButton;
//-(BOOL)enableRemoveTagButton;

@end
