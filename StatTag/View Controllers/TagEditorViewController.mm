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

//obj-c++ -> include in the header instead so we can refer to the protocol
// well that didn't work...
#import "Scintilla/ScintillaView.h"
#import "Scintilla/InfoBar.h"
#import "Scintilla/Scintilla.h"


#import "DisclosureViewController.h"

#import "ScintillaNET.h"

#import "TagPreviewController.h"
#import "ViewUtils.h"

#import "STTag+Preview.h"

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

//@synthesize propertiesStackView = _propertiesStackView;

//BOOL changedCodeFile = false;
STCodeFile* codeFile;
const int TagMargin = 1;
const int TagMarker = 1;
const uint TagMask = (1 << TagMarker);

NSColor* commentColor;
NSColor* stringColor;
NSColor* wordColor;
NSColor* macroKeywordColor;
NSColor* blockKeywordColor;

STTag* _originalTag;
//NSString* TagType;

SCScintilla* scintillaHelper;

//NSString* instructionTitleText;
//NSString* allowedCommandsText;

//review this later for the table view
//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CocoaBindings/Tasks/images.html

static void *TagTypeContext = &TagTypeContext;

-(BOOL)showTagValuePropertiesView {
  return _showTagValuePropertiesView;
}
-(void)setShowTagValuePropertiesView:(BOOL)newValue {
  _showTagValuePropertiesView = newValue;
}


-(void)awakeFromNib {
  
  
  [self addSourceViewEditor];
  
  commentColor = [StatTagShared colorFromRGBRed:0.0f green:127.0f blue:0.0f alpha: 1.0]; //0x00, 0x7F, 0x00
  stringColor = [StatTagShared colorFromRGBRed:163.0f green:21.0f blue:21.0f alpha:1.0f];  //0xA3, 0x15, 0x15
  wordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  macroKeywordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  blockKeywordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  
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
  [_propertiesStackView setDetachesHiddenViews:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configureStackView];
}

-(void)viewWillAppear {
  [[self tagValuePropertiesView] setHidden:YES];
  [[self tagTablePropertiesView] setHidden:YES];
}

-(void)viewDidLayout {
  
}

-(void)viewDidAppear {
  if(_documentManager != nil) {
    //every time this view appears we need to completely refresh all code files
    [_codeFileList removeObjects:[_codeFileList arrangedObjects]];
    [_codeFileList addObjects: [_documentManager GetCodeFileList]];
    
    //in either case - we're going to default to the top-most object in the code file list
    [self setCodeFile:nil];

    SCMarker* marker = [[scintillaHelper Markers] marketAtIndex:TagMarker];
    [marker SetBackColor:[StatTagShared colorFromRGBRed:204 green:196 blue:223 alpha:0]];
    [marker setSymbol:Background];

    if(_tag != nil) {
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
        NSArray<NSString*>* lines = [[_sourceEditor string] componentsSeparatedByString:@"\r\n"];
        int maxIndex = (int)[lines count] - 1;
        int startIndex = MAX(0, [[_tag LineStart] intValue] );
        startIndex = MIN(startIndex, maxIndex);
        int endIndex = MIN([[_tag LineEnd] intValue], maxIndex);
        //NSLog(@"[[_tag LineStart] intValue] : %d", [[_tag LineStart] intValue]);
        //NSLog(@"[[_tag LineEnd] intValue] : %d", [[_tag LineEnd] intValue]);
        for (int index = startIndex; index <= endIndex; index++)
        {
          //NSLog(@"trying to add line at index: %d", index);
          [self SetLineMarker:[[[scintillaHelper Lines] Lines] objectAtIndex: index ] andMark:YES];
        }
        [scintillaHelper LineScroll:startIndex columns:0];
      }
      
      if([[[self tag] Type] isEqualToString: [STConstantsTagType Value]] ){
        [self UpdateForType:[[self tag]Type]];
      } else if([[[self tag] Type] isEqualToString: [STConstantsTagType Figure]] ){
        [self UpdateForType:[[self tag]Type]];
      } else if([[[self tag] Type] isEqualToString: [STConstantsTagType Table]] ){
        [self UpdateForType:[[self tag] Type]];
      }
      
      
    } else {
      //probably a new tag
      _originalTag = nil;
      
      //create a new tag and set some defaults
      [self setTag:[[STTag alloc] init]];
      [[self tag] setType:[STConstantsTagType Value]];
      //ack... I'd rather get this from the array controller, but...
      [[self tag] setCodeFile: [[[self documentManager] GetCodeFileList] firstObject]];
      [self setCodeFile:[[self tag] CodeFile]];
      [[self tag] setRunFrequency:[STConstantsRunFrequency OnDemand]];
      STValueFormat* v = [[STValueFormat alloc] init];
      STTableFormat* t = [[STTableFormat alloc] init];
      STFigureFormat* f = [[STFigureFormat alloc] init];
      [v setFormatType:[STConstantsValueFormatType Default]];
      [[self tag] setValueFormat:v];
      [[self tag] setTableFormat:t];
      [[self tag] setFigureFormat:f];
      [[self tag] setType:[STConstantsTagType Value]];
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
    
    //NSLog(@"view did appear stackview count = %lu", (unsigned long)[[_propertiesStackView views] count]);
    //NSLog(@"tag from properties view : %@", [_tagBasicProperties tag]);
    [self updateTagTypeInformation:[[self tag] Type]];
    [self configureStackView];
  }
}

