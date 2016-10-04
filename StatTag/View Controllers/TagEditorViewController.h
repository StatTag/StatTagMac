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

@interface TagEditorViewController : NSViewController <NSTextFieldDelegate, TagBasicPropertiesControllerDelegate, ValuePropertiesControllerDelegate> {
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

@property (strong) IBOutlet ValuePropertiesController *tagValueProperties;


@end
