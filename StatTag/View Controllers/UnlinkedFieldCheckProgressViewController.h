//
//  UnlinkedFieldCheckProgressViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatTagShared.h"

@class STDocumentManager;
@class STTag;
@class StatTagWordDocument;


@class UnlinkedFieldCheckProgressViewController;
@protocol UnlinkedFieldCheckProgressDelegate <NSObject>
- (void)dismissUnlinkedFieldCheckProgressViewController:(UnlinkedFieldCheckProgressViewController*)controller withReturnCode:(StatTagResponseState)returnCode;
@end


@interface UnlinkedFieldCheckProgressViewController : NSViewController {
  __weak NSProgressIndicator *progressIndicator;
  __weak NSTextField *progressText;
  
  NSMutableArray<STTag*>* _tagsToProcess;
  STDocumentManager* _documentManager;
  StatTagWordDocument* _stWordDoc;

  
  BOOL _insert;
  NSMutableArray<STTag*>*_failedTags;
  NSMutableDictionary<STTag*, NSException*>* _failedTagErrors;
}

@property (strong, nonatomic) NSMutableArray<STTag*>* tagsToProcess;
@property (strong, nonatomic) STDocumentManager* documentManager;
@property (strong, nonatomic) StatTagWordDocument* stWordDoc;

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *progressText;

@property (nonatomic, weak) id<UnlinkedFieldCheckProgressDelegate> delegate;

@property (strong, nonatomic) NSNumber* numItemsCompleted;
@property (strong, nonatomic) NSNumber* numItemsToProcess;
@property (strong, nonatomic) NSString* progressCountText;

@property (weak) IBOutlet NSProgressIndicator *progressIndicatorDeterminate;
@property (weak) IBOutlet NSTextField *progressCountLabel;

@property (strong, nonatomic) NSMutableArray<STTag*>*failedTags;
@property (strong, nonatomic) NSMutableDictionary<STTag*, NSException*>*failedTagErrors;

@property BOOL insert;

@end
