//
//  TagEditorViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/26/16.
//  Copyright © 2016 StatTag. All rights reserved.
//
/*
 
 TO DO:
 =================
 
 When our formatters are nil we have issues with absent components in the UI
 
 EX: I convert a figure to a table - the thousands separate doesn't show up.  And the thing doesn't really work...
 
 Go back and fix this - We want to initialize the tag structures at all times
 
 */

#import "TagEditorViewController.h"
#import "StatTagFramework.h"
#import "StatTagShared.h"
#import "UIUtility.h"


#import "DisclosureViewController.h"


#import "TagPreviewController.h"
#import "ViewUtils.h"

#import "STTag+Preview.h"

#import "ScintillaEmbeddedViewController.h"

#import "STCodeFile+FileAttributes.h"


@interface TagEditorViewController ()

@end

@implementation TagEditorViewController

@synthesize tag = _tag;
@synthesize documentManager = _documentManager;
@synthesize codeFileList = _codeFileList;
@synthesize sourceEditor = _sourceEditor;

@synthesize instructionTitleText = _instructionTitleText;
@synthesize allowedCommandsText = _allowedCommandsText;
@synthesize editable = _editable;

@synthesize originallySelectedCodeFile = _originallySelectedCodeFile;


STTag* _originalTag;
bool SaveOccurred;

//review this later for the table view
//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CocoaBindings/Tasks/images.html

static void *TagTypeContext = &TagTypeContext;


typedef enum {
  SaveActionTypeSaveAndClose = 1,
  SaveActionTypeSaveAndCreateAnother = 2
} SaveActionType;

typedef enum {
  CodeFindActionTypeBack = 0,
  CodeFindActionTypeForward = 1
} CodeFindActionType;


-(void)startObservingEditorDirectives
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(forciblyDismissEditor)
                                               name:@"allEditorsShouldClose"
                                             object:nil];
}

-(void)stopObservingNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(BOOL)showTagValuePropertiesView {
  return _showTagValuePropertiesView;
}
-(void)setShowTagValuePropertiesView:(BOOL)newValue {
  _showTagValuePropertiesView = newValue;
}


-(void)awakeFromNib {
  
  _instructionTitleText = [[NSMutableAttributedString alloc] initWithString: @""];
  _allowedCommandsText = @"";
  
  //build our stack view
  [self initializeStackView];
  
  //only need to do these once - globally
  self.tagBasicProperties.delegate = self;
  self.tagValueProperties.delegate = self;
  self.tagTableProperties.delegate = self;
  
  //search field delegate
  //[[self findCodeTextSearchField] setDelegate:self];
  
  [self setShowTagValuePropertiesView:NO];

}

