//
//  TagEditorViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/26/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatTagShared.h"

@class ScintillaView;
@class STTag;
@class STCodeFile;
@class STDocumentManager;
@class ScintillaView;

@class TagEditorViewController;
@protocol TagEditorViewControllerDelegate <NSObject>
- (void)dismissTagEditorController:(TagEditorViewController*)controller withReturnCode:(StatTagResponseState)returnCode;
@end


@interface TagEditorViewController : NSViewController {
  STTag* _tag;
  STDocumentManager* _documentManager;
  
  NSArrayController* _codeFileList;
  NSArrayController* _tagFrequency;

  ScintillaView* _sourceEditor;

  
}

@property (strong, nonatomic) STTag* tag;
@property (strong, nonatomic) STDocumentManager* documentManager;

@property (strong) IBOutlet NSArrayController *codeFileList;

@property (strong) IBOutlet NSArrayController *tagFrequency;

//top part
@property (weak) IBOutlet NSPopUpButton *listCodeFile;
@property (weak) IBOutlet NSPopUpButton *listFrequency;
@property (weak) IBOutlet NSTextField *textBoxTagName;


//"value"
@property (weak) IBOutlet NSButton *radioValueDefault;
@property (weak) IBOutlet NSButton *radioValueNumeric;

@property (weak) IBOutlet NSButton *radioValueDateTime;
@property (weak) IBOutlet NSButton *radioValuePercentage;
@property (weak) IBOutlet NSTextField *lblValueDescription;
@property (weak) IBOutlet NSTextField *lblValueCommands;


//"table"
@property (weak) IBOutlet NSButton *tableCheckboxColumnNames;
@property (weak) IBOutlet NSButton *tableCheckboxRowNames;
@property (weak) IBOutlet NSTextField *tableTextboxDecimalPlaces;
@property (weak) IBOutlet NSStepper *tableStepperDecimalPlaces;
@property (weak) IBOutlet NSButton *tableCheckboxUseThousandsSeparator;
@property (weak) IBOutlet NSTextField *tableLblDescription;
@property (weak) IBOutlet NSTextField *tableLblCommands;


//@property (weak) IBOutlet NSBox *sourceViewBox;

//@property (weak) IBOutlet ScintillaView *sourceView;
@property (strong, nonatomic) ScintillaView *sourceEditor;
@property (weak) IBOutlet NSView *sourceView;

//delegate since this is probably opened modally
@property (nonatomic, weak) id<TagEditorViewControllerDelegate> delegate;

@property (weak) IBOutlet NSButton *buttonSave;
@property (weak) IBOutlet NSButton *buttonCancel;



@end



