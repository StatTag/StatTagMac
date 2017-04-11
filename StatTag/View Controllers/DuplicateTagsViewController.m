//
//  DuplicateTagsViewController.m
//  StatTag
//
//  Created by Eric Whitley on 4/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "DuplicateTagsViewController.h"
#import "StatTagShared.h"
#import "StatTagFramework.h"
//#import "STDuplicateTagResults.h"
#import "STCodeFile+PackageIcon.h"
#import "DuplicateTagGroupRowView.h"
#import "DuplicateTagDetailRowView.h"
#import "STTag+TagContent.h"
#import "TagCodePeekViewController.h"

@interface DuplicateTagsViewController ()

@end

@implementation DuplicateTagsViewController

@synthesize tagGroupEntries = _tagGroupEntries;
@synthesize duplicateTags = _duplicateTags;

TagEditorViewController* duplicateTagEditorController;

//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"DuplicateTagsViewController";
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
//  [[self duplicateTagTableView] setDelegate:self];
}

//MARK: view event
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
  
  _popoverViewController = [[TagCodePeekViewController alloc] init];

  
}

-(void)setDuplicateTags:(STDuplicateTagResults *)duplicateTags
{
  _duplicateTags = duplicateTags;
  NSArray<DuplicateTagGroupEntry*>* t = [DuplicateTagGroupEntry initWithDuplicateTagResults:duplicateTags];
  [self setTagGroupEntries:t];
  NSLog(@"%@", t);
  [[self duplicateTagTableView] reloadData];
}
-(STDuplicateTagResults*)duplicateTags
{
  return _duplicateTags;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  NSLog(@"tagGroupEntries count : %ld", [[self tagGroupEntries] count]);
  return [[self tagGroupEntries] count];
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
  //if ([[self _entityForRow:row] isKindOfClass:[ATDesktopFolderEntity class]]) {
  if ([[[self tagGroupEntries] objectAtIndex:row] isGroup]) {
    return YES;
  } else {
    return NO;
  }
}

-(NSView*)subviewWithIdentifier:(NSString*)identifier fromView:(NSView*)view
{
  for(NSView* subview in [view subviews]) {
    if ([[subview identifier] isEqualToString:identifier]) {
      return subview;
    }
  }
  
  return nil;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSTableCellView *cell = nil;
  
  DuplicateTagGroupEntry* entry = [[self tagGroupEntries] objectAtIndex:row];
  
  
  if ([entry isGroup]) {
    DuplicateTagGroupRowView* groupCell = (DuplicateTagGroupRowView*)[tableView makeViewWithIdentifier:@"tagGroupCell" owner:self];
    groupCell.title.objectValue = [entry title];
    groupCell.subTitle.objectValue = [entry subTitle];
    [[groupCell imageView] setImage: [[[entry tag] CodeFile] packageIcon]];
    return groupCell;
    //tagPackageIcon
    //tagName
    //tagCodeFileName
  } else {
    DuplicateTagDetailRowView* detailCell = (DuplicateTagDetailRowView*)[tableView makeViewWithIdentifier:@"tagContentCell" owner:self];
    detailCell.tagName.objectValue = [[entry tag] Name];
    detailCell.tagType.objectValue = [[entry tag] Type];
    detailCell.tagLines.objectValue = [NSString stringWithFormat:@"Lines: %ld-%ld", [[[entry tag] LineStart] integerValue], (long)[[[entry tag] LineEnd] integerValue]];
    
    [[detailCell tagContent] setString:[[entry tag] tagContent]];
    
    /*
    if([[entry tag] LineStart] != nil && [[entry tag] LineEnd] != nil)
    {
      //NSString* linePreview;
      NSArray<NSString*>* content = [[[entry tag] CodeFile] Content];
      
      NSInteger startIndex = [[[entry tag] LineStart] integerValue] + 1; //begin tag line
      NSInteger endIndex = [[[entry tag] LineEnd] integerValue] ; //end tag line
      NSInteger rows = endIndex - startIndex;
      if([content count] > 0 && rows >= 0)
      {
        NSInteger count = MIN( [content count] - startIndex, rows );
        NSArray<NSString*>* contentRows = [content subarrayWithRange: NSMakeRange( startIndex, count )];
        //detailCell.tagContent.objectValue = [contentRows componentsJoinedByString:@"\n"];
        [[detailCell tagContent] setString: [contentRows componentsJoinedByString:@"\n"]];
      }
    }
    */
    
    
    return detailCell;

    //tagName
    //tagLines
    //tagType
  }
  
  return cell;
  
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
  //FIXME: this is bad - we're using fixed heights
  // we should calculate the content size and use that
  if(tableView == [self duplicateTagTableView])
  {
    DuplicateTagGroupEntry* entry = [[self tagGroupEntries] objectAtIndex:row];
    if([entry isGroup])
    {
      return 36;
    }
    return 80;
  }
  return [tableView rowHeight];
}

- (void) tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
  if (tableView == [self duplicateTagTableView]) {
    [[self duplicateTagTableView] noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row, 1)]];
  }
}

