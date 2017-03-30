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

-(void)loadTagsForCodeFiles:(NSArray<STCodeFile*>*)codeFiles {
  [_documentManager LoadCodeFileListFromDocument:[[StatTagShared sharedInstance] doc]];
  
  for(STCodeFile* file in [_documentManager GetCodeFileList]) {
    [file LoadTagsFromContent];
  }

//  for(STCodeFile* file in codeFiles) {
//    [file LoadTagsFromContent];
//  }
  
  //FIXME: we should probably check these aginst the list of code files to be safe
  if([codeFiles count] > 0) {
    [[self addTagButton] setEnabled:YES];
  } else {
    [[self addTagButton] setEnabled:NO];
  }
  NSMutableArray<STTag*>* allTags = [[NSMutableArray<STTag*> alloc] initWithArray:[_documentManager GetTags]];
  NSMutableArray<STTag*>* filteredTags = [[NSMutableArray<STTag*> alloc] init];
  //FIXME: do this without loops - just do a filtered array
  //for now, validating
  for(STTag* t in allTags)
  {
    for(STCodeFile* f in codeFiles)
    {
      if([[f FilePath] isEqualToString:[[t CodeFile] FilePath]])
      {
        [filteredTags addObject:t];
      }      
    }
  }
  
  [self setDocumentTags:filteredTags];
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

/**
 This is used by the external AppleScript interface to select a tag
 We then use it immediately after to (likely) fire the tag UI
 */
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
      [onDemandTags setSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(tagIndex, 1)]];
      return tag;
    }
  }
  return nil;
}

/**
 This is used by the external AppleScript interface to select a tag
 We then use it immediately after to (likely) fire the tag UI
 */
- (STTag*)selectTagWithID:(NSString*)tagID {
  
  STTag* tag = nil;
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", tagID];
  NSArray *filteredArray = [[onDemandTags arrangedObjects] filteredArrayUsingPredicate:predicate];
  tag =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
  
  if(tag != nil)
  {
    NSInteger tagIndex=[[onDemandTags arrangedObjects] indexOfObject:tag];
    if(NSNotFound == tagIndex) {
      NSLog(@"selectTagWithID couldn't find tag '%@' in onDemandTags", [tag Name]);
    } else {
      [onDemandTags setSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(tagIndex, 1)]];
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
  [self startRefreshingFieldsWithModalController:NO];
}
- (void)startRefreshingFieldsWithModalController:(BOOL)insert {
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"tagInsertRefreshStarted" object:self userInfo:nil];

  if (tagUpdateProgressController == nil)
  {
    tagUpdateProgressController = [[UpdateOutputProgressViewController alloc] init];
  }

  tagUpdateProgressController.tagsToProcess = [NSMutableArray arrayWithArray:[onDemandTags selectedObjects]];
  tagUpdateProgressController.documentManager = _documentManager;
  tagUpdateProgressController.insert = insert;
  tagUpdateProgressController.delegate = self;
  
  [self presentViewControllerAsSheet:tagUpdateProgressController];
}

- (void)dismissUpdateOutputProgressController:(UpdateOutputProgressViewController *)controller withReturnCode:(StatTagResponseState)returnCode andFailedTags:(NSArray<STTag *> *)failedTags {
  //FIXME: need to handle errors from worker sheet
  [self dismissViewController:controller];
  if(returnCode == OK) {
    //reload the tag list
    [self willChangeValueForKey:@"documentTags"];
    [self didChangeValueForKey:@"documentTags"];
  }
  
  if([failedTags count] > 0)
  {
    [self alertUserToFailedTags:failedTags];
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"tagInsertRefreshCompleted" object:self userInfo:nil];
}

-(void)alertUserToFailedTags:(NSArray<STTag*>*)failedTags
{
  //we should really fix how this all works
  NSLog(@"failed tags : %@", failedTags);
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText:@"Not All Tags Could be Processed"];
  
  NSMutableString* content = [[NSMutableString alloc] initWithString:@"StatTag could not run the following tags\n"];
  for(STTag* t in failedTags)
  {
    [content appendString:[NSString stringWithFormat:@"•\t%@ (%@)\n", [t Name], [[t CodeFile] FileName] ]];
  }
  [content appendString:@"\nPlease try running your code file(s) directly in their respective statistical programs. Look for any warnings or errors that might prevent successful completion."];
 
  [alert setInformativeText:content];

  [alert setAlertStyle:NSWarningAlertStyle];
  [alert addButtonWithTitle:@"OK"];
  [alert beginSheetModalForWindow:[[self view] window] completionHandler:^(NSModalResponse returnCode) {
  }];

  
}

- (IBAction)insertTagIntoDocument:(id)sender {
  
  
 // [_documentManager InsertTagsInDocument:[onDemandTags selectedObjects]];

  /*
  for(STTag* tag in [onDemandTags selectedObjects]) {
    [_documentManager InsertField:tag];
  }

  //EWW 2017-03-02 - asked by team to add this in here
  //when we insert a tag (for now?) we also need to populate the value
  [self refreshTags:self];
   */
  [self startRefreshingFieldsWithModalController:YES];
  
  //we're double-generating this.......
//  for(STTag* tag in [onDemandTags selectedObjects]) {
//    for(STMSWord2011Field* field in [[[StatTagShared sharedInstance] doc] fields]) {
//      if([self isMatchForStatTagField:field forTag:tag])
//      {
//        field.showCodes = ![field showCodes];
//        field.showCodes = ![field showCodes];
//      }
//    }
//  }
  
  //need to figure out where we do this on a single tag within StatTag - doing this for all tags is expensive
//  for(STMSWord2011Field* field in [[[StatTagShared sharedInstance] doc] fields]) {
//    NSLog(@"fieldText : %@", [field fieldText]);
//    NSLog(@"fieldCode : %@", [[field fieldCode] content]);
//    
//    field.showCodes = ![field showCodes];
//    field.showCodes = ![field showCodes];
//  }
}

-(void)toggleWordFieldsForTag:(STTag*)tag
{
  for(STMSWord2011Field* field in [[[StatTagShared sharedInstance] doc] fields]) {
    if(field != nil && tag != nil && [[[field fieldCode] content] containsString:[NSString stringWithFormat:@"MacroButton %@", [STConstantsFieldDetails MacroButtonName]]] && [[[[field nextField] fieldCode] content] containsString:[NSString stringWithFormat:@"ADDIN %@", [tag Name]]])
    {
      field.showCodes = ![field showCodes];
      field.showCodes = ![field showCodes];
    }
  }
}


-(BOOL)isMatchForStatTagField:(STMSWord2011Field*)field forTag:(STTag*)tag
{
  if(field != nil && tag != nil && [[[field fieldCode] content] containsString:[NSString stringWithFormat:@"MacroButton %@", [STConstantsFieldDetails MacroButtonName]]] && [[[[field nextField] fieldCode] content] containsString:[NSString stringWithFormat:@"ADDIN %@", [tag Name]]])
  {
    return YES;
  }
  return NO;
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
    //[self loadAllTags];
  } else {
    //could be cancel, could be error
  }
}

-(NSString*)tagPreviewText:(STTag*)tag {
  return @"hello";
}


@end
