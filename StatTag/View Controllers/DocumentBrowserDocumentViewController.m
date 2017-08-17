//
//  DocumentBrowserDocumentViewController.m
//  StatTag
//
//  Created by Eric Whitley on 4/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "DocumentBrowserDocumentViewController.h"

#import "StatTagShared.h"
#import "StatTagFramework.h"
#import "DocumentBrowserCodeFilesViewController.h"
#import "DocumentBrowserDocumentViewController.h"

#import "STDocumentManager+FileMonitor.h"
#import "NSURL+FileAccess.h"

@interface DocumentBrowserDocumentViewController ()

@end

@implementation DocumentBrowserDocumentViewController


//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"DocumentBrowserDocumentViewController";
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

-(void)dealloc
{
  [self stopMonitoringCodeFiles];
  //[self stopObservingNotifications];
}

//MARK: view events
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
  
  
  NSView *cfView = self.codeFilesViewController.view;
  cfView.frame = self.codeFilesView.bounds;
  cfView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
  [self.codeFilesView setAutoresizesSubviews:YES];
  [self.codeFilesView addSubview:cfView];
  
  self.codeFilesViewController.delegate = self;
  
 // [self beginObservingCodeFileMonitoringNotifications];
}

-(void)setDocumentManager:(STDocumentManager *)documentManager
{
  _documentManager = documentManager;
  self.codeFilesViewController.documentManager = _documentManager;
  //self.codeFilesViewController.documentBrowserDelegate = self;
  
  self.tagListViewController.documentManager = _documentManager;
  self.tagListViewController.delegate = self;
  self.duplicateTagsViewController.documentManager = _documentManager;
  self.duplicateTagsViewController.delegate = self;
  self.unlinkedTagsViewController.documentManager = _documentManager;
  self.unlinkedTagsViewController.delegate = self;
}
-(STDocumentManager*)documentManager
{
  return _documentManager;
}

-(void)setDocument:(STMSWord2011Document *)document
{
  [self stopMonitoringCodeFiles];
  _document = document;
  [self startMonitoringCodeFiles];
  //_documentManager.activeDocument = document;
  //FIXME: removed
  [[self codeFilesViewController] configure];
  //FIXME: removed
  [self focusOnTags];
  [[self codeFilesViewController] focusOnTags:TagIndicatorViewTagFocusAllTags];
}
-(STMSWord2011Document*)document
{
  return _document;
}


-(void)focusOnDuplicateTags
{
  if(![[[self focusView] subviews] containsObject:[[self duplicateTagsViewController] view]])
  {
    [[self focusView] setSubviews:[NSArray array]];
    NSView *fView = self.duplicateTagsViewController.view;
    fView.frame = self.focusView.bounds;
    fView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
    [self.focusView setAutoresizesSubviews:YES];
    [self.focusView addSubview:fView];
  }
  
  [[self duplicateTagsViewController] setDuplicateTags:[self duplicateTags]];
  [[self codeFilesViewController] focusOnTags:TagIndicatorViewTagFocusDuplicateTags];
}

-(void)focusOnUnlinkedTags
{
  if(![[[self focusView] subviews] containsObject:[[self unlinkedTagsViewController] view]])
  {
    [[self focusView] setSubviews:[NSArray array]];
    NSView *fView = self.unlinkedTagsViewController.view;
    fView.frame = self.focusView.bounds;
    fView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
    [self.focusView setAutoresizesSubviews:YES];
    [self.focusView addSubview:fView];
  }

  //we're cheating here a bit - we want to reuse the "unlinked tags" UI for relinking a code file
  /*
  NSMutableDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags = [[[self documentManager] FindAllUnlinkedTags] mutableCopy];
 
  for(STCodeFile* cf in [[self documentManager] GetCodeFileList])
  {
    if(![[cf FilePathURL] fileExistsAtPath])
    {
      if(![[unlinkedTags allKeys] containsObject:[cf FilePath]])
      {
        [unlinkedTags setObject:[[NSArray<STTag*> alloc] init] forKey:cf];
      }
    }
  }
  
  [[self unlinkedTagsViewController] setUnlinkedTags:unlinkedTags];
   */
  [[self unlinkedTagsViewController] setUnlinkedTags:[[self documentManager] FindAllUnlinkedTags]];
  [[self codeFilesViewController] focusOnTags:TagIndicatorViewTagFocusUnlinkedTags];
}

