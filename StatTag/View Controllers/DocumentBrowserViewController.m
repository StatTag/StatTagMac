//
//  DocumentBrowserViewController.m
//  StatTag
//
//  Created by Eric Whitley on 3/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "DocumentBrowserViewController.h"
#import "StatTagShared.h"
#import "StatTagFramework.h"
#import "DocumentBrowserCodeFilesViewController.h"
#import "UpdateOutputViewController.h"
#import "UnlinkedTagsViewController.h"
#import "DocumentBrowserDocumentViewController.h"
#import "STDocumentManager+FileMonitor.h"

#import <QuartzCore/CALayer.h>

@interface DocumentBrowserViewController ()

@end

@implementation DocumentBrowserViewController

@synthesize documentManager = _documentManager;

- (void)awakeFromNib {
}

- (NSString *)nibName
{
  return @"DocumentBrowserViewController";
}

//restoring at runtime with storyboards
-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}

-(void)setup
{
  _documentManager = [[StatTagShared sharedInstance] docManager];
  self.documentBrowserDocumentViewController.documentManager = _documentManager;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setup];

  //we're goig to attach to the default notification center so we can force-reload changed documents
  // when the window regains focus


  //[[StatTagShared sharedInstance] configureBasicProperties];
  [self startObservingAppleScriptUpdates];
  [self startObservingTagChanges];
  [self startObservingAppFocus];

//  [self setup];

  NSView *docView = self.documentBrowserDocumentViewController.view;
  docView.frame = self.documentBrowserDocumentView.bounds;
  docView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
  [self.documentBrowserDocumentView setAutoresizesSubviews:YES];
  [self.documentBrowserDocumentView addSubview:docView];

  
//  NSView *cfView = self.codeFilesViewController.view;
//  cfView.frame = self.codeFilesView.bounds;
//  cfView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
//  [self.codeFilesView setAutoresizesSubviews:YES];
//  [self.codeFilesView addSubview:cfView];

}

-(void)startObservingAppleScriptUpdates
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(setActiveDocument)
                                               name:@"activeDocumentDidChange"
                                             object:nil];  

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(setActiveTag:)
                                               name:@"activeTagDidChange"
                                             object:nil];

}

-(void)startObservingTagChanges
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(tagInsertRefreshStarted)
                                               name:@"tagInsertRefreshStarted"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(tagInsertRefreshCompleted)
                                               name:@"tagInsertRefreshCompleted"
                                             object:nil];
}

-(void)startObservingAppFocus
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                          selector:@selector(viewApplicationDidBecomeActive)
                                              name:NSApplicationDidBecomeActiveNotification
                                            object:nil];
}
-(void)stopObservingAppFocus
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidBecomeActiveNotification object:nil];
  
//  [[NSNotificationCenter defaultCenter]addObserver:self
//                                          selector:@selector(loadDocsAndContent)
//                                              name:NSApplicationDidBecomeActiveNotification
//                                            object:nil];
}


-(void)tagInsertRefreshStarted
{
  [self stopObservingAppFocus];
}
-(void)tagInsertRefreshCompleted
{
  [self startObservingAppFocus];
}

-(void)stopObservingNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear
{
}

-(void)dealloc
{
  [self stopObservingNotifications];
}

-(void)viewDidAppear
{
  [self loadDocsAndContent];
  [self setup];

  //self.codeFilesView = _codeFilesViewController.view;
  
  //go read up on this post for why we're not able to connect the view outlet to the controller directly
  //http://stackoverflow.com/questions/20676801/how-do-you-get-a-custom-view-controller-to-load-its-view-into-placeholder-in-ano

  //examine our shared document notification events and see if we need to act
}