- (IBAction)peekAtCode:(id)sender
{
  [self createPopover];
  
  //NSTableView *targetButton = (NSTableView *)sender;
  
  // configure the preferred position of the popover
  NSRectEdge prefEdge = 1;

  NSInteger row = [[self duplicateTagTableView] selectedRow];
  if(row > -1)
  {
    DuplicateTagGroupEntry* entry = [[self tagGroupEntries] objectAtIndex:row];
    if(entry != nil && ![entry isGroup])
    {
      [[self popoverViewController] setTag:[entry tag]];
      self.popoverView.contentViewController = [self popoverViewController]; //not sure why we have to rebind this
      
      NSRect r = [[self duplicateTagTableView] frameOfCellAtColumn:0 row:[[self duplicateTagTableView] selectedRow]];
      
      [[self popoverView] showRelativeToRect:r ofView:sender preferredEdge:prefEdge];
    }
    else
    {
      [[self popoverView] close];
      
    }
  } else {
    [[self popoverView] close];
  }

  
//  // Create popover
//  NSPopover *entryPopover = [[NSPopover alloc] init];
//  [entryPopover setContentSize:NSMakeSize(200.0, 200.0)];
//  [entryPopover setBehavior:NSPopoverBehaviorTransient];
//  [entryPopover setAnimates:YES];
//  [entryPopover setContentViewController:_popoverViewController];
//
//  // Convert point to main window coordinates
//  NSRect entryRect = [sender convertRect:[sender view].bounds
//                                  toView:[[NSApp mainWindow] contentView]];
//  // Show popover
//  [entryPopover showRelativeToRect:entryRect
//                            ofView:[[NSApp mainWindow] contentView]
//                     preferredEdge:NSMinYEdge];
}

- (void)createPopover
{
  if (self.popoverView == nil)
  {
    // create and setup our popover
    _popoverView = [[NSPopover alloc] init];
    
    // the popover retains us and we retain the popover,
    // we drop the popover whenever it is closed to avoid a cycle
    
    self.popoverView.contentViewController = [self popoverViewController];
    self.popoverView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    self.popoverView.animates = YES;
    
    self.popoverView.behavior = NSPopoverBehaviorTransient;
    
    // so we can be notified when the popover appears or closes
    self.popoverView.delegate = self;
  }
}



//MARK: popover delegate

- (void)popoverWillShow:(NSNotification *)notification
{
  NSPopover *popover = notification.object;
  if (popover != nil)
  {
  }
}

- (void)popoverDidShow:(NSNotification *)notification
{
}

- (void)popoverWillClose:(NSNotification *)notification
{
  NSString *closeReason = [notification.userInfo valueForKey:NSPopoverCloseReasonKey];
  if (closeReason)
  {
    // closeReason can be:
    //      NSPopoverCloseReasonStandard
    //      NSPopoverCloseReasonDetachToWindow
  }
}

- (void)popoverDidClose:(NSNotification *)notification
{
  NSString *closeReason = [notification.userInfo valueForKey:NSPopoverCloseReasonKey];
  if (closeReason)
  {
    // closeReason can be:
    //      NSPopoverCloseReasonStandard
    //      NSPopoverCloseReasonDetachToWindow
  }
  
  // release our popover since it closed
  _popoverView = nil;
}


//- (IBAction)tblvwDoubleClick:(id)sender {
//  NSInteger row = [_tableViewMain selectedRow];
//  if (row != -1) {
//    ATDesktopEntity *entity = [self _entityForRow:row];
//    [[NSWorkspace sharedWorkspace] selectFile:[entity.fileURL path] inFileViewerRootedAtPath:nil];
//  }
//}




- (IBAction)editTag:(id)sender {
  if (duplicateTagEditorController == nil)
  {
    duplicateTagEditorController = [[TagEditorViewController alloc] init];
  }
  
  //NSInteger row = [[self tableViewOnDemand] rowForView:sender];
  NSInteger row = [[self duplicateTagTableView] selectedRow];
  if(row == -1) {
    row = [[self duplicateTagTableView] clickedRow];
  }
  if(row > -1) {
    if(![[[self tagGroupEntries] objectAtIndex:row] isGroup])
    {
      //only let clicking happen for detail / tag rows - not groups
      STTag* selectedTag = [[[self tagGroupEntries] objectAtIndex:row] tag];
      if(selectedTag != nil) {
        duplicateTagEditorController.documentManager = _documentManager;
        duplicateTagEditorController.tag = selectedTag;
        duplicateTagEditorController.delegate = self;
        [self presentViewControllerAsSheet:duplicateTagEditorController];
      }
    }
  }
}

- (void)dismissTagEditorController:(TagEditorViewController *)controller withReturnCode:(StatTagResponseState)returnCode {
  //FIXME: need to handle errors from worker sheet
  [self dismissViewController:controller];
  if(returnCode == OK) {
    //no errors - so refresh the list of tags because we changed things
    //[self loadAllTags];
    //call out to parent to refresh our tag list
  } else if (returnCode == Cancel) {
    //[self loadAllTags];
  } else {
    //could be cancel, could be error
  }
}


@end