-(void)SetLineMarker:(SCLine*)line andMark:(BOOL)mark
{
  if (mark)
  {
    [line MarkerAdd:TagMarker];
  }
  else
  {
    [line MarkerDelete:TagMarker];
  }
}

-(void)UpdateForType:(NSString*)tabIdentifier
{
  [self SetInstructionText];
}

-(void) SetInstructionText
{
  
  STCodeFile* selectedCodeFile = (STCodeFile*)[[[self listCodeFile] selectedItem] representedObject];
  NSString* statPackage = (selectedCodeFile == nil) ? @"tag" : [selectedCodeFile StatisticalPackage];
  

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
  [self loadSourceViewFromCodeFile:codeFile];
  //changedCodeFile = false; //we just reset the code file so set this back
  [scintillaHelper EmptyUndoBuffer];
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

- (IBAction)cancel:(id)sender {
  [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)Cancel];
}


- (IBAction)save:(id)sender {
  //NOTE: we're not saving yet - this is all save VALIDATION
  
  NSError* saveError;
  NSError* saveWarning;
  
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
            [errorDetail setValue:[NSString stringWithFormat:@"The Tag name %@ is already used in code file %@. Tag names should be unique. You may continue, but it is suggested you use a different name.", [aTag Name], [codeFile FileName]] forKey:NSLocalizedDescriptionKey];
            saveWarning = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
          }
        }
      }
    }
  //}

  NSArray<NSNumber*>* selectedIndices = [self GetSelectedIndices];
  if([selectedIndices count] == 0)
  {
    [[self tag] setLineStart: nil];
    [[self tag] setLineEnd: nil];
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

  if(saveError == nil)
  {
    if([[[self tag] Type] isEqualToString:[STConstantsTagType Value]]) {
    } else if([[[self tag] Type] isEqualToString:[STConstantsTagType Table]]) {
    } else if([[[self tag] Type] isEqualToString:[STConstantsTagType Figure]]) {
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
        [self saveAndClose];
      }
    }];
  } else {
    [self saveAndClose];
  }
  
  
}

-(void)saveAndClose {
  
  //NOTE: this assumes validation already occured in "save"
  
  NSError* saveError;
  
  [[[self tag] CodeFile] setContent:[NSMutableArray arrayWithArray:[[_sourceEditor string] componentsSeparatedByString: @"\r\n"]]];
  BOOL edited = [[self documentManager] EditTag:[self tag] existingTag:_originalTag];
  
  if(saveError != nil) {
    [NSApp presentError:saveError];
    return;
  }
  
  if(edited == YES)
  {
    [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)OK];
    return;
  }
  
  //something bad happened... we should probably have better error handling...
  NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
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

  
  [self updateTagTypeInformation:[[[controller tagTypeList] selectedItem] representedObject]];
}

