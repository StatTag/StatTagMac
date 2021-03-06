//
//  UnlinkedTagsViewController.m
//  StatTag
//
//  Created by Eric Whitley on 3/30/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "UnlinkedTagsViewController.h"

#import "StatTagShared.h"
#import "StatTagFramework.h"
#import "STCodeFile+PackageIcon.h"
#import "UnlinkedTagsDetailRowView.h"
#import "UnlinkedTagsGroupRowView.h"
#import "UnlinkedTagGroupEntry.h"

#import "STCodeFile+FileAttributes.h"
#import "STCodeFile+FileMonitor.h"
#import "STDocumentManager+CodeFileManagement.h"
#import "STDocumentManager+FileMonitor.h"

#import "UnlinkedFieldCheckProgressViewController.h"

#import "StatTagWordDocument.h"


@interface UnlinkedTagsViewController ()

@end

@implementation UnlinkedTagsViewController

@synthesize unlinkedTags = _unlinkedTags;
@synthesize unlinkedTagsArray = _unlinkedTagsArray;

UnlinkedFieldCheckProgressViewController* unlinkedFieldProgressController;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
  [self view];//dumb but we want the self view loaded
}

- (NSString *)nibName
{
  return @"UnlinkedTagsViewController";
}

//restoring at runtime with storyboards
-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
    [self setup];
  }
  return self;
}

-(void)setup
{
  _unlinkedTagsArray = [[NSMutableArray<UnlinkedTagGroupEntry*> alloc] init];
  [[self unlinkedTagsTableView] setDelegate:self];
}

-(void)viewWillAppear
{
  //self.window = UIWindow(frame: UIScreen.main.bounds)
}

-(void)viewDidAppear
{
  if([[self view] window])
  {
    [self checkUnlinkedTagsWithModalController];
  }
}

//FIXME: refactor this... it's a mess. Once we started doing more stuff w/ the files and not just tags we bent this badly. Should just extend the document manager to manage this for us
-(void)setUnlinkedTags:(NSDictionary<NSString*, NSArray<STTag*>*>*)unlinkedTags
{
  _unlinkedTags = unlinkedTags;

  NSMutableArray<UnlinkedTagGroupEntry*>* tagGroupEntries;
  if(unlinkedTags != nil)
  {
    tagGroupEntries = [[UnlinkedTagGroupEntry initWithUnlinkedTags:unlinkedTags] mutableCopy];
    NSArray<STCodeFile*>* impactedCodeFiles = [[NSSet setWithArray:[tagGroupEntries valueForKey:@"codeFile"]] allObjects];
    for(STCodeFile* cf in [_documentManager unlinkedCodeFiles])
    {
      if(![impactedCodeFiles containsObject:cf])
      {
        [tagGroupEntries addObject:[[UnlinkedTagGroupEntry alloc] initWithCodeFile:cf andTag:nil isGroup:YES]];
      }
    }
    
    self.unlinkedTagsArray = tagGroupEntries;
  } else {
    
  }
  [[self unlinkedTagsArrayController] setContent:[self unlinkedTagsArray]];
  [[self unlinkedTagsTableView] reloadData];
  
}
-(NSDictionary<NSString*, NSArray<STTag*>*>*)unlinkedTags
{
  return _unlinkedTags;
}

//MARK: table drop-down actions (code file / tag)

