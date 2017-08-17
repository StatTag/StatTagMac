//
//  DocumentBrowserCodeFilesViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "DocumentBrowserCodeFilesViewController.h"
#import "StatTagFramework.h"
#import "FileMonitor.h"
#import "StatTagShared.h"
#import <StatTagFramework/STConstants.h>
#import "STCodeFile+FileHelper.h"
#import "DocumentBrowserDocumentViewController.h"
#import "STDocumentManager+FileMonitor.h"

//#import "TagIndicatorView.h"

@interface DocumentBrowserCodeFilesViewController ()


@end

@implementation DocumentBrowserCodeFilesViewController

@synthesize fileTableView;
@synthesize arrayController;
@synthesize tagSummaryArrayController;
@synthesize codeFiles = _codeFiles;
@synthesize documentManager = _documentManager;



//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"DocumentBrowserCodeFilesViewController";
}

-(id)init {
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}
- (void)awakeFromNib {
   [[self fileTableView] setDoubleAction:@selector(doubleClickCodeFile:)];
  
  [[self fileTableView] registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
  
}

//MARK: view controller events

-(void)viewDidAppear
{
}

-(void)viewWillDisappear {
}

-(void)viewWillAppear {
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  ////NSLog(@"DocumentBrowserCodeFilesViewController.h loaded");


  _documentManager = [[StatTagShared sharedInstance] docManager];
}

-(void)configure
{
  [[StatTagShared sharedInstance] setDoc:[[StatTagShared sharedInstance] doc]];
  [_documentManager LoadCodeFileListFromDocument:[[StatTagShared sharedInstance] doc]];
  
  self.codeFiles = [[self documentManager] GetCodeFileList];
  [arrayController rearrangeObjects];

  //  [_documentManager LoadCodeFileListFromDocument:[[StatTagShared sharedInstance] doc]];
  
  [self updateTagSummary];
}




-(void)updateTagSummary
{
  NSInteger numGoodTags = 0;
  NSInteger numDuplicateTags = 0;
  NSInteger numUnlinkedTags = 0;
  
  for(STCodeFile* file in [self codeFiles]) {
    [file LoadTagsFromContent];
    //NSLog(@"Loading code file: '%@' for doc: '%@'", [file FileName], [[[StatTagShared sharedInstance] doc] name]);
  }

  NSArray<STTag*>* tags = [[self documentManager] GetTags];
  //NSLog(@"document [%@] has %ld tags", [[[self documentManager] activeDocument] name], (unsigned long)[tags count]);
  
  //NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags = [[self documentManager] FindAllUnlinkedTags];
  [self setUnlinkedTags:[[self documentManager] FindAllUnlinkedTags]];
  
  //STDuplicateTagResults* duplicateTags = [[[self documentManager] TagManager] FindAllDuplicateTags];
  [self setDuplicateTags: [[[self documentManager] TagManager] FindAllDuplicateTags]];

  numGoodTags = [tags count];
  //numUnlinkedTags = [unlinkedTags count];
  //numDuplicateTags = [[self duplicateTags] count];
  for(STTag* t in [self duplicateTags])
  {
    numDuplicateTags += [[[self duplicateTags] objectForKey:t] count] + 1; //we need to include the parent tag as a duplicate
  }
  for(NSString* filepath in [self unlinkedTags])
  {
    numUnlinkedTags += [[[self unlinkedTags] objectForKey:filepath] count];
  }

  NSMutableArray<DocumentBrowserTagSummary*>* objs = [[NSMutableArray<DocumentBrowserTagSummary*> alloc] init];

  //[[tagSummaryArrayController content] removeAllObjects];
  
  [objs addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:[NSString stringWithFormat:@"%@", @"All Tags"] andStyle:TagIndicatorViewTagStyleNormal withFocus:TagIndicatorViewTagFocusAllTags andCount:numGoodTags]];

  if(numDuplicateTags > 0)
  {
    [objs addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:@"Duplicate Tags" andStyle:TagIndicatorViewTagStyleWarning withFocus:TagIndicatorViewTagFocusDuplicateTags andCount:numDuplicateTags]];
  }
  
  if(numUnlinkedTags > 0)
  {
    [objs addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:@"Unlinked Tags" andStyle:TagIndicatorViewTagStyleError withFocus:TagIndicatorViewTagFocusUnlinkedTags andCount:numUnlinkedTags]];
  }
  
  [tagSummaryArrayController setContent:objs];
  
}