-(void)viewApplicationDidBecomeActive
{
  [self loadDocsAndContent];
  //NSLog(@"%@", [[self documentManager] fileNotifications]);
  
  NSString* userAlertInformation;
  NSString* userInformativeText = @"";
  NSString* movedFilesAlert = @"";
  NSString* deletedFilesAlert = @"";
  NSString* modifiedFilesAlert = @"";
  
  
  NSDictionary<NSString*, FileChangeNotificationData*>* fileChanges = [[self documentManager] getPrioritizedFileNotifications];
  NSLog(@"listing file notifications");
  NSLog(@"%@", fileChanges);
  if([[fileChanges allValues] count] > 0)
  {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allEditorsShouldClose" object:self userInfo:nil];

    
    NSMutableArray<NSString*>* modifiedFiles = [[NSMutableArray<NSString*> alloc] init];
    NSMutableArray<NSString*>* deletedFiles = [[NSMutableArray<NSString*> alloc] init];
    NSMutableArray<NSString*>* movedFiles = [[NSMutableArray<NSString*> alloc] init];
    for(NSString* k in [fileChanges allKeys])
    {
      FileChangeNotificationData* v = [fileChanges objectForKey:k];
      NSString* fileName = [[v filePath] lastPathComponent];
      if([v fileModified])
      {
        [modifiedFiles addObject:fileName];
      }
      if([v fileDeleted])
      {
        [deletedFiles addObject:fileName];
      }
      if([v fileMoved])
      {
        [movedFiles addObject:fileName];
      }
    }
    
    if([modifiedFiles count] > 0)
    {
      modifiedFilesAlert = [NSString stringWithFormat:@"\r\n\r\n\r\nModified:\r\n • %@", [modifiedFiles componentsJoinedByString:@"\r\n • "]];
    }
    if([deletedFiles count] > 0)
    {
      deletedFilesAlert = [NSString stringWithFormat:@"\r\n\r\nDeleted:\r\n • %@", [deletedFiles componentsJoinedByString:@"\r\n • "]];
    }
    if([movedFiles count] > 0)
    {
      movedFilesAlert = [NSString stringWithFormat:@"\r\n\r\nMoved or Renamed:\r\n • %@", [movedFiles componentsJoinedByString:@"\r\n • "]];
    }
    
    userAlertInformation = [NSString stringWithFormat:@"The following files were modified outside of StatTag. StatTag has refreshed to ensure you are using the latest content."];
    userInformativeText = [NSString stringWithFormat:@"%@%@%@", deletedFilesAlert, movedFilesAlert, modifiedFilesAlert ];
    
    [_documentsArrayController rearrangeObjects];
  }
  if(userAlertInformation != nil)
  {
    [STUIUtility WarningMessageBoxWithTitle:userAlertInformation andDetail:userInformativeText logger:nil];
  }
  //-(NSDictionary<NSString*, FileChangeNotificationData*>*)getPrioritizedFileNotifications
}

-(void)setActiveDocument
{

//  [self tableViewSelectionDidChange:[[NSNotification alloc] init]];
  
  
  NSString* docName = [WordHelpers getActiveDocumentName];// stringByReplacingOccurrencesOfString:@" [Compatibility Mode]" withString:@""];
  //NSString* activeCodeFilePath =
  
  NSArray<NSString*>* selectedFilePaths = [[[[[self documentBrowserDocumentViewController] codeFilesViewController] arrayController] selectedObjects] valueForKey:@"FilePath"];
  NSLog(@"selectedFilePaths : %@", selectedFilePaths);
  
  NSLog(@"active document: %@", [[[self documentsArrayController] selectedObjects] firstObject]);
  
  if(![[[[self documentsArrayController] selectedObjects] firstObject] isEqualToString:docName])
  {
    if(docName != nil)
    {
      for(NSString* name in [[self documentsArrayController] arrangedObjects])
      {
        if([docName isEqualToString:name])
        {
          //since we're changing documents we need to close any open editors
          [[NSNotificationCenter defaultCenter] postNotificationName:@"allEditorsShouldClose" object:self userInfo:nil];
          [[self documentsArrayController] setSelectedObjects:[NSArray arrayWithObject:name]];
        }
      }
    }
  } else {
    //if it's already selected, select "all tags"
    //FIXME: disabled
    //do we really want to reload all tags? maybe?
    //[self documentManager]
    //putting this in for now so we can reload (regardless of selection change... I know, I know...) because there might have been file changes outside of the app. This is probably not ideal and we really need to redo a lot of this code from the ground up
    [self setActiveDocumentAtIndex:[[self documentsArrayController] selectionIndex]];
    //[[self documentsArrayController] setSelectionIndex:[[self documentsArrayController] selectionIndex]];
    //[[self documentBrowserDocumentViewController] focusOnTags];
    //NSLog(@"document is already actively selected");
  }

  [self setSelectedCodeFilesForFilePaths:selectedFilePaths];
  
}