- (IBAction)takeActionOnCodeFile:(id)sender
{
  //NSLog(@"selected code file");
  NSPopUpButton* btn = (NSPopUpButton*)sender;
  NSInteger row = [[self unlinkedTagsTableView] rowForView:sender];
  //STTag* t = [[[self unlinkedTagsArray] objectAtIndex:row] tag];
  STCodeFile* cfo = [[[self unlinkedTagsArray] objectAtIndex:row] codeFile];
  //if(t && [t CodeFile])
  if(cfo)
  {
    if([[btn selectedItem] tag] == 1)
    {
      //tag 1 = link to new code file (choose new file from file system)
      NSURL* filePath = [self getCodeFileFromUser:cfo];
      if(filePath != nil)
      {
        STCodeFile* cf = [[STCodeFile alloc] init];
        [cf setFilePathURL:filePath];
        STCodeFileAction* cfa = [[STCodeFileAction alloc] init];
        [cfa setAction:[STConstantsCodeFileActionTask ChangeFile]];
        [cfa setParameter:cf];
        [cfa setLabel:@"Link to New Code File"];//this doesn't matter for us, but adding for debugging
        //let's try re-linking...
        NSString* oldCodeFilePath = [cfo FilePath];
        NSDictionary<NSString *,STCodeFileAction *>* actions = [[NSDictionary<NSString *,STCodeFileAction *> alloc] initWithObjectsAndKeys:cfa, [cfo FilePath], nil];
        [[self documentManager] UpdateUnlinkedTagsByCodeFile:actions];
        [btn selectItemAtIndex:0];
        //this is risky... we don't entirely know for sure that the code file remapping worked, but we're going to continue to clean up after adding the new code file - by removing the old code file reference

        //remove the old code file
        //remove the file watcher for the existing code file
        [[self documentManager] stopMonitoringCodeFiles];
        [[self documentManager] RemoveCodeFile:oldCodeFilePath];
                
        //add the new code file
        //create a new file watcher for the new code file
        [[self documentManager] AddCodeFile:[filePath path]];
        [[self documentManager] startMonitoringCodeFiles];
        
//        NSLog(@"RELINKING CODE FILE");
        [self unlinkedTagsDidChange:self forCodeFilePath:oldCodeFilePath];
        //the above handles all of the code file and tag relinking
      }
    } else if ([[btn selectedItem] tag] == 2)
    {
      //tag 2 = remove ALL IMPACTED tags from document
      // this would be ALL tags directly related to the code file (since the link is broken)
      // *** this is not to be taken lightly *** - we should force a confirmation on this

      NSMutableArray<NSString*>* tagNames = [[NSMutableArray<NSString*> alloc] init];
      for(UnlinkedTagGroupEntry* entry  in [self unlinkedTagsArray])
      {
        if(![entry isGroup])
        {
          if([[[entry tag] CodeFile] isEqual: cfo] )
          {
            [tagNames addObject:[[entry tag] Name]];
          }
        }
      }
      
      NSAlert *alert = [[NSAlert alloc] init];
      [alert setAlertStyle:NSAlertStyleWarning];
      [alert setMessageText:[NSString stringWithFormat:@"Do you wish to remove these %ld tags from your Word document?", [tagNames count]]];
      [alert setInformativeText:[NSString stringWithFormat:@"Tags (%ld): %@", [tagNames count], [tagNames componentsJoinedByString:@", "]]];
      [alert addButtonWithTitle:@"Remove Tags"];
      [alert addButtonWithTitle:@"Cancel"];
      
      [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
          STCodeFileAction* cfa = [[STCodeFileAction alloc] init];
          [cfa setAction:[STConstantsCodeFileActionTask RemoveTags]];
          [cfa setParameter:cfo];
          [cfa setLabel:@"Remove Tag"];//this doesn't matter for us, but adding for debugging
          //let's try re-linking...
          NSDictionary<NSString *,STCodeFileAction *>* actions = [[NSDictionary<NSString *,STCodeFileAction *> alloc] initWithObjectsAndKeys:cfa, [cfo FilePath], nil];
          [[self documentManager] UpdateUnlinkedTagsByCodeFile:actions];
          [btn selectItemAtIndex:0];
          //[self unlinkedTagsDidChange:self];
          [self unlinkedTagsDidChange:self forCodeFilePath:[cfo FilePath]];
        } else if (returnCode == NSAlertSecondButtonReturn) {
          //clear the popup selection
          [btn selectItemAtIndex:0];
        }
      }];

    }
  }
}