-(void)updateTagTypeInformation:(NSString*)tagType {
  [self SetInstructionText]; //this is not a "Cocoa way" of doing this - we should be observing for changes

  if([tagType isEqualToString:[STConstantsTagType Value]]) {
    [[self tagValuePropertiesView] setHidden:NO];
  } else {
    if([[_propertiesStackView arrangedSubviews] containsObject:[self tagValuePropertiesView]]) {
      [[self tagValuePropertiesView] setHidden:YES];
    }
  }
  
  if([tagType isEqualToString:[STConstantsTagType Table]]) {
    [[self tagTablePropertiesView] setHidden:NO];
  } else {
    if([[_propertiesStackView arrangedSubviews] containsObject:[self tagTablePropertiesView]]) {
      [[self tagTablePropertiesView] setHidden:YES];
    }
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


//MARK: source view editor
-(void)addSourceViewEditor {
  _sourceEditor = [[ScintillaView alloc] initWithFrame: [_sourceView frame]];
  [[self sourceEditor] setDelegate:self]; //ehhhhhh....
  
  scintillaHelper = [[SCScintilla alloc] initWithScintillaView:_sourceEditor];
  
  [_sourceView addSubview: _sourceEditor];
  
  _sourceEditor.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSLayoutConstraint *trailing =[NSLayoutConstraint
                                 constraintWithItem:_sourceEditor
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:_sourceView
                                 attribute:NSLayoutAttributeTrailing
                                 multiplier:1.0f
                                 constant:0.f];
  
  NSLayoutConstraint *leading = [NSLayoutConstraint
                                 constraintWithItem:_sourceEditor
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:_sourceView
                                 attribute:NSLayoutAttributeLeading
                                 multiplier:1.0f
                                 constant:0.f];
  
  NSLayoutConstraint *bottom =[NSLayoutConstraint
                               constraintWithItem:_sourceEditor
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                               toItem:_sourceView
                               attribute:NSLayoutAttributeBottom
                               multiplier:1.0f
                               constant:0.f];
  
  NSLayoutConstraint *top =[NSLayoutConstraint
                            constraintWithItem:_sourceEditor
                            attribute:NSLayoutAttributeTop
                            relatedBy:NSLayoutRelationEqual
                            toItem:_sourceView
                            attribute:NSLayoutAttributeTop
                            multiplier:1.0f
                            constant:0.f];
  
  
  [_sourceView addConstraint:trailing];
  [_sourceView addConstraint:bottom];
  [_sourceView addConstraint:leading];
  [_sourceView addConstraint:top];
  
  
  [self setupSourceViewEditor];
  
}


-(void)setupSourceViewEditor {
  
  // Colors and styles for various syntactic elements. First the default style.
  [_sourceEditor setStringProperty: SCI_STYLESETFONT parameter: STYLE_DEFAULT value: @"Helvetica"];
  // [mEditor setStringProperty: SCI_STYLESETFONT parameter: STYLE_DEFAULT value: @"Monospac821 BT"]; // Very pleasing programmer's font.
  [_sourceEditor setGeneralProperty: SCI_STYLESETSIZE parameter: STYLE_DEFAULT value: 14];
  [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: STYLE_DEFAULT value: [NSColor blackColor]];
  
  [_sourceEditor setGeneralProperty: SCI_STYLECLEARALL parameter: 0 value: 0];
  
  
  // Number of styles we use with this lexer.
  [_sourceEditor setGeneralProperty: SCI_SETSTYLEBITS value: [_sourceEditor getGeneralProperty: SCI_GETSTYLEBITSNEEDED]];
  
  // Line number style.
  [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: STYLE_LINENUMBER fromHTML: @"#F0F0F0"];
  [_sourceEditor setColorProperty: SCI_STYLESETBACK parameter: STYLE_LINENUMBER fromHTML: @"#808080"];
  
  [_sourceEditor setGeneralProperty: SCI_SETMARGINTYPEN parameter: 0 value: SC_MARGIN_NUMBER];
  [_sourceEditor setGeneralProperty: SCI_SETMARGINWIDTHN parameter: 0 value: 40];
  
  // Markers.
  [_sourceEditor setGeneralProperty: SCI_SETMARGINWIDTHN parameter: TagMargin value: 20];
  [_sourceEditor setGeneralProperty: SCI_SETMARGINSENSITIVEN parameter: TagMargin value: 1];
  //[_sourceEditor setGeneralProperty: SCI_SETMARGINTYPEN parameter: TagMargin value: SC_MARGIN_SYMBOL];
  
  //ntilla.DirectMessage(NativeMethods.SCI_MARKERSETBACK, new IntPtr(Index), new IntPtr(colour));
  //scintilla.DirectMessage(NativeMethods.SCI_MARKERDEFINE, new IntPtr(Index), new IntPtr(markerSymbol));
  //hrm...... are these not working? or is it because our "tagmargin" doesn't match the margin where we're operating?
  [_sourceEditor setColorProperty: SCI_MARKERSETBACK parameter: TagMarker value: [NSColor redColor]];
  [_sourceEditor setGeneralProperty: SCI_MARKERDEFINE parameter: TagMarker value: SC_MARK_BACKGROUND];

  [_sourceEditor setGeneralProperty: SCI_SETMARGINMASKN parameter: TagMargin value: -1];
  
  /*
   Original .NET -> margin.Mask = Marker.MaskAll;
   
   per https://github.com/jacobslusser/ScintillaNET/blob/dac00e526da95693f6b59b8276c5580846a4e63a/src/ScintillaNET/Marker.cs
   
   it appears that this is a .NET-specific convenience value that is "-1"
   
   /// An unsigned 32-bit mask of all <see cref="Margin" /> indexes where each bit cooresponds to a margin index.
   public const uint MaskAll = unchecked((uint)-1);
   */
  [_sourceEditor setGeneralProperty: SCI_SETMARGINCURSORN parameter: TagMargin value: SC_CURSORARROW];
  
  
  [_sourceEditor setColorProperty: SCI_STYLESETBACK parameter: TagMarker value: [StatTagShared colorFromRGBRed:204 green:196 blue:223 alpha:1.0]];
  
  // Some special lexer properties.
  [_sourceEditor setLexerProperty: @"fold" value: @"1"];
  [_sourceEditor setLexerProperty: @"fold.compact" value: @"0"];
  [_sourceEditor setLexerProperty: @"fold.comment" value: @"1"];
  [_sourceEditor setLexerProperty: @"fold.preprocessor" value: @"1"];
  
  //  // Folder setup.
  //  [_sourceEditor setGeneralProperty: SCI_SETMARGINWIDTHN parameter: 2 value: 16];
  //  [_sourceEditor setGeneralProperty: SCI_SETMARGINMASKN parameter: 2 value: SC_MASK_FOLDERS];
  //  [_sourceEditor setGeneralProperty: SCI_SETMARGINSENSITIVEN parameter: 2 value: 1];
  //  [_sourceEditor setGeneralProperty: SCI_MARKERDEFINE parameter: SC_MARKNUM_FOLDEROPEN value: SC_MARK_BOXMINUS];
  //  [_sourceEditor setGeneralProperty: SCI_MARKERDEFINE parameter: SC_MARKNUM_FOLDER value: SC_MARK_BOXPLUS];
  //  [_sourceEditor setGeneralProperty: SCI_MARKERDEFINE parameter: SC_MARKNUM_FOLDERSUB value: SC_MARK_VLINE];
  //  [_sourceEditor setGeneralProperty: SCI_MARKERDEFINE parameter: SC_MARKNUM_FOLDERTAIL value: SC_MARK_LCORNER];
  //  [_sourceEditor setGeneralProperty: SCI_MARKERDEFINE parameter: SC_MARKNUM_FOLDEREND value: SC_MARK_BOXPLUSCONNECTED];
  //  [_sourceEditor setGeneralProperty: SCI_MARKERDEFINE parameter: SC_MARKNUM_FOLDEROPENMID value: SC_MARK_BOXMINUSCONNECTED];
  //  [_sourceEditor setGeneralProperty
  //   : SCI_MARKERDEFINE parameter: SC_MARKNUM_FOLDERMIDTAIL value: SC_MARK_TCORNER];
  //  for (int n= 25; n < 32; ++n) // Markers 25..31 are reserved for folding.
  //  {
  //    [_sourceEditor setColorProperty: SCI_MARKERSETFORE parameter: n value: [NSColor whiteColor]];
  //    [_sourceEditor setColorProperty: SCI_MARKERSETBACK parameter: n value: [NSColor blackColor]];
  //  }
  
  // Init markers & indicators for highlighting of syntax errors.
  [_sourceEditor setColorProperty: SCI_INDICSETFORE parameter: 0 value: [NSColor redColor]];
  [_sourceEditor setGeneralProperty: SCI_INDICSETUNDER parameter: 0 value: 1];
  [_sourceEditor setGeneralProperty: SCI_INDICSETSTYLE parameter: 0 value: INDIC_SQUIGGLE];
  
  [_sourceEditor setColorProperty: SCI_MARKERSETBACK parameter: 0 fromHTML: @"#B1151C"];
  
  [_sourceEditor setColorProperty: SCI_SETSELBACK parameter: 1 value: [NSColor selectedTextBackgroundColor]];
  
  
  InfoBar* infoBar = [[InfoBar alloc] initWithFrame: NSMakeRect(0, 0, 400, 0)] ;
  [infoBar setDisplay: IBShowAll];
  [_sourceEditor setInfoBar: infoBar top: NO];
  [_sourceEditor setStatusText: @"Operation complete"];
}

-(void)loadSourceViewFromCodeFile:(STCodeFile*)codeFile {
  
  [_sourceEditor setString:[[codeFile Content] componentsJoinedByString:@"\r\n" ] ];
  [[scintillaHelper Lines] populateLinesFromContent: [_sourceEditor string]];
  [[scintillaHelper Lines] RebuildLineData];
  
  //yeah - I know - it's not smart to do this with hardcoded comparisons
  //  - but I'm just working through it for now
  //NSLog(@"%@", [scintillaHelper Lines]);
  
  if([[codeFile StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata]]) {
    
    [_sourceEditor setGeneralProperty: SCI_SETLEXER parameter: SCLEX_STATA value: 0];
    [_sourceEditor setGeneralProperty: SCI_STYLECLEARALL parameter: 0 value: 0];
    
    // Disable code block folding.
    [_sourceEditor setLexerProperty: @"fold" value: @"0"];
    
    // Set the styles
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_STATA_DEFAULT value: [NSColor blackColor]];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_STATA_COMMENT value: commentColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETITALIC parameter: SCE_STATA_COMMENT value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_STATA_COMMENTLINE value: commentColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETITALIC parameter: SCE_STATA_COMMENTLINE value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_STATA_COMMENTBLOCK value: commentColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETITALIC parameter: SCE_STATA_COMMENTBLOCK value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_STATA_NUMBER value: [NSColor blackColor]];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_STATA_STRING value: stringColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETBOLD parameter: SCE_STATA_OPERATOR value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_STATA_WORD value: wordColor];
    
    
    // We don't like showing the whitespace markers
    [_sourceEditor setGeneralProperty: SCI_SETVIEWWS parameter: 0 value: SCWS_INVISIBLE];
    
    // Keyword lists:
    // 0 "Keywords",
    // 1 "Highlighted identifiers"
    char keywords[] = "foreach if in of for any pause more set on off by bysort sort use save saveold insheet using global local gen egen mean median replace graph export inlist keep drop legend label la var clear compress mem memory duplicates di display substring substr subinstring subinstr twoway line scatter estimates estout xi:regress tabulate scalar ttest histogram return summarize count matrix sysuse log";
    [_sourceEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 0 value: keywords];
    [_sourceEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 1 value: keywords];
    
    
  } else if([[codeFile StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages R]]) {
    //[_sourceView setMode:ACEModeR];
    [_sourceEditor setGeneralProperty: SCI_SETLEXER parameter: SCLEX_R value: 0];
    
    [_sourceEditor setGeneralProperty: SCI_STYLECLEARALL parameter: 0 value: 0];
    
    // Disable code block folding.
    [_sourceEditor setLexerProperty: @"fold" value: @"0"];
    
    //Set the styles
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_R_DEFAULT value: [NSColor blackColor]];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_R_COMMENT value: commentColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETITALIC parameter: SCE_R_COMMENT value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_R_NUMBER value: [NSColor blackColor]];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_R_STRING value: stringColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETBOLD parameter: SCE_R_OPERATOR value: 1];
    
    // We don't like showing the whitespace markers
    [_sourceEditor setGeneralProperty: SCI_SETVIEWWS parameter: 0 value: SCWS_INVISIBLE];
    
    
    char keywords[] = "commandArgs detach length dev.off stop lm library predict lmer plot print display anova read.table read.csv complete.cases dim attach as.numeric seq max min data.frame lines curve as.integer levels nlevels ceiling sqrt ranef order AIC summary str head png tryCatch par mfrow interaction.plot qqnorm qqline";
    
    char keywords2[] = "TRUE FALSE if else for while in break continue function";
    
    [_sourceEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 0 value: keywords];
    [_sourceEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 1 value: keywords2];
    
    
  } else if([[codeFile StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages SAS]]) {
    [_sourceEditor setGeneralProperty: SCI_SETLEXER parameter: SCLEX_SAS value: 0];
    
    [_sourceEditor setGeneralProperty: SCI_STYLECLEARALL parameter: 0 value: 0];
    
    // Disable code block folding.
    [_sourceEditor setLexerProperty: @"fold" value: @"0"];
    
    // Set the styles
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_DEFAULT value: [NSColor blackColor]];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_COMMENT value: commentColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETITALIC parameter: SCE_SAS_COMMENT value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_COMMENTLINE value: commentColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETITALIC parameter: SCE_SAS_COMMENTLINE value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_COMMENTBLOCK value: commentColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETITALIC parameter: SCE_SAS_COMMENTBLOCK value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_NUMBER value: [NSColor blackColor]];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_STRING value: stringColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETBOLD parameter: SCE_SAS_OPERATOR value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_WORD value: wordColor];
    
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_MACRO value: [NSColor blackColor]];
    [_sourceEditor setGeneralProperty: SCI_STYLESETITALIC parameter: SCE_SAS_MACRO value: 1];
    
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_MACRO_KEYWORD value: macroKeywordColor];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_BLOCK_KEYWORD value: blockKeywordColor];
    [_sourceEditor setGeneralProperty: SCI_STYLESETBOLD parameter: SCE_SAS_BLOCK_KEYWORD value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_MACRO_FUNCTION value: [NSColor blackColor]];
    [_sourceEditor setGeneralProperty: SCI_STYLESETBOLD parameter: SCE_SAS_MACRO_FUNCTION value: 1];
    [_sourceEditor setColorProperty: SCI_STYLESETFORE parameter: SCE_SAS_STATEMENT value: blockKeywordColor];
    
    // We don't like showing the whitespace markers
    [_sourceEditor setGeneralProperty: SCI_SETVIEWWS parameter: 0 value: SCWS_INVISIBLE];
    
    // Keyword lists:
    // 0 "Macro keywords",
    // 1 "Macro block keywords"
    // 2 "Macro function keywords"
    // 3 "Statements"
    char keywords[] = "%end %length %sysevalf %abort %eval %let %qscan %sysexec %qsubstr %sysfunc %global %qsysfunc %sysget %bquote %go %local %quote %sysrput %by %goto %qupcase %then %if %inc %return %tso %cms %include %nrstr %unquote %index %scan %until %input %put %upcase %nrbquote %str %while %nrquote %syscall %window %display %substr %superq %symdel %do %symexist %else";
    char blockKeywords[] = "%macro %mend proc data run";
    char functionKeywords[] = "%abend %qkupcase %act %file %list %activate %listm %clear %resolve %to %close %pause %run %comandr %on %save %unstr %copy %infile %open %deact %stop %del %kcmpres %delete %kindex %kleft %metasym %dmidsply %klength %qkcmpres %dmisplit %kscan %qkleft %ksubstr %qkscan %edit %ktrim %qksubstr %symglobl %kupcase %qktrim %symlocal";
    char statements[] = "abort array attrib by call cards cards4 catname checkpoint execute_always continue datalines datalines4 declare delete describe display dm do until while drop end endsas error execute file filename footnote format go to if then else infile informat input keep label leave length libname link list lock lostcard merge missing modify null ods options output page put putlog redirect remove rename replace retain return sasfile select set skip stop sum sysecho title update where window x";
    
    [_sourceEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 0 value: keywords];
    [_sourceEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 1 value: blockKeywords];
    [_sourceEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 2 value: functionKeywords];
    [_sourceEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 3 value: statements];
    
  } else {
    //[_sourceView setMode:ACEModeHTML];
  }
  
  [scintillaHelper EmptyUndoBuffer];
  
}