-(void)unlinkedTagsDidChange:(UnlinkedTagsViewController*)unlinkedTagsViewController
{
  //our unlinked tags changed
  [[self codeFilesViewController] configure];
  [[self unlinkedTagsViewController] setUnlinkedTags:[[self documentManager] FindAllUnlinkedTags]];
  if([[unlinkedTagsViewController unlinkedTags] count] > 0)
  {
    [self focusOnUnlinkedTags];
  } else {
    [self focusOnTags];
  }
}

-(void)focusOnTags
{
  //if we need to set the focus view to tags
  if(![[[self focusView] subviews] containsObject:[[self tagListViewController] view]])
  {
    //remove all subviews first
    [[self focusView] setSubviews:[NSArray array]];
    NSView *fView = self.tagListViewController.view;
    fView.frame = self.focusView.bounds;
    fView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
    [self.focusView setAutoresizesSubviews:YES];
    [self.focusView addSubview:fView];

  }
  //revisit this - we're reloading everything every time we focus
  NSArray<STCodeFile*>* files = [NSMutableArray arrayWithArray:[[[self codeFilesViewController]arrayController] selectedObjects]];
  if([files count] > 0)
  {
    [[self tagListViewController] loadTagsForCodeFiles:files];
  } else {
    //for now - just load all
    [[self tagListViewController] loadAllTags];
  }

}

/**
 Used by AppleScript to edit the identified tag
 */
-(void)openTagForEditingByName:(NSString*)tagName orID:(NSString*)tagID
{
  //FIXME: we should be using tag ID and not name - there can be multiple tags w/ the same name
  [self focusOnTags];
  if([self tagListViewController] != nil)
  {
    //FIXME: we should be using tag ID and not name - there can be multiple tags w/ the same name
    STTag* tag = [[self tagListViewController] selectTagWithName:tagName orID:tagID];
    
    if(tag == nil)
    {
      [[self codeFilesViewController] focusOnTags:TagIndicatorViewTagFocusAllTags];
      //the tag isn't found on the ones currently on screen, so load the whole tag list and check them all
      // we're going to also force the list back to "all" for this (easier, but not terribly efficient)
      tag = [[self tagListViewController] selectTagWithName:tagName orID:tagID];
    }
    
    if(tag != nil)
    {
      [[self tagListViewController] editTag:tag];
    }
  }
}

//- (void)selectedCodeFileDidChange:(DocumentBrowserCodeFilesViewController*)controller {
//  //NSLog(@"code file changed selection");
//  //This needs attention
//  // if the code file selection changed, we could have one of a few things:
//  // 1) a specific code / group of code filess were selected - we want to focus on tags
//  // 2) summary view - we want to focus on tags
//  //for the rest, we want to focus on the different interfaces appropriate for the selection
//  // 3) duplicate tags
//  // 4) unlinked tags
//  [self focusOnTags];
//}
//
//-(void)selectedTagSummaryDidChange:(DocumentBrowserCodeFilesViewController*)controller;
//{
//  //NSLog(@"tag summary changed selection");
//}

- (void)codeFilesSetFocusOnTags:(DocumentBrowserCodeFilesViewController*)controller {
  //NSLog(@"code file changed selection");
  [self focusOnTags];
}

-(void)codeFilesSetFocusOnDuplicateTags:(DocumentBrowserCodeFilesViewController*)controller;
{
  //NSLog(@"focusing on duplicate tags");
  //duplicateTags
  [self setDuplicateTags:[controller duplicateTags]];
  [self focusOnDuplicateTags];
}

-(void)codeFilesSetFocusOnUnlinkedTags:(DocumentBrowserCodeFilesViewController*)controller;
{
  //NSLog(@"focusing on unlinked tags");
  [self focusOnUnlinkedTags];
}


-(void)duplicateTagsDidChange:(DuplicateTagsViewController*)controller
{
  //our tags changed
  [[self codeFilesViewController] configure];
  //[self setDuplicateTags:[controller duplicateTags]];
  [self focusOnDuplicateTags];
}

-(void)allTagsDidChange:(UpdateOutputViewController*)controller
{
  //our tags changed
  [[self codeFilesViewController] configure];
  //[self setDuplicateTags:[controller duplicateTags]];
  [self focusOnTags];
}



//MARK: Code File Monitoring

-(void)beginObservingCodeFileMonitoringNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(codeFileEdited:)
                                               name:@"codeFileEdited"
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(codeFileRenamed:)
                                               name:@"codeFileRenamed"
                                             object:nil];
}

-(void)stopObservingNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)startMonitoringCodeFiles
{
  [self beginObservingCodeFileMonitoringNotifications];
  [[self documentManager] startMonitoringCodeFiles];
}

-(void)stopMonitoringCodeFiles
{
  [self stopObservingNotifications];
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


@end