- (IBAction)takeActionOnTag:(id)sender
{
  NSPopUpButton* btn = (NSPopUpButton*)sender;
  NSInteger row = [[self unlinkedTagsTableView] rowForView:sender];
  STTag* t = [[[self unlinkedTagsArray] objectAtIndex:row] tag];
//  NSLog(@"selected tag action - %@ for row %ld with tag: %ld", [btn selectedItem], row, [[btn selectedItem] tag]);
  if([[btn selectedItem] tag] == 1)
  {
    //tag 1 = link to existing code file
    //OK - per the docs for "UpdateUnlinkedTagsByTag" - we really don't need this.
    // if this is true (DocumentManager.cs) : "some of the actions may in fact affect multiple tags.  For example, re-linking the code file to the document for a single tag has the effect of re-linking it for all related tags."
    // then there's no point in having tag-level re-linking - because that's going to impact the _entire_ code file
    // so we're actually better off saying "just re-link the code file" since that's a more accurate depiction of what's going on here
    NSURL* filePath = [self getCodeFileFromUser:[t CodeFile]];
    if(filePath != nil)
    {
      STCodeFile* cf = [[STCodeFile alloc] init];
      [cf setFilePathURL:filePath];
      STCodeFileAction* cfa = [[STCodeFileAction alloc] init];
      [cfa setAction:[STConstantsCodeFileActionTask ChangeFile]];
      [cfa setParameter:cf];
      [cfa setLabel:@"Link to New Code File"];//this doesn't matter for us, but adding for debugging
      //let's try re-linking...
      NSDictionary<NSString *,STCodeFileAction *>* actions = [[NSDictionary<NSString *,STCodeFileAction *> alloc] initWithObjectsAndKeys:cfa, [t Id], nil];
      [[self documentManager] UpdateUnlinkedTagsByTag:actions];
      [btn selectItemAtIndex:0];
      //[self unlinkedTagsDidChange:self];
      [self unlinkedTagsDidChange:self forTag:t];
      //the above handles all of the code file and tag relinking
    }
   
  } else if ([[btn selectedItem] tag] == 2)
  {
    //tag 2 = remove INDIVIDUAL tag from document
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert setMessageText:@"Do you wish to remove this tag from your Word document?"];
    [alert setInformativeText:[NSString stringWithFormat:@"Tag: %@", [t Name]]];
    [alert addButtonWithTitle:@"Remove Tag"];
    [alert addButtonWithTitle:@"Cancel"];
    
    [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSModalResponse returnCode) {
      if (returnCode == NSAlertFirstButtonReturn) {
        STCodeFileAction* cfa = [[STCodeFileAction alloc] init];
        [cfa setAction:[STConstantsCodeFileActionTask RemoveTags]];
        [cfa setParameter:[t CodeFile]];
        [cfa setLabel:@"Remove Tag"];//this doesn't matter for us, but adding for debugging
        //let's try re-linking...
        NSDictionary<NSString *,STCodeFileAction *>* actions = [[NSDictionary<NSString *,STCodeFileAction *> alloc] initWithObjectsAndKeys:cfa, [t Id], nil];
        [[self documentManager] UpdateUnlinkedTagsByTag:actions];
        [btn selectItemAtIndex:0];
        //[self unlinkedTagsDidChange:self];
        [self unlinkedTagsDidChange:self forTag:t];
      } else if (returnCode == NSAlertSecondButtonReturn) {
        //clear the popup selection
        [btn selectItemAtIndex:0];
      }
    }];
  }
}

-(bool)confirmBasicModal:(STCodeFile*)cf
{
  return false;
}



//MARK: code file - relink
-(NSURL*)getCodeFileFromUser:(STCodeFile*)cf
{
  //we're going to try to relink the code file to a path
  NSOpenPanel* openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseFiles:YES];
  [openPanel setCanChooseDirectories:NO];
  [openPanel setCanSelectHiddenExtension:NO];
  [openPanel setPrompt:@"Select Files"];
  [openPanel setAllowsMultipleSelection:NO];//only allowing this one to be selected
  
  [openPanel setAllowedFileTypes:[STConstantsFileFilters SupportedFileFiltersArray]];
  
  if ( [openPanel runModal] == NSModalResponseOK )
  {
    NSArray<NSURL*>* files = [openPanel URLs];
    //NSLog(@"added files... %@", files);
    return [files firstObject];
  }
  return nil;
}



//MARK: Table View

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  //NSLog(@"tagGroupEntries count : %ld", [[self unlinkedTagsArray] count]);
  return [[self unlinkedTagsArray] count];
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSTableCellView *cell = nil;
  
  UnlinkedTagGroupEntry* entry = [[self unlinkedTagsArray] objectAtIndex:row];
  
  if ([entry isGroup]) {
    UnlinkedTagsGroupRowView* groupCell = (UnlinkedTagsGroupRowView*)[tableView makeViewWithIdentifier:@"unlinkedTagGroupRow" owner:self];
    groupCell.codeFileName.objectValue = [[entry codeFile] FileName];
    groupCell.codeFilePath.objectValue = [[entry codeFile] FilePath];
    [[groupCell imageView] setImage: [[entry codeFile] packageIcon]];
    /*
    if([[_documentManager GetCodeFileList] containsObject:[entry codeFile]] && [[entry codeFile] fileAccessibleAtPath])
    {
//      //ok, so - if the tag's code file is NOT already referenced OR the code file is no longer accessible, we want to draw the code file as a header WITH a dropdown, BUT...
//      // we don't want to draw the dropdown/action button if the code file is "valid" for StatTag
//        [[groupCell codeFileActionPopUpList] setHidden:YES]; //so we're going to hide it...
//        [[groupCell codeFilePopUpWidth] setConstant:0.0]; //and we're going to shrink the constraint so the other UI elements are allowed to grow to fill

      //leaving the above for reference - we will actually keep the ddl on the page at all times because there's a "remove all tags" option
      //if the code file is valid we're going to remove the action where a user re-links to a new code file
      for(NSInteger i = 0; i < [[[groupCell codeFileActionPopUpList] itemArray] count]; i++)
      {
        NSMenuItem* item = [[[groupCell codeFileActionPopUpList] itemArray] objectAtIndex:i];
        if([item tag] == 1) //1 = link to code file
        {
          [[groupCell codeFileActionPopUpList] removeItemAtIndex:i];
          break;
        }
      }
    }
     */
    
    
    return groupCell;
  }
  else
  {
    UnlinkedTagsDetailRowView* detailCell = (UnlinkedTagsDetailRowView*)[tableView makeViewWithIdentifier:@"unlinkedTagDetailRow" owner:self];
    detailCell.tagName.objectValue = [[entry tag] Name];
    detailCell.tagType.objectValue = [[entry tag] Type];
    return detailCell;
  }

  return cell;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
  //if ([[self _entityForRow:row] isKindOfClass:[ATDesktopFolderEntity class]]) {
  if ([[[self unlinkedTagsArray] objectAtIndex:row] isGroup]) {
    return YES;
  } else {
    return NO;
  }
}