//DO NOT MODIFY the parameter type
//ignore the type mismatch - I can't seem to figure out how to get the namespace to work in the header,
// so we're just saying "SCNotification" there - but the fully namespaced notification here
- (void)notification:(Scintilla::SCNotification*)notification {
  //2013 -> Scintilla.h -> #define for each
  if(notification->nmhdr.code != SCN_PAINTED) {
    //#define SCN_CHARADDED 2001
    //#define SCN_KEY 2005
    //#define SCN_DOUBLECLICK 2006
    //#define SCN_UPDATEUI 2007
    //#define SCN_MARGINCLICK 2010
    
    switch (notification->nmhdr.code) {
      case SCN_KEY: //2005
        //NSLog(@"clicked on a key");
        break;
      case SCN_DOUBLECLICK: //2006
        //NSLog(@"double-clicked on something");
        break;
      case SCN_UPDATEUI: //2007
        //NSLog(@"some sort of UI update");
        break;
      case SCN_MODIFIED: //2008
        //NSLog(@"modified");
        break;
      case SCN_MARGINCLICK: //2010
        //margin -> margin array. 1 = our "gutter" between line #'s and the text block
        //position -> x coordiante - NOT the line #
        //NSLog(@"margin clicked : margin[%d], position[%d]", notification->margin, notification->position);
        [self marginClick:notification];
        //NSInteger lineIndex = [scintillaHelper LineFromPosition:notification->position];
        //NSLog(@"line : %ld", (long)lineIndex);
        break;
      case SCN_FOCUSIN: //2028
        //NSLog(@"focus in");
        break;
      case SCN_FOCUSOUT: //2029
        //NSLog(@"focus out");
        break;
      default:
        //NSLog(@"SCNotification (unknown) : code: %d", notification->nmhdr.code);
        break;
    }
  }
  //http://scintilla-interest.narkive.com/Igf6A0zn/nsdocument-with-scintilla
  //https://groups.google.com/forum/#!topic/scintilla-interest/5kVw7Vizgns
}