-(void)initializeStackView {
  [ViewUtils fillView:_tagBasicPropertiesView withView:[_tagBasicProperties view]];
  [ViewUtils fillView:_tagValuePropertiesView withView:[_tagValueProperties view]];
  [ViewUtils fillView:_tagTablePropertiesView withView:[_tagTableProperties view]];
  [ViewUtils fillView:_tagPreviewView withView:[_tagPreviewController view]];

  [_propertiesStackView layoutSubtreeIfNeeded];
  
  [_tagPreviewController setShowsPreviewText:YES];
  [_tagPreviewController setShowsPreviewImage:YES];
  
  // we want our views arranged from top to bottom
  _propertiesStackView.orientation = NSUserInterfaceLayoutOrientationVertical;
  
  // the internal views should be aligned with their centers
  // (although since they'll all be the same width, it won't end up mattering)
  _propertiesStackView.alignment = NSLayoutAttributeCenterX;
  _propertiesStackView.spacing = 0; // No spacing between the disclosure views
  
  // have the stackView strongly hug the sides of the views it contains
  [_propertiesStackView setHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
  
  // have the stackView grow and shrink as its internal views grow, are added, or are removed
  [_propertiesStackView setHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
}

-(void)configureStackView {
  _tagBasicProperties.tag = [self tag];
  _tagValueProperties.tag = [self tag];
  _tagTableProperties.tag = [self tag];
  _tagPreviewController.tag = [self tag];
  //if (NSAppKitVersionNumber >= NSAppKitVersionNumber10_11)
  //{
  #if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_11
    [_propertiesStackView setDetachesHiddenViews:YES];
  #endif
  //}
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configureStackView];
}

-(void)viewWillAppear {

  [[self findCodeTextSearchField] setStringValue:@""];//clear out on re-open

  [[self tagValuePropertiesView] setHidden:YES];
  [[self tagTablePropertiesView] setHidden:YES];
  [ViewUtils fillView:[self sourceView] withView:[[self sourceEditor] view]];
}

-(void)viewDidLayout {
}

-(void)viewDidAppear {
  [[[self view] window] makeFirstResponder:[self view]]; //don't give focus to any specific control. EX: don't go to "search"
  
  [self startObservingEditorDirectives];
  [self initializeTagInfo];
}

-(void)initializeTagInfo
{
  if(_documentManager != nil) {
    //every time this view appears we need to completely refresh all code files
    [_codeFileList removeObjects:[_codeFileList arrangedObjects]];
    
    //add the code files - but only the accessible code files
    
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"fileAccessibleAtPath == %@", @"YES"];
    //NSArray<STCodeFile*>* filterArray = [[_documentManager GetCodeFileList] filteredArrayUsingPredicate:predicate];
    
    for(STCodeFile* cf in [_documentManager GetCodeFileList])
    {
      if([cf fileAccessibleAtPath])
      {
        [_codeFileList addObject: cf];
      }
    }
    
    
    //in either case - we're going to default to the top-most object in the code file list
    [self setCodeFile:nil];
    
    if(_tag != nil) {
      if([[self tag] Name] == nil) {
        [[self tag] setName:@""];
      }
      
      if([[self tag] ValueFormat] == nil) {
        [[self tag] setValueFormat:[[STValueFormat alloc] init]];
      }
      if([[self tag] TableFormat] == nil) {
        [[self tag] setTableFormat:[[STTableFormat alloc] init]];
      }
      if([[self tag] FigureFormat] == nil) {
        [[self tag] setFigureFormat:[[STFigureFormat alloc] init]];
      }
      
      //existing tag
      _originalTag = [[STTag alloc] initWithTag:_tag];
      
      _listCodeFile.enabled = NO; // We don't allow switching code files
      if([_tag LineStart] != nil && [_tag LineEnd] != nil) {
        NSArray<NSString*>* lines = [[_sourceEditor string] componentsSeparatedByString:@"\n"];
        int maxIndex = (int)[lines count] - 1;
        int startIndex = MAX(0, [[_tag LineStart] intValue] );
        startIndex = MIN(startIndex, maxIndex);
        int endIndex = MIN([[_tag LineEnd] intValue], maxIndex);
        ////NSLog(@"[[_tag LineStart] intValue] : %d", [[_tag LineStart] intValue]);
        ////NSLog(@"[[_tag LineEnd] intValue] : %d", [[_tag LineEnd] intValue]);
        for (int index = startIndex; index <= endIndex; index++)
        {
          ////NSLog(@"trying to add line at index: %d", index);
          [_sourceEditor setLineMarkerAtIndex:index];
        }
        [_sourceEditor scrollToLine:startIndex];
      }
      
      if([[[self tag] Type] isEqualToString: [STConstantsTagType Value]] ){
        [self UpdateForType:[[self tag]Type]];
      } else if([[[self tag] Type] isEqualToString: [STConstantsTagType Figure]] ){
        [self UpdateForType:[[self tag]Type]];
      } else if([[[self tag] Type] isEqualToString: [STConstantsTagType Table]] ){
        [self UpdateForType:[[self tag] Type]];
      } else if([[[self tag] Type] isEqualToString: [STConstantsTagType Verbatim]] ){
        [self UpdateForType:[[self tag] Type]];
      }
      
      
    } else {
      //probably a new tag
      _originalTag = nil;
      
      [[self tag] setName:@""];
      //create a new tag and set some defaults
      [self setTag:[[STTag alloc] init]];

      [[self tag] setType:[STConstantsTagType Value]];
      STValueFormat* v = [[STValueFormat alloc] init];
      STTableFormat* t = [[STTableFormat alloc] init];
      STFigureFormat* f = [[STFigureFormat alloc] init];
      [v setFormatType:[STConstantsValueFormatType Default]];
      [[self tag] setValueFormat:v];
      [[self tag] setTableFormat:t];
      [[self tag] setFigureFormat:f];
      //ack... I'd rather get this from the array controller, but...
      
      //if we have a code file that was active in the tag list UI, try to set the code file selection to that if we're editing
      if([self originallySelectedCodeFile])
      {
        [[self tag] setCodeFile:[self originallySelectedCodeFile]];
      } else {
        [[self tag] setCodeFile: [[[self documentManager] GetCodeFileList] firstObject]];
      }
      
      [self setCodeFile:[[self tag] CodeFile]];
      [[self tag] setRunFrequency:[STConstantsRunFrequency OnDemand]];

      //      [[self tag] setType:[STConstantsTagType Value]];
      [self UpdateForType:[[self tag] Type]];
      
      
      //EWW - not doing this - we're going to just let cocoa bindings handle it
      // that _is_ different - we're selecting the code file and not saying "hey, choose a code file"
      
      // If there is only one file available, select it by default
      //      if (Manager != null)
      //      {
      //        var files = Manager.GetCodeFileList();
      //        if (files != null && files.Count == 1)
      //        {
      //          cboCodeFiles.SelectedIndex = 0;
      //        }
      //      }
    }
    
    ////NSLog(@"view did appear stackview count = %lu", (unsigned long)[[_propertiesStackView views] count]);
    ////NSLog(@"tag from properties view : %@", [_tagBasicProperties tag]);
    [self updateTagTypeInformation:[[self tag] Type]];
    [self configureStackView];
  }
}