//-(void)startMonitoringCodeFiles
//{
//  if([[self documentBrowserDelegate] respondsToSelector:@selector(startMonitoringCodeFiles)]) {
//    [[self documentBrowserDelegate] startMonitoringCodeFiles];
//  }
//}
//
//-(void)stopMonitoringCodeFiles
//{
//  if([[self documentBrowserDelegate] respondsToSelector:@selector(stopMonitoringCodeFiles)]) {
//    [[self documentBrowserDelegate] stopMonitoringCodeFiles];
//  }
//}



-(void)codeFilesSetFocusOnTags:(DocumentBrowserCodeFilesViewController*)controller
{
  if([[self delegate] respondsToSelector:@selector(codeFilesSetFocusOnTags:)]) {
    [[self delegate] codeFilesSetFocusOnTags:controller];
  }
}
-(void)codeFilesSetFocusOnDuplicateTags:(DocumentBrowserCodeFilesViewController*)controller
{
  if([[self delegate] respondsToSelector:@selector(codeFilesSetFocusOnDuplicateTags:)]) {
    [[self delegate] codeFilesSetFocusOnDuplicateTags:controller];
  }
}
-(void)codeFilesSetFocusOnUnlinkedTags:(DocumentBrowserCodeFilesViewController*)controller
{
  if([[self delegate] respondsToSelector:@selector(codeFilesSetFocusOnDuplicateTags:)]) {
    [[self delegate] codeFilesSetFocusOnUnlinkedTags:controller];
  }
}


- (void)keyDown:(NSEvent *)theEvent
{
  if((id)[self fileTableView] == [(id)[NSApp keyWindow] firstResponder])
  {
    if([theEvent keyCode] == 51)
    {
      //delete
      [self removeFiles:fileTableView];
    }
  }
}


//- (void)selectedCodeFileDidChange:(DocumentBrowserCodeFilesViewController*)controller {
//  if([[self delegate] respondsToSelector:@selector(selectedCodeFileDidChange:)]) {
//    [[self delegate] selectedCodeFileDidChange:controller];
//  }
//}
//
//- (void)selectedTagSummaryDidChange:(DocumentBrowserCodeFilesViewController*)controller {
//  if([[self delegate] respondsToSelector:@selector(selectedTagSummaryDidChange:)]) {
//    [[self delegate] selectedTagSummaryDidChange:controller];
//  }
//}


- (void)insertObject:(STCodeFile *)cf inCodeFilesAtIndex:(NSUInteger)index {
  [_documentManager AddCodeFile:[cf FilePath]];
  [_documentManager SaveCodeFileListToDocument:nil];
  [_codeFiles addObject:cf];
  [_documentManager monitorCodeFile:cf];
  //[[StatTagShared sharedInstance] monitorCodeFile:cf];
  [self updateTagSummary];
}

//go back and review - this isn't fired (should be...)
//FIXME: not sure why this isn't being called
- (void)removeObjectFromCodeFilesAtIndex:(NSUInteger)index {
  
  //[[StatTagShared sharedInstance] stopMonitoringCodeFile:[_codeFiles objectAtIndex:index]];
  [_documentManager stopMonitoringCodeFile:[_codeFiles objectAtIndex:index]];
  [_codeFiles removeObjectAtIndex:index];
  [_documentManager SetCodeFileList:_codeFiles document:nil];
  [_documentManager SaveCodeFileListToDocument:nil];
  [self updateTagSummary];

  //  [_documentManager SetCodeFileList:<#(NSArray<STCodeFile *> *)#> document:<#(STMSWord2011Document *)#>]
}

- (IBAction)addFile:(id)sender {
  
  NSOpenPanel* openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseFiles:YES];
  [openPanel setCanChooseDirectories:NO];
  [openPanel setCanSelectHiddenExtension:NO];
  [openPanel setPrompt:@"Select Files"];
  [openPanel setAllowsMultipleSelection:YES];
  
  
  [openPanel setAllowedFileTypes:[STConstantsFileFilters SupportedFileFiltersArray]];
  
  //BOOL isDir;
  //NSFileManager* fileManager = [NSFileManager defaultManager];
  
  if ( [openPanel runModal] == NSModalResponseOK )
  {
    NSArray<NSURL*>* files = [openPanel URLs];
    [self addCodeFilesByURL:files];
  }
  
}