-(void)marginClick:(Scintilla::SCNotification*)notification
{
  if(notification->margin == TagMargin)
  {
    NSInteger lineIndex = [scintillaHelper LineFromPosition:notification->position];
    //NSLog(@"margin [%ld] was clicked on line : %ld, modifiers: %d", (long)notification->margin, (long)lineIndex, notification->modifiers);
    
    SCLine* line = [[[scintillaHelper Lines] Lines] objectAtIndex:lineIndex];
    
    // Check to see if there are any existing selections.  If so, we need to determine if the newly selected
    // row is a neighbor to the existing selection since we only allow continuous ranges.
    NSInteger previousLineIndex = [[[[scintillaHelper Lines] Lines] objectAtIndex:(lineIndex > 0 ? lineIndex - 1 : lineIndex)] MarkerPrevious:(1 << TagMarker)];
      //this seems like an extraordinarily risky line - confirmed this blows up when index is 0
    
    if (previousLineIndex != -1)
    {
      if (abs(lineIndex - previousLineIndex) > 1)
      {
        if (notification->modifiers == SCMOD_SHIFT)
        {
          for (NSInteger index = previousLineIndex; index < lineIndex; index++)
          {
            [self SetLineMarker:[[[scintillaHelper Lines] Lines] objectAtIndex:index]  andMark:YES];
          }
        }
        else
        {
          // Deselect everything
          while (previousLineIndex > -1)
          {
            [self SetLineMarker:[[[scintillaHelper Lines] Lines] objectAtIndex:previousLineIndex] andMark:NO];
            previousLineIndex = [[[[scintillaHelper Lines] Lines] objectAtIndex:(previousLineIndex)] MarkerPrevious:(1 << TagMarker)];
          }
        }
      }
    }
    else
    {
      
      NSInteger nextLineIndex = [[[[scintillaHelper Lines] Lines] objectAtIndex:(lineIndex < [[[scintillaHelper Lines] Lines] count] ? lineIndex +1 : lineIndex)] MarkerNext:(1 << TagMarker)];

      if (abs(lineIndex - nextLineIndex) > 1)
      {
        if (notification->modifiers == SCMOD_SHIFT)
        {
          for (NSInteger index = nextLineIndex; index > lineIndex; index--)
          {
            [self SetLineMarker:[[[scintillaHelper Lines] Lines] objectAtIndex:index] andMark:YES];
          }
        }
        else
        {
          // Deselect everything
          while (nextLineIndex > -1)
          {
            [self SetLineMarker:[[[scintillaHelper Lines] Lines] objectAtIndex:nextLineIndex] andMark:NO];
            nextLineIndex = [[[[scintillaHelper Lines] Lines] objectAtIndex:(nextLineIndex)] MarkerNext:(1 << TagMarker)];
          }
        }
      }
    }

    //NSLog(@"TagMask = %u", TagMask);
    // Toggle based on the line's current marker status.
    //NSLog(@"[line MarkerGet] & TagMask = %u", [line MarkerGet] & TagMask);
    
    [self SetLineMarker:line andMark:(([line MarkerGet] & TagMask) <= 0)];
  }
}