-(void)UpdateForType:(NSString*)tabIdentifier
{
  [self SetInstructionText];
}

-(void) SetInstructionText
{
  NSString* statPackage;

  //FIXME: this is bogus and gross... need to fix this to check for the "No Value" selection when we have a default list set
  if([[self listCodeFile] selectedItem] == nil || [[self listCodeFile] indexOfSelectedItem] < 0 || ![[[[[self listCodeFile] selectedItem] representedObject] className] isEqualToString:@"STCodeFile"])
  {
    return;
  }
  STCodeFile* selectedCodeFile = (STCodeFile*)[[[self listCodeFile] selectedItem] representedObject];
  statPackage = (selectedCodeFile == nil) ? @"tag" : [selectedCodeFile StatisticalPackage];

  [self willChangeValueForKey:@"instructionTitleText"];
  // ----------- BOLD OUR KEYWORDS
  //FIXME
  //circle back... this is ugly
  //http://stackoverflow.com/questions/12974120/nsattributedstring-change-style-to-bold-without-changing-pointsize
  //https://jaanus.com/how-to-easily-present-strings-with-bold-text-and-links-in-cocoa/
  
  NSFont* labelFont = [[self labelInstructionText] font];

  NSFontManager *fontManager = [NSFontManager sharedFontManager];
  NSFont *boldedFont = [fontManager fontWithFamily:[labelFont familyName]
                                            traits:NSBoldFontMask//|NSItalicFontMask - if you want to add more
                                            weight:0
                                              size:[labelFont pointSize]];
  if(boldedFont == nil) {
    boldedFont = labelFont;
  }
  NSDictionary* instructionAttention = [NSDictionary dictionaryWithObject:boldedFont forKey:NSFontAttributeName];
  _instructionTitleText = [[NSMutableAttributedString alloc] initWithString:@"The following "];
  [_instructionTitleText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:statPackage attributes:instructionAttention]];
  [_instructionTitleText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" commands may be used for " ]];
  [_instructionTitleText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[[self tag]Type] attributes:instructionAttention]];
  [_instructionTitleText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" output" ]];
  // -----------
  [self didChangeValueForKey:@"instructionTitleText"];

  NSObject<STIResultCommandList>* commandList = [UIUtility GetResultCommandList:selectedCodeFile resultType:[[self tag]Type]];
  
  [self willChangeValueForKey:@"allowedCommandsText"];
  _allowedCommandsText = (commandList == nil) ? @"(None specified)" : [[commandList GetCommands] componentsJoinedByString:@"\r\n"];
  [self didChangeValueForKey:@"allowedCommandsText"];
  
}


