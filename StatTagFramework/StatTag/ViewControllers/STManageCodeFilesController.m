//
//  STManageCodeFilesController.m
//  StatTag
//
//  Created by Eric Whitley on 8/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STManageCodeFilesController.h"
#import "StatTag.h"

@interface STManageCodeFilesController ()

@end

@implementation STManageCodeFilesController
@synthesize fileTableView;
@synthesize arrayController;
@synthesize codeFiles = _codeFiles;
@synthesize manager = _manager;

NSString* const allowedExtensions_CodeFiles = @"do/DO";


- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  //[self populateArrayController];
  //[fileTableView reloadData];
  //_codeFiles = [_manager GetCodeFileList];
  for(STCodeFile* cf in _codeFiles) {
    NSLog(@"package : %@, path : %@", [cf StatisticalPackage], [cf FilePath]);
  }

}

- (void)windowWillClose:(NSNotification *)notification {
  [[NSApplication sharedApplication] stopModal];
}



- (void)insertObject:(STCodeFile *)cf inCodeFilesAtIndex:(NSUInteger)index {
  [_manager AddCodeFile:[cf FilePath]];
  //[_codeFiles insertObject:cf atIndex:index];
}

- (void)removeObjectFromCodeFilesAtIndex:(NSUInteger)index {
  //[[_manager GetCodeFileList] removeObjectAtIndex:index];
  [_codeFiles removeObjectAtIndex:index];
}

- (IBAction)addFile:(id)sender {
  
  NSOpenPanel* openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseFiles:YES];
  [openPanel setCanChooseDirectories:NO];
  [openPanel setCanSelectHiddenExtension:NO];
  [openPanel setPrompt:@"Select Files"];
  [openPanel setAllowsMultipleSelection:YES];
  
  
  NSArray<NSString*>* types = [allowedExtensions_CodeFiles pathComponents];
  [openPanel setAllowedFileTypes:types];
  
  BOOL isDir;
  NSFileManager* fileManager = [NSFileManager defaultManager];
  
  if ( [openPanel runModal] == NSOKButton )
  {
    NSArray<NSURL*>* files = [openPanel URLs];
    
    for( int i = 0; i < [files count]; i++ )
    {
      NSURL* url = [files objectAtIndex:i];
//      if ([fileManager fileExistsAtPath:[url path] isDirectory:&isDir] && isDir) {
//        url = [url URLByAppendingPathComponent:defaultLogFileName];
//      }
      
//      [[self labelFilePath] setStringValue:[url path]];
      STCodeFile* cf = [[STCodeFile alloc] init];
      cf.FilePathURL = url;
      
      //add to array controller
      [arrayController addObject:cf];

      //re-sort in case the user has sorteda column
      [arrayController rearrangeObjects];
      
    }
  }

}

- (IBAction)removeFiles:(id)sender {
  NSIndexSet* selectedFiles = [arrayController selectionIndexes];
  [_codeFiles removeObjectsAtIndexes:selectedFiles];
  [arrayController rearrangeObjects];
}


- (IBAction)btnOKAndSave:(id)sender {
  
  //need error handling
  [_manager SaveCodeFileListToDocument:nil];
  
  [[self window] close];
}

- (IBAction)btnCancel:(id)sender {
  [[self window] close];
}


@end