-(void)addCodeFilesByURL:(NSArray<NSURL*>*)files
{
  NSMutableArray<STCodeFile*>* codefiles = [[NSMutableArray alloc] initWithArray:[[self arrayController] arrangedObjects]];
  //NSLog(@"codefiles = %@", codefiles);
  //NSLog(@"allowed extensions : %@", [allowedExtensions_CodeFiles pathComponents]);
  for( NSInteger i = 0; i < [files count]; i++ )
  {
    NSURL* url = [files objectAtIndex:i];
    //      if ([fileManager fileExistsAtPath:[url path] isDirectory:&isDir] && isDir) {
    //        url = [url URLByAppendingPathComponent:defaultLogFileName];
    //      }
    
    //      [[self labelFilePath] setStringValue:[url path]];
    //NSLog(@"path extension : %@", [url pathExtension]);
    
    //if([[STConstantsFileFilters SupportedFileFiltersArray] containsObject:[url pathExtension]])
    if([STCodeFile fileIsSupported:url])
    {
      STCodeFile* cf = [[STCodeFile alloc] init];
      cf.FilePathURL = url;
      [codefiles addObject:cf];
    }
  }
  //remove duplicates
  [codefiles setArray:[[NSSet setWithArray:codefiles] allObjects]];
  //NSLog(@"codefiles = %@", codefiles);
  for(STCodeFile* cf in codefiles)
  {
    if(![[arrayController arrangedObjects] containsObject:cf])
    {
      [arrayController addObject:cf];
    }
  }
  //add to array controller
  // leaving this here so you know I did this initially, but things weren't persisting
  // will circle back and evaluate later
  //[arrayController setContent:codefiles];
  
  //NSLog(@"arrayController content = %@", [arrayController content]);
  
  //re-sort in case the user has sorteda column
  [arrayController rearrangeObjects];

}

- (IBAction)removeFiles:(id)sender {
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSAlertStyleWarning];
  [alert setMessageText:@"Do you wish to remove the selected code files from your project?"];
  [alert addButtonWithTitle:@"Remove Code File"];
  [alert addButtonWithTitle:@"Cancel"];
  
  [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSModalResponse returnCode) {
    if (returnCode == NSAlertFirstButtonReturn) {
      NSIndexSet* selectedFiles = [arrayController selectionIndexes];
      [arrayController removeObjectsAtArrangedObjectIndexes:selectedFiles];
      [arrayController rearrangeObjects];
    } else if (returnCode == NSAlertSecondButtonReturn) {
    }
  }];


//  [_documentManager SaveCodeFileListToDocument:nil];
//  [self updateTagSummary];

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

- (void)doubleClickCodeFile:(id)sender {
  
  NSInteger row = [[self fileTableView] clickedRow];
  STCodeFile* cf = [[arrayController arrangedObjects] objectAtIndex:row];
  if(cf != nil)
  {
    NSURL* filePathURL = [cf FilePathURL];
    [[NSWorkspace sharedWorkspace] selectFile:[filePathURL path] inFileViewerRootedAtPath:[filePathURL path]];
  }
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  
  NSTableCellView *cell = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:NULL];

  if(tableColumn != nil)
  {
    if([[tableColumn identifier] isEqualToString:@"tagIndicatorColumn"])
    {
      //the visual "tag" indicator in the top tag list table
      cell = [tableView makeViewWithIdentifier:@"tagIndicatorCellView" owner:NULL];
      DocumentBrowserTagSummary* summary = [[[self tagSummaryArrayController] arrangedObjects] objectAtIndex:row];
      if(summary)
      {
        cell.textField.stringValue = [NSString stringWithFormat:@"%ld", (long)[summary tagCount]];
        NSImage* img = [DocumentBrowserTagSummary colorImage:cell.imageView.image forTagIndicatorViewTagStyle:[summary tagStyle]];
        cell.imageView.image = img;
      }
    }
    else if([[tableColumn identifier] isEqualToString:@"tagIndicatorColumn"])
    {
      //our stat package icon
      // this is handled by bindings
    }
  }
  
  return cell;
}

-(void)focusOnTags:(TagIndicatorViewTagFocus)tagFocus
{
  if([[[self tagSummaryArrayController] arrangedObjects] count] > 0)
  {
    for(DocumentBrowserTagSummary* t in [[self tagSummaryArrayController] arrangedObjects])
    {
      if([t tagFocus] == tagFocus)
      {
        [[self tagSummaryArrayController] setSelectedObjects:[NSArray arrayWithObject:t]];
        break;
      }
    }
  }
}