- (IBAction)setCodeFile:(id)sender {
  if([[[self listCodeFile] selectedItem] representedObject] != nil) {
    STCodeFile* aCodeFile = (STCodeFile*)[[[self listCodeFile] selectedItem] representedObject];
    [self LoadCodeFile:aCodeFile];
  }
}

-(void)LoadCodeFile:(STCodeFile*)codeFile {
 [ [self sourceEditor] loadSource:[codeFile ContentString] withPackageIdentifier:[codeFile StatisticalPackage]];
}

-(void)controlTextDidChange:(NSNotification *)notification {
  //  //in the XIB, make sure your text field points to file's owner as the delegate
  if([[[notification object] identifier] isEqualToString:@"codeSearchField"]){
    NSSearchField* searchField = (NSSearchField*) [notification object];

    //reset selection on search field change. Otherwise we just wind up searching forward on each keystroke
    [[_sourceEditor sourceEditor] setGeneralProperty:SCI_SETSELECTIONSTART value:0];
    [[_sourceEditor sourceEditor] setGeneralProperty:SCI_SETSELECTIONEND value:0];

    [self searchForTextInCodeFile:searchField backWards:NO];
  }
}

//submit on return
- (void)controlTextDidEndEditing:(NSNotification *)notification {

  if([[[notification object] identifier] isEqualToString:@"codeSearchField"]){

    //NSTextField *textField = [notification object];
    if([[[notification userInfo] objectForKey:@"NSTextMovement"] integerValue] == NSReturnTextMovement)
    {
      NSSearchField* searchField = (NSSearchField*) [notification object];
      [self searchForTextInCodeFile:searchField backWards:NO];
    }
  }
}


-(void)forciblyDismissEditor
{
  [self cancel:self];
}

- (IBAction)cancel:(id)sender {
  [self stopObservingNotifications];
  [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)Cancel andTag:nil];
}


- (IBAction)saveAndCreateAnother:(id)sender
{
  [self validateSave:SaveActionTypeSaveAndCreateAnother];
}

- (IBAction)saveButtonClick:(id)sender
{
  [self validateSave:SaveActionTypeSaveAndClose];
}

-(NSString*) detectStoppableCollision
{
  if ([self tag] == nil) {
    return nil;
  }

  STTagCollisionResult* collisionResult = [STTagUtil DetectTagCollision:[self tag]];
  if (collisionResult == nil) {
    // Unable to fully assess tag collision - assuming there are no issues
    return nil;
  }
  else if ([collisionResult Collision] == NoOverlap) {
    // There is no overlap detected with this tag and others
    return nil;
  }
  else if ([collisionResult CollidingTag] == nil) {
    // No coliding tag returned, so we can't really warn the user...
    return nil;
  }
  // So now we know there's some type of collision.  If we are editing a tag, and the tag collides
  // with itself, that's fine.  We will properly remove the old tag boundaries and apply the new ones.
  else if (_originalTag != nil && [[collisionResult CollidingTag] Equals:_originalTag usePosition:FALSE]) {
    return nil;
  }

  STTag* collidingTag = [collisionResult CollidingTag];
  NSString* error = [NSString stringWithFormat:@"The code that you have selected for your new tag overlaps with an existing tag ('%@').", [collidingTag Name]];
  return error;
}

