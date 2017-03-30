//
//  ManageCodeFilesViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class STCodeFile;
@class STDocumentManager;

static NSString* const allowedExtensions_CodeFiles = @"do/DO";

@interface ManageCodeFilesViewController : NSViewController {
  NSArrayController *arrayController;
  __weak NSTableView *fileTableView;
  
  NSMutableArray<STCodeFile*>* _codeFiles;
  STDocumentManager* _documentManager;
}
@property (weak) IBOutlet NSTableView *fileTableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong, nonatomic) NSMutableArray<STCodeFile*>* codeFiles;
@property (strong, nonatomic) STDocumentManager* documentManager;


@end
