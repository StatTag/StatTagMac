//
//  ManageCodeFilesViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "ManageCodeFilesViewController.h"
#import "StatTag.h"
#import "FileMonitor.h"
#import "StatTagShared.h"
#import "STDocumentManager+FileMonitor.h"

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

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(codeFileEdited:)
                                               name:@"codeFileEdited"
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(codeFileRenamed:)
                                               name:@"codeFileRenamed"
                                             object:nil];

  
}

-(void)viewWillAppear {
  self.codeFiles = [[self documentManager] GetCodeFileList];
}

-(void)viewDidAppear
{
  [self startMonitoringCodeFiles];
//  [[StatTagShared sharedInstance] restoreWindowFrame];
}

-(void)viewWillDisappear {
  [self stopMonitoringCodeFiles];
//  [[StatTagShared sharedInstance] saveWindowFrame];
}

-(void)startMonitoringCodeFiles
{
  [[self documentManager] startMonitoringCodeFiles];
}

-(void)stopMonitoringCodeFiles
{
  [[self documentManager] stopMonitoringCodeFiles];
}


- (void)awakeFromNib {
}

-(void)codeFileEdited:(NSNotification *)notification
{
  //FIXME: go back and do this as an alert sheet
  // http://pinkstone.co.uk/how-to-create-an-alert-view-in-cocoa/

  NSString* filePathString = [[notification userInfo] valueForKey:@"originalFilePath"];
  NSURL* filePath = [NSURL fileURLWithPath:filePathString];
  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"OK"];
  [alert setMessageText:[NSString stringWithFormat:@"The following code file was just changed outside of StatTag:\r\n\r\n%@", [filePath path]]];
  [alert runModal];
}

-(void)codeFileRenamed:(NSNotification *)notification
{
  NSString* filePathString = [[notification userInfo] valueForKey:@"originalFilePath"];
  NSURL* filePath = [NSURL fileURLWithPath:filePathString];
  
  NSString* newFilePathString = [[notification userInfo] valueForKey:@"newFilePath"];
  NSURL* newFilePath = [NSURL fileURLWithPath:newFilePathString];
  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"OK"];
  [alert setMessageText:[NSString stringWithFormat:@"The following code file was just changed outside of StatTag:\r\n\r\n%@\r\n\r\nis now located at\r\n\r\n%@", [filePath path], [newFilePath path]]];
  [alert runModal];

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
  //[_codeFiles removeObjectsAtIndexes:selectedFiles];
  [arrayController removeObjectsAtArrangedObjectIndexes:selectedFiles];
  [arrayController rearrangeObjects];
  //[_documentManager SaveCodeFileListToDocument:nil];
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