//NOTE: we're not saving yet - this is all save VALIDATION
-(void)validateSave:(SaveActionType)actionAfterSave
{
  NSMutableArray<NSString*>* errorCollection = [[NSMutableArray<NSString*> alloc] init];
  NSError* saveWarning;
  BOOL duplicateTag = FALSE;
  BOOL emptyName = FALSE;
  STCodeFile* codeFile = [[[self listCodeFile] selectedItem] representedObject];

  // Check for duplicate names (if the name is set)
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if([[self tag] Name] != nil
     && [[[[self tag] Name] stringByTrimmingCharactersInSet: ws] length] > 0) {
    if ([STTagUtil ShouldCheckForDuplicateLabel:_originalTag newTag:[self tag]]) {
      // Tag names must be unique within a code file.  It's allowed (but not ideal) for them to be duplicated between code files
      for (STCodeFile* cf in [_documentManager GetCodeFileList]) {
        for (STTag* aTag in [cf Tags]) {
          // If the tag names match, and it is not the same object (purposely using != instead of !isEqual).
          if ([[aTag Name] isEqualToString:[[self tag] Name]] && aTag != [self tag]) {
            if([cf isEqual:codeFile]) {
              //same codefile, so this is an error
              duplicateTag = TRUE;
              [errorCollection addObject:[NSString stringWithFormat:@"Tag name is not unique.  Tag '%@' already appears in this code file.", [aTag Name]]];
            } else {
              //different codefile - we should warn
              NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
              [errorDetail setValue:[NSString stringWithFormat:@"The Tag name %@ is already used in code file %@. Tag names should be unique. You may continue, but it is suggested you use a different name.", [aTag Name], [cf FileName]] forKey:NSLocalizedDescriptionKey];
              saveWarning = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
            }
          }
        }
      }
    }
  }
  // Or, alert the user that they need to supply a name
  else {
    emptyName = TRUE;
    [errorCollection addObject:@"Tag name is blank."];
  }

  BOOL noSelectedLines = FALSE;
  // Check if there are lines selected
  NSArray<NSNumber*>* selectedIndices = [[self sourceEditor ] GetSelectedIndices];
  if([selectedIndices count] == 0) {
    noSelectedLines = TRUE;
    [[self tag] setLineStart: nil];
    [[self tag] setLineEnd: nil];
    [errorCollection addObject:@"No code selected. Select by clicking next to the line number."];
  }
  else if ([selectedIndices count] == 1) {
    [[self tag] setLineStart: [selectedIndices firstObject]];
    [[self tag] setLineEnd: [[self tag] LineStart]];
  }
  else {
    //http://stackoverflow.com/questions/15931112/finding-the-smallest-and-biggest-value-in-nsarray-of-nsnumbers
    [[self tag] setLineStart:[selectedIndices valueForKeyPath:@"@min.self"]];
    [[self tag] setLineEnd:[selectedIndices valueForKeyPath:@"@max.self"]];
  }

  BOOL stoppableCollision = FALSE;
  // Detect if there are any stoppable collisions
  NSString* collisionError = [self detectStoppableCollision];
  if (collisionError != nil) {
    stoppableCollision = TRUE;
    [errorCollection addObject:collisionError];
  }
  

  if([[[self tag] Type] isEqualToString:[STConstantsTagType Value]]) {
  } else if([[[self tag] Type] isEqualToString:[STConstantsTagType Table]]) {
  } else if([[[self tag] Type] isEqualToString:[STConstantsTagType Figure]]) {
  } else if([[[self tag] Type] isEqualToString:[STConstantsTagType Verbatim]]) {
  } else {
    [errorCollection addObject:@"Tag type is not yet supported."];
  }
  
  if (saveWarning != nil) {
    //warn the user - they can decide if they want to proceed
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Tag name is not unique"];
    [alert setInformativeText:[[saveWarning userInfo] valueForKey:NSLocalizedDescriptionKey ]];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Use this Tag name"];
    [alert beginSheetModalForWindow:[[self view] window] completionHandler:^(NSModalResponse returnCode) {
      //button orders are the order in which they're created above
      if (returnCode == NSAlertSecondButtonReturn) {
        [self saveAndClose:actionAfterSave];
      }
    }];
    return;
  }
  
  [[_tagBasicProperties tagNameLabel] setTextColor:(duplicateTag || emptyName) ? [NSColor redColor] : [NSColor blackColor]];
  [_marginLabel setTextColor:(noSelectedLines || stoppableCollision) ? [NSColor redColor] : [NSColor blackColor]];
  
  NSUInteger errorCollectionCount = [errorCollection count];
  //oops! something bad happened - tell the user
  if(errorCollectionCount > 0) {
    NSMutableString* errorMessage = [NSMutableString stringWithFormat:@"StatTag detected %lu problem%s with this tag:\r\n",
                                     errorCollectionCount, (errorCollectionCount == 1 ? "" : "s")];
    for (NSString* error in errorCollection) {
      [errorMessage appendFormat:@"- %@\r\n", error];
    }
    
    [errorMessage appendString:@"\r\nPlease see the User’s Guide for more information."];
    
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:errorMessage forKey:NSLocalizedDescriptionKey];
    NSError* saveError = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
    
    [NSApp presentError:saveError];
    return;
  } else {
    [self saveAndClose:actionAfterSave];
  }
}

