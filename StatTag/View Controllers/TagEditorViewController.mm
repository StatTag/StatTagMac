//
//  TagEditorViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/26/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagEditorViewController.h"
#import "StatTag.h"
#import "StatTagShared.h"
#import "UIUtility.h"

#import "Scintilla/ScintillaView.h"
#import "Scintilla/InfoBar.h"
#import "Scintilla/Scintilla.h"

#import "DisclosureViewController.h"

#import "ScintillaNET.h"

#import "TagPreviewController.h"

@interface TagEditorViewController ()

@end

@implementation TagEditorViewController

@synthesize tag = _tag;
@synthesize documentManager = _documentManager;
@synthesize codeFileList = _codeFileList;
@synthesize sourceEditor = _sourceEditor;

@synthesize instructionTitleText = _instructionTitleText;
@synthesize allowedCommandsText = _allowedCommandsText;

//@synthesize propertiesStackView = _propertiesStackView;

//BOOL changedCodeFile = false;
STCodeFile* codeFile;
const int TagMargin = 1;
const int TagMarker = 1;


NSColor* commentColor;
NSColor* stringColor;
NSColor* wordColor;
NSColor* macroKeywordColor;
NSColor* blockKeywordColor;

STTag* _originalTag;
NSString* TagType;

SCScintilla* scintillaHelper;

//NSString* instructionTitleText;
//NSString* allowedCommandsText;

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
//  [[_tagBasicProperties tagFrequencyArrayController] addObjects: [STConstantsRunFrequency GetList]];
//  [[_tagBasicProperties tagTypeArrayController] addObjects: [STConstantsTagType GetList]];

//  self.tagBasicPropertiesDisclosure.disclosedView = self.tagBasicProperties.view;
//  self.tagBasicPropertiesDisclosure.title = @"Tag Settings";

  
  self.tagValueProperties.delegate = self;
//  self.tagValuePropertiesDisclosure.disclosedView = self.tagValueProperties.view;
//  self.tagValuePropertiesDisclosure.title = @"Value Options";

  self.tagTableProperties.delegate = self;
//  self.tagTablePropertiesDisclosure.disclosedView = self.tagTableProperties.view;
//  self.tagTablePropertiesDisclosure.title = @"Table Options";
  
  
}