//if we want to go back and retain selection (because we're just trouncing all over the selections when we forcibly reload the document), then we need to just tell the app which code files were previously selected.
//yes - there's likely a better way to do this
-(void)setSelectedCodeFilesForFilePaths:(NSArray<NSString*>*)codeFilePaths
{
  NSMutableIndexSet* selectedIndexes = [[NSMutableIndexSet alloc] init];
  if(codeFilePaths && [codeFilePaths count] > 0 && [[[[[self documentBrowserDocumentViewController] codeFilesViewController] arrayController] arrangedObjects] count] > 0)
  {
    for(NSInteger i = 0; i < [[[[[self documentBrowserDocumentViewController] codeFilesViewController] arrayController] arrangedObjects] count]; i++)
    {
      if([codeFilePaths containsObject:[[[[[[self documentBrowserDocumentViewController] codeFilesViewController] arrayController] arrangedObjects] objectAtIndex:i] FilePath]])
      {
        [selectedIndexes addIndex:i];
      }
    }
    [[[[self documentBrowserDocumentViewController] codeFilesViewController] arrayController] setSelectionIndexes:selectedIndexes];
    //NSArray<NSString*>* selectedFilePaths = [[[[[self documentBrowserDocumentViewController] codeFilesViewController] arrayController] selectedObjects] valueForKey:@"FilePath"];
    //[[[[self documentBrowserDocumentViewController] codeFilesViewController] arrayController] selectionIndexes];
    
  }
}

/**
 Used by AppleScript to edit the identified tag
 */
-(void)setActiveTag:(NSNotification*)notification
{
  
  //  [self tableViewSelectionDidChange:[[NSNotification alloc] init]];
  //FIXME: we should be using tag ID and not name - there can be multiple tags w/ the same name
  [self setActiveDocument];
  NSString* tagName = [[notification userInfo] objectForKey:@"TagName"];
  NSString* tagID = [[notification userInfo] objectForKey:@"TagID"];
  NSInteger tagFieldID = [[[notification userInfo] objectForKey:@"TagFieldID"] integerValue];

  //get the tag data from our document field (by ID)
  //for(STMSWord2011Field* fld in [[[[StatTagShared sharedInstance] documentManager] activeDocument] fields])
  //{
  //  if([fld field] == tagFieldID)
  //  {
  //
  //  }
  //}
  STMSWord2011Field* fld = [[[[self documentManager] activeDocument] fields] objectAtIndex:tagFieldID];
  
  if(fld != nil)
  {

    NSString* jsonData = [fld fieldText];
    NSError *error = nil;
    NSData *JSONData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (!error && JSONDictionary) {
      tagName = [JSONDictionary valueForKey:@"Name"];
      NSString* codeFilePath = [JSONDictionary valueForKey:@"CodeFilePath"];
      
      if(tagName != nil && codeFilePath != nil)
      {
        tagID = [NSString stringWithFormat:@"%@--%@", tagName, codeFilePath];
      }
      //return [NSString stringWithFormat:@"%@--%@", (_Name == nil ? @"" : _Name), (_CodeFile == nil || [_CodeFile FilePath] == nil ? @"" : [_CodeFile FilePath])];
    }
    //STMSWord2011Field* dataField = [fields firstObject];
    //dataField.fieldText = [tag Serialize:nil];

  }
  
  if(tagName != nil || tagID != nil)
  {
    //FIXME: we should be using tag ID and not name - there can be multiple tags w/ the same name
    [[self documentBrowserDocumentViewController] openTagForEditingByName:tagName orID:tagID];
    //NSLog(@"told to focus on tag '%@' with id: '%@'", tagName, tagID);
  }
  
//  STTag* tag = [[[StatTagShared sharedInstance] tagsViewController] selectTagWithName:tagName];
//  //NSLog(@"tag name : %@", [tag Name]);
//  if(tag != nil)
//  {
//    [[[StatTagShared sharedInstance] tagsViewController] editTag:nil];
//  }
//  
//  //NSLog(@"%@", args);

}


