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

@interface UnlinkedTagsViewController ()

@end

@implementation UnlinkedTagsViewController

@synthesize unlinkedTags = _unlinkedTags;
@synthesize unlinkedTagsArray = _unlinkedTagsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
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
}

-(void)setUnlinkedTags:(NSDictionary<NSString*, NSArray<STTag*>*>*)unlinkedTags
{
  _unlinkedTags = unlinkedTags;

  NSArray<UnlinkedTagGroupEntry*>* tagGroupEntries = [UnlinkedTagGroupEntry initWithUnlinkedTags:unlinkedTags];

  self.unlinkedTagsArray = tagGroupEntries;
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
  NSLog(@"selected code file");
  NSPopUpButton* btn = (NSPopUpButton*)sender;
  NSInteger row = [[self unlinkedTagsTableView] rowForView:sender];
  STTag* t = [[[self unlinkedTagsArray] objectAtIndex:row] tag];
  if(t && [t CodeFile])
  {
    if([[btn selectedItem] tag] == 1)
    {
      //tag 1 = link to new code file (choose new file from file system)
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
        NSDictionary<NSString *,STCodeFileAction *>* actions = [[NSDictionary<NSString *,STCodeFileAction *> alloc] initWithObjectsAndKeys:cfa, [[t CodeFile] FilePath], nil];
        [[self documentManager] UpdateUnlinkedTagsByCodeFile:actions];
        [btn selectItemAtIndex:0];
        [self unlinkedTagsDidChange:self];
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
          if([[[entry tag] CodeFile] isEqual: [t CodeFile]] )
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
          [cfa setParameter:[t CodeFile]];
          [cfa setLabel:@"Remove Tag"];//this doesn't matter for us, but adding for debugging
          //let's try re-linking...
          NSDictionary<NSString *,STCodeFileAction *>* actions = [[NSDictionary<NSString *,STCodeFileAction *> alloc] initWithObjectsAndKeys:cfa, [[t CodeFile] FilePath], nil];
          [[self documentManager] UpdateUnlinkedTagsByCodeFile:actions];
          [btn selectItemAtIndex:0];
          [self unlinkedTagsDidChange:self];
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
  NSLog(@"selected tag action - %@ for row %ld with tag: %ld", [btn selectedItem], row, [[btn selectedItem] tag]);
  if([[btn selectedItem] tag] == 1)
  {
    //tag 1 = link to existing code file
    //OK - per the docs for "UpdateUnlinkedTagsByTag" - we really don't need this.
    // if this is true : "ome of the actions may in fact affect multiple tags.  For example, re-linking the code file to the document for a single tag has the effect of re-linking it for all related tags."
    // then there's no point in having tag-level re-linking - because that's going to impact the _entire_ code file
    // so we're actually better off saying "just re-link the code file" since that's a more accurate depiction of what's going on here
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
        [self unlinkedTagsDidChange:self];
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
    NSLog(@"added files... %@", files);
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
    groupCell.codeFileName.objectValue = [[[entry tag] CodeFile] FileName];
    groupCell.codeFilePath.objectValue = [[[entry tag] CodeFile] FilePath];
    [[groupCell imageView] setImage: [[[entry tag] CodeFile] packageIcon]];
    if([[_documentManager GetCodeFileList] containsObject:[[entry tag] CodeFile]] && [[[entry tag] CodeFile] fileAccessibleAtPath])
    {
//      //ok, so - if the tag's code file is NOT already referenced OR the code file is no longer accessible, we want to draw the code file as a header WITH a dropdown, BUT...
//      // we don't want to draw the dropdown/action button if the code file is "valid" for StatTag
//        [[groupCell codeFileActionPopUpList] setHidden:YES]; //so we're going to hide it...
//        [[groupCell codeFilePopUpWidth] setConstant:0.0]; //and we're goign to shrink the constraint so the other UI elements are allowed to grow to fill

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



-(void)unlinkedTagsDidChange:(UnlinkedTagsViewController*)controller
{
  if([[self delegate] respondsToSelector:@selector(unlinkedTagsDidChange:)]) {
    [[self delegate] unlinkedTagsDidChange:controller];
  }
}


@end
