//
//  ScintillaEmbeddedViewController.m
//  StatTag
//
//  Created by Eric Whitley on 4/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "ScintillaEmbeddedViewController.h"

//#import "Scintilla/ScintillaView.h"
#import "Scintilla/InfoBar.h"
#import "Scintilla/Scintilla.h"

#import "ScintillaNET.h"

#import "ViewUtils.h"

@interface ScintillaEmbeddedViewController ()

@end

@implementation ScintillaEmbeddedViewController

@synthesize sourceEditor = _sourceEditor;
@synthesize usesInfoBar = _usesInfoBar;
@synthesize editable = _editable;


static const int TagMargin = 1;
static const int TagMarker = 1;
static const uint TagMask = (1 << TagMarker);
static NSColor* commentColor;
static NSColor* stringColor;
static NSColor* wordColor;
static NSColor* macroKeywordColor;
static NSColor* blockKeywordColor;
static SCScintilla* scintillaHelper;

static NSString* PACKAGE_STATA = @"Stata";
static NSString* PACKAGE_SAS = @"SAS";
static NSString* PACKAGE_R = @"R";


//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"ScintillaEmbeddedViewController";
}

-(id)init {
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}
- (void)awakeFromNib {
  [self setEditable:YES];
  [self setUsesInfoBar:YES];
  [self addSourceViewEditor];
  
  commentColor = [StatTagShared colorFromRGBRed:0.0f green:127.0f blue:0.0f alpha: 1.0]; //0x00, 0x7F, 0x00
  stringColor = [StatTagShared colorFromRGBRed:163.0f green:21.0f blue:21.0f alpha:1.0f];  //0xA3, 0x15, 0x15
  wordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  macroKeywordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  blockKeywordColor = [StatTagShared colorFromRGBRed:0.0f green:0.0f blue:127.0f alpha:1.0f];    //0x00, 0x00, 0x7F
  
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(void)viewDidAppear
{
  SCMarker* marker = [[scintillaHelper Markers] marketAtIndex:TagMarker];
  [marker SetBackColor:[StatTagShared colorFromRGBRed:204 green:196 blue:223 alpha:0]];
  [marker setSymbol:Background];
}


//MARK: source view editor
-(void)addSourceViewEditor {
  _sourceEditor = [[ScintillaView alloc] initWithFrame: [_sourceView frame]];
  [[self sourceEditor] setDelegate:self]; //ehhhhhh....
  
  scintillaHelper = [[SCScintilla alloc] initWithScintillaView:_sourceEditor];
  
  [ViewUtils fillView:[self sourceView] withView:[self sourceEditor]];

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
  
  // Init markers & indicators for highlighting of syntax errors.
  [_sourceEditor setColorProperty: SCI_INDICSETFORE parameter: 0 value: [NSColor redColor]];
  [_sourceEditor setGeneralProperty: SCI_INDICSETUNDER parameter: 0 value: 1];
  [_sourceEditor setGeneralProperty: SCI_INDICSETSTYLE parameter: 0 value: INDIC_SQUIGGLE];
  
  [_sourceEditor setColorProperty: SCI_MARKERSETBACK parameter: 0 fromHTML: @"#B1151C"];
  
  [_sourceEditor setColorProperty: SCI_SETSELBACK parameter: 1 value: [NSColor selectedTextBackgroundColor]];
  
  if([self usesInfoBar])
  {
    InfoBar* infoBar = [[InfoBar alloc] initWithFrame: NSMakeRect(0, 0, 400, 0)] ;
    [infoBar setDisplay: IBShowAll];
    [_sourceEditor setInfoBar: infoBar top: NO];
    [_sourceEditor setStatusText: @"Operation complete"];
  }
  
  
}


-(BOOL)editable
{
  return _editable;
}
-(void)setEditable:(BOOL)editable
{
  _editable = editable;
  [[self sourceEditor] setEditable:editable];
}

-(void)EmptyUndoBuffer
{
  [scintillaHelper EmptyUndoBuffer];
}

-(void)loadSource:(NSString*)source withPackageIdentifier:(NSString*)packageType {
  
  if(source == nil)
  {
    source = @"";
  }
  
  [[self sourceEditor] setEditable:YES];//you need to enable editing if it's not on
  [_sourceEditor setString:source];
  [[self sourceEditor] setEditable:[self editable]];

  [[scintillaHelper Lines] populateLinesFromContent: [_sourceEditor string]];
  [[scintillaHelper Lines] RebuildLineData];
  
  //yeah - I know - it's not smart to do this with hardcoded comparisons
  //  - but I'm just working through it for now
  //NSLog(@"%@", [scintillaHelper Lines]);
  
  if([packageType isEqualToString:PACKAGE_STATA]) {
    
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
    
    
  } else if([packageType isEqualToString:PACKAGE_R]) {
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
    
    
  } else if([packageType isEqualToString:PACKAGE_SAS]) {
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


//DO NOT MODIFY the parameter type
//ignore the type mismatch - I can't seem to figure out how to get the namespace to work in the header,
// so we're just saying "SCNotification" there - but the fully namespaced notification here
- (void)notification:(SCNotification*)notification {
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
        //NSLog(@"notification : %d", notification->modificationType);
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

-(void)marginClick:(SCNotification*)notification
{
  if(notification->margin == TagMargin)
  {
    //this is going to look terrible (it is), but we're going to reload the helper lines before doing this...
    //when scintilla is done editing (and I'm not sure how we get that notification) our "Lines" are out of sync w/ the content - so we need to refresh them w/ the latest content in Scintilla
    //there's VERY likely a better way to do this (or even a better place to put this), but for the moment I'm sticking it here because it's obvious and it fixes an issue where we try to load content from LINES using a Scintilla line index that extends beyond the content bounds
    // there's an overall "modified" event (SCN_MODIFIED), but we don't want all modifications - just
    // "modification ended" events
    [[scintillaHelper Lines] populateLinesFromContent: [_sourceEditor string]];
    [[scintillaHelper Lines] RebuildLineData];
    
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
      //EWW - "uglifying" this so it's clear what we're doing
      //also - the positions are off here - so I'm just break-fixing this
      //if you click on the last line in the editor, it breaks
      // we should probably evaluate the whole +1 thing and revisit this later
      NSInteger x = (lineIndex < [[[scintillaHelper Lines] Lines] count] ? lineIndex +1 : lineIndex);
      if(x > [[[scintillaHelper Lines] Lines] count] - 1)
      {
        x = [[[scintillaHelper Lines] Lines] count] - 1;
      }
      SCLine* y = [[[scintillaHelper Lines] Lines] objectAtIndex:x];
      NSInteger nextLineIndex = [y MarkerNext:(1 << TagMarker)];
      
      //NSInteger nextLineIndex = [[[[scintillaHelper Lines] Lines] objectAtIndex:(lineIndex < [[[scintillaHelper Lines] Lines] count] ? lineIndex +1 : lineIndex)] MarkerNext:(1 << TagMarker)];
      
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

-(NSString*)string
{
  return [[self sourceEditor] string];
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
-(void)setLinMarkerAtIndex:(NSInteger)index
{
  [self SetLineMarker:[[[scintillaHelper Lines] Lines] objectAtIndex: index ] andMark:YES];
}
-(void)scrollToLine:(NSInteger)startIndex
{
  [scintillaHelper LineScroll:startIndex columns:0];
}



@end