//-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
//{
//  
//  //http://stackoverflow.com/questions/28112787/create-a-custom-cell-in-a-nstableview
//  
//  NSTableCellView *cell = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:NULL];

//  docListTable
//  docListColumn
//  docListTableCellView
  
  /*
  if([[tableColumn identifier] isEqualToString:@"docListColumn"])
    {
//      //the visual "tag" indicator in the top tag list table
//      NSTableCellView *docViewCell = [tableView makeViewWithIdentifier:@"docListTableCellView" owner:NULL];
//      if(docViewCell != nil)
//      {
//        NSShadow *shadow = [[NSShadow alloc] init];
//        [shadow setShadowBlurRadius:4.0f];
//        [shadow setShadowOffset:CGSizeMake(4.0f, 4.0f)];
//        [shadow setShadowColor:[NSColor redColor]];
//        [shadow set];

        cell = [tableView makeViewWithIdentifier:@"docListTableCellView" owner:NULL];
        [[cell superview] setWantsLayer:YES];
        [[cell imageView] setWantsLayer:YES];
      
//        [[cell textField] setStringValue:@"hi"];
//        [[[cell imageView] layer] setBackgroundColor:[[NSColor redColor] CGColor]];
      
        CALayer *imageLayer = cell.imageView.layer;
        [imageLayer setShadowRadius:5.f];
        [imageLayer setShadowOffset:CGSizeZero];
        [imageLayer setShadowOpacity:0.5f];
        [imageLayer setShadowColor:CGColorCreateGenericGray(0, 1)];
        imageLayer.masksToBounds = NO;
      
        //[docViewCell.imageView setShadow:shadow];
        //cell = docViewCell;
//      }
//      cell = [tableView makeViewWithIdentifier:@"docListTableCellView" owner:NULL];
//      
      
//      DocumentBrowserTagSummary* summary = [[[self tagSummaryArrayController] arrangedObjects] objectAtIndex:row];
//      if(summary)
//      {
//        cell.textField.stringValue = [NSString stringWithFormat:@"%ld", (long)[summary tagCount]];
//        //NSImage* img = [TagIndicatorView colorImage:cell.imageView.image  withTint:NSColor.yellowColor];
//        NSImage* img = [TagIndicatorView colorImage:cell.imageView.image forTagIndicatorViewTagStyle:[summary tagType]];
//        cell.imageView.image = img;
//        //cell.imageView.image = [NSImage imageNamed:@"tag_button"];
//      }
    
  }
   */
