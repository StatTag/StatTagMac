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
#import "STDocumentManager+FileMonitor.h"
#import "DocumentBrowserTagSummary.h"
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
}

//MARK: view controller events

-(void)viewDidAppear
{
  [self startMonitoringCodeFiles];
}

-(void)viewWillDisappear {
  [self stopMonitoringCodeFiles];
}

-(void)viewWillAppear {
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //NSLog(@"DocumentBrowserCodeFilesViewController.h loaded");

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(codeFileEdited:)
                                               name:@"codeFileEdited"
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(codeFileRenamed:)
                                               name:@"codeFileRenamed"
                                             object:nil];

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
  [self viewAllTags];
}




-(void)updateTagSummary
{
  NSInteger numGoodTags = 0;
  NSInteger numDuplicateTags = 0;
  NSInteger numUnlinkedTags = 0;
  
  for(STCodeFile* file in [self codeFiles]) {
    [file LoadTagsFromContent];
    NSLog(@"Loading code file: '%@' for doc: '%@'", [file FileName], [[[StatTagShared sharedInstance] doc] name]);
  }

  NSArray<STTag*>* tags = [[self documentManager] GetTags];
  NSLog(@"document [%@] has %ld tags", [[[self documentManager] activeDocument] name], (unsigned long)[tags count]);
  NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags = [[self documentManager] FindAllUnlinkedTags];
  //STDuplicateTagResults* duplicateTags = [[[self documentManager] TagManager] FindAllDuplicateTags];
  [self setDuplicateTags: [[[self documentManager] TagManager] FindAllDuplicateTags]];

  numGoodTags = [tags count];
  numUnlinkedTags = [unlinkedTags count];
  numDuplicateTags = [[self duplicateTags] count];

  [[tagSummaryArrayController content] removeAllObjects];
  
  [tagSummaryArrayController addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:[NSString stringWithFormat:@"%@", @"All Tags"] andStyle:TagIndicatorViewTagStyleNormal withFocus:TagIndicatorViewTagFocusAllTags andCount:numGoodTags]];

  if(numDuplicateTags > 0)
  {
    [tagSummaryArrayController addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:@"Duplicate Tags" andStyle:TagIndicatorViewTagStyleWarning withFocus:TagIndicatorViewTagFocusDuplicateTags andCount:numDuplicateTags]];
  }
  
  if(numUnlinkedTags > 0)
  {
    [tagSummaryArrayController addObject:[[DocumentBrowserTagSummary alloc] initWithTitle:@"Unlinked Tags" andStyle:TagIndicatorViewTagStyleError withFocus:TagIndicatorViewTagFocusUnlinkedTags andCount:numUnlinkedTags]];
  }
  
}


-(void)startMonitoringCodeFiles
{
  [[self documentManager] startMonitoringCodeFiles];
}

-(void)stopMonitoringCodeFiles
{
  [[self documentManager] stopMonitoringCodeFiles];
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
    [[self delegate] codeFilesSetFocusOnDuplicateTags:controller];
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
  [self updateTagSummary];
}

//go back and review - this isn't fired (should be...)
//FIXME: not sure why this isn't being called
- (void)removeObjectFromCodeFilesAtIndex:(NSUInteger)index {
  
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
  
  
  NSArray<NSString*>* types = [allowedExtensions_CodeFiles pathComponents];
  [openPanel setAllowedFileTypes:types];
  
  //BOOL isDir;
  //NSFileManager* fileManager = [NSFileManager defaultManager];
  
  if ( [openPanel runModal] == NSOKButton )
  {
    NSArray<NSURL*>* files = [openPanel URLs];
    
    for( NSInteger i = 0; i < [files count]; i++ )
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
  [arrayController removeObjectsAtArrangedObjectIndexes:selectedFiles];
  [arrayController rearrangeObjects];


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
  
  //http://stackoverflow.com/questions/28112787/create-a-custom-cell-in-a-nstableview
  
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
        //NSImage* img = [TagIndicatorView colorImage:cell.imageView.image  withTint:NSColor.yellowColor];
        NSImage* img = [DocumentBrowserTagSummary colorImage:cell.imageView.image forTagIndicatorViewTagStyle:[summary tagStyle]];
        cell.imageView.image = img;
        //cell.imageView.image = [NSImage imageNamed:@"tag_button"];
      }
    }
    else if([[tableColumn identifier] isEqualToString:@"tagIndicatorColumn"])
    {
      //our stat package icon
    }
    
    
  }
  //tagSummaryCellView
//  var viewIdentifier = "StandardTableCellView"
//  
//  if let column = tableColumn {
//    
//    switch column.identifier {
//      
//    case "nameColumn":
//      viewIdentifier = "nameCellView"
//      
//    default: break
//      
//    }
//  }
//return tableView.makeViewWithIdentifier(viewIdentifier, owner: self) as? NSView
  
  return cell;
}

-(void)viewAllTags
{
  if([[[self tagSummaryArrayController] arrangedObjects] count] > 0)
  {
    //TagIndicatorViewTagStyleNormal
    for(DocumentBrowserTagSummary* t in [[self tagSummaryArrayController] arrangedObjects])
    {
      if([t tagFocus] == TagIndicatorViewTagFocusAllTags)
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
  
  //[[aNotification object] identifier] 
  
  //ONLY listen for changes to our two tables
  //otherwise you're going to get a bunch of bad recursive events as we change other tables
  
  if([[[notification object] identifier] isEqualToString:@"tagSummaryTable"] || [[[notification object] identifier] isEqualToString:@"fileTableView"])
  {
    if([[[notification object] identifier] isEqualToString:@"tagSummaryTable"])
    {
      
      NSInteger row = [self.tagSummaryTableView selectedRow];
      if(row == -1) {
        row = [[self tagSummaryTableView] clickedRow];
      }
      if(row != -1)
      {
        //summary was selected, so we want to remove the code file selections
        //All Tags
        //Duplicate Tags
        //Unlinked Tags

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
      if(row == -1) {
        row = [[self fileTableView] clickedRow];
      }
      if(row != -1)
      {
        //code file was selected, so we want to remove the summary file selections
        //[[self tagSummaryTableView] deselectAll:nil];
        [[self tagSummaryArrayController] setSelectedObjects:[NSArray array]];
      }
      
      //since interaction with EITHER of these two tables impacts the other table,
      // only fire for the file table view
      [self codeFilesSetFocusOnTags:self];
      //[self selectedCodeFileDidChange:self];
    }
  }
  
  
  
//  NSInteger row = [self.documentsTableView selectedRow];
//  
//  if(row == -1) {
//    //row = [[self tableViewOnDemand] clickedRow];
//    row = [[self documentsTableView] clickedRow];
//  }
//  if(row > -1) {
//    NSString* doc_name = [[_documentsArrayController arrangedObjects] objectAtIndex:row];
//    if(doc_name != nil) {
//      [WordHelpers setActiveDocumentByDocName:doc_name];
//      [[self codeFilesViewController] configure];
//      //[[self codeFilesViewController] updateTagSummary];
//    }
//    //STMSWord2011Document* doc = [[_documentsArrayController arrangedObjects] objectAtIndex:row];
//    //if(doc != nil) {
//    //  [WordHelpers setActiveDocumentByDocName:[doc name]];
//    //}
//  }
}

@end