-(NSArray<NSString*>*)GetSelectedText
{
  NSArray<NSString*>* lines = [[self GetSelectedLines] valueForKeyPath:@"Text"];
  return lines;
}

-(NSArray<NSNumber*>*)GetSelectedIndices
{
  NSArray<NSNumber*>* lines = [[self GetSelectedLines] valueForKeyPath:@"Index"];
  return lines;
}

-(NSArray<SCLine*>*)GetSelectedLines
{
  NSMutableArray<SCLine*>* lines = [[NSMutableArray<SCLine*> alloc] init];
  NSInteger nextLineIndex = [[[[scintillaHelper Lines] Lines] firstObject] MarkerNext:(1 << TagMarker)];
  while (nextLineIndex > -1 && nextLineIndex < [[scintillaHelper Lines] Count])
  {
    [lines addObject:[[[scintillaHelper Lines] Lines] objectAtIndex: nextLineIndex]];
    if (nextLineIndex == 0 || nextLineIndex == [[scintillaHelper Lines] Count] - 1)
    {
      break;
    }
    nextLineIndex = [[[[scintillaHelper Lines] Lines ] objectAtIndex:(nextLineIndex + 1)] MarkerNext:(1 << TagMarker)];
  }
  return (NSArray<SCLine*>*)lines;
}


@end
