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

@class ScintillaView;
@class STTag;
@class STCodeFile;
@class STDocumentManager;
@class ScintillaView;

@class TagBasicPropertiesController;

@class TagEditorViewController;
@protocol TagEditorViewControllerDelegate <NSObject>
- (void)dismissTagEditorController:(TagEditorViewController*)controller withReturnCode:(StatTagResponseState)returnCode;
@end

@interface TagEditorViewController : NSViewController <NSTextFieldDelegate, TagBasicPropertiesControllerDelegate, ValuePropertiesControllerDelegate, TablePropertiesControllerDelegate> {
  STTag* _tag;
  STDocumentManager* _documentManager;
  
  NSArrayController* _codeFileList;
  
  ScintillaView* _sourceEditor;
  
  NSMutableAttributedString* _instructionTitleText;
  NSString* _allowedCommandsText;
  
//  NSStackView* _propertiesStackView;
}

@property (strong, nonatomic) STTag* tag;
@property (strong, nonatomic) STDocumentManager* documentManager;

//top part - code file list
@property (strong) IBOutlet NSArrayController *codeFileList;
@property (weak) IBOutlet NSPopUpButton *listCodeFile;


@property (strong, nonatomic) ScintillaView *sourceEditor;
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

@property (weak) IBOutlet TagBasicPropertiesController* tagBasicProperties;
@property (strong) IBOutlet DisclosureViewController *tagBasicPropertiesDisclosure;

@property (strong) IBOutlet ValuePropertiesController *tagValueProperties;
@property (strong) IBOutlet DisclosureViewController *tagValuePropertiesDisclosure;

@property (strong) IBOutlet TablePropertiesController *tagTableProperties;
@property (strong) IBOutlet DisclosureViewController *tagTablePropertiesDisclosure;


/*
 EWW:
 You'll note the XIB file uses a custom clipview within the scrollview when embedding a stackview - this is by design
 Apparently you need to flip the coordinate system when doing this
 http://prod.lists.apple.com/archives/cocoa-dev/2013/Dec/msg00263.html
 https://github.com/mugginsoft/TSInfoBarStackView
 */


@end
