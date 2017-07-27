//
//  DuplicateTagRenameViewController.h
//  StatTag
//
//  Created by Eric Whitley on 6/1/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatTagShared.h"

@class STTag;
@class STDocumentManager;

@class DuplicateTagRenameViewController;
@protocol DuplicateTagRenameViewControllerDelegate <NSObject>
- (void)dismissTagRenameController:(DuplicateTagRenameViewController*)controller withReturnCode:(StatTagResponseState)returnCode;
@end


@interface DuplicateTagRenameViewController : NSViewController <NSTextFieldDelegate> {
  //NSMutableArray<STTag*>* allTags;
  NSMutableArray<NSString*>* allTagNames;
}

//pass in what we're going to be manipulating
@property (strong, nonatomic) STTag* duplicateTag;
@property (strong, nonatomic) STDocumentManager* documentManager;
@property (nonatomic, weak) id<DuplicateTagRenameViewControllerDelegate> delegate;


@property BOOL canRename;


//UI
@property (weak) IBOutlet NSTextField *tagNameInUseInfoTextLabel;

@property (weak) IBOutlet NSTextField *currentTagNameTextField;
@property (weak) IBOutlet NSTextField *replacementTagNameTextField;

@property (weak) IBOutlet NSView *warningContentView;

@property (weak) IBOutlet NSImageView *tagNameInUseWarningImage;
@property (weak) IBOutlet NSTextField *tagNameInUseLabel;

@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSButton *renameButton;



@end
