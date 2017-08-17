//
//  TagEditorViewControllerRevised.h
//  StatTag
//
//  Created by Eric Whitley on 10/4/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatTagShared.h"

#import "TagBasicPropertiesController.h"
#import "ValuePropertiesController.h"
#import "TablePropertiesController.h"

@class ScintillaEmbeddedViewController;

@class STTag;
@class STCodeFile;
@class STDocumentManager;
@class ScintillaView;

@class TagBasicPropertiesController;
@class TagPreviewController;

@class TagEditorViewController;
@protocol TagEditorViewControllerDelegate <NSObject>
- (void)dismissTagEditorController:(TagEditorViewController*)controller withReturnCode:(StatTagResponseState)returnCode andTag:(STTag*)tag;
@end

@interface TagEditorViewController : NSViewController <NSTextFieldDelegate, TagBasicPropertiesControllerDelegate, ValuePropertiesControllerDelegate, TablePropertiesControllerDelegate> {
  STTag* _tag;
  STDocumentManager* _documentManager;
  
  NSArrayController* _codeFileList;
  
  ScintillaEmbeddedViewController* _sourceEditor;
  
  NSMutableAttributedString* _instructionTitleText;
  NSString* _allowedCommandsText;
  
  BOOL _showTagValuePropertiesView;
  BOOL _editable;
  STCodeFile* _originallySelectedCodeFile;
}

@property (strong, nonatomic) STTag* tag;
@property (strong, nonatomic) STDocumentManager* documentManager;

//top part - code file list
@property (strong) IBOutlet NSArrayController *codeFileList;
@property (weak) IBOutlet NSPopUpButton *listCodeFile;

//the code file that was selected (if any) in the code file list prior to
@property (strong, nonatomic) STCodeFile* originallySelectedCodeFile;

@property (strong) IBOutlet ScintillaEmbeddedViewController *sourceEditor;
@property (weak) IBOutlet NSView *sourceView;

//delegate since this is probably opened modally
@property (nonatomic, weak) id<TagEditorViewControllerDelegate> delegate;

@property (weak) IBOutlet NSButton *buttonSave;
@property (weak) IBOutlet NSButton *buttonCancel;

@property (strong, nonatomic) NSMutableAttributedString* instructionTitleText;
@property (strong, nonatomic) NSString* allowedCommandsText;


//Properties Panel
@property (weak) IBOutlet NSStackView *propertiesStackView;


@property (weak) IBOutlet NSTextField *labelInstructionText;

@property (strong) IBOutlet TagBasicPropertiesController* tagBasicProperties;
@property (strong) IBOutlet DisclosureViewController *tagBasicPropertiesDisclosure;
@property (weak) IBOutlet NSView *tagBasicPropertiesView;


@property (strong) IBOutlet ValuePropertiesController *tagValueProperties;
@property (strong) IBOutlet DisclosureViewController *tagValuePropertiesDisclosure;
@property (weak) IBOutlet NSView *tagValuePropertiesView;

@property (strong) IBOutlet TablePropertiesController *tagTableProperties;
@property (strong) IBOutlet DisclosureViewController *tagTablePropertiesDisclosure;
@property (weak) IBOutlet NSView *tagTablePropertiesView;

@property (strong) IBOutlet TagPreviewController *tagPreviewController;
@property (strong) IBOutlet DisclosureViewController *tagPreviewDisclosureController;
@property (weak) IBOutlet NSView *tagPreviewView;


@property (weak) IBOutlet NSView *codeEditingPanel;

@property BOOL editable;

/**
 Cancel all actions and close editor
 we're making this public so our "something changed with the code file" notifications can cancel/close the editor when necessary
*/
- (IBAction)cancel:(id)sender;


/*
 EWW:
 You'll note the XIB file uses a custom clipview within the scrollview when embedding a stackview - this is by design
 Apparently you need to flip the coordinate system when doing this
 http://prod.lists.apple.com/archives/cocoa-dev/2013/Dec/msg00263.html
 https://github.com/mugginsoft/TSInfoBarStackView
 */


@end