-(void)addSourceViewEditor {
  _sourceEditor = [[ScintillaView alloc] initWithFrame: [_sourceView frame]];
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

-(void)initializeStackView {
  
  //from Apple's example...
  
  //_tagBasicProperties = [[TagBasicPropertiesController alloc] init];
  //  _tagBasicProperties.disclosedView = [_tagBasicProperties view]; //as expected, BOOOOOOOOOM

  
  [_propertiesStackView addArrangedSubview:_tagBasicProperties.view];
  
//  NSBox *line = [[NSBox alloc] init];
//  [line setBoxType:NSBoxSeparator];                     /* make it a line */
//  [line setFrame:NSMakeRect(0.0, 4.0, 300.0, 0.0)];    /* Or assign NSLayoutConstraint objects */
//  [_propertiesStackView addArrangedSubview:line];
  
  [_propertiesStackView addArrangedSubview:_tagValueProperties.view];
  [_propertiesStackView addArrangedSubview:_tagTableProperties.view];

  [_propertiesStackView addArrangedSubview:_tagPreviewController.view];
  
  [_tagPreviewController setShowsPreviewText:YES];
  [_tagPreviewController setShowsPreviewImage:YES];
  
//  _tagValueProperties.view.hidden = true;
//  _tagTableProperties.view.hidden = true;
  
//    [_propertiesStackView addArrangedSubview:_tagTablePropertiesDisclosure.view];
  
  
//  [_propertiesStackView addArrangedSubview:_tagBasicPropertiesDisclosure.view];
//  [_propertiesStackView addArrangedSubview:_tagValuePropertiesDisclosure.view];
  
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
  
  //  _propertiesStackView.translatesAutoresizingMaskIntoConstraints = false;
  
}

-(void)configureStackView {
  _tagBasicProperties.tag = [self tag];
  _tagValueProperties.tag = [self tag];
  _tagTableProperties.tag = [self tag];
  _tagPreviewController.tag = [self tag];
}

- (void)viewDidLoad {
  
  NSLog(@"stackview count = %lu", (unsigned long)[[_propertiesStackView views] count]);
  
  [super viewDidLoad];
  // Do view setup here.
  if(_documentManager != nil) {
  }
  [self configureStackView];
}

-(void)viewDidAppear {
  if(_documentManager != nil) {
    
    //every time this view appears we need to completely refresh all code files
    [_codeFileList removeObjects:[_codeFileList arrangedObjects]];
    [_codeFileList addObjects: [_documentManager GetCodeFileList]];
    
    //in either case - we're going to default to the top-most object in the code file list
    [self setCodeFile:nil];
    
    
    //  NSLog(@"[[scintillaHelper Lines] count] : %lu", (unsigned long)[[[scintillaHelper Lines] Lines] count] );
    
    //  NSLog(@"number of lines : %d", [scintillaHelper LinesOnScreen]);
    
    if(_tag != nil) {
      //existing tag?
      _originalTag = [[STTag alloc] initWithTag:_tag];
      
      //FIXME:
//      self.textBoxTagName.stringValue = [_tag Name];
      _listCodeFile.enabled = NO; // We don't allow switching code files
      TagType = [_tag Type];
      if([_tag LineStart] != nil && [_tag LineEnd] != nil) {
        NSArray<NSString*>* lines = [[_sourceEditor string] componentsSeparatedByString:@"\r\n"];
        int maxIndex = (int)[lines count] - 1;
        int startIndex = MAX(0, [[_tag LineStart] intValue] );
        startIndex = MIN(startIndex, maxIndex);
        int endIndex = MIN([[_tag LineEnd] intValue], maxIndex);
        NSLog(@"[[_tag LineStart] intValue] : %d", [[_tag LineStart] intValue]);
        NSLog(@"[[_tag LineEnd] intValue] : %d", [[_tag LineEnd] intValue]);
        for (int index = startIndex; index <= endIndex; index++)
        {
          NSLog(@"trying to add line at index: %d", index);
          [self SetLineMarker:[[[scintillaHelper Lines] Lines] objectAtIndex: index ] andMark:YES];
        }
        [scintillaHelper LineScroll:startIndex columns:0];
      }
      
      if([TagType isEqualToString: [STConstantsTagType Value]] ){
        [self UpdateForType:TagType];
        //          valueProperties.SetValueFormat(Tag.ValueFormat);
      } else if([TagType isEqualToString: [STConstantsTagType Figure]] ){
        [self UpdateForType:TagType];
        //          figureProperties.SetFigureFormat(Tag.FigureFormat);
      } else if([TagType isEqualToString: [STConstantsTagType Table]] ){
        [self UpdateForType:TagType];
        //          tableProperties.SetTableFormat(Tag.TableFormat);
        //          tableProperties.SetValueFormat(Tag.ValueFormat);
      }
    } else {
      //probably a new tag
      _originalTag = nil;
      
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
    
    //[self configureStackView];
    NSLog(@"view did appear stackview count = %lu", (unsigned long)[[_propertiesStackView views] count]);

    NSLog(@"tag from properties view : %@", [_tagBasicProperties tag]);
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

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
  if([tabViewItem.identifier isEqualToString:[STConstantsTagType Value]])
  {
    //Value
    TagType = [STConstantsTagType Value];
  } else if([tabViewItem.identifier isEqualToString:[STConstantsTagType Figure]])
  {
    //Figure
    TagType = [STConstantsTagType Figure];
  } else if([tabViewItem.identifier isEqualToString:[STConstantsTagType Table]])
  {
    //Table
    TagType = [STConstantsTagType Table];
  }
  
  [self SetInstructionText];
}

-(void)UpdateForType:(NSString*)tabIdentifier
{
//  [[self tagTypeTabView] selectTabViewItemWithIdentifier:tabIdentifier];
  //FIXME
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
  [_instructionTitleText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:TagType attributes:instructionAttention]];
  [_instructionTitleText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" output" ]];
  // -----------
  [self didChangeValueForKey:@"instructionTitleText"];

  
  
  NSObject<STIResultCommandList>* commandList = [UIUtility GetResultCommandList:selectedCodeFile resultType:TagType];
  
  [self willChangeValueForKey:@"allowedCommandsText"];
  _allowedCommandsText = (commandList == nil) ? @"(None specified)" : [[commandList GetCommands] componentsJoinedByString:@"\r\n"];
  [self didChangeValueForKey:@"allowedCommandsText"];
  
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
  [_sourceEditor setGeneralProperty: SCI_SETMARGINTYPEN parameter: TagMargin value: SC_MARGIN_SYMBOL];
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
  //FIXME: - need this line
  //  marker.Symbol = MarkerSymbol.Background;
  // no idea what it's doing exactly
  
  
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
  
  //yeah - I know - it's not smart to do this with hardcoded comparisons
  //  - but I'm just working through it for now
  
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

- (IBAction)setCodeFile:(id)sender {
  if([[[self listCodeFile] selectedItem] representedObject] != nil) {
    STCodeFile* aCodeFile = (STCodeFile*)[[[self listCodeFile] selectedItem] representedObject];
    [self LoadCodeFile:aCodeFile];
  }
}

-(void)LoadCodeFile:(STCodeFile*)codeFile {
  [self loadSourceViewFromCodeFile:codeFile];
  //changedCodeFile = false; //we just reset the code file so set this back
}

//- (IBAction)setFrequency:(id)sender {
//}
//
//- (IBAction)setTagName:(id)sender {
//}


//- (void) textDidChange:(NSNotification *)notification {
//  // Handle text changes
//  changedCodeFile = true;
//  //NSLog(@"%s", __PRETTY_FUNCTION__);
//}

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
  //NOTE: we're not saving yet
  
  NSError* saveError;
  NSError* saveWarning;
  
  //FIXME:
  /*
  if(! [[_tag Name] isEqualToString: [_textBoxTagName stringValue]]  ) {
    //the name has been changed - so update it
    //first see if we have a duplicate tag name
    
    //tag names must be unique within a code file
    // it's allowed (but not ideal) for them to be duplicated between code files
    
    for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
      for(STTag* aTag in [cf Tags]) {
        //FIXME:
        if ([[aTag Name] isEqualToString:[_textBoxTagName stringValue]] && ![aTag isEqual:_tag]){
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
  }
   */
  
  
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
  
  
  //  private void EditTag_FormClosing(object sender, FormClosingEventArgs e)
  //  {
  //    if (this.DialogResult == DialogResult.OK)
  //    {
  //      if (!TagUtil.ShouldCheckForDuplicateLabel(OriginalTag, Tag))
  //      {
  //        return;
  //      }
  //
  //      var files = Manager.GetCodeFileList();
  //      var result = TagUtil.CheckForDuplicateLabels(Tag, files);
  //      if (result != null && result.Count > 0)
  //      {
  //        if (TagUtil.IsDuplicateLabelInSameFile(Tag, result))
  //        {
  //          UIUtility.WarningMessageBox(
  //                                      string.Format("The tag name you have entered ('{0}') already appears in this file.\r\nPlease give this tag a unique name before proceeding.", Tag.Name),
  //                                      Manager.Logger);
  //          this.DialogResult = DialogResult.None;
  //          e.Cancel = true;
  //        }
  //        else if (DialogResult.Yes != MessageBox.Show(
  //                                                     string.Format(
  //                                                                   "The tag name you have entered ('{0}') appears in {1} other {2}.  Are you sure you want to use the same label?",
  //                                                                   Tag.Name, result.Count, "file".Pluralize(result.Count)),
  //                                                     UIUtility.GetAddInName(), MessageBoxButtons.YesNo))
  //        {
  //          this.DialogResult = DialogResult.None;
  //          e.Cancel = true;
  //        }
  //      }
  //    }
  //  }
  
  
  NSError* saveError;
  
//  if(changedCodeFile) {
    codeFile.Content = [NSMutableArray arrayWithArray:[[_sourceEditor string] componentsSeparatedByString: @"\r\n"]];
    [codeFile Save:&saveError];
//  }
  
  if(saveError != nil) {
    [NSApp presentError:saveError];
    return;
  }
  
  
  
  [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)OK];
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

  [self SetInstructionText]; //this is not a "Cocoa way" of doing this - we should be observing for changes
  
  //add or remove the Value property type view
  if([[[[controller tagTypeList] selectedItem] representedObject] isEqualToString:[STConstantsTagType Value]]) {
    [_propertiesStackView addArrangedSubview:[[self tagValueProperties] view]];
//    _tagValueProperties.view.hidden = false;
  } else {
    if([[_propertiesStackView arrangedSubviews] containsObject:[[self tagValueProperties] view]]) {
//      _tagValueProperties.view.hidden = true;
      [_propertiesStackView removeArrangedSubview:[[self tagValueProperties] view]];
      [[[self tagValueProperties] view] removeFromSuperview];
    }
  }
  if([[[[controller tagTypeList] selectedItem] representedObject] isEqualToString:[STConstantsTagType Table]]) {
      [_propertiesStackView addArrangedSubview:[[self tagTableProperties] view]];
//    _tagTableProperties.view.hidden = false;
  } else {
    if([[_propertiesStackView arrangedSubviews] containsObject:[[self tagTableProperties] view]]) {
//      _tagTableProperties.view.hidden = true;
      [_propertiesStackView removeArrangedSubview:[[self tagTableProperties] view]];
      [[[self tagTableProperties] view] removeFromSuperview];
    }
  }
  /*
  if([[[[controller tagTypeList] selectedItem] representedObject] isEqualToString:[STConstantsTagType Value]]) {
    [_propertiesStackView addArrangedSubview:[[self tagValuePropertiesDisclosure] view]];
  } else {
    if([[_propertiesStackView arrangedSubviews] containsObject:[[self tagValuePropertiesDisclosure] view]]) {
      [_propertiesStackView removeArrangedSubview:[[self tagValuePropertiesDisclosure] view]];
      [[[self tagValuePropertiesDisclosure] view] removeFromSuperview];
    }
  }
   */
  
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


@end
