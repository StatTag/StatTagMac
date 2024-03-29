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
#import "StatTagWordDocument.h"

#import "TagIndicatorView.h"


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
  STMSWord2011Document* doc = [[StatTagShared sharedInstance] doc];
  // It's possible to get back a document object even if there is no active document.  We
  // need to further check if it is really there.
  if (doc != nil && [doc name] != nil) {
    [[StatTagShared sharedInstance] setDoc:doc];
    [_documentManager LoadCodeFileListFromDocument:doc];
    
    self.codeFiles = [[self documentManager] GetCodeFileList];
    [_removeCodeFile setEnabled:[self enableRemoveCodeFile]];
    [_addCodeFile setEnabled:TRUE];
  } else {
    [[StatTagShared sharedInstance] setDoc:nil];
    self.codeFiles = nil;
    [_removeCodeFile setEnabled:FALSE];
    [_addCodeFile setEnabled:FALSE];
  }

  [arrayController rearrangeObjects];
  [self updateTagSummary];
}

-(void)updateTagSummary
{
  NSInteger numGoodTags = 0;
  NSInteger numDuplicateTags = 0;
  
  for(STCodeFile* file in [self codeFiles]) {
    [file LoadTagsFromContent];
    //NSLog(@"Loading code file: '%@' for doc: '%@'", [file FileName], [[[StatTagShared sharedInstance] doc] name]);
  }

  NSArray<STTag*>* tags = [[self documentManager] GetTags];
  //NSLog(@"document [%@] has %ld tags", [[[self documentManager] activeDocument] name], (unsigned long)[tags count]);
  
  //NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags = [[self documentManager] FindAllUnlinkedTags];
  
  //FIXME: disabling unlinked tag loading temporarily
  //EWW REMOVED FUNCTIONALITY
  //[self setUnlinkedTags:[[self documentManager] FindAllUnlinkedTags]];
  
  //STDuplicateTagResults* duplicateTags = [[[self documentManager] TagManager] FindAllDuplicateTags];
  [self setDuplicateTags: [[[self documentManager] TagManager] FindAllDuplicateTags]];
  [self setOverlappingTags: [[[self documentManager] TagManager] FindAllOverlappingTags]];

  numGoodTags = [tags count];
  for(STTag* t in [self duplicateTags]) {
    numDuplicateTags += [[[self duplicateTags] objectForKey:t] count] + 1; //we need to include the parent tag as a duplicate
  }

  NSMutableArray<DocumentBrowserTagSummary*>* objs = [[NSMutableArray<DocumentBrowserTagSummary*> alloc] init];
  [objs addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:[NSString stringWithFormat:@"%@", @"All Tags"] andStyle:TagIndicatorViewTagStyleNormal withFocus:TagIndicatorViewTagFocusAllTags andCount:numGoodTags andDisplayCount:TRUE]];

  if (numDuplicateTags > 0) {
    [objs addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:@"Duplicate Tags" andStyle:TagIndicatorViewTagStyleWarning withFocus:TagIndicatorViewTagFocusDuplicateTags andCount:numDuplicateTags andDisplayCount:TRUE]];
  }
  
  if ([self overlappingTags] != nil && [[self overlappingTags] count] > 0) {
    int overlappingTagGroupCounter = 0;
    for (STCodeFile* key in [self overlappingTags]) {
      NSMutableArray<NSMutableArray<STTag*>*>* value = [self overlappingTags][key];
      if (value != nil) {
        overlappingTagGroupCounter += [value count];
      }
    }
    [objs addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:@"Overlapping Tags" andStyle:TagIndicatorViewTagStyleWarning withFocus:TagIndicatorViewTagFocusOverlappingTags andCount:overlappingTagGroupCounter andDisplayCount:TRUE]];
  }
  
  [objs addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:[NSString stringWithFormat:@"%@", @"Check Unlinked Tags"] andStyle:TagIndicatorViewTagStyleUnlinked withFocus:TagIndicatorViewTagFocusUnlinkedTags andCount:0 andDisplayCount:FALSE]];

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
-(void)codeFilesSetFocusOnOverlappingTags:(DocumentBrowserCodeFilesViewController*)controller
{
  if([[self delegate] respondsToSelector:@selector(codeFilesSetFocusOnOverlappingTags:)]) {
    [[self delegate] codeFilesSetFocusOnOverlappingTags:controller];
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
//  [_documentManager SaveCodeFileListToDocument:nil];
  [_documentManager SaveMetadataToDocument:[_documentManager activeDocument] metadata:[_documentManager LoadMetadataFromDocument:[_documentManager activeDocument] createIfEmpty:true]];

  
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
//  [_documentManager SaveCodeFileListToDocument:nil];
  [_documentManager SimpleSaveChanges];
//  [_documentManager SaveMetadataToDocument:[_documentManager activeDocument] metadata:[_documentManager LoadMetadataFromDocument:[_documentManager activeDocument] createIfEmpty:true]];

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
  
  [[[StatTagShared sharedInstance] logManager] WriteLog:@"Preparing to add file" logLevel:STLogVerbose];
  if ( [openPanel runModal] == NSModalResponseOK )
  {
    NSArray<NSURL*>* files = [openPanel URLs];
    [[[StatTagShared sharedInstance] logManager] WriteLog:[NSString stringWithFormat:@"Adding %lu files", [files count]] logLevel:STLogVerbose];
    [self addCodeFilesByURL:files];
    [[[StatTagShared sharedInstance] activeStatTagWordDocument] loadDocument];
    [[[StatTagShared sharedInstance] logManager] WriteLog:@"Reloaded document" logLevel:STLogVerbose];
  }
  else {
    [[[StatTagShared sharedInstance] logManager] WriteLog:@"Cancelled adding a file" logLevel:STLogVerbose];
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
      [[[StatTagShared sharedInstance] logManager] WriteLog:[NSString stringWithFormat:@"Adding file %@", url] logLevel:STLogVerbose];
      STCodeFile* cf = [[STCodeFile alloc] init];
      cf.FilePathURL = url;
      [codefiles addObject:cf];
    }
    else {
      [[[StatTagShared sharedInstance] logManager] WriteLog:[NSString stringWithFormat:@"Ignoring file %@ - not supported", url] logLevel:STLogVerbose];
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
  
  [_removeCodeFile setEnabled:[self enableRemoveCodeFile]];

  //re-sort in case the user has sorted a column
  [arrayController rearrangeObjects];

}

- (BOOL)enableRemoveCodeFile
{
  return [[self documentManager] HasCodeFiles] && [[arrayController selectionIndexes] count] > 0;
}

- (IBAction)removeFiles:(id)sender {
  
  // If nothing is selected, don't prompt the user or proceed.
  NSIndexSet* selectedFiles = [arrayController selectionIndexes];
  if ([selectedFiles count] <= 0) {
    return;
  }
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSAlertStyleWarning];
  [alert setMessageText:@"Do you wish to remove the selected code files from your project?"];
  [alert addButtonWithTitle:@"Remove Code File"];
  [alert addButtonWithTitle:@"Cancel"];
  
  [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSModalResponse returnCode) {
    if (returnCode == NSAlertFirstButtonReturn) {
      NSIndexSet* selectedFiles = [arrayController selectionIndexes];
      [[[StatTagShared sharedInstance] logManager] WriteLog:[NSString stringWithFormat:@"Removing %lu files", [selectedFiles count]] logLevel:STLogVerbose];
      [arrayController removeObjectsAtArrangedObjectIndexes:selectedFiles];
      [arrayController rearrangeObjects];
      [[[StatTagShared sharedInstance] activeStatTagWordDocument] loadDocument];
      [_removeCodeFile setEnabled:[self enableRemoveCodeFile]];
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
  

//  DuplicateTagGroupRowView* groupCell = (DuplicateTagGroupRowView*)[tableView makeViewWithIdentifier:@"tagGroupCell" owner:self];
  NSTableCellView *cell = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:NULL];

  
  if(tableColumn != nil)
  {
    if([[tableColumn identifier] isEqualToString:@"tagIndicatorColumn"])
    {
      //the visual "tag" indicator in the top tag list table
      //
      TagIndicatorView* cell = (TagIndicatorView*)[tableView makeViewWithIdentifier:@"tagDashboardCell" owner:NULL];
      //cell = (TagIndicatorView*)[tableView makeViewWithIdentifier:@"tagIndicatorCellView" owner:NULL];
      DocumentBrowserTagSummary* summary = [[[self tagSummaryArrayController] arrangedObjects] objectAtIndex:row];
      if(summary)
      {
//        cell.textField.stringValue = [NSString stringWithFormat:@"%ld", (long)[summary tagCount]];
//        NSImage* img = [DocumentBrowserTagSummary colorImage:cell.imageView.image forTagIndicatorViewTagStyle:[summary tagStyle]];
//        cell.imageView.image = img;

        cell.tagLabel.stringValue = [summary tagGroupTitle];
        //[[cell tagCountLabel] setTextColor: [DocumentBrowserTagSummary textColorForTagIndicatorViewTagStyle:[summary tagStyle]]];
        if([summary tagStyle] == TagIndicatorViewTagStyleLoading) {
          cell.tagCountLabel.hidden = true;
          cell.tagImageView.hidden = true;
          cell.unlinkedTagImageView.hidden = true;
          cell.tagProgressIndicator.hidden = false;
          [cell.tagProgressIndicator startAnimation:self];
        }
        else if([summary tagStyle] == TagIndicatorViewTagStyleUnlinked) {
          cell.tagCountLabel.hidden = true;
          cell.tagImageView.hidden = true;
          cell.unlinkedTagImageView.hidden = false;
          cell.tagProgressIndicator.hidden = true;
        }
        else {
          cell.tagCountLabel.hidden = false;
          NSImage* img = [DocumentBrowserTagSummary colorImage:cell.tagImageView.image forTagIndicatorViewTagStyle:[summary tagStyle]];
          cell.tagImageView.image = img;
          cell.unlinkedTagImageView.hidden = true;

          cell.tagImageView.hidden = false;
          if ([summary displayCount]) {
            cell.tagCountLabel.stringValue = [NSString stringWithFormat:@"%ld", (long)[summary tagCount]];
          }
          else {
            cell.tagCountLabel.stringValue = @"";
          }
          [cell.tagProgressIndicator stopAnimation:self];
          cell.tagProgressIndicator.hidden = true;
        }
        
        return cell;
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
          case TagIndicatorViewTagFocusOverlappingTags:
            [self codeFilesSetFocusOnOverlappingTags:self];
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
      
      [_removeCodeFile setEnabled:[self enableRemoveCodeFile]];
      
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

-(void)beginLoadingUnlinkedTags
{
  //remove the unlinked tags
  [self setLoadingUnlinkedTags:YES];
  [self setUnlinkedTags: [[NSDictionary<NSString*, NSArray<STTag*>*> alloc] init]];
  [self updateTagSummary];
}
-(void)completeLoadingUnlinkedTags
{
  [self setUnlinkedTags: [[[StatTagShared sharedInstance] activeStatTagWordDocument] unlinkedTags]];
  [self setLoadingUnlinkedTags:NO];
  [self updateTagSummary];
}



@end
