//
//  UpdateOutputProgressViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatTagShared.h"

@class STDocumentManager;
@class STTag;


@class UpdateOutputProgressViewController;
@protocol UpdateOutputProgressDelegate <NSObject>
- (void)dismissUpdateOutputProgressController:(UpdateOutputProgressViewController*)controller withReturnCode:(StatTagResponseState)returnCode andFailedTags:(NSArray<STTag*>*)failedTags withErrors:(NSDictionary<STTag*, NSException*>*)errors;
@end


@interface UpdateOutputProgressViewController : NSViewController {
  __weak NSProgressIndicator *progressIndicator;
  __weak NSTextField *progressText;
  
  NSMutableArray<STTag*>* _tagsToProcess;
  STDocumentManager* _documentManager;
  BOOL _insert;
  NSMutableArray<STTag*>*_failedTags;
  NSMutableDictionary<STTag*, NSException*>* _failedTagErrors;
}

@property (strong, nonatomic) NSMutableArray<STTag*>* tagsToProcess;
@property (strong, nonatomic) STDocumentManager* documentManager;

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *progressText;

@property (nonatomic, weak) id<UpdateOutputProgressDelegate> delegate;

@property (strong, nonatomic) NSNumber* numTagsCompleted;
@property (strong, nonatomic) NSNumber* numTagsToProcess;
@property (strong, nonatomic) NSString* progressCountText;

@property (weak) IBOutlet NSProgressIndicator *progressIndicatorDeterminate;
@property (weak) IBOutlet NSTextField *progressCountLabel;

@property (strong, nonatomic) NSMutableArray<STTag*>*failedTags;
@property (strong, nonatomic) NSMutableDictionary<STTag*, NSException*>*failedTagErrors;

@property BOOL insert;

@end