-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
  //FIXME: this is bad - we're using fixed heights
  // we should calculate the content size and use that
  if(tableView == [self unlinkedTagsTableView])
  {
    UnlinkedTagGroupEntry* entry = [[self unlinkedTagsArray] objectAtIndex:row];
    if([entry isGroup])
    {
      return 40;
    }
    return 40;
  }
  return [tableView rowHeight];
}

- (IBAction)linkCodeFileToNewPath:(id)sender {
}

-(void)unlinkedTagsDidChange:(UnlinkedTagsViewController*)controller forTag:(STTag*)tag
{
  [[[StatTagShared sharedInstance] activeStatTagWordDocument] cachesDidChangeForTags:@[tag] orCodeFilePath:nil];
  [self unlinkedTagsDidChange:controller];
}
-(void)unlinkedTagsDidChange:(UnlinkedTagsViewController*)controller forCodeFilePath:(NSString*)codeFilePath
{
  [[[StatTagShared sharedInstance] activeStatTagWordDocument] cachesDidChangeForTags:@[] orCodeFilePath:codeFilePath];
  [self unlinkedTagsDidChange:controller];
}

-(void)unlinkedTagsDidChange:(UnlinkedTagsViewController*)controller
{
  [self syncUnlinkedTags];
  [self checkUnlinkedTagsWithModalController];
  if([[self delegate] respondsToSelector:@selector(unlinkedTagsDidChange:)]) {
    [[self delegate] unlinkedTagsDidChange:controller];
  }
}

//MARK: unlinked tags progress controller delegate
- (void)checkUnlinkedTagsWithModalController {
  
  //[[NSNotificationCenter defaultCenter] postNotificationName:@"tagInsertRefreshStarted" object:self userInfo:nil];
  
  if (unlinkedFieldProgressController == nil)
  {
    unlinkedFieldProgressController = [[UnlinkedFieldCheckProgressViewController alloc] init];
  }
  
//  tagUpdateProgressController.tagsToProcess = [NSMutableArray arrayWithArray:[onDemandTags selectedObjects]];
  unlinkedFieldProgressController.documentManager = _documentManager;
//  tagUpdateProgressController.insert = insert;
  unlinkedFieldProgressController.delegate = self;
  
  if ([unlinkedFieldProgressController isViewLoaded] && [[unlinkedFieldProgressController view] window]) {
    // viewController is visible
  } else {
    [self presentViewControllerAsSheet:unlinkedFieldProgressController];
  }
}

- (void)dismissUnlinkedFieldCheckProgressViewController:(UnlinkedFieldCheckProgressViewController*)controller withReturnCode:(StatTagResponseState)returnCode
{
  if([controller view] && [[controller view] window])
  {
    [self dismissViewController:controller];
    [self syncUnlinkedTags];
    [[self unlinkedTagsArrayController] setContent:[self unlinkedTagsArray]];
    [[self unlinkedTagsTableView] reloadData];
  }
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"tagInsertRefreshCompleted" object:self userInfo:nil];
}

-(void)syncUnlinkedTags
{
  [[[StatTagShared sharedInstance] activeStatTagWordDocument] loadDocument];
//  NSLog(@"CODE FILE PATHS: %@", [[[StatTagShared sharedInstance] activeStatTagWordDocument] codeFilePaths]);
  [self setUnlinkedTags:[[[StatTagShared sharedInstance] activeStatTagWordDocument] unlinkedTags]];
//  NSLog(@"UNLINKED TAGS: %@", [self unlinkedTags]);
}




@end
