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
#import "STDocumentManager+FileMonitor.h"
#import "NSURL+FileAccess.h"

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
@synthesize activeCodeFiles = _activeCodeFiles;

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
  
  [self setActiveCodeFiles:codeFiles];
  
  for(STCodeFile* file in [_documentManager GetCodeFileList]) {
    [file LoadTagsFromContent];
  }

//  for(STCodeFile* file in codeFiles) {
//    [file LoadTagsFromContent];
//  }
  
  //FIXME: we should probably check these against the list of code files to be safe
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
  [self setActiveCodeFiles:nil];
  
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
- (STTag*)selectTagWithName:(NSString*)tagName orID:(NSString*)tagID {
  
  STTag* tag = nil;

  //let's try to match by ID
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", tagID];
  NSArray *filteredArray = [[onDemandTags arrangedObjects] filteredArrayUsingPredicate:predicate];
  tag =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
  
  //if we didn't hit one, then try just by name
  if(tag == nil)
  {
    predicate = [NSPredicate predicateWithFormat:@"Name == %@", tagName];
    filteredArray = [[onDemandTags arrangedObjects] filteredArrayUsingPredicate:predicate];
    tag =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
  }
  
  if(tag != nil)
  {
    NSInteger tagIndex=[[onDemandTags arrangedObjects] indexOfObject:tag];
    if(NSNotFound == tagIndex) {
      //NSLog(@"selectTagWithName couldn't find tag '%@' in onDemandTags", [tag Name]);
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
      //NSLog(@"selectTagWithID couldn't find tag '%@' in onDemandTags", [tag Name]);
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

- (void)dismissUpdateOutputProgressController:(UpdateOutputProgressViewController *)controller withReturnCode:(StatTagResponseState)returnCode andFailedTags:(NSArray<STTag *> *)failedTags withErrors:(NSDictionary<STTag*, NSException*>*)failedTagErrors{
  //FIXME: need to handle errors from worker sheet
  [self dismissViewController:controller];
  if(returnCode == OK && [failedTags count] <= 0) {
    //reload the tag list
    [self willChangeValueForKey:@"documentTags"];
    [self didChangeValueForKey:@"documentTags"];
  }
  
  if(returnCode == Error || [failedTags count] > 0)
  {
    [self alertUserToFailedTags:failedTags withErrors:failedTagErrors];
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"tagInsertRefreshCompleted" object:self userInfo:nil];
}

-(void)alertUserToFailedTags:(NSArray<STTag*>*)failedTags withErrors:(NSDictionary<STTag*, NSException*>*)failedTagErrors
{
  //we should really fix how this all works
  //NSLog(@"failed tags : %@", failedTags);
  
  if(failedTags == nil)
  {
    failedTags = [[NSArray<STTag*> alloc] init];
  }
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText:@"Not All Tags Could be Processed"];

  NSMutableString* content = [[NSMutableString alloc] init];
  if(failedTags == nil || [failedTags count] <= 0)
  {
    //it's possible we have generalized failures not directly related to a tag
    [content appendString:@"StatTag encountered an error and could not continue processing the requested tag(s).\n"];
  } else {
    [content appendString:@"StatTag could not run the following tags\n\n"];
    for(STTag* t in failedTags)
    {
      NSString* errorDetail = @"";
      if(failedTagErrors != nil)
      {
        NSException* ex = [failedTagErrors objectForKey:t];
        if(ex != nil && [ex userInfo] != nil)
        {
          NSString* errorStatisticalPackage = [[ex userInfo] valueForKey:@"StatisticalPackage"];
          NSString* errorCode = [[ex userInfo] valueForKey:@"ErrorCode"];
          NSString* errorDescription = [[ex userInfo] valueForKey:@"ErrorDescription"];
          errorDetail = [NSString stringWithFormat:@" %@ - %@ - %@", errorStatisticalPackage == nil ? @"" : errorStatisticalPackage, errorCode == nil ? @"" : errorCode, errorDescription == nil ? @"" : errorDescription];
        }
      }
      [content appendString:[NSString stringWithFormat:@"•  %@ (%@%@)\n", [t Name], [[t CodeFile] FileName], errorDetail ]];
    }
  }
  [content appendString:@"\nPlease try running your code file(s) directly in their respective statistical programs. Look for any warnings or errors that might prevent successful completion."];
 
  [alert setInformativeText:content];

  [alert setAlertStyle:NSWarningAlertStyle];
  [alert addButtonWithTitle:@"OK"];
  [alert beginSheetModalForWindow:[[self view] window] completionHandler:^(NSModalResponse returnCode) {
  }];

  
}

- (IBAction)insertTagIntoDocument:(id)sender {
  
  
  //[_documentManager InsertTagsInDocument:[onDemandTags selectedObjects]];

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
//    //NSLog(@"fieldText : %@", [field fieldText]);
//    //NSLog(@"fieldCode : %@", [[field fieldCode] content]);
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

  //don't do anything if there are no code files available
  BOOL canCreatTag = false;
  for(STCodeFile* cf in [[self documentManager] GetCodeFileList])
  {
    if([[cf FilePathURL] fileExistsAtPath])
    {
      canCreatTag = true;
      break;
    }
  }
  
  if(canCreatTag)
  {
    tagEditorController.documentManager = _documentManager;
    tagEditorController.tag = nil;
    tagEditorController.delegate = self;
    tagEditorController.originallySelectedCodeFile = [[self activeCodeFiles] firstObject];
    [self presentViewControllerAsSheet:tagEditorController];
  } else {
    [STUIUtility WarningMessageBoxWithTitle:@"No Code Files Available" andDetail:@"Creating a tag requires at least one code file be accessible. Please ensure you have added a code file to your document and that it is available at the location you specified." logger:nil];
  }
}

- (IBAction)deleteTag:(id)sender {

  NSMutableArray<STTag*>* tags = [NSMutableArray arrayWithArray:[onDemandTags selectedObjects]];
  NSInteger numSelectedTags = [tags count];

  if(numSelectedTags > 0)
  {
    //no tag deletion yet
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert setMessageText:[NSString stringWithFormat:@"Do you wish to remove the %ld selected tags from your project?", numSelectedTags]];
    [alert setInformativeText:[NSString stringWithFormat:@"Removing a tag will not materially change your code file. StatTag will remove references to the tag within the file, but leave the code itself intact.\n\nTags (%ld): %@", numSelectedTags, [[tags valueForKeyPath:@"@distinctUnionOfObjects.Name"] componentsJoinedByString:@", "]]];
    [alert addButtonWithTitle:@"Remove Tag"];
    [alert addButtonWithTitle:@"Cancel"];
    
    [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSModalResponse returnCode) {
      if (returnCode == NSAlertFirstButtonReturn) {
        //NSLog(@"tag deletion not yet implemented");
        
        //look in ManageTags.cs -> cmdRemove_Click
        for(STTag* tag in tags)
        {
          [[tag CodeFile] RemoveTag:tag];

          NSError* error;
          [[tag CodeFile] Save:&error];
        }
        //[self loadAllTags];
        [self allTagsDidChange:self];

      } else if (returnCode == NSAlertSecondButtonReturn) {
      }
    }];
  }


}