- (IBAction)save:(id)sender {
  [self validateSave:SaveActionTypeSaveAndClose];
}

//-(void)resetTagUI
//{
////  [self initializeStackView];
////  [[self tagBasicProperties] setTag:[self tag]];
////  [[self tagValueProperties] setTag:[self tag]];
////  [[self tagTableProperties] setTag:[self tag]];
//  
////  [[self tagBasicProperties] resetTagUI];
////  [[self tagValueProperties] resetTagUI];
////  [[self tagTableProperties] resetTagUI];
////  [[self tagPreviewView] resetTagUI];
//  //and reset the ui
//}

-(void)createNewEmptyTag
{
  //reset the tag
  //[self willChangeValueForKey:@"tag"];
  //_tag = nil;
  [self setTag:nil];
  //[self didChangeValueForKey:@"tag"];
  [self initializeTagInfo];
  
  
  [[self tagBasicProperties] setTag:[self tag]];
  [[self tagValueProperties] setTag:[self tag]];
  [[self tagTableProperties] setTag:[self tag]];
 
  
//  [self resetTagUI];

//  [self tagTableProperties] reset
  
//  [[[self tagBasicProperties] tagNameTextbox] setStringValue:[[self tag] Name]];
//  [[[self tagBasicProperties] tagTypeList] selectItemAtIndex:0];
//  [self tagValueProperties] ta
  
  //  [[self tagNameTextbox] setStringValue:@""];
  //  [[self tagTypeList] selectItemAtIndex:0];

  
  //reset the position of our selected line in scintilla so we bounce around less
  [_sourceEditor scrollToLine:_scintillaLastLineNumber];

}

