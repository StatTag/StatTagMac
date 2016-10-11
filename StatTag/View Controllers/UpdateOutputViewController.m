//
//  UpdateOutputViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "UpdateOutputViewController.h"

#import "StatTag.h"
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
  // Do view setup here.
  

//  NSSegmentedControl* segment = [[NSSegmentedControl alloc] initWithFrame:NSMakeRect(0, 0, 200, 100)];
//  [segment setSegmentStyle:NSSegmentStyleSeparated];
  
  //this sort of works, but...
  // 1) wrong state
  // 2) not the button background - it's the entire view backgorund...
//  [[self filterButtonAll] setWantsLayer:YES];
//  [[[self filterButtonAll] layer] setBackgroundColor:[[NSColor whiteColor] CGColor]];
  
//  [[self filterButtonAll] cell] setBackgroundStyle:[NSBackgroundColorAttributeName]
  
//  [[self filterButtonAll] setCell:[ColoredButtonCell cellForButton: [self filterButton] withColor: [NSColor whiteColor]];
//   setCell: [ColoredButtonCell
//             cellForButton:myButton
//             withColor:[NSColor xxxColor]
//             ]
//   ];

  
}


-(void)viewWillAppear {
  //we need to reload the tags every time the view appears - it's possible code files were removed or the code file
  // was modified, etc.
  [self loadAllTags];

//  [[self filterButtonAll] setState:NSOnState];
  
  
// still doesn't work...
//  [[self buttonEdit] setWantsLayer:YES];
//  [[[self buttonEdit] layer] setBackgroundColor:[[NSColor whiteColor] CGColor]];

  
}

-(void)viewDidAppear {
  [[[StatTagShared sharedInstance] window] makeFirstResponder:[self tableViewOnDemand]];
}

//-(BOOL)enableAddTagButton {
//  return [[[self documentManager] GetCodeFileList] count] > 0 ? YES : NO;
//}
//-(BOOL)enableRemoveTagButton {
//  return NO;
//}


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
  
  //[self willChangeValueForKey:@"documentTags"];
  //_documentTags = [[NSMutableArray<STTag*> alloc] initWithArray:[_documentManager GetTags]];
  //[self didChangeValueForKey:@"documentTags"];
  [self setDocumentTags:[[NSMutableArray<STTag*> alloc] initWithArray:[_documentManager GetTags]]];
}

-(void)getTags {
  
  [_documentManager GetTags];
  
}


- (IBAction)selectOnDemandNone:(id)sender {
  [onDemandTags setSelectionIndexes:[NSIndexSet indexSet]];
}

- (IBAction)selectOnDemandAll:(id)sender {
  //OK, I expect this to break... our range end should be count - 1, not count, but... the selection is one item short if we do that
  [onDemandTags setSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[onDemandTags arrangedObjects] count])]];
}


- (IBAction)refreshTags:(id)sender {
  
  //  STStatsManager* stats = [[STStatsManager alloc] init:manager];
  //  for(STCodeFile* cf in [manager GetCodeFileList]) {
  //    NSLog(@"found codefile %@", [cf FilePath]);
  //    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
  //  }
  
  //  STStatsManager* stats = [[STStatsManager alloc] init:manager];
  //  for(STCodeFile* cf in [manager GetCodeFileList]) {
  //    NSLog(@"found codefile %@", [cf FilePath]);
  //
  //    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
  //                                                 filterMode:[STConstantsParserFilterMode TagList]
  //                                                tagsToRun:[onDemandTags selectedObjects]
  //                                           ];
  //    NSLog(@"result : %hhd", result.Success);
  //  }
  
  
  //  [self startRefreshingFields];
  [self startRefreshingFieldsWithModalController];
  //NSLog(@"success? %hhd", success);
  
  //  if(success) {
  //    [[self window] close];
  //  } else {
  //
  //  }
  //  [manager UpdateFields];
  
}
- (void)startRefreshingFieldsWithModalController {
  
  //tagUpdateProgressController
  
  if (tagUpdateProgressController == nil)
  {
    tagUpdateProgressController = [[UpdateOutputProgressViewController alloc] init];
  }

  tagUpdateProgressController.tagsToProcess = [NSMutableArray arrayWithArray:[onDemandTags selectedObjects]];
  tagUpdateProgressController.documentManager = _documentManager;
  tagUpdateProgressController.delegate = self;
  
  [self presentViewControllerAsSheet:tagUpdateProgressController];
  
  /*
  [[[self view] window] beginSheet:[[tagUpdateProgressController view] window] completionHandler:^(NSModalResponse returnCode){
    //NSLog(@"returnCode : %@", returnCode);
    tagUpdateProgressController = nil;
    if(returnCode == NSModalResponseOK) {
      [[[self view] window] close];
    } else {
      NSAlert *alert = [[NSAlert alloc] init];
      [alert setMessageText:@"StatTag encountered a problem"];
      [alert setInformativeText:@"StatTag could not update your selected tags"];
      [alert setAlertStyle:NSCriticalAlertStyle];
      [alert addButtonWithTitle:@"Ok"];
      [alert runModal];
    }
    
  }];
   */
  
}

- (void)dismissUpdateOutputProgressController:(UpdateOutputProgressViewController *)controller withReturnCode:(StatTagResponseState)returnCode {
  //FIXME: need to handle errors from worker sheet
  [self dismissViewController:controller];
  if(returnCode == OK) {
    //reload the tag list
    //[self documentManager] save
    //[self loadAllTags];
    //[[self documentManager] UpdateFields]; //don't do this here - we have the separate controller
    //[self loadAllTags];
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

//- (IBAction)cancel:(id)sender {
//  [[self window] close];
//}

- (IBAction)editTag:(id)sender {

  
  if (tagEditorController == nil)
  {
    tagEditorController = [[TagEditorViewController alloc] init];
  }
  
  NSInteger row = [[self tableViewOnDemand] rowForView:sender];
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
  } else {
    //could be cancel, could be error
  }
}



//MARK: tableview delegates
//-(id)tableView
//-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//  
//  // populate each row of our table view with data
//  // display a different value depending on each column (as identified in XIB)
//  
//  if ([tableColumn.identifier isEqualToString:@"tagPreviewText"]) {
//    
//    // first colum (numbers)
//    //return [self.numbers objectAtIndex:row];
//    
//  } else {
//    
//    // second column (numberCodes)
//    //return [self.numberCodes objectAtIndex:row];
//  }
//}

-(NSString*)tagPreviewText:(STTag*)tag {
  return @"hello";
}


@end