/*
-(void)viewTagWithName:(NSString*)tagName
{
  [self viewAllTags];
  
}
-(void)viewTagWithID:(STTag*)tagID
{
  [self viewAllTags];
  
}
*/

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
  //ONLY listen for changes to our two tables
  if([[[notification object] identifier] isEqualToString:@"tagSummaryTable"] || [[[notification object] identifier] isEqualToString:@"fileTableView"])
  {
    if([[[notification object] identifier] isEqualToString:@"tagSummaryTable"])
    {

      //NSLog(@"tableViewSelectionDidChange - tagSummaryTable - table changed");
      NSInteger row = [self.tagSummaryTableView selectedRow];
      if(row == -1) {
        row = [[self tagSummaryTableView] clickedRow];
      }
      if(row != -1)
      {
        //NSLog(@"tableViewSelectionDidChange - tagSummaryTable - selection is : %ld", row);
        //summary was selected, so we want to remove the code file selections
        //deselect all of the code file selections
        [[self arrayController] setSelectedObjects:[NSArray array]];
        DocumentBrowserTagSummary* tagSummary = [[[self tagSummaryArrayController] arrangedObjects]objectAtIndex:row];
        switch([tagSummary tagFocus])
        {
          case TagIndicatorViewTagFocusDuplicateTags:
            [self codeFilesSetFocusOnDuplicateTags:self];
            break;
          case TagIndicatorViewTagFocusUnlinkedTags:
            [self codeFilesSetFocusOnUnlinkedTags:self];
            break;
          default:
            [self codeFilesSetFocusOnTags:self];
            break;
        }
      }
    } else if([[[notification object] identifier] isEqualToString:@"fileTableView"])
    {
      NSInteger row = [self.fileTableView selectedRow];
      //NSLog(@"tableViewSelectionDidChange - fileTableView - table changed");
      if(row == -1) {
        row = [[self fileTableView] clickedRow];
      }
      if(row != -1)
      {
        //code file was selected, so we want to remove the summary file selections
        [[self tagSummaryArrayController] setSelectedObjects:[NSArray array]];
      }
      //NSLog(@"tableViewSelectionDidChange - fileTableView - selection is : %ld", row);
      
      //since interaction with EITHER of these two tables impacts the other table,
      // only fire for the file table view
      
      
      //we have a user behavior where people want to select code files that are currently unlinked. If we have a selection that contains ONLY unlinked tags, let's load the unlinked tags UI
      NSPredicate* unlinkedCodeFilePredicate = [NSPredicate predicateWithFormat:@"fileAccessibleAtPath = NO"];
      NSArray<STCodeFile*>* missingSelectedCodeFiles = [[[self arrayController] selectedObjects] filteredArrayUsingPredicate:unlinkedCodeFilePredicate];
      if([missingSelectedCodeFiles count] > 0)
      {
        //did we have ANY unlinked code files selected? If so, force the unlinked tags UI
        //NOTE: yes - this is a bit goofy. It deselects the selected code file and selects the "unlinked tags" tag from the summary view - this is a placeholder behavior for now so we can test this out
        [self codeFilesSetFocusOnUnlinkedTags:self];
      } else {
        [self codeFilesSetFocusOnTags:self];
      }
    }
  }
}


//best example of this: http://stackoverflow.com/questions/10308008/nstableview-and-drag-and-drop-from-finder
-(NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
  //get the file URLs from the pasteboard
  NSPasteboard* pb = info.draggingPasteboard;
  
  //list the file type UTIs we want to accept
  //EWW: full list of types here
  // https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
  //more: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DragandDrop/Tasks/acceptingdrags.html#//apple_ref/doc/uid/20000993-BABHHIHC
  NSArray* acceptedTypes = [NSArray arrayWithObject:(NSString*)kUTTypeText];
  
  NSArray* urls = [pb readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
                                    options:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithBool:YES],NSPasteboardURLReadingFileURLsOnlyKey,
                                             acceptedTypes, NSPasteboardURLReadingContentsConformToTypesKey,
                                             nil]];
  #pragma unused(urls)
  return NSDragOperationCopy;
}

- (BOOL)tableView:(NSTableView *)tableView
       acceptDrop:(id<NSDraggingInfo>)info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)dropOperation
{
  
  if(tableView == fileTableView)
  {
    //NSLog(@"on this table");
    NSArray* filenames = [[info draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    //we're ignoring positioning for this
    //NSData *data = [[info draggingPasteboard] dataForType:NSFilenamesPboardType];
    //NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray<NSURL*>*urls = [[NSMutableArray<NSURL*> alloc] init];
    for(NSString* filename in filenames)
    {
      NSURL* url = [NSURL fileURLWithPath:filename ];
      if(url != nil)
      {
        [urls addObject:url];
      }
    }
    [self addCodeFilesByURL:urls];
    
    return YES;
  }
  
  return NO;
}




@end