-(void)saveAndClose:(SaveActionType)actionAfterSave {
  
  //NOTE: this assumes validation already occured in "save"
  
  SaveOccurred = YES;
  
  //this isn't quite right, but leaving as is for now
  // we don't want the first selected line - we want the first VISIBLE line
  // for that to happen we'd need to extend the editor wrapper
  _scintillaLastLineNumber = [[[_sourceEditor GetSelectedIndices] firstObject] integerValue];
  
  NSError* saveError;
  NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
  
  [[[self tag] CodeFile] setContent:[NSMutableArray arrayWithArray:[[_sourceEditor string] componentsSeparatedByString: @"\r\n"]]];
  BOOL edited = [[self documentManager] EditTag:[self tag] existingTag:_originalTag];
  
  if(saveError != nil) {
    [NSApp presentError:saveError];
    return;
  }


  if(actionAfterSave == SaveActionTypeSaveAndCreateAnother)
  {
    //FIXME: this is wrong - just shimming this in here for the moment, but we should handle this differently
    //now that we've updated the code file, reload the editor so we can pull in the updated code file
    [self setCodeFile:nil];
    [[self documentManager] LoadAllTagsFromCodeFiles];//expensive - can we refesh the tag list from just one code file? (the selected one)
    
    for(STCodeFile* file in [_documentManager GetCodeFileList]) {
      if([file FilePath] == [[[self tag] CodeFile] FilePath])
      {
        [file LoadTagsFromContent];
        if ([_delegate respondsToSelector:@selector(respondsToSelector:)])
        {
          [[self delegate] tagsShouldRefreshForCodeFile:file];
        }
        //FIXME: we also need to call back to the delegate to refresh its tag list - otherwise, on cancel, the tag list is wrong
      }
    }
    
    [self createNewEmptyTag];
    //FIXME: should we stop observing notifications? revisit
    return;
  } else   if(actionAfterSave == SaveActionTypeSaveAndClose)
  {
    if(edited == YES || [errorDetail count] == 0)
    {
      [self stopObservingNotifications];
      [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)OK andTag:[self tag]];
      return;
    }
  }
  
  //FIXME: we're never going to hit this
  //something bad happened... we should probably have better error handling...
  [errorDetail setValue:[NSString stringWithFormat:@"StatTag was not able to save changes"] forKey:NSLocalizedDescriptionKey];
  saveError = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
  [NSApp presentError:saveError];
}

//MARK: tag basic properties delegate
- (void)tagFrequencyDidChange:(TagBasicPropertiesController*)controller {
  _tag.RunFrequency = [[[controller tagFrequencyList] selectedItem] representedObject];
}

- (void)tagNameDidChange:(TagBasicPropertiesController*)controller {
    [[controller tagNameTextbox] setStringValue: [[[controller tagNameTextbox] stringValue] stringByReplacingOccurrencesOfString:[STConstantsReservedCharacters TagTableCellDelimiter] withString:@""]];
  _tag.Name = [[controller tagNameTextbox] stringValue];
    //this might be smarter  - right now we actually wind up moving key positions, which is bad
    //http://stackoverflow.com/questions/12161654/restrict-nstextfield-to-only-allow-numbers
}

- (void)tagNameDidFinishEditing:(TagBasicPropertiesController*)controller {
  
}

- (void)tagTypeDidChange:(TagBasicPropertiesController*)controller {
  //NOTE: this is a placeholder - we can only get away with this right now because we have TWO views...
  // 1st view -> basic tag info
  // 2nd view -> value / table / figure properties
  //[[self tag] setValue:[[[controller tagTypeList] selectedItem] representedObject] forKey:@"Type"];

  //if we changed to table, we need to switch to numeric format
  if([[[self tag] Type] isEqualToString:[STConstantsTagType Table]]) {
    if(![[[self tag] ValueFormat] isEqualTo:[STConstantsValueFormatType Numeric]]) {
      STValueFormat* numeric = [[STValueFormat alloc] init];
      [numeric setFormatType:[STConstantsValueFormatType Numeric]];
      [[self tag] setValueFormat:numeric];
    }
  }
  
  [self updateTagTypeInformation: [[self tag] Type]];
  //[self updateTagTypeInformation:[[[controller tagTypeList] selectedItem] representedObject]];
}

