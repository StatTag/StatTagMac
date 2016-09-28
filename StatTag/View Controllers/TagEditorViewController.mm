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
//#import "ACEView/ACEView.h"
//#import "ACEView/ACEModeNames.h"
//#import "ACEView/ACEThemeNames.h"
//#import "ACEView/ACEKeyboardHandlerNames.h"

#import "Scintilla/ScintillaView.h"
#import "Scintilla/InfoBar.h"
#import "Scintilla/Scintilla.h"


#import "ScintillaNET.h"


@interface TagEditorViewController ()

@end

@implementation TagEditorViewController

@synthesize tag = _tag;
@synthesize documentManager = _documentManager;
@synthesize codeFileList = _codeFileList;
@synthesize tagFrequency = _tagFrequency;
@synthesize sourceEditor = _sourceEditor;

BOOL changedCodeFile = false;
STCodeFile* codeFile;
const int TagMargin = 1;
const int TagMarker = 1;


NSColor* commentColor;
NSColor* stringColor;
NSColor* wordColor;
NSColor* macroKeywordColor;
NSColor* blockKeywordColor;

STTag* _originalTag;

SCScintilla* scintillaHelper;

-(void)awakeFromNib {
  [self addSourceViewEditor];
  
  commentColor = [StatTagShared colorFromRGBRed:0.0f green:127.0f blue:0.0f alpha: 1.0]; //0x00, 0x7F, 0x00
  stringColor = [StatTagShared colorFromRGBRed:163.0f green:21.0f blue:21.0f alpha:1.0f];  //0xA3, 0x15, 0x15
  wordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  macroKeywordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  blockKeywordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
  if(_documentManager != nil) {
    [_tagFrequency removeObjects:[_tagFrequency arrangedObjects]];
    [_tagFrequency addObjects: [STConstantsRunFrequency GetList]];
  }
//  [_sourceView setDelegate:self];
//  [_sourceView setTheme:ACEThemeXcode];
//  [_sourceView setKeyboardHandler:ACEKeyboardHandlerAce];
//  [_sourceView setShowPrintMargin:NO];
//  [_sourceView setShowInvisibles:YES];
//  [_sourceView setBasicAutoCompletion:YES];
//  [_sourceView setLiveAutocompletion:YES];
//  [_sourceView setSnippets:YES];
//  [_sourceView setEmmet: YES];

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
      self.textBoxTagName.stringValue = [_tag Name];
      _listCodeFile.enabled = NO; // We don't allow switching code files
      
      //      TagType = Tag.Type;
      if([_tag LineStart] != nil && [_tag LineEnd] != nil) {
        NSArray<NSString*>* lines = [[_sourceEditor string] componentsSeparatedByString:@"\r\n"];
        int maxIndex = (int)[lines count] - 1;
        int startIndex = MAX(0, [[_tag LineStart] intValue] );
        startIndex = MIN(startIndex, maxIndex);
        int endIndex = MIN([[_tag LineEnd] intValue], maxIndex);
        
        for (int index = startIndex; index <= endIndex; index++)
        {
//                  SetLineMarker(scintilla1.Lines[index], true);
          
        }
//                scintilla1.LineScroll(startIndex, 0);
      }
      
      //      switch (TagType)
      //      {
      //        case Constants.TagType.Value:
      //          UpdateForTypeClick(cmdValue);
      //          valueProperties.SetValueFormat(Tag.ValueFormat);
      //          break;
      //        case Constants.TagType.Figure:
      //          UpdateForTypeClick(cmdFigure);
      //          figureProperties.SetFigureFormat(Tag.FigureFormat);
      //          break;
      //        case Constants.TagType.Table:
      //          UpdateForTypeClick(cmdTable);
      //          tableProperties.SetTableFormat(Tag.TableFormat);
      //          tableProperties.SetValueFormat(Tag.ValueFormat);
      //          break;
      //      }
    } else {
      //probably a new tag
      //      OriginalTag = null;
      //
      //      // If there is only one file available, select it by default
      //      if (Manager != null)
      //      {
      //        var files = Manager.GetCodeFileList();
      //        if (files != null && files.Count == 1)
      //        {
      //          cboCodeFiles.SelectedIndex = 0;
      //        }
      //      }
      //
      //      // Default the default run frequency to "Default" (by default)
      //      cboRunFrequency.SelectedItem = Constants.RunFrequency.Always;
    }
    
    
  }
}

-(void)SetLineMarkerAtLineNumber:(int)lineNumber andMark:(BOOL)mark onScintillaView:(ScintillaView*)scintilla
{
  if (mark)
  {
    
    // var handle = scintilla.DirectMessage(NativeMethods.SCI_MARKERADD, new IntPtr(Index), new IntPtr(marker));
    //Scintilla::ScintillaCocoa* backend = [scintilla backend];
    //line.MarkerAdd(TagMarker);

    //marker = Helpers.Clamp(marker, 0, scintilla.Markers.Count - 1);
    [ScintillaView directCall:scintilla message:SCI_MARKERADD wParam:lineNumber lParam:TagMarker];
    
  }
  else
  {
    //line.MarkerDelete(TagMarker);
    //marker = Helpers.Clamp(marker, -1, scintilla.Markers.Count - 1);
    //scintilla.DirectMessage(NativeMethods.SCI_MARKERDELETE, new IntPtr(Index), new IntPtr(marker));
  }
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
  
}

- (IBAction)setCodeFile:(id)sender {
  if([[[self listCodeFile] selectedItem] representedObject] != nil) {
    STCodeFile* aCodeFile = (STCodeFile*)[[[self listCodeFile] selectedItem] representedObject];
    codeFile = aCodeFile;
    [self loadSourceViewFromCodeFile:codeFile];
    changedCodeFile = false; //we just reset the code file so set this back
  }
}

- (IBAction)setFrequency:(id)sender {
}

- (IBAction)setTagName:(id)sender {
}


- (void) textDidChange:(NSNotification *)notification {
  // Handle text changes
  changedCodeFile = true;
  //NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (IBAction)cancel:(id)sender {
  [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)Cancel];
}


- (IBAction)save:(id)sender {
  //NOTE: we're not saving yet
  
  NSError* saveError;
  NSError* saveWarning;

  if(! [[_tag Name] isEqualToString: [_textBoxTagName stringValue]]  ) {
    //the name has been changed - so update it
    //first see if we have a duplicate tag name
    
    //tag names must be unique within a code file
    // it's allowed (but not ideal) for them to be duplicated between code files

    for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
      for(STTag* aTag in [cf Tags]) {
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
  
  NSError* saveError;

  if(changedCodeFile) {
    codeFile.Content = [NSMutableArray arrayWithArray:[[_sourceEditor string] componentsSeparatedByString: @"\r\n"]];
    [codeFile Save:&saveError];
  }

  if(saveError != nil) {
    [NSApp presentError:saveError];
    return;
  }

  
  
  [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)OK];
}


@end
