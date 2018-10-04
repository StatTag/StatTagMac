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


//@synthesize propertiesStackView = _propertiesStackView;
STCodeFile* codeFile;
STTag* _originalTag;
//NSString* TagType;
bool SaveOccurred;

//NSString* instructionTitleText;
//NSString* allowedCommandsText;

//review this later for the table view
//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CocoaBindings/Tasks/images.html

static void *TagTypeContext = &TagTypeContext;


typedef enum {
  SaveActionTypeSaveAndClose = 1,
  SaveActionTypeSaveAndCreateAnother = 2
} SaveActionType;


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
  [[self tagValuePropertiesView] setHidden:YES];
  [[self tagTablePropertiesView] setHidden:YES];
  [ViewUtils fillView:[self sourceView] withView:[[self sourceEditor] view]];
}

-(void)viewDidLayout {
}

-(void)viewDidAppear {
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

//note: moved to delegate - just showing how this is done with NSTextDelegate
//-(void)controlTextDidChange:(NSNotification *)obj {
//  //in the XIB, make sure your text field points to file's owner as the delegate
//  if ([obj object] == _textBoxTagName) {
//    // Ignore reserved characters
//    // we can get away with this because the strings are really tiny - but this seems like overkill
//    [_textBoxTagName setStringValue: [[_textBoxTagName stringValue] stringByReplacingOccurrencesOfString:[STConstantsReservedCharacters TagTableCellDelimiter] withString:@""]];
//  }
//  
//  //this might be smarter  - right now we actually wind up moving key positions, which is bad
//  //http://stackoverflow.com/questions/12161654/restrict-nstextfield-to-only-allow-numbers
//  
//}

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

-(NSError*) detectStoppableCollision
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

  NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
  STTag* collidingTag = [collisionResult CollidingTag];
  [errorDetail setValue:[NSString stringWithFormat:@"The code that you have selected for your new tag overlaps with an existing tag ('%@').", [collidingTag Name]] forKey:NSLocalizedDescriptionKey];
  NSError* error = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
  return error;
}

-(void)validateSave:(SaveActionType)actionAfterSave
{
  //NOTE: we're not saving yet - this is all save VALIDATION

  NSError* saveError;
  NSError* saveWarning;

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if([[self tag] Name] != nil && [[[[self tag] Name] stringByTrimmingCharactersInSet: ws] length] > 0 )
  {
    //FIXME:
    //if(! [[_tag Name] isEqualToString: [_textBoxTagName stringValue]]  ) {
    //if(! [[_tag Name] isEqualToString: [_textBoxTagName stringValue]]  ) {
    //the name has been changed - so update it
    //first see if we have a duplicate tag name
    
    //tag names must be unique within a code file
    // it's allowed (but not ideal) for them to be duplicated between code files

    for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
      for(STTag* aTag in [cf Tags]) {
        //FIXME:
        //if ([[aTag Name] isEqualToString:[_textBoxTagName stringValue]] && ![aTag isEqual:_tag]){
        if ([[aTag Name] isEqualToString:[[self tag] Name]] && ![aTag isEqual:[self tag]]){
          if(cf == codeFile) {
            //same codefile, so this is an error
            //is the tag name reused (other than this tag)?
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:[NSString stringWithFormat:@"The Tag name %@ is already used in code file %@. You will need to specify a unique Tag name", [aTag Name], [codeFile FileName]] forKey:NSLocalizedDescriptionKey];
            saveError = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
          } else {
            //different codefile - we should warn
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:[NSString stringWithFormat:@"The Tag name %@ is already used in code file %@. Tag names should be unique. You may continue, but it is suggested you use a different name.", [aTag Name], [cf FileName]] forKey:NSLocalizedDescriptionKey];
            saveWarning = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
          }
        }
      }
    }
    //}
    
  }
  else {
    NSMutableDictionary *errorDetail;
    errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:[NSString stringWithFormat:@"Please supply a tag name"] forKey:NSLocalizedDescriptionKey];
    saveError = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
    
  }

  if(saveError == nil)
  {
    NSArray<NSNumber*>* selectedIndices = [[self sourceEditor ] GetSelectedIndices];
    if([selectedIndices count] == 0)
    {
      [[self tag] setLineStart: nil];
      [[self tag] setLineEnd: nil];
      
      NSMutableDictionary *errorDetail;
      errorDetail = [NSMutableDictionary dictionary];
      [errorDetail setValue:[NSString stringWithFormat:@"Please click on the margin of the code viewer to select the lines you would like to use in your tag"] forKey:NSLocalizedDescriptionKey];
      saveError = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
      
    }
    else if ([selectedIndices count] == 1)
    {
      [[self tag] setLineStart: [selectedIndices firstObject]];
      [[self tag] setLineEnd: [[self tag] LineStart]];
    }
    else
    {
      //http://stackoverflow.com/questions/15931112/finding-the-smallest-and-biggest-value-in-nsarray-of-nsnumbers
      [[self tag] setLineStart:[selectedIndices valueForKeyPath:@"@min.self"]];
      [[self tag] setLineEnd:[selectedIndices valueForKeyPath:@"@max.self"]];
    }
  }

  if (saveError == nil) {
    saveError = [self detectStoppableCollision];
  }
  
  if(saveError == nil)
  {
    if([[[self tag] Type] isEqualToString:[STConstantsTagType Value]]) {
    } else if([[[self tag] Type] isEqualToString:[STConstantsTagType Table]]) {
    } else if([[[self tag] Type] isEqualToString:[STConstantsTagType Figure]]) {
    } else if([[[self tag] Type] isEqualToString:[STConstantsTagType Verbatim]]) {
    } else {
      NSMutableDictionary *errorDetail;
      errorDetail = [NSMutableDictionary dictionary];
      [errorDetail setValue:[NSString stringWithFormat:@"This tag type is not yet supported"] forKey:NSLocalizedDescriptionKey];
      saveError = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
    }
  }
  
  if(saveError != nil) {
    //oops! something bad happened - tell the user
    [NSApp presentError:saveError];
    return;
  } else if(saveWarning != nil) {
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
