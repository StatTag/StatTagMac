//
//  STManageCodeFilesController.h
//  StatTag
//
//  Created by Eric Whitley on 8/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class STCodeFile;
@class STDocumentManager;

@interface STManageCodeFilesController : NSWindowController {
  NSArrayController *arrayController;
  __weak NSTableView *fileTableView;
  
  NSMutableArray<STCodeFile*>* _codeFiles;
  STDocumentManager* _manager;
}
@property (weak) IBOutlet NSTableView *fileTableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong, nonatomic) NSMutableArray<STCodeFile*>* codeFiles;
@property (strong, nonatomic) STDocumentManager* manager;


- (void)windowWillClose:(NSNotification*)notification;
- (void)windowDidBecomeKey:(NSNotification*)notification;


@end