- (void)keyDown:(NSEvent *)theEvent
{
  if((id)[self tableViewOnDemand] == [(id)[NSApp keyWindow] firstResponder])
  {
    if([theEvent keyCode] == 51)
    {
      //delete
      [self deleteTag:tableViewOnDemand];
    }
  }
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  if(tableView == tableViewOnDemand)
  {
    NSEvent *e = [NSApp currentEvent];
    if (e.type == NSKeyDown && e.keyCode == 48) return NO;
    return YES;
  }
  return NO;
}


- (void)dismissTagEditorController:(TagEditorViewController *)controller withReturnCode:(StatTagResponseState)returnCode andTag:(STTag*)tag {
  //FIXME: need to handle errors from worker sheet
  [self dismissViewController:controller];
  if(returnCode == OK) {
    //no errors - so refresh the list of tags because we changed things
    //FIXME: we shouldn't have to do this - we should just reload the data and re-selected the items that were previously selected (code files)
    //[self loadAllTags];
    [self loadTagsForCodeFiles:[self activeCodeFiles]];
    
    if(tag)
    {
      [self selectTagWithID:[tag Id]];//selected the tag we just created or edited
    }
  } else if (returnCode == Cancel) {
    //[self loadAllTags];
  } else {
    //could be cancel, could be error
  }
}

-(NSString*)tagPreviewText:(STTag*)tag {
  return @"hello";
}

-(void)tableView:(NSTableView *)tableView sortDescriptorsDidChange: (NSArray *)oldDescriptors
{
  NSArray *newDescriptors = [tableView sortDescriptors];
  //[[[self onDemandTags] arrangedObjects] sortUsingDescriptors:newDescriptors];
  [[self onDemandTags] setSortDescriptors:newDescriptors];
  //"results" is my NSMutableArray which is set to be the data source for the NSTableView object.
//  [tableView reloadData];
}

-(void)allTagsDidChange:(UpdateOutputViewController*)controller
{
  if([[self delegate] respondsToSelector:@selector(allTagsDidChange:)]) {
    [[self delegate] allTagsDidChange:controller];
  }
}


@end
