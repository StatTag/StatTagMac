//
//  ManageCodeFilesViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "ManageCodeFilesViewController.h"
#import "StatTag.h"


@interface ManageCodeFilesViewController ()

@end

@implementation ManageCodeFilesViewController

@synthesize fileTableView;
@synthesize arrayController;
@synthesize codeFiles = _codeFiles;
@synthesize documentManager = _documentManager;

NSString* const allowedExtensions_CodeFiles = @"do/DO";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
  NSLog(@"ManageCodeFilesViewController loaded");

}

-(void)viewWillAppear {
  self.codeFiles = [[self documentManager] GetCodeFileList];
  for(STCodeFile* cf in _codeFiles) {
    NSLog(@"package : %@, path : %@", [cf StatisticalPackage], [cf FilePath]);
  }
}

- (void)awakeFromNib {
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"ManageCodeFilesViewController" owner:self topLevelObjects:nil];
  }
  return self;
}

- (void)insertObject:(STCodeFile *)cf inCodeFilesAtIndex:(NSUInteger)index {
  [_documentManager AddCodeFile:[cf FilePath]];
  [_documentManager SaveCodeFileListToDocument:nil];

}

//go back and review - this isn't fired (should be...)
//FIXME: not sure why this isn't being called
- (void)removeObjectFromCodeFilesAtIndex:(NSUInteger)index {
  [_codeFiles removeObjectAtIndex:index];
  [_documentManager SaveCodeFileListToDocument:nil];
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
  [_documentManager SaveCodeFileListToDocument:nil];
}

- (IBAction)openFileInFinder:(id)sender {
  
  //make sure you set the table's delegate and data source to file's owner
  
  NSInteger row = [[self fileTableView] rowForView:sender];

  //if we just want the containing directory
  //  NSURL* folderPathURL = [[[_codeFiles objectAtIndex:row] FilePathURL] URLByDeletingLastPathComponent];
  //  [[NSWorkspace sharedWorkspace] openURL: folderPathURL];

  //if we want to open the finder and select the file
  NSURL* filePathURL = [[_codeFiles objectAtIndex:row] FilePathURL];
  [[NSWorkspace sharedWorkspace] selectFile:[filePathURL path] inFileViewerRootedAtPath:[filePathURL path]];
  
}




//- (IBAction)btnOKAndSave:(id)sender {
//  
//  //need error handling
//  [_manager SaveCodeFileListToDocument:nil];
//  
//}

//- (IBAction)btnCancel:(id)sender {
//  [[self window] close];
//}


@end
