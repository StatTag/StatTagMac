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
  _unlinkedTagsArray = [[NSMutableArray<STTag*> alloc] init];
  [[self unlinkedTagsTableView] setDelegate:self];
}

-(void)viewWillAppear
{
  NSLog(@"appearing");
  NSLog(@"count : %ld", [[self unlinkedTagsArray] count]);
}

-(void)setUnlinkedTags:(NSDictionary<NSString*, NSArray<STTag*>*>*)unlinkedTags
{
  _unlinkedTags = unlinkedTags;
  NSMutableArray<STTag*>* tagList = [[NSMutableArray<STTag*> alloc] init];
  for (NSString* key in _unlinkedTags) {
    [tagList addObjectsFromArray:[_unlinkedTags objectForKey:key]];
  }
  
//  [[self unlinkedTagsArray] addObjectsFromArray:tagList];

  //[self willChangeValueForKey:@"unlinkedTagsArray"];
  [[self unlinkedTagsArray] setArray:tagList];
  [[self unlinkedTagsArrayController] setContent:[self unlinkedTagsArray]];
  //[self didChangeValueForKey:@"unlinkedTagsArray"];
  
  //NSLog(@"count : %ld", [[self unlinkedTagsArray] count]);
  //NSLog(@"count : %ld", [tagList count]);
  
//  [[self unlinkedTagsArrayController] setContent:tagList];
//  [[self unlinkedTagsArrayController] rearrangeObjects];

  [[self unlinkedTagsTableView] reloadData];
  
//  NSLog(@"stop here");
  
//  [self willChangeValueForKey:@"unlinkedTagsArrayController"];
//  [self didChangeValueForKey:@"unlinkedTagsArrayController"];

//  NSArray<DuplicateTagGroupEntry*>* t = [DuplicateTagGroupEntry initWithDuplicateTagResults:duplicateTags];
//  [self setTagGroupEntries:t];
//  NSLog(@"%@", t);
//  [[self duplicateTagTableView] reloadData];
}
-(NSDictionary<NSString*, NSArray<STTag*>*>*)unlinkedTags
{
  return _unlinkedTags;
}







- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  NSLog(@"tagGroupEntries count : %ld", [[self unlinkedTagsArray] count]);
  return [[self unlinkedTagsArray] count];
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSTableCellView *cell = nil;
  
  STTag* tag = [[self unlinkedTagsArray] objectAtIndex:row];
  if(tag != nil)
  {
    UnlinkedTagsDetailRowView* detailCell = (UnlinkedTagsDetailRowView*)[tableView makeViewWithIdentifier:@"unlinkedTagDetailRow" owner:self];

    detailCell.tagName.objectValue = [tag Name];
    detailCell.tagType.objectValue = [tag Type];
    detailCell.codeFileName.objectValue = [[tag CodeFile] FileName];
    detailCell.codeFilePath.objectValue = [[tag CodeFile] FilePath];
    [[detailCell imageView] setImage: [[tag CodeFile] packageIcon]];
    return detailCell;
  }
  
  return cell;
//  
//  if ([entry isGroup]) {
//    return groupCell;
//    //tagPackageIcon
//    //tagName
//    //tagCodeFileName
//  } else {
//    DuplicateTagDetailRowView* detailCell = (DuplicateTagDetailRowView*)[tableView makeViewWithIdentifier:@"tagContentCell" owner:self];
//    detailCell.tagName.objectValue = [[entry tag] Name];
//    detailCell.tagType.objectValue = [[entry tag] Type];
//    detailCell.tagLines.objectValue = [NSString stringWithFormat:@"Lines: %ld-%ld", [[[entry tag] LineStart] integerValue], (long)[[[entry tag] LineEnd] integerValue]];
//    
//    [[detailCell tagContent] setString:[[entry tag] tagContent]];
//    
//    /*
//     if([[entry tag] LineStart] != nil && [[entry tag] LineEnd] != nil)
//     {
//     //NSString* linePreview;
//     NSArray<NSString*>* content = [[[entry tag] CodeFile] Content];
//     
//     NSInteger startIndex = [[[entry tag] LineStart] integerValue] + 1; //begin tag line
//     NSInteger endIndex = [[[entry tag] LineEnd] integerValue] ; //end tag line
//     NSInteger rows = endIndex - startIndex;
//     if([content count] > 0 && rows >= 0)
//     {
//     NSInteger count = MIN( [content count] - startIndex, rows );
//     NSArray<NSString*>* contentRows = [content subarrayWithRange: NSMakeRange( startIndex, count )];
//     //detailCell.tagContent.objectValue = [contentRows componentsJoinedByString:@"\n"];
//     [[detailCell tagContent] setString: [contentRows componentsJoinedByString:@"\n"]];
//     }
//     }
//     */
//    
//    
//    return detailCell;
//    
//    //tagName
//    //tagLines
//    //tagType
//  }
//  
//  return cell;
  
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
  //FIXME: this is bad - we're using fixed heights
  // we should calculate the content size and use that
  if(tableView == [self unlinkedTagsTableView])
  {
    return 36;
  }
  return [tableView rowHeight];
}

@end
