//
//  UpdateOutputViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "UpdateOutputViewController.h"

#import "StatTagFramework.h"
#import "StatTagShared.h"
#import "UpdateOutputProgressViewController.h"
#import "TagEditorViewController.h"


@interface UpdateOutputViewController ()

@end

@implementation UpdateOutputViewController

@synthesize labelOnDemandSearchText;
@synthesize buttonOnDemandSelectAll;
@synthesize buttonOnDemandSelectNone;
@synthesize tableViewOnDemand;
@synthesize buttonRefresh;
@synthesize onDemandTags;
@synthesize documentTags = _documentTags;
@synthesize documentManager = _documentManager;

UpdateOutputProgressViewController* tagUpdateProgressController;
TagEditorViewController* tagEditorController;


BOOL breakLoop = YES;
#define maxloop 1000

-(id)init {
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"UpdateOutputViewController" owner:self topLevelObjects:nil];
  }
  return self;
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"UpdateOutputViewController" owner:self topLevelObjects:nil];
  }
  return self;
}


-(NSString*)filterAll {
  return @"x";
}
-(void)setFilterAll:(NSString*)value {
  
}

-(NSString*)filterTagFrequency {
  return _filterTagFrequency;
}
-(void)setFilterTagFrequency:(NSString*)value {
  
}
-(NSString*)filterTagType {
  return _filterTagType;
}
-(void)setFilterTagType:(NSString*)value {
  
}



- (void)viewDidLoad {
  [super viewDidLoad];
}


-(void)viewWillAppear {
  //we need to reload the tags every time the view appears - it's possible code files were removed or the code file
  // was modified, etc.
  [self loadAllTags];
}

-(void)viewDidAppear {
  [[[StatTagShared sharedInstance] window] makeFirstResponder:[self tableViewOnDemand]];
}

-(void)loadAllTags {
  [_documentManager LoadCodeFileListFromDocument:[[StatTagShared sharedInstance] doc]];
  
  for(STCodeFile* file in [_documentManager GetCodeFileList]) {
    [file LoadTagsFromContent];
  }
  
  if([[[self documentManager] GetCodeFileList] count] > 0) {
    [[self addTagButton] setEnabled:YES];
  } else {
    [[self addTagButton] setEnabled:NO];
  }
  
  [self setDocumentTags:[[NSMutableArray<STTag*> alloc] initWithArray:[_documentManager GetTags]]];
}

-(void)getTags {
  
  [_documentManager GetTags];
  
}

- (STTag*)selectTagWithName:(NSString*)tagName {
  
  STTag* tag = nil;
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name == %@", tagName];
  NSArray *filteredArray = [[onDemandTags arrangedObjects] filteredArrayUsingPredicate:predicate];
  tag =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
  
  if(tag != nil)
  {
    NSInteger tagIndex=[[onDemandTags arrangedObjects] indexOfObject:tag];
    if(NSNotFound == tagIndex) {
      NSLog(@"selectTagWithName couldn't find tag '%@' in onDemandTags", [tag Name]);
    } else {
      [onDemandTags setSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(tagIndex, tagIndex)]];
      return tag;
    }
  }
  return nil;
}


- (IBAction)selectOnDemandNone:(id)sender {
  [onDemandTags setSelectionIndexes:[NSIndexSet indexSet]];
}

- (IBAction)selectOnDemandAll:(id)sender {
  //OK, I expect this to break... our range end should be count - 1, not count, but... the selection is one item short if we do that
  [onDemandTags setSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[onDemandTags arrangedObjects] count])]];
}


- (IBAction)refreshTags:(id)sender {
  [self startRefreshingFieldsWithModalController];
}
- (void)startRefreshingFieldsWithModalController {
  if (tagUpdateProgressController == nil)
  {
    tagUpdateProgressController = [[UpdateOutputProgressViewController alloc] init];
  }

  tagUpdateProgressController.tagsToProcess = [NSMutableArray arrayWithArray:[onDemandTags selectedObjects]];
  tagUpdateProgressController.documentManager = _documentManager;
  tagUpdateProgressController.delegate = self;
  
  [self presentViewControllerAsSheet:tagUpdateProgressController];
}

- (void)dismissUpdateOutputProgressController:(UpdateOutputProgressViewController *)controller withReturnCode:(StatTagResponseState)returnCode {
  //FIXME: need to handle errors from worker sheet
  [self dismissViewController:controller];
  if(returnCode == OK) {
    //reload the tag list
    [self willChangeValueForKey:@"documentTags"];
    [self didChangeValueForKey:@"documentTags"];
  }
}

- (IBAction)insertTagIntoDocument:(id)sender {

  for(STTag* tag in [onDemandTags selectedObjects]) {
    [_documentManager InsertField:tag];
  }
  
  //need to figure out where we do this on a single tag within StatTag - doing this for all tags is expensive
  for(STMSWord2011Field* field in [[[StatTagShared sharedInstance] doc] fields]) {
    field.showCodes = ![field showCodes];
    field.showCodes = ![field showCodes];
  }
}


- (BOOL) getNewValues {
  return true;
}

- (BOOL) updateTagsInDocument {
  return true;
}

- (IBAction)editTag:(id)sender {
  if (tagEditorController == nil)
  {
    tagEditorController = [[TagEditorViewController alloc] init];
  }
  
  //NSInteger row = [[self tableViewOnDemand] rowForView:sender];
  NSInteger row = [[self tableViewOnDemand] selectedRow];
  if(row == -1) {
    row = [[self tableViewOnDemand] clickedRow];
  }
  if(row > -1) {
    STTag* selectedTag = [[onDemandTags arrangedObjects] objectAtIndex:row];
    if(selectedTag != nil) {
      tagEditorController.documentManager = _documentManager;
      tagEditorController.tag = selectedTag;
      tagEditorController.delegate = self;
      [self presentViewControllerAsSheet:tagEditorController];
    }
  }
}

- (IBAction)createTag:(id)sender {
  
  if (tagEditorController == nil)
  {
    tagEditorController = [[TagEditorViewController alloc] init];
  }

  tagEditorController.documentManager = _documentManager;
  tagEditorController.tag = nil;
  tagEditorController.delegate = self;
  [self presentViewControllerAsSheet:tagEditorController];
}

- (void)dismissTagEditorController:(TagEditorViewController *)controller withReturnCode:(StatTagResponseState)returnCode {
  //FIXME: need to handle errors from worker sheet
  [self dismissViewController:controller];
  if(returnCode == OK) {
    //no errors - so refresh the list of tags because we changed things
    [self loadAllTags];
  } else if (returnCode == Cancel) {
    [self loadAllTags];
  } else {
    //could be cancel, could be error
  }
}

-(NSString*)tagPreviewText:(STTag*)tag {
  return @"hello";
}


@end
