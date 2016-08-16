//
//  STTagUpdateProgressController.h
//  StatTag
//
//  Created by Eric Whitley on 8/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STTag;
//@class STCodeFile;
@class STDocumentManager;

@interface STTagUpdateProgressController : NSWindowController {
  __weak NSProgressIndicator *progressIndicator;
  __weak NSTextField *progressText;
  
  NSMutableArray<STTag*>* _tagsToProcess;
  STDocumentManager* _manager;
}


@property (strong, nonatomic) NSMutableArray<STTag*>* tagsToProcess;
@property (strong, nonatomic) STDocumentManager* manager;

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *progressText;


@end
