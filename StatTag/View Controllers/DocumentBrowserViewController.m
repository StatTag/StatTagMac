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
  self.codeFilesViewController.documentManager = _documentManager;
  self.codeFilesViewController.delegate = self;
  
  self.tagListViewController.documentManager = _documentManager;

}

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do view setup here.
  //we're goig to attach to the default notification center so we can force-reload changed documents
  // when the window regains focus


  //[[StatTagShared sharedInstance] configureBasicProperties];
  [self startObservingAppleScriptUpdates];
  [self startObservingTagChanges];
  [self startObservingAppFocus];
  
  NSView *cfView = self.codeFilesViewController.view;
  cfView.frame = self.codeFilesView.bounds;
  cfView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
  [self.codeFilesView setAutoresizesSubviews:YES];
  [self.codeFilesView addSubview:cfView];

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
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                          selector:@selector(loadDocsAndContent)
//                                              name:NSApplicationDidBecomeActiveNotification
//                                            object:nil];
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

}

-(void)setActiveDocument
{

//  [self tableViewSelectionDidChange:[[NSNotification alloc] init]];
  
  NSString* docName = [WordHelpers getActiveDocumentName];
  
  if(![[[[self documentsArrayController] selectedObjects] firstObject] isEqualToString:docName])
  {
    if(docName != nil)
    {
      for(NSString* name in [[self documentsArrayController] arrangedObjects])
      {
        if([docName isEqualToString:name])
        {
          [[self documentsArrayController] setSelectedObjects:[NSArray arrayWithObject:name]];
        }
      }
    }
  } else {
    //if it's already selected, select "all tags"
    [[self codeFilesViewController] viewAllTags];
  }

}


-(void)setActiveTag:(NSNotification*)notification
{
  
  //  [self tableViewSelectionDidChange:[[NSNotification alloc] init]];
  //FIXME: we should be using tag ID and not name - there can be multiple tags w/ the same name
  [self setActiveDocument];
  NSString* tagName = [[notification userInfo] objectForKey:@"TagName"];
  NSString* tagID = [[notification userInfo] objectForKey:@"TagID"];
  if(tagName != nil)
  {
    if([self tagListViewController] != nil)
    {
      //FIXME: we should be using tag ID and not name - there can be multiple tags w/ the same name
      STTag* tag = [[self tagListViewController] selectTagWithName:tagName];
      if(tag != nil)
      {
        //    [[[StatTagShared sharedInstance] tagsViewController] editTag:nil];
        [[self tagListViewController] editTag:tag];
      }
    }
    NSLog(@"told to focus on tag '%@' with id: '%@'", tagName, tagID);
  }
  
//  STTag* tag = [[[StatTagShared sharedInstance] tagsViewController] selectTagWithName:tagName];
//  NSLog(@"tag name : %@", [tag Name]);
//  if(tag != nil)
//  {
//    [[[StatTagShared sharedInstance] tagsViewController] editTag:nil];
//  }
//  
//  NSLog(@"%@", args);

  
}


-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  
  //http://stackoverflow.com/questions/28112787/create-a-custom-cell-in-a-nstableview
  
  NSTableCellView *cell = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:NULL];
  
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
//        NSImage* img = [TagIndicatorView colorImage:cell.imageView.image forTagIndicatorViewTagType:[summary tagType]];
//        cell.imageView.image = img;
//        //cell.imageView.image = [NSImage imageNamed:@"tag_button"];
//      }
    
  }
   */
  return cell;
}

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
      NSString* doc_name = [[_documentsArrayController arrangedObjects] objectAtIndex:row];
      if(doc_name != nil) {
        [WordHelpers setActiveDocumentByDocName:doc_name];
        [[self codeFilesViewController] configure];
        [self focusOnTags];
        //[[self codeFilesViewController] updateTagSummary];
      }
      //STMSWord2011Document* doc = [[_documentsArrayController arrangedObjects] objectAtIndex:row];
      //if(doc != nil) {
      //  [WordHelpers setActiveDocumentByDocName:[doc name]];
      //}
    }
  }

}


-(void)focusOnTags
{
  //remove all subviews first
  [[self focusView] setSubviews:[NSArray array]];
  NSView *fView = self.tagListViewController.view;
  fView.frame = self.focusView.bounds;
  fView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
  [self.focusView setAutoresizesSubviews:YES];
  [self.focusView addSubview:fView];
  
  //-(void)loadTagsForCodeFiles:(NSArray<STCodeFile*>*)codeFiles
  //NSIndexSet* selectedFiles = [[[self codeFilesViewController] fileTableView] selectedRowIndexes];
  NSArray<STCodeFile*>* files = [NSMutableArray arrayWithArray:[[[self codeFilesViewController]arrayController] selectedObjects]];
  if([files count] > 0)
  {
    [[self tagListViewController] loadTagsForCodeFiles:files];
  } else {
    //for now - just load all
    [[self tagListViewController] loadAllTags];
  }
}

- (void)selectedCodeFileDidChange:(DocumentBrowserCodeFilesViewController*)controller {
  NSLog(@"code file changed selection");
  [self focusOnTags];
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
      [current_word_doc_names addObject:[w name]];
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
  
  //NSLog(@"Added docs : %@", new_docs);
  //NSLog(@"Removed docs : %@", removed_docs);
  
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
}

@end