-(void)updateTagTypeInformation:(NSString*)tagType {
  [self SetInstructionText]; //this is not a "Cocoa way" of doing this - we should be observing for changes

  if([tagType isEqualToString:[STConstantsTagType Value]]) {
    [[self tagValuePropertiesView] setHidden:NO];
  } else {
    #if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_11
    if([[_propertiesStackView arrangedSubviews] containsObject:[self tagValuePropertiesView]]) {
      [[self tagValuePropertiesView] setHidden:YES];
    }
    #else
    if([[_propertiesStackView subviews] containsObject:[self tagValuePropertiesView]])
    {
      [_propertiesStackView setVisibilityPriority:NSStackViewVisibilityPriorityNotVisible forView:[self tagValuePropertiesView]];
    }
    #endif
  }
  
  if([tagType isEqualToString:[STConstantsTagType Table]]) {
    [[self tagTablePropertiesView] setHidden:NO];
  } else {
    #if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_11
      if([[_propertiesStackView arrangedSubviews] containsObject:[self tagTablePropertiesView]]) {
        [[self tagTablePropertiesView] setHidden:YES];
      }
    #else
      if([[_propertiesStackView subviews] containsObject:[self tagTablePropertiesView]])
      {
        [_propertiesStackView setVisibilityPriority:NSStackViewVisibilityPriorityNotVisible forView:[self tagTablePropertiesView]];
      }
    #endif
  }


  [_propertiesStackView layoutSubtreeIfNeeded];

}


//MARK: tag value settings delegate
- (void)valueTypeDidChange:(ValuePropertiesController*)controller {
  //our radio button collection, etc. for default / percentage / date/time etc.
}


//MARK: table properties settings delegate

- (void)showColumnNamesDidChange:(TablePropertiesController*)controller {
}
- (void)showRowNamesDidChange:(TablePropertiesController*)controller {
}
- (void)decimalPlacesDidChange:(TablePropertiesController*)controller {
}
- (void)useThousandsSeparatorDidChange:(TablePropertiesController*)controller {
}


//MARK: Code File Search
- (IBAction)findCodeTextBackForward:(id)sender {
  NSInteger clickedSegment = [sender selectedSegment];
  NSInteger clickedSegmentTag = [[sender cell] tagForSegment:clickedSegment];
  if(clickedSegmentTag == CodeFindActionTypeBack) {
    [self searchForTextInCodeFile:[self findCodeTextSearchField] backWards:YES];
  } else if (clickedSegmentTag == CodeFindActionTypeForward) {
    [self searchForTextInCodeFile:[self findCodeTextSearchField] backWards:NO];
  }
}

-(void)searchForTextInCodeFile:(NSSearchField*)searchField backWards:(BOOL)backwards {
  NSString* searchString = [searchField stringValue];
  if([searchString length] > 0) {
    [[_sourceEditor sourceEditor] findAndHighlightText:searchString matchCase:NO wholeWord:NO scrollTo:YES wrap:YES backwards:backwards];
  }
}

/*
- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector
{
  if([control i])
  NSLog(@"Selector method is (%@)", NSStringFromSelector( commandSelector ) );
  if (commandSelector == @selector(insertNewline:)) {
    //[self searchForTextInCodeFile:[self findCodeTextSearchField] backWards:NO];
    
  }
  return YES;
  // return YES if the action was handled; otherwise NO
}
*/
- (IBAction)searchFromSearchField:(id)sender {
  [self searchForTextInCodeFile:[self findCodeTextSearchField] backWards:NO];
//  NSLog(@"searching!");
}




//MARK: KVO

-(void) startObservingTagChanges {
  [self addObserver:self
         forKeyPath:@"tag.Type"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagTypeContext];
}

-(void) stopObservingTagChanges {
  [self removeObserver:self
            forKeyPath:@"tag.Type"
               context:TagTypeContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  if (context == TagTypeContext) {
    [self updateTagTypeInformation:[[self tag] Type]];
  } else {
    // Any unrecognized context must belong to super
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
  }
}

@end
