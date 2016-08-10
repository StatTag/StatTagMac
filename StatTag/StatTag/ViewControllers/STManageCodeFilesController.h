//
//  STManageCodeFilesController.h
//  StatTag
//
//  Created by Eric Whitley on 8/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class STCodeFile;

@interface STManageCodeFilesController : NSWindowController {
  NSArrayController *arrayController;
  __weak NSTableView *fileTableView;
  
  NSMutableArray<STCodeFile*>* _codeFiles;
  
}
@property (weak) IBOutlet NSTableView *fileTableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong, nonatomic) NSMutableArray<STCodeFile*>* codeFiles;


- (void)windowWillClose:(NSNotification*)notification;
- (void)windowDidBecomeKey:(NSNotification*)notification;


@end