//  return cell;
//}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
  
  if([[[notification object] identifier] isEqualToString:@"documentListTableView"])
  {
    NSInteger row = [self.documentsTableView selectedRow];
    
    if(row == -1) {
      //row = [[self tableViewOnDemand] clickedRow];
      row = [[self documentsTableView] clickedRow];
    }
    if(row > -1) {
      [self setActiveDocumentAtIndex:row];
      /*
      NSString* doc_name = [[_documentsArrayController arrangedObjects] objectAtIndex:row];
      if(doc_name != nil) {
        [WordHelpers setActiveDocumentByDocName:doc_name];
        STMSWord2011Document* doc = [[StatTagShared sharedInstance] doc];
        [[self documentBrowserDocumentViewController] setDocument:doc];
        //FIXME: removed
        //[[self codeFilesViewController] configure];
        //FIXME: removed
        //[self focusOnTags];

        //[[self codeFilesViewController] updateTagSummary];
      }
       */
      //STMSWord2011Document* doc = [[_documentsArrayController arrangedObjects] objectAtIndex:row];
      //if(doc != nil) {
      //  [WordHelpers setActiveDocumentByDocName:[doc name]];
      //}
    }
  }

}

-(void)setActiveDocumentAtIndex:(NSInteger)index
{
  NSString* doc_name = [[_documentsArrayController arrangedObjects] objectAtIndex:index];
  if(doc_name != nil) {
    [WordHelpers setActiveDocumentByDocName:doc_name];
    STMSWord2011Document* doc = [[StatTagShared sharedInstance] doc];
    [[self documentBrowserDocumentViewController] setDocument:doc];
    //FIXME: removed
    //[[self codeFilesViewController] configure];
    //FIXME: removed
    //[self focusOnTags];
    
    //[[self codeFilesViewController] updateTagSummary];
  }
}

-(void)doubleClickedDocumentRow
{
  
}


-(void)loadDocsAndContent
{
  //we can also use IB to do this on the array controller, but for now I want to explicitly manage this while testing
  
  //NOTE for postertiy - this will NOT work.
  // The API isn't working right. If you query "documents" directly you'll often get an incorrect list (missing names and duplicated names). It's inconsistent, but fails when you have modified your document list (in Word) by opening and closing a lot of documents
  // The work-around is to first list _windows_ in Word, then get their corresponding document. That seems to work and retrieve the correct document names.
  //NSArray<NSString*>* current_word_doc_names = [[[[[STGlobals sharedInstance] ThisAddIn] Application] documents] valueForKey:@"name"];

  NSMutableArray<NSString*>* current_word_doc_names = [[NSMutableArray<NSString*> alloc] init];
  for(STMSWord2011Window* w in [[[[STGlobals sharedInstance] ThisAddIn] Application] windows])
  {
    if([w document] != nil)
    {
      [current_word_doc_names addObject:[[w document ] name] ]; //stringByReplacingOccurrencesOfString:@" [Compatibility Mode]" withString:@""]];
    }
  }
  
  //we have 3 scenarios
  //1) matching docs in both sets
  //2) in our array controller, but not in our doc list (doc no longer active, so it should be removed)
  //3) in our doc list, but not in our array controller - new doc, so load it
  // we don't want to constantly refresh all 3 sets - we could have one already selected, which would disrupt the UI
  // we only want to attend to (1) and (3)
  
  NSArray<NSString*> *removed_docs = [[_documentsArrayController arrangedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT self IN %@", current_word_doc_names]];
  NSArray<NSString*> *new_docs = [current_word_doc_names filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT self IN %@", [_documentsArrayController arrangedObjects]]];
  
  ////NSLog(@"Added docs : %@", new_docs);
  ////NSLog(@"Removed docs : %@", removed_docs);
  
  //  [[_documentsArrayController content] removeAllObjects];
  //  [_documentsArrayController addObjects:current_word_doc_names];
  
  [[_documentsArrayController content] removeObjectsInArray:removed_docs];
  [_documentsArrayController addObjects:new_docs];
  
  NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
  [_documentsArrayController setSortDescriptors:@[sort_descriptor]];
  
  if([removed_docs count] > 0 || [new_docs count] > 0)
  {
    [_documentsArrayController rearrangeObjects];
  }
  
  [self setActiveDocument];

}






@end
