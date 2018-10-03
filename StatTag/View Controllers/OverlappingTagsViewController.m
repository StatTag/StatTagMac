//
//  OverlapingTagsViewController.m
//  StatTag
//
//  Created by Luke Rasmussen on 9/19/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import "OverlappingTagsViewController.h"
#import "StatTagShared.h"
#import "StatTagFramework.h"
#import "STCodeFile+PackageIcon.h"
#import "OverlappingTagsGroupRowView.h"
#import "OverlappingTagsDetailRowView.h"
#import "STTag+TagContent.h"
#import "TagCodePeekViewController.h"


@interface OverlappingTagsViewController ()

@end

@implementation OverlappingTagsViewController

@synthesize tagGroupEntries = _tagGroupEntries;
@synthesize overlappingTags = _overlappingTags;
@synthesize peekTitle = _peekTitle;

//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"OverlappingTagsViewController";
}

-(id)init
{
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}

-(id) initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _popoverViewController = [[TagCodePeekViewController alloc] init];
  _peekTitle = @"Peek";
}

-(void)setOverlappingTags:(STOverlappingTagResults *)overlappingTags
{
  _overlappingTags = overlappingTags;
  NSArray<OverlappingTagGroupEntry*>* t = [OverlappingTagGroupEntry initWithOverlappingTags:overlappingTags];
  [self setTagGroupEntries:t];
  [[self overlappingTagTableView] reloadData];
}

-(STOverlappingTagResults*)overlappingTags
{
  return _overlappingTags;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  //NSLog(@"tagGroupEntries count : %ld", [[self tagGroupEntries] count]);
  return [[self tagGroupEntries] count];
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
  if ([[[self tagGroupEntries] objectAtIndex:row] isGroup]) {
    return YES;
  } else {
    return NO;
  }
}

-(NSView*)subviewWithIdentifier:(NSString*)identifier fromView:(NSView*)view
{
  for (NSView* subview in [view subviews]) {
    if ([[subview identifier] isEqualToString:identifier]) {
      return subview;
    }
  }
  
  return nil;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  NSTableCellView *cell = nil;
  OverlappingTagGroupEntry* entry = [[self tagGroupEntries] objectAtIndex:row];
  if ([entry isGroup]) {
    OverlappingTagsGroupRowView* groupCell = (OverlappingTagsGroupRowView*)[tableView makeViewWithIdentifier:@"overlappingTagGroupRow" owner:self];
    groupCell.groupName.objectValue = [entry title];
    groupCell.codeFileName.objectValue = [entry subTitle];
    [groupCell.groupActionPopUpList addItemsWithTitles:[entry getTagNames]];
    [[groupCell imageView] setImage: [[entry codeFile] packageIcon]];
    return groupCell;
  }
  else {
    OverlappingTagsDetailRowView* detailCell = (OverlappingTagsDetailRowView*)[tableView makeViewWithIdentifier:@"overlappingTagDetailRow" owner:self];
    STTag* tag = [[entry tags] firstObject];
    detailCell.tagName.objectValue = [tag Name];
    detailCell.tagType.objectValue = [tag Type];
    detailCell.tagLines.objectValue = [NSString stringWithFormat:@"Lines: %ld-%ld", [[tag LineStart] integerValue], (long)[[tag LineEnd] integerValue]];
    return detailCell;
  }
  
  return cell;
  
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
  //FIXME: this is bad - we're using fixed heights
  // we should calculate the content size and use that
  if(tableView == [self overlappingTagTableView]) {
    OverlappingTagGroupEntry* entry = [[self tagGroupEntries] objectAtIndex:row];
    if([entry isGroup]) {
      return 36;
    }
    return 40;
  }
  return [tableView rowHeight];
}

- (void) tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
  if (tableView == [self overlappingTagTableView]) {
    [[self overlappingTagTableView] noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row, 1)]];
  }
}

- (IBAction)peekAtCode:(id)sender
{
  [self createPopover];

  NSInteger row = [[self overlappingTagTableView] rowForView:sender];
  if(row > -1) {
    OverlappingTagGroupEntry* entry = [[self tagGroupEntries] objectAtIndex:row];
    if(entry != nil && [entry isGroup]) {
      [[self popoverViewController] setCodeFile:[entry codeFile] withStart:[entry startIndex] andEnd:[entry endIndex]];
      self.popoverView.contentViewController = [self popoverViewController]; //not sure why we have to rebind this
      [[self popoverView] showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    }
    else {
      [[self popoverView] close];
    }
  }
  else {
    [[self popoverView] close];
  }
  
}

- (void)createPopover
{
  if (self.popoverView == nil) {
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

- (void)popoverDidClose:(NSNotification *)notification
{
  _popoverView = nil;
}

-(void)overlappingTagsDidChange:(OverlappingTagsViewController*)controller
{
  if([[self delegate] respondsToSelector:@selector(overlappingTagsDidChange:)]) {
    [[self delegate] overlappingTagsDidChange:controller];
  }
}

@end
