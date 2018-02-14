/*
 * STMSWord2011.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

@class STMSWord2011BaseObject, STMSWord2011BaseApplication, STMSWord2011BaseDocument, STMSWord2011BasicWindow, STMSWord2011PrintSettings, STMSWord2011CommandBarControl, STMSWord2011CommandBarButton, STMSWord2011CommandBarCombobox, STMSWord2011CommandBarPopup, STMSWord2011CommandBar, STMSWord2011DocumentProperty, STMSWord2011CustomDocumentProperty, STMSWord2011WebPageFont, STMSWord2011WordComment, STMSWord2011WordList, STMSWord2011WordOptions, STMSWord2011AddIn, STMSWord2011Application, STMSWord2011AutoTextEntry, STMSWord2011Bookmark, STMSWord2011BorderOptions, STMSWord2011Border, STMSWord2011Browser, STMSWord2011BuildingBlockCategory, STMSWord2011BuildingBlockType, STMSWord2011BuildingBlock, STMSWord2011CaptionLabel, STMSWord2011CheckBox, STMSWord2011CoauthLock, STMSWord2011CoauthUpdate, STMSWord2011Coauthor, STMSWord2011Coauthoring, STMSWord2011Conflict, STMSWord2011CustomLabel, STMSWord2011DataMergeDataField, STMSWord2011DataMergeDataSource, STMSWord2011DataMergeFieldName, STMSWord2011DataMergeField, STMSWord2011DataMerge, STMSWord2011DefaultWebOptions, STMSWord2011Dialog, STMSWord2011DocumentVersion, STMSWord2011Document, STMSWord2011DropCap, STMSWord2011DropDown, STMSWord2011EndnoteOptions, STMSWord2011Endnote, STMSWord2011Envelope, STMSWord2011FieldOptions, STMSWord2011Field, STMSWord2011FileConverter, STMSWord2011Find, STMSWord2011Font, STMSWord2011FootnoteOptions, STMSWord2011Footnote, STMSWord2011FormField, STMSWord2011Frame, STMSWord2011HeaderFooter, STMSWord2011HeadingStyle, STMSWord2011HyperlinkObject, STMSWord2011Index, STMSWord2011KeyBinding, STMSWord2011LetterContent, STMSWord2011LineNumbering, STMSWord2011LinkFormat, STMSWord2011ListEntry, STMSWord2011ListFormat, STMSWord2011ListGallery, STMSWord2011ListLevel, STMSWord2011ListTemplate, STMSWord2011MailingLabel, STMSWord2011MathAccent, STMSWord2011MathAutocorrectEntry, STMSWord2011MathAutocorrect, STMSWord2011MathBar, STMSWord2011MathBorderBox, STMSWord2011MathBox, STMSWord2011MathBreak, STMSWord2011MathDelimiter, STMSWord2011MathEquationArray, STMSWord2011MathFraction, STMSWord2011MathFunc, STMSWord2011MathFunction, STMSWord2011MathGroupChar, STMSWord2011MathLeftScripts, STMSWord2011MathLowerLimit, STMSWord2011MathMatrixColumn, STMSWord2011MathMatrixRow, STMSWord2011MathMatrix, STMSWord2011MathNary, STMSWord2011MathObject, STMSWord2011MathPhantom, STMSWord2011MathRadical, STMSWord2011MathRecognizedFunction, STMSWord2011MathSubAndSuperScript, STMSWord2011MathSubscript, STMSWord2011MathSuperscript, STMSWord2011MathUpperLimit, STMSWord2011PageNumberOptions, STMSWord2011PageNumber, STMSWord2011PageSetup, STMSWord2011Pane, STMSWord2011RangeEndnoteOptions, STMSWord2011RangeFootnoteOptions, STMSWord2011RecentFile, STMSWord2011Replacement, STMSWord2011Reviewer, STMSWord2011Revision, STMSWord2011SelectionObject, STMSWord2011Subdocument, STMSWord2011SystemObject, STMSWord2011TabStop, STMSWord2011TableOfAuthorities, STMSWord2011TableOfContents, STMSWord2011TableOfFigures, STMSWord2011Template, STMSWord2011TextColumn, STMSWord2011TextInput, STMSWord2011TextRetrievalMode, STMSWord2011Variable, STMSWord2011View, STMSWord2011WebOptions, STMSWord2011Window, STMSWord2011Zoom, STMSWord2011Adjustment, STMSWord2011CalloutFormat, STMSWord2011FillFormat, STMSWord2011GlowFormat, STMSWord2011HorizontalLineFormat, STMSWord2011InlineShape, STMSWord2011InlineHorizontalLine, STMSWord2011InlinePictureBullet, STMSWord2011InlinePicture, STMSWord2011LineFormat, STMSWord2011OfficeTheme, STMSWord2011PictureFormat, STMSWord2011ReflectionFormat, STMSWord2011ShadowFormat, STMSWord2011Shape, STMSWord2011Callout, STMSWord2011LineShape, STMSWord2011Picture, STMSWord2011SoftEdgeFormat, STMSWord2011StandardInlineHorizontalLine, STMSWord2011TextBox, STMSWord2011TextFrame, STMSWord2011ThemeColorScheme, STMSWord2011ThemeColor, STMSWord2011ThemeEffectScheme, STMSWord2011ThemeFontScheme, STMSWord2011ThemeFont, STMSWord2011MajorThemeFont, STMSWord2011MinorThemeFont, STMSWord2011ThemeFonts, STMSWord2011ThreeDFormat, STMSWord2011WordArtFormat, STMSWord2011WordArt, STMSWord2011WrapFormat, STMSWord2011WordStyle, STMSWord2011ParagraphFormat, STMSWord2011Paragraph, STMSWord2011Section, STMSWord2011Shading, STMSWord2011TextRange, STMSWord2011Character, STMSWord2011GrammaticalError, STMSWord2011Sentence, STMSWord2011SpellingError, STMSWord2011StoryRange, STMSWord2011Word, STMSWord2011AutocorrectEntry, STMSWord2011Autocorrect, STMSWord2011Dictionary, STMSWord2011FirstLetterException, STMSWord2011Language, STMSWord2011OtherCorrectionsException, STMSWord2011ReadabilityStatistic, STMSWord2011SynonymInfo, STMSWord2011TwoInitialCapsException, STMSWord2011Cell, STMSWord2011ColumnOptions, STMSWord2011Column, STMSWord2011Condition, STMSWord2011RowOptions, STMSWord2011Row, STMSWord2011TableStyle, STMSWord2011Table;

enum STMSWord2011Savo {
	STMSWord2011SavoYes = 'yes ' /* Save objects now */,
	STMSWord2011SavoNo = 'no  ' /* Do not save objects */,
	STMSWord2011SavoAsk = 'ask ' /* Ask the user whether to save */
};
typedef enum STMSWord2011Savo STMSWord2011Savo;

enum STMSWord2011Kfrm {
	STMSWord2011KfrmIndex = 'indx' /* keyform designating indexed access */,
	STMSWord2011KfrmNamed = 'name' /* keyform designating named access */,
	STMSWord2011KfrmId = 'ID  ' /* keyform designating access by unique identifier */
};
typedef enum STMSWord2011Kfrm STMSWord2011Kfrm;

enum STMSWord2011Enum {
	STMSWord2011EnumStandard = 'lwst' /* Standard PostScript error handling   */,
	STMSWord2011EnumDetailed = 'lwdt' /* print a detailed report of Postscript errors */
};
typedef enum STMSWord2011Enum STMSWord2011Enum;

enum STMSWord2011MlDs {
	STMSWord2011MlDsLineDashStyleUnset = '\000\222\377\376',
	STMSWord2011MlDsLineDashStyleSolid = '\000\223\000\001',
	STMSWord2011MlDsLineDashStyleSquareDot = '\000\223\000\002',
	STMSWord2011MlDsLineDashStyleRoundDot = '\000\223\000\003',
	STMSWord2011MlDsLineDashStyleDash = '\000\223\000\004',
	STMSWord2011MlDsLineDashStyleDashDot = '\000\223\000\005',
	STMSWord2011MlDsLineDashStyleDashDotDot = '\000\223\000\006',
	STMSWord2011MlDsLineDashStyleLongDash = '\000\223\000\007',
	STMSWord2011MlDsLineDashStyleLongDashDot = '\000\223\000\010',
	STMSWord2011MlDsLineDashStyleLongDashDotDot = '\000\223\000\011',
	STMSWord2011MlDsLineDashStyleSystemDash = '\000\223\000\012',
	STMSWord2011MlDsLineDashStyleSystemDot = '\000\223\000\013',
	STMSWord2011MlDsLineDashStyleSystemDashDot = '\000\223\000\014'
};
typedef enum STMSWord2011MlDs STMSWord2011MlDs;

enum STMSWord2011MLnS {
	STMSWord2011MLnSLineStyleUnset = '\000\224\377\376',
	STMSWord2011MLnSSingleLine = '\000\225\000\001',
	STMSWord2011MLnSThinThinLine = '\000\225\000\002',
	STMSWord2011MLnSThinThickLine = '\000\225\000\003',
	STMSWord2011MLnSThickThinLine = '\000\225\000\004',
	STMSWord2011MLnSThickBetweenThinLine = '\000\225\000\005'
};
typedef enum STMSWord2011MLnS STMSWord2011MLnS;

enum STMSWord2011MAhS {
	STMSWord2011MAhSArrowheadStyleUnset = '\000\221\377\376',
	STMSWord2011MAhSNoArrowhead = '\000\222\000\001',
	STMSWord2011MAhSTriangleArrowhead = '\000\222\000\002',
	STMSWord2011MAhSOpen_arrowhead = '\000\222\000\003',
	STMSWord2011MAhSStealthArrowhead = '\000\222\000\004',
	STMSWord2011MAhSDiamondArrowhead = '\000\222\000\005',
	STMSWord2011MAhSOvalArrowhead = '\000\222\000\006'
};
typedef enum STMSWord2011MAhS STMSWord2011MAhS;

enum STMSWord2011MAhW {
	STMSWord2011MAhWArrowheadWidthUnset = '\000\220\377\376',
	STMSWord2011MAhWNarrowWidthArrowhead = '\000\221\000\001',
	STMSWord2011MAhWMediumWidthArrowhead = '\000\221\000\002',
	STMSWord2011MAhWWideArrowhead = '\000\221\000\003'
};
typedef enum STMSWord2011MAhW STMSWord2011MAhW;

enum STMSWord2011MAhL {
	STMSWord2011MAhLArrowheadLengthUnset = '\000\223\377\376',
	STMSWord2011MAhLShortArrowhead = '\000\224\000\001',
	STMSWord2011MAhLMediumArrowhead = '\000\224\000\002',
	STMSWord2011MAhLLongArrowhead = '\000\224\000\003'
};
typedef enum STMSWord2011MAhL STMSWord2011MAhL;

enum STMSWord2011MFdT {
	STMSWord2011MFdTFillUnset = '\000c\377\376',
	STMSWord2011MFdTFillSolid = '\000d\000\001',
	STMSWord2011MFdTFillPatterned = '\000d\000\002',
	STMSWord2011MFdTFillGradient = '\000d\000\003',
	STMSWord2011MFdTFillTextured = '\000d\000\004',
	STMSWord2011MFdTFillBackground = '\000d\000\005',
	STMSWord2011MFdTFillPicture = '\000d\000\006'
};
typedef enum STMSWord2011MFdT STMSWord2011MFdT;

enum STMSWord2011MGdS {
	STMSWord2011MGdSGradientUnset = '\000d\377\376',
	STMSWord2011MGdSHorizontalGradient = '\000e\000\001',
	STMSWord2011MGdSVerticalGradient = '\000e\000\002',
	STMSWord2011MGdSDiagonalUpGradient = '\000e\000\003',
	STMSWord2011MGdSDiagonalDownGradient = '\000e\000\004',
	STMSWord2011MGdSFromCornerGradient = '\000e\000\005',
	STMSWord2011MGdSFromTitleGradient = '\000e\000\006',
	STMSWord2011MGdSFromCenterGradient = '\000e\000\007'
};
typedef enum STMSWord2011MGdS STMSWord2011MGdS;

enum STMSWord2011MGCt {
	STMSWord2011MGCtGradientTypeUnset = '\003\357\377\376',
	STMSWord2011MGCtSingleShadeGradientType = '\003\360\000\001',
	STMSWord2011MGCtTwoColorsGradientType = '\003\360\000\002',
	STMSWord2011MGCtPresetColorsGradientType = '\003\360\000\003',
	STMSWord2011MGCtMultiColorsGradientType = '\003\360\000\004'
};
typedef enum STMSWord2011MGCt STMSWord2011MGCt;

enum STMSWord2011MxtT {
	STMSWord2011MxtTTextureTypeTextureTypeUnset = '\003\360\377\376',
	STMSWord2011MxtTTextureTypePresetTexture = '\003\361\000\001',
	STMSWord2011MxtTTextureTypeUserDefinedTexture = '\003\361\000\002'
};
typedef enum STMSWord2011MxtT STMSWord2011MxtT;

enum STMSWord2011MPzT {
	STMSWord2011MPzTPresetTextureUnset = '\000e\377\376',
	STMSWord2011MPzTTexturePapyrus = '\000f\000\001',
	STMSWord2011MPzTTextureCanvas = '\000f\000\002',
	STMSWord2011MPzTTextureDenim = '\000f\000\003',
	STMSWord2011MPzTTextureWovenMat = '\000f\000\004',
	STMSWord2011MPzTTextureWaterDroplets = '\000f\000\005',
	STMSWord2011MPzTTexturePaperBag = '\000f\000\006',
	STMSWord2011MPzTTextureFishFossil = '\000f\000\007',
	STMSWord2011MPzTTextureSand = '\000f\000\010',
	STMSWord2011MPzTTextureGreenMarble = '\000f\000\011',
	STMSWord2011MPzTTextureWhiteMarble = '\000f\000\012',
	STMSWord2011MPzTTextureBrownMarble = '\000f\000\013',
	STMSWord2011MPzTTextureGranite = '\000f\000\014',
	STMSWord2011MPzTTextureNewsprint = '\000f\000\015',
	STMSWord2011MPzTTextureRecycledPaper = '\000f\000\016',
	STMSWord2011MPzTTextureParchment = '\000f\000\017',
	STMSWord2011MPzTTextureStationery = '\000f\000\020',
	STMSWord2011MPzTTextureBlueTissuePaper = '\000f\000\021',
	STMSWord2011MPzTTexturePinkTissuePaper = '\000f\000\022',
	STMSWord2011MPzTTexturePurpleMesh = '\000f\000\023',
	STMSWord2011MPzTTextureBouquet = '\000f\000\024',
	STMSWord2011MPzTTextureCork = '\000f\000\025',
	STMSWord2011MPzTTextureWalnut = '\000f\000\026',
	STMSWord2011MPzTTextureOak = '\000f\000\027',
	STMSWord2011MPzTTextureMediumWood = '\000f\000\030'
};
typedef enum STMSWord2011MPzT STMSWord2011MPzT;

enum STMSWord2011PpTy {
	STMSWord2011PpTyPatternUnset = '\000f\377\376',
	STMSWord2011PpTyFivePercentPattern = '\000g\000\001',
	STMSWord2011PpTyTenPercentPattern = '\000g\000\002',
	STMSWord2011PpTyTwentyPercentPattern = '\000g\000\003',
	STMSWord2011PpTyTwentyFivePercentPattern = '\000g\000\004',
	STMSWord2011PpTyThirtyPercentPattern = '\000g\000\005',
	STMSWord2011PpTyFortyPercentPattern = '\000g\000\006',
	STMSWord2011PpTyFiftyPercentPattern = '\000g\000\007',
	STMSWord2011PpTySixtyPercentPattern = '\000g\000\010',
	STMSWord2011PpTySeventyPercentPattern = '\000g\000\011',
	STMSWord2011PpTySeventyFivePercentPattern = '\000g\000\012',
	STMSWord2011PpTyEightyPercentPattern = '\000g\000\013',
	STMSWord2011PpTyNinetyPercentPattern = '\000g\000\014',
	STMSWord2011PpTyDarkHorizontalPattern = '\000g\000\015',
	STMSWord2011PpTyDarkVerticalPattern = '\000g\000\016',
	STMSWord2011PpTyDarkDownwardDiagonalPattern = '\000g\000\017',
	STMSWord2011PpTyDarkUpwardDiagonalPattern = '\000g\000\020',
	STMSWord2011PpTySmallCheckerBoardPattern = '\000g\000\021',
	STMSWord2011PpTyTrellisPattern = '\000g\000\022',
	STMSWord2011PpTyLightHorizontalPattern = '\000g\000\023',
	STMSWord2011PpTyLightVerticalPattern = '\000g\000\024',
	STMSWord2011PpTyLightDownwardDiagonalPattern = '\000g\000\025',
	STMSWord2011PpTyLightUpwardDiagonalPattern = '\000g\000\026',
	STMSWord2011PpTySmallGridPattern = '\000g\000\027',
	STMSWord2011PpTyDottedDiamondPattern = '\000g\000\030',
	STMSWord2011PpTyWideDownwardDiagonal = '\000g\000\031',
	STMSWord2011PpTyWideUpwardDiagonalPattern = '\000g\000\032',
	STMSWord2011PpTyDashedUpwardDiagonalPattern = '\000g\000\033',
	STMSWord2011PpTyDashedDownwardDiagonalPattern = '\000g\000\034',
	STMSWord2011PpTyNarrowVerticalPattern = '\000g\000\035',
	STMSWord2011PpTyNarrowHorizontalPattern = '\000g\000\036',
	STMSWord2011PpTyDashedVerticalPattern = '\000g\000\037',
	STMSWord2011PpTyDashedHorizontalPattern = '\000g\000 ',
	STMSWord2011PpTyLargeConfettiPattern = '\000g\000!',
	STMSWord2011PpTyLargeGridPattern = '\000g\000\"',
	STMSWord2011PpTyHorizontalBrickPattern = '\000g\000#',
	STMSWord2011PpTyLargeCheckerBoardPattern = '\000g\000$',
	STMSWord2011PpTySmallConfettiPattern = '\000g\000%',
	STMSWord2011PpTyZigZagPattern = '\000g\000&',
	STMSWord2011PpTySolidDiamondPattern = '\000g\000\'',
	STMSWord2011PpTyDiagonalBrickPattern = '\000g\000(',
	STMSWord2011PpTyOutlinedDiamondPattern = '\000g\000)',
	STMSWord2011PpTyPlaidPattern = '\000g\000*',
	STMSWord2011PpTySpherePattern = '\000g\000+',
	STMSWord2011PpTyWeavePattern = '\000g\000,',
	STMSWord2011PpTyDottedGridPattern = '\000g\000-',
	STMSWord2011PpTyDivotPattern = '\000g\000.',
	STMSWord2011PpTyShinglePattern = '\000g\000/',
	STMSWord2011PpTyWavePattern = '\000g\0000',
	STMSWord2011PpTyHorizontalPattern = '\000g\0001',
	STMSWord2011PpTyVerticalPattern = '\000g\0002',
	STMSWord2011PpTyCrossPattern = '\000g\0003',
	STMSWord2011PpTyDownwardDiagonalPattern = '\000g\0004',
	STMSWord2011PpTyUpwardDiagonalPattern = '\000g\0005',
	STMSWord2011PpTyDiagonalCrossPattern = '\000g\0005'
};
typedef enum STMSWord2011PpTy STMSWord2011PpTy;

enum STMSWord2011MPGb {
	STMSWord2011MPGbPresetGradientUnset = '\000g\377\376',
	STMSWord2011MPGbGradientEarlySunset = '\000h\000\001',
	STMSWord2011MPGbGradientLateSunset = '\000h\000\002',
	STMSWord2011MPGbGradientNightfall = '\000h\000\003',
	STMSWord2011MPGbGradientDaybreak = '\000h\000\004',
	STMSWord2011MPGbGradientHorizon = '\000h\000\005',
	STMSWord2011MPGbGradientDesert = '\000h\000\006',
	STMSWord2011MPGbGradientOcean = '\000h\000\007',
	STMSWord2011MPGbGradientCalmWater = '\000h\000\010',
	STMSWord2011MPGbGradientFire = '\000h\000\011',
	STMSWord2011MPGbGradientFog = '\000h\000\012',
	STMSWord2011MPGbGradientMoss = '\000h\000\013',
	STMSWord2011MPGbGradientPeacock = '\000h\000\014',
	STMSWord2011MPGbGradientWheat = '\000h\000\015',
	STMSWord2011MPGbGradientParchment = '\000h\000\016',
	STMSWord2011MPGbGradientMahogany = '\000h\000\017',
	STMSWord2011MPGbGradientRainbow = '\000h\000\020',
	STMSWord2011MPGbGradientRainbow2 = '\000h\000\021',
	STMSWord2011MPGbGradientGold = '\000h\000\022',
	STMSWord2011MPGbGradientGold2 = '\000h\000\023',
	STMSWord2011MPGbGradientBrass = '\000h\000\024',
	STMSWord2011MPGbGradientChrome = '\000h\000\025',
	STMSWord2011MPGbGradientChrome2 = '\000h\000\026',
	STMSWord2011MPGbGradientSilver = '\000h\000\027',
	STMSWord2011MPGbGradientSapphire = '\000h\000\030'
};
typedef enum STMSWord2011MPGb STMSWord2011MPGb;

enum STMSWord2011MSdT {
	STMSWord2011MSdTShadowUnset = '\003_\377\376',
	STMSWord2011MSdTShadow1 = '\003`\000\001',
	STMSWord2011MSdTShadow2 = '\003`\000\002',
	STMSWord2011MSdTShadow3 = '\003`\000\003',
	STMSWord2011MSdTShadow4 = '\003`\000\004',
	STMSWord2011MSdTShadow5 = '\003`\000\005',
	STMSWord2011MSdTShadow6 = '\003`\000\006',
	STMSWord2011MSdTShadow7 = '\003`\000\007',
	STMSWord2011MSdTShadow8 = '\003`\000\010',
	STMSWord2011MSdTShadow9 = '\003`\000\011',
	STMSWord2011MSdTShadow10 = '\003`\000\012',
	STMSWord2011MSdTShadow11 = '\003`\000\013',
	STMSWord2011MSdTShadow12 = '\003`\000\014',
	STMSWord2011MSdTShadow13 = '\003`\000\015',
	STMSWord2011MSdTShadow14 = '\003`\000\016',
	STMSWord2011MSdTShadow15 = '\003`\000\017',
	STMSWord2011MSdTShadow16 = '\003`\000\020',
	STMSWord2011MSdTShadow17 = '\003`\000\021',
	STMSWord2011MSdTShadow18 = '\003`\000\022',
	STMSWord2011MSdTShadow19 = '\003`\000\023',
	STMSWord2011MSdTShadow20 = '\003`\000\024',
	STMSWord2011MSdTShadow21 = '\003`\000\025',
	STMSWord2011MSdTShadow22 = '\003`\000\026',
	STMSWord2011MSdTShadow23 = '\003`\000\027',
	STMSWord2011MSdTShadow24 = '\003`\000\030',
	STMSWord2011MSdTShadow25 = '\003`\000\031',
	STMSWord2011MSdTShadow26 = '\003`\000\032',
	STMSWord2011MSdTShadow27 = '\003`\000\033',
	STMSWord2011MSdTShadow28 = '\003`\000\034',
	STMSWord2011MSdTShadow29 = '\003`\000\035',
	STMSWord2011MSdTShadow30 = '\003`\000\036',
	STMSWord2011MSdTShadow31 = '\003`\000\037',
	STMSWord2011MSdTShadow32 = '\003`\000 ',
	STMSWord2011MSdTShadow33 = '\003`\000!',
	STMSWord2011MSdTShadow34 = '\003`\000\"',
	STMSWord2011MSdTShadow35 = '\003`\000#',
	STMSWord2011MSdTShadow36 = '\003`\000$',
	STMSWord2011MSdTShadow37 = '\003`\000%',
	STMSWord2011MSdTShadow38 = '\003`\000&',
	STMSWord2011MSdTShadow39 = '\003`\000\'',
	STMSWord2011MSdTShadow40 = '\003`\000(',
	STMSWord2011MSdTShadow41 = '\003`\000)',
	STMSWord2011MSdTShadow42 = '\003`\000*',
	STMSWord2011MSdTShadow43 = '\003`\000+'
};
typedef enum STMSWord2011MSdT STMSWord2011MSdT;

enum STMSWord2011MPXF {
	STMSWord2011MPXFWordartFormatUnset = '\003\361\377\376',
	STMSWord2011MPXFWordartFormat1 = '\003\362\000\000',
	STMSWord2011MPXFWordartFormat2 = '\003\362\000\001',
	STMSWord2011MPXFWordartFormat3 = '\003\362\000\002',
	STMSWord2011MPXFWordartFormat4 = '\003\362\000\003',
	STMSWord2011MPXFWordartFormat5 = '\003\362\000\004',
	STMSWord2011MPXFWordartFormat6 = '\003\362\000\005',
	STMSWord2011MPXFWordartFormat7 = '\003\362\000\006',
	STMSWord2011MPXFWordartFormat8 = '\003\362\000\007',
	STMSWord2011MPXFWordartFormat9 = '\003\362\000\010',
	STMSWord2011MPXFWordartFormat10 = '\003\362\000\011',
	STMSWord2011MPXFWordartFormat11 = '\003\362\000\012',
	STMSWord2011MPXFWordartFormat12 = '\003\362\000\013',
	STMSWord2011MPXFWordartFormat13 = '\003\362\000\014',
	STMSWord2011MPXFWordartFormat14 = '\003\362\000\015',
	STMSWord2011MPXFWordartFormat15 = '\003\362\000\016',
	STMSWord2011MPXFWordartFormat16 = '\003\362\000\017',
	STMSWord2011MPXFWordartFormat17 = '\003\362\000\020',
	STMSWord2011MPXFWordartFormat18 = '\003\362\000\021',
	STMSWord2011MPXFWordartFormat19 = '\003\362\000\022',
	STMSWord2011MPXFWordartFormat20 = '\003\362\000\023',
	STMSWord2011MPXFWordartFormat21 = '\003\362\000\024',
	STMSWord2011MPXFWordartFormat22 = '\003\362\000\025',
	STMSWord2011MPXFWordartFormat23 = '\003\362\000\026',
	STMSWord2011MPXFWordartFormat24 = '\003\362\000\027',
	STMSWord2011MPXFWordartFormat25 = '\003\362\000\030',
	STMSWord2011MPXFWordartFormat26 = '\003\362\000\031',
	STMSWord2011MPXFWordartFormat27 = '\003\362\000\032',
	STMSWord2011MPXFWordartFormat28 = '\003\362\000\033',
	STMSWord2011MPXFWordartFormat29 = '\003\362\000\034',
	STMSWord2011MPXFWordartFormat30 = '\003\362\000\035'
};
typedef enum STMSWord2011MPXF STMSWord2011MPXF;

enum STMSWord2011MPTs {
	STMSWord2011MPTsTextEffectShapeUnset = '\000\227\377\376',
	STMSWord2011MPTsPlainText = '\000\230\000\001',
	STMSWord2011MPTsStop = '\000\230\000\002',
	STMSWord2011MPTsTriangleUp = '\000\230\000\003',
	STMSWord2011MPTsTriangleDown = '\000\230\000\004',
	STMSWord2011MPTsChevronUp = '\000\230\000\005',
	STMSWord2011MPTsChevronDown = '\000\230\000\006',
	STMSWord2011MPTsRingInside = '\000\230\000\007',
	STMSWord2011MPTsRingOutside = '\000\230\000\010',
	STMSWord2011MPTsArchUpCurve = '\000\230\000\011',
	STMSWord2011MPTsArchDownCurve = '\000\230\000\012',
	STMSWord2011MPTsCircleCurve = '\000\230\000\013',
	STMSWord2011MPTsButtonCurve = '\000\230\000\014',
	STMSWord2011MPTsArchUpPour = '\000\230\000\015',
	STMSWord2011MPTsArchDownPour = '\000\230\000\016',
	STMSWord2011MPTsCirclePour = '\000\230\000\017',
	STMSWord2011MPTsButtonPour = '\000\230\000\020',
	STMSWord2011MPTsCurveUp = '\000\230\000\021',
	STMSWord2011MPTsCurveDown = '\000\230\000\022',
	STMSWord2011MPTsCanUp = '\000\230\000\023',
	STMSWord2011MPTsCanDown = '\000\230\000\024',
	STMSWord2011MPTsWave1 = '\000\230\000\025',
	STMSWord2011MPTsWave2 = '\000\230\000\026',
	STMSWord2011MPTsDoubleWave1 = '\000\230\000\027',
	STMSWord2011MPTsDoubleWave2 = '\000\230\000\030',
	STMSWord2011MPTsInflate = '\000\230\000\031',
	STMSWord2011MPTsDeflate = '\000\230\000\032',
	STMSWord2011MPTsInflateBottom = '\000\230\000\033',
	STMSWord2011MPTsDeflateBottom = '\000\230\000\034',
	STMSWord2011MPTsInflateTop = '\000\230\000\035',
	STMSWord2011MPTsDeflateTop = '\000\230\000\036',
	STMSWord2011MPTsDeflateInflate = '\000\230\000\037',
	STMSWord2011MPTsDeflateInflateDeflate = '\000\230\000 ',
	STMSWord2011MPTsFadeRight = '\000\230\000!',
	STMSWord2011MPTsFadeLeft = '\000\230\000\"',
	STMSWord2011MPTsFadeUp = '\000\230\000#',
	STMSWord2011MPTsFadeDown = '\000\230\000$',
	STMSWord2011MPTsSlantUp = '\000\230\000%',
	STMSWord2011MPTsSlantDown = '\000\230\000&',
	STMSWord2011MPTsCascadeUp = '\000\230\000\'',
	STMSWord2011MPTsCascadeDown = '\000\230\000('
};
typedef enum STMSWord2011MPTs STMSWord2011MPTs;

enum STMSWord2011MTxA {
	STMSWord2011MTxATextEffectAlignmentUnset = '\000\226\377\376',
	STMSWord2011MTxALeftTextEffectAlignment = '\000\227\000\001',
	STMSWord2011MTxACenteredTextEffectAlignment = '\000\227\000\002',
	STMSWord2011MTxARightTextEffectAlignment = '\000\227\000\003',
	STMSWord2011MTxAJustifyTextEffectAlignment = '\000\227\000\004',
	STMSWord2011MTxAWordJustifyTextEffectAlignment = '\000\227\000\005',
	STMSWord2011MTxAStretchJustifyTextEffectAlignment = '\000\227\000\006'
};
typedef enum STMSWord2011MTxA STMSWord2011MTxA;

enum STMSWord2011MPLd {
	STMSWord2011MPLdPresetLightingDirectionUnset = '\000\233\377\376',
	STMSWord2011MPLdLightFromTopLeft = '\000\234\000\001',
	STMSWord2011MPLdLightFromTop = '\000\234\000\002',
	STMSWord2011MPLdLightFromTopRight = '\000\234\000\003',
	STMSWord2011MPLdLightFromLeft = '\000\234\000\004',
	STMSWord2011MPLdLightFromNone = '\000\234\000\005',
	STMSWord2011MPLdLightFromRight = '\000\234\000\006',
	STMSWord2011MPLdLightFromBottomLeft = '\000\234\000\007',
	STMSWord2011MPLdLightFromBottom = '\000\234\000\010',
	STMSWord2011MPLdLightFromBottomRight = '\000\234\000\011'
};
typedef enum STMSWord2011MPLd STMSWord2011MPLd;

enum STMSWord2011MlSf {
	STMSWord2011MlSfLightingSoftnessUnset = '\000\234\377\376',
	STMSWord2011MlSfLightingDim = '\000\235\000\001',
	STMSWord2011MlSfLightingNormal = '\000\235\000\002',
	STMSWord2011MlSfLightingBright = '\000\235\000\003'
};
typedef enum STMSWord2011MlSf STMSWord2011MlSf;

enum STMSWord2011MPMt {
	STMSWord2011MPMtPresetMaterialUnset = '\000\235\377\376',
	STMSWord2011MPMtMatte = '\000\236\000\001',
	STMSWord2011MPMtPlastic = '\000\236\000\002',
	STMSWord2011MPMtMetal = '\000\236\000\003',
	STMSWord2011MPMtWireframe = '\000\236\000\004',
	STMSWord2011MPMtMatte2 = '\000\236\000\005',
	STMSWord2011MPMtPlastic2 = '\000\236\000\006',
	STMSWord2011MPMtMetal2 = '\000\236\000\007',
	STMSWord2011MPMtWarmMatte = '\000\236\000\010',
	STMSWord2011MPMtTranslucentPowder = '\000\236\000\011',
	STMSWord2011MPMtPowder = '\000\236\000\012',
	STMSWord2011MPMtDarkEdge = '\000\236\000\013',
	STMSWord2011MPMtSoftEdge = '\000\236\000\014',
	STMSWord2011MPMtMaterialClear = '\000\236\000\015',
	STMSWord2011MPMtFlat = '\000\236\000\016',
	STMSWord2011MPMtSoftMetal = '\000\236\000\017'
};
typedef enum STMSWord2011MPMt STMSWord2011MPMt;

enum STMSWord2011MExD {
	STMSWord2011MExDPresetExtrusionDirectionUnset = '\000\231\377\376',
	STMSWord2011MExDExtrudeBottomRight = '\000\232\000\001',
	STMSWord2011MExDExtrudeBottom = '\000\232\000\002',
	STMSWord2011MExDExtrudeBottomLeft = '\000\232\000\003',
	STMSWord2011MExDExtrudeRight = '\000\232\000\004',
	STMSWord2011MExDExtrudeNone = '\000\232\000\005',
	STMSWord2011MExDExtrudeLeft = '\000\232\000\006',
	STMSWord2011MExDExtrudeTopRight = '\000\232\000\007',
	STMSWord2011MExDExtrudeTop = '\000\232\000\010',
	STMSWord2011MExDExtrudeTopLeft = '\000\232\000\011'
};
typedef enum STMSWord2011MExD STMSWord2011MExD;

enum STMSWord2011M3DF {
	STMSWord2011M3DFPresetThreeDFormatUnset = '\000\230\377\376',
	STMSWord2011M3DFFormat1 = '\000\231\000\001',
	STMSWord2011M3DFFormat2 = '\000\231\000\002',
	STMSWord2011M3DFFormat3 = '\000\231\000\003',
	STMSWord2011M3DFFormat4 = '\000\231\000\004',
	STMSWord2011M3DFFormat5 = '\000\231\000\005',
	STMSWord2011M3DFFormat6 = '\000\231\000\006',
	STMSWord2011M3DFFormat7 = '\000\231\000\007',
	STMSWord2011M3DFFormat8 = '\000\231\000\010',
	STMSWord2011M3DFFormat9 = '\000\231\000\011',
	STMSWord2011M3DFFormat10 = '\000\231\000\012',
	STMSWord2011M3DFFormat11 = '\000\231\000\013',
	STMSWord2011M3DFFormat12 = '\000\231\000\014',
	STMSWord2011M3DFFormat13 = '\000\231\000\015',
	STMSWord2011M3DFFormat14 = '\000\231\000\016',
	STMSWord2011M3DFFormat15 = '\000\231\000\017',
	STMSWord2011M3DFFormat16 = '\000\231\000\020',
	STMSWord2011M3DFFormat17 = '\000\231\000\021',
	STMSWord2011M3DFFormat18 = '\000\231\000\022',
	STMSWord2011M3DFFormat19 = '\000\231\000\023',
	STMSWord2011M3DFFormat20 = '\000\231\000\024'
};
typedef enum STMSWord2011M3DF STMSWord2011M3DF;

enum STMSWord2011MExC {
	STMSWord2011MExCExtrusionColorUnset = '\000\232\377\376',
	STMSWord2011MExCExtrusionColorAutomatic = '\000\233\000\001',
	STMSWord2011MExCExtrusionColorCustom = '\000\233\000\002'
};
typedef enum STMSWord2011MExC STMSWord2011MExC;

enum STMSWord2011MCtT {
	STMSWord2011MCtTConnectorTypeUnset = '\000h\377\376',
	STMSWord2011MCtTStraight = '\000i\000\001',
	STMSWord2011MCtTElbow = '\000i\000\002',
	STMSWord2011MCtTCurve = '\000i\000\003'
};
typedef enum STMSWord2011MCtT STMSWord2011MCtT;

enum STMSWord2011MHzA {
	STMSWord2011MHzAHorizontalAnchorUnset = '\000\236\377\376',
	STMSWord2011MHzAHorizontalAnchorNone = '\000\237\000\001',
	STMSWord2011MHzAHorizontalAnchorCenter = '\000\237\000\002'
};
typedef enum STMSWord2011MHzA STMSWord2011MHzA;

enum STMSWord2011MVtA {
	STMSWord2011MVtAVerticalAnchorUnset = '\000\237\377\376',
	STMSWord2011MVtAAnchorTop = '\000\240\000\001',
	STMSWord2011MVtAAnchorTopBaseline = '\000\240\000\002',
	STMSWord2011MVtAAnchorMiddle = '\000\240\000\003',
	STMSWord2011MVtAAnchorBottom = '\000\240\000\004',
	STMSWord2011MVtAAnchorBottomBaseline = '\000\240\000\005'
};
typedef enum STMSWord2011MVtA STMSWord2011MVtA;

enum STMSWord2011MAsT {
	STMSWord2011MAsTAutoshapeShapeTypeUnset = '\000i\377\376',
	STMSWord2011MAsTAutoshapeRectangle = '\000j\000\001',
	STMSWord2011MAsTAutoshapeParallelogram = '\000j\000\002',
	STMSWord2011MAsTAutoshapeTrapezoid = '\000j\000\003',
	STMSWord2011MAsTAutoshapeDiamond = '\000j\000\004',
	STMSWord2011MAsTAutoshapeRoundedRectangle = '\000j\000\005',
	STMSWord2011MAsTAutoshapeOctagon = '\000j\000\006',
	STMSWord2011MAsTAutoshapeIsoscelesTriangle = '\000j\000\007',
	STMSWord2011MAsTAutoshapeRightTriangle = '\000j\000\010',
	STMSWord2011MAsTAutoshapeOval = '\000j\000\011',
	STMSWord2011MAsTAutoshapeHexagon = '\000j\000\012',
	STMSWord2011MAsTAutoshapeCross = '\000j\000\013',
	STMSWord2011MAsTAutoshapeRegularPentagon = '\000j\000\014',
	STMSWord2011MAsTAutoshapeCan = '\000j\000\015',
	STMSWord2011MAsTAutoshapeCube = '\000j\000\016',
	STMSWord2011MAsTAutoshapeBevel = '\000j\000\017',
	STMSWord2011MAsTAutoshapeFoldedCorner = '\000j\000\020',
	STMSWord2011MAsTAutoshapeSmileyFace = '\000j\000\021',
	STMSWord2011MAsTAutoshapeDonut = '\000j\000\022',
	STMSWord2011MAsTAutoshapeNoSymbol = '\000j\000\023',
	STMSWord2011MAsTAutoshapeBlockArc = '\000j\000\024',
	STMSWord2011MAsTAutoshapeHeart = '\000j\000\025',
	STMSWord2011MAsTAutoshapeLightningBolt = '\000j\000\026',
	STMSWord2011MAsTAutoshapeSun = '\000j\000\027',
	STMSWord2011MAsTAutoshapeMoon = '\000j\000\030',
	STMSWord2011MAsTAutoshapeArc = '\000j\000\031',
	STMSWord2011MAsTAutoshapeDoubleBracket = '\000j\000\032',
	STMSWord2011MAsTAutoshapeDoubleBrace = '\000j\000\033',
	STMSWord2011MAsTAutoshapePlaque = '\000j\000\034',
	STMSWord2011MAsTAutoshapeLeftBracket = '\000j\000\035',
	STMSWord2011MAsTAutoshapeRightBracket = '\000j\000\036',
	STMSWord2011MAsTAutoshapeLeftBrace = '\000j\000\037',
	STMSWord2011MAsTAutoshapeRightBrace = '\000j\000 ',
	STMSWord2011MAsTAutoshapeRightArrow = '\000j\000!',
	STMSWord2011MAsTAutoshapeLeftArrow = '\000j\000\"',
	STMSWord2011MAsTAutoshapeUpArrow = '\000j\000#',
	STMSWord2011MAsTAutoshapeDownArrow = '\000j\000$',
	STMSWord2011MAsTAutoshapeLeftRightArrow = '\000j\000%',
	STMSWord2011MAsTAutoshapeUpDownArrow = '\000j\000&',
	STMSWord2011MAsTAutoshapeQuadArrow = '\000j\000\'',
	STMSWord2011MAsTAutoshapeLeftRightUpArrow = '\000j\000(',
	STMSWord2011MAsTAutoshapeBentArrow = '\000j\000)',
	STMSWord2011MAsTAutoshapeUTurnArrow = '\000j\000*',
	STMSWord2011MAsTAutoshapeLeftUpArrow = '\000j\000+',
	STMSWord2011MAsTAutoshapeBentUpArrow = '\000j\000,',
	STMSWord2011MAsTAutoshapeCurvedRightArrow = '\000j\000-',
	STMSWord2011MAsTAutoshapeCurvedLeftArrow = '\000j\000.',
	STMSWord2011MAsTAutoshapeCurvedUpArrow = '\000j\000/',
	STMSWord2011MAsTAutoshapeCurvedDownArrow = '\000j\0000',
	STMSWord2011MAsTAutoshapeStripedRightArrow = '\000j\0001',
	STMSWord2011MAsTAutoshapeNotchedRightArrow = '\000j\0002',
	STMSWord2011MAsTAutoshapePentagon = '\000j\0003',
	STMSWord2011MAsTAutoshapeChevron = '\000j\0004',
	STMSWord2011MAsTAutoshapeRightArrowCallout = '\000j\0005',
	STMSWord2011MAsTAutoshapeLeftArrowCallout = '\000j\0006',
	STMSWord2011MAsTAutoshapeUpArrowCallout = '\000j\0007',
	STMSWord2011MAsTAutoshapeDownArrowCallout = '\000j\0008',
	STMSWord2011MAsTAutoshapeLeftRightArrowCallout = '\000j\0009',
	STMSWord2011MAsTAutoshapeUpDownArrowCallout = '\000j\000:',
	STMSWord2011MAsTAutoshapeQuadArrowCallout = '\000j\000;',
	STMSWord2011MAsTAutoshapeCircularArrow = '\000j\000<',
	STMSWord2011MAsTAutoshapeFlowchartProcess = '\000j\000=',
	STMSWord2011MAsTAutoshapeFlowchartAlternateProcess = '\000j\000>',
	STMSWord2011MAsTAutoshapeFlowchartDecision = '\000j\000\?',
	STMSWord2011MAsTAutoshapeFlowchartData = '\000j\000@',
	STMSWord2011MAsTAutoshapeFlowchartPredefinedProcess = '\000j\000A',
	STMSWord2011MAsTAutoshapeFlowchartInternalStorage = '\000j\000B',
	STMSWord2011MAsTAutoshapeFlowchartDocument = '\000j\000C',
	STMSWord2011MAsTAutoshapeFlowchartMultiDocument = '\000j\000D',
	STMSWord2011MAsTAutoshapeFlowchartTerminator = '\000j\000E',
	STMSWord2011MAsTAutoshapeFlowchartPreparation = '\000j\000F',
	STMSWord2011MAsTAutoshapeFlowchartManualInput = '\000j\000G',
	STMSWord2011MAsTAutoshapeFlowchartManualOperation = '\000j\000H',
	STMSWord2011MAsTAutoshapeFlowchartConnector = '\000j\000I',
	STMSWord2011MAsTAutoshapeFlowchartOffpageConnector = '\000j\000J',
	STMSWord2011MAsTAutoshapeFlowchartCard = '\000j\000K',
	STMSWord2011MAsTAutoshapeFlowchartPunchedTape = '\000j\000L',
	STMSWord2011MAsTAutoshapeFlowchartSummingJunction = '\000j\000M',
	STMSWord2011MAsTAutoshapeFlowchartOr = '\000j\000N',
	STMSWord2011MAsTAutoshapeFlowchartCollate = '\000j\000O',
	STMSWord2011MAsTAutoshapeFlowchartSort = '\000j\000P',
	STMSWord2011MAsTAutoshapeFlowchartExtract = '\000j\000Q',
	STMSWord2011MAsTAutoshapeFlowchartMerge = '\000j\000R',
	STMSWord2011MAsTAutoshapeFlowchartStoredData = '\000j\000S',
	STMSWord2011MAsTAutoshapeFlowchartDelay = '\000j\000T',
	STMSWord2011MAsTAutoshapeFlowchartSequentialAccessStorage = '\000j\000U',
	STMSWord2011MAsTAutoshapeFlowchartMagneticDisk = '\000j\000V',
	STMSWord2011MAsTAutoshapeFlowchartDirectAccessStorage = '\000j\000W',
	STMSWord2011MAsTAutoshapeFlowchartDisplay = '\000j\000X',
	STMSWord2011MAsTAutoshapeExplosionOne = '\000j\000Y',
	STMSWord2011MAsTAutoshapeExplosionTwo = '\000j\000Z',
	STMSWord2011MAsTAutoshapeFourPointStar = '\000j\000[',
	STMSWord2011MAsTAutoshapeFivePointStar = '\000j\000\\',
	STMSWord2011MAsTAutoshapeEightPointStar = '\000j\000]',
	STMSWord2011MAsTAutoshapeSixteenPointStar = '\000j\000^',
	STMSWord2011MAsTAutoshapeTwentyFourPointStar = '\000j\000_',
	STMSWord2011MAsTAutoshapeThirtyTwoPointStar = '\000j\000`',
	STMSWord2011MAsTAutoshapeUpRibbon = '\000j\000a',
	STMSWord2011MAsTAutoshapeDownRibbon = '\000j\000b',
	STMSWord2011MAsTAutoshapeCurvedUpRibbon = '\000j\000c',
	STMSWord2011MAsTAutoshapeCurvedDownRibbon = '\000j\000d',
	STMSWord2011MAsTAutoshapeVerticalScroll = '\000j\000e',
	STMSWord2011MAsTAutoshapeHorizontalScroll = '\000j\000f',
	STMSWord2011MAsTAutoshapeWave = '\000j\000g',
	STMSWord2011MAsTAutoshapeDoubleWave = '\000j\000h',
	STMSWord2011MAsTAutoshapeRectangularCallout = '\000j\000i',
	STMSWord2011MAsTAutoshapeRoundedRectangularCallout = '\000j\000j',
	STMSWord2011MAsTAutoshapeOvalCallout = '\000j\000k',
	STMSWord2011MAsTAutoshapeCloudCallout = '\000j\000l',
	STMSWord2011MAsTAutoshapeLineCalloutOne = '\000j\000m',
	STMSWord2011MAsTAutoshapeLineCalloutTwo = '\000j\000n',
	STMSWord2011MAsTAutoshapeLineCalloutThree = '\000j\000o',
	STMSWord2011MAsTAutoshapeLineCalloutFour = '\000j\000p',
	STMSWord2011MAsTAutoshapeLineCalloutOneAccentBar = '\000j\000q',
	STMSWord2011MAsTAutoshapeLineCalloutTwoAccentBar = '\000j\000r',
	STMSWord2011MAsTAutoshapeLineCalloutThreeAccentBar = '\000j\000s',
	STMSWord2011MAsTAutoshapeLineCalloutFourAccentBar = '\000j\000t',
	STMSWord2011MAsTAutoshapeLineCalloutOneNoBorder = '\000j\000u',
	STMSWord2011MAsTAutoshapeLineCalloutTwoNoBorder = '\000j\000v',
	STMSWord2011MAsTAutoshapeLineCalloutThreeNoBorder = '\000j\000w',
	STMSWord2011MAsTAutoshapeLineCalloutFourNoBorder = '\000j\000x',
	STMSWord2011MAsTAutoshapeCalloutOneBorderAndAccentBar = '\000j\000y',
	STMSWord2011MAsTAutoshapeCalloutTwoBorderAndAccentBar = '\000j\000z',
	STMSWord2011MAsTAutoshapeCalloutThreeBorderAndAccentBar = '\000j\000{',
	STMSWord2011MAsTAutoshapeCalloutFourBorderAndAccentBar = '\000j\000|',
	STMSWord2011MAsTAutoshapeActionButtonCustom = '\000j\000}',
	STMSWord2011MAsTAutoshapeActionButtonHome = '\000j\000~',
	STMSWord2011MAsTAutoshapeActionButtonHelp = '\000j\000\177',
	STMSWord2011MAsTAutoshapeActionButtonInformation = '\000j\000\200',
	STMSWord2011MAsTAutoshapeActionButtonBackOrPrevious = '\000j\000\201',
	STMSWord2011MAsTAutoshapeActionButtonForwardOrNext = '\000j\000\202',
	STMSWord2011MAsTAutoshapeActionButtonBeginning = '\000j\000\203',
	STMSWord2011MAsTAutoshapeActionButtonEnd = '\000j\000\204',
	STMSWord2011MAsTAutoshapeActionButtonReturn = '\000j\000\205',
	STMSWord2011MAsTAutoshapeActionButtonDocument = '\000j\000\206',
	STMSWord2011MAsTAutoshapeActionButtonSound = '\000j\000\207',
	STMSWord2011MAsTAutoshapeActionButtonMovie = '\000j\000\210',
	STMSWord2011MAsTAutoshapeBalloon = '\000j\000\211',
	STMSWord2011MAsTAutoshapeNotPrimitive = '\000j\000\212',
	STMSWord2011MAsTAutoshapeFlowchartOfflineStorage = '\000j\000\213',
	STMSWord2011MAsTAutoshapeLeftRightRibbon = '\000j\000\214',
	STMSWord2011MAsTAutoshapeDiagonalStripe = '\000j\000\215',
	STMSWord2011MAsTAutoshapePie = '\000j\000\216',
	STMSWord2011MAsTAutoshapeNonIsoscelesTrapezoid = '\000j\000\217',
	STMSWord2011MAsTAutoshapeDecagon = '\000j\000\220',
	STMSWord2011MAsTAutoshapeHeptagon = '\000j\000\221',
	STMSWord2011MAsTAutoshapeDodecagon = '\000j\000\222',
	STMSWord2011MAsTAutoshapeSixPointsStar = '\000j\000\223',
	STMSWord2011MAsTAutoshapeSevenPointsStar = '\000j\000\224',
	STMSWord2011MAsTAutoshapeTenPointsStar = '\000j\000\225',
	STMSWord2011MAsTAutoshapeTwelvePointsStar = '\000j\000\226',
	STMSWord2011MAsTAutoshapeRoundOneRectangle = '\000j\000\227',
	STMSWord2011MAsTAutoshapeRoundTwoSameRectangle = '\000j\000\230',
	STMSWord2011MAsTAutoshapeRoundTwoDiagonalRectangle = '\000j\000\231',
	STMSWord2011MAsTAutoshapeSnipRoundRectangle = '\000j\000\232',
	STMSWord2011MAsTAutoshapeSnipOneRectangle = '\000j\000\233',
	STMSWord2011MAsTAutoshapeSnipTwoSameRectangle = '\000j\000\234',
	STMSWord2011MAsTAutoshapeSnipTwoDiagonalRectangle = '\000j\000\235',
	STMSWord2011MAsTAutoshapeFrame = '\000j\000\236',
	STMSWord2011MAsTAutoshapeHalfFrame = '\000j\000\237',
	STMSWord2011MAsTAutoshapeTear = '\000j\000\240',
	STMSWord2011MAsTAutoshapeChord = '\000j\000\241',
	STMSWord2011MAsTAutoshapeCorner = '\000j\000\242',
	STMSWord2011MAsTAutoshapeMathPlus = '\000j\000\243',
	STMSWord2011MAsTAutoshapeMathMinus = '\000j\000\244',
	STMSWord2011MAsTAutoshapeMathMultiply = '\000j\000\245',
	STMSWord2011MAsTAutoshapeMathDivide = '\000j\000\246',
	STMSWord2011MAsTAutoshapeMathEqual = '\000j\000\247',
	STMSWord2011MAsTAutoshapeMathNotEqual = '\000j\000\250',
	STMSWord2011MAsTAutoshapeCornerTabs = '\000j\000\251',
	STMSWord2011MAsTAutoshapeSquareTabs = '\000j\000\252',
	STMSWord2011MAsTAutoshapePlaqueTabs = '\000j\000\253',
	STMSWord2011MAsTAutoshapeGearSix = '\000j\000\254',
	STMSWord2011MAsTAutoshapeGearNine = '\000j\000\255',
	STMSWord2011MAsTAutoshapeFunnel = '\000j\000\256',
	STMSWord2011MAsTAutoshapePieWedge = '\000j\000\257',
	STMSWord2011MAsTAutoshapeLeftCircularArrow = '\000j\000\260',
	STMSWord2011MAsTAutoshapeLeftRightCircularArrow = '\000j\000\261',
	STMSWord2011MAsTAutoshapeSwooshArrow = '\000j\000\262',
	STMSWord2011MAsTAutoshapeCloud = '\000j\000\263',
	STMSWord2011MAsTAutoshapeChartX = '\000j\000\264',
	STMSWord2011MAsTAutoshapeChartStar = '\000j\000\265',
	STMSWord2011MAsTAutoshapeChartPlus = '\000j\000\266',
	STMSWord2011MAsTAutoshapeLineInverse = '\000j\000\267'
};
typedef enum STMSWord2011MAsT STMSWord2011MAsT;

enum STMSWord2011MShp {
	STMSWord2011MShpShapeTypeUnset = '\000\213\377\376',
	STMSWord2011MShpShapeTypeAuto = '\000\214\000\001',
	STMSWord2011MShpShapeTypeCallout = '\000\214\000\002',
	STMSWord2011MShpShapeTypeChart = '\000\214\000\003',
	STMSWord2011MShpShapeTypeComment = '\000\214\000\004',
	STMSWord2011MShpShapeTypeFreeForm = '\000\214\000\005',
	STMSWord2011MShpShapeTypeGroup = '\000\214\000\006',
	STMSWord2011MShpShapeTypeEmbeddedOLEControl = '\000\214\000\007',
	STMSWord2011MShpShapeTypeFormControl = '\000\214\000\010',
	STMSWord2011MShpShapeTypeLine = '\000\214\000\011',
	STMSWord2011MShpShapeTypeLinkedOLEObject = '\000\214\000\012',
	STMSWord2011MShpShapeTypeLinkedPicture = '\000\214\000\013',
	STMSWord2011MShpShapeTypeOLEControl = '\000\214\000\014',
	STMSWord2011MShpShapeTypePicture = '\000\214\000\015',
	STMSWord2011MShpShapeTypePlaceHolder = '\000\214\000\016',
	STMSWord2011MShpShapeTypeWordArt = '\000\214\000\017',
	STMSWord2011MShpShapeTypeMedia = '\000\214\000\020',
	STMSWord2011MShpShapeTypeTextBox = '\000\214\000\021',
	STMSWord2011MShpShapeTypeTable = '\000\214\000\022',
	STMSWord2011MShpShapeTypeCanvas = '\000\214\000\023',
	STMSWord2011MShpShapeTypeDiagram = '\000\214\000\024',
	STMSWord2011MShpShapeTypeInk = '\000\214\000\025',
	STMSWord2011MShpShapeTypeInkComment = '\000\214\000\026',
	STMSWord2011MShpShapeTypeSmartartGraphic = '\000\214\000\027',
	STMSWord2011MShpShapeTypeSlicer = '\000\214\000\030'
};
typedef enum STMSWord2011MShp STMSWord2011MShp;

enum STMSWord2011MCrT {
	STMSWord2011MCrTColorTypeUnset = '\000j\377\376',
	STMSWord2011MCrTRGB = '\000k\000\001',
	STMSWord2011MCrTScheme = '\000k\000\002'
};
typedef enum STMSWord2011MCrT STMSWord2011MCrT;

enum STMSWord2011MPc {
	STMSWord2011MPcPictureColorTypeUnset = '\000\265\377\376',
	STMSWord2011MPcPictureColorAutomatic = '\000\266\000\001',
	STMSWord2011MPcPictureColorGrayScale = '\000\266\000\002',
	STMSWord2011MPcPictureColorBlackAndWhite = '\000\266\000\003',
	STMSWord2011MPcPictureColorWatermark = '\000\266\000\004'
};
typedef enum STMSWord2011MPc STMSWord2011MPc;

enum STMSWord2011MCAt {
	STMSWord2011MCAtAngleUnset = '\000k\377\376',
	STMSWord2011MCAtAngleAutomatic = '\000l\000\001',
	STMSWord2011MCAtAngle30 = '\000l\000\002',
	STMSWord2011MCAtAngle45 = '\000l\000\003',
	STMSWord2011MCAtAngle60 = '\000l\000\004',
	STMSWord2011MCAtAngle90 = '\000l\000\005'
};
typedef enum STMSWord2011MCAt STMSWord2011MCAt;

enum STMSWord2011MCDt {
	STMSWord2011MCDtDropUnset = '\000l\377\376',
	STMSWord2011MCDtDropCustom = '\000m\000\001',
	STMSWord2011MCDtDropTop = '\000m\000\002',
	STMSWord2011MCDtDropCenter = '\000m\000\003',
	STMSWord2011MCDtDropBottom = '\000m\000\004'
};
typedef enum STMSWord2011MCDt STMSWord2011MCDt;

enum STMSWord2011MCot {
	STMSWord2011MCotCalloutUnset = '\000m\377\376',
	STMSWord2011MCotCalloutOne = '\000n\000\001',
	STMSWord2011MCotCalloutTwo = '\000n\000\002',
	STMSWord2011MCotCalloutThree = '\000n\000\003',
	STMSWord2011MCotCalloutFour = '\000n\000\004'
};
typedef enum STMSWord2011MCot STMSWord2011MCot;

enum STMSWord2011TxOr {
	STMSWord2011TxOrTextOrientationUnset = '\000\215\377\376',
	STMSWord2011TxOrHorizontal = '\000\216\000\001',
	STMSWord2011TxOrUpward = '\000\216\000\002',
	STMSWord2011TxOrDownward = '\000\216\000\003',
	STMSWord2011TxOrVerticalEastAsian = '\000\216\000\004',
	STMSWord2011TxOrVertical = '\000\216\000\005',
	STMSWord2011TxOrHorizontalRotatedEastAsian = '\000\216\000\006'
};
typedef enum STMSWord2011TxOr STMSWord2011TxOr;

enum STMSWord2011MSFr {
	STMSWord2011MSFrScaleFromTopLeft = '\000o\000\000',
	STMSWord2011MSFrScaleFromMiddle = '\000o\000\001',
	STMSWord2011MSFrScaleFromBottomRight = '\000o\000\002'
};
typedef enum STMSWord2011MSFr STMSWord2011MSFr;

enum STMSWord2011MPzC {
	STMSWord2011MPzCPresetCameraUnset = '\000\256\377\376',
	STMSWord2011MPzCCameraLegacyObliqueFromTopLeft = '\000\257\000\001',
	STMSWord2011MPzCCameraLegacyObliqueFromTop = '\000\257\000\002',
	STMSWord2011MPzCCameraLegacyObliqueFromTopright = '\000\257\000\003',
	STMSWord2011MPzCCameraLegacyObliqueFromLeft = '\000\257\000\004',
	STMSWord2011MPzCCameraLegacyObliqueFromFront = '\000\257\000\005',
	STMSWord2011MPzCCameraLegacyObliqueFromRight = '\000\257\000\006',
	STMSWord2011MPzCCameraLegacyObliqueFromBottomLeft = '\000\257\000\007',
	STMSWord2011MPzCCameraLegacyObliqueFromBottom = '\000\257\000\010',
	STMSWord2011MPzCCameraLegacyObliqueFromBottomRight = '\000\257\000\011',
	STMSWord2011MPzCCameraLegacyPerspectiveFromTopLeft = '\000\257\000\012',
	STMSWord2011MPzCCameraLegacyPerspectiveFromTop = '\000\257\000\013',
	STMSWord2011MPzCCameraLegacyPerspectiveFromTopRight = '\000\257\000\014',
	STMSWord2011MPzCCameraLegacyPerspectiveFromLeft = '\000\257\000\015',
	STMSWord2011MPzCCameraLegacyPerspectiveFromFront = '\000\257\000\016',
	STMSWord2011MPzCCameraLegacyPerspectiveFromRight = '\000\257\000\017',
	STMSWord2011MPzCCameraLegacyPerspectiveFromBottomLeft = '\000\257\000\020',
	STMSWord2011MPzCCameraLegacyPerspectiveFromBottom = '\000\257\000\021',
	STMSWord2011MPzCCameraLegacyPerspectiveFromBottomRight = '\000\257\000\022',
	STMSWord2011MPzCCameraOrthographic = '\000\257\000\023',
	STMSWord2011MPzCCameraIsometricFromTopUp = '\000\257\000\024',
	STMSWord2011MPzCCameraIsometricFromTopDown = '\000\257\000\025',
	STMSWord2011MPzCCameraIsometricFromBottomUp = '\000\257\000\026',
	STMSWord2011MPzCCameraIsometricFromBottomDown = '\000\257\000\027',
	STMSWord2011MPzCCameraIsometricFromLeftUp = '\000\257\000\030',
	STMSWord2011MPzCCameraIsometricFromLeftDown = '\000\257\000\031',
	STMSWord2011MPzCCameraIsometricFromRightUp = '\000\257\000\032',
	STMSWord2011MPzCCameraIsometricFromRightDown = '\000\257\000\033',
	STMSWord2011MPzCCameraIsometricOffAxis1FromLeft = '\000\257\000\034',
	STMSWord2011MPzCCameraIsometricOffAxis1FromRight = '\000\257\000\035',
	STMSWord2011MPzCCameraIsometricOffAxis1FromTop = '\000\257\000\036',
	STMSWord2011MPzCCameraIsometricOffAxis2FromLeft = '\000\257\000\037',
	STMSWord2011MPzCCameraIsometricOffAxis2FromRight = '\000\257\000 ',
	STMSWord2011MPzCCameraIsometricOffAxis2FromTop = '\000\257\000!',
	STMSWord2011MPzCCameraIsometricOffAxis3FromLeft = '\000\257\000\"',
	STMSWord2011MPzCCameraIsometricOffAxis3FromRight = '\000\257\000#',
	STMSWord2011MPzCCameraIsometricOffAxis3FromBottom = '\000\257\000$',
	STMSWord2011MPzCCameraIsometricOffAxis4FromLeft = '\000\257\000%',
	STMSWord2011MPzCCameraIsometricOffAxis4FromRight = '\000\257\000&',
	STMSWord2011MPzCCameraIsometricOffAxis4FromBottom = '\000\257\000\'',
	STMSWord2011MPzCCameraObliqueFromTopLeft = '\000\257\000(',
	STMSWord2011MPzCCameraObliqueFromTop = '\000\257\000)',
	STMSWord2011MPzCCameraObliqueFromTopRight = '\000\257\000*',
	STMSWord2011MPzCCameraObliqueFromLeft = '\000\257\000+',
	STMSWord2011MPzCCameraObliqueFromRight = '\000\257\000,',
	STMSWord2011MPzCCameraObliqueFromBottomLeft = '\000\257\000-',
	STMSWord2011MPzCCameraObliqueFromBottom = '\000\257\000.',
	STMSWord2011MPzCCameraObliqueFromBottomRight = '\000\257\000/',
	STMSWord2011MPzCCameraPerspectiveFromFront = '\000\257\0000',
	STMSWord2011MPzCCameraPerspectiveFromLeft = '\000\257\0001',
	STMSWord2011MPzCCameraPerspectiveFromRight = '\000\257\0002',
	STMSWord2011MPzCCameraPerspectiveFromAbove = '\000\257\0003',
	STMSWord2011MPzCCameraPerspectiveFromBelow = '\000\257\0004',
	STMSWord2011MPzCCameraPerspectiveFromAboveFacingLeft = '\000\257\0005',
	STMSWord2011MPzCCameraPerspectiveFromAboveFacingRight = '\000\257\0006',
	STMSWord2011MPzCCameraPerspectiveContrastingFacingLeft = '\000\257\0007',
	STMSWord2011MPzCCameraPerspectiveContrastingFacingRight = '\000\257\0008',
	STMSWord2011MPzCCameraPerspectiveHeroicFacingLeft = '\000\257\0009',
	STMSWord2011MPzCCameraPerspectiveHeroicFacingRight = '\000\257\000:',
	STMSWord2011MPzCCameraPerspectiveHeroicExtremeFacingLeft = '\000\257\000;',
	STMSWord2011MPzCCameraPerspectiveHeroicExtremeFacingRight = '\000\257\000<',
	STMSWord2011MPzCCameraPerspectiveRelaxed = '\000\257\000=',
	STMSWord2011MPzCCameraPerspectiveRelaxedModerately = '\000\257\000>'
};
typedef enum STMSWord2011MPzC STMSWord2011MPzC;

enum STMSWord2011MLtT {
	STMSWord2011MLtTLightRigUnset = '\000\257\377\376',
	STMSWord2011MLtTLightRigFlat1 = '\000\260\000\001',
	STMSWord2011MLtTLightRigFlat2 = '\000\260\000\002',
	STMSWord2011MLtTLightRigFlat3 = '\000\260\000\003',
	STMSWord2011MLtTLightRigFlat4 = '\000\260\000\004',
	STMSWord2011MLtTLightRigNormal1 = '\000\260\000\005',
	STMSWord2011MLtTLightRigNormal2 = '\000\260\000\006',
	STMSWord2011MLtTLightRigNormal3 = '\000\260\000\007',
	STMSWord2011MLtTLightRigNormal4 = '\000\260\000\010',
	STMSWord2011MLtTLightRigHarsh1 = '\000\260\000\011',
	STMSWord2011MLtTLightRigHarsh2 = '\000\260\000\012',
	STMSWord2011MLtTLightRigHarsh3 = '\000\260\000\013',
	STMSWord2011MLtTLightRigHarsh4 = '\000\260\000\014',
	STMSWord2011MLtTLightRigThreePoint = '\000\260\000\015',
	STMSWord2011MLtTLightRigBalanced = '\000\260\000\016',
	STMSWord2011MLtTLightRigSoft = '\000\260\000\017',
	STMSWord2011MLtTLightRigHarsh = '\000\260\000\020',
	STMSWord2011MLtTLightRigFlood = '\000\260\000\021',
	STMSWord2011MLtTLightRigContrasting = '\000\260\000\022',
	STMSWord2011MLtTLightRigMorning = '\000\260\000\023',
	STMSWord2011MLtTLightRigSunrise = '\000\260\000\024',
	STMSWord2011MLtTLightRigSunset = '\000\260\000\025',
	STMSWord2011MLtTLightRigChilly = '\000\260\000\026',
	STMSWord2011MLtTLightRigFreezing = '\000\260\000\027',
	STMSWord2011MLtTLightRigFlat = '\000\260\000\030',
	STMSWord2011MLtTLightRigTwoPoint = '\000\260\000\031',
	STMSWord2011MLtTLightRigGlow = '\000\260\000\032',
	STMSWord2011MLtTLightRigBrightRoom = '\000\260\000\033'
};
typedef enum STMSWord2011MLtT STMSWord2011MLtT;

enum STMSWord2011MBlT {
	STMSWord2011MBlTBevelTypeUnset = '\000\260\377\376',
	STMSWord2011MBlTBevelNone = '\000\261\000\001',
	STMSWord2011MBlTBevelRelaxedInset = '\000\261\000\002',
	STMSWord2011MBlTBevelCircle = '\000\261\000\003',
	STMSWord2011MBlTBevelSlope = '\000\261\000\004',
	STMSWord2011MBlTBevelCross = '\000\261\000\005',
	STMSWord2011MBlTBevelAngle = '\000\261\000\006',
	STMSWord2011MBlTBevelSoftRound = '\000\261\000\007',
	STMSWord2011MBlTBevelConvex = '\000\261\000\010',
	STMSWord2011MBlTBevelCoolSlant = '\000\261\000\011',
	STMSWord2011MBlTBevelDivot = '\000\261\000\012',
	STMSWord2011MBlTBevelRiblet = '\000\261\000\013',
	STMSWord2011MBlTBevelHardEdge = '\000\261\000\014',
	STMSWord2011MBlTBevelArtDeco = '\000\261\000\015'
};
typedef enum STMSWord2011MBlT STMSWord2011MBlT;

enum STMSWord2011MSSt {
	STMSWord2011MSStShadowStyleUnset = '\000\261\377\376',
	STMSWord2011MSStShadowStyleInner = '\000\262\000\001',
	STMSWord2011MSStShadowStyleOuter = '\000\262\000\002'
};
typedef enum STMSWord2011MSSt STMSWord2011MSSt;

enum STMSWord2011PpgA {
	STMSWord2011PpgAParagraphAlignmentUnset = '\000\346\377\376',
	STMSWord2011PpgAParagraphAlignLeft = '\000\347\000\000',
	STMSWord2011PpgAParagraphAlignCenter = '\000\347\000\001',
	STMSWord2011PpgAParagraphAlignRight = '\000\347\000\002',
	STMSWord2011PpgAParagraphAlignJustify = '\000\347\000\003',
	STMSWord2011PpgAParagraphAlignDistribute = '\000\347\000\004',
	STMSWord2011PpgAParagraphAlignThai = '\000\347\000\005',
	STMSWord2011PpgAParagraphAlignJustifyLow = '\000\347\000\006'
};
typedef enum STMSWord2011PpgA STMSWord2011PpgA;

enum STMSWord2011MTSt {
	STMSWord2011MTStStrikeUnset = '\000\263\377\376',
	STMSWord2011MTStNoStrike = '\000\264\000\000',
	STMSWord2011MTStSingleStrike = '\000\264\000\001',
	STMSWord2011MTStDoubleStrike = '\000\264\000\002'
};
typedef enum STMSWord2011MTSt STMSWord2011MTSt;

enum STMSWord2011MTCa {
	STMSWord2011MTCaCapsUnset = '\000\264\377\376',
	STMSWord2011MTCaNoCaps = '\000\265\000\000',
	STMSWord2011MTCaSmallCaps = '\000\265\000\001',
	STMSWord2011MTCaAllCaps = '\000\265\000\002'
};
typedef enum STMSWord2011MTCa STMSWord2011MTCa;

enum STMSWord2011MTUl {
	STMSWord2011MTUlUnderlineUnset = '\003\356\377\376',
	STMSWord2011MTUlNoUnderline = '\003\357\000\000',
	STMSWord2011MTUlUnderlineWordsOnly = '\003\357\000\001',
	STMSWord2011MTUlUnderlineSingleLine = '\003\357\000\002',
	STMSWord2011MTUlUnderlineDoubleLine = '\003\357\000\003',
	STMSWord2011MTUlUnderlineHeavyLine = '\003\357\000\004',
	STMSWord2011MTUlUnderlineDottedLine = '\003\357\000\005',
	STMSWord2011MTUlUnderlineHeavyDottedLine = '\003\357\000\006',
	STMSWord2011MTUlUnderlineDashLine = '\003\357\000\007',
	STMSWord2011MTUlUnderlineHeavyDashLine = '\003\357\000\010',
	STMSWord2011MTUlUnderlineLongDashLine = '\003\357\000\011',
	STMSWord2011MTUlUnderlineHeavyLongDashLine = '\003\357\000\012',
	STMSWord2011MTUlUnderlineDotDashLine = '\003\357\000\013',
	STMSWord2011MTUlUnderlineHeavyDotDashLine = '\003\357\000\014',
	STMSWord2011MTUlUnderlineDotDotDashLine = '\003\357\000\015',
	STMSWord2011MTUlUnderlineHeavyDotDotDashLine = '\003\357\000\016',
	STMSWord2011MTUlUnderlineWavyLine = '\003\357\000\017',
	STMSWord2011MTUlUnderlineHeavyWavyLine = '\003\357\000\020',
	STMSWord2011MTUlUnderlineWavyDoubleLine = '\003\357\000\021'
};
typedef enum STMSWord2011MTUl STMSWord2011MTUl;

enum STMSWord2011MTTA {
	STMSWord2011MTTATabUnset = '\000\266\377\376',
	STMSWord2011MTTALeftTab = '\000\267\000\000',
	STMSWord2011MTTACenterTab = '\000\267\000\001',
	STMSWord2011MTTARightTab = '\000\267\000\002',
	STMSWord2011MTTADecimalTab = '\000\267\000\003'
};
typedef enum STMSWord2011MTTA STMSWord2011MTTA;

enum STMSWord2011MTCW {
	STMSWord2011MTCWCharacterWrapUnset = '\000\267\377\376',
	STMSWord2011MTCWNoCharacterWrap = '\000\270\000\000',
	STMSWord2011MTCWStandardCharacterWrap = '\000\270\000\001',
	STMSWord2011MTCWStrictCharacterWrap = '\000\270\000\002',
	STMSWord2011MTCWCustomCharacterWrap = '\000\270\000\003'
};
typedef enum STMSWord2011MTCW STMSWord2011MTCW;

enum STMSWord2011MTFA {
	STMSWord2011MTFAFontAlignmentUnset = '\000\270\377\376',
	STMSWord2011MTFAAutomaticAlignment = '\000\271\000\000',
	STMSWord2011MTFATopAlignment = '\000\271\000\001',
	STMSWord2011MTFACenterAlignment = '\000\271\000\002',
	STMSWord2011MTFABaselineAlignment = '\000\271\000\003',
	STMSWord2011MTFABottomAlignment = '\000\271\000\004'
};
typedef enum STMSWord2011MTFA STMSWord2011MTFA;

enum STMSWord2011PAtS {
	STMSWord2011PAtSAutoSizeUnset = '\000\344\377\376',
	STMSWord2011PAtSAutoSizeNone = '\000\345\000\000',
	STMSWord2011PAtSShapeToFitText = '\000\345\000\001',
	STMSWord2011PAtSTextToFitShape = '\000\345\000\002'
};
typedef enum STMSWord2011PAtS STMSWord2011PAtS;

enum STMSWord2011MPFo {
	STMSWord2011MPFoPathTypeUnset = '\000\272\377\376',
	STMSWord2011MPFoNoPathType = '\000\273\000\000',
	STMSWord2011MPFoPathType1 = '\000\273\000\001',
	STMSWord2011MPFoPathType2 = '\000\273\000\002',
	STMSWord2011MPFoPathType3 = '\000\273\000\003',
	STMSWord2011MPFoPathType4 = '\000\273\000\004'
};
typedef enum STMSWord2011MPFo STMSWord2011MPFo;

enum STMSWord2011MWFo {
	STMSWord2011MWFoWarpFormatUnset = '\000\273\377\376',
	STMSWord2011MWFoWarpFormat1 = '\000\274\000\000',
	STMSWord2011MWFoWarpFormat2 = '\000\274\000\001',
	STMSWord2011MWFoWarpFormat3 = '\000\274\000\002',
	STMSWord2011MWFoWarpFormat4 = '\000\274\000\003',
	STMSWord2011MWFoWarpFormat5 = '\000\274\000\004',
	STMSWord2011MWFoWarpFormat6 = '\000\274\000\005',
	STMSWord2011MWFoWarpFormat7 = '\000\274\000\006',
	STMSWord2011MWFoWarpFormat8 = '\000\274\000\007',
	STMSWord2011MWFoWarpFormat9 = '\000\274\000\010',
	STMSWord2011MWFoWarpFormat10 = '\000\274\000\011',
	STMSWord2011MWFoWarpFormat11 = '\000\274\000\012',
	STMSWord2011MWFoWarpFormat12 = '\000\274\000\013',
	STMSWord2011MWFoWarpFormat13 = '\000\274\000\014',
	STMSWord2011MWFoWarpFormat14 = '\000\274\000\015',
	STMSWord2011MWFoWarpFormat15 = '\000\274\000\016',
	STMSWord2011MWFoWarpFormat16 = '\000\274\000\017',
	STMSWord2011MWFoWarpFormat17 = '\000\274\000\020',
	STMSWord2011MWFoWarpFormat18 = '\000\274\000\021',
	STMSWord2011MWFoWarpFormat19 = '\000\274\000\022',
	STMSWord2011MWFoWarpFormat20 = '\000\274\000\023',
	STMSWord2011MWFoWarpFormat21 = '\000\274\000\024',
	STMSWord2011MWFoWarpFormat22 = '\000\274\000\025',
	STMSWord2011MWFoWarpFormat23 = '\000\274\000\026',
	STMSWord2011MWFoWarpFormat24 = '\000\274\000\027',
	STMSWord2011MWFoWarpFormat25 = '\000\274\000\030',
	STMSWord2011MWFoWarpFormat26 = '\000\274\000\031',
	STMSWord2011MWFoWarpFormat27 = '\000\274\000\032',
	STMSWord2011MWFoWarpFormat28 = '\000\274\000\033',
	STMSWord2011MWFoWarpFormat29 = '\000\274\000\034',
	STMSWord2011MWFoWarpFormat30 = '\000\274\000\035',
	STMSWord2011MWFoWarpFormat31 = '\000\274\000\036',
	STMSWord2011MWFoWarpFormat32 = '\000\274\000\037',
	STMSWord2011MWFoWarpFormat33 = '\000\274\000 ',
	STMSWord2011MWFoWarpFormat34 = '\000\274\000!',
	STMSWord2011MWFoWarpFormat35 = '\000\274\000\"',
	STMSWord2011MWFoWarpFormat36 = '\000\274\000#'
};
typedef enum STMSWord2011MWFo STMSWord2011MWFo;

enum STMSWord2011PCgC {
	STMSWord2011PCgCCaseSentence = '\000\344\000\001',
	STMSWord2011PCgCCaseLower = '\000\344\000\002',
	STMSWord2011PCgCCaseUpper = '\000\344\000\003',
	STMSWord2011PCgCCaseTitle = '\000\344\000\004',
	STMSWord2011PCgCCaseToggle = '\000\344\000\005'
};
typedef enum STMSWord2011PCgC STMSWord2011PCgC;

enum STMSWord2011MDTF {
	STMSWord2011MDTFDateTimeFormatUnset = '\000\275\377\376',
	STMSWord2011MDTFDateTimeFormatMdyy = '\000\276\000\001',
	STMSWord2011MDTFDateTimeFormatDdddMMMMddyyyy = '\000\276\000\002',
	STMSWord2011MDTFDateTimeFormatDMMMMyyyy = '\000\276\000\003',
	STMSWord2011MDTFDateTimeFormatMMMMdyyyy = '\000\276\000\004',
	STMSWord2011MDTFDateTimeFormatDMMMyy = '\000\276\000\005',
	STMSWord2011MDTFDateTimeFormatMMMMyy = '\000\276\000\006',
	STMSWord2011MDTFDateTimeFormatMMyy = '\000\276\000\007',
	STMSWord2011MDTFDateTimeFormatMMddyyHmm = '\000\276\000\010',
	STMSWord2011MDTFDateTimeFormatMMddyyhmmAMPM = '\000\276\000\011',
	STMSWord2011MDTFDateTimeFormatHmm = '\000\276\000\012',
	STMSWord2011MDTFDateTimeFormatHmmss = '\000\276\000\013',
	STMSWord2011MDTFDateTimeFormatHmmAMPM = '\000\276\000\014',
	STMSWord2011MDTFDateTimeFormatHmmssAMPM = '\000\276\000\015',
	STMSWord2011MDTFDateTimeFormatFigureOut = '\000\276\000\016'
};
typedef enum STMSWord2011MDTF STMSWord2011MDTF;

enum STMSWord2011MSET {
	STMSWord2011MSETSoftEdgeUnset = '\000\277\377\376',
	STMSWord2011MSETNoSoftEdge = '\000\300\000\000',
	STMSWord2011MSETSoftEdgeType1 = '\000\300\000\001',
	STMSWord2011MSETSoftEdgeType2 = '\000\300\000\002',
	STMSWord2011MSETSoftEdgeType3 = '\000\300\000\003',
	STMSWord2011MSETSoftEdgeType4 = '\000\300\000\004',
	STMSWord2011MSETSoftEdgeType5 = '\000\300\000\005',
	STMSWord2011MSETSoftEdgeType6 = '\000\300\000\006'
};
typedef enum STMSWord2011MSET STMSWord2011MSET;

enum STMSWord2011MCSI {
	STMSWord2011MCSIFirstDarkSchemeColor = '\000\301\000\001',
	STMSWord2011MCSIFirstLightSchemeColor = '\000\301\000\002',
	STMSWord2011MCSISecondDarkSchemeColor = '\000\301\000\003',
	STMSWord2011MCSISecondLightSchemeColor = '\000\301\000\004',
	STMSWord2011MCSIFirstAccentSchemeColor = '\000\301\000\005',
	STMSWord2011MCSISecondAccentSchemeColor = '\000\301\000\006',
	STMSWord2011MCSIThirdAccentSchemeColor = '\000\301\000\007',
	STMSWord2011MCSIFourthAccentSchemeColor = '\000\301\000\010',
	STMSWord2011MCSIFifthAccentSchemeColor = '\000\301\000\011',
	STMSWord2011MCSISixthAccentSchemeColor = '\000\301\000\012',
	STMSWord2011MCSIHyperlinkSchemeColor = '\000\301\000\013',
	STMSWord2011MCSIFollowedHyperlinkSchemeColor = '\000\301\000\014'
};
typedef enum STMSWord2011MCSI STMSWord2011MCSI;

enum STMSWord2011MCoI {
	STMSWord2011MCoIThemeColorUnset = '\000\301\377\376',
	STMSWord2011MCoINoThemeColor = '\000\302\000\000',
	STMSWord2011MCoIFirstDarkThemeColor = '\000\302\000\001',
	STMSWord2011MCoIFirstLightThemeColor = '\000\302\000\002',
	STMSWord2011MCoISecondDarkThemeColor = '\000\302\000\003',
	STMSWord2011MCoISecondLightThemeColor = '\000\302\000\004',
	STMSWord2011MCoIFirstAccentThemeColor = '\000\302\000\005',
	STMSWord2011MCoISecondAccentThemeColor = '\000\302\000\006',
	STMSWord2011MCoIThirdAccentThemeColor = '\000\302\000\007',
	STMSWord2011MCoIFourthAccentThemeColor = '\000\302\000\010',
	STMSWord2011MCoIFifthAccentThemeColor = '\000\302\000\011',
	STMSWord2011MCoISixthAccentThemeColor = '\000\302\000\012',
	STMSWord2011MCoIHyperlinkThemeColor = '\000\302\000\013',
	STMSWord2011MCoIFollowedHyperlinkThemeColor = '\000\302\000\014',
	STMSWord2011MCoIFirstTextThemeColor = '\000\302\000\015',
	STMSWord2011MCoIFirstBackgroundThemeColor = '\000\302\000\016',
	STMSWord2011MCoISecondTextThemeColor = '\000\302\000\017',
	STMSWord2011MCoISecondBackgroundThemeColor = '\000\302\000\020'
};
typedef enum STMSWord2011MCoI STMSWord2011MCoI;

enum STMSWord2011MFLI {
	STMSWord2011MFLIThemeFontLatin = '\000\303\000\001',
	STMSWord2011MFLIThemeFontComplexScript = '\000\303\000\002',
	STMSWord2011MFLIThemeFontHighAnsi = '\000\303\000\003',
	STMSWord2011MFLIThemeFontEastAsian = '\000\303\000\004'
};
typedef enum STMSWord2011MFLI STMSWord2011MFLI;

enum STMSWord2011MSSI {
	STMSWord2011MSSIShapeStyleUnset = '\000\303\377\376',
	STMSWord2011MSSIShapeNotAPreset = '\000\304\000\000',
	STMSWord2011MSSIShapePreset1 = '\000\304\000\001',
	STMSWord2011MSSIShapePreset2 = '\000\304\000\002',
	STMSWord2011MSSIShapePreset3 = '\000\304\000\003',
	STMSWord2011MSSIShapePreset4 = '\000\304\000\004',
	STMSWord2011MSSIShapePreset5 = '\000\304\000\005',
	STMSWord2011MSSIShapePreset6 = '\000\304\000\006',
	STMSWord2011MSSIShapePreset7 = '\000\304\000\007',
	STMSWord2011MSSIShapePreset8 = '\000\304\000\010',
	STMSWord2011MSSIShapePreset9 = '\000\304\000\011',
	STMSWord2011MSSIShapePreset10 = '\000\304\000\012',
	STMSWord2011MSSIShapePreset11 = '\000\304\000\013',
	STMSWord2011MSSIShapePreset12 = '\000\304\000\014',
	STMSWord2011MSSIShapePreset13 = '\000\304\000\015',
	STMSWord2011MSSIShapePreset14 = '\000\304\000\016',
	STMSWord2011MSSIShapePreset15 = '\000\304\000\017',
	STMSWord2011MSSIShapePreset16 = '\000\304\000\020',
	STMSWord2011MSSIShapePreset17 = '\000\304\000\021',
	STMSWord2011MSSIShapePreset18 = '\000\304\000\022',
	STMSWord2011MSSIShapePreset19 = '\000\304\000\023',
	STMSWord2011MSSIShapePreset20 = '\000\304\000\024',
	STMSWord2011MSSIShapePreset21 = '\000\304\000\025',
	STMSWord2011MSSIShapePreset22 = '\000\304\000\026',
	STMSWord2011MSSIShapePreset23 = '\000\304\000\027',
	STMSWord2011MSSIShapePreset24 = '\000\304\000\030',
	STMSWord2011MSSIShapePreset25 = '\000\304\000\031',
	STMSWord2011MSSIShapePreset26 = '\000\304\000\032',
	STMSWord2011MSSIShapePreset27 = '\000\304\000\033',
	STMSWord2011MSSIShapePreset28 = '\000\304\000\034',
	STMSWord2011MSSIShapePreset29 = '\000\304\000\035',
	STMSWord2011MSSIShapePreset30 = '\000\304\000\036',
	STMSWord2011MSSIShapePreset31 = '\000\304\000\037',
	STMSWord2011MSSIShapePreset32 = '\000\304\000 ',
	STMSWord2011MSSIShapePreset33 = '\000\304\000!',
	STMSWord2011MSSIShapePreset34 = '\000\304\000\"',
	STMSWord2011MSSIShapePreset35 = '\000\304\000#',
	STMSWord2011MSSIShapePreset36 = '\000\304\000$',
	STMSWord2011MSSIShapePreset37 = '\000\304\000%',
	STMSWord2011MSSIShapePreset38 = '\000\304\000&',
	STMSWord2011MSSIShapePreset39 = '\000\304\000\'',
	STMSWord2011MSSIShapePreset40 = '\000\304\000(',
	STMSWord2011MSSIShapePreset41 = '\000\304\000)',
	STMSWord2011MSSIShapePreset42 = '\000\304\000*',
	STMSWord2011MSSILinePreset1 = '\000\304\'\021',
	STMSWord2011MSSILinePreset2 = '\000\304\'\022',
	STMSWord2011MSSILinePreset3 = '\000\304\'\023',
	STMSWord2011MSSILinePreset4 = '\000\304\'\024',
	STMSWord2011MSSILinePreset5 = '\000\304\'\025',
	STMSWord2011MSSILinePreset6 = '\000\304\'\026',
	STMSWord2011MSSILinePreset7 = '\000\304\'\027',
	STMSWord2011MSSILinePreset8 = '\000\304\'\030',
	STMSWord2011MSSILinePreset9 = '\000\304\'\031',
	STMSWord2011MSSILinePreset10 = '\000\304\'\032',
	STMSWord2011MSSILinePreset11 = '\000\304\'\033',
	STMSWord2011MSSILinePreset12 = '\000\304\'\034',
	STMSWord2011MSSILinePreset13 = '\000\304\'\035',
	STMSWord2011MSSILinePreset14 = '\000\304\'\036',
	STMSWord2011MSSILinePreset15 = '\000\304\'\037',
	STMSWord2011MSSILinePreset16 = '\000\304\' ',
	STMSWord2011MSSILinePreset17 = '\000\304\'!',
	STMSWord2011MSSILinePreset18 = '\000\304\'\"',
	STMSWord2011MSSILinePreset19 = '\000\304\'#',
	STMSWord2011MSSILinePreset20 = '\000\304\'$',
	STMSWord2011MSSILinePreset21 = '\000\304\'%'
};
typedef enum STMSWord2011MSSI STMSWord2011MSSI;

enum STMSWord2011MBSI {
	STMSWord2011MBSIBackgroundUnset = '\000\304\377\376',
	STMSWord2011MBSIBackgroundNotAPreset = '\000\305\000\000',
	STMSWord2011MBSIBackgroundPreset1 = '\000\305\000\001',
	STMSWord2011MBSIBackgroundPreset2 = '\000\305\000\002',
	STMSWord2011MBSIBackgroundPreset3 = '\000\305\000\003',
	STMSWord2011MBSIBackgroundPreset4 = '\000\305\000\004',
	STMSWord2011MBSIBackgroundPreset5 = '\000\305\000\005',
	STMSWord2011MBSIBackgroundPreset6 = '\000\305\000\006',
	STMSWord2011MBSIBackgroundPreset7 = '\000\305\000\007',
	STMSWord2011MBSIBackgroundPreset8 = '\000\305\000\010',
	STMSWord2011MBSIBackgroundPreset9 = '\000\305\000\011',
	STMSWord2011MBSIBackgroundPreset10 = '\000\305\000\012',
	STMSWord2011MBSIBackgroundPreset11 = '\000\305\000\013',
	STMSWord2011MBSIBackgroundPreset12 = '\000\305\000\014'
};
typedef enum STMSWord2011MBSI STMSWord2011MBSI;

enum STMSWord2011PDrT {
	STMSWord2011PDrTTextDirectionUnset = '\000\352\377\376',
	STMSWord2011PDrTLeftToRight = '\000\353\000\001',
	STMSWord2011PDrTRightToLeft = '\000\353\000\002'
};
typedef enum STMSWord2011PDrT STMSWord2011PDrT;

enum STMSWord2011PBtT {
	STMSWord2011PBtTBulletTypeUnset = '\000\347\377\376',
	STMSWord2011PBtTBulletTypeNone = '\000\350\000\000',
	STMSWord2011PBtTBulletTypeUnnumbered = '\000\350\000\001',
	STMSWord2011PBtTBulletTypeNumbered = '\000\350\000\002',
	STMSWord2011PBtTPictureBulletType = '\000\350\000\003'
};
typedef enum STMSWord2011PBtT STMSWord2011PBtT;

enum STMSWord2011PBtS {
	STMSWord2011PBtSNumberedBulletStyleUnset = '\000\350\377\376',
	STMSWord2011PBtSNumberedBulletStyleAlphaLowercasePeriod = '\000\351\000\000',
	STMSWord2011PBtSNumberedBulletStyleAlphaUppercasePeriod = '\000\351\000\001',
	STMSWord2011PBtSNumberedBulletStyleArabicRightParen = '\000\351\000\002',
	STMSWord2011PBtSNumberedBulletStyleArabicPeriod = '\000\351\000\003',
	STMSWord2011PBtSNumberedBulletStyleRomanLowercaseParenBoth = '\000\351\000\004',
	STMSWord2011PBtSNumberedBulletStyleRomanLowercaseParenRight = '\000\351\000\005',
	STMSWord2011PBtSNumberedBulletStyleRomanLowercasePeriod = '\000\351\000\006',
	STMSWord2011PBtSNumberedBulletStyleRomanUppercasePeriod = '\000\351\000\007',
	STMSWord2011PBtSNumberedBulletStyleAlphaLowercaseParenBoth = '\000\351\000\010',
	STMSWord2011PBtSNumberedBulletStyleAlphaLowercaseParenRight = '\000\351\000\011',
	STMSWord2011PBtSNumberedBulletStyleAlphaUppercaseParenBoth = '\000\351\000\012',
	STMSWord2011PBtSNumberedBulletStyleAlphaUppercaseParenRight = '\000\351\000\013',
	STMSWord2011PBtSNumberedBulletStyleArabicParenBoth = '\000\351\000\014',
	STMSWord2011PBtSNumberedBulletStyleArabicPlain = '\000\351\000\015',
	STMSWord2011PBtSNumberedBulletStyleRomanUppercaseParenBoth = '\000\351\000\016',
	STMSWord2011PBtSNumberedBulletStyleRomanUppercaseParenRight = '\000\351\000\017',
	STMSWord2011PBtSNumberedBulletStyleSimplifiedChinesePlain = '\000\351\000\020',
	STMSWord2011PBtSNumberedBulletStyleSimplifiedChinesePeriod = '\000\351\000\021',
	STMSWord2011PBtSNumberedBulletStyleCircleNumberPlain = '\000\351\000\022',
	STMSWord2011PBtSNumberedBulletStyleCircleNumberWhitePlain = '\000\351\000\023',
	STMSWord2011PBtSNumberedBulletStyleCircleNumberBlackPlain = '\000\351\000\024',
	STMSWord2011PBtSNumberedBulletStyleTraditionalChinesePlain = '\000\351\000\025',
	STMSWord2011PBtSNumberedBulletStyleTraditionalChinesePeriod = '\000\351\000\026',
	STMSWord2011PBtSNumberedBulletStyleArabicAlphaDash = '\000\351\000\027',
	STMSWord2011PBtSNumberedBulletStyleArabicAbjadDash = '\000\351\000\030',
	STMSWord2011PBtSNumberedBulletStyleHebrewAlphaDash = '\000\351\000\031',
	STMSWord2011PBtSNumberedBulletStyleKanjiKoreanPlain = '\000\351\000\032',
	STMSWord2011PBtSNumberedBulletStyleKanjiKoreanPeriod = '\000\351\000\033',
	STMSWord2011PBtSNumberedBulletStyleArabicDBPlain = '\000\351\000\034',
	STMSWord2011PBtSNumberedBulletStyleArabicDBPeriod = '\000\351\000\035',
	STMSWord2011PBtSNumberedBulletStyleThaiAlphaPeriod = '\000\351\000\036',
	STMSWord2011PBtSNumberedBulletStyleThaiAlphaParenRight = '\000\351\000\037',
	STMSWord2011PBtSNumberedBulletStyleThaiAlphaParenBoth = '\000\351\000 ',
	STMSWord2011PBtSNumberedBulletStyleThaiNumberPeriod = '\000\351\000!',
	STMSWord2011PBtSNumberedBulletStyleThaiNumberParenRight = '\000\351\000\"',
	STMSWord2011PBtSNumberedBulletStyleThaiParenBoth = '\000\351\000#',
	STMSWord2011PBtSNumberedBulletStyleHindiAlphaPeriod = '\000\351\000$',
	STMSWord2011PBtSNumberedBulletStyleHindiNumberPeriod = '\000\351\000%',
	STMSWord2011PBtSNumberedBulletStyleKanjiSimpifiedChineseDBPeriod = '\000\351\000&',
	STMSWord2011PBtSNumberedBulletStyleHindiNumberParenRight = '\000\351\000\'',
	STMSWord2011PBtSNumberedBulletStyleHindiAlpha1Period = '\000\351\000('
};
typedef enum STMSWord2011PBtS STMSWord2011PBtS;

enum STMSWord2011PTSp {
	STMSWord2011PTSpTabstopUnset = '\000\364\377\376',
	STMSWord2011PTSpTabstopLeft = '\000\365\000\001',
	STMSWord2011PTSpTabstopCenter = '\000\365\000\002',
	STMSWord2011PTSpTabstopRight = '\000\365\000\003',
	STMSWord2011PTSpTabstopDecimal = '\000\365\000\004'
};
typedef enum STMSWord2011PTSp STMSWord2011PTSp;

enum STMSWord2011MRfT {
	STMSWord2011MRfTReflectionUnset = '\003\351\377\376',
	STMSWord2011MRfTReflectionTypeNone = '\003\352\000\000',
	STMSWord2011MRfTReflectionType1 = '\003\352\000\001',
	STMSWord2011MRfTReflectionType2 = '\003\352\000\002',
	STMSWord2011MRfTReflectionType3 = '\003\352\000\003',
	STMSWord2011MRfTReflectionType4 = '\003\352\000\004',
	STMSWord2011MRfTReflectionType5 = '\003\352\000\005',
	STMSWord2011MRfTReflectionType6 = '\003\352\000\006',
	STMSWord2011MRfTReflectionType7 = '\003\352\000\007',
	STMSWord2011MRfTReflectionType8 = '\003\352\000\010',
	STMSWord2011MRfTReflectionType9 = '\003\352\000\011'
};
typedef enum STMSWord2011MRfT STMSWord2011MRfT;

enum STMSWord2011MTtA {
	STMSWord2011MTtATextureUnset = '\003\352\377\376',
	STMSWord2011MTtATextureTopLeft = '\003\353\000\000',
	STMSWord2011MTtATextureTop = '\003\353\000\001',
	STMSWord2011MTtATextureTopRight = '\003\353\000\002',
	STMSWord2011MTtATextureLeft = '\003\353\000\003',
	STMSWord2011MTtATextureCenter = '\003\353\000\004',
	STMSWord2011MTtATextureRight = '\003\353\000\005',
	STMSWord2011MTtATextureBottomLeft = '\003\353\000\006',
	STMSWord2011MTtATextureBotton = '\003\353\000\007',
	STMSWord2011MTtATextureBottomRight = '\003\353\000\010'
};
typedef enum STMSWord2011MTtA STMSWord2011MTtA;

enum STMSWord2011PBlA {
	STMSWord2011PBlATextBaselineAlignmentUnset = '\003\353\377\376',
	STMSWord2011PBlATextBaselineAlignBaseline = '\003\354\000\001',
	STMSWord2011PBlATextBaselineAlignTop = '\003\354\000\002',
	STMSWord2011PBlATextBaselineAlignCenter = '\003\354\000\003',
	STMSWord2011PBlATextBaselineAlignEastAsian50 = '\003\354\000\004',
	STMSWord2011PBlATextBaselineAlignAutomatic = '\003\354\000\005'
};
typedef enum STMSWord2011PBlA STMSWord2011PBlA;

enum STMSWord2011MCbF {
	STMSWord2011MCbFClipboardFormatUnset = '\003\354\377\376',
	STMSWord2011MCbFNativeClipboardFormat = '\003\355\000\001',
	STMSWord2011MCbFHTMlClipboardFormat = '\003\355\000\002',
	STMSWord2011MCbFRTFClipboardFormat = '\003\355\000\003',
	STMSWord2011MCbFPlainTextClipboardFormat = '\003\355\000\004'
};
typedef enum STMSWord2011MCbF STMSWord2011MCbF;

enum STMSWord2011MTiP {
	STMSWord2011MTiPInsertBefore = '\003\356\000\000',
	STMSWord2011MTiPInsertAfter = '\003\356\000\001'
};
typedef enum STMSWord2011MTiP STMSWord2011MTiP;

enum STMSWord2011MPiT {
	STMSWord2011MPiTSaveAsDefault = '\003\362\377\376',
	STMSWord2011MPiTSaveAsPNGFile = '\003\363\000\000',
	STMSWord2011MPiTSaveAsBMPFile = '\003\363\000\001',
	STMSWord2011MPiTSaveAsGIFFile = '\003\363\000\002',
	STMSWord2011MPiTSaveAsJPGFile = '\003\363\000\003',
	STMSWord2011MPiTSaveAsPDFFile = '\003\363\000\004'
};
typedef enum STMSWord2011MPiT STMSWord2011MPiT;

enum STMSWord2011MPeT {
	STMSWord2011MPeTNoEffect = '\003\364\000\000',
	STMSWord2011MPeTEffectBackgroundRemoval = '\003\364\000\001',
	STMSWord2011MPeTEffectBlur = '\003\364\000\002',
	STMSWord2011MPeTEffectBrightnessContrast = '\003\364\000\003',
	STMSWord2011MPeTEffectCement = '\003\364\000\004',
	STMSWord2011MPeTEffectCrisscrossEtching = '\003\364\000\005',
	STMSWord2011MPeTEffectChalkSketch = '\003\364\000\006',
	STMSWord2011MPeTEffectColorTemperature = '\003\364\000\007',
	STMSWord2011MPeTEffectCutout = '\003\364\000\010',
	STMSWord2011MPeTEffectFilmGrain = '\003\364\000\011',
	STMSWord2011MPeTEffectGlass = '\003\364\000\012',
	STMSWord2011MPeTEffectGlowDiffused = '\003\364\000\013',
	STMSWord2011MPeTEffectGlowEdges = '\003\364\000\014',
	STMSWord2011MPeTEffectLightScreen = '\003\364\000\015',
	STMSWord2011MPeTEffectLineDrawing = '\003\364\000\016',
	STMSWord2011MPeTEffectMarker = '\003\364\000\017',
	STMSWord2011MPeTEffectMosiaicBubbles = '\003\364\000\020',
	STMSWord2011MPeTEffectPaintBrush = '\003\364\000\021',
	STMSWord2011MPeTEffectPaintStrokes = '\003\364\000\022',
	STMSWord2011MPeTEffectPastelsSmooth = '\003\364\000\023',
	STMSWord2011MPeTEffectPencilGrayscale = '\003\364\000\024',
	STMSWord2011MPeTEffectPencilSketch = '\003\364\000\025',
	STMSWord2011MPeTEffectPhotocopy = '\003\364\000\026',
	STMSWord2011MPeTEffectPlasticWrap = '\003\364\000\027',
	STMSWord2011MPeTEffectSaturation = '\003\364\000\030',
	STMSWord2011MPeTEffectSharpenSoften = '\003\364\000\031',
	STMSWord2011MPeTEffectTexturizer = '\003\364\000\032',
	STMSWord2011MPeTEffectWatercolorSponge = '\003\364\000\033'
};
typedef enum STMSWord2011MPeT STMSWord2011MPeT;

enum STMSWord2011MSgT {
	STMSWord2011MSgTLine = '\000\217\000\000',
	STMSWord2011MSgTCurve = '\000\217\000\001'
};
typedef enum STMSWord2011MSgT STMSWord2011MSgT;

enum STMSWord2011MEdT {
	STMSWord2011MEdTAuto = '\000\220\000\000',
	STMSWord2011MEdTCorner = '\000\220\000\001',
	STMSWord2011MEdTSmooth = '\000\220\000\002',
	STMSWord2011MEdTSymmetric = '\000\220\000\003'
};
typedef enum STMSWord2011MEdT STMSWord2011MEdT;

enum STMSWord2011SANP {
	STMSWord2011SANPDefaultNodePosition = '\003\365\000\001',
	STMSWord2011SANPAfterNode = '\003\365\000\002',
	STMSWord2011SANPBeforeNode = '\003\365\000\003',
	STMSWord2011SANPAboveNode = '\003\365\000\004',
	STMSWord2011SANPBelowNode = '\003\365\000\005'
};
typedef enum STMSWord2011SANP STMSWord2011SANP;

enum STMSWord2011SANT {
	STMSWord2011SANTDefaultNode = '\003\366\000\001',
	STMSWord2011SANTAssistantNode = '\003\366\000\002'
};
typedef enum STMSWord2011SANT STMSWord2011SANT;

enum STMSWord2011MOCT {
	STMSWord2011MOCTOrgChartLayoutUnset = '\003\366\377\376',
	STMSWord2011MOCTOrgChartLayoutStandard = '\003\367\000\001',
	STMSWord2011MOCTOrgChartLayoutBothHanging = '\003\367\000\002',
	STMSWord2011MOCTOrgChartLayoutLeftHanging = '\003\367\000\003',
	STMSWord2011MOCTOrgChartLayoutRightHanging = '\003\367\000\004',
	STMSWord2011MOCTOrgChartLayoutDefault = '\003\367\000\005'
};
typedef enum STMSWord2011MOCT STMSWord2011MOCT;

enum STMSWord2011MAlC {
	STMSWord2011MAlCAlignLefts = '\000\000\000\000',
	STMSWord2011MAlCAlignCenters = '\000\000\000\001',
	STMSWord2011MAlCAlignRights = '\000\000\000\002',
	STMSWord2011MAlCAlignTops = '\000\000\000\003',
	STMSWord2011MAlCAlignMiddles = '\000\000\000\004',
	STMSWord2011MAlCAlignBottoms = '\000\000\000\005'
};
typedef enum STMSWord2011MAlC STMSWord2011MAlC;

enum STMSWord2011MDsC {
	STMSWord2011MDsCDistributeHorizontally = '\000\000\000\000',
	STMSWord2011MDsCDistributeVertically = '\000\000\000\001'
};
typedef enum STMSWord2011MDsC STMSWord2011MDsC;

enum STMSWord2011MOrT {
	STMSWord2011MOrTOrientationUnset = '\000\214\377\376',
	STMSWord2011MOrTHorizontalOrientation = '\000\215\000\001',
	STMSWord2011MOrTVerticalOrientation = '\000\215\000\002'
};
typedef enum STMSWord2011MOrT STMSWord2011MOrT;

enum STMSWord2011MZoC {
	STMSWord2011MZoCBringShapeToFront = '\000p\000\000',
	STMSWord2011MZoCSendShapeToBack = '\000p\000\001',
	STMSWord2011MZoCBringShapeForward = '\000p\000\002',
	STMSWord2011MZoCSendShapeBackward = '\000p\000\003',
	STMSWord2011MZoCBringShapeInFrontOfText = '\000p\000\004',
	STMSWord2011MZoCSendShapeBehindText = '\000p\000\005'
};
typedef enum STMSWord2011MZoC STMSWord2011MZoC;

enum STMSWord2011MFlC {
	STMSWord2011MFlCFlipHorizontal = '\000q\000\000',
	STMSWord2011MFlCFlipVertical = '\000q\000\001'
};
typedef enum STMSWord2011MFlC STMSWord2011MFlC;

enum STMSWord2011MTri {
	STMSWord2011MTriTrue = '\000\240\377\377',
	STMSWord2011MTriFalse = '\000\241\000\000',
	STMSWord2011MTriCTrue = '\000\241\000\001',
	STMSWord2011MTriToggle = '\000\240\377\375',
	STMSWord2011MTriTriStateUnset = '\000\240\377\376'
};
typedef enum STMSWord2011MTri STMSWord2011MTri;

enum STMSWord2011MBW {
	STMSWord2011MBWBlackAndWhiteUnset = '\000\254\377\376',
	STMSWord2011MBWBlackAndWhiteModeAutomatic = '\000\255\000\001',
	STMSWord2011MBWBlackAndWhiteModeGrayScale = '\000\255\000\002',
	STMSWord2011MBWBlackAndWhiteModeLightGrayScale = '\000\255\000\003',
	STMSWord2011MBWBlackAndWhiteModeInverseGrayScale = '\000\255\000\004',
	STMSWord2011MBWBlackAndWhiteModeGrayOutline = '\000\255\000\005',
	STMSWord2011MBWBlackAndWhiteModeBlackTextAndLine = '\000\255\000\006',
	STMSWord2011MBWBlackAndWhiteModeHighContrast = '\000\255\000\007',
	STMSWord2011MBWBlackAndWhiteModeBlack = '\000\255\000\010',
	STMSWord2011MBWBlackAndWhiteModeWhite = '\000\255\000\011',
	STMSWord2011MBWBlackAndWhiteModeDontShow = '\000\255\000\012'
};
typedef enum STMSWord2011MBW STMSWord2011MBW;

enum STMSWord2011MBPS {
	STMSWord2011MBPSBarLeft = '\000r\000\000',
	STMSWord2011MBPSBarTop = '\000r\000\001',
	STMSWord2011MBPSBarRight = '\000r\000\002',
	STMSWord2011MBPSBarBottom = '\000r\000\003',
	STMSWord2011MBPSBarFloating = '\000r\000\004',
	STMSWord2011MBPSBarPopUp = '\000r\000\005',
	STMSWord2011MBPSBarMenu = '\000r\000\006'
};
typedef enum STMSWord2011MBPS STMSWord2011MBPS;

enum STMSWord2011MBPt {
	STMSWord2011MBPtNoProtection = '\000s\000\000',
	STMSWord2011MBPtNoCustomize = '\000s\000\001',
	STMSWord2011MBPtNoResize = '\000s\000\002',
	STMSWord2011MBPtNoMove = '\000s\000\004',
	STMSWord2011MBPtNoChangeVisible = '\000s\000\010',
	STMSWord2011MBPtNoChangeDock = '\000s\000\020',
	STMSWord2011MBPtNoVerticalDock = '\000s\000 ',
	STMSWord2011MBPtNoHorizontalDock = '\000s\000@'
};
typedef enum STMSWord2011MBPt STMSWord2011MBPt;

enum STMSWord2011MBTY {
	STMSWord2011MBTYNormalCommandBar = '\000t\000\000',
	STMSWord2011MBTYMenubarCommandBar = '\000t\000\001',
	STMSWord2011MBTYPopupCommandBar = '\000t\000\002'
};
typedef enum STMSWord2011MBTY STMSWord2011MBTY;

enum STMSWord2011MCLT {
	STMSWord2011MCLTControlCustom = '\000u\000\000',
	STMSWord2011MCLTControlButton = '\000u\000\001',
	STMSWord2011MCLTControlEdit = '\000u\000\002',
	STMSWord2011MCLTControlDropDown = '\000u\000\003',
	STMSWord2011MCLTControlCombobox = '\000u\000\004',
	STMSWord2011MCLTButtonDropDown = '\000u\000\005',
	STMSWord2011MCLTSplitDropDown = '\000u\000\006',
	STMSWord2011MCLTOCXDropDown = '\000u\000\007',
	STMSWord2011MCLTGenericDropDown = '\000u\000\010',
	STMSWord2011MCLTGraphicDropDown = '\000u\000\011',
	STMSWord2011MCLTControlPopup = '\000u\000\012',
	STMSWord2011MCLTGraphicPopup = '\000u\000\013',
	STMSWord2011MCLTButtonPopup = '\000u\000\014',
	STMSWord2011MCLTSplitButtonPopup = '\000u\000\015',
	STMSWord2011MCLTSplitButtonMRUPopup = '\000u\000\016',
	STMSWord2011MCLTControlLabel = '\000u\000\017',
	STMSWord2011MCLTExpandingGrid = '\000u\000\020',
	STMSWord2011MCLTSplitExpandingGrid = '\000u\000\021',
	STMSWord2011MCLTControlGrid = '\000u\000\022',
	STMSWord2011MCLTControlGauge = '\000u\000\023',
	STMSWord2011MCLTGraphicCombobox = '\000u\000\024',
	STMSWord2011MCLTControlPane = '\000u\000\025',
	STMSWord2011MCLTActiveX = '\000u\000\026',
	STMSWord2011MCLTControlGroup = '\000u\000\027',
	STMSWord2011MCLTControlTab = '\000u\000\030',
	STMSWord2011MCLTControlSpinner = '\000u\000\031'
};
typedef enum STMSWord2011MCLT STMSWord2011MCLT;

enum STMSWord2011MBns {
	STMSWord2011MBnsButtonStateUp = '\000v\000\000',
	STMSWord2011MBnsButtonStateDown = '\000u\377\377',
	STMSWord2011MBnsButtonStateUnset = '\000v\000\002'
};
typedef enum STMSWord2011MBns STMSWord2011MBns;

enum STMSWord2011McOu {
	STMSWord2011McOuNeither = '\000w\000\000',
	STMSWord2011McOuServer = '\000w\000\001',
	STMSWord2011McOuClient = '\000w\000\002',
	STMSWord2011McOuBoth = '\000w\000\003'
};
typedef enum STMSWord2011McOu STMSWord2011McOu;

enum STMSWord2011MBTs {
	STMSWord2011MBTsButtonAutomatic = '\000x\000\000',
	STMSWord2011MBTsButtonIcon = '\000x\000\001',
	STMSWord2011MBTsButtonCaption = '\000x\000\002',
	STMSWord2011MBTsButtonIconAndCaption = '\000x\000\003'
};
typedef enum STMSWord2011MBTs STMSWord2011MBTs;

enum STMSWord2011MXcb {
	STMSWord2011MXcbComboboxStyleNormal = '\000y\000\000',
	STMSWord2011MXcbComboboxStyleLabel = '\000y\000\001'
};
typedef enum STMSWord2011MXcb STMSWord2011MXcb;

enum STMSWord2011MMNA {
	STMSWord2011MMNANone = '\000{\000\000',
	STMSWord2011MMNARandom = '\000{\000\001',
	STMSWord2011MMNAUnfold = '\000{\000\002',
	STMSWord2011MMNASlide = '\000{\000\003'
};
typedef enum STMSWord2011MMNA STMSWord2011MMNA;

enum STMSWord2011MHlT {
	STMSWord2011MHlTHyperlinkTypeTextRange = '\000\226\000\000',
	STMSWord2011MHlTHyperlinkTypeShape = '\000\226\000\001',
	STMSWord2011MHlTHyperlinkTypeInlineShape = '\000\226\000\002'
};
typedef enum STMSWord2011MHlT STMSWord2011MHlT;

enum STMSWord2011MXiM {
	STMSWord2011MXiMAppendString = '\000\256\000\000',
	STMSWord2011MXiMPostString = '\000\256\000\001'
};
typedef enum STMSWord2011MXiM STMSWord2011MXiM;

enum STMSWord2011MANT {
	STMSWord2011MANTIdle = '\000|\000\001',
	STMSWord2011MANTGreeting = '\000|\000\002',
	STMSWord2011MANTGoodbye = '\000|\000\003',
	STMSWord2011MANTBeginSpeaking = '\000|\000\004',
	STMSWord2011MANTCharacterSuccessMajor = '\000|\000\006',
	STMSWord2011MANTGetAttentionMajor = '\000|\000\013',
	STMSWord2011MANTGetAttentionMinor = '\000|\000\014',
	STMSWord2011MANTSearching = '\000|\000\015',
	STMSWord2011MANTPrinting = '\000|\000\022',
	STMSWord2011MANTGestureRight = '\000|\000\023',
	STMSWord2011MANTWritingNotingSomething = '\000|\000\026',
	STMSWord2011MANTWorkingAtSomething = '\000|\000\027',
	STMSWord2011MANTThinking = '\000|\000\030',
	STMSWord2011MANTSendingMail = '\000|\000\031',
	STMSWord2011MANTListensToComputer = '\000|\000\032',
	STMSWord2011MANTDisappear = '\000|\000\037',
	STMSWord2011MANTAppear = '\000|\000 ',
	STMSWord2011MANTGetArtsy = '\000|\000d',
	STMSWord2011MANTGetTechy = '\000|\000e',
	STMSWord2011MANTGetWizardy = '\000|\000f',
	STMSWord2011MANTCheckingSomething = '\000|\000g',
	STMSWord2011MANTLookDown = '\000|\000h',
	STMSWord2011MANTLookDownLeft = '\000|\000i',
	STMSWord2011MANTLookDownRight = '\000|\000j',
	STMSWord2011MANTLookLeft = '\000|\000k',
	STMSWord2011MANTLookRight = '\000|\000l',
	STMSWord2011MANTLookUp = '\000|\000m',
	STMSWord2011MANTLookUpLeft = '\000|\000n',
	STMSWord2011MANTLookUpRight = '\000|\000o',
	STMSWord2011MANTSaving = '\000|\000p',
	STMSWord2011MANTGestureDown = '\000|\000q',
	STMSWord2011MANTGestureLeft = '\000|\000r',
	STMSWord2011MANTGestureUp = '\000|\000s',
	STMSWord2011MANTEmptyTrash = '\000|\000t'
};
typedef enum STMSWord2011MANT STMSWord2011MANT;

enum STMSWord2011MBSt {
	STMSWord2011MBStButtonNone = '\000}\000\000',
	STMSWord2011MBStButtonOk = '\000}\000\001',
	STMSWord2011MBStButtonCancel = '\000}\000\002',
	STMSWord2011MBStButtonsOkCancel = '\000}\000\003',
	STMSWord2011MBStButtonsYesNo = '\000}\000\004',
	STMSWord2011MBStButtonsYesNoCancel = '\000}\000\005',
	STMSWord2011MBStButtonsBackClose = '\000}\000\006',
	STMSWord2011MBStButtonsNextClose = '\000}\000\007',
	STMSWord2011MBStButtonsBackNextClose = '\000}\000\010',
	STMSWord2011MBStButtonsRetryCancel = '\000}\000\011',
	STMSWord2011MBStButtonsAbortRetryIgnore = '\000}\000\012',
	STMSWord2011MBStButtonsSearchClose = '\000}\000\013',
	STMSWord2011MBStButtonsBackNextSnooze = '\000}\000\014',
	STMSWord2011MBStButtonsTipsOptionsClose = '\000}\000\015',
	STMSWord2011MBStButtonsYesAllNoCancel = '\000}\000\016'
};
typedef enum STMSWord2011MBSt STMSWord2011MBSt;

enum STMSWord2011MIct {
	STMSWord2011MIctIconNone = '\000~\000\000',
	STMSWord2011MIctIconApplication = '\000~\000\001',
	STMSWord2011MIctIconAlert = '\000~\000\002',
	STMSWord2011MIctIconTip = '\000~\000\003',
	STMSWord2011MIctIconAlertCritical = '\000~\000e',
	STMSWord2011MIctIconAlertWarning = '\000~\000g',
	STMSWord2011MIctIconAlertInfo = '\000~\000h'
};
typedef enum STMSWord2011MIct STMSWord2011MIct;

enum STMSWord2011MWAt {
	STMSWord2011MWAtInactive = '\000\202\000\000',
	STMSWord2011MWAtActive = '\000\202\000\001',
	STMSWord2011MWAtSuspend = '\000\202\000\002',
	STMSWord2011MWAtResume = '\000\202\000\003'
};
typedef enum STMSWord2011MWAt STMSWord2011MWAt;

enum STMSWord2011MeDP {
	STMSWord2011MeDPPropertyTypeNumber = '\000\242\000\001',
	STMSWord2011MeDPPropertyTypeBoolean = '\000\242\000\002',
	STMSWord2011MeDPPropertyTypeDate = '\000\242\000\003',
	STMSWord2011MeDPPropertyTypeString = '\000\242\000\004',
	STMSWord2011MeDPPropertyTypeFloat = '\000\242\000\005'
};
typedef enum STMSWord2011MeDP STMSWord2011MeDP;

enum STMSWord2011MASc {
	STMSWord2011MAScMsoAutomationSecurityLow = '\000\243\000\001',
	STMSWord2011MAScMsoAutomationSecurityByUI = '\000\243\000\002',
	STMSWord2011MAScMsoAutomationSecurityForceDisable = '\000\243\000\003'
};
typedef enum STMSWord2011MASc STMSWord2011MASc;

enum STMSWord2011MSsz {
	STMSWord2011MSszResolution544x376 = '\000\204\000\000',
	STMSWord2011MSszResolution640x480 = '\000\204\000\001',
	STMSWord2011MSszResolution720x512 = '\000\204\000\002',
	STMSWord2011MSszResolution800x600 = '\000\204\000\003',
	STMSWord2011MSszResolution1024x768 = '\000\204\000\004',
	STMSWord2011MSszResolution1152x882 = '\000\204\000\005',
	STMSWord2011MSszResolution1152x900 = '\000\204\000\006',
	STMSWord2011MSszResolution1280x1024 = '\000\204\000\007',
	STMSWord2011MSszResolution1600x1200 = '\000\204\000\010',
	STMSWord2011MSszResolution1800x1440 = '\000\204\000\011',
	STMSWord2011MSszResolution1920x1200 = '\000\204\000\012'
};
typedef enum STMSWord2011MSsz STMSWord2011MSsz;

enum STMSWord2011MChS {
	STMSWord2011MChSArabicCharacterSet = '\000\205\000\001',
	STMSWord2011MChSCyrillicCharacterSet = '\000\205\000\002',
	STMSWord2011MChSEnglishCharacterSet = '\000\205\000\003',
	STMSWord2011MChSGreekCharacterSet = '\000\205\000\004',
	STMSWord2011MChSHebrewCharacterSet = '\000\205\000\005',
	STMSWord2011MChSJapaneseCharacterSet = '\000\205\000\006',
	STMSWord2011MChSKoreanCharacterSet = '\000\205\000\007',
	STMSWord2011MChSMultilingualUnicodeCharacterSet = '\000\205\000\010',
	STMSWord2011MChSSimplifiedChineseCharacterSet = '\000\205\000\011',
	STMSWord2011MChSThaiCharacterSet = '\000\205\000\012',
	STMSWord2011MChSTraditionalChineseCharacterSet = '\000\205\000\013',
	STMSWord2011MChSVietnameseCharacterSet = '\000\205\000\014'
};
typedef enum STMSWord2011MChS STMSWord2011MChS;

enum STMSWord2011MtEn {
	STMSWord2011MtEnEncodingThai = '\000\213\003j',
	STMSWord2011MtEnEncodingJapaneseShiftJIS = '\000\213\003\244',
	STMSWord2011MtEnEncodingSimplifiedChinese = '\000\213\003\250',
	STMSWord2011MtEnEncodingKorean = '\000\213\003\265',
	STMSWord2011MtEnEncodingBig5TraditionalChinese = '\000\213\003\266',
	STMSWord2011MtEnEncodingLittleEndian = '\000\213\004\260',
	STMSWord2011MtEnEncodingBigEndian = '\000\213\004\261',
	STMSWord2011MtEnEncodingCentralEuropean = '\000\213\004\342',
	STMSWord2011MtEnEncodingCyrillic = '\000\213\004\343',
	STMSWord2011MtEnEncodingWestern = '\000\213\004\344',
	STMSWord2011MtEnEncodingGreek = '\000\213\004\345',
	STMSWord2011MtEnEncodingTurkish = '\000\213\004\346',
	STMSWord2011MtEnEncodingHebrew = '\000\213\004\347',
	STMSWord2011MtEnEncodingArabic = '\000\213\004\350',
	STMSWord2011MtEnEncodingBaltic = '\000\213\004\351',
	STMSWord2011MtEnEncodingVietnamese = '\000\213\004\352',
	STMSWord2011MtEnEncodingISO88591Latin1 = '\000\213o\257',
	STMSWord2011MtEnEncodingISO88592CentralEurope = '\000\213o\260',
	STMSWord2011MtEnEncodingISO88593Latin3 = '\000\213o\261',
	STMSWord2011MtEnEncodingISO88594Baltic = '\000\213o\262',
	STMSWord2011MtEnEncodingISO88595Cyrillic = '\000\213o\263',
	STMSWord2011MtEnEncodingISO88596Arabic = '\000\213o\264',
	STMSWord2011MtEnEncodingISO88597Greek = '\000\213o\265',
	STMSWord2011MtEnEncodingISO88598Hebrew = '\000\213o\266',
	STMSWord2011MtEnEncodingISO88599Turkish = '\000\213o\267',
	STMSWord2011MtEnEncodingISO885915Latin9 = '\000\213o\275',
	STMSWord2011MtEnEncodingISO2022JapaneseNoHalfWidthKatakana = '\000\213\304,',
	STMSWord2011MtEnEncodingISO2022JapaneseJISX02021984 = '\000\213\304-',
	STMSWord2011MtEnEncodingISO2022JapaneseJISX02011989 = '\000\213\304.',
	STMSWord2011MtEnEncodingISO2022KR = '\000\213\3041',
	STMSWord2011MtEnEncodingISO2022CNTraditionalChinese = '\000\213\3043',
	STMSWord2011MtEnEncodingISO2022CNSimplifiedChinese = '\000\213\3045',
	STMSWord2011MtEnEncodingMacRoman = '\000\213\'\020',
	STMSWord2011MtEnEncodingMacJapanese = '\000\213\'\021',
	STMSWord2011MtEnEncodingMacTraditionalChinese = '\000\213\'\022',
	STMSWord2011MtEnEncodingMacKorean = '\000\213\'\023',
	STMSWord2011MtEnEncodingMacArabic = '\000\213\'\024',
	STMSWord2011MtEnEncodingMacHebrew = '\000\213\'\025',
	STMSWord2011MtEnEncodingMacGreek1 = '\000\213\'\026',
	STMSWord2011MtEnEncodingMacCyrillic = '\000\213\'\027',
	STMSWord2011MtEnEncodingMacSimplifiedChineseGB2312 = '\000\213\'\030',
	STMSWord2011MtEnEncodingMacRomania = '\000\213\'\032',
	STMSWord2011MtEnEncodingMacUkraine = '\000\213\'!',
	STMSWord2011MtEnEncodingMacLatin2 = '\000\213\'-',
	STMSWord2011MtEnEncodingMacIcelandic = '\000\213\'_',
	STMSWord2011MtEnEncodingMacTurkish = '\000\213\'a',
	STMSWord2011MtEnEncodingMacCroatia = '\000\213\'b',
	STMSWord2011MtEnEncodingEBCDICUSCanada = '\000\213\000%',
	STMSWord2011MtEnEncodingEBCDICInternational = '\000\213\001\364',
	STMSWord2011MtEnEncodingEBCDICMultilingualROECELatin2 = '\000\213\003f',
	STMSWord2011MtEnEncodingEBCDICGreekModern = '\000\213\003k',
	STMSWord2011MtEnEncodingEBCDICTurkishLatin5 = '\000\213\004\002',
	STMSWord2011MtEnEncodingEBCDICGermany = '\000\213O1',
	STMSWord2011MtEnEncodingEBCDICDenmarkNorway = '\000\213O5',
	STMSWord2011MtEnEncodingEBCDICFinlandSweden = '\000\213O6',
	STMSWord2011MtEnEncodingEBCDICItaly = '\000\213O8',
	STMSWord2011MtEnEncodingEBCDICLatinAmericaSpain = '\000\213O<',
	STMSWord2011MtEnEncodingEBCDICUnitedKingdom = '\000\213O=',
	STMSWord2011MtEnEncodingEBCDICJapaneseKatakanaExtended = '\000\213OB',
	STMSWord2011MtEnEncodingEBCDICFrance = '\000\213OI',
	STMSWord2011MtEnEncodingEBCDICArabic = '\000\213O\304',
	STMSWord2011MtEnEncodingEBCDICGreek = '\000\213O\307',
	STMSWord2011MtEnEncodingEBCDICHebrew = '\000\213O\310',
	STMSWord2011MtEnEncodingEBCDICKoreanExtended = '\000\213Qa',
	STMSWord2011MtEnEncodingEBCDICThai = '\000\213Qf',
	STMSWord2011MtEnEncodingEBCDICIcelandic = '\000\213Q\207',
	STMSWord2011MtEnEncodingEBCDICTurkish = '\000\213Q\251',
	STMSWord2011MtEnEncodingEBCDICRussian = '\000\213Q\220',
	STMSWord2011MtEnEncodingEBCDICSerbianBulgarian = '\000\213R!',
	STMSWord2011MtEnEncodingEBCDICJapaneseKatakanaExtendedAndJapanese = '\000\213\306\362',
	STMSWord2011MtEnEncodingEBCDICUSCanadaAndJapanese = '\000\213\306\363',
	STMSWord2011MtEnEncodingEBCDICExtendedAndKorean = '\000\213\306\365',
	STMSWord2011MtEnEncodingEBCDICSimplifiedChineseExtendedAndSimplifiedChinese = '\000\213\306\367',
	STMSWord2011MtEnEncodingEBCDICUSCanadaAndTraditionalChinese = '\000\213\306\371',
	STMSWord2011MtEnEncodingEBCDICJapaneseLatinExtendedAndJapanese = '\000\213\306\373',
	STMSWord2011MtEnEncodingOEMUnitedStates = '\000\213\001\265',
	STMSWord2011MtEnEncodingOEMGreek = '\000\213\002\341',
	STMSWord2011MtEnEncodingOEMBaltic = '\000\213\003\007',
	STMSWord2011MtEnEncodingOEMMultilingualLatinI = '\000\213\003R',
	STMSWord2011MtEnEncodingOEMMultilingualLatinII = '\000\213\003T',
	STMSWord2011MtEnEncodingOEMCyrillic = '\000\213\003W',
	STMSWord2011MtEnEncodingOEMTurkish = '\000\213\003Y',
	STMSWord2011MtEnEncodingOEMPortuguese = '\000\213\003\\',
	STMSWord2011MtEnEncodingOEMIcelandic = '\000\213\003]',
	STMSWord2011MtEnEncodingOEMHebrew = '\000\213\003^',
	STMSWord2011MtEnEncodingOEMCanadianFrench = '\000\213\003_',
	STMSWord2011MtEnEncodingOEMArabic = '\000\213\003`',
	STMSWord2011MtEnEncodingOEMNordic = '\000\213\003a',
	STMSWord2011MtEnEncodingOEMCyrillicII = '\000\213\003b',
	STMSWord2011MtEnEncodingOEMModernGreek = '\000\213\003e',
	STMSWord2011MtEnEncodingEUCJapanese = '\000\213\312\334',
	STMSWord2011MtEnEncodingEUCChineseSimplifiedChinese = '\000\213\312\340',
	STMSWord2011MtEnEncodingEUCKorean = '\000\213\312\355',
	STMSWord2011MtEnEncodingEUCTaiwaneseTraditionalChinese = '\000\213\312\356',
	STMSWord2011MtEnEncodingDevanagari = '\000\213\336\252',
	STMSWord2011MtEnEncodingBengali = '\000\213\336\253',
	STMSWord2011MtEnEncodingTamil = '\000\213\336\254',
	STMSWord2011MtEnEncodingTelugu = '\000\213\336\255',
	STMSWord2011MtEnEncodingAssamese = '\000\213\336\256',
	STMSWord2011MtEnEncodingOriya = '\000\213\336\257',
	STMSWord2011MtEnEncodingKannada = '\000\213\336\260',
	STMSWord2011MtEnEncodingMalayalam = '\000\213\336\261',
	STMSWord2011MtEnEncodingGujarati = '\000\213\336\262',
	STMSWord2011MtEnEncodingPunjabi = '\000\213\336\263',
	STMSWord2011MtEnEncodingArabicASMO = '\000\213\002\304',
	STMSWord2011MtEnEncodingArabicTransparentASMO = '\000\213\002\320',
	STMSWord2011MtEnEncodingKoreanJohab = '\000\213\005Q',
	STMSWord2011MtEnEncodingTaiwanCNS = '\000\213N ',
	STMSWord2011MtEnEncodingTaiwanTCA = '\000\213N!',
	STMSWord2011MtEnEncodingTaiwanEten = '\000\213N\"',
	STMSWord2011MtEnEncodingTaiwanIBM5550 = '\000\213N#',
	STMSWord2011MtEnEncodingTaiwanTeletext = '\000\213N$',
	STMSWord2011MtEnEncodingTaiwanWang = '\000\213N%',
	STMSWord2011MtEnEncodingIA5IRV = '\000\213N\211',
	STMSWord2011MtEnEncodingIA5German = '\000\213N\212',
	STMSWord2011MtEnEncodingIA5Swedish = '\000\213N\213',
	STMSWord2011MtEnEncodingIA5Norwegian = '\000\213N\214',
	STMSWord2011MtEnEncodingUSASCII = '\000\213N\237',
	STMSWord2011MtEnEncodingT61 = '\000\213O%',
	STMSWord2011MtEnEncodingISO6937NonspacingAccent = '\000\213O-',
	STMSWord2011MtEnEncodingKOI8R = '\000\213Q\202',
	STMSWord2011MtEnEncodingExtAlphaLowercase = '\000\213R#',
	STMSWord2011MtEnEncodingKOI8U = '\000\213Uj',
	STMSWord2011MtEnEncodingEuropa3 = '\000\213qI',
	STMSWord2011MtEnEncodingHZGBSimplifiedChinese = '\000\213\316\310',
	STMSWord2011MtEnEncodingUTF7 = '\000\213\375\350',
	STMSWord2011MtEnEncodingUTF8 = '\000\213\375\351'
};
typedef enum STMSWord2011MtEn STMSWord2011MtEn;

enum STMSWord20114000 {
	STMSWord20114000CommandBar = 'msCB',
	STMSWord20114000CommandBarControl = 'mCBC'
};
typedef enum STMSWord20114000 STMSWord20114000;

enum STMSWord2011EMvS {
	STMSWord2011EMvSTowardsTheEnd = '\002\266\000\000',
	STMSWord2011EMvSTowardsTheStart = '\002\266\000\001',
	STMSWord2011EMvSTowardsTheLeft = '\002\266\000\002',
	STMSWord2011EMvSTowardsTheRight = '\002\266\000\003',
	STMSWord2011EMvSTowardsTheTop = '\002\266\000\004',
	STMSWord2011EMvSTowardsTheBottom = '\002\266\000\005'
};
typedef enum STMSWord2011EMvS STMSWord2011EMvS;

enum STMSWord2011EMUW {
	STMSWord2011EMUWTowardsTheTail = '\002\267\000\000',
	STMSWord2011EMUWTowardsTheBeginning = '\002\267\000\001'
};
typedef enum STMSWord2011EMUW STMSWord2011EMUW;

enum STMSWord2011EiAb {
	STMSWord2011EiAbAbove = '\002\270\000\000',
	STMSWord2011EiAbBelow = '\002\270\000\001'
};
typedef enum STMSWord2011EiAb STMSWord2011EiAb;

enum STMSWord2011EiBa {
	STMSWord2011EiBaBeforeTheObject = '\002\271\000\000',
	STMSWord2011EiBaAfterTheObject = '\002\271\000\001'
};
typedef enum STMSWord2011EiBa STMSWord2011EiBa;

enum STMSWord2011EiRL {
	STMSWord2011EiRLInsertOnTheRight = '\002\273\000\000',
	STMSWord2011EiRLInsertOnTheLeft = '\002\273\000\001'
};
typedef enum STMSWord2011EiRL STMSWord2011EiRL;

enum STMSWord2011EIPt {
	STMSWord2011EIPtOffset = '\003\037\000\000',
	STMSWord2011EIPtLocationReference = '\003\037\000\001'
};
typedef enum STMSWord2011EIPt STMSWord2011EIPt;

enum STMSWord2011EFRt {
	STMSWord2011EFRtTextRange = '\003\036\000\000',
	STMSWord2011EFRtInsertionPoint = '\003\036\000\001'
};
typedef enum STMSWord2011EFRt STMSWord2011EFRt;

enum STMSWord2011E101 {
	STMSWord2011E101TypeNormalTemplate = '\001\365\000\000',
	STMSWord2011E101TypeGlobalTemplate = '\001\365\000\001',
	STMSWord2011E101TypeAttachedTemplate = '\001\365\000\002'
};
typedef enum STMSWord2011E101 STMSWord2011E101;

enum STMSWord2011E102 {
	STMSWord2011E102ContinueDisabled = '\001\366\000\000',
	STMSWord2011E102ResetList = '\001\366\000\001',
	STMSWord2011E102ContinueList = '\001\366\000\002'
};
typedef enum STMSWord2011E102 STMSWord2011E102;

enum STMSWord2011E103 {
	STMSWord2011E103IMEModeNoControl = '\001\367\000\000',
	STMSWord2011E103IMEModeOn = '\001\367\000\001',
	STMSWord2011E103IMEModeOff = '\001\367\000\002',
	STMSWord2011E103IMEModeHiragana = '\001\367\000\004',
	STMSWord2011E103IMEModeKatakana = '\001\367\000\005',
	STMSWord2011E103IMEModeKatakanaHalf = '\001\367\000\006',
	STMSWord2011E103IMEModeAlphaFull = '\001\367\000\007',
	STMSWord2011E103IMEModeAlpha = '\001\367\000\010',
	STMSWord2011E103IMEModeHangulFull = '\001\367\000\011',
	STMSWord2011E103IMEModeHangul = '\001\367\000\012'
};
typedef enum STMSWord2011E103 STMSWord2011E103;

enum STMSWord2011E104 {
	STMSWord2011E104BaselineAlignTop = '\001\370\000\000',
	STMSWord2011E104BaselineAlignCenter = '\001\370\000\001',
	STMSWord2011E104BaselineAlignBaseline = '\001\370\000\002',
	STMSWord2011E104BaselineAlignEastAsian50 = '\001\370\000\003',
	STMSWord2011E104BaselineAlignAuto = '\001\370\000\004'
};
typedef enum STMSWord2011E104 STMSWord2011E104;

enum STMSWord2011E105 {
	STMSWord2011E105IndexFilterNone = '\001\371\000\000',
	STMSWord2011E105IndexFilterAiueo = '\001\371\000\001',
	STMSWord2011E105IndexFilterAkasatana = '\001\371\000\002',
	STMSWord2011E105IndexFilterChosung = '\001\371\000\003',
	STMSWord2011E105IndexFilterLow = '\001\371\000\004',
	STMSWord2011E105IndexFilterMedium = '\001\371\000\005',
	STMSWord2011E105IndexFilterFull = '\001\371\000\006'
};
typedef enum STMSWord2011E105 STMSWord2011E105;

enum STMSWord2011E106 {
	STMSWord2011E106IndexSortByStroke = '\001\372\000\000',
	STMSWord2011E106IndexSortBySyllable = '\001\372\000\001'
};
typedef enum STMSWord2011E106 STMSWord2011E106;

enum STMSWord2011E107 {
	STMSWord2011E107JustificationModeExpand = '\001\373\000\000',
	STMSWord2011E107JustificationModeCompress = '\001\373\000\001',
	STMSWord2011E107JustificationModeCompressKana = '\001\373\000\002'
};
typedef enum STMSWord2011E107 STMSWord2011E107;

enum STMSWord2011E108 {
	STMSWord2011E108EastAsianLineBreakLevelNormal = '\001\374\000\000',
	STMSWord2011E108EastAsianLineBreakLevelStrict = '\001\374\000\001',
	STMSWord2011E108EastAsianLineBreakLevelCustom = '\001\374\000\002'
};
typedef enum STMSWord2011E108 STMSWord2011E108;

enum STMSWord2011E109 {
	STMSWord2011E109HangulToHanja = '\001\375\000\000',
	STMSWord2011E109HanjaToHangul = '\001\375\000\001'
};
typedef enum STMSWord2011E109 STMSWord2011E109;

enum STMSWord2011E110 {
	STMSWord2011E110Auto = '\001\376\000\000',
	STMSWord2011E110Black = '\001\376\000\001',
	STMSWord2011E110Blue = '\001\376\000\002',
	STMSWord2011E110Turquoise = '\001\376\000\003',
	STMSWord2011E110BrightGreen = '\001\376\000\004',
	STMSWord2011E110Pink = '\001\376\000\005',
	STMSWord2011E110Red = '\001\376\000\006',
	STMSWord2011E110Yellow = '\001\376\000\007',
	STMSWord2011E110White = '\001\376\000\010',
	STMSWord2011E110DarkBlue = '\001\376\000\011',
	STMSWord2011E110Teal = '\001\376\000\012',
	STMSWord2011E110Green = '\001\376\000\013',
	STMSWord2011E110Violet = '\001\376\000\014',
	STMSWord2011E110DarkRed = '\001\376\000\015',
	STMSWord2011E110DarkYellow = '\001\376\000\016',
	STMSWord2011E110Gray50 = '\001\376\000\017',
	STMSWord2011E110Gray25 = '\001\376\000\020',
	STMSWord2011E110ByAuthor = '\001\375\377\377',
	STMSWord2011E110NoHighlight = '\001\376\000\000'
};
typedef enum STMSWord2011E110 STMSWord2011E110;

enum STMSWord2011E111 {
	STMSWord2011E111ColorAutomatic = '\377\000\000\000',
	STMSWord2011E111ColorBlack = '\000\000\000\000',
	STMSWord2011E111ColorBlue = '\000\377\000\000',
	STMSWord2011E111ColorPink = '\000\377\000\377',
	STMSWord2011E111ColorRed = '\000\000\000\377',
	STMSWord2011E111ColorYellow = '\000\000\377\377',
	STMSWord2011E111ColorTurquoise = '\000\377\377\000',
	STMSWord2011E111ColorBrightGreen = '\000\000\377\000',
	STMSWord2011E111ColorGreen = '\000\000\200\000',
	STMSWord2011E111ColorWhite = '\000\377\377\377',
	STMSWord2011E111ColorDarkBlue = '\000\200\000\000',
	STMSWord2011E111ColorTeal = '\000\200\200\000',
	STMSWord2011E111ColorViolet = '\000\200\000\200',
	STMSWord2011E111ColorDarkGreen = '\000\0003\000',
	STMSWord2011E111ColorDarkRed = '\000\000\000\200',
	STMSWord2011E111ColorDarkYellow = '\000\000\200\200',
	STMSWord2011E111ColorBrown = '\000\0003\231',
	STMSWord2011E111ColorOliveGreen = '\000\00033',
	STMSWord2011E111ColorDarkTeal = '\000f3\000',
	STMSWord2011E111ColorIndigo = '\000\23133',
	STMSWord2011E111ColorOrange = '\000\000f\377',
	STMSWord2011E111ColorBlueGray = '\000\231ff',
	STMSWord2011E111ColorLightOrange = '\000\000\231\377',
	STMSWord2011E111ColorLime = '\000\000\314\231',
	STMSWord2011E111ColorSeaGreen = '\000f\2313',
	STMSWord2011E111ColorAqua = '\000\314\3143',
	STMSWord2011E111ColorLightBlue = '\000\377f3',
	STMSWord2011E111ColorGold = '\000\000\314\377',
	STMSWord2011E111ColorSkyBlue = '\000\377\314\000',
	STMSWord2011E111ColorPlum = '\000f3\231',
	STMSWord2011E111ColorRose = '\000\314\231\377',
	STMSWord2011E111ColorTan = '\000\231\314\377',
	STMSWord2011E111ColorLightYellow = '\000\231\377\377',
	STMSWord2011E111ColorLightGreen = '\000\314\377\314',
	STMSWord2011E111ColorLightTurquoise = '\000\377\377\314',
	STMSWord2011E111ColorPaleBlue = '\000\377\314\231',
	STMSWord2011E111ColorLavender = '\000\377\231\314',
	STMSWord2011E111ColorGray05 = '\000\363\363\363',
	STMSWord2011E111ColorGray10 = '\000\346\346\346',
	STMSWord2011E111ColorGray125 = '\000\340\340\340',
	STMSWord2011E111ColorGray15 = '\000\331\331\331',
	STMSWord2011E111ColorGray20 = '\000\314\314\314',
	STMSWord2011E111ColorGray25 = '\000\300\300\300',
	STMSWord2011E111ColorGray30 = '\000\263\263\263',
	STMSWord2011E111ColorGray35 = '\000\246\246\246',
	STMSWord2011E111ColorGray375 = '\000\240\240\240',
	STMSWord2011E111ColorGray40 = '\000\231\231\231',
	STMSWord2011E111ColorGray45 = '\000\214\214\214',
	STMSWord2011E111ColorGray50 = '\000\200\200\200',
	STMSWord2011E111ColorGray55 = '\000sss',
	STMSWord2011E111ColorGray60 = '\000fff',
	STMSWord2011E111ColorGray625 = '\000```',
	STMSWord2011E111ColorGray65 = '\000YYY',
	STMSWord2011E111ColorGray70 = '\000LLL',
	STMSWord2011E111ColorGray75 = '\000@@@',
	STMSWord2011E111ColorGray80 = '\000333',
	STMSWord2011E111ColorGray85 = '\000&&&',
	STMSWord2011E111ColorGray875 = '\000   ',
	STMSWord2011E111ColorGray90 = '\000\031\031\031',
	STMSWord2011E111ColorGray95 = '\000\014\014\014'
};
typedef enum STMSWord2011E111 STMSWord2011E111;

enum STMSWord2011E112 {
	STMSWord2011E112TextureNone = '\002\000\000\000',
	STMSWord2011E112Texture2Pt5Percent = '\002\000\000\031',
	STMSWord2011E112Texture5Percent = '\002\000\0002',
	STMSWord2011E112Texture7Pt5Percent = '\002\000\000K',
	STMSWord2011E112Texture10Percent = '\002\000\000d',
	STMSWord2011E112Texture12Pt5Percent = '\002\000\000}',
	STMSWord2011E112Texture15Percent = '\002\000\000\226',
	STMSWord2011E112Texture17Pt5Percent = '\002\000\000\257',
	STMSWord2011E112Texture20Percent = '\002\000\000\310',
	STMSWord2011E112Texture22Pt5Percent = '\002\000\000\341',
	STMSWord2011E112Texture25Percent = '\002\000\000\372',
	STMSWord2011E112Texture27Pt5Percent = '\002\000\001\023',
	STMSWord2011E112Texture30Percent = '\002\000\001,',
	STMSWord2011E112Texture32Pt5Percent = '\002\000\001E',
	STMSWord2011E112Texture35Percent = '\002\000\001^',
	STMSWord2011E112Texture37Pt5Percent = '\002\000\001w',
	STMSWord2011E112Texture40Percent = '\002\000\001\220',
	STMSWord2011E112Texture42Pt5Percent = '\002\000\001\251',
	STMSWord2011E112Texture45Percent = '\002\000\001\302',
	STMSWord2011E112Texture47Pt5Percent = '\002\000\001\333',
	STMSWord2011E112Texture50Percent = '\002\000\001\364',
	STMSWord2011E112Texture52Pt5Percent = '\002\000\002\015',
	STMSWord2011E112Texture55Percent = '\002\000\002&',
	STMSWord2011E112Texture57Pt5Percent = '\002\000\002\?',
	STMSWord2011E112Texture60Percent = '\002\000\002X',
	STMSWord2011E112Texture62Pt5Percent = '\002\000\002q',
	STMSWord2011E112Texture65Percent = '\002\000\002\212',
	STMSWord2011E112Texture67Pt5Percent = '\002\000\002\243',
	STMSWord2011E112Texture70Percent = '\002\000\002\274',
	STMSWord2011E112Texture72Pt5Percent = '\002\000\002\325',
	STMSWord2011E112Texture75Percent = '\002\000\002\356',
	STMSWord2011E112Texture77Pt5Percent = '\002\000\003\007',
	STMSWord2011E112Texture80Percent = '\002\000\003 ',
	STMSWord2011E112Texture82Pt5Percent = '\002\000\0039',
	STMSWord2011E112Texture85Percent = '\002\000\003R',
	STMSWord2011E112Texture87Pt5Percent = '\002\000\003k',
	STMSWord2011E112Texture90Percent = '\002\000\003\204',
	STMSWord2011E112Texture92Pt5Percent = '\002\000\003\235',
	STMSWord2011E112Texture95Percent = '\002\000\003\266',
	STMSWord2011E112Texture97Pt5Percent = '\002\000\003\317',
	STMSWord2011E112TextureSolid = '\002\000\003\350',
	STMSWord2011E112TextureDarkHorizontal = '\001\377\377\377',
	STMSWord2011E112TextureDarkVertical = '\001\377\377\376',
	STMSWord2011E112TextureDarkDiagonalDown = '\001\377\377\375',
	STMSWord2011E112TextureDarkDiagonalUp = '\001\377\377\374',
	STMSWord2011E112TextureDarkCross = '\001\377\377\373',
	STMSWord2011E112TextureDarkDiagonalCross = '\001\377\377\372',
	STMSWord2011E112TextureHorizontal = '\001\377\377\371',
	STMSWord2011E112TextureVertical = '\001\377\377\370',
	STMSWord2011E112TextureDiagonalDown = '\001\377\377\367',
	STMSWord2011E112TextureDiagonalUp = '\001\377\377\366',
	STMSWord2011E112TextureCross = '\001\377\377\365',
	STMSWord2011E112TextureDiagonalCross = '\001\377\377\364'
};
typedef enum STMSWord2011E112 STMSWord2011E112;

enum STMSWord2011E113 {
	STMSWord2011E113UnderlineNone = '\002\001\000\000',
	STMSWord2011E113UnderlineSingle = '\002\001\000\001',
	STMSWord2011E113UnderlineWords = '\002\001\000\002',
	STMSWord2011E113UnderlineDouble = '\002\001\000\003',
	STMSWord2011E113UnderlineDotted = '\002\001\000\004',
	STMSWord2011E113UnderlineThick = '\002\001\000\006',
	STMSWord2011E113UnderlineDash = '\002\001\000\007',
	STMSWord2011E113UnderlineDotDash = '\002\001\000\011',
	STMSWord2011E113UnderlineDotDotDash = '\002\001\000\012',
	STMSWord2011E113UnderlineWavy = '\002\001\000\013',
	STMSWord2011E113UnderlineWavyHeavy = '\002\001\000\033',
	STMSWord2011E113UnderlineDottedHeavy = '\002\001\000\024',
	STMSWord2011E113UnderlineDashHeavy = '\002\001\000\027',
	STMSWord2011E113UnderlineDotDashHeavy = '\002\001\000\031',
	STMSWord2011E113UnderlineDotDotDashHeavy = '\002\001\000\032',
	STMSWord2011E113UnderlineDashLong = '\002\001\000\'',
	STMSWord2011E113UnderlineDashLongHeavy = '\002\001\0007',
	STMSWord2011E113UnderlineWavyDouble = '\002\001\000+'
};
typedef enum STMSWord2011E113 STMSWord2011E113;

enum STMSWord2011E114 {
	STMSWord2011E114EmphasisMarkNone = '\002\002\000\000',
	STMSWord2011E114EmphasisMarkOverSolidCircle = '\002\002\000\001',
	STMSWord2011E114EmphasisMarkOverComma = '\002\002\000\002',
	STMSWord2011E114EmphasisMarkOverWhiteCircle = '\002\002\000\003',
	STMSWord2011E114EmphasisMarkUnderSolidCircle = '\002\002\000\004'
};
typedef enum STMSWord2011E114 STMSWord2011E114;

enum STMSWord2011E115 {
	STMSWord2011E115ListSeparator = '\002\003\000\021',
	STMSWord2011E115DecimalSeparator = '\002\003\000\022',
	STMSWord2011E115ThousandsSeparator = '\002\003\000\023',
	STMSWord2011E115CurrencyCode = '\002\003\000\024',
	STMSWord2011E115TwentyFourHourClock = '\002\003\000\025',
	STMSWord2011E115InternationalAm = '\002\003\000\026',
	STMSWord2011E115InternationalPm = '\002\003\000\027',
	STMSWord2011E115TimeSeparator = '\002\003\000\030',
	STMSWord2011E115DateSeparator = '\002\003\000\031',
	STMSWord2011E115ProductLanguageID = '\002\003\000\032'
};
typedef enum STMSWord2011E115 STMSWord2011E115;

enum STMSWord2011E116 {
	STMSWord2011E116AutoExec = '\002\004\000\000',
	STMSWord2011E116AutoNew = '\002\004\000\001',
	STMSWord2011E116AutoOpen = '\002\004\000\002',
	STMSWord2011E116AutoClose = '\002\004\000\003',
	STMSWord2011E116AutoExit = '\002\004\000\004'
};
typedef enum STMSWord2011E116 STMSWord2011E116;

enum STMSWord2011E117 {
	STMSWord2011E117CaptionPositionAbove = '\002\005\000\000',
	STMSWord2011E117CaptionPositionBelow = '\002\005\000\001'
};
typedef enum STMSWord2011E117 STMSWord2011E117;

enum STMSWord2011E118 {
	STMSWord2011E118Us = '\002\006\000\001',
	STMSWord2011E118Canada = '\002\006\000\002',
	STMSWord2011E118LatinAmerica = '\002\006\000\003',
	STMSWord2011E118Netherlands = '\002\006\000\037',
	STMSWord2011E118France = '\002\006\000!',
	STMSWord2011E118Spain = '\002\006\000\"',
	STMSWord2011E118Italy = '\002\006\000\'',
	STMSWord2011E118Uk = '\002\006\000,',
	STMSWord2011E118Denmark = '\002\006\000-',
	STMSWord2011E118Sweden = '\002\006\000.',
	STMSWord2011E118Norway = '\002\006\000/',
	STMSWord2011E118Germany = '\002\006\0001',
	STMSWord2011E118Peru = '\002\006\0003',
	STMSWord2011E118Mexico = '\002\006\0004',
	STMSWord2011E118Argentina = '\002\006\0006',
	STMSWord2011E118Brazil = '\002\006\0007',
	STMSWord2011E118Chile = '\002\006\0008',
	STMSWord2011E118Venezuela = '\002\006\000:',
	STMSWord2011E118Japan = '\002\006\000Q',
	STMSWord2011E118Taiwan = '\002\006\003v',
	STMSWord2011E118China = '\002\006\000V',
	STMSWord2011E118Korea = '\002\006\000R',
	STMSWord2011E118Finland = '\002\006\001f',
	STMSWord2011E118Iceland = '\002\006\001b'
};
typedef enum STMSWord2011E118 STMSWord2011E118;

enum STMSWord2011E119 {
	STMSWord2011E119HeadingSeparatorNone = '\002\007\000\000',
	STMSWord2011E119HeadingSeparatorBlankLine = '\002\007\000\001',
	STMSWord2011E119HeadingSeparatorLetter = '\002\007\000\002',
	STMSWord2011E119HeadingSeparatorLetterLow = '\002\007\000\003',
	STMSWord2011E119HeadingSeparatorLetterFull = '\002\007\000\004'
};
typedef enum STMSWord2011E119 STMSWord2011E119;

enum STMSWord2011E120 {
	STMSWord2011E120SeparatorHyphen = '\002\010\000\000',
	STMSWord2011E120SeparatorPeriod = '\002\010\000\001',
	STMSWord2011E120SeparatorColon = '\002\010\000\002',
	STMSWord2011E120SeparatorEmDash = '\002\010\000\003',
	STMSWord2011E120SeparatorEnDash = '\002\010\000\004'
};
typedef enum STMSWord2011E120 STMSWord2011E120;

enum STMSWord2011E121 {
	STMSWord2011E121AlignPageNumberLeft = '\002\011\000\000',
	STMSWord2011E121AlignPageNumberCenter = '\002\011\000\001',
	STMSWord2011E121AlignPageNumberRight = '\002\011\000\002',
	STMSWord2011E121AlignPageNumberInside = '\002\011\000\003',
	STMSWord2011E121AlignPageNumberOutside = '\002\011\000\004'
};
typedef enum STMSWord2011E121 STMSWord2011E121;

enum STMSWord2011E122 {
	STMSWord2011E122BorderTop = '\002\011\377\377',
	STMSWord2011E122BorderLeft = '\002\011\377\376',
	STMSWord2011E122BorderBottom = '\002\011\377\375',
	STMSWord2011E122BorderRight = '\002\011\377\374',
	STMSWord2011E122BorderHorizontal = '\002\011\377\373',
	STMSWord2011E122BorderVertical = '\002\011\377\372',
	STMSWord2011E122BorderDiagonalDown = '\002\011\377\371',
	STMSWord2011E122BorderDiagonalUp = '\002\011\377\370'
};
typedef enum STMSWord2011E122 STMSWord2011E122;

enum STMSWord2011E123 {
	STMSWord2011E123FrameTop = '\001\373\275\301',
	STMSWord2011E123FrameLeft = '\001\373\275\302',
	STMSWord2011E123FrameBottom = '\001\373\275\303',
	STMSWord2011E123FrameRight = '\001\373\275\304',
	STMSWord2011E123FrameCenter = '\001\373\275\305',
	STMSWord2011E123FrameInside = '\001\373\275\306',
	STMSWord2011E123FrameOutside = '\001\373\275\307'
};
typedef enum STMSWord2011E123 STMSWord2011E123;

enum STMSWord2011E124 {
	STMSWord2011E124AnimationNone = '\002\014\000\000',
	STMSWord2011E124AnimationLasVegasLights = '\002\014\000\001',
	STMSWord2011E124AnimationBlinkingBackground = '\002\014\000\002',
	STMSWord2011E124AnimationSparkleText = '\002\014\000\003',
	STMSWord2011E124AnimationMarchingBlackAnts = '\002\014\000\004',
	STMSWord2011E124AnimationMarchingRedAnts = '\002\014\000\005',
	STMSWord2011E124AnimationShimmer = '\002\014\000\006'
};
typedef enum STMSWord2011E124 STMSWord2011E124;

enum STMSWord2011E125 {
	STMSWord2011E125NextCase = '\002\014\377\377',
	STMSWord2011E125LowerCase = '\002\015\000\000',
	STMSWord2011E125UpperCase = '\002\015\000\001',
	STMSWord2011E125TitleWord = '\002\015\000\002',
	STMSWord2011E125TitleSentence = '\002\015\000\004',
	STMSWord2011E125ToggleCase = '\002\015\000\005',
	STMSWord2011E125CaseHalfWidth = '\002\015\000\006',
	STMSWord2011E125CaseFullWidth = '\002\015\000\007',
	STMSWord2011E125CaseKatakana = '\002\015\000\010',
	STMSWord2011E125CaseHiragana = '\002\015\000\011'
};
typedef enum STMSWord2011E125 STMSWord2011E125;

enum STMSWord2011E127 {
	STMSWord2011E12710Sentences = '\002\016\377\376',
	STMSWord2011E12720Sentences = '\002\016\377\375',
	STMSWord2011E127100Words = '\002\016\377\374',
	STMSWord2011E127500Words = '\002\016\377\373',
	STMSWord2011E12710Percent = '\002\016\377\372',
	STMSWord2011E12725Percent = '\002\016\377\371',
	STMSWord2011E12750Percent = '\002\016\377\370',
	STMSWord2011E12775Percent = '\002\016\377\367'
};
typedef enum STMSWord2011E127 STMSWord2011E127;

enum STMSWord2011E128 {
	STMSWord2011E128StyleTypeParagraph = '\002\020\000\001',
	STMSWord2011E128StyleTypeCharacter = '\002\020\000\002',
	STMSWord2011E128StyleTypeTable = '\002\020\000\003',
	STMSWord2011E128StyleTypeList = '\002\020\000\004'
};
typedef enum STMSWord2011E128 STMSWord2011E128;

enum STMSWord2011E129 {
	STMSWord2011E129ACharacterItem = '\002\021\000\001',
	STMSWord2011E129AWordItem = '\002\021\000\002',
	STMSWord2011E129ASentenceItem = '\002\021\000\003',
	STMSWord2011E129AParagraphItem = '\002\021\000\004',
	STMSWord2011E129ALineItem = '\002\021\000\005',
	STMSWord2011E129AStoryItem = '\002\021\000\006',
	STMSWord2011E129AScreen = '\002\021\000\007',
	STMSWord2011E129ASection = '\002\021\000\010',
	STMSWord2011E129AColumn = '\002\021\000\011',
	STMSWord2011E129ARow = '\002\021\000\012',
	STMSWord2011E129AWindow = '\002\021\000\013',
	STMSWord2011E129ACell = '\002\021\000\014',
	STMSWord2011E129ACharacterFormatting = '\002\021\000\015',
	STMSWord2011E129AParagraphFormatting = '\002\021\000\016',
	STMSWord2011E129ATable = '\002\021\000\017',
	STMSWord2011E129AnItemUnit = '\002\021\000\020'
};
typedef enum STMSWord2011E129 STMSWord2011E129;

enum STMSWord2011E130 {
	STMSWord2011E130GotoABookmarkItem = '\002\021\377\377',
	STMSWord2011E130GotoASectionItem = '\002\022\000\000',
	STMSWord2011E130GotoAPageItem = '\002\022\000\001',
	STMSWord2011E130GotoATableItem = '\002\022\000\002',
	STMSWord2011E130GotoALineItem = '\002\022\000\003',
	STMSWord2011E130GotoAFootnoteItem = '\002\022\000\004',
	STMSWord2011E130GotoAnEndnoteItem = '\002\022\000\005',
	STMSWord2011E130GotoACommentItem = '\002\022\000\006',
	STMSWord2011E130GotoAFieldItem = '\002\022\000\007',
	STMSWord2011E130GotoAGraphic = '\002\022\000\010',
	STMSWord2011E130GotoAnObjectItem = '\002\022\000\011',
	STMSWord2011E130GotoAnEquation = '\002\022\000\012',
	STMSWord2011E130GotoAHeadingItem = '\002\022\000\013',
	STMSWord2011E130GotoAPercent = '\002\022\000\014',
	STMSWord2011E130GotoASpellingError = '\002\022\000\015',
	STMSWord2011E130GotoAGrammaticalError = '\002\022\000\016',
	STMSWord2011E130GotoAProofreadingError = '\002\022\000\017'
};
typedef enum STMSWord2011E130 STMSWord2011E130;

enum STMSWord2011E131 {
	STMSWord2011E131TheFirstItem = '\002\023\000\001',
	STMSWord2011E131TheLastItem = '\002\022\377\377',
	STMSWord2011E131TheNextItem = '\002\023\000\002',
	STMSWord2011E131Relative = '\002\023\000\002',
	STMSWord2011E131ThePreviousItem = '\002\023\000\003',
	STMSWord2011E131Absolute = '\002\023\000\001'
};
typedef enum STMSWord2011E131 STMSWord2011E131;

enum STMSWord2011E132 {
	STMSWord2011E132CollapseStart = '\002\024\000\001',
	STMSWord2011E132CollapseEnd = '\002\024\000\000'
};
typedef enum STMSWord2011E132 STMSWord2011E132;

enum STMSWord2011E133 {
	STMSWord2011E133RowHeightAuto = '\002\025\000\000',
	STMSWord2011E133RowHeightAtLeast = '\002\025\000\001',
	STMSWord2011E133RowHeightExactly = '\002\025\000\002'
};
typedef enum STMSWord2011E133 STMSWord2011E133;

enum STMSWord2011E134 {
	STMSWord2011E134FrameAuto = '\002\026\000\000',
	STMSWord2011E134FrameAtLeast = '\002\026\000\001',
	STMSWord2011E134FrameExact = '\002\026\000\002'
};
typedef enum STMSWord2011E134 STMSWord2011E134;

enum STMSWord2011E135 {
	STMSWord2011E135InsertCellsShiftRight = '\002\027\000\000',
	STMSWord2011E135InsertCellsShiftDown = '\002\027\000\001',
	STMSWord2011E135InsertCellsEntireRow = '\002\027\000\002',
	STMSWord2011E135InsertCellsEntireColumn = '\002\027\000\003'
};
typedef enum STMSWord2011E135 STMSWord2011E135;

enum STMSWord2011E136 {
	STMSWord2011E136DeleteCellsShiftLeft = '\002\030\000\000',
	STMSWord2011E136DeleteCellsShiftUp = '\002\030\000\001',
	STMSWord2011E136DeleteCellsEntireRow = '\002\030\000\002',
	STMSWord2011E136DeleteCellsEntireColumn = '\002\030\000\003'
};
typedef enum STMSWord2011E136 STMSWord2011E136;

enum STMSWord2011E137 {
	STMSWord2011E137ListApplyToWholeList = '\002\031\000\000',
	STMSWord2011E137ListApplyToThisPointForward = '\002\031\000\001',
	STMSWord2011E137ListApplyToSelection = '\002\031\000\002'
};
typedef enum STMSWord2011E137 STMSWord2011E137;

enum STMSWord2011E138 {
	STMSWord2011E138AlertsNone = '\002\032\000\000',
	STMSWord2011E138AlertsMessageBox = '\002\031\377\376',
	STMSWord2011E138AlertsAll = '\002\031\377\377'
};
typedef enum STMSWord2011E138 STMSWord2011E138;

enum STMSWord2011E139 {
	STMSWord2011E139CursorWait = '\002\033\000\000',
	STMSWord2011E139CursorIbeam = '\002\033\000\001',
	STMSWord2011E139CursorNormal = '\002\033\000\002',
	STMSWord2011E139CursorNorthwestArrow = '\002\033\000\003'
};
typedef enum STMSWord2011E139 STMSWord2011E139;

enum STMSWord2011E141 {
	STMSWord2011E141AdjustNone = '\002\035\000\000',
	STMSWord2011E141AdjustProportional = '\002\035\000\001',
	STMSWord2011E141AdjustFirstColumn = '\002\035\000\002',
	STMSWord2011E141AdjustSameWidth = '\002\035\000\003'
};
typedef enum STMSWord2011E141 STMSWord2011E141;

enum STMSWord2011E142 {
	STMSWord2011E142AlignParagraphLeft = '\002\036\000\000',
	STMSWord2011E142AlignParagraphCenter = '\002\036\000\001',
	STMSWord2011E142AlignParagraphRight = '\002\036\000\002',
	STMSWord2011E142AlignParagraphJustify = '\002\036\000\003',
	STMSWord2011E142AlignParagraphDistribute = '\002\036\000\004'
};
typedef enum STMSWord2011E142 STMSWord2011E142;

enum STMSWord2011E143 {
	STMSWord2011E143ListLevelAlignLeft = '\002\037\000\000',
	STMSWord2011E143ListLevelAlignCenter = '\002\037\000\001',
	STMSWord2011E143ListLevelAlignRight = '\002\037\000\002'
};
typedef enum STMSWord2011E143 STMSWord2011E143;

enum STMSWord2011E144 {
	STMSWord2011E144AlignRowLeft = '\002 \000\000',
	STMSWord2011E144AlignRowCenter = '\002 \000\001',
	STMSWord2011E144AlignRowRight = '\002 \000\002'
};
typedef enum STMSWord2011E144 STMSWord2011E144;

enum STMSWord2011E145 {
	STMSWord2011E145AlignTabLeft = '\002!\000\000',
	STMSWord2011E145AlignTabCenter = '\002!\000\001',
	STMSWord2011E145AlignTabRight = '\002!\000\002',
	STMSWord2011E145AlignTabDecimal = '\002!\000\003',
	STMSWord2011E145AlignTabBar = '\002!\000\004',
	STMSWord2011E145AlignTabList = '\002!\000\006'
};
typedef enum STMSWord2011E145 STMSWord2011E145;

enum STMSWord2011E146 {
	STMSWord2011E146AlignVerticalTop = '\002\"\000\000',
	STMSWord2011E146AlignVerticalCenter = '\002\"\000\001',
	STMSWord2011E146AlignVerticalJustify = '\002\"\000\002',
	STMSWord2011E146AlignVerticalBottom = '\002\"\000\003'
};
typedef enum STMSWord2011E146 STMSWord2011E146;

enum STMSWord2011E147 {
	STMSWord2011E147CellAlignVerticalTop = '\002#\000\000',
	STMSWord2011E147CellAlignVerticalCenter = '\002#\000\001',
	STMSWord2011E147CellAlignVerticalBottom = '\002#\000\003'
};
typedef enum STMSWord2011E147 STMSWord2011E147;

enum STMSWord2011E148 {
	STMSWord2011E148RangeAnnotationAlignmentCenter = '\002$\000\000',
	STMSWord2011E148ZeroOneZero = '\002$\000\001',
	STMSWord2011E148OneTwoOne = '\002$\000\002',
	STMSWord2011E148RangeAnnotationAlignmentLeft = '\002$\000\003',
	STMSWord2011E148RangeAnnotationAlignmentRight = '\002$\000\004'
};
typedef enum STMSWord2011E148 STMSWord2011E148;

enum STMSWord2011E149 {
	STMSWord2011E149TrailingTab = '\002%\000\000',
	STMSWord2011E149TrailingSpace = '\002%\000\001',
	STMSWord2011E149TrailingNone = '\002%\000\002'
};
typedef enum STMSWord2011E149 STMSWord2011E149;

enum STMSWord2011E150 {
	STMSWord2011E150BulletGallery = '\002&\000\001',
	STMSWord2011E150NumberGallery = '\002&\000\002',
	STMSWord2011E150OutlineNumberGallery = '\002&\000\003'
};
typedef enum STMSWord2011E150 STMSWord2011E150;

enum STMSWord2011E151 {
	STMSWord2011E151ListNumberStyleArabic = '\002\'\000\000',
	STMSWord2011E151ListNumberStyleUppercaseRoman = '\002\'\000\001',
	STMSWord2011E151ListNumberStyleLowercaseRoman = '\002\'\000\002',
	STMSWord2011E151ListNumberStyleUppercaseLetter = '\002\'\000\003',
	STMSWord2011E151ListNumberStyleLowercaseLetter = '\002\'\000\004',
	STMSWord2011E151ListNumberStyleOrdinal = '\002\'\000\005',
	STMSWord2011E151ListNumberStyleCardinalText = '\002\'\000\006',
	STMSWord2011E151ListNumberStyleOrdinalText = '\002\'\000\007',
	STMSWord2011E151ListNumberStyleKanji = '\002\'\000\012',
	STMSWord2011E151ListNumberStyleKanjiDigit = '\002\'\000\013',
	STMSWord2011E151ListNumberStyleAiueoHalfWidth = '\002\'\000\014',
	STMSWord2011E151ListNumberStyleIrohaHalfWidth = '\002\'\000\015',
	STMSWord2011E151ListNumberStyleArabicFullWidth = '\002\'\000\016',
	STMSWord2011E151ListNumberStyleKanjiTraditional = '\002\'\000\020',
	STMSWord2011E151ListNumberStyleKanjiTraditional2 = '\002\'\000\021',
	STMSWord2011E151ListNumberStyleNumberInCircle = '\002\'\000\022',
	STMSWord2011E151ListNumberStyleAiueo = '\002\'\000\024',
	STMSWord2011E151ListNumberStyleIroha = '\002\'\000\025',
	STMSWord2011E151ListNumberStyleArabicLz = '\002\'\000\026',
	STMSWord2011E151ListNumberStyleBullet = '\002\'\000\027',
	STMSWord2011E151ListNumberStyleGanada = '\002\'\000\030',
	STMSWord2011E151ListNumberStyleChosung = '\002\'\000\031',
	STMSWord2011E151ListNumberStyleGbnum1 = '\002\'\000\032',
	STMSWord2011E151ListNumberStyleGbnum2 = '\002\'\000\033',
	STMSWord2011E151ListNumberStyleGbnum3 = '\002\'\000\034',
	STMSWord2011E151ListNumberStyleGbnum4 = '\002\'\000\035',
	STMSWord2011E151ListNumberStyleZodiac1 = '\002\'\000\036',
	STMSWord2011E151ListNumberStyleZodiac2 = '\002\'\000\037',
	STMSWord2011E151ListNumberStyleZodiac3 = '\002\'\000 ',
	STMSWord2011E151ListNumberStyleTradChinNum1 = '\002\'\000!',
	STMSWord2011E151ListNumberStyleTradChinNum2 = '\002\'\000\"',
	STMSWord2011E151ListNumberStyleTradChinNum3 = '\002\'\000#',
	STMSWord2011E151ListNumberStyleTradChinNum4 = '\002\'\000$',
	STMSWord2011E151ListNumberStyleSimpChinNum1 = '\002\'\000%',
	STMSWord2011E151ListNumberStyleSimpChinNum2 = '\002\'\000&',
	STMSWord2011E151ListNumberStyleSimpChinNum3 = '\002\'\000\'',
	STMSWord2011E151ListNumberStyleSimpChinNum4 = '\002\'\000(',
	STMSWord2011E151ListNumberStyleHanjaRead = '\002\'\000)',
	STMSWord2011E151ListNumberStyleHanjaReadDigit = '\002\'\000*',
	STMSWord2011E151ListNumberStyleHangul = '\002\'\000+',
	STMSWord2011E151ListNumberStyleHanja = '\002\'\000,',
	STMSWord2011E151ListNumberStylePictureBullet = '\002\'\000\371',
	STMSWord2011E151ListNumberStyleLegal = '\002\'\000\375',
	STMSWord2011E151ListNumberStyleLegalLz = '\002\'\000\376',
	STMSWord2011E151ListNumberStyleNone = '\002\'\000\377'
};
typedef enum STMSWord2011E151 STMSWord2011E151;

enum STMSWord2011E152 {
	STMSWord2011E152NoteNumberStyleArabic = '\002(\000\000',
	STMSWord2011E152NoteNumberStyleUppercaseRoman = '\002(\000\001',
	STMSWord2011E152NoteNumberStyleLowercaseRoman = '\002(\000\002',
	STMSWord2011E152NoteNumberStyleUppercaseLetter = '\002(\000\003',
	STMSWord2011E152NoteNumberStyleLowercaseLetter = '\002(\000\004',
	STMSWord2011E152NoteNumberStyleSymbol = '\002(\000\011',
	STMSWord2011E152NoteNumberStyleArabicFullWidth = '\002(\000\016',
	STMSWord2011E152NoteNumberStyleKanji = '\002(\000\012',
	STMSWord2011E152NoteNumberStyleKanjiDigit = '\002(\000\013',
	STMSWord2011E152NoteNumberStyleKanjiTraditional = '\002(\000\020',
	STMSWord2011E152NoteNumberStyleNumberInCircle = '\002(\000\022',
	STMSWord2011E152NoteNumberStyleHanjaRead = '\002(\000)',
	STMSWord2011E152NoteNumberStyleHanjaReadDigit = '\002(\000*',
	STMSWord2011E152NoteNumberStyleTradChinNum1 = '\002(\000!',
	STMSWord2011E152NoteNumberStyleTradChinNum2 = '\002(\000\"',
	STMSWord2011E152NoteNumberStyleSimpChinNum1 = '\002(\000%',
	STMSWord2011E152NoteNumberStyleSimpChinNum2 = '\002(\000&'
};
typedef enum STMSWord2011E152 STMSWord2011E152;

enum STMSWord2011E153 {
	STMSWord2011E153CaptionNumberStyleArabic = '\002)\000\000',
	STMSWord2011E153CaptionNumberStyleUppercaseRoman = '\002)\000\001',
	STMSWord2011E153CaptionNumberStyleLowercaseRoman = '\002)\000\002',
	STMSWord2011E153CaptionNumberStyleUppercaseLetter = '\002)\000\003',
	STMSWord2011E153CaptionNumberStyleLowercaseLetter = '\002)\000\004',
	STMSWord2011E153CaptionNumberStyleArabicFullWidth = '\002)\000\016',
	STMSWord2011E153CaptionNumberStyleKanji = '\002)\000\012',
	STMSWord2011E153CaptionNumberStyleKanjiDigit = '\002)\000\013',
	STMSWord2011E153CaptionNumberStyleKanjiTraditional = '\002)\000\020',
	STMSWord2011E153CaptionNumberStyleNumberInCircle = '\002)\000\022',
	STMSWord2011E153CaptionNumberStyleGanada = '\002)\000\030',
	STMSWord2011E153CaptionNumberStyleChosung = '\002)\000\031',
	STMSWord2011E153CaptionNumberStyleZodiac1 = '\002)\000\036',
	STMSWord2011E153CaptionNumberStyleZodiac2 = '\002)\000\037',
	STMSWord2011E153CaptionNumberStyleHanjaRead = '\002)\000)',
	STMSWord2011E153CaptionNumberStyleHanjaReadDigit = '\002)\000*',
	STMSWord2011E153CaptionNumberStyleTradChinNum2 = '\002)\000\"',
	STMSWord2011E153CaptionNumberStyleTradChinNum3 = '\002)\000#',
	STMSWord2011E153CaptionNumberStyleSimpChinNum2 = '\002)\000&',
	STMSWord2011E153CaptionNumberStyleSimpChinNum3 = '\002)\000\''
};
typedef enum STMSWord2011E153 STMSWord2011E153;

enum STMSWord2011E154 {
	STMSWord2011E154PageNumberStyleArabic = '\002*\000\000',
	STMSWord2011E154PageNumberStyleUppercaseRoman = '\002*\000\001',
	STMSWord2011E154PageNumberStyleLowercaseRoman = '\002*\000\002',
	STMSWord2011E154PageNumberStyleUppercaseLetter = '\002*\000\003',
	STMSWord2011E154PageNumberStyleLowercaseLetter = '\002*\000\004',
	STMSWord2011E154PageNumberStyleArabicFullWidth = '\002*\000\016',
	STMSWord2011E154PageNumberStyleKanji = '\002*\000\012',
	STMSWord2011E154PageNumberStyleKanjiDigit = '\002*\000\013',
	STMSWord2011E154PageNumberStyleKanjiTraditional = '\002*\000\020',
	STMSWord2011E154PageNumberStyleNumberInCircle = '\002*\000\022',
	STMSWord2011E154PageNumberStyleHanjaRead = '\002*\000)',
	STMSWord2011E154PageNumberStyleHanjaReadDigit = '\002*\000*',
	STMSWord2011E154PageNumberStyleTradChinNum1 = '\002*\000!',
	STMSWord2011E154PageNumberStyleTradChinNum2 = '\002*\000\"',
	STMSWord2011E154PageNumberStyleSimpChinNum1 = '\002*\000%',
	STMSWord2011E154PageNumberStyleSimpChinNum2 = '\002*\000&'
};
typedef enum STMSWord2011E154 STMSWord2011E154;

enum STMSWord2011E155 {
	STMSWord2011E155StatisticWords = '\002+\000\000',
	STMSWord2011E155StatisticLines = '\002+\000\001',
	STMSWord2011E155StatisticPages = '\002+\000\002',
	STMSWord2011E155StatisticCharacters = '\002+\000\003',
	STMSWord2011E155StatisticParagraphs = '\002+\000\004',
	STMSWord2011E155StatisticCharactersWithSpaces = '\002+\000\005',
	STMSWord2011E155StatisticEastAsianCharacters = '\002+\000\006'
};
typedef enum STMSWord2011E155 STMSWord2011E155;

enum STMSWord2011E156 {
	STMSWord2011E156PropertyTitle = '\002,\000\001',
	STMSWord2011E156PropertySubject = '\002,\000\002',
	STMSWord2011E156PropertyAuthor = '\002,\000\003',
	STMSWord2011E156PropertyKeywords = '\002,\000\004',
	STMSWord2011E156PropertyComments = '\002,\000\005',
	STMSWord2011E156PropertyTemplate = '\002,\000\006',
	STMSWord2011E156PropertyLastAuthor = '\002,\000\007',
	STMSWord2011E156PropertyRevision = '\002,\000\010',
	STMSWord2011E156PropertyAppName = '\002,\000\011',
	STMSWord2011E156PropertyTimeLastPrinted = '\002,\000\012',
	STMSWord2011E156PropertyTimeCreated = '\002,\000\013',
	STMSWord2011E156PropertyTimeLastSaved = '\002,\000\014',
	STMSWord2011E156PropertyVbatotalEdit = '\002,\000\015',
	STMSWord2011E156PropertyPages = '\002,\000\016',
	STMSWord2011E156PropertyWords = '\002,\000\017',
	STMSWord2011E156PropertyCharacters = '\002,\000\020',
	STMSWord2011E156PropertySecurity = '\002,\000\021',
	STMSWord2011E156PropertyCategory = '\002,\000\022',
	STMSWord2011E156PropertyFormat = '\002,\000\023',
	STMSWord2011E156PropertyManager = '\002,\000\024',
	STMSWord2011E156PropertyCompany = '\002,\000\025',
	STMSWord2011E156PropertyBytes = '\002,\000\026',
	STMSWord2011E156PropertyLines = '\002,\000\027',
	STMSWord2011E156PropertyParas = '\002,\000\030',
	STMSWord2011E156PropertySlides = '\002,\000\031',
	STMSWord2011E156PropertyNotes = '\002,\000\032',
	STMSWord2011E156PropertyHiddenSlides = '\002,\000\033',
	STMSWord2011E156PropertyMmclips = '\002,\000\034',
	STMSWord2011E156PropertyHyperlinkBase = '\002,\000\035',
	STMSWord2011E156PropertyCharsWspaces = '\002,\000\036'
};
typedef enum STMSWord2011E156 STMSWord2011E156;

enum STMSWord2011E157 {
	STMSWord2011E157LineSpaceSingle = '\002-\000\000',
	STMSWord2011E157LineSpace1Pt5 = '\002-\000\001',
	STMSWord2011E157LineSpaceDouble = '\002-\000\002',
	STMSWord2011E157LineSpaceAtLeast = '\002-\000\003',
	STMSWord2011E157LineSpaceExactly = '\002-\000\004',
	STMSWord2011E157LineSpaceMultiple = '\002-\000\005'
};
typedef enum STMSWord2011E157 STMSWord2011E157;

enum STMSWord2011E158 {
	STMSWord2011E158NumberParagraph = '\002.\000\001',
	STMSWord2011E158NumberListnum = '\002.\000\002',
	STMSWord2011E158NumberAllNumbers = '\002.\000\003'
};
typedef enum STMSWord2011E158 STMSWord2011E158;

enum STMSWord2011E159 {
	STMSWord2011E159ListNoNumbering = '\002/\000\000',
	STMSWord2011E159ListListnumOnly = '\002/\000\001',
	STMSWord2011E159ListBullet = '\002/\000\002',
	STMSWord2011E159ListSimpleNumbering = '\002/\000\003',
	STMSWord2011E159ListOutlineNumbering = '\002/\000\004',
	STMSWord2011E159ListMixedNumbering = '\002/\000\005',
	STMSWord2011E159ListPictureBullet = '\002/\000\006'
};
typedef enum STMSWord2011E159 STMSWord2011E159;

enum STMSWord2011E160 {
	STMSWord2011E160MainTextStory = '\0020\000\001',
	STMSWord2011E160FootnotesStory = '\0020\000\002',
	STMSWord2011E160EndnotesStory = '\0020\000\003',
	STMSWord2011E160CommentsStory = '\0020\000\004',
	STMSWord2011E160TextFrameStory = '\0020\000\005',
	STMSWord2011E160EvenPagesHeaderStory = '\0020\000\006',
	STMSWord2011E160PrimaryHeaderStory = '\0020\000\007',
	STMSWord2011E160EvenPagesFooterStory = '\0020\000\010',
	STMSWord2011E160PrimaryFooterStory = '\0020\000\011',
	STMSWord2011E160FirstPageHeaderStory = '\0020\000\012',
	STMSWord2011E160FirstPageFooterStory = '\0020\000\013',
	STMSWord2011E160FootnoteSeparatorStory = '\0020\000\014',
	STMSWord2011E160FootnoteContinuationSeparatorStory = '\0020\000\015',
	STMSWord2011E160FootnoteContinuationNoticeStory = '\0020\000\016',
	STMSWord2011E160EndnoteSeparatorStory = '\0020\000\017',
	STMSWord2011E160EndnoteContinuationSeparatorStory = '\0020\000\020',
	STMSWord2011E160EndnoteContinuationNoticeStory = '\0020\000\021'
};
typedef enum STMSWord2011E160 STMSWord2011E160;

enum STMSWord2011E161 {
	STMSWord2011E161FormatDocument97 = '\0021\000\000',
	STMSWord2011E161FormatTemplate97 = '\0021\000\001',
	STMSWord2011E161FormatText = '\0021\000\002',
	STMSWord2011E161FormatTextLineBreaks = '\0021\000\003',
	STMSWord2011E161FormatDostext = '\0021\000\004',
	STMSWord2011E161FormatDostextLineBreaks = '\0021\000\005',
	STMSWord2011E161FormatRtf = '\0021\000\006',
	STMSWord2011E161FormatUnicodeText = '\0021\000\007',
	STMSWord2011E161FormatHTML = '\0021\000\010',
	STMSWord2011E161FormatWebArchive = '\0021\000\011',
	STMSWord2011E161FormatStationery = '\0021\000\012',
	STMSWord2011E161FormatXml = '\0021\000\013',
	STMSWord2011E161FormatDocument = '\0021\000\014',
	STMSWord2011E161FormatDocumentME = '\0021\000\015',
	STMSWord2011E161FormatTemplate = '\0021\000\016',
	STMSWord2011E161FormatTemplateME = '\0021\000\017',
	STMSWord2011E161FormatPDF = '\0021\000\020',
	STMSWord2011E161FormatFlatDocument = '\0021\000\021',
	STMSWord2011E161FormatFlatDocumentME = '\0021\000\022',
	STMSWord2011E161FormatFlatTemplate = '\0021\000\023',
	STMSWord2011E161FormatFlatTemplateME = '\0021\000\024',
	STMSWord2011E161FormatCustomDictionary = '\0021\000\025',
	STMSWord2011E161FormatExcludeDictionary = '\0021\000\026',
	STMSWord2011E161FormatDocumentAuto = '\0021\015\014',
	STMSWord2011E161FormatTemplateAuto = '\0021\015\007'
};
typedef enum STMSWord2011E161 STMSWord2011E161;

enum STMSWord2011E162 {
	STMSWord2011E162OpenFormatAuto = '\0022\000\000',
	STMSWord2011E162OpenFormatDocument = '\0022\000\001',
	STMSWord2011E162OpenFormatTemplate = '\0022\000\002',
	STMSWord2011E162OpenFormatRtf = '\0022\000\003',
	STMSWord2011E162OpenFormatText = '\0022\000\004',
	STMSWord2011E162OpenFormatUnicodeText = '\0022\000\005',
	STMSWord2011E162OpenFormatEncodedText = '\0022\000\005',
	STMSWord2011E162OpenFormatMacReadable = '\0022\000\006',
	STMSWord2011E162OpenFormatWebPages = '\0022\000\007',
	STMSWord2011E162OpenFormatXml = '\0022\000\010',
	STMSWord2011E162OpenFormatDocument97 = '\0022\000\011',
	STMSWord2011E162OpenFormatTemplate97 = '\0022\000\012',
	STMSWord2011E162OpenFormatOffice = '\0022\000\013'
};
typedef enum STMSWord2011E162 STMSWord2011E162;

enum STMSWord2011E163 {
	STMSWord2011E163HeaderFooterPrimary = '\0023\000\001',
	STMSWord2011E163HeaderFooterFirstPage = '\0023\000\002',
	STMSWord2011E163HeaderFooterEvenPages = '\0023\000\003'
};
typedef enum STMSWord2011E163 STMSWord2011E163;

enum STMSWord2011E164 {
	STMSWord2011E164Toctemplate = '\0024\000\000',
	STMSWord2011E164Tocclassic = '\0024\000\001',
	STMSWord2011E164Tocdistinctive = '\0024\000\002',
	STMSWord2011E164Tocfancy = '\0024\000\003',
	STMSWord2011E164Tocmodern = '\0024\000\004',
	STMSWord2011E164Tocformal = '\0024\000\005',
	STMSWord2011E164Tocsimple = '\0024\000\006'
};
typedef enum STMSWord2011E164 STMSWord2011E164;

enum STMSWord2011E165 {
	STMSWord2011E165Toftemplate = '\0025\000\000',
	STMSWord2011E165Tofclassic = '\0025\000\001',
	STMSWord2011E165Tofdistinctive = '\0025\000\002',
	STMSWord2011E165Tofcentered = '\0025\000\003',
	STMSWord2011E165Tofformal = '\0025\000\004',
	STMSWord2011E165Tofsimple = '\0025\000\005'
};
typedef enum STMSWord2011E165 STMSWord2011E165;

enum STMSWord2011E166 {
	STMSWord2011E166Toatemplate = '\0026\000\000',
	STMSWord2011E166Toaclassic = '\0026\000\001',
	STMSWord2011E166Toadistinctive = '\0026\000\002',
	STMSWord2011E166Toaformal = '\0026\000\003',
	STMSWord2011E166Toasimple = '\0026\000\004'
};
typedef enum STMSWord2011E166 STMSWord2011E166;

enum STMSWord2011E167 {
	STMSWord2011E167LineStyleNone = '\0027\000\000',
	STMSWord2011E167LineStyleSingle = '\0027\000\001',
	STMSWord2011E167LineStyleDot = '\0027\000\002',
	STMSWord2011E167LineStyleDashSmallGap = '\0027\000\003',
	STMSWord2011E167LineStyleDashLargeGap = '\0027\000\004',
	STMSWord2011E167LineStyleDashDot = '\0027\000\005',
	STMSWord2011E167LineStyleDashDotDot = '\0027\000\006',
	STMSWord2011E167LineStyleDouble = '\0027\000\007',
	STMSWord2011E167LineStyleTriple = '\0027\000\010',
	STMSWord2011E167LineStyleThinThickSmallGap = '\0027\000\011',
	STMSWord2011E167LineStyleThickThinSmallGap = '\0027\000\012',
	STMSWord2011E167LineStyleThinThickThinSmallGap = '\0027\000\013',
	STMSWord2011E167LineStyleThinThickMedGap = '\0027\000\014',
	STMSWord2011E167LineStyleThickThinMedGap = '\0027\000\015',
	STMSWord2011E167LineStyleThinThickThinMedGap = '\0027\000\016',
	STMSWord2011E167LineStyleThinThickLargeGap = '\0027\000\017',
	STMSWord2011E167LineStyleThickThinLargeGap = '\0027\000\020',
	STMSWord2011E167LineStyleThinThickThinLargeGap = '\0027\000\021',
	STMSWord2011E167LineStyleSingleWavy = '\0027\000\022',
	STMSWord2011E167LineStyleDoubleWavy = '\0027\000\023',
	STMSWord2011E167LineStyleDashDotStroked = '\0027\000\024',
	STMSWord2011E167LineStyleEmboss_3D = '\0027\000\025',
	STMSWord2011E167LineStyleEngrave_3D = '\0027\000\026',
	STMSWord2011E167LineStyleOutset = '\0027\000\027',
	STMSWord2011E167LineStyleInset = '\0027\000\030'
};
typedef enum STMSWord2011E167 STMSWord2011E167;

enum STMSWord2011E168 {
	STMSWord2011E168LineWidth25Point = '\0028\000\002',
	STMSWord2011E168LineWidth50Point = '\0028\000\004',
	STMSWord2011E168LineWidth75Point = '\0028\000\006',
	STMSWord2011E168LineWidth100Point = '\0028\000\010',
	STMSWord2011E168LineWidth150Point = '\0028\000\014',
	STMSWord2011E168LineWidth225Point = '\0028\000\022',
	STMSWord2011E168LineWidth300Point = '\0028\000\030',
	STMSWord2011E168LineWidth450Point = '\0028\000$',
	STMSWord2011E168LineWidth600Point = '\0028\0000'
};
typedef enum STMSWord2011E168 STMSWord2011E168;

enum STMSWord2011E169 {
	STMSWord2011E169SectionBreakNextPage = '\0029\000\002',
	STMSWord2011E169SectionBreakContinuous = '\0029\000\003',
	STMSWord2011E169SectionBreakEvenPage = '\0029\000\004',
	STMSWord2011E169SectionBreakOddPage = '\0029\000\005',
	STMSWord2011E169LineBreak = '\0029\000\006',
	STMSWord2011E169PageBreak = '\0029\000\007',
	STMSWord2011E169ColumnBreak = '\0029\000\010'
};
typedef enum STMSWord2011E169 STMSWord2011E169;

enum STMSWord2011E313 {
	STMSWord2011E313ContinuedMaster = '\002\311\000\000'
};
typedef enum STMSWord2011E313 STMSWord2011E313;

enum STMSWord2011E170 {
	STMSWord2011E170TabLeaderSpaces = '\002:\000\000',
	STMSWord2011E170TabLeaderDots = '\002:\000\001',
	STMSWord2011E170TabLeaderDashes = '\002:\000\002',
	STMSWord2011E170TabLeaderLines = '\002:\000\003',
	STMSWord2011E170TabLeaderHeavy = '\002:\000\004',
	STMSWord2011E170TabLeaderMiddleDot = '\002:\000\005'
};
typedef enum STMSWord2011E170 STMSWord2011E170;

enum STMSWord2011E171 {
	STMSWord2011E171Inches = '\002;\000\000',
	STMSWord2011E171Centimeters = '\002;\000\001',
	STMSWord2011E171Millimeters = '\002;\000\002',
	STMSWord2011E171Points = '\002;\000\003',
	STMSWord2011E171Picas = '\002;\000\004'
};
typedef enum STMSWord2011E171 STMSWord2011E171;

enum STMSWord2011E172 {
	STMSWord2011E172DropNone = '\002<\000\000',
	STMSWord2011E172DropNormal = '\002<\000\001',
	STMSWord2011E172DropMargin = '\002<\000\002'
};
typedef enum STMSWord2011E172 STMSWord2011E172;

enum STMSWord2011E173 {
	STMSWord2011E173RestartContinuous = '\002=\000\000',
	STMSWord2011E173RestartSection = '\002=\000\001',
	STMSWord2011E173RestartPage = '\002=\000\002'
};
typedef enum STMSWord2011E173 STMSWord2011E173;

enum STMSWord2011E174 {
	STMSWord2011E174BottomOfPage = '\002>\000\000',
	STMSWord2011E174BeneathText = '\002>\000\001'
};
typedef enum STMSWord2011E174 STMSWord2011E174;

enum STMSWord2011E175 {
	STMSWord2011E175End_of_section = '\002\?\000\000',
	STMSWord2011E175End_of_document = '\002\?\000\001'
};
typedef enum STMSWord2011E175 STMSWord2011E175;

enum STMSWord2011E176 {
	STMSWord2011E176SortSeparateByTabs = '\002@\000\000',
	STMSWord2011E176SortSeparateByCommas = '\002@\000\001',
	STMSWord2011E176SortSeparateByDefaultTableSeparator = '\002@\000\002'
};
typedef enum STMSWord2011E176 STMSWord2011E176;

enum STMSWord2011E177 {
	STMSWord2011E177SeparateByParagraphs = '\002A\000\000',
	STMSWord2011E177SeparateByTabs = '\002A\000\001',
	STMSWord2011E177SeparateByCommas = '\002A\000\002',
	STMSWord2011E177SeparateByDefaultListSeparator = '\002A\000\003'
};
typedef enum STMSWord2011E177 STMSWord2011E177;

enum STMSWord2011E178 {
	STMSWord2011E178SortFieldAlphanumeric = '\002B\000\000',
	STMSWord2011E178SortFieldNumeric = '\002B\000\001',
	STMSWord2011E178SortFieldDate = '\002B\000\002',
	STMSWord2011E178SortFieldSyllable = '\002B\000\003',
	STMSWord2011E178SortFieldJapanJis = '\002B\000\004',
	STMSWord2011E178SortFieldStroke = '\002B\000\005',
	STMSWord2011E178SortFieldKoreaKs = '\002B\000\006'
};
typedef enum STMSWord2011E178 STMSWord2011E178;

enum STMSWord2011E179 {
	STMSWord2011E179SortOrderAscending = '\002C\000\000',
	STMSWord2011E179SortOrderDescending = '\002C\000\001'
};
typedef enum STMSWord2011E179 STMSWord2011E179;

enum STMSWord2011E180 {
	STMSWord2011E180TableFormatNone = '\002D\000\000',
	STMSWord2011E180TableFormatSimple1 = '\002D\000\001',
	STMSWord2011E180TableFormatSimple2 = '\002D\000\002',
	STMSWord2011E180TableFormatSimple3 = '\002D\000\003',
	STMSWord2011E180TableFormatClassic1 = '\002D\000\004',
	STMSWord2011E180TableFormatClassic2 = '\002D\000\005',
	STMSWord2011E180TableFormatClassic3 = '\002D\000\006',
	STMSWord2011E180TableFormatClassic4 = '\002D\000\007',
	STMSWord2011E180TableFormatColorful1 = '\002D\000\010',
	STMSWord2011E180TableFormatColorful2 = '\002D\000\011',
	STMSWord2011E180TableFormatColorful3 = '\002D\000\012',
	STMSWord2011E180TableFormatColumns1 = '\002D\000\013',
	STMSWord2011E180TableFormatColumns2 = '\002D\000\014',
	STMSWord2011E180TableFormatColumns3 = '\002D\000\015',
	STMSWord2011E180TableFormatColumns4 = '\002D\000\016',
	STMSWord2011E180TableFormatColumns5 = '\002D\000\017',
	STMSWord2011E180TableFormatGrid1 = '\002D\000\020',
	STMSWord2011E180TableFormatGrid2 = '\002D\000\021',
	STMSWord2011E180TableFormatGrid3 = '\002D\000\022',
	STMSWord2011E180TableFormatGrid4 = '\002D\000\023',
	STMSWord2011E180TableFormatGrid5 = '\002D\000\024',
	STMSWord2011E180TableFormatGrid6 = '\002D\000\025',
	STMSWord2011E180TableFormatGrid7 = '\002D\000\026',
	STMSWord2011E180TableFormatGrid8 = '\002D\000\027',
	STMSWord2011E180TableFormatList1 = '\002D\000\030',
	STMSWord2011E180TableFormatList2 = '\002D\000\031',
	STMSWord2011E180TableFormatList3 = '\002D\000\032',
	STMSWord2011E180TableFormatList4 = '\002D\000\033',
	STMSWord2011E180TableFormatList5 = '\002D\000\034',
	STMSWord2011E180TableFormatList6 = '\002D\000\035',
	STMSWord2011E180TableFormatList7 = '\002D\000\036',
	STMSWord2011E180TableFormatList8 = '\002D\000\037',
	STMSWord2011E180TableFormat3DEffects1 = '\002D\000 ',
	STMSWord2011E180TableFormat3DEffects2 = '\002D\000!',
	STMSWord2011E180TableFormat3DEffects3 = '\002D\000\"',
	STMSWord2011E180TableFormatContemporary = '\002D\000#',
	STMSWord2011E180TableFormatElegant = '\002D\000$',
	STMSWord2011E180TableFormatProfessional = '\002D\000%',
	STMSWord2011E180TableFormatSubtle1 = '\002D\000&',
	STMSWord2011E180TableFormatSubtle2 = '\002D\000\'',
	STMSWord2011E180TableFormatWeb1 = '\002D\000(',
	STMSWord2011E180TableFormatWeb2 = '\002D\000)',
	STMSWord2011E180TableFormatWeb3 = '\002D\000*'
};
typedef enum STMSWord2011E180 STMSWord2011E180;

enum STMSWord2011E181 {
	STMSWord2011E181TableFormatApplyBorders = '\002E\000\001',
	STMSWord2011E181TableFormatApplyShading = '\002E\000\002',
	STMSWord2011E181TableFormatApplyFont = '\002E\000\004',
	STMSWord2011E181TableFormatApplyColor = '\002E\000\010',
	STMSWord2011E181TableFormatApplyAutoFit = '\002E\000\020',
	STMSWord2011E181TableFormatApplyHeadingRows = '\002E\000 ',
	STMSWord2011E181TableFormatApplyLastRow = '\002E\000@',
	STMSWord2011E181TableFormatApplyFirstColumn = '\002E\000\200',
	STMSWord2011E181TableFormatApplyLastColumn = '\002E\001\000'
};
typedef enum STMSWord2011E181 STMSWord2011E181;

enum STMSWord2011E182 {
	STMSWord2011E182LanguageNone = '\002F\000\000',
	STMSWord2011E182LanguageNoProofing = '\002F\004\000',
	STMSWord2011E182Danish = '\002F\004\006',
	STMSWord2011E182German = '\002F\004\007',
	STMSWord2011E182SwissGerman = '\002F\010\007',
	STMSWord2011E182AustrianGerman = '\002F\014\007',
	STMSWord2011E182EnglishAus = '\002F\014\011',
	STMSWord2011E182EnglishUk = '\002F\010\011',
	STMSWord2011E182EnglishUs = '\002F\004\011',
	STMSWord2011E182EnglishCanadian = '\002F\020\011',
	STMSWord2011E182EnglishNewZealand = '\002F\024\011',
	STMSWord2011E182EnglishSouthAfrica = '\002F\034\011',
	STMSWord2011E182Spanish = '\002F\004\012',
	STMSWord2011E182French = '\002F\004\014',
	STMSWord2011E182FrenchCanadian = '\002F\014\014',
	STMSWord2011E182Italian = '\002F\004\020',
	STMSWord2011E182Dutch = '\002F\004\023',
	STMSWord2011E182NorwegianBokmol = '\002F\004\024',
	STMSWord2011E182NorwegianNynorsk = '\002F\010\024',
	STMSWord2011E182BrazilianPortuguese = '\002F\004\026',
	STMSWord2011E182Portuguese = '\002F\010\026',
	STMSWord2011E182Finnish = '\002F\004\013',
	STMSWord2011E182Swedish = '\002F\004\035',
	STMSWord2011E182Catalan = '\002F\004\003',
	STMSWord2011E182Greek = '\002F\004\010',
	STMSWord2011E182Turkish = '\002F\004\037',
	STMSWord2011E182Russian = '\002F\004\031',
	STMSWord2011E182Czech = '\002F\004\005',
	STMSWord2011E182Hungarian = '\002F\004\016',
	STMSWord2011E182Polish = '\002F\004\025',
	STMSWord2011E182Slovenian = '\002F\004$',
	STMSWord2011E182Basque = '\002F\004-',
	STMSWord2011E182Malaysian = '\002F\004>',
	STMSWord2011E182Japanese = '\002F\004\021',
	STMSWord2011E182Korean = '\002F\004\022',
	STMSWord2011E182SimplifiedChinese = '\002F\010\004',
	STMSWord2011E182TraditionalChinese = '\002F\004\004',
	STMSWord2011E182SwissFrench = '\002F\020\014',
	STMSWord2011E182Sesotho = '\002F\0040',
	STMSWord2011E182Tsonga = '\002F\0041',
	STMSWord2011E182Tswana = '\002F\0042',
	STMSWord2011E182Venda = '\002F\0043',
	STMSWord2011E182Xhosa = '\002F\0044',
	STMSWord2011E182Zulu = '\002F\0045',
	STMSWord2011E182Afrikaans = '\002F\0046',
	STMSWord2011E182Arabic = '\002F\004\001',
	STMSWord2011E182Hebrew = '\002F\004\015',
	STMSWord2011E182Slovak = '\002F\004\033',
	STMSWord2011E182Farsi = '\002F\004)',
	STMSWord2011E182Romanian = '\002F\004\030',
	STMSWord2011E182Croatian = '\002F\004\032',
	STMSWord2011E182Ukrainian = '\002F\004\"',
	STMSWord2011E182Byelorussian = '\002F\004#',
	STMSWord2011E182Estonian = '\002F\004%',
	STMSWord2011E182Latvian = '\002F\004&',
	STMSWord2011E182Macedonian = '\002F\004/',
	STMSWord2011E182SerbianLatin = '\002F\010\032',
	STMSWord2011E182SerbianCyrillic = '\002F\014\032',
	STMSWord2011E182Icelandic = '\002F\004\017',
	STMSWord2011E182BelgianFrench = '\002F\010\014',
	STMSWord2011E182BelgianDutch = '\002F\010\023',
	STMSWord2011E182Bulgarian = '\002F\004\002',
	STMSWord2011E182MexicanSpanish = '\002F\010\012',
	STMSWord2011E182SpanishModernSort = '\002F\014\012',
	STMSWord2011E182SwissItalian = '\002F\010\020'
};
typedef enum STMSWord2011E182 STMSWord2011E182;

enum STMSWord2011E183 {
	STMSWord2011E183FieldEmpty = '\002F\377\377',
	STMSWord2011E183FieldRef = '\002G\000\003',
	STMSWord2011E183FieldIndexEntry = '\002G\000\004',
	STMSWord2011E183FieldFootnoteRef = '\002G\000\005',
	STMSWord2011E183FieldSet = '\002G\000\006',
	STMSWord2011E183FieldIf = '\002G\000\007',
	STMSWord2011E183FieldIndex = '\002G\000\010',
	STMSWord2011E183FieldTocEntry = '\002G\000\011',
	STMSWord2011E183FieldStyleRef = '\002G\000\012',
	STMSWord2011E183FieldRefDoc = '\002G\000\013',
	STMSWord2011E183FieldSequence = '\002G\000\014',
	STMSWord2011E183FieldToc = '\002G\000\015',
	STMSWord2011E183FieldInfo = '\002G\000\016',
	STMSWord2011E183FieldTitle = '\002G\000\017',
	STMSWord2011E183FieldSubject = '\002G\000\020',
	STMSWord2011E183FieldAuthor = '\002G\000\021',
	STMSWord2011E183FieldKeyWord = '\002G\000\022',
	STMSWord2011E183FieldComments = '\002G\000\023',
	STMSWord2011E183FieldLastSavedBy = '\002G\000\024',
	STMSWord2011E183FieldCreateDate = '\002G\000\025',
	STMSWord2011E183FieldSaveDate = '\002G\000\026',
	STMSWord2011E183FieldPrintDate = '\002G\000\027',
	STMSWord2011E183FieldRevisionNum = '\002G\000\030',
	STMSWord2011E183FieldEditTime = '\002G\000\031',
	STMSWord2011E183FieldNumPages = '\002G\000\032',
	STMSWord2011E183FieldNumWords = '\002G\000\033',
	STMSWord2011E183FieldNumChars = '\002G\000\034',
	STMSWord2011E183FieldFileName = '\002G\000\035',
	STMSWord2011E183FieldTemplate = '\002G\000\036',
	STMSWord2011E183FieldDate = '\002G\000\037',
	STMSWord2011E183FieldTime = '\002G\000 ',
	STMSWord2011E183FieldPage = '\002G\000!',
	STMSWord2011E183FieldExpression = '\002G\000\"',
	STMSWord2011E183FieldQuote = '\002G\000#',
	STMSWord2011E183FieldInclude = '\002G\000$',
	STMSWord2011E183FieldPageRef = '\002G\000%',
	STMSWord2011E183FieldAsk = '\002G\000&',
	STMSWord2011E183FieldFillIn = '\002G\000\'',
	STMSWord2011E183FieldData = '\002G\000(',
	STMSWord2011E183FieldNext = '\002G\000)',
	STMSWord2011E183FieldNextIf = '\002G\000*',
	STMSWord2011E183FieldSkipIf = '\002G\000+',
	STMSWord2011E183FieldMergeRec = '\002G\000,',
	STMSWord2011E183FieldDde = '\002G\000-',
	STMSWord2011E183FieldDdeauto = '\002G\000.',
	STMSWord2011E183FieldGlossary = '\002G\000/',
	STMSWord2011E183FieldPrint = '\002G\0000',
	STMSWord2011E183FieldFormula = '\002G\0001',
	STMSWord2011E183FieldGoToButton = '\002G\0002',
	STMSWord2011E183FieldMacroButton = '\002G\0003',
	STMSWord2011E183FieldAutoNumOutline = '\002G\0004',
	STMSWord2011E183FieldAutoNumLegal = '\002G\0005',
	STMSWord2011E183FieldAutoNum = '\002G\0006',
	STMSWord2011E183FieldImport = '\002G\0007',
	STMSWord2011E183FieldLink = '\002G\0008',
	STMSWord2011E183FieldSymbol = '\002G\0009',
	STMSWord2011E183FieldEmbed = '\002G\000:',
	STMSWord2011E183FieldMergeField = '\002G\000;',
	STMSWord2011E183FieldUserName = '\002G\000<',
	STMSWord2011E183FieldUserInitials = '\002G\000=',
	STMSWord2011E183FieldUserAddress = '\002G\000>',
	STMSWord2011E183FieldBarCode = '\002G\000\?',
	STMSWord2011E183FieldDocVariable = '\002G\000@',
	STMSWord2011E183FieldSection = '\002G\000A',
	STMSWord2011E183FieldSectionPages = '\002G\000B',
	STMSWord2011E183FieldIncludePicture = '\002G\000C',
	STMSWord2011E183FieldIncludeText = '\002G\000D',
	STMSWord2011E183FieldFileSize = '\002G\000E',
	STMSWord2011E183FieldFormTextInput = '\002G\000F',
	STMSWord2011E183FieldFormCheckBox = '\002G\000G',
	STMSWord2011E183FieldNoteRef = '\002G\000H',
	STMSWord2011E183FieldToa = '\002G\000I',
	STMSWord2011E183FieldToaentry = '\002G\000J',
	STMSWord2011E183FieldMergeSeq = '\002G\000K',
	STMSWord2011E183FieldPrivate = '\002G\000M',
	STMSWord2011E183FieldDatabase = '\002G\000N',
	STMSWord2011E183FieldAutoText = '\002G\000O',
	STMSWord2011E183FieldCompare = '\002G\000P',
	STMSWord2011E183FieldAddin = '\002G\000Q',
	STMSWord2011E183FieldSubscriber = '\002G\000R',
	STMSWord2011E183FieldFormDropDown = '\002G\000S',
	STMSWord2011E183FieldAdvance = '\002G\000T',
	STMSWord2011E183FieldDocProperty = '\002G\000U',
	STMSWord2011E183FieldOcx = '\002G\000W',
	STMSWord2011E183FieldHyperlink = '\002G\000X',
	STMSWord2011E183FieldAutoTextList = '\002G\000Y',
	STMSWord2011E183FieldListnum = '\002G\000Z',
	STMSWord2011E183FieldHtmlactiveX = '\002G\000[',
	STMSWord2011E183FieldContact = '\002G\000b',
	STMSWord2011E183FieldUserProperty = '\002G\000c'
};
typedef enum STMSWord2011E183 STMSWord2011E183;

enum STMSWord2011E184 {
	STMSWord2011E184StyleNormal = '\002G\377\377',
	STMSWord2011E184StyleEnvelopeAddress = '\002G\377\333',
	STMSWord2011E184StyleEnvelopeReturn = '\002G\377\332',
	STMSWord2011E184StyleBodyText = '\002G\377\275',
	STMSWord2011E184StyleHeading1 = '\002G\377\376',
	STMSWord2011E184StyleHeading2 = '\002G\377\375',
	STMSWord2011E184StyleHeading3 = '\002G\377\374',
	STMSWord2011E184StyleHeading4 = '\002G\377\373',
	STMSWord2011E184StyleHeading5 = '\002G\377\372',
	STMSWord2011E184StyleHeading6 = '\002G\377\371',
	STMSWord2011E184StyleHeading7 = '\002G\377\370',
	STMSWord2011E184StyleHeading8 = '\002G\377\367',
	STMSWord2011E184StyleHeading9 = '\002G\377\366',
	STMSWord2011E184StyleIndex1 = '\002G\377\365',
	STMSWord2011E184StyleIndex2 = '\002G\377\364',
	STMSWord2011E184StyleIndex3 = '\002G\377\363',
	STMSWord2011E184StyleIndex4 = '\002G\377\362',
	STMSWord2011E184StyleIndex5 = '\002G\377\361',
	STMSWord2011E184StyleIndex6 = '\002G\377\360',
	STMSWord2011E184StyleIndex7 = '\002G\377\357',
	STMSWord2011E184StyleIndex8 = '\002G\377\356',
	STMSWord2011E184StyleIndex9 = '\002G\377\355',
	STMSWord2011E184StyleToc1 = '\002G\377\354',
	STMSWord2011E184StyleToc2 = '\002G\377\353',
	STMSWord2011E184StyleToc3 = '\002G\377\352',
	STMSWord2011E184StyleToc4 = '\002G\377\351',
	STMSWord2011E184StyleToc5 = '\002G\377\350',
	STMSWord2011E184StyleToc6 = '\002G\377\347',
	STMSWord2011E184StyleToc7 = '\002G\377\346',
	STMSWord2011E184StyleToc8 = '\002G\377\345',
	STMSWord2011E184StyleToc9 = '\002G\377\344',
	STMSWord2011E184StyleNormalIndent = '\002G\377\343',
	STMSWord2011E184StyleFootnoteText = '\002G\377\342',
	STMSWord2011E184StyleCommentText = '\002G\377\341',
	STMSWord2011E184StyleHeader = '\002G\377\340',
	STMSWord2011E184StyleFooter = '\002G\377\337',
	STMSWord2011E184StyleIndexHeading = '\002G\377\336',
	STMSWord2011E184StyleCaption = '\002G\377\335',
	STMSWord2011E184StyleTableOfFigures = '\002G\377\334',
	STMSWord2011E184StyleFootnoteReference = '\002G\377\331',
	STMSWord2011E184StyleCommentReference = '\002G\377\330',
	STMSWord2011E184StyleLineNumber = '\002G\377\327',
	STMSWord2011E184StylePageNumber = '\002G\377\326',
	STMSWord2011E184StyleEndnoteReference = '\002G\377\325',
	STMSWord2011E184StyleEndnoteText = '\002G\377\324',
	STMSWord2011E184StyleTableOfAuthorities = '\002G\377\323',
	STMSWord2011E184StyleMacroText = '\002G\377\322',
	STMSWord2011E184StyleToaHeading = '\002G\377\321',
	STMSWord2011E184StyleList = '\002G\377\320',
	STMSWord2011E184StyleListBullet = '\002G\377\317',
	STMSWord2011E184StyleListNumber = '\002G\377\316',
	STMSWord2011E184StyleList2 = '\002G\377\315',
	STMSWord2011E184StyleList3 = '\002G\377\314',
	STMSWord2011E184StyleList4 = '\002G\377\313',
	STMSWord2011E184StyleList5 = '\002G\377\312',
	STMSWord2011E184StyleListBullet2 = '\002G\377\311',
	STMSWord2011E184StyleListBullet3 = '\002G\377\310',
	STMSWord2011E184StyleListBullet4 = '\002G\377\307',
	STMSWord2011E184StyleListBullet5 = '\002G\377\306',
	STMSWord2011E184StyleListNumber2 = '\002G\377\305',
	STMSWord2011E184StyleListNumber3 = '\002G\377\304',
	STMSWord2011E184StyleListNumber4 = '\002G\377\303',
	STMSWord2011E184StyleListNumber5 = '\002G\377\302',
	STMSWord2011E184StyleTitle = '\002G\377\301',
	STMSWord2011E184StyleClosing = '\002G\377\300',
	STMSWord2011E184StyleSignature = '\002G\377\277',
	STMSWord2011E184StyleDefaultParagraphFont = '\002G\377\276',
	STMSWord2011E184StyleBodyTextIndent = '\002G\377\274',
	STMSWord2011E184StyleListContinue = '\002G\377\273',
	STMSWord2011E184StyleListContinue2 = '\002G\377\272',
	STMSWord2011E184StyleListContinue3 = '\002G\377\271',
	STMSWord2011E184StyleListContinue4 = '\002G\377\270',
	STMSWord2011E184StyleListContinue5 = '\002G\377\267',
	STMSWord2011E184StyleMessageHeader = '\002G\377\266',
	STMSWord2011E184StyleSubtitle = '\002G\377\265',
	STMSWord2011E184StyleSalutation = '\002G\377\264',
	STMSWord2011E184StyleDate = '\002G\377\263',
	STMSWord2011E184StyleBodyTextFirstIndent = '\002G\377\262',
	STMSWord2011E184StyleBodyTextFirstIndent2 = '\002G\377\261',
	STMSWord2011E184StyleNoteHeading = '\002G\377\260',
	STMSWord2011E184StyleBodyText2 = '\002G\377\257',
	STMSWord2011E184StyleBodyText3 = '\002G\377\256',
	STMSWord2011E184StyleBodyTextIndent2 = '\002G\377\255',
	STMSWord2011E184StyleBodyTextIndent3 = '\002G\377\254',
	STMSWord2011E184StyleBlockQuotation = '\002G\377\253',
	STMSWord2011E184StyleHyperlink = '\002G\377\252',
	STMSWord2011E184StyleHyperlinkFollowed = '\002G\377\251',
	STMSWord2011E184StyleStrong = '\002G\377\250',
	STMSWord2011E184StyleEmphasis = '\002G\377\247',
	STMSWord2011E184StyleNavPane = '\002G\377\246',
	STMSWord2011E184StylePlainText = '\002G\377\245',
	STMSWord2011E184StyleHtmlNormal = '\002G\377\241',
	STMSWord2011E184StyleHtmlAcronym = '\002G\377\240',
	STMSWord2011E184StyleHtmlAddress = '\002G\377\237',
	STMSWord2011E184StyleHtmlCite = '\002G\377\236',
	STMSWord2011E184StyleHtmlCode = '\002G\377\235',
	STMSWord2011E184StyleHtmlDefine = '\002G\377\234',
	STMSWord2011E184StyleHtmlKeyboard = '\002G\377\233',
	STMSWord2011E184StyleHtmlPreformatted = '\002G\377\232',
	STMSWord2011E184StyleHtmlSample = '\002G\377\231',
	STMSWord2011E184StyleHtmlTypewriter = '\002G\377\230',
	STMSWord2011E184StyleHtmlVariable = '\002G\377\227',
	STMSWord2011E184StyleNoteLevel1 = '\002G\377c',
	STMSWord2011E184StyleNoteLevel2 = '\002G\377b',
	STMSWord2011E184StyleNoteLevel3 = '\002G\377a',
	STMSWord2011E184StyleNoteLevel4 = '\002G\377`',
	STMSWord2011E184StyleNoteLevel5 = '\002G\377_',
	STMSWord2011E184StyleNoteLevel6 = '\002G\377^',
	STMSWord2011E184StyleNoteLevel7 = '\002G\377]',
	STMSWord2011E184StyleNoteLevel8 = '\002G\377\\',
	STMSWord2011E184StyleNoteLevel9 = '\002G\377[',
	STMSWord2011E184StyleBibliography = '\002G\377Z',
	STMSWord2011E184StyleListParagraph = '\002G\377Y',
	STMSWord2011E184StylePlaceholderText = '\002G\377X'
};
typedef enum STMSWord2011E184 STMSWord2011E184;

enum STMSWord2011E185 {
	STMSWord2011E185DialogFileDocumentLayoutTabMargins = '\002I\000\017',
	STMSWord2011E185DialogFileDocumentLayoutTabLayout = '\002I\000\020',
	STMSWord2011E185DialogFilePageSetupTabMargins = '\002I\000\021',
	STMSWord2011E185DialogFilePageSetupTabPaperSize = '\002I\000\022',
	STMSWord2011E185DialogFilePageSetupTabPaperSource = '\002I\000\023',
	STMSWord2011E185DialogFilePageSetupTabLayout = '\002I\000\024',
	STMSWord2011E185DialogFilePageSetupTabCharsLines = '\002I\000\025',
	STMSWord2011E185DialogInsertSymbolTabSymbols = '\002I\000\026',
	STMSWord2011E185DialogInsertSymbolTabSpecialCharacters = '\002I\000\027',
	STMSWord2011E185DialogNoteOptionsTabAllFootnotes = '\002I\000\030',
	STMSWord2011E185DialogNoteOptionsTabAllEndnotes = '\002I\000\031',
	STMSWord2011E185DialogInsertIndexAndTablesTabIndex = '\002I\000\032',
	STMSWord2011E185DialogInsertIndexAndTablesTabTableOfContents = '\002I\000\033',
	STMSWord2011E185DialogInsertIndexAndTablesTabTableOfFigures = '\002I\000\034',
	STMSWord2011E185DialogInsertIndexAndTablesTabTableOfAuthorities = '\002I\000\035',
	STMSWord2011E185DialogOrganizerTabStyles = '\002I\000\036',
	STMSWord2011E185DialogOrganizerTabAutoText = '\002I\000\037',
	STMSWord2011E185DialogOrganizerTabCommandBars = '\002I\000 ',
	STMSWord2011E185DialogOrganizerTabMacros = '\002I\000!',
	STMSWord2011E185DialogFormatFontTabFont = '\002I\000\"',
	STMSWord2011E185DialogFormatFontTabCharacterSpacing = '\002I\000#',
	STMSWord2011E185DialogFormatBordersAndShadingTabBorders = '\002I\000%',
	STMSWord2011E185DialogFormatBordersAndShadingTabPageBorder = '\002I\000&',
	STMSWord2011E185DialogFormatBordersAndShadingTabShading = '\002I\000\'',
	STMSWord2011E185DialogToolsEnvelopesAndLabelsTabEnvelopes = '\002I\000(',
	STMSWord2011E185DialogToolsEnvelopesAndLabelsTabLabels = '\002I\000)',
	STMSWord2011E185DialogFormatParagraphTabIndentsAndSpacing = '\002I\000*',
	STMSWord2011E185DialogFormatParagraphTabTextFlow = '\002I\000+',
	STMSWord2011E185DialogFormatParagraphTabTeisai = '\002I\000,',
	STMSWord2011E185DialogFormatDrawingObjectTabColorsAndLines = '\002I\000-',
	STMSWord2011E185DialogFormatDrawingObjectTabSize = '\002I\000.',
	STMSWord2011E185DialogFormatDrawingObjectTabPosition = '\002I\000/',
	STMSWord2011E185DialogFormatDrawingObjectTabWrapping = '\002I\0000',
	STMSWord2011E185DialogFormatDrawingObjectTabPicture = '\002I\0001',
	STMSWord2011E185DialogFormatDrawingObjectTabTextbox = '\002I\0002',
	STMSWord2011E185DialogFormatDrawingObjectTabHr = '\002I\0003',
	STMSWord2011E185DialogToolsAutocorrectExceptionsTabFirstLetter = '\002I\0004',
	STMSWord2011E185DialogToolsAutocorrectExceptionsTabInitialCaps = '\002I\0005',
	STMSWord2011E185DialogToolsAutocorrectExceptionsTabHangulAndAlphabet = '\002I\0006',
	STMSWord2011E185DialogToolsAutocorrectExceptionsTabIac = '\002I\0007',
	STMSWord2011E185DialogFormatBulletsAndNumberingTabBulleted = '\002I\0008',
	STMSWord2011E185DialogFormatBulletsAndNumberingTabNumbered = '\002I\0009',
	STMSWord2011E185DialogFormatBulletsAndNumberingTabOutlineNumbered = '\002I\000:',
	STMSWord2011E185DialogLetterWizardTabLetterFormat = '\002I\000;',
	STMSWord2011E185DialogLetterWizardTabRecipientInfo = '\002I\000<',
	STMSWord2011E185DialogLetterWizardTabOtherElements = '\002I\000=',
	STMSWord2011E185DialogLetterWizardTabSenderInfo = '\002I\000>',
	STMSWord2011E185DialogToolsAutoManagerTabAutocorrect = '\002I\000\?',
	STMSWord2011E185DialogToolsAutoManagerTabMathAutocorrect = '\002I\000@',
	STMSWord2011E185DialogToolsAutoManagerTabAutoFormatAsYouType = '\002I\000A',
	STMSWord2011E185DialogToolsAutoManagerTabAutoText = '\002I\000B',
	STMSWord2011E185DialogToolsAutoManagerTabAutoFormat = '\002I\000C',
	STMSWord2011E185DialogWebOptionsGeneral = '\002I\000D',
	STMSWord2011E185DialogWebOptionsFiles = '\002I\000E',
	STMSWord2011E185DialogWebOptionsPictures = '\002I\000F',
	STMSWord2011E185DialogWebOptionsEncoding = '\002I\000G',
	STMSWord2011E185DialogWebOptionsFonts = '\002I\000H',
	STMSWord2011E185DialogFormatDrawingObjectTabAltText = '\002I\000I'
};
typedef enum STMSWord2011E185 STMSWord2011E185;

enum STMSWord2011E186 {
	STMSWord2011E186DialogHelpAbout = '\002J\000\011',
	STMSWord2011E186DialogHelpWordPerfectHelp = '\002J\000\012',
	STMSWord2011E186DialogHelpWordPerfectHelpOptions = '\002J\001\377',
	STMSWord2011E186DialogFormatChangeCase = '\002J\001B',
	STMSWord2011E186DialogToolsOptionsFuzzy = '\002J\003\026',
	STMSWord2011E186DialogToolsWordCount = '\002J\000\344',
	STMSWord2011E186DialogDocumentStatistics = '\002J\000N',
	STMSWord2011E186DialogFileNew = '\002J\000O',
	STMSWord2011E186DialogFileOpen = '\002J\000P',
	STMSWord2011E186DialogDataMergeOpenDataSource = '\002J\000Q',
	STMSWord2011E186DialogDataMergeOpenHeaderSource = '\002J\000R',
	STMSWord2011E186DialogDataMergeUseAddressBook = '\002J\003\013',
	STMSWord2011E186DialogFileSaveAs = '\002J\000T',
	STMSWord2011E186DialogFileSummaryInfo = '\002J\000V',
	STMSWord2011E186DialogToolsTemplates = '\002J\000W',
	STMSWord2011E186DialogOrganizer = '\002J\000\336',
	STMSWord2011E186DialogFilePrint = '\002J\000X',
	STMSWord2011E186DialogDataMerge = '\002J\002\244',
	STMSWord2011E186DialogDataMergeCheck = '\002J\002\245',
	STMSWord2011E186DialogDataMergeQueryOptions = '\002J\002\251',
	STMSWord2011E186DialogDataMergeFindRecord = '\002J\0029',
	STMSWord2011E186DialogDataMergeInsertIf = '\002J\017\321',
	STMSWord2011E186DialogDataMergeInsertNextIf = '\002J\017\325',
	STMSWord2011E186DialogDataMergeInsertSkipIf = '\002J\017\327',
	STMSWord2011E186DialogDataMergeInsertFillIn = '\002J\017\320',
	STMSWord2011E186DialogDataMergeInsertAsk = '\002J\017\317',
	STMSWord2011E186DialogDataMergeInsertSet = '\002J\017\326',
	STMSWord2011E186DialogDataMergeHelper = '\002J\002\250',
	STMSWord2011E186DialogLetterWizard = '\002J\0035',
	STMSWord2011E186DialogFilePrintSetup = '\002J\000a',
	STMSWord2011E186DialogFileFind = '\002J\000c',
	STMSWord2011E186DialogDataMergeCreateDataSource = '\002J\002\202',
	STMSWord2011E186DialogDataMergeCreateHeaderSource = '\002J\002\203',
	STMSWord2011E186DialogEditPasteSpecial = '\002J\000o',
	STMSWord2011E186DialogEditFind = '\002J\000p',
	STMSWord2011E186DialogEditReplace = '\002J\000u',
	STMSWord2011E186DialogEditGoToOld = '\002J\003+',
	STMSWord2011E186DialogEditGoTo = '\002J\003\200',
	STMSWord2011E186DialogCreateAutoText = '\002J\003h',
	STMSWord2011E186DialogEditAutoText = '\002J\003\331',
	STMSWord2011E186DialogEditLinks = '\002J\000|',
	STMSWord2011E186DialogEditObject = '\002J\000}',
	STMSWord2011E186DialogConvertObject = '\002J\001\210',
	STMSWord2011E186DialogTableToText = '\002J\000\200',
	STMSWord2011E186DialogTextToTable = '\002J\000\177',
	STMSWord2011E186DialogTableInsertTable = '\002J\000\201',
	STMSWord2011E186DialogTableInsertCells = '\002J\000\202',
	STMSWord2011E186DialogTableInsertRow = '\002J\000\203',
	STMSWord2011E186DialogTableDeleteCells = '\002J\000\205',
	STMSWord2011E186DialogTableSplitCells = '\002J\000\211',
	STMSWord2011E186DialogTableFormula = '\002J\001\\',
	STMSWord2011E186DialogTableAutoFormat = '\002J\0023',
	STMSWord2011E186DialogTableFormatCell = '\002J\002d',
	STMSWord2011E186DialogViewZoom = '\002J\002A',
	STMSWord2011E186DialogNewToolbar = '\002J\002J',
	STMSWord2011E186DialogInsertBreak = '\002J\000\237',
	STMSWord2011E186DialogInsertFootnote = '\002J\001r',
	STMSWord2011E186DialogInsertSymbol = '\002J\000\242',
	STMSWord2011E186DialogInsertPicture = '\002J\000\243',
	STMSWord2011E186DialogInsertFile = '\002J\000\244',
	STMSWord2011E186DialogInsertDateTime = '\002J\000\245',
	STMSWord2011E186DialogInsertNumber = '\002J\003,',
	STMSWord2011E186DialogInsertField = '\002J\000\246',
	STMSWord2011E186DialogInsertDatabase = '\002J\001U',
	STMSWord2011E186DialogInsertMergeField = '\002J\000\247',
	STMSWord2011E186DialogInsertBookmark = '\002J\000\250',
	STMSWord2011E186DialogMarkIndexEntry = '\002J\000\251',
	STMSWord2011E186DialogMarkCitation = '\002J\001\317',
	STMSWord2011E186DialogEditToacategory = '\002J\002q',
	STMSWord2011E186DialogInsertIndexAndTables = '\002J\001\331',
	STMSWord2011E186DialogInsertIndex = '\002J\000\252',
	STMSWord2011E186DialogInsertTableOfContents = '\002J\000\253',
	STMSWord2011E186DialogMarkTableOfContentsEntry = '\002J\001\272',
	STMSWord2011E186DialogInsertTableOfFigures = '\002J\001\330',
	STMSWord2011E186DialogInsertTableOfAuthorities = '\002J\001\327',
	STMSWord2011E186DialogInsertObject = '\002J\000\254',
	STMSWord2011E186DialogFormatCallout = '\002J\002b',
	STMSWord2011E186DialogDrawSnapToGrid = '\002J\002y',
	STMSWord2011E186DialogDrawAlign = '\002J\002z',
	STMSWord2011E186DialogToolsEnvelopesAndLabels = '\002J\002_',
	STMSWord2011E186DialogToolsCreateEnvelope = '\002J\000\255',
	STMSWord2011E186DialogToolsCreateLabels = '\002J\001\351',
	STMSWord2011E186DialogToolsProtectDocument = '\002J\001\367',
	STMSWord2011E186DialogToolsProtectSection = '\002J\002B',
	STMSWord2011E186DialogToolsUnprotectDocument = '\002J\002\011',
	STMSWord2011E186DialogFormatFont = '\002J\000\256',
	STMSWord2011E186DialogFormatParagraph = '\002J\000\257',
	STMSWord2011E186DialogFormatSectionLayout = '\002J\000\260',
	STMSWord2011E186DialogFormatColumns = '\002J\000\261',
	STMSWord2011E186DialogFileDocumentLayout = '\002J\000\262',
	STMSWord2011E186DialogFileMacPageSetup = '\002J\002\255',
	STMSWord2011E186DialogFilePageSetup = '\002J\000\262',
	STMSWord2011E186DialogFormatTabs = '\002J\000\263',
	STMSWord2011E186DialogFormatStyle = '\002J\000\264',
	STMSWord2011E186DialogFormatStyleGallery = '\002J\001\371',
	STMSWord2011E186DialogFormatDefineStyleFont = '\002J\000\265',
	STMSWord2011E186DialogFormatDefineStylePara = '\002J\000\266',
	STMSWord2011E186DialogFormatDefineStyleTabs = '\002J\000\267',
	STMSWord2011E186DialogFormatDefineStyleFrame = '\002J\000\270',
	STMSWord2011E186DialogFormatDefineStyleBorders = '\002J\000\271',
	STMSWord2011E186DialogFormatDefineStyleLang = '\002J\000\272',
	STMSWord2011E186DialogFormatPicture = '\002J\000\273',
	STMSWord2011E186DialogToolsLanguage = '\002J\000\274',
	STMSWord2011E186DialogFormatBordersAndShading = '\002J\000\275',
	STMSWord2011E186DialogFormatDrawingObject = '\002J\003\300',
	STMSWord2011E186DialogFormatFrame = '\002J\000\276',
	STMSWord2011E186DialogFormatDropCap = '\002J\001\350',
	STMSWord2011E186DialogFormatBulletsAndNumbering = '\002J\0038',
	STMSWord2011E186DialogToolsHyphenation = '\002J\000\303',
	STMSWord2011E186DialogToolsBulletsNumbers = '\002J\000\304',
	STMSWord2011E186DialogToolsHighlightChanges = '\002J\000\305',
	STMSWord2011E186DialogToolsAcceptRejectChanges = '\002J\001\372',
	STMSWord2011E186DialogToolsMergeDocuments = '\002J\001\263',
	STMSWord2011E186DialogToolsCompareDocuments = '\002J\000\306',
	STMSWord2011E186DialogTableSort = '\002J\000\307',
	STMSWord2011E186DialogToolsCustomizeMenuBar = '\002J\002g',
	STMSWord2011E186DialogToolsCustomize = '\002J\000\230',
	STMSWord2011E186DialogToolsCustomizeKeyboard = '\002J\001\260',
	STMSWord2011E186DialogToolsCustomizeMenus = '\002J\001\261',
	STMSWord2011E186DialogListCommands = '\002J\002\323',
	STMSWord2011E186DialogToolsOptions = '\002J\003\316',
	STMSWord2011E186DialogToolsOptionsGeneral = '\002J\000\313',
	STMSWord2011E186DialogToolsAdvancedSettings = '\002J\000\316',
	STMSWord2011E186DialogToolsOptionsCompatibility = '\002J\002\015',
	STMSWord2011E186DialogToolsOptionsPrint = '\002J\000\320',
	STMSWord2011E186DialogToolsOptionsSave = '\002J\000\321',
	STMSWord2011E186DialogToolsOptionsSpellingAndGrammar = '\002J\000\323',
	STMSWord2011E186DialogToolsSpellingAndGrammar = '\002J\003<',
	STMSWord2011E186DialogToolsThesaurus = '\002J\000\302',
	STMSWord2011E186DialogToolsOptionsUserInfo = '\002J\000\325',
	STMSWord2011E186DialogToolsOptionsAutoFormat = '\002J\003\277',
	STMSWord2011E186DialogToolsOptionsTrackChanges = '\002J\001\202',
	STMSWord2011E186DialogToolsOptionsEdit = '\002J\000\340',
	STMSWord2011E186DialogInsertPageNumbers = '\002J\001&',
	STMSWord2011E186DialogFormatPageNumber = '\002J\001*',
	STMSWord2011E186DialogNoteOptions = '\002J\001u',
	STMSWord2011E186DialogCopyFile = '\002J\001,',
	STMSWord2011E186DialogFormatAddrFonts = '\002J\000g',
	STMSWord2011E186DialogFormatRetAddrFonts = '\002J\000\335',
	STMSWord2011E186DialogToolsOptionsFileLocations = '\002J\000\341',
	STMSWord2011E186DialogToolsCreateDirectory = '\002J\003A',
	STMSWord2011E186DialogUpdateToc = '\002J\001K',
	STMSWord2011E186DialogInsertFormField = '\002J\001\343',
	STMSWord2011E186DialogFormFieldOptions = '\002J\001a',
	STMSWord2011E186DialogInsertCaption = '\002J\001e',
	STMSWord2011E186DialogInsertAutoCaption = '\002J\001g',
	STMSWord2011E186DialogInsertAddCaption = '\002J\001\222',
	STMSWord2011E186DialogInsertCaptionNumbering = '\002J\001f',
	STMSWord2011E186DialogInsertCrossReference = '\002J\001o',
	STMSWord2011E186DialogToolsManageFields = '\002J\002w',
	STMSWord2011E186DialogToolsAutoManager = '\002J\003\223',
	STMSWord2011E186DialogToolsAutocorrect = '\002J\001z',
	STMSWord2011E186DialogToolsAutocorrectExceptions = '\002J\002\372',
	STMSWord2011E186DialogConnect = '\002J\001\244',
	STMSWord2011E186DialogToolsOptionsView = '\002J\000\314',
	STMSWord2011E186DialogInsertSubdocument = '\002J\002G',
	STMSWord2011E186DialogFileRoutingSlip = '\002J\002p',
	STMSWord2011E186DialogFontSubstitution = '\002J\002E',
	STMSWord2011E186DialogToolsOptionsTypography = '\002J\002\343',
	STMSWord2011E186DialogToolsOptionsAutoFormatAsYouType = '\002J\003\012',
	STMSWord2011E186DialogControlRun = '\002J\000\353',
	STMSWord2011E186DialogFileVersions = '\002J\003\261',
	STMSWord2011E186DialogFileSaveVersion = '\002J\003\357',
	STMSWord2011E186DialogWindowActivate = '\002J\000\334',
	STMSWord2011E186DialogToolsMacroRecord = '\002J\000\326',
	STMSWord2011E186DialogToolsRevisions = '\002J\000\305',
	STMSWord2011E186DialogWebOptions = '\002J\003\202',
	STMSWord2011E186DialogFitText = '\002J\003\327',
	STMSWord2011E186DialogFormatEncloseCharacters = '\002J\004\212',
	STMSWord2011E186DialogEmail = '\002J\020%',
	STMSWord2011E186DialogFormatTheme = '\002J\003W',
	STMSWord2011E186DialogToolsOptionsSecurity = '\002J\005Q',
	STMSWord2011E186DialogToolsOptionsFeedback = '\002J\006\301',
	STMSWord2011E186DialogToolsOptionsEditCopyPaste = '\002J\005L',
	STMSWord2011E186DialogToolsOptionsNoteRecording = '\002J\006a',
	STMSWord2011E186DialogMathRecognizedFunctions = '\002J\006\321',
	STMSWord2011E186DialogMathMatrixSpacing = '\002J\006\322',
	STMSWord2011E186DialogMathEquationArraySpacing = '\002J\006\323'
};
typedef enum STMSWord2011E186 STMSWord2011E186;

enum STMSWord2011E187 {
	STMSWord2011E187FieldKindNone = '\002K\000\000',
	STMSWord2011E187FieldKindHot = '\002K\000\001',
	STMSWord2011E187FieldKindWarm = '\002K\000\002',
	STMSWord2011E187FieldKindCold = '\002K\000\003'
};
typedef enum STMSWord2011E187 STMSWord2011E187;

enum STMSWord2011E188 {
	STMSWord2011E188RegularText = '\002L\000\000',
	STMSWord2011E188NumberText = '\002L\000\001',
	STMSWord2011E188DateText = '\002L\000\002',
	STMSWord2011E188CurrentDateText = '\002L\000\003',
	STMSWord2011E188CurrentTimeText = '\002L\000\004',
	STMSWord2011E188CalculationText = '\002L\000\005'
};
typedef enum STMSWord2011E188 STMSWord2011E188;

enum STMSWord2011E189 {
	STMSWord2011E189NeverConvert = '\002M\000\000',
	STMSWord2011E189AlwaysConvert = '\002M\000\001',
	STMSWord2011E189AskToNotConvert = '\002M\000\002',
	STMSWord2011E189AskToConvert = '\002M\000\003'
};
typedef enum STMSWord2011E189 STMSWord2011E189;

enum STMSWord2011E190 {
	STMSWord2011E190NotAMergeDocument = '\002M\377\377',
	STMSWord2011E190DocumentTypeFormLetters = '\002N\000\000',
	STMSWord2011E190DocumentTypeMailingLabels = '\002N\000\001',
	STMSWord2011E190DocumentTypeEnvelopes = '\002N\000\002',
	STMSWord2011E190DocumentTypeCatalog = '\002N\000\003'
};
typedef enum STMSWord2011E190 STMSWord2011E190;

enum STMSWord2011E191 {
	STMSWord2011E191NormalDocument = '\002O\000\000',
	STMSWord2011E191MainDocumentOnly = '\002O\000\001',
	STMSWord2011E191MainAndDataSource = '\002O\000\002',
	STMSWord2011E191MainAndHeader = '\002O\000\003',
	STMSWord2011E191MainAndSourceAndHeader = '\002O\000\004',
	STMSWord2011E191DataSource = '\002O\000\005'
};
typedef enum STMSWord2011E191 STMSWord2011E191;

enum STMSWord2011E192 {
	STMSWord2011E192SendToNewDocument = '\002P\000\000',
	STMSWord2011E192SendToPrinter = '\002P\000\001',
	STMSWord2011E192SendToEmail = '\002P\000\002',
	STMSWord2011E192SendToFax = '\002P\000\003'
};
typedef enum STMSWord2011E192 STMSWord2011E192;

enum STMSWord2011E193 {
	STMSWord2011E193NoActiveRecord = '\002P\377\377',
	STMSWord2011E193NextDataRecord = '\002P\377\376',
	STMSWord2011E193PreviousDataRecord = '\002P\377\375',
	STMSWord2011E193FirstDataRecord = '\002P\377\374',
	STMSWord2011E193LastDataRecord = '\002P\377\373'
};
typedef enum STMSWord2011E193 STMSWord2011E193;

enum STMSWord2011E194 {
	STMSWord2011E194DefaultFirstRecord = '\000\000\000\001',
	STMSWord2011E194DefaultLastRecord = '\377\377\377\360'
};
typedef enum STMSWord2011E194 STMSWord2011E194;

enum STMSWord2011E195 {
	STMSWord2011E195NoMergeInfo = '\002R\377\377',
	STMSWord2011E195MergeInfoFromWord = '\002S\000\000',
	STMSWord2011E195MergeInfoFromAccessDde = '\002S\000\001',
	STMSWord2011E195MergeInfoFromExcelDde = '\002S\000\002',
	STMSWord2011E195MergeInfoFromMsqueryDde = '\002S\000\003',
	STMSWord2011E195MergeInfoFromOdbc = '\002S\000\004'
};
typedef enum STMSWord2011E195 STMSWord2011E195;

enum STMSWord2011E196 {
	STMSWord2011E196MergeIfEqual = '\002T\000\000',
	STMSWord2011E196MergeIfNotEqual = '\002T\000\001',
	STMSWord2011E196MergeIfLessThan = '\002T\000\002',
	STMSWord2011E196MergeIfGreaterThan = '\002T\000\003',
	STMSWord2011E196MergeIfLessThanOrEqual = '\002T\000\004',
	STMSWord2011E196MergeIfGreaterThanOrEqual = '\002T\000\005',
	STMSWord2011E196MergeIfIsBlank = '\002T\000\006',
	STMSWord2011E196MergeIfIsNotBlank = '\002T\000\007'
};
typedef enum STMSWord2011E196 STMSWord2011E196;

enum STMSWord2011E197 {
	STMSWord2011E197SortByName = '\002U\000\000',
	STMSWord2011E197SortByLocation = '\002U\000\001'
};
typedef enum STMSWord2011E197 STMSWord2011E197;

enum STMSWord2011E198 {
	STMSWord2011E198WindowStateNormal = '\002V\000\000',
	STMSWord2011E198WindowStateMaximize = '\002V\000\001',
	STMSWord2011E198WindowStateMinimize = '\002V\000\002'
};
typedef enum STMSWord2011E198 STMSWord2011E198;

enum STMSWord2011E199 {
	STMSWord2011E199LinkNone = '\002W\000\000',
	STMSWord2011E199LinkDataInDoc = '\002W\000\001',
	STMSWord2011E199LinkDataOnDisk = '\002W\000\002'
};
typedef enum STMSWord2011E199 STMSWord2011E199;

enum STMSWord2011E200 {
	STMSWord2011E200LinkTypeOle = '\002X\000\000',
	STMSWord2011E200LinkTypePicture = '\002X\000\001',
	STMSWord2011E200LinkTypeText = '\002X\000\002',
	STMSWord2011E200LinkTypeReference = '\002X\000\003',
	STMSWord2011E200LinkTypeInclude = '\002X\000\004',
	STMSWord2011E200LinkTypeImport = '\002X\000\005',
	STMSWord2011E200LinkTypeDde = '\002X\000\006',
	STMSWord2011E200LinkTypeDdeauto = '\002X\000\007',
	STMSWord2011E200LinkTypeChart = '\002X\000\010'
};
typedef enum STMSWord2011E200 STMSWord2011E200;

enum STMSWord2011E201 {
	STMSWord2011E201WindowDocument = '\002Y\000\000',
	STMSWord2011E201WindowTemplate = '\002Y\000\001'
};
typedef enum STMSWord2011E201 STMSWord2011E201;

enum STMSWord2011E202 {
	STMSWord2011E202NormalView = '\002Z\000\001',
	STMSWord2011E202DraftView = '\002Z\000\001',
	STMSWord2011E202OutlineView = '\002Z\000\002',
	STMSWord2011E202PageView = '\002Z\000\003',
	STMSWord2011E202PrintView = '\002Z\000\003',
	STMSWord2011E202PrintPreviewView = '\002Z\000\004',
	STMSWord2011E202MasterView = '\002Z\000\005',
	STMSWord2011E202OnlineView = '\002Z\000\006',
	STMSWord2011E202WordNoteView = '\002Z\000\007',
	STMSWord2011E202PublishingView = '\002Z\000\010',
	STMSWord2011E202ConflictView = '\002Z\000\011'
};
typedef enum STMSWord2011E202 STMSWord2011E202;

enum STMSWord2011E203 {
	STMSWord2011E203SeekMainDocument = '\002[\000\000',
	STMSWord2011E203SeekPrimaryHeader = '\002[\000\001',
	STMSWord2011E203SeekFirstPageHeader = '\002[\000\002',
	STMSWord2011E203SeekEvenPagesHeader = '\002[\000\003',
	STMSWord2011E203SeekPrimaryFooter = '\002[\000\004',
	STMSWord2011E203SeekFirstPageFooter = '\002[\000\005',
	STMSWord2011E203SeekEvenPagesFooter = '\002[\000\006',
	STMSWord2011E203SeekFootnotes = '\002[\000\007',
	STMSWord2011E203SeekEndnotes = '\002[\000\010',
	STMSWord2011E203SeekCurrentPageHeader = '\002[\000\011',
	STMSWord2011E203SeekCurrentPageFooter = '\002[\000\012'
};
typedef enum STMSWord2011E203 STMSWord2011E203;

enum STMSWord2011E204 {
	STMSWord2011E204PaneNone = '\002\\\000\000',
	STMSWord2011E204PanePrimaryHeader = '\002\\\000\001',
	STMSWord2011E204PaneFirstPageHeader = '\002\\\000\002',
	STMSWord2011E204PaneEvenPagesHeader = '\002\\\000\003',
	STMSWord2011E204PanePrimaryFooter = '\002\\\000\004',
	STMSWord2011E204PaneFirstPageFooter = '\002\\\000\005',
	STMSWord2011E204PaneEvenPagesFooter = '\002\\\000\006',
	STMSWord2011E204PaneFootnotes = '\002\\\000\007',
	STMSWord2011E204PaneEndnotes = '\002\\\000\010',
	STMSWord2011E204PaneFootnoteContinuationNotice = '\002\\\000\011',
	STMSWord2011E204PaneFootnoteContinuationSeparator = '\002\\\000\012',
	STMSWord2011E204PaneFootnoteSeparator = '\002\\\000\013',
	STMSWord2011E204PaneEndnoteContinuationNotice = '\002\\\000\014',
	STMSWord2011E204PaneEndnoteContinuationSeparator = '\002\\\000\015',
	STMSWord2011E204PaneEndnoteSeparator = '\002\\\000\016',
	STMSWord2011E204PaneComments = '\002\\\000\017',
	STMSWord2011E204PaneCurrentPageHeader = '\002\\\000\020',
	STMSWord2011E204PaneCurrentPageFooter = '\002\\\000\021',
	STMSWord2011E204PaneRevisions = '\002\\\000\022'
};
typedef enum STMSWord2011E204 STMSWord2011E204;

enum STMSWord2011E205 {
	STMSWord2011E205PageFitNone = '\002]\000\000',
	STMSWord2011E205PageFitFullPage = '\002]\000\001',
	STMSWord2011E205PageFitBestFit = '\002]\000\002'
};
typedef enum STMSWord2011E205 STMSWord2011E205;

enum STMSWord2011E206 {
	STMSWord2011E206BrowsePage = '\002^\000\001',
	STMSWord2011E206BrowseSection = '\002^\000\002',
	STMSWord2011E206BrowseComment = '\002^\000\003',
	STMSWord2011E206BrowseFootnote = '\002^\000\004',
	STMSWord2011E206BrowseEndnote = '\002^\000\005',
	STMSWord2011E206BrowseField = '\002^\000\006',
	STMSWord2011E206BrowseTable = '\002^\000\007',
	STMSWord2011E206BrowseGraphic = '\002^\000\010',
	STMSWord2011E206BrowseHeading = '\002^\000\011',
	STMSWord2011E206BrowseEdit = '\002^\000\012',
	STMSWord2011E206BrowseFind = '\002^\000\013',
	STMSWord2011E206BrowseGoTo = '\002^\000\014'
};
typedef enum STMSWord2011E206 STMSWord2011E206;

enum STMSWord2011E207 {
	STMSWord2011E207PrinterDefaultBin = '\002_\000\000',
	STMSWord2011E207PrinterUpperBin = '\002_\000\001',
	STMSWord2011E207PrinterOnlyBin = '\002_\000\001',
	STMSWord2011E207PrinterLowerBin = '\002_\000\002',
	STMSWord2011E207PrinterMiddleBin = '\002_\000\003',
	STMSWord2011E207PrinterManualFeed = '\002_\000\004',
	STMSWord2011E207PrinterEnvelopeFeed = '\002_\000\005',
	STMSWord2011E207PrinterManualEnvelopeFeed = '\002_\000\006',
	STMSWord2011E207PrinterAutomaticSheetFeed = '\002_\000\007',
	STMSWord2011E207PrinterTractorFeed = '\002_\000\010',
	STMSWord2011E207PrinterSmallFormatBin = '\002_\000\011',
	STMSWord2011E207PrinterLargeFormatBin = '\002_\000\012',
	STMSWord2011E207PrinterLargeCapacityBin = '\002_\000\013',
	STMSWord2011E207PrinterPaperCassette = '\002_\000\016',
	STMSWord2011E207PrinterFormSource = '\002_\000\017'
};
typedef enum STMSWord2011E207 STMSWord2011E207;

enum STMSWord2011E208 {
	STMSWord2011E208OrientPortrait = '\002`\000\000',
	STMSWord2011E208OrientLandscape = '\002`\000\001'
};
typedef enum STMSWord2011E208 STMSWord2011E208;

enum STMSWord2011E209 {
	STMSWord2011E209NoSelection = '\002a\000\000',
	STMSWord2011E209SelectionIp = '\002a\000\001',
	STMSWord2011E209SelectionNormal = '\002a\000\002',
	STMSWord2011E209SelectionFrame = '\002a\000\003',
	STMSWord2011E209SelectionColumn = '\002a\000\004',
	STMSWord2011E209SelectionRow = '\002a\000\005',
	STMSWord2011E209SelectionBlock = '\002a\000\006',
	STMSWord2011E209SelectionInlineShape = '\002a\000\007',
	STMSWord2011E209SelectionShape = '\002a\000\010'
};
typedef enum STMSWord2011E209 STMSWord2011E209;

enum STMSWord2011E210 {
	STMSWord2011E210CaptionFigure = '\002a\377\377',
	STMSWord2011E210CaptionTable = '\002a\377\376',
	STMSWord2011E210CaptionEquation = '\002a\377\375'
};
typedef enum STMSWord2011E210 STMSWord2011E210;

enum STMSWord2011E211 {
	STMSWord2011E211ReferenceTypeNumberedItem = '\002c\000\000',
	STMSWord2011E211ReferenceTypeHeading = '\002c\000\001',
	STMSWord2011E211ReferenceTypeBookmark = '\002c\000\002',
	STMSWord2011E211ReferenceTypeFootnote = '\002c\000\003',
	STMSWord2011E211ReferenceTypeEndnote = '\002c\000\004'
};
typedef enum STMSWord2011E211 STMSWord2011E211;

enum STMSWord2011E212 {
	STMSWord2011E212ReferenceContentText = '\002c\377\377',
	STMSWord2011E212ReferenceNumberRelativeContext = '\002c\377\376',
	STMSWord2011E212ReferenceNumberNoContext = '\002c\377\375',
	STMSWord2011E212ReferenceNumberFullContext = '\002c\377\374',
	STMSWord2011E212ReferenceEntireCaption = '\002d\000\002',
	STMSWord2011E212ReferenceOnlyLabelAndNumber = '\002d\000\003',
	STMSWord2011E212ReferenceOnlyCaptionText = '\002d\000\004',
	STMSWord2011E212ReferenceFootnoteNumber = '\002d\000\005',
	STMSWord2011E212ReferenceEndnoteNumber = '\002d\000\006',
	STMSWord2011E212ReferencePageNumber = '\002d\000\007',
	STMSWord2011E212ReferencePosition = '\002d\000\017',
	STMSWord2011E212ReferenceFootnoteNumberFormatted = '\002d\000\020',
	STMSWord2011E212ReferenceEndnoteNumberFormatted = '\002d\000\021'
};
typedef enum STMSWord2011E212 STMSWord2011E212;

enum STMSWord2011E213 {
	STMSWord2011E213IndexTemplate = '\002e\000\000',
	STMSWord2011E213IndexClassic = '\002e\000\001',
	STMSWord2011E213IndexFancy = '\002e\000\002',
	STMSWord2011E213IndexModern = '\002e\000\003',
	STMSWord2011E213IndexBulleted = '\002e\000\004',
	STMSWord2011E213IndexFormal = '\002e\000\005',
	STMSWord2011E213IndexSimple = '\002e\000\006'
};
typedef enum STMSWord2011E213 STMSWord2011E213;

enum STMSWord2011E214 {
	STMSWord2011E214IndexIndent = '\002f\000\000',
	STMSWord2011E214IndexRunin = '\002f\000\001'
};
typedef enum STMSWord2011E214 STMSWord2011E214;

enum STMSWord2011E215 {
	STMSWord2011E215WrapNever = '\002g\000\000',
	STMSWord2011E215WrapAlways = '\002g\000\001',
	STMSWord2011E215WrapAsk = '\002g\000\002'
};
typedef enum STMSWord2011E215 STMSWord2011E215;

enum STMSWord2011E216 {
	STMSWord2011E216NoRevision = '\002h\000\000',
	STMSWord2011E216RevisionInsert = '\002h\000\001',
	STMSWord2011E216RevisionDelete = '\002h\000\002',
	STMSWord2011E216RevisionProperty = '\002h\000\003',
	STMSWord2011E216RevisionParagraphNumber = '\002h\000\004',
	STMSWord2011E216RevisionDisplayField = '\002h\000\005',
	STMSWord2011E216RevisionReconcile = '\002h\000\006',
	STMSWord2011E216RevisionConflict = '\002h\000\007',
	STMSWord2011E216RevisionStyle = '\002h\000\010',
	STMSWord2011E216RevisionReplace = '\002h\000\011',
	STMSWord2011E216RevisionParagraphProperty = '\002h\000\012',
	STMSWord2011E216RevisionTableProperty = '\002h\000\013',
	STMSWord2011E216RevisionSectionProperty = '\002h\000\014',
	STMSWord2011E216RevisionStyleDefinition = '\002h\000\015',
	STMSWord2011E216RevisionMoveFrom = '\002h\000\016',
	STMSWord2011E216RevisionMoveTo = '\002h\000\017',
	STMSWord2011E216RevisionCellInsertion = '\002h\000\020',
	STMSWord2011E216RevisionCellDeletion = '\002h\000\021',
	STMSWord2011E216RevisionCellMerge = '\002h\000\022',
	STMSWord2011E216RevisionCellSplit = '\002h\000\023',
	STMSWord2011E216RevisionConflictInsert = '\002h\000\024',
	STMSWord2011E216RevisionConflictDelete = '\002h\000\025'
};
typedef enum STMSWord2011E216 STMSWord2011E216;

enum STMSWord2011E217 {
	STMSWord2011E217OneAfterAnother = '\002i\000\000',
	STMSWord2011E217AllAtOnce = '\002i\000\001'
};
typedef enum STMSWord2011E217 STMSWord2011E217;

enum STMSWord2011E218 {
	STMSWord2011E218NotYetRouted = '\002j\000\000',
	STMSWord2011E218RouteInProgress = '\002j\000\001',
	STMSWord2011E218RouteComplete = '\002j\000\002'
};
typedef enum STMSWord2011E218 STMSWord2011E218;

enum STMSWord2011E219 {
	STMSWord2011E219SectionContinuous = '\002k\000\000',
	STMSWord2011E219SectionNewColumn = '\002k\000\001',
	STMSWord2011E219SectionNewPage = '\002k\000\002',
	STMSWord2011E219SectionEvenPage = '\002k\000\003',
	STMSWord2011E219SectionOddPage = '\002k\000\004'
};
typedef enum STMSWord2011E219 STMSWord2011E219;

enum STMSWord2011E220 {
	STMSWord2011E220DoNotSaveChanges = '\002l\000\000',
	STMSWord2011E220SaveChanges = '\002k\377\377',
	STMSWord2011E220PromptToSaveChanges = '\002k\377\376'
};
typedef enum STMSWord2011E220 STMSWord2011E220;

enum STMSWord2011E221 {
	STMSWord2011E221DocumentNotSpecified = '\002m\000\000',
	STMSWord2011E221DocumentLetter = '\002m\000\001',
	STMSWord2011E221DocumentEmail = '\002m\000\002'
};
typedef enum STMSWord2011E221 STMSWord2011E221;

enum STMSWord2011E222 {
	STMSWord2011E222TypeDocument = '\002n\000\000',
	STMSWord2011E222TypeTemplate = '\002n\000\001'
};
typedef enum STMSWord2011E222 STMSWord2011E222;

enum STMSWord2011E223 {
	STMSWord2011E223WordDocument = '\002o\000\000',
	STMSWord2011E223OriginalDocumentFormat = '\002o\000\001',
	STMSWord2011E223PromptUser = '\002o\000\002'
};
typedef enum STMSWord2011E223 STMSWord2011E223;

enum STMSWord2011E224 {
	STMSWord2011E224RelocateUp = '\002p\000\000',
	STMSWord2011E224RelocateDown = '\002p\000\001'
};
typedef enum STMSWord2011E224 STMSWord2011E224;

enum STMSWord2011E225 {
	STMSWord2011E225InsertedTextMarkNone = '\002q\000\000',
	STMSWord2011E225InsertedTextMarkBold = '\002q\000\001',
	STMSWord2011E225InsertedTextMarkItalic = '\002q\000\002',
	STMSWord2011E225InsertedTextMarkUnderline = '\002q\000\003',
	STMSWord2011E225InsertedTextMarkDoubleUnderline = '\002q\000\004',
	STMSWord2011E225InsertedTextMarkColorOnly = '\002q\000\005',
	STMSWord2011E225InsertedTextMarkStrikeThrough = '\002q\000\006',
	STMSWord2011E225InsertedTextMarkDoubleStrikeThrough = '\002q\000\007'
};
typedef enum STMSWord2011E225 STMSWord2011E225;

enum STMSWord2011E226 {
	STMSWord2011E226RevisedLinesMarkNone = '\002r\000\000',
	STMSWord2011E226RevisedLinesMarkLeftBorder = '\002r\000\001',
	STMSWord2011E226RevisedLinesMarkRightBorder = '\002r\000\002',
	STMSWord2011E226RevisedLinesMarkOutsideBorder = '\002r\000\003'
};
typedef enum STMSWord2011E226 STMSWord2011E226;

enum STMSWord2011E227 {
	STMSWord2011E227DeletedTextMarkHidden = '\002s\000\000',
	STMSWord2011E227DeletedTextMarkStrikeThrough = '\002s\000\001',
	STMSWord2011E227DeletedTextMarkCaret = '\002s\000\002',
	STMSWord2011E227DeletedTextMarkPound = '\002s\000\003',
	STMSWord2011E227DeletedTextMarkNone = '\002s\000\004',
	STMSWord2011E227DeletedTextMarkBold = '\002s\000\005',
	STMSWord2011E227DeletedTextMarkItalic = '\002s\000\006',
	STMSWord2011E227DeletedTextMarkUnderline = '\002s\000\007',
	STMSWord2011E227DeletedTextMarkDoubleUnderline = '\002s\000\010',
	STMSWord2011E227DeletedTextMarkColorOnly = '\002s\000\011',
	STMSWord2011E227DeletedTextMarkDoubleStrikeThrough = '\002s\000\012'
};
typedef enum STMSWord2011E227 STMSWord2011E227;

enum STMSWord2011E228 {
	STMSWord2011E228RevisedPropertiesMarkNone = '\002t\000\000',
	STMSWord2011E228RevisedPropertiesMarkBold = '\002t\000\001',
	STMSWord2011E228RevisedPropertiesMarkItalic = '\002t\000\002',
	STMSWord2011E228RevisedPropertiesMarkUnderline = '\002t\000\003',
	STMSWord2011E228RevisedPropertiesMarkDoubleUnderline = '\002t\000\004',
	STMSWord2011E228RevisedPropertiesMarkColorOnly = '\002t\000\005',
	STMSWord2011E228RevisedPropertiesMarkStrikeThrough = '\002t\000\006',
	STMSWord2011E228RevisedPropertiesMarkDoubleStrikeThrough = '\002t\000\007'
};
typedef enum STMSWord2011E228 STMSWord2011E228;

enum STMSWord2011E316 {
	STMSWord2011E316MoveToTextMarkNone = '\002\314\000\000',
	STMSWord2011E316MoveToTextMarkBold = '\002\314\000\001',
	STMSWord2011E316MoveToTextMarkItalic = '\002\314\000\002',
	STMSWord2011E316MoveToTextMarkUnderline = '\002\314\000\003',
	STMSWord2011E316MoveToTextMarkDoubleUnderline = '\002\314\000\004',
	STMSWord2011E316MoveToTextMarkColorOnly = '\002\314\000\005',
	STMSWord2011E316MoveToTextMarkStrikeThrough = '\002\314\000\006',
	STMSWord2011E316MoveToTextMarkDoubleStrikeThrough = '\002\314\000\007'
};
typedef enum STMSWord2011E316 STMSWord2011E316;

enum STMSWord2011E319 {
	STMSWord2011E319MathAccentType = '\002\317\000\001',
	STMSWord2011E319MathFunctionBarType = '\002\317\000\002',
	STMSWord2011E319MathBoxType = '\002\317\000\003',
	STMSWord2011E319MathBoxedFormulaType = '\002\317\000\004',
	STMSWord2011E319MathDelimitersType = '\002\317\000\005',
	STMSWord2011E319MathEquationArrayType = '\002\317\000\006',
	STMSWord2011E319MathFractionType = '\002\317\000\007',
	STMSWord2011E319MathFunctionApplyType = '\002\317\000\010',
	STMSWord2011E319MathStretchStackType = '\002\317\000\011',
	STMSWord2011E319MathLowerLimitType = '\002\317\000\012',
	STMSWord2011E319MathUpperLimitType = '\002\317\000\013',
	STMSWord2011E319MathMatrixType = '\002\317\000\014',
	STMSWord2011E319MathNaryOperatorType = '\002\317\000\015',
	STMSWord2011E319MathPhantomType = '\002\317\000\016',
	STMSWord2011E319MathLeftSubSuperscriptType = '\002\317\000\017',
	STMSWord2011E319MathRadicalType = '\002\317\000\020',
	STMSWord2011E319MathSubscriptType = '\002\317\000\021',
	STMSWord2011E319MathSubSuperscriptType = '\002\317\000\022',
	STMSWord2011E319MathSuperscriptType = '\002\317\000\023',
	STMSWord2011E319MathTextType = '\002\317\000\024',
	STMSWord2011E319MathNormalTextType = '\002\317\000\025',
	STMSWord2011E319MathLiteralTextType = '\002\317\000\026'
};
typedef enum STMSWord2011E319 STMSWord2011E319;

enum STMSWord2011E320 {
	STMSWord2011E320EquationHorizontalAlignCenter = '\002\320\000\000',
	STMSWord2011E320EquationHorizontalAlignLeft = '\002\320\000\001',
	STMSWord2011E320EquationHorizontalAlignRight = '\002\320\000\002'
};
typedef enum STMSWord2011E320 STMSWord2011E320;

enum STMSWord2011E321 {
	STMSWord2011E321EquationVerticalAlignCenter = '\002\321\000\000',
	STMSWord2011E321EquationVerticalAlignTop = '\002\321\000\001',
	STMSWord2011E321EquationVerticalAlignBottom = '\002\321\000\002'
};
typedef enum STMSWord2011E321 STMSWord2011E321;

enum STMSWord2011E322 {
	STMSWord2011E322MathFractionTypeBar = '\002\322\000\000',
	STMSWord2011E322MathFractionTypeStack = '\002\322\000\001',
	STMSWord2011E322MathFractionTypeSlashed = '\002\322\000\002',
	STMSWord2011E322MathFractionTypeLinear = '\002\322\000\003'
};
typedef enum STMSWord2011E322 STMSWord2011E322;

enum STMSWord2011E323 {
	STMSWord2011E323EquationSpacingSingle = '\002\323\000\000',
	STMSWord2011E323EquationSpacingOneAndAHalf = '\002\323\000\001',
	STMSWord2011E323EquationSpacingDouble = '\002\323\000\002',
	STMSWord2011E323EquationSpacingExactly = '\002\323\000\003',
	STMSWord2011E323EquationSpacingMultiple = '\002\323\000\004'
};
typedef enum STMSWord2011E323 STMSWord2011E323;

enum STMSWord2011E324 {
	STMSWord2011E324EquationDisplayProfessional = '\002\324\000\000' /* Specifies an equation is displayed in professional/built up format. */,
	STMSWord2011E324EquationDisplayInline = '\002\324\000\001' /* Specifies an equation is displayed in linear/built down style. */
};
typedef enum STMSWord2011E324 STMSWord2011E324;

enum STMSWord2011E325 {
	STMSWord2011E325MathDelimitersCenterVertically = '\002\325\000\000',
	STMSWord2011E325MathDelimitersMatchContentSize = '\002\325\000\001'
};
typedef enum STMSWord2011E325 STMSWord2011E325;

enum STMSWord2011E326 {
	STMSWord2011E326EquationJustificationCenterGroup = '\002\326\000\001',
	STMSWord2011E326EquationJustificationCenter = '\002\326\000\002',
	STMSWord2011E326EquationJustificationLeft = '\002\326\000\003',
	STMSWord2011E326EquationJustificationRight = '\002\326\000\004',
	STMSWord2011E326EquationJustificationInline = '\002\326\000\007'
};
typedef enum STMSWord2011E326 STMSWord2011E326;

enum STMSWord2011E327 {
	STMSWord2011E327MathBinaryOperatorBreakBefore = '\002\327\000\000',
	STMSWord2011E327MathBinaryOperatorBreakAfter = '\002\327\000\001',
	STMSWord2011E327MathBinaryOperatorRepeat = '\002\327\000\002'
};
typedef enum STMSWord2011E327 STMSWord2011E327;

enum STMSWord2011E328 {
	STMSWord2011E328MinusMinus = '\002\330\000\000',
	STMSWord2011E328PlusMinus = '\002\330\000\001',
	STMSWord2011E328MinusPlus = '\002\330\000\002'
};
typedef enum STMSWord2011E328 STMSWord2011E328;

enum STMSWord2011E329 {
	STMSWord2011E329BuildingBlockEquations = '\000\000\000\003'
};
typedef enum STMSWord2011E329 STMSWord2011E329;

enum STMSWord2011E330 {
	STMSWord2011E330InlineBuildingBlock = '\000\000\000\000',
	STMSWord2011E330PageLevelBuildingBlock = '\000\000\000\001',
	STMSWord2011E330ParagraphLevelBuildingBlock = '\000\000\000\002'
};
typedef enum STMSWord2011E330 STMSWord2011E330;

enum STMSWord2011E317 {
	STMSWord2011E317MoveFromTextMarkHidden = '\002\315\000\000',
	STMSWord2011E317MoveFromTextMarkDoubleStrikeThrough = '\002\315\000\001',
	STMSWord2011E317MoveFromTextMarkStrikeThrough = '\002\315\000\002',
	STMSWord2011E317MoveFromTextMarkCaret = '\002\315\000\003',
	STMSWord2011E317MoveFromTextMarkPound = '\002\315\000\004',
	STMSWord2011E317MoveFromTextMarkNone = '\002\315\000\005',
	STMSWord2011E317MoveFromTextMarkBold = '\002\315\000\006',
	STMSWord2011E317MoveFromTextMarkItalic = '\002\315\000\007',
	STMSWord2011E317MoveFromTextMarkUnderline = '\002\315\000\010',
	STMSWord2011E317MoveFromTextMarkDoubleUnderline = '\002\315\000\011',
	STMSWord2011E317MoveFromTextMarkColorOnly = '\002\315\000\012'
};
typedef enum STMSWord2011E317 STMSWord2011E317;

enum STMSWord2011E318 {
	STMSWord2011E318CellColorByAuthor = '\002\315\377\377',
	STMSWord2011E318CellColorNoHighlight = '\002\316\000\000',
	STMSWord2011E318CellColorPink = '\002\316\000\001',
	STMSWord2011E318CellColorLightBlue = '\002\316\000\002',
	STMSWord2011E318CellColorLightYellow = '\002\316\000\003',
	STMSWord2011E318CellColorLightPurple = '\002\316\000\004',
	STMSWord2011E318CellColorLightOrange = '\002\316\000\005',
	STMSWord2011E318CellColorLightGreen = '\002\316\000\006',
	STMSWord2011E318CellColorLightGray = '\002\316\000\007'
};
typedef enum STMSWord2011E318 STMSWord2011E318;

enum STMSWord2011E229 {
	STMSWord2011E229FieldShadingNever = '\002u\000\000',
	STMSWord2011E229FieldShadingAlways = '\002u\000\001',
	STMSWord2011E229FieldShadingWhenSelected = '\002u\000\002'
};
typedef enum STMSWord2011E229 STMSWord2011E229;

enum STMSWord2011E230 {
	STMSWord2011E230DocumentsPath = '\002v\000\000',
	STMSWord2011E230PicturesPath = '\002v\000\001',
	STMSWord2011E230UserTemplatesPath = '\002v\000\002',
	STMSWord2011E230WorkgroupTemplatesPath = '\002v\000\003',
	STMSWord2011E230UserOptionsPath = '\002v\000\004',
	STMSWord2011E230AutoRecoverPath = '\002v\000\005',
	STMSWord2011E230ToolsPath = '\002v\000\006',
	STMSWord2011E230TutorialPath = '\002v\000\007',
	STMSWord2011E230StartupPath = '\002v\000\010',
	STMSWord2011E230ProgramPath = '\002v\000\011',
	STMSWord2011E230GraphicsFiltersPath = '\002v\000\012',
	STMSWord2011E230TextConvertersPath = '\002v\000\013',
	STMSWord2011E230ProofingToolsPath = '\002v\000\014',
	STMSWord2011E230TempFilePath = '\002v\000\015',
	STMSWord2011E230CurrentFolderPath = '\002v\000\016',
	STMSWord2011E230StyleGalleryPath = '\002v\000\017',
	STMSWord2011E230TrashPath = '\002v\000\020',
	STMSWord2011E230OfficePath = '\002v\000\021',
	STMSWord2011E230TypeLibrariesPath = '\002v\000\022',
	STMSWord2011E230BorderArtPath = '\002v\000\023'
};
typedef enum STMSWord2011E230 STMSWord2011E230;

enum STMSWord2011E231 {
	STMSWord2011E231NoTabHangingIndent = '\002w\000\001',
	STMSWord2011E231NoSpaceForRaisedOrLoweredCharacters = '\002w\000\002',
	STMSWord2011E231PrintColorsBlack = '\002w\000\003',
	STMSWord2011E231WrapTrailSpaces = '\002w\000\004',
	STMSWord2011E231NoColumnBalance = '\002w\000\005',
	STMSWord2011E231ConvertDataMergeEscapes = '\002w\000\006',
	STMSWord2011E231SuppressSpaceBeforeAfterPageBreak = '\002w\000\007',
	STMSWord2011E231SuppressTopSpacing = '\002w\000\010',
	STMSWord2011E231OriginalWordTableRules = '\002w\000\011',
	STMSWord2011E231TransparentMetafiles = '\002w\000\012',
	STMSWord2011E231ShowBreaksInFrames = '\002w\000\013',
	STMSWord2011E231SwapBordersFacingPages = '\002w\000\014',
	STMSWord2011E231LeaveBackslashAlone = '\002w\000\015',
	STMSWord2011E231ExpandShiftReturn = '\002w\000\016',
	STMSWord2011E231DoNotUnderlineTrailingSpaces = '\002w\000\017',
	STMSWord2011E231DoNotBalanceSBCSAndDBCSCharacters = '\002w\000\020',
	STMSWord2011E231SuppressTopSpacingMacWord5 = '\002w\000\021',
	STMSWord2011E231SpacingInWholePoints = '\002w\000\022',
	STMSWord2011E231PrintBodyTextBeforeHeader = '\002w\000\023',
	STMSWord2011E231NoExtraSpaceBetweenRowsOfText = '\002w\000\024',
	STMSWord2011E231NoSpaceForUnderlines = '\002w\000\025',
	STMSWord2011E231UseLargerSmallCaps = '\002w\000\026',
	STMSWord2011E231NoExtraLineSpacing = '\002w\000\027',
	STMSWord2011E231TruncateFontHeight = '\002w\000\030',
	STMSWord2011E231SubstituteFontBySize = '\002w\000\031',
	STMSWord2011E231UsePrinterMetrics = '\002w\000\032',
	STMSWord2011E231Word6BorderRules = '\002w\000\033',
	STMSWord2011E231ExactOnTop = '\002w\000\034',
	STMSWord2011E231SuppressBottomSpacing = '\002w\000\035',
	STMSWord2011E231WordPerfectSpaceWidth = '\002w\000\036',
	STMSWord2011E231WordPerfectJustification = '\002w\000\037',
	STMSWord2011E231Word6LineWrap = '\002w\000 ',
	STMSWord2011E231Word96ShapeLayout = '\002w\000!',
	STMSWord2011E231Word98FootnoteLayout = '\002w\000\"',
	STMSWord2011E231DoNotUseHtmlParagraphAutoSpacing = '\002w\000#',
	STMSWord2011E231DoNotAdjustLineHeightInTable = '\002w\000$',
	STMSWord2011E231ForgetLastTabAlignment = '\002w\000%',
	STMSWord2011E231Word95AutoSpace = '\002w\000&',
	STMSWord2011E231AlignTablesRowByRow = '\002w\000\'',
	STMSWord2011E231LayoutRawTableWidth = '\002w\000(',
	STMSWord2011E231LayoutTableRowsApart = '\002w\000)',
	STMSWord2011E231UseWord97LineBreakingRules = '\002w\000*',
	STMSWord2011E231DoNotBreakWrappedTables = '\002w\000+',
	STMSWord2011E231GrowAutofit = '\002w\000,',
	STMSWord2011E231DoNotSnapTextToGridInTableWithObjects = '\002w\000-',
	STMSWord2011E231SelectFieldWithFirstOrLastCharacter = '\002w\000.',
	STMSWord2011E231ApplyBreakingRules = '\002w\000/',
	STMSWord2011E231DoNotWrapTextWithPunctuation = '\002w\0000',
	STMSWord2011E231DoNotUseAsianBreakRulesInGrid = '\002w\0001',
	STMSWord2011E231UseWord2002TableStyleRules = '\002w\0002'
};
typedef enum STMSWord2011E231 STMSWord2011E231;

enum STMSWord2011E314 {
	STMSWord2011E314DefaultCompatibilitySettings = '\002\312\000\000' /* Microsoft Word 2007-2008 */,
	STMSWord2011E314Word20002004AndX = '\002\312\000\014' /* Microsoft Word 2000-2004 and X */,
	STMSWord2011E314Word97And98 = '\002\312\000\001' /* Microsoft Word 97-98 */,
	STMSWord2011E314Word6And95 = '\002\312\000\002' /* Microsoft Word 6.0/95 */,
	STMSWord2011E314WinWord1 = '\002\312\000\003' /* Word for Windows 1.0 */,
	STMSWord2011E314WinWord2 = '\002\312\000\004' /* Word for Windows 2.0 */,
	STMSWord2011E314MacWord5 = '\002\312\000\005' /* Word for the Macintosh 5.x */,
	STMSWord2011E314DosWord = '\002\312\000\006' /* Word for MS-DOS */,
	STMSWord2011E314Wordperfect5 = '\002\312\000\007' /* WordPerfect 5.x */,
	STMSWord2011E314WinWordperfect6 = '\002\312\000\010' /* WordPerfect 6.x for Windows */,
	STMSWord2011E314DosWordperfect6 = '\002\312\000\011' /* WordPerfect 6.0 for DOS */,
	STMSWord2011E314AsianWord97And98 = '\002\312\000\012' /* Microsoft Word Asian Versions 97-98 */,
	STMSWord2011E314UsWord6And95 = '\002\312\000\013' /* US Microsoft Word for Windows 6.0/95 */,
	STMSWord2011E314CustomCompatibilitySettings = '\002\312\000\015' /* Custom settings */
};
typedef enum STMSWord2011E314 STMSWord2011E314;

enum STMSWord2011E232 {
	STMSWord2011E232PaperTenXFourteen = '\002x\000\000',
	STMSWord2011E232PaperElevenXSeventeen = '\002x\000\001',
	STMSWord2011E232PaperLetter = '\002x\000\002',
	STMSWord2011E232PaperLetterSmall = '\002x\000\003',
	STMSWord2011E232PaperLegal = '\002x\000\004',
	STMSWord2011E232PaperExecutive = '\002x\000\005',
	STMSWord2011E232PaperA3 = '\002x\000\006',
	STMSWord2011E232PaperA4 = '\002x\000\007',
	STMSWord2011E232PaperA4Small = '\002x\000\010',
	STMSWord2011E232PaperA5 = '\002x\000\011',
	STMSWord2011E232PaperB4 = '\002x\000\012',
	STMSWord2011E232PaperB5 = '\002x\000\013',
	STMSWord2011E232PaperCsheet = '\002x\000\014',
	STMSWord2011E232PaperDsheet = '\002x\000\015',
	STMSWord2011E232PaperEsheet = '\002x\000\016',
	STMSWord2011E232PaperFanfoldLegalGerman = '\002x\000\017',
	STMSWord2011E232PaperFanfoldStdGerman = '\002x\000\020',
	STMSWord2011E232PaperFanfoldUs = '\002x\000\021',
	STMSWord2011E232PaperFolio = '\002x\000\022',
	STMSWord2011E232PaperLedger = '\002x\000\023',
	STMSWord2011E232PaperNote = '\002x\000\024',
	STMSWord2011E232PaperQuarto = '\002x\000\025',
	STMSWord2011E232PaperStatement = '\002x\000\026',
	STMSWord2011E232PaperTabloid = '\002x\000\027',
	STMSWord2011E232PaperEnvelope9 = '\002x\000\030',
	STMSWord2011E232PaperEnvelope10 = '\002x\000\031',
	STMSWord2011E232PaperEnvelope11 = '\002x\000\032',
	STMSWord2011E232PaperEnvelope12 = '\002x\000\033',
	STMSWord2011E232PaperEnvelope14 = '\002x\000\034',
	STMSWord2011E232PaperEnvelopeB4 = '\002x\000\035',
	STMSWord2011E232PaperEnvelopeB5 = '\002x\000\036',
	STMSWord2011E232PaperEnvelopeB6 = '\002x\000\037',
	STMSWord2011E232PaperEnvelopeC3 = '\002x\000 ',
	STMSWord2011E232PaperEnvelopeC4 = '\002x\000!',
	STMSWord2011E232PaperEnvelopeC5 = '\002x\000\"',
	STMSWord2011E232PaperEnvelopeC6 = '\002x\000#',
	STMSWord2011E232PaperEnvelopeC65 = '\002x\000$',
	STMSWord2011E232PaperEnvelopeDl = '\002x\000%',
	STMSWord2011E232PaperEnvelopeItaly = '\002x\000&',
	STMSWord2011E232PaperEnvelopeMonarch = '\002x\000\'',
	STMSWord2011E232PaperEnvelopePersonal = '\002x\000(',
	STMSWord2011E232PaperCustom = '\002x\000)'
};
typedef enum STMSWord2011E232 STMSWord2011E232;

enum STMSWord2011E233 {
	STMSWord2011E233CustomLabelLetter = '\002y\000\000',
	STMSWord2011E233CustomLabelLetterLandscape = '\002y\000\001',
	STMSWord2011E233CustomLabelA4 = '\002y\000\002',
	STMSWord2011E233CustomLabelA4Landscape = '\002y\000\003',
	STMSWord2011E233CustomLabelA5 = '\002y\000\004',
	STMSWord2011E233CustomLabelA5Landscape = '\002y\000\005',
	STMSWord2011E233CustomLabelB5 = '\002y\000\006',
	STMSWord2011E233CustomLabelMini = '\002y\000\007',
	STMSWord2011E233CustomLabelFanfold = '\002y\000\010'
};
typedef enum STMSWord2011E233 STMSWord2011E233;

enum STMSWord2011E234 {
	STMSWord2011E234NoDocumentProtection = '\002y\377\377',
	STMSWord2011E234AllowOnlyRevisions = '\002z\000\000',
	STMSWord2011E234AllowOnlyComments = '\002z\000\001',
	STMSWord2011E234AllowOnlyFormFields = '\002z\000\002',
	STMSWord2011E234AllowOnlyReading = '\002z\000\003'
};
typedef enum STMSWord2011E234 STMSWord2011E234;

enum STMSWord2011E235 {
	STMSWord2011E235Adjective = '\002{\000\000',
	STMSWord2011E235Noun = '\002{\000\001',
	STMSWord2011E235Adverb = '\002{\000\002',
	STMSWord2011E235Verb = '\002{\000\003',
	STMSWord2011E235Pronoun = '\002{\000\004',
	STMSWord2011E235Conjunction = '\002{\000\005',
	STMSWord2011E235Preposition = '\002{\000\006',
	STMSWord2011E235Interjection = '\002{\000\007',
	STMSWord2011E235Idiom = '\002{\000\010',
	STMSWord2011E235Other = '\002{\000\011'
};
typedef enum STMSWord2011E235 STMSWord2011E235;

enum STMSWord2011E236 {
	STMSWord2011E236RelativeHorizontalPositionMargin = '\002|\000\000',
	STMSWord2011E236RelativeHorizontalPositionPage = '\002|\000\001',
	STMSWord2011E236RelativeHorizontalPositionColumn = '\002|\000\002',
	STMSWord2011E236RelativeHorizontalPositionCharacter = '\002|\000\003',
	STMSWord2011E236RelativeHorizontalPositionLeftMargin = '\002|\000\004',
	STMSWord2011E236RelativeHorizontalPositionRightMargin = '\002|\000\005',
	STMSWord2011E236RelativeHorizontalPositionInnerMargin = '\002|\000\006',
	STMSWord2011E236RelativeHorizontalPositionOuterMargin = '\002|\000\007'
};
typedef enum STMSWord2011E236 STMSWord2011E236;

enum STMSWord2011E237 {
	STMSWord2011E237RelativeVerticalPositionMargin = '\002}\000\000',
	STMSWord2011E237RelativeVerticalPositionPage = '\002}\000\001',
	STMSWord2011E237RelativeVerticalPositionParagraph = '\002}\000\002',
	STMSWord2011E237RelativeVerticalPositionLine = '\002}\000\003',
	STMSWord2011E237RelativeVerticalPositionTopMargin = '\002}\000\004',
	STMSWord2011E237RelativeVerticalPositionBottomMargin = '\002}\000\005',
	STMSWord2011E237RelativeVerticalPositionInnerMargin = '\002}\000\006',
	STMSWord2011E237RelativeVerticalPositionOuterMargin = '\002}\000\007'
};
typedef enum STMSWord2011E237 STMSWord2011E237;

enum STMSWord2011E238 {
	STMSWord2011E238Help = '\002~\000\000',
	STMSWord2011E238HelpAbout = '\002~\000\001',
	STMSWord2011E238HelpContents = '\002~\000\003',
	STMSWord2011E238HelpIndex = '\002~\000\005',
	STMSWord2011E238HelpPsshelp = '\002~\000\007',
	STMSWord2011E238HelpSearch = '\002~\000\011'
};
typedef enum STMSWord2011E238 STMSWord2011E238;

enum STMSWord2011E239 {
	STMSWord2011E239KeyCategoryNil = '\002~\377\377',
	STMSWord2011E239KeyCategoryDisable = '\002\177\000\000',
	STMSWord2011E239KeyCategoryCommand = '\002\177\000\001',
	STMSWord2011E239KeyCategoryMacro = '\002\177\000\002',
	STMSWord2011E239KeyCategoryFont = '\002\177\000\003',
	STMSWord2011E239KeyCategoryAutoText = '\002\177\000\004',
	STMSWord2011E239KeyCategoryStyle = '\002\177\000\005',
	STMSWord2011E239KeyCategorySymbol = '\002\177\000\006',
	STMSWord2011E239KeyCategoryPrefix = '\002\177\000\007'
};
typedef enum STMSWord2011E239 STMSWord2011E239;

enum STMSWord2011E240 {
	STMSWord2011E240No_key = '\002\200\000\377',
	STMSWord2011E240Shift_key = '\002\200\002\000',
	STMSWord2011E240Control_key = '\002\200\020\000',
	STMSWord2011E240Command_key = '\002\200\001\000',
	STMSWord2011E240Option_key = '\002\200\010\000',
	STMSWord2011E240KeyAlt = '\002\200\010\000',
	STMSWord2011E240A_key = '\002\200\000A',
	STMSWord2011E240B_key = '\002\200\000B',
	STMSWord2011E240C_key = '\002\200\000C',
	STMSWord2011E240D_key = '\002\200\000D',
	STMSWord2011E240E_key = '\002\200\000E',
	STMSWord2011E240F_key = '\002\200\000F',
	STMSWord2011E240G_key = '\002\200\000G',
	STMSWord2011E240H_key = '\002\200\000H',
	STMSWord2011E240I_Key = '\002\200\000I',
	STMSWord2011E240J_key = '\002\200\000J',
	STMSWord2011E240K_key = '\002\200\000K',
	STMSWord2011E240L_key = '\002\200\000L',
	STMSWord2011E240M_key = '\002\200\000M',
	STMSWord2011E240N_key = '\002\200\000N',
	STMSWord2011E240O_key = '\002\200\000O',
	STMSWord2011E240P_key = '\002\200\000P',
	STMSWord2011E240Q_key = '\002\200\000Q',
	STMSWord2011E240R_key = '\002\200\000R',
	STMSWord2011E240S_key = '\002\200\000S',
	STMSWord2011E240T_key = '\002\200\000T',
	STMSWord2011E240U_kwy = '\002\200\000U',
	STMSWord2011E240V_key = '\002\200\000V',
	STMSWord2011E240W_key = '\002\200\000W',
	STMSWord2011E240X_key = '\002\200\000X',
	STMSWord2011E240Y_key = '\002\200\000Y',
	STMSWord2011E240Z_key = '\002\200\000Z',
	STMSWord2011E240Key_number_0 = '\002\200\0000',
	STMSWord2011E240Key_number_1 = '\002\200\0001',
	STMSWord2011E240Key_numbe_2 = '\002\200\0002',
	STMSWord2011E240Key_numbe_3 = '\002\200\0003',
	STMSWord2011E240Key_number_4 = '\002\200\0004',
	STMSWord2011E240Key_number_5 = '\002\200\0005',
	STMSWord2011E240Key_number_6 = '\002\200\0006',
	STMSWord2011E240KeyNumber_7 = '\002\200\0007',
	STMSWord2011E240Key_number_8 = '\002\200\0008',
	STMSWord2011E240Key_number_9 = '\002\200\0009',
	STMSWord2011E240Backspace_key = '\002\200\000\010',
	STMSWord2011E240Tab_key = '\002\200\000\011',
	STMSWord2011E240Key_numeric_5_special = '\002\200\000\014',
	STMSWord2011E240Return_key = '\002\200\000\015',
	STMSWord2011E240Pause_key = '\002\200\000\023',
	STMSWord2011E240Esc_key = '\002\200\000\033',
	STMSWord2011E240Spacebar_key = '\002\200\000 ',
	STMSWord2011E240Page_up_key = '\002\200\000!',
	STMSWord2011E240Page_down_key = '\002\200\000\"',
	STMSWord2011E240End_key = '\002\200\000#',
	STMSWord2011E240Home_key = '\002\200\000$',
	STMSWord2011E240Insert_key = '\002\200\000-',
	STMSWord2011E240Delete_key = '\002\200\000.',
	STMSWord2011E240Key_numeric_0 = '\002\200\000`',
	STMSWord2011E240Key_numeric_1 = '\002\200\000a',
	STMSWord2011E240Key_numeric_2 = '\002\200\000b',
	STMSWord2011E240Key_numeric_3 = '\002\200\000c',
	STMSWord2011E240Key_numeric_4 = '\002\200\000d',
	STMSWord2011E240Key_numeric_5 = '\002\200\000e',
	STMSWord2011E240Key_numeric_6 = '\002\200\000f',
	STMSWord2011E240Key_numeric_7 = '\002\200\000g',
	STMSWord2011E240Key_numeric_8 = '\002\200\000h',
	STMSWord2011E240Key_numeric_9 = '\002\200\000i',
	STMSWord2011E240Key_numeric_multiply = '\002\200\000j',
	STMSWord2011E240Key_numeric_add = '\002\200\000k',
	STMSWord2011E240Key_numeric_subtract = '\002\200\000m',
	STMSWord2011E240Key_numeric_decimal = '\002\200\000n',
	STMSWord2011E240Key_numeric_divide = '\002\200\000o',
	STMSWord2011E240F1_key = '\002\200\000p',
	STMSWord2011E240F2_key = '\002\200\000q',
	STMSWord2011E240F3_key = '\002\200\000r',
	STMSWord2011E240F4_key = '\002\200\000s',
	STMSWord2011E240F5_key = '\002\200\000t',
	STMSWord2011E240F6_key = '\002\200\000u',
	STMSWord2011E240F7_key = '\002\200\000v',
	STMSWord2011E240F8_key = '\002\200\000w',
	STMSWord2011E240F9_key = '\002\200\000x',
	STMSWord2011E240F10_key = '\002\200\000y',
	STMSWord2011E240F11_key = '\002\200\000z',
	STMSWord2011E240F12_key = '\002\200\000{',
	STMSWord2011E240F13_key = '\002\200\000|',
	STMSWord2011E240F14_key = '\002\200\000}',
	STMSWord2011E240F15_key = '\002\200\000~',
	STMSWord2011E240F16_key = '\002\200\000\177',
	STMSWord2011E240Scroll_lock_key = '\002\200\000\221',
	STMSWord2011E240Semi_colon_key = '\002\200\000\272',
	STMSWord2011E240Equals_key = '\002\200\000\273',
	STMSWord2011E240Comma_key = '\002\200\000\274',
	STMSWord2011E240Hyphen_key = '\002\200\000\275',
	STMSWord2011E240Period_key = '\002\200\000\276',
	STMSWord2011E240Slash_key = '\002\200\000\277',
	STMSWord2011E240Back_single_quote_key = '\002\200\000\300',
	STMSWord2011E240Open_square_brace_key = '\002\200\000\333',
	STMSWord2011E240Back_slash_key = '\002\200\000\334',
	STMSWord2011E240Close_square_brace_key = '\002\200\000\335',
	STMSWord2011E240Single_quote_key = '\002\200\000\336'
};
typedef enum STMSWord2011E240 STMSWord2011E240;

enum STMSWord2011E241 {
	STMSWord2011E241Olelink = '\002\201\000\000',
	STMSWord2011E241Oleembed = '\002\201\000\001',
	STMSWord2011E241Olecontrol = '\002\201\000\002'
};
typedef enum STMSWord2011E241 STMSWord2011E241;

enum STMSWord2011E242 {
	STMSWord2011E242OleverbPrimary = '\002\202\000\000',
	STMSWord2011E242OleverbShow = '\002\201\377\377',
	STMSWord2011E242OleverbOpen = '\002\201\377\376',
	STMSWord2011E242OleverbHide = '\002\201\377\375',
	STMSWord2011E242OleverbUiactivate = '\002\201\377\374',
	STMSWord2011E242OleverbInPlaceActivate = '\002\201\377\373',
	STMSWord2011E242OleverbDiscardUndoState = '\002\201\377\372'
};
typedef enum STMSWord2011E242 STMSWord2011E242;

enum STMSWord2011E243 {
	STMSWord2011E243InLine = '\002\203\000\000',
	STMSWord2011E243FloatOverText = '\002\203\000\001'
};
typedef enum STMSWord2011E243 STMSWord2011E243;

enum STMSWord2011E244 {
	STMSWord2011E244LeftPortrait = '\002\204\000\000',
	STMSWord2011E244CenterPortrait = '\002\204\000\001',
	STMSWord2011E244RightPortrait = '\002\204\000\002',
	STMSWord2011E244LeftLandscape = '\002\204\000\003',
	STMSWord2011E244CenterLandscape = '\002\204\000\004',
	STMSWord2011E244RightLandscape = '\002\204\000\005',
	STMSWord2011E244LeftClockwise = '\002\204\000\006',
	STMSWord2011E244CenterClockwise = '\002\204\000\007',
	STMSWord2011E244RightClockwise = '\002\204\000\010'
};
typedef enum STMSWord2011E244 STMSWord2011E244;

enum STMSWord2011E245 {
	STMSWord2011E245FullBlock = '\002\205\000\000',
	STMSWord2011E245ModifiedBlock = '\002\205\000\001',
	STMSWord2011E245SemiBlock = '\002\205\000\002'
};
typedef enum STMSWord2011E245 STMSWord2011E245;

enum STMSWord2011E246 {
	STMSWord2011E246LetterTop = '\002\206\000\000',
	STMSWord2011E246LetterBottom = '\002\206\000\001',
	STMSWord2011E246LetterLeft = '\002\206\000\002',
	STMSWord2011E246LetterRight = '\002\206\000\003'
};
typedef enum STMSWord2011E246 STMSWord2011E246;

enum STMSWord2011E247 {
	STMSWord2011E247SalutationInformal = '\002\207\000\000',
	STMSWord2011E247SalutationFormal = '\002\207\000\001',
	STMSWord2011E247SalutationBusiness = '\002\207\000\002',
	STMSWord2011E247SalutationOther = '\002\207\000\003'
};
typedef enum STMSWord2011E247 STMSWord2011E247;

enum STMSWord2011E248 {
	STMSWord2011E248GenderFemale = '\002\210\000\000',
	STMSWord2011E248GenderMale = '\002\210\000\001',
	STMSWord2011E248GenderNeutral = '\002\210\000\002',
	STMSWord2011E248GenderUnknown = '\002\210\000\003'
};
typedef enum STMSWord2011E248 STMSWord2011E248;

enum STMSWord2011E249 {
	STMSWord2011E249ByMoving = '\002\211\000\000',
	STMSWord2011E249BySelecting = '\002\211\000\001'
};
typedef enum STMSWord2011E249 STMSWord2011E249;

enum STMSWord2011E250 {
	STMSWord2011E250UndefinedConstant = '\000\230\226\177',
	STMSWord2011E250ToggleConstant = '\000\230\226~',
	STMSWord2011E250ForwardConstant = '\?\377\377\377',
	STMSWord2011E250BackwardConstant = '\300\000\000\001',
	STMSWord2011E250AutoPosition = '\000\000\000\000',
	STMSWord2011E250FirstConstant = '\000\000\000\001',
	STMSWord2011E250CreatorCode = 'MSWD'
};
typedef enum STMSWord2011E250 STMSWord2011E250;

enum STMSWord2011E251 {
	STMSWord2011E251PasteOleobject = '\002\213\000\000',
	STMSWord2011E251PasteRtf = '\002\213\000\001',
	STMSWord2011E251PasteText = '\002\213\000\002',
	STMSWord2011E251PasteMetafilePicture = '\002\213\000\003',
	STMSWord2011E251PasteBitmap = '\002\213\000\004',
	STMSWord2011E251PasteDeviceIndependentBitmap = '\002\213\000\005',
	STMSWord2011E251PasteHyperlink = '\002\213\000\007',
	STMSWord2011E251PasteShape = '\002\213\000\010',
	STMSWord2011E251PasteEnhancedMetafile = '\002\212\377\377',
	STMSWord2011E251PasteStyledText = '\002\213\000\011',
	STMSWord2011E251PasteHtml = '\002\213\000\012',
	STMSWord2011E251PastePDF = '\002\213\000\013'
};
typedef enum STMSWord2011E251 STMSWord2011E251;

enum STMSWord2011E252 {
	STMSWord2011E252PrintDocumentContent = '\002\214\000\000',
	STMSWord2011E252PrintProperties = '\002\214\000\001',
	STMSWord2011E252PrintComments = '\002\214\000\002',
	STMSWord2011E252PrintStyles = '\002\214\000\003',
	STMSWord2011E252PrintAutoTextEntries = '\002\214\000\004',
	STMSWord2011E252PrintKeyAssignments = '\002\214\000\005',
	STMSWord2011E252PrintEnvelope = '\002\214\000\006'
};
typedef enum STMSWord2011E252 STMSWord2011E252;

enum STMSWord2011E253 {
	STMSWord2011E253PrintAllPages = '\002\215\000\000',
	STMSWord2011E253PrintOddPagesOnly = '\002\215\000\001',
	STMSWord2011E253PrintEvenPagesOnly = '\002\215\000\002'
};
typedef enum STMSWord2011E253 STMSWord2011E253;

enum STMSWord2011E254 {
	STMSWord2011E254PrintAllDocument = '\002\216\000\000',
	STMSWord2011E254PrintSelection = '\002\216\000\001',
	STMSWord2011E254PrintCurrentPage = '\002\216\000\002',
	STMSWord2011E254PrintFromTo = '\002\216\000\003',
	STMSWord2011E254PrintRangeOfPages = '\002\216\000\004'
};
typedef enum STMSWord2011E254 STMSWord2011E254;

enum STMSWord2011E255 {
	STMSWord2011E255Spelling = '\002\217\000\000',
	STMSWord2011E255Grammar = '\002\217\000\001',
	STMSWord2011E255Thesaurus = '\002\217\000\002',
	STMSWord2011E255Hyphenation = '\002\217\000\003',
	STMSWord2011E255SpellingComplete = '\002\217\000\004',
	STMSWord2011E255SpellingCustom = '\002\217\000\005',
	STMSWord2011E255SpellingLegal = '\002\217\000\006',
	STMSWord2011E255SpellingMedical = '\002\217\000\007',
	STMSWord2011E255HangulHanjaConversion = '\002\217\000\010',
	STMSWord2011E255HangulHanjaConversionCustom = '\002\217\000\011'
};
typedef enum STMSWord2011E255 STMSWord2011E255;

enum STMSWord2011E256 {
	STMSWord2011E256SpellingWordTypeSpellWord = '\002\220\000\000',
	STMSWord2011E256SpellingWordTypeWildcard = '\002\220\000\001',
	STMSWord2011E256SpellingWordTypeAnagram = '\002\220\000\002'
};
typedef enum STMSWord2011E256 STMSWord2011E256;

enum STMSWord2011E257 {
	STMSWord2011E257SpellingCorrect = '\002\221\000\000',
	STMSWord2011E257SpellingNotInDictionary = '\002\221\000\001',
	STMSWord2011E257SpellingCapitalization = '\002\221\000\002'
};
typedef enum STMSWord2011E257 STMSWord2011E257;

enum STMSWord2011E258 {
	STMSWord2011E258SpellingError = '\002\222\000\000',
	STMSWord2011E258GrammaticalError = '\002\222\000\001'
};
typedef enum STMSWord2011E258 STMSWord2011E258;

enum STMSWord2011E259 {
	STMSWord2011E259InlineShapeEmbeddedOleobject = '\002\223\000\001',
	STMSWord2011E259InlineShapeLinkedOleobject = '\002\223\000\002',
	STMSWord2011E259InlineShapePicture = '\002\223\000\003',
	STMSWord2011E259InlineShapeLinkedPicture = '\002\223\000\004',
	STMSWord2011E259InlineShapeOlecontrolObject = '\002\223\000\005',
	STMSWord2011E259InlineShapeHorizontalLine = '\002\223\000\006',
	STMSWord2011E259InlineShapePictureHorizontalLine = '\002\223\000\007',
	STMSWord2011E259InlineShapeLinkedPictureHorizontalLine = '\002\223\000\010',
	STMSWord2011E259InlineShapePictureBullet = '\002\223\000\011',
	STMSWord2011E259InlineShapeScriptAnchor = '\002\223\000\012',
	STMSWord2011E259InlineShapeOWSAnchor = '\002\223\000\013',
	STMSWord2011E259InlineShapeChart = '\002\223\000\014',
	STMSWord2011E259InlineShapeDiagram = '\002\223\000\015',
	STMSWord2011E259InlineShapeLockedCanvas = '\002\223\000\016',
	STMSWord2011E259InlineShapeSmartartGraphic = '\002\223\000\017'
};
typedef enum STMSWord2011E259 STMSWord2011E259;

enum STMSWord2011E260 {
	STMSWord2011E260Tiled = '\002\224\000\000',
	STMSWord2011E260Icons = '\002\224\000\001'
};
typedef enum STMSWord2011E260 STMSWord2011E260;

enum STMSWord2011E261 {
	STMSWord2011E261SelectionStartActive = '\002\225\000\001',
	STMSWord2011E261SelectionAtEol = '\002\225\000\002',
	STMSWord2011E261SelectionOvertype = '\002\225\000\004',
	STMSWord2011E261SelectionActive = '\002\225\000\010',
	STMSWord2011E261SelectionReplace = '\002\225\000\020',
	STMSWord2011E261SelectionInactive = '\002\225\000\000',
	STMSWord2011E261SelectionStartActiveAndAtEol = '\002\225\000\003',
	STMSWord2011E261SelectionStartActiveAndOvertype = '\002\225\000\005',
	STMSWord2011E261SelectionAtEolAndOvertype = '\002\225\000\006',
	STMSWord2011E261SelectionStartActiveAndAtEolAndOvertype = '\002\225\000\007',
	STMSWord2011E261SelectionStartActiveAndActive = '\002\225\000\011',
	STMSWord2011E261SelectionAtEolAndActive = '\002\225\000\012',
	STMSWord2011E261SelectionStartActiveAndAtEolAndActive = '\002\225\000\013',
	STMSWord2011E261SelectionOvertypeAndActive = '\002\225\000\014',
	STMSWord2011E261SelectionStartActiveAndOvertypeAndActive = '\002\225\000\015',
	STMSWord2011E261SelectionAtEolAndOvertypeAndActive = '\002\225\000\016',
	STMSWord2011E261SelectionStartActiveAndAtEolAndOvertypeAndActive = '\002\225\000\017',
	STMSWord2011E261SelectionStartActiveAndReplace = '\002\225\000\021',
	STMSWord2011E261SelectionAtEolAndReplace = '\002\225\000\022',
	STMSWord2011E261SelectionStartActiveAndAtEolAndReplace = '\002\225\000\023',
	STMSWord2011E261SelectionOvertypeAndReplace = '\002\225\000\024',
	STMSWord2011E261SelectionStartActiveAndOvertypeAndReplace = '\002\225\000\025',
	STMSWord2011E261SelectionAtEolAndOvertypeAndReplace = '\002\225\000\026',
	STMSWord2011E261SelectionStartActiveAndAtEolAndOvertypeAndReplace = '\002\225\000\027',
	STMSWord2011E261SelectionActiveAndReplace = '\002\225\000\030',
	STMSWord2011E261SelectionStartActiveAndActiveAndReplace = '\002\225\000\031',
	STMSWord2011E261SelectionAtEolAndActiveAndReplace = '\002\225\000\032',
	STMSWord2011E261SelectionStartActiveAndAtEolAndActiveAndReplace = '\002\225\000\033',
	STMSWord2011E261SelectionOvertypeAndActiveAndReplace = '\002\225\000\034',
	STMSWord2011E261SelectionStartActiveAndOvertypeAndActiveAndReplace = '\002\225\000\035',
	STMSWord2011E261SelectionAtEolAndOvertypeAndActiveAndReplace = '\002\225\000\036',
	STMSWord2011E261SelectionStartActiveAndAtEolAndOvertypeAndActiveAndReplace = '\002\225\000\037'
};
typedef enum STMSWord2011E261 STMSWord2011E261;

enum STMSWord2011E262 {
	STMSWord2011E262AutoVersionOff = '\002\226\000\000',
	STMSWord2011E262AutoVersionOnClose = '\002\226\000\001'
};
typedef enum STMSWord2011E262 STMSWord2011E262;

enum STMSWord2011E263 {
	STMSWord2011E263OrganizerObjectStyles = '\002\227\000\000',
	STMSWord2011E263OrganizerObjectAutoText = '\002\227\000\001',
	STMSWord2011E263OrganizerObjectCommandBars = '\002\227\000\002'
};
typedef enum STMSWord2011E263 STMSWord2011E263;

enum STMSWord2011E264 {
	STMSWord2011E264MatchParagraphMark = '\002\231\000\017',
	STMSWord2011E264MatchTabCharacter = '\002\230\000\011',
	STMSWord2011E264MatchCommentMark = '\002\230\000\005',
	STMSWord2011E264MatchAnyCharacter = '\002\231\000\?',
	STMSWord2011E264MatchAnyDigit = '\002\231\000\037',
	STMSWord2011E264MatchAnyLetter = '\002\231\000/',
	STMSWord2011E264MatchCaretCharacter = '\002\230\000\013',
	STMSWord2011E264MatchColumnBreak = '\002\230\000\016',
	STMSWord2011E264MatchEmDash = '\002\230 \024',
	STMSWord2011E264MatchEnDash = '\002\230 \023',
	STMSWord2011E264MatchEndnoteMark = '\002\231\000\023',
	STMSWord2011E264MatchField = '\002\230\000\023',
	STMSWord2011E264MatchFootnoteMark = '\002\231\000\022',
	STMSWord2011E264MatchGraphic = '\002\230\000\001',
	STMSWord2011E264MatchManualLineBreak = '\002\231\000\017',
	STMSWord2011E264MatchManualPageBreak = '\002\231\000\034',
	STMSWord2011E264MatchNonbreakingHyphen = '\002\230\000\036',
	STMSWord2011E264MatchNonbreakingSpace = '\002\230\000\240',
	STMSWord2011E264MatchOptionalHyphen = '\002\230\000\037',
	STMSWord2011E264MatchSectionBreak = '\002\231\000,',
	STMSWord2011E264MatchWhiteSpace = '\002\231\000w'
};
typedef enum STMSWord2011E264 STMSWord2011E264;

enum STMSWord2011E265 {
	STMSWord2011E265FindStop = '\002\231\000\000',
	STMSWord2011E265FindContinue = '\002\231\000\001',
	STMSWord2011E265FindAsk = '\002\231\000\002'
};
typedef enum STMSWord2011E265 STMSWord2011E265;

enum STMSWord2011E266 {
	STMSWord2011E266ActiveEndAdjustedPageNumber = '\002\232\000\001',
	STMSWord2011E266ActiveEndSectionNumber = '\002\232\000\002',
	STMSWord2011E266ActiveEndPageNumber = '\002\232\000\003',
	STMSWord2011E266NumberOfPagesInDocument = '\002\232\000\004',
	STMSWord2011E266HorizontalPositionRelativeToPage = '\002\232\000\005',
	STMSWord2011E266VerticalPositionRelativeToPage = '\002\232\000\006',
	STMSWord2011E266HorizontalPositionRelativeToTextBoundary = '\002\232\000\007',
	STMSWord2011E266VerticalPositionRelativeToTextBoundary = '\002\232\000\010',
	STMSWord2011E266FirstCharacterColumnNumber = '\002\232\000\011',
	STMSWord2011E266FirstCharacterLineNumber = '\002\232\000\012',
	STMSWord2011E266FrameIsSelected = '\002\232\000\013',
	STMSWord2011E266WithInTable = '\002\232\000\014',
	STMSWord2011E266StartOfRangeRowNumber = '\002\232\000\015',
	STMSWord2011E266End_ofRangeRowNumber = '\002\232\000\016',
	STMSWord2011E266MaximumNumberOfRows = '\002\232\000\017',
	STMSWord2011E266StartOfRangeColumnNumber = '\002\232\000\020',
	STMSWord2011E266End_ofRangeColumnNumber = '\002\232\000\021',
	STMSWord2011E266MaximumNumberOfColumns = '\002\232\000\022',
	STMSWord2011E266ZoomPercentage = '\002\232\000\023',
	STMSWord2011E266SelectionMode = '\002\232\000\024',
	STMSWord2011E266InfoCapsLock = '\002\232\000\025',
	STMSWord2011E266InfoNumLock = '\002\232\000\026',
	STMSWord2011E266OverType = '\002\232\000\027',
	STMSWord2011E266RevisionMarking = '\002\232\000\030',
	STMSWord2011E266InFootnoteEndnotePane = '\002\232\000\031',
	STMSWord2011E266InCommentPane = '\002\232\000\032',
	STMSWord2011E266InHeaderFooter = '\002\232\000\034',
	STMSWord2011E266AtEndOfRowMarker = '\002\232\000\037',
	STMSWord2011E266ReferenceOfType = '\002\232\000 ',
	STMSWord2011E266HeaderFooterType = '\002\232\000!',
	STMSWord2011E266InMasterDocument = '\002\232\000\"',
	STMSWord2011E266InFootnote = '\002\232\000#',
	STMSWord2011E266InEndnote = '\002\232\000$',
	STMSWord2011E266InWordMail = '\002\232\000%',
	STMSWord2011E266InClipboard = '\002\232\000&'
};
typedef enum STMSWord2011E266 STMSWord2011E266;

enum STMSWord2011E267 {
	STMSWord2011E267WrapSquare = '\002\233\000\000',
	STMSWord2011E267WrapTight = '\002\233\000\001',
	STMSWord2011E267WrapThrough = '\002\233\000\002',
	STMSWord2011E267WrapNone = '\002\233\000\003',
	STMSWord2011E267WrapTopBottom = '\002\233\000\004'
};
typedef enum STMSWord2011E267 STMSWord2011E267;

enum STMSWord2011E312 {
	STMSWord2011E312PictureWrapTypeInlineWithText = '\002\310\000\000',
	STMSWord2011E312PictureWrapTypeSquare = '\002\310\000\001',
	STMSWord2011E312PictureWrapTypeTight = '\002\310\000\002',
	STMSWord2011E312PictureWrapTypeBehindText = '\002\310\000\003',
	STMSWord2011E312PictureWrapTypeInFrontOfText = '\002\310\000\004',
	STMSWord2011E312PictureWrapTypeThrough = '\002\310\000\005',
	STMSWord2011E312PictureWrapTypeTopAndBottom = '\002\310\000\006'
};
typedef enum STMSWord2011E312 STMSWord2011E312;

enum STMSWord2011E268 {
	STMSWord2011E268WrapBoth = '\002\234\000\000',
	STMSWord2011E268WrapLeft = '\002\234\000\001',
	STMSWord2011E268WrapRight = '\002\234\000\002',
	STMSWord2011E268WrapLargest = '\002\234\000\003'
};
typedef enum STMSWord2011E268 STMSWord2011E268;

enum STMSWord2011E269 {
	STMSWord2011E269OutlineLevel1 = '\002\235\000\001',
	STMSWord2011E269OutlineLevel2 = '\002\235\000\002',
	STMSWord2011E269OutlineLevel3 = '\002\235\000\003',
	STMSWord2011E269OutlineLevel4 = '\002\235\000\004',
	STMSWord2011E269OutlineLevel5 = '\002\235\000\005',
	STMSWord2011E269OutlineLevel6 = '\002\235\000\006',
	STMSWord2011E269OutlineLevel7 = '\002\235\000\007',
	STMSWord2011E269OutlineLevel8 = '\002\235\000\010',
	STMSWord2011E269OutlineLevel9 = '\002\235\000\011',
	STMSWord2011E269OutlineLevelBodyText = '\002\235\000\012'
};
typedef enum STMSWord2011E269 STMSWord2011E269;

enum STMSWord2011E270 {
	STMSWord2011E270TextOrientationHorizontal = '\002\236\000\000',
	STMSWord2011E270TextOrientationUpward = '\002\236\000\002',
	STMSWord2011E270TextOrientationDownward = '\002\236\000\003',
	STMSWord2011E270TextOrientationVerticalEastAsian = '\002\236\000\001',
	STMSWord2011E270TextOrientationHorizontalRotatedEastAsian = '\002\236\000\004'
};
typedef enum STMSWord2011E270 STMSWord2011E270;

enum STMSWord2011E271 {
	STMSWord2011E271ArtNone = '\002\237\000\000',
	STMSWord2011E271ArtApples = '\002\237\000\001',
	STMSWord2011E271ArtMapleMuffins = '\002\237\000\002',
	STMSWord2011E271ArtCakeSlice = '\002\237\000\003',
	STMSWord2011E271ArtCandyCorn = '\002\237\000\004',
	STMSWord2011E271ArtIceCreamCones = '\002\237\000\005',
	STMSWord2011E271ArtChampagneBottle = '\002\237\000\006',
	STMSWord2011E271ArtPartyGlass = '\002\237\000\007',
	STMSWord2011E271ArtChristmasTree = '\002\237\000\010',
	STMSWord2011E271ArtTrees = '\002\237\000\011',
	STMSWord2011E271ArtPalmsColor = '\002\237\000\012',
	STMSWord2011E271ArtBalloons3Colors = '\002\237\000\013',
	STMSWord2011E271ArtBalloonsHotAir = '\002\237\000\014',
	STMSWord2011E271ArtPartyFavor = '\002\237\000\015',
	STMSWord2011E271ArtConfettiStreamers = '\002\237\000\016',
	STMSWord2011E271ArtHearts = '\002\237\000\017',
	STMSWord2011E271ArtHeartBalloon = '\002\237\000\020',
	STMSWord2011E271ArtStars3D = '\002\237\000\021',
	STMSWord2011E271ArtStarsShadowed = '\002\237\000\022',
	STMSWord2011E271ArtStars = '\002\237\000\023',
	STMSWord2011E271ArtSun = '\002\237\000\024',
	STMSWord2011E271ArtEarth2 = '\002\237\000\025',
	STMSWord2011E271ArtEarth1 = '\002\237\000\026',
	STMSWord2011E271ArtPeopleHats = '\002\237\000\027',
	STMSWord2011E271ArtSombrero = '\002\237\000\030',
	STMSWord2011E271ArtPencils = '\002\237\000\031',
	STMSWord2011E271ArtPackages = '\002\237\000\032',
	STMSWord2011E271ArtClocks = '\002\237\000\033',
	STMSWord2011E271ArtFirecrackers = '\002\237\000\034',
	STMSWord2011E271ArtRings = '\002\237\000\035',
	STMSWord2011E271ArtMapPins = '\002\237\000\036',
	STMSWord2011E271ArtConfetti = '\002\237\000\037',
	STMSWord2011E271ArtCreaturesButterfly = '\002\237\000 ',
	STMSWord2011E271ArtCreaturesLadyBug = '\002\237\000!',
	STMSWord2011E271ArtCreaturesFish = '\002\237\000\"',
	STMSWord2011E271ArtBirdsFlight = '\002\237\000#',
	STMSWord2011E271ArtScaredCat = '\002\237\000$',
	STMSWord2011E271ArtBats = '\002\237\000%',
	STMSWord2011E271ArtFlowersRoses = '\002\237\000&',
	STMSWord2011E271ArtFlowersRedRose = '\002\237\000\'',
	STMSWord2011E271ArtPoinsettias = '\002\237\000(',
	STMSWord2011E271ArtHolly = '\002\237\000)',
	STMSWord2011E271ArtFlowersTiny = '\002\237\000*',
	STMSWord2011E271ArtFlowersPansy = '\002\237\000+',
	STMSWord2011E271ArtFlowersModern2 = '\002\237\000,',
	STMSWord2011E271ArtFlowersModern1 = '\002\237\000-',
	STMSWord2011E271ArtWhiteFlowers = '\002\237\000.',
	STMSWord2011E271ArtVine = '\002\237\000/',
	STMSWord2011E271ArtFlowersDaisies = '\002\237\0000',
	STMSWord2011E271ArtFlowersBlockPrint = '\002\237\0001',
	STMSWord2011E271ArtDecoArchColor = '\002\237\0002',
	STMSWord2011E271ArtFans = '\002\237\0003',
	STMSWord2011E271ArtFilm = '\002\237\0004',
	STMSWord2011E271ArtLightning1 = '\002\237\0005',
	STMSWord2011E271ArtCompass = '\002\237\0006',
	STMSWord2011E271ArtDoubleD = '\002\237\0007',
	STMSWord2011E271ArtClassicalWave = '\002\237\0008',
	STMSWord2011E271ArtShadowedSquares = '\002\237\0009',
	STMSWord2011E271ArtTwistedLines1 = '\002\237\000:',
	STMSWord2011E271ArtWaveline = '\002\237\000;',
	STMSWord2011E271ArtQuadrants = '\002\237\000<',
	STMSWord2011E271ArtCheckedBarColor = '\002\237\000=',
	STMSWord2011E271ArtSwirligig = '\002\237\000>',
	STMSWord2011E271ArtPushPinNote1 = '\002\237\000\?',
	STMSWord2011E271ArtPushPinNote2 = '\002\237\000@',
	STMSWord2011E271ArtPumpkin1 = '\002\237\000A',
	STMSWord2011E271ArtEggsBlack = '\002\237\000B',
	STMSWord2011E271ArtCup = '\002\237\000C',
	STMSWord2011E271ArtHeartGray = '\002\237\000D',
	STMSWord2011E271ArtGingerbreadMan = '\002\237\000E',
	STMSWord2011E271ArtBabyPacifier = '\002\237\000F',
	STMSWord2011E271ArtBabyRattle = '\002\237\000G',
	STMSWord2011E271ArtCabins = '\002\237\000H',
	STMSWord2011E271ArtHouseFunky = '\002\237\000I',
	STMSWord2011E271ArtStarsBlack = '\002\237\000J',
	STMSWord2011E271ArtSnowflakes = '\002\237\000K',
	STMSWord2011E271ArtSnowflakeFancy = '\002\237\000L',
	STMSWord2011E271ArtSkyrocket = '\002\237\000M',
	STMSWord2011E271ArtSeattle = '\002\237\000N',
	STMSWord2011E271ArtMusicNotes = '\002\237\000O',
	STMSWord2011E271ArtPalmsBlack = '\002\237\000P',
	STMSWord2011E271ArtMapleLeaf = '\002\237\000Q',
	STMSWord2011E271ArtPaperClips = '\002\237\000R',
	STMSWord2011E271ArtShorebirdTracks = '\002\237\000S',
	STMSWord2011E271ArtPeople = '\002\237\000T',
	STMSWord2011E271ArtPeopleWaving = '\002\237\000U',
	STMSWord2011E271ArtEclipsingSquares2 = '\002\237\000V',
	STMSWord2011E271ArtHypnotic = '\002\237\000W',
	STMSWord2011E271ArtDiamondsGray = '\002\237\000X',
	STMSWord2011E271ArtDecoArch = '\002\237\000Y',
	STMSWord2011E271ArtDecoBlocks = '\002\237\000Z',
	STMSWord2011E271ArtCirclesLines = '\002\237\000[',
	STMSWord2011E271ArtPapyrus = '\002\237\000\\',
	STMSWord2011E271ArtWoodwork = '\002\237\000]',
	STMSWord2011E271ArtWeavingBraid = '\002\237\000^',
	STMSWord2011E271ArtWeavingRibbon = '\002\237\000_',
	STMSWord2011E271ArtWeavingAngles = '\002\237\000`',
	STMSWord2011E271ArtArchedScallops = '\002\237\000a',
	STMSWord2011E271ArtSafari = '\002\237\000b',
	STMSWord2011E271ArtCelticKnotwork = '\002\237\000c',
	STMSWord2011E271ArtCrazyMaze = '\002\237\000d',
	STMSWord2011E271ArtEclipsingSquares1 = '\002\237\000e',
	STMSWord2011E271ArtBirds = '\002\237\000f',
	STMSWord2011E271ArtFlowersTeacup = '\002\237\000g',
	STMSWord2011E271ArtNorthwest = '\002\237\000h',
	STMSWord2011E271ArtSouthwest = '\002\237\000i',
	STMSWord2011E271ArtTribal6 = '\002\237\000j',
	STMSWord2011E271ArtTribal4 = '\002\237\000k',
	STMSWord2011E271ArtTribal3 = '\002\237\000l',
	STMSWord2011E271ArtTribal2 = '\002\237\000m',
	STMSWord2011E271ArtTribal5 = '\002\237\000n',
	STMSWord2011E271ArtXillusions = '\002\237\000o',
	STMSWord2011E271ArtZanyTriangles = '\002\237\000p',
	STMSWord2011E271ArtPyramids = '\002\237\000q',
	STMSWord2011E271ArtPyramidsAbove = '\002\237\000r',
	STMSWord2011E271ArtConfettiGrays = '\002\237\000s',
	STMSWord2011E271ArtConfettiOutline = '\002\237\000t',
	STMSWord2011E271ArtConfettiWhite = '\002\237\000u',
	STMSWord2011E271ArtMosaic = '\002\237\000v',
	STMSWord2011E271ArtLightning2 = '\002\237\000w',
	STMSWord2011E271ArtHeebieJeebies = '\002\237\000x',
	STMSWord2011E271ArtLightBulb = '\002\237\000y',
	STMSWord2011E271ArtGradient = '\002\237\000z',
	STMSWord2011E271ArtTriangleParty = '\002\237\000{',
	STMSWord2011E271ArtTwistedLines2 = '\002\237\000|',
	STMSWord2011E271ArtMoons = '\002\237\000}',
	STMSWord2011E271ArtOvals = '\002\237\000~',
	STMSWord2011E271ArtDoubleDiamonds = '\002\237\000\177',
	STMSWord2011E271ArtChainLink = '\002\237\000\200',
	STMSWord2011E271ArtTriangles = '\002\237\000\201',
	STMSWord2011E271ArtTribal1 = '\002\237\000\202',
	STMSWord2011E271ArtMarqueeToothed = '\002\237\000\203',
	STMSWord2011E271ArtSharksTeeth = '\002\237\000\204',
	STMSWord2011E271ArtSawtooth = '\002\237\000\205',
	STMSWord2011E271ArtSawtoothGray = '\002\237\000\206',
	STMSWord2011E271ArtPostageStamp = '\002\237\000\207',
	STMSWord2011E271ArtWeavingStrips = '\002\237\000\210',
	STMSWord2011E271ArtZigZag = '\002\237\000\211',
	STMSWord2011E271ArtCrossStitch = '\002\237\000\212',
	STMSWord2011E271ArtGems = '\002\237\000\213',
	STMSWord2011E271ArtCirclesRectangles = '\002\237\000\214',
	STMSWord2011E271ArtCornerTriangles = '\002\237\000\215',
	STMSWord2011E271ArtCreaturesInsects = '\002\237\000\216',
	STMSWord2011E271ArtZigZagStitch = '\002\237\000\217',
	STMSWord2011E271ArtCheckered = '\002\237\000\220',
	STMSWord2011E271ArtCheckedBarBlack = '\002\237\000\221',
	STMSWord2011E271ArtMarquee = '\002\237\000\222',
	STMSWord2011E271ArtBasicWhiteDots = '\002\237\000\223',
	STMSWord2011E271ArtBasicWideMidline = '\002\237\000\224',
	STMSWord2011E271ArtBasicWideOutline = '\002\237\000\225',
	STMSWord2011E271ArtBasicWideInline = '\002\237\000\226',
	STMSWord2011E271ArtBasicThinLines = '\002\237\000\227',
	STMSWord2011E271ArtBasicWhiteDashes = '\002\237\000\230',
	STMSWord2011E271ArtBasicWhiteSquares = '\002\237\000\231',
	STMSWord2011E271ArtBasicBlackSquares = '\002\237\000\232',
	STMSWord2011E271ArtBasicBlackDashes = '\002\237\000\233',
	STMSWord2011E271ArtBasicBlackDots = '\002\237\000\234',
	STMSWord2011E271ArtStarsTop = '\002\237\000\235',
	STMSWord2011E271ArtCertificateBanner = '\002\237\000\236',
	STMSWord2011E271ArtHandmade1 = '\002\237\000\237',
	STMSWord2011E271ArtHandmade2 = '\002\237\000\240',
	STMSWord2011E271ArtTornPaper = '\002\237\000\241',
	STMSWord2011E271ArtTornPaperBlack = '\002\237\000\242',
	STMSWord2011E271ArtCouponCutoutDashes = '\002\237\000\243',
	STMSWord2011E271ArtCouponCutoutDots = '\002\237\000\244'
};
typedef enum STMSWord2011E271 STMSWord2011E271;

enum STMSWord2011E272 {
	STMSWord2011E272BorderDistanceFromText = '\002\240\000\000',
	STMSWord2011E272BorderDistanceFromPageEdge = '\002\240\000\001'
};
typedef enum STMSWord2011E272 STMSWord2011E272;

enum STMSWord2011E273 {
	STMSWord2011E273ReplaceNone = '\002\241\000\000',
	STMSWord2011E273ReplaceOne = '\002\241\000\001',
	STMSWord2011E273ReplaceAll = '\002\241\000\002'
};
typedef enum STMSWord2011E273 STMSWord2011E273;

enum STMSWord2011E274 {
	STMSWord2011E274FontBiasDoNotCare = '\002\242\000\377',
	STMSWord2011E274FontBiasDefault = '\002\242\000\000',
	STMSWord2011E274FontBiasEastAsian = '\002\242\000\001'
};
typedef enum STMSWord2011E274 STMSWord2011E274;

enum STMSWord2011E275 {
	STMSWord2011E275BrowserLevelV4 = '\002\243\000\000',
	STMSWord2011E275BrowserLevelMicrosoftInternetExplorer5 = '\002\243\000\001'
};
typedef enum STMSWord2011E275 STMSWord2011E275;

enum STMSWord2011E276 {
	STMSWord2011E276EnclosureCircle = '\002\244\000\000',
	STMSWord2011E276EnclosureSquare = '\002\244\000\001',
	STMSWord2011E276EnclosureTriangle = '\002\244\000\002',
	STMSWord2011E276EnclosureDiamond = '\002\244\000\003'
};
typedef enum STMSWord2011E276 STMSWord2011E276;

enum STMSWord2011E277 {
	STMSWord2011E277EncloseStyleNone = '\002\245\000\000',
	STMSWord2011E277EncloseStyleSmall = '\002\245\000\001',
	STMSWord2011E277EncloseStyleLarge = '\002\245\000\002'
};
typedef enum STMSWord2011E277 STMSWord2011E277;

enum STMSWord2011E278 {
	STMSWord2011E278LayoutModeDefault = '\002\246\000\000',
	STMSWord2011E278LayoutModeGrid = '\002\246\000\001',
	STMSWord2011E278LayoutModeLineGrid = '\002\246\000\002',
	STMSWord2011E278LayoutModeGenko = '\002\246\000\003'
};
typedef enum STMSWord2011E278 STMSWord2011E278;

enum STMSWord2011E279 {
	STMSWord2011E279ForAEmailMessage = '\002\247\000\000',
	STMSWord2011E279ForADocument = '\002\247\000\001',
	STMSWord2011E279ForAWebPage = '\002\247\000\002'
};
typedef enum STMSWord2011E279 STMSWord2011E279;

enum STMSWord2011E308 {
	STMSWord2011E308TwoLinesInOneNone = '\002\304\000\000',
	STMSWord2011E308TwoLinesInOneNoBrackets = '\002\304\000\001',
	STMSWord2011E308TwoLinesInOneParentheses = '\002\304\000\002',
	STMSWord2011E308TwoLinesInOneSquareBrackets = '\002\304\000\003',
	STMSWord2011E308TwoLinesInOneAngleBrackets = '\002\304\000\004',
	STMSWord2011E308TwoLinesInOneCurlyBrackets = '\002\304\000\005'
};
typedef enum STMSWord2011E308 STMSWord2011E308;

enum STMSWord2011E309 {
	STMSWord2011E309HorizontalInVerticalNone = '\002\305\000\000',
	STMSWord2011E309HorizontalInVerticalFitInLine = '\002\305\000\001',
	STMSWord2011E309HorizontalInVerticalResizeLine = '\002\305\000\002'
};
typedef enum STMSWord2011E309 STMSWord2011E309;

enum STMSWord2011E280 {
	STMSWord2011E280HorizontalLineAlignLeft = '\002\250\000\000',
	STMSWord2011E280HorizontalLineAlignCenter = '\002\250\000\001',
	STMSWord2011E280HorizontalLineAlignRight = '\002\250\000\002'
};
typedef enum STMSWord2011E280 STMSWord2011E280;

enum STMSWord2011E281 {
	STMSWord2011E281HorizontalLinePercentWidth = '\002\250\377\377',
	STMSWord2011E281HorizontalLineFixedWidth = '\002\250\377\376'
};
typedef enum STMSWord2011E281 STMSWord2011E281;

enum STMSWord2011E310 {
	STMSWord2011E310PhoneticGuideAlignmentCenter = '\002\306\000\000',
	STMSWord2011E310PhoneticGuideAlignmentZeroOneZero = '\002\306\000\001',
	STMSWord2011E310PhoneticGuideAlignmentOneTwoOne = '\002\306\000\002',
	STMSWord2011E310PhoneticGuideAlignmentLeft = '\002\306\000\003',
	STMSWord2011E310PhoneticGuideAlignmentRight = '\002\306\000\004',
	STMSWord2011E310PhoneticGuideAlignmentRightVertical = '\002\306\000\005'
};
typedef enum STMSWord2011E310 STMSWord2011E310;

enum STMSWord2011E282 {
	STMSWord2011E282TableDirectionRtl = '\002\252\000\000',
	STMSWord2011E282TableDirectionLtr = '\002\252\000\001'
};
typedef enum STMSWord2011E282 STMSWord2011E282;

enum STMSWord2011E283 {
	STMSWord2011E283GutterPositionLeft = '\002\253\000\000',
	STMSWord2011E283GutterPositionTop = '\002\253\000\001',
	STMSWord2011E283GutterPositionRight = '\002\253\000\002'
};
typedef enum STMSWord2011E283 STMSWord2011E283;

enum STMSWord2011E284 {
	STMSWord2011E284GutterStyleLatin = '\002\253\377\366',
	STMSWord2011E284GutterStyleBidi = '\002\254\000\002',
	STMSWord2011E284GutterStyleNone = '\002\254\000\000'
};
typedef enum STMSWord2011E284 STMSWord2011E284;

enum STMSWord2011E285 {
	STMSWord2011E285ShapeTop = '\002\235\275\301',
	STMSWord2011E285ShapeLeft = '\002\235\275\302',
	STMSWord2011E285ShapeBottom = '\002\235\275\303',
	STMSWord2011E285ShapeRight = '\002\235\275\304',
	STMSWord2011E285ShapeCenter = '\002\235\275\305',
	STMSWord2011E285ShapeInside = '\002\235\275\306',
	STMSWord2011E285ShapeOutside = '\002\235\275\307'
};
typedef enum STMSWord2011E285 STMSWord2011E285;

enum STMSWord2011E286 {
	STMSWord2011E286TableTop = '\002\236\275\301',
	STMSWord2011E286TableLeft = '\002\236\275\302',
	STMSWord2011E286TableBottom = '\002\236\275\303',
	STMSWord2011E286TableRight = '\002\236\275\304',
	STMSWord2011E286TableCenter = '\002\236\275\305',
	STMSWord2011E286TableInside = '\002\236\275\306',
	STMSWord2011E286TableOutside = '\002\236\275\307'
};
typedef enum STMSWord2011E286 STMSWord2011E286;

enum STMSWord2011E287 {
	STMSWord2011E287Word8TableBehavior = '\002\257\000\000',
	STMSWord2011E287Word9TableBehavior = '\002\257\000\001'
};
typedef enum STMSWord2011E287 STMSWord2011E287;

enum STMSWord2011E288 {
	STMSWord2011E288AutoFitFixed = '\002\260\000\000',
	STMSWord2011E288AutoFitContent = '\002\260\000\001',
	STMSWord2011E288AutoFitWindow = '\002\260\000\002'
};
typedef enum STMSWord2011E288 STMSWord2011E288;

enum STMSWord2011E289 {
	STMSWord2011E289Word8ListBehavior = '\002\261\000\000',
	STMSWord2011E289Word9ListBehavior = '\002\261\000\001',
	STMSWord2011E289Word10ListBehavior = '\002\261\000\002'
};
typedef enum STMSWord2011E289 STMSWord2011E289;

enum STMSWord2011E290 {
	STMSWord2011E290PreferredWidthAuto = '\002\262\000\001',
	STMSWord2011E290PreferredWidthPercent = '\002\262\000\002',
	STMSWord2011E290PreferredWidthPoints = '\002\262\000\003'
};
typedef enum STMSWord2011E290 STMSWord2011E290;

enum STMSWord2011E291 {
	STMSWord2011E291NewBlankDocument = '\002\263\000\000',
	STMSWord2011E291NewWebPage = '\002\263\000\001',
	STMSWord2011E291NewNotebookDocument = '\002\263\000\004',
	STMSWord2011E291NewPublishingDocument = '\002\263\000\005'
};
typedef enum STMSWord2011E291 STMSWord2011E291;

enum STMSWord2011E292 {
	STMSWord2011E292UserFirst = '\002\264\000\001',
	STMSWord2011E292UserLast = '\002\264\000\002',
	STMSWord2011E292UserCompany = '\002\264\000\024',
	STMSWord2011E292UserWorkStreet = '\002\264\000\026',
	STMSWord2011E292UserWorkCity = '\002\264\000\027',
	STMSWord2011E292UserWorkState = '\002\264\000\030',
	STMSWord2011E292UserWorkZip = '\002\264\000\031',
	STMSWord2011E292UserWorkPhone = '\002\264\000\035',
	STMSWord2011E292UserEmailAddress1 = '\002\264\000f'
};
typedef enum STMSWord2011E292 STMSWord2011E292;

enum STMSWord2011E293 {
	STMSWord2011E293PasteDefault = '\002\265\000\000',
	STMSWord2011E293SingleCellText = '\002\265\000\005',
	STMSWord2011E293SingleCellTable = '\002\265\000\006',
	STMSWord2011E293ListContinueNumbering = '\002\265\000\007',
	STMSWord2011E293ListRestartNumbering = '\002\265\000\010',
	STMSWord2011E293TableInsertAsRows = '\002\265\000\013',
	STMSWord2011E293TableAppendTable = '\002\265\000\012',
	STMSWord2011E293TableOriginalFormatting = '\002\265\000\014',
	STMSWord2011E293ChartPicture = '\002\265\000\015',
	STMSWord2011E293Chart = '\002\265\000\016',
	STMSWord2011E293ChartLinked = '\002\265\000\017',
	STMSWord2011E293FormatOriginalFormatting = '\002\265\000\020',
	STMSWord2011E293FormatSurroundingFormattingWithEmphasis = '\002\265\000\024',
	STMSWord2011E293FormatPlainText = '\002\265\000\026',
	STMSWord2011E293TableOverwriteCells = '\002\265\000\027',
	STMSWord2011E293ListCombineWithExistingList = '\002\265\000\030',
	STMSWord2011E293ListDontMerge = '\002\265\000\031'
};
typedef enum STMSWord2011E293 STMSWord2011E293;

enum STMSWord2011E294 {
	STMSWord2011E294GoForward = '\002\266\000\001',
	STMSWord2011E294GoBackward = '\002\266\000\002',
	STMSWord2011E294ANumericConstant = '\002\266\000\000'
};
typedef enum STMSWord2011E294 STMSWord2011E294;

enum STMSWord2011E311 {
	STMSWord2011E311LineEndingCrLf = '\002\307\000\000',
	STMSWord2011E311LineEndingCrOnly = '\002\307\000\001',
	STMSWord2011E311LineEndingLfOnly = '\002\307\000\002',
	STMSWord2011E311LineEndingLfCr = '\002\307\000\003',
	STMSWord2011E311LineEndingLsPs = '\002\307\000\004'
};
typedef enum STMSWord2011E311 STMSWord2011E311;

enum STMSWord2011E299 {
	STMSWord2011E299ConditionFirstRow = '\002\301\000\000',
	STMSWord2011E299ConditionLastRow = '\002\301\000\001',
	STMSWord2011E299ConditionOddRowBanding = '\002\301\000\002',
	STMSWord2011E299ConditionEvenRowBanding = '\002\301\000\003',
	STMSWord2011E299ConditionFirstColumn = '\002\301\000\004',
	STMSWord2011E299ConditionLastColumn = '\002\301\000\005',
	STMSWord2011E299ConditionOddColumnBanding = '\002\301\000\006',
	STMSWord2011E299ConditionEvenColumnBanding = '\002\301\000\007',
	STMSWord2011E299ConditionTopRightCell = '\002\301\000\010',
	STMSWord2011E299ConditionTopLeftCell = '\002\301\000\011',
	STMSWord2011E299ConditionBottomRightCell = '\002\301\000\012',
	STMSWord2011E299ConditionBottomLeftCell = '\002\301\000\013'
};
typedef enum STMSWord2011E299 STMSWord2011E299;

enum STMSWord2011E295 {
	STMSWord2011E295UnitALine = '\002\267\000\005',
	STMSWord2011E295UnitAStory = '\002\267\000\006',
	STMSWord2011E295UnitAScreen = '\002\267\000\007',
	STMSWord2011E295UnitASection = '\002\267\000\010',
	STMSWord2011E295UnitAColumn = '\002\267\000\011',
	STMSWord2011E295UnitARow = '\002\267\000\012'
};
typedef enum STMSWord2011E295 STMSWord2011E295;

enum STMSWord2011E296 {
	STMSWord2011E296HighlightOn = '\002\270\377\377',
	STMSWord2011E296HighlightOff = '\002\270\000\000',
	STMSWord2011E296ANumericConstant = '\002\270\000\000'
};
typedef enum STMSWord2011E296 STMSWord2011E296;

enum STMSWord2011E297 {
	STMSWord2011E297CompareTargetSelected = '\002\271\000\000',
	STMSWord2011E297CompareTargetCurrent = '\002\271\000\001',
	STMSWord2011E297CompareTargetNew = '\002\271\000\002'
};
typedef enum STMSWord2011E297 STMSWord2011E297;

enum STMSWord2011E298 {
	STMSWord2011E298MergeTargetSelected = '\002\272\000\000',
	STMSWord2011E298MergeTargetCurrent = '\002\272\000\001',
	STMSWord2011E298MergeTargetNew = '\002\272\000\002'
};
typedef enum STMSWord2011E298 STMSWord2011E298;

enum STMSWord2011E300 {
	STMSWord2011E300RevisionsViewFinal = '\002\274\000\000',
	STMSWord2011E300RevisionsViewOriginal = '\002\274\000\001'
};
typedef enum STMSWord2011E300 STMSWord2011E300;

enum STMSWord2011E301 {
	STMSWord2011E301RevisionsViewBalloons = '\002\275\000\000',
	STMSWord2011E301RevisionsViewInline = '\002\275\000\001'
};
typedef enum STMSWord2011E301 STMSWord2011E301;

enum STMSWord2011E303 {
	STMSWord2011E303BalloonPrintOrientationAutomatic = '\002\277\000\000',
	STMSWord2011E303BalloonPrintOrientationPreserve = '\002\277\000\001',
	STMSWord2011E303BalloonPrintOrientationLandscape = '\002\277\000\002'
};
typedef enum STMSWord2011E303 STMSWord2011E303;

enum STMSWord2011E304 {
	STMSWord2011E304BalloonMarginLeft = '\002\300\000\000',
	STMSWord2011E304BalloonMarginRight = '\002\300\000\001'
};
typedef enum STMSWord2011E304 STMSWord2011E304;

enum STMSWord2011E331 {
	STMSWord2011E331MinorVersion = '\002\333\000\000',
	STMSWord2011E331MajorVersion = '\002\333\000\001',
	STMSWord2011E331OverwriteCurrentVersion = '\002\333\000\002'
};
typedef enum STMSWord2011E331 STMSWord2011E331;

enum STMSWord2011E332 {
	STMSWord2011E332LockNone = '\002\334\000\000',
	STMSWord2011E332LockReservation = '\002\334\000\001',
	STMSWord2011E332LockEphemeral = '\002\334\000\002',
	STMSWord2011E332LockChanged = '\002\334\000\003'
};
typedef enum STMSWord2011E332 STMSWord2011E332;

enum STMSWord20114017 {
	STMSWord20114017FieldOptions = 'w298',
	STMSWord20114017Field = 'w170'
};
typedef enum STMSWord20114017 STMSWord20114017;

enum STMSWord20114018 {
	STMSWord20114018FieldOptions = 'w298',
	STMSWord20114018Field = 'w170'
};
typedef enum STMSWord20114018 STMSWord20114018;

enum STMSWord20114024 {
	STMSWord20114024Revision = 'w219',
	STMSWord20114024Conflict = 'o120'
};
typedef enum STMSWord20114024 STMSWord20114024;

enum STMSWord20114025 {
	STMSWord20114025Revision = 'w219',
	STMSWord20114025Conflict = 'o120'
};
typedef enum STMSWord20114025 STMSWord20114025;

enum STMSWord20114013 {
	STMSWord20114013FootnoteOptions = 'WopN',
	STMSWord20114013EndnoteOptions = 'WopE'
};
typedef enum STMSWord20114013 STMSWord20114013;

enum STMSWord20114014 {
	STMSWord20114014FootnoteOptions = 'WopN',
	STMSWord20114014EndnoteOptions = 'WopE'
};
typedef enum STMSWord20114014 STMSWord20114014;

enum STMSWord20114015 {
	STMSWord20114015FootnoteOptions = 'WopN',
	STMSWord20114015EndnoteOptions = 'WopE'
};
typedef enum STMSWord20114015 STMSWord20114015;

enum STMSWord20114004 {
	STMSWord20114004Document = 'docu',
	STMSWord20114004Window = 'cwin',
	STMSWord20114004Pane = 'w120'
};
typedef enum STMSWord20114004 STMSWord20114004;

enum STMSWord20114019 {
	STMSWord20114019Font = 'w137',
	STMSWord20114019Frame = 'w175',
	STMSWord20114019SelectionObject = 'WSoj'
};
typedef enum STMSWord20114019 STMSWord20114019;

enum STMSWord20114021 {
	STMSWord20114021Field = 'w170',
	STMSWord20114021Frame = 'w175',
	STMSWord20114021FormField = 'w177',
	STMSWord20114021DataMergeField = 'w187',
	STMSWord20114021SelectionObject = 'WSoj',
	STMSWord20114021PageNumber = 'w225'
};
typedef enum STMSWord20114021 STMSWord20114021;

enum STMSWord20114023 {
	STMSWord20114023ListFormat = 'w123',
	STMSWord20114023WordList = 'w236'
};
typedef enum STMSWord20114023 STMSWord20114023;

enum STMSWord20114002 {
	STMSWord20114002Application = 'capp',
	STMSWord20114002Document = 'docu'
};
typedef enum STMSWord20114002 STMSWord20114002;

enum STMSWord20114003 {
	STMSWord20114003Application = 'capp',
	STMSWord20114003Document = 'docu'
};
typedef enum STMSWord20114003 STMSWord20114003;

enum STMSWord20114011 {
	STMSWord20114011Find = 'w124',
	STMSWord20114011Replacement = 'w125',
	STMSWord20114011SelectionObject = 'WSoj'
};
typedef enum STMSWord20114011 STMSWord20114011;

enum STMSWord20114012 {
	STMSWord20114012DropCap = 'w133',
	STMSWord20114012TabStop = 'w135',
	STMSWord20114012TextInput = 'w178',
	STMSWord20114012KeyBinding = 'w242'
};
typedef enum STMSWord20114012 STMSWord20114012;

enum STMSWord20114010 {
	STMSWord20114010Document = 'docu',
	STMSWord20114010ListFormat = 'w123',
	STMSWord20114010WordList = 'w236'
};
typedef enum STMSWord20114010 STMSWord20114010;

enum STMSWord20114020 {
	STMSWord20114020Field = 'w170',
	STMSWord20114020Frame = 'w175',
	STMSWord20114020FormField = 'w177',
	STMSWord20114020DataMergeField = 'w187',
	STMSWord20114020SelectionObject = 'WSoj',
	STMSWord20114020PageNumber = 'w225'
};
typedef enum STMSWord20114020 STMSWord20114020;

enum STMSWord20114005 {
	STMSWord20114005Window = 'cwin',
	STMSWord20114005Pane = 'w120'
};
typedef enum STMSWord20114005 STMSWord20114005;

enum STMSWord20114009 {
	STMSWord20114009Document = 'docu',
	STMSWord20114009ListFormat = 'w123',
	STMSWord20114009WordList = 'w236'
};
typedef enum STMSWord20114009 STMSWord20114009;

enum STMSWord20114007 {
	STMSWord20114007Window = 'cwin',
	STMSWord20114007Pane = 'w120'
};
typedef enum STMSWord20114007 STMSWord20114007;

enum STMSWord20114001 {
	STMSWord20114001Application = 'capp',
	STMSWord20114001Document = 'docu',
	STMSWord20114001Window = 'cwin'
};
typedef enum STMSWord20114001 STMSWord20114001;

enum STMSWord20114008 {
	STMSWord20114008Document = 'docu',
	STMSWord20114008ListFormat = 'w123',
	STMSWord20114008WordList = 'w236'
};
typedef enum STMSWord20114008 STMSWord20114008;

enum STMSWord20114006 {
	STMSWord20114006Window = 'cwin',
	STMSWord20114006Pane = 'w120'
};
typedef enum STMSWord20114006 STMSWord20114006;

enum STMSWord20114022 {
	STMSWord20114022TableOfFigures = 'w184',
	STMSWord20114022TableOfContents = 'w198'
};
typedef enum STMSWord20114022 STMSWord20114022;

enum STMSWord20114016 {
	STMSWord20114016LinkFormat = 'w167',
	STMSWord20114016FieldOptions = 'w298',
	STMSWord20114016TableOfFigures = 'w184',
	STMSWord20114016TableOfContents = 'w198',
	STMSWord20114016TableOfAuthorities = 'w200',
	STMSWord20114016Dialog = 'w202',
	STMSWord20114016Index = 'w215'
};
typedef enum STMSWord20114016 STMSWord20114016;

enum STMSWord2011E315 {
	STMSWord2011E315Def1 = '\002\312\377\377',
	STMSWord2011E315Def2 = '\002\313\000\000',
	STMSWord2011E315Def3 = '\002\313\000\001',
	STMSWord2011E315Def4 = '\002\313\000\002',
	STMSWord2011E315Def5 = '\002\313\000\003',
	STMSWord2011E315Def6 = '\002\313\000\004',
	STMSWord2011E315Def7 = '\002\313\000\005',
	STMSWord2011E315Def8 = '\002\313\000\006',
	STMSWord2011E315Def9 = '\002\313\000\007',
	STMSWord2011E315Def10 = '\002\313\000\010',
	STMSWord2011E315Def11 = '\002\313\000\011',
	STMSWord2011E315Def12 = '\002\313\000\012',
	STMSWord2011E315Def13 = '\002\313\000\013',
	STMSWord2011E315Def14 = '\002\313\000\014',
	STMSWord2011E315Def15 = '\002\313\000\015',
	STMSWord2011E315Def16 = '\002\313\000\016',
	STMSWord2011E315Def17 = '\002\313\000\017'
};
typedef enum STMSWord2011E315 STMSWord2011E315;

enum STMSWord20114027 {
	STMSWord20114027Shape = 'pShp',
	STMSWord20114027CalloutFormat = 'w275'
};
typedef enum STMSWord20114027 STMSWord20114027;

enum STMSWord20114028 {
	STMSWord20114028Callout = 'cD00',
	STMSWord20114028CalloutFormat = 'w275'
};
typedef enum STMSWord20114028 STMSWord20114028;

enum STMSWord20114029 {
	STMSWord20114029Callout = 'cD00',
	STMSWord20114029CalloutFormat = 'w275'
};
typedef enum STMSWord20114029 STMSWord20114029;

enum STMSWord20114030 {
	STMSWord20114030Callout = 'cD00',
	STMSWord20114030CalloutFormat = 'w275'
};
typedef enum STMSWord20114030 STMSWord20114030;

enum STMSWord20114031 {
	STMSWord20114031Shape = 'pShp',
	STMSWord20114031FillFormat = 'w278'
};
typedef enum STMSWord20114031 STMSWord20114031;

enum STMSWord20114032 {
	STMSWord20114032Shape = 'pShp',
	STMSWord20114032FillFormat = 'w278'
};
typedef enum STMSWord20114032 STMSWord20114032;

enum STMSWord20114033 {
	STMSWord20114033Shape = 'pShp',
	STMSWord20114033FillFormat = 'w278'
};
typedef enum STMSWord20114033 STMSWord20114033;

enum STMSWord20114034 {
	STMSWord20114034Shape = 'pShp',
	STMSWord20114034FillFormat = 'w278'
};
typedef enum STMSWord20114034 STMSWord20114034;

enum STMSWord20114035 {
	STMSWord20114035Shape = 'pShp',
	STMSWord20114035FillFormat = 'w278'
};
typedef enum STMSWord20114035 STMSWord20114035;

enum STMSWord20114036 {
	STMSWord20114036Shape = 'pShp',
	STMSWord20114036FillFormat = 'w278'
};
typedef enum STMSWord20114036 STMSWord20114036;

enum STMSWord20114037 {
	STMSWord20114037Shape = 'pShp',
	STMSWord20114037FillFormat = 'w278'
};
typedef enum STMSWord20114037 STMSWord20114037;

enum STMSWord20114038 {
	STMSWord20114038Shape = 'pShp',
	STMSWord20114038FillFormat = 'w278'
};
typedef enum STMSWord20114038 STMSWord20114038;

enum STMSWord20114039 {
	STMSWord20114039Shape = 'pShp',
	STMSWord20114039ThreeDFormat = 'w286'
};
typedef enum STMSWord20114039 STMSWord20114039;

enum STMSWord20114026 {
	STMSWord20114026Shape = 'pShp',
	STMSWord20114026InlineShape = 'w257'
};
typedef enum STMSWord20114026 STMSWord20114026;

enum STMSWord20114046 {
	STMSWord20114046Paragraph = 'cpar',
	STMSWord20114046ParagraphFormat = 'w136'
};
typedef enum STMSWord20114046 STMSWord20114046;

enum STMSWord20114040 {
	STMSWord20114040TextRange = 'w122',
	STMSWord20114040Section = 'w130',
	STMSWord20114040Paragraph = 'cpar',
	STMSWord20114040ParagraphFormat = 'w136',
	STMSWord20114040WordStyle = 'w173'
};
typedef enum STMSWord20114040 STMSWord20114040;

enum STMSWord20114041 {
	STMSWord20114041Paragraph = 'cpar',
	STMSWord20114041ParagraphFormat = 'w136'
};
typedef enum STMSWord20114041 STMSWord20114041;

enum STMSWord20114050 {
	STMSWord20114050Paragraph = 'cpar',
	STMSWord20114050ParagraphFormat = 'w136'
};
typedef enum STMSWord20114050 STMSWord20114050;

enum STMSWord20114051 {
	STMSWord20114051Paragraph = 'cpar',
	STMSWord20114051ParagraphFormat = 'w136'
};
typedef enum STMSWord20114051 STMSWord20114051;

enum STMSWord20114043 {
	STMSWord20114043Paragraph = 'cpar',
	STMSWord20114043ParagraphFormat = 'w136'
};
typedef enum STMSWord20114043 STMSWord20114043;

enum STMSWord20114042 {
	STMSWord20114042Paragraph = 'cpar',
	STMSWord20114042ParagraphFormat = 'w136'
};
typedef enum STMSWord20114042 STMSWord20114042;

enum STMSWord20114048 {
	STMSWord20114048Paragraph = 'cpar',
	STMSWord20114048ParagraphFormat = 'w136'
};
typedef enum STMSWord20114048 STMSWord20114048;

enum STMSWord20114047 {
	STMSWord20114047Paragraph = 'cpar',
	STMSWord20114047ParagraphFormat = 'w136'
};
typedef enum STMSWord20114047 STMSWord20114047;

enum STMSWord20114049 {
	STMSWord20114049Paragraph = 'cpar',
	STMSWord20114049ParagraphFormat = 'w136'
};
typedef enum STMSWord20114049 STMSWord20114049;

enum STMSWord20114044 {
	STMSWord20114044Paragraph = 'cpar',
	STMSWord20114044ParagraphFormat = 'w136'
};
typedef enum STMSWord20114044 STMSWord20114044;

enum STMSWord20114045 {
	STMSWord20114045Paragraph = 'cpar',
	STMSWord20114045ParagraphFormat = 'w136'
};
typedef enum STMSWord20114045 STMSWord20114045;

enum STMSWord20114058 {
	STMSWord20114058Row = 'crow',
	STMSWord20114058RowOptions = 'WrOp'
};
typedef enum STMSWord20114058 STMSWord20114058;

enum STMSWord20114059 {
	STMSWord20114059Row = 'crow',
	STMSWord20114059RowOptions = 'WrOp'
};
typedef enum STMSWord20114059 STMSWord20114059;

enum STMSWord20114060 {
	STMSWord20114060Column = 'ccol',
	STMSWord20114060ColumnOptions = 'WcOp'
};
typedef enum STMSWord20114060 STMSWord20114060;

enum STMSWord20114053 {
	STMSWord20114053Table = 'ctbl',
	STMSWord20114053Column = 'ccol'
};
typedef enum STMSWord20114053 STMSWord20114053;

enum STMSWord20114052 {
	STMSWord20114052Table = 'ctbl',
	STMSWord20114052Row = 'crow',
	STMSWord20114052Column = 'ccol',
	STMSWord20114052Cell = 'ccel',
	STMSWord20114052RowOptions = 'WrOp',
	STMSWord20114052ColumnOptions = 'WcOp',
	STMSWord20114052TableStyle = 'w292',
	STMSWord20114052Condition = 'w293'
};
typedef enum STMSWord20114052 STMSWord20114052;

enum STMSWord20114057 {
	STMSWord20114057Row = 'crow',
	STMSWord20114057Cell = 'ccel',
	STMSWord20114057RowOptions = 'WrOp'
};
typedef enum STMSWord20114057 STMSWord20114057;

enum STMSWord20114056 {
	STMSWord20114056Column = 'ccol',
	STMSWord20114056Cell = 'ccel',
	STMSWord20114056ColumnOptions = 'WcOp'
};
typedef enum STMSWord20114056 STMSWord20114056;

enum STMSWord20114054 {
	STMSWord20114054Table = 'ctbl',
	STMSWord20114054Column = 'ccol'
};
typedef enum STMSWord20114054 STMSWord20114054;

enum STMSWord20114055 {
	STMSWord20114055Table = 'ctbl',
	STMSWord20114055Column = 'ccol'
};
typedef enum STMSWord20114055 STMSWord20114055;

@protocol STMSWord2011GenericMethods

- (void) closeSaving:(STMSWord2011Savo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size in bytes of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) openFileName:(NSString *)fileName confirmConversions:(BOOL)confirmConversions readOnly:(BOOL)readOnly addToRecentFiles:(BOOL)addToRecentFiles passwordDocument:(NSString *)passwordDocument passwordTemplate:(NSString *)passwordTemplate Revert:(BOOL)Revert writePassword:(NSString *)writePassword writePasswordTemplate:(NSString *)writePasswordTemplate fileConverter:(STMSWord2011E162)fileConverter;  // Open the specified object(s). Returns a reference to the opened file when using the file name parameter.
- (void) printWithProperties:(STMSWord2011PrintSettings *)withProperties printDialog:(BOOL)printDialog;  // Print the specified object(s)
- (void) saveIn:(NSURL *)in_ as:(NSNumber *)as;  // Save an object
- (void) select;  // Make a selection
- (STMSWord2011MathObject *) addMathArgumentBeforeArg:(NSInteger)beforeArg toFunction:(STMSWord2011MathFunction *)toFunction toMatrixRow:(STMSWord2011MathMatrixRow *)toMatrixRow toMatrixColumn:(STMSWord2011MathMatrixColumn *)toMatrixColumn;  // Inserts an argument into an equation with variable number of arguments, i.e. math delimiter and math equation array objects, and returns a math object object. You must specify only one function, row, or argument.
- (void) autoPullLocksLocalDocument:(STMSWord2011Document *)localDocument serverDocument:(STMSWord2011Document *)serverDocument baseDocument:(STMSWord2011Document *)baseDocument;
- (void) autosaveDocument:(STMSWord2011Document *)document;  // Causes an autosave to occur for the given document or all documents if no document is specified.
- (BOOL) canCheckOutFileName:(NSString *)fileName;  // Returns True if Word can check out a specified document from a server.
- (void) checkOutFileName:(NSString *)fileName;  // Copies a specified document from a server to a local computer for editing. Returns a String that represents the local path and file name of the document checked out.
- (void) duplicatePage;  // Duplicates the page of the current selection and moves the selection to the new page. This command only works when in Publishing Layout View.
- (void) insertPage;  // Insert a page following the page of the current selection.
- (void) removePage;  // Removes the page of the selection and moves the selection to the following page. When removing the last page, the selection is moved to the previous page. This command only works when in Publishing Layout View.
- (void) threeWayMergeLocalDocument:(STMSWord2011Document *)localDocument serverDocument:(STMSWord2011Document *)serverDocument baseDocument:(STMSWord2011Document *)baseDocument favorSource:(BOOL)favorSource;
- (void) toggleShowCodes;

@end



/*
 * Standard Suite
 */

// A scriptable object
@interface STMSWord2011BaseObject : SBObject <STMSWord2011GenericMethods>

@property (copy) NSDictionary *properties;  // All of the object's properties


@end

// A basic application program
@interface STMSWord2011BaseApplication : STMSWord2011BaseObject

@property (readonly) BOOL frontmost;  // Is this the frontmost application?
@property (copy, readonly) NSString *name;  // the name
@property (copy, readonly) NSString *version;  // the version of the application


@end

// A basic document
@interface STMSWord2011BaseDocument : STMSWord2011BaseObject

@property (readonly) BOOL modified;  // Has the document been modified since the last save?
@property (copy, readonly) NSString *name;  // the name


@end

// A basic window
@interface STMSWord2011BasicWindow : STMSWord2011BaseObject

@property NSRect bounds;  // the boundary rectangle for the window
@property (readonly) BOOL closeable;  // Does the window have a close box?
@property (readonly) BOOL titled;  // Does the window have a title bar?
@property (readonly) NSInteger entryIndex;  // the number of the window
@property (readonly) BOOL floating;  // Does the window float?
@property (readonly) BOOL modal;  // Is the window modal?
@property NSPoint position;  // upper left coordinates of the window
@property (readonly) BOOL resizable;  // Is the window resizable?
@property (readonly) BOOL zoomable;  // Is the window zoomable?
@property BOOL zoomed;  // Is the window zoomed?
@property (copy, readonly) NSString *name;  // the title of the window
@property (readonly) BOOL visible;  // Is the window visible?
@property (readonly) BOOL collapsable;  // Is the window collapasable?
@property BOOL collapsed;  // Is the window collapsed?
@property (readonly) BOOL sheet;  // Is this window a sheet window?


@end

@interface STMSWord2011PrintSettings : SBObject <STMSWord2011GenericMethods>

@property NSInteger copies;  // the number of copies of a document to be printed 
@property BOOL collating;  // Should printed copies be collated?
@property NSInteger startingPage;  // the first page of the document to be printed
@property NSInteger endingPage;  // the last page of the document to be printed
@property NSInteger pagesAcross;  // number of logical pages laid across a physical page
@property NSInteger pagesDown;  // number of logical pages laid out down a physical page
@property STMSWord2011Enum errorHandling;  // how errors are handled
@property (copy) NSString *faxNumber;  // for fax number
@property (copy) NSString *targetPrinter;  // the queue name of the target printer


@end



/*
 * Microsoft Office Suite
 */

// A control within a command bar.
@interface STMSWord2011CommandBarControl : STMSWord2011BaseObject

@property BOOL beginGroup;  // Returns or sets if the command bar control appears at the beginning of a group of controls on the command bar.
@property (readonly) BOOL builtIn;  // Returns true if the command bar control is a built-in command bar control.
@property (readonly) STMSWord2011MCLT controlType;  // Returns the type of the command bar control.
@property (copy) NSString *descriptionText;  // Returns or sets the description for a command bar control.  The description is not displayed to the user, but it can be useful for documenting the behavior of a control.
@property BOOL enabled;  // Returns or sets if the command bar control is enabled.
@property (readonly) NSInteger entry_index;  // Returns the index number for this command bar control.
@property NSInteger height;  // Returns or sets the height of a command bar control.
@property NSInteger helpContextID;  // Returns or sets the help context ID number for the Help topic attached to the command bar control.
@property (copy) NSString *helpFile;  // Returns or sets the file name for the help topic attached to the command bar.  To use this property, you must also set the help context ID property.
- (NSInteger) id;  // Returns the id for a built-in command bar control.
@property (readonly) NSInteger leftPosition;  // Returns the left position of the command bar control.
@property (copy) NSString *name;  // Returns or sets the caption text for a command bar control.
@property (copy) NSString *parameter;  // Returns or sets a string that is used to execute a command.
@property NSInteger priority;  // Returns or sets the priority of a command bar control. A controls priority determines whether the control can be dropped from a docked command bar if the command bar controls can not fit in a single row.  Valid priority number are 0 through 7.
@property (copy) NSString *tag;  // Returns or sets information about the command bar control, such as data that can be used as an argument in procedures, or information that identifies the control.
@property (copy) NSString *tooltipText;  // Returns or sets the text displayed in a command bar controls tooltip.
@property (readonly) NSInteger top;  // Returns the top position of a command bar control.
@property BOOL visible;  // Returns or sets if the command bar control is visible.
@property NSInteger width;  // Returns or sets the width in pixels of the command bar control.

- (void) execute;  // Runs the procedure or built-in command assigned to the specified command bar control.

@end

// A button control within a command bar.
@interface STMSWord2011CommandBarButton : STMSWord2011CommandBarControl

@property (readonly) BOOL buttonFaceIsDefault;  // Returns if the face of a command bar button control is the original built-in face.
@property STMSWord2011MBns buttonState;  // Returns or set the appearance of a command bar button control.  The property is read-only for built-in command bar buttons.
@property STMSWord2011MBTs buttonStyle;  // Returns or sets the way a command button control is displayed.
@property NSInteger faceId;  // Returns or sets the Id number for the face of the command bar button control.


@end

// A combobox menu control within a command bar.
@interface STMSWord2011CommandBarCombobox : STMSWord2011CommandBarControl

@property STMSWord2011MXcb comboboxStyle;  // Returns or sets the way a command bar combobox control is displayed.
@property (copy) NSString *comboboxText;  // Returns or sets the text in the display or edit portion of the command bar combobox control.
@property NSInteger dropDownLines;  // Returns or sets the number of lines in a command bar control combobox control.  The combobox control must be a custom control.
@property NSInteger dropDownWidth;  // Returns or sets the width in pixels of the list for the specified command bar combobox control.  An error occurs if you attempt to set this property for a built-in combobox control.
@property NSInteger listIndex;

- (void) addItemToComboboxComboboxItem:(NSString *)comboboxItem entry_index:(NSInteger)entry_index;  // Add a new string to a custom combobox control.
- (void) clearCombobox;  // Clear all of the strings form a custom combobox.
- (NSString *) getComboboxItemEntry_index:(NSInteger)entry_index;  // Return the string at the given index within a combobox.
- (NSInteger) getCountOfComboboxItems;  // Return the number of strings within a combobox.
- (void) removeAnItemFromComboboxEntry_index:(NSInteger)entry_index;  // Remove a string from a custom combobox.
- (void) setComboboxItemEntry_index:(NSInteger)entry_index comboboxItem:(NSString *)comboboxItem;  // Set the string an a given index for a custom combobox.

@end

// A popup menu control within a command bar.
@interface STMSWord2011CommandBarPopup : STMSWord2011CommandBarControl

- (SBElementArray<STMSWord2011CommandBarControl *> *) commandBarControls;


@end

// Toolbars used in all of the Office applications.
@interface STMSWord2011CommandBar : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011CommandBarControl *> *) commandBarControls;

@property STMSWord2011MBPS barPosition;  // Returns or sets the position of the command bar.
@property (readonly) STMSWord2011MBTY barType;  // Returns the type of this command bar.
@property (readonly) BOOL builtIn;  // True if the command bar is built-in.
@property (copy, readonly) NSString *context;  // Returns or sets a string that determines where a command bar will be saved.
@property (readonly) BOOL embeddable;  // Returns if the command bar can be displayed inside the document window.
@property BOOL embedded;  // Returns or sets if the command bar will be displayed inside the document window.
@property BOOL enabled;  // Returns or set if the command bar is enabled.
@property (readonly) NSInteger entry_index;  // The index of the command bar.
@property NSInteger height;  // Returns or sets the height of the command bar.
@property NSInteger leftPosition;  // Returns or sets the left position of the command bar.
@property (copy) NSString *localName;  // Returns or sets the name of the command bar in the localized language of the application.  An error is returned when trying to set the local name of a built-in command bar.
@property (copy) NSString *name;  // Returns or sets the name of the command bar.
@property (copy) NSArray *protection;  // Returns or sets the way a command bar is protected from user customization.  It accepts a list of the following items: no protection, no customize, no resize, no move, no change visible, no change dock, no vertical dock, no horizontal dock.
@property NSInteger rowIndex;  // Returns or sets the docking order of a command bar in relation to other command bars in the same docking area.  Can be an integer greater than zero.
@property NSInteger top;  // Returns or sets the top position of a command bar.
@property BOOL visible;  // Returns or sets if the command bar is visible.
@property NSInteger width;  // Returns or sets the width in pixels of the command bar.


@end

@interface STMSWord2011DocumentProperty : STMSWord2011BaseObject

@property (copy) NSNumber *documentPropertyType;  // Returns or sets the document property type.
@property (copy) NSString *linkSource;  // Returns or sets the source of a lined custom document property.
@property BOOL linkToContent;  // True if the value of the document property is lined to the content of the container document.  False if the value is static.  This only applies to custom document properties.  For built-in properties this is always false.
@property (copy) NSString *name;  // Returns or sets the name of the document property.
@property (copy) NSString *value;  // Returns or sets the value of the document property.


@end

@interface STMSWord2011CustomDocumentProperty : STMSWord2011DocumentProperty


@end

@interface STMSWord2011WebPageFont : STMSWord2011BaseObject

@property (copy) NSString *fixedWidthFont;  // Returns or sets the fixed-width font setting.
@property double fixedWidthFontSize;  // Returns or sets the fixed-width font size.  You can enter half-point sizes; if you enter other fractional point sizes, they are rounded up or down to the nearest half-point.
@property (copy) NSString *proportionalFont;  // Returns or sets the proportional font setting.
@property double proportionalFontSize;  // Returns or sets the proportional font size.  You can enter half-point sizes; if you enter other fractional point sizes, they are rounded up or down to the nearest half-point.


@end



/*
 * Microsoft Word Suite
 */

// Represents a single comment.
@interface STMSWord2011WordComment : STMSWord2011BaseObject

@property (copy) NSString *author;
@property (readonly) NSInteger commentIndex;
@property (copy, readonly) STMSWord2011TextRange *commentText;
@property (copy, readonly) NSDate *dateValue;
@property (copy) NSString *initials;
@property (copy, readonly) STMSWord2011TextRange *noteReference;
@property (copy, readonly) STMSWord2011TextRange *scope;
@property (readonly) BOOL showTip;


@end

// Represents a single list format that's been applied to specified paragraphs in a document.
@interface STMSWord2011WordList : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Paragraph *> *) paragraphs;

@property (readonly) BOOL singleListTemplate;  // Returns if the entire Word list object uses the same list template.
@property (copy, readonly) NSString *styleName;
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the Word list.

- (void) applyListTemplateListTemplate:(STMSWord2011ListTemplate *)listTemplate continuePreviousList:(BOOL)continuePreviousList defaultListBehavior:(STMSWord2011E289)defaultListBehavior;  // Applies a set of list-formatting characteristics to the specified Word list object.

@end

// Represents application and document options in Word.
@interface STMSWord2011WordOptions : STMSWord2011BaseObject

@property BOOL EnableMisusedWordsDictionary;  // Returns or sets if Microsoft Word checks for misused words when checking the spelling and grammar in a document.
@property BOOL IMEAutomaticControl;  // Returns or sets if Microsoft Word is set to automatically open and close the Japanese Input Method Editor. 
@property BOOL RTFInClipboard;  // Returns or sets if all text copied from Word to the Clipboard retains its character and paragraph formatting.
@property BOOL allowAccentedUppercase;  // Returns or sets if accents are retained when a French language character is changed to uppercase.
@property BOOL allowClickAndTypeMouse;  // Returns or sets if click and type functionality is enabled.
@property BOOL allowDragAndDrop;  // Returns or sets if dragging and dropping can be used to move or copy a selection.
@property BOOL allowFastSave;  // Returns or sets if Word saves only changes to a document. When reopening the document, Word uses the saved changes to reconstruct the document.
@property BOOL animateScreenMovements;  // Returns or sets if Word animates mouse movements, uses animated cursors, and animates actions such as background saving and find and replace operations.
@property BOOL applyEastAsianFontsToAscii;  // Returns or sets if Microsoft Word applies East Asian fonts to Latin text.
@property BOOL autoFormatApplyBulletedLists;  // Returns or sets if characters, such as asterisks, hyphens, and greater-than signs, at the beginning of list paragraphs are replaced with bullets from the Bullets and Numbering dialog box when Word formats a document or range automatically.
@property BOOL autoFormatApplyHeadings;  // Returns or sets if styles are automatically applied to headings when Word formats a document or range automatically.
@property BOOL autoFormatApplyLists;  // Returns or sets if  if styles are automatically applied to lists when Word formats a document or range automatically.
@property BOOL autoFormatApplyOtherParagraphs;  // Returns or sets if styles are automatically applied to paragraphs that aren't headings or list items when Word formats a document or range automatically.
@property BOOL autoFormatAsYouTypeApplyBorders;  // Returns or sets if a series of three or more hyphens -, equal signs =, or underscore characters _ are automatically replaced by a specific border line when the ENTER key is pressed.
@property BOOL autoFormatAsYouTypeApplyBulletedLists;  // Returns or sets if bullet characters, such as asterisks, hyphens, and greater-than signs, are replaced with bullets from the bullets and numbering dialog box as you type.
@property BOOL autoFormatAsYouTypeApplyClosings;  // Returns or sets if Microsoft Word to automatically applies the closing style to letter closings as you type.
@property BOOL autoFormatAsYouTypeApplyDates;  // Returns or sets if Microsoft Word  automatically applies the date style to dates as you type.
@property BOOL autoFormatAsYouTypeApplyFirstIndents;  // Returns or sets if Microsoft Word automatically replaces a space entered at the beginning of a paragraph with a first-line indent.
@property BOOL autoFormatAsYouTypeApplyHeadings;  // Returns or sets if styles are automatically applied to headings as you type.
@property BOOL autoFormatAsYouTypeApplyNumberedLists;  // Returns or sets if paragraphs are automatically formatted as numbered lists with a numbering scheme from the Bullets and Numbering dialog box according to what's typed.
@property BOOL autoFormatAsYouTypeApplyTables;  // Returns or set if Word automatically creates a table when you type a plus sign, a series of hyphens, another plus sign, and so on, and then press ENTER. The plus signs become the column borders, and the hyphens become the column widths.
@property BOOL autoFormatAsYouTypeAutoLetterWizard;  // Returns or sets if Microsoft Word to automatically starts the Letter Wizard when the user enters a letter salutation or closing.
@property BOOL autoFormatAsYouTypeDefineStyles;  // Returns or sets if Word automatically creates new styles based on manual formatting.
@property BOOL autoFormatAsYouTypeDeleteAutoSpaces;  // Returns or sets if Microsoft Word to automatically deletes spaces inserted between Japanese and Latin text as you type.
@property BOOL autoFormatAsYouTypeFormatListItemBeginning;  // Returns or sets if Word repeats character formatting applied to the beginning of a list item to the next list item.
@property BOOL autoFormatAsYouTypeInsertClosings;  // Returns or sets if Microsoft Word to automatically inserts the corresponding memo closing when the user enters a memo heading.
@property BOOL autoFormatAsYouTypeInsertOvers;  // Returns or sets if Word will automatically inset certain Japanese characters for other Japanese characters.
@property BOOL autoFormatAsYouTypeMatchParentheses;  // Returns or sets if Microsoft Word to automatically corrects improperly paired parentheses.
@property BOOL autoFormatAsYouTypeReplaceEastAsianDashes;  // Returns or sets if Microsoft Word to automatically corrects long vowel sounds and dashes.
@property BOOL autoFormatAsYouTypeReplaceFractions;  // Returns or sets if typed fractions are replaced with fractions from the current character set as you type.
@property BOOL autoFormatAsYouTypeReplaceHyperlinks;  // Returns or sets if e-mail addresses, server and share names, also known as UNC paths, and Internet addresses, also known as URLs, are automatically changed to hyperlinks as you type.
@property BOOL autoFormatAsYouTypeReplaceOrdinals;  // Returns or sets if the ordinal number suffixes st, nd, rd, and th are replaced with the same letters in superscript as you type. For example, 1st is replaced with 1 followed by st formatted as superscript.
@property BOOL autoFormatAsYouTypeReplacePlainTextEmphasis;  // Returns or sets if manual emphasis characters are automatically replaced with character formatting as you type.
@property BOOL autoFormatAsYouTypeReplaceQuotes;  // Returns or sets if straight quotation marks are automatically changed to smart, curly, quotation marks as you type.
@property BOOL autoFormatAsYouTypeReplaceSymbols;  // Returns or sets if two consecutive hyphens -- are replaced with an en dash – or an em dash — as you type.
@property BOOL autoFormatDeleteAutoSpaces;  // Returns or sets if Microsoft Word deletes spaces inserted between Japanese and Latin text, when Word formats a document or range automatically.
@property BOOL autoFormatMatchParentheses;  // Returns or sets if Microsoft Word  automatically corrects improperly paired parentheses.
@property BOOL autoFormatPreserveStyles;  // Returns or sets if previously applied styles are preserved when Word formats a document or range automatically.
@property BOOL autoFormatReplaceEastAsianDashes;  // Returns or sets if Microsoft Word automatically corrects long vowel sounds and dashes.
@property BOOL autoFormatReplaceFirstIndents;  // Returns or sets for Microsoft Word to automatically replace a space entered at the beginning of a paragraph with a first-line indent.
@property BOOL autoFormatReplaceFractions;  // Returns or sets if typed fractions are replaced with fractions from the current character set when Word formats a document or range automatically.
@property BOOL autoFormatReplaceHyperlinks;  // Returns or sets if e-mail addresses, server and share names, also known as UNC paths, and Internet addresses, also known as URLS, are changed to hyperlinks, when Word formats a document or range automatically.
@property BOOL autoFormatReplaceOrdinals;  // Returns or sets if the ordinal number suffixes st, nd, rd, and th are replaced with the same letters in superscript when Word formats a document or range automatically. For example, 1st is replaced with 1 followed by st formatted as superscript.
@property BOOL autoFormatReplacePlainTextEmphasis;  // Returns or sets if manual emphasis characters are replaced with character formatting when Word formats a document or range automatically.
@property BOOL autoFormatReplaceQuotes;  // Returns or sets if straight quotation marks are automatically changed to smart, curly, quotation marks when Word formats a document or range automatically.
@property BOOL autoFormatReplaceSymbols;  // Returns or set if two consecutive hyphens -- are replaced by an en dash – or an em dash — when Word formats a document or range automatically.
@property BOOL autoWordSelection;  // Returns or sets if dragging selects one word at a time instead of one character at a time.
@property BOOL automaticallyBuildUpEquations;  // Returns or sets whether Microsoft Word automatically converts equations to professional format.
@property BOOL ayMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between some Japanese characters.
@property BOOL blueScreen;  // Returns or sets if Word displays text as white characters on a blue background.
@property NSInteger buttonFieldClicks;  // Returns or sets the number of clicks, either one or two, required to run a GOTOBUTTON or MACROBUTTON field.
@property BOOL bvMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between some Japanese characters.
@property BOOL byteMatchFuzzy;  // Returns or sets Microsoft Word ignores the distinction between full-width and half-width characters, Latin or Japanese, during a search.
@property BOOL caseMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between uppercase and lowercase letters during a search.
@property BOOL checkGrammarAsYouType;  // Returns or sets if Word checks grammar and marks errors automatically as you type.
@property BOOL checkGrammarWithSpelling;  // Returns or sets if Word checks grammar while checking spelling.
@property BOOL checkSpellingAsYouType;  // Returns or sets if Word checks spelling and marks errors automatically as you type.
@property STMSWord2011E110 commentsColor;  // Returns or sets the color of comments.
@property BOOL confirmConversions;  // Returns or sets if Word displays the convert file dialog box before it opens or inserts a file that isn't a Word document or template. In the convert file dialog box, the user chooses the format to convert the file from.
@property BOOL convertHighAnsiToEastAsian;  // Returns or sets if Microsoft Word converts text that is associated with an East Asian font to the appropriate font when it opens a document.
@property BOOL createBackup;  // Returns or sets if Word creates a backup copy each time a document is saved.
@property BOOL dashMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between minus signs, long vowel sounds, and dashes during a search.
@property (copy) NSColor *defaultBorderColor;  // Returns or sets the default RGB color to use for new border objects.
@property STMSWord2011E110 defaultBorderColorIndex;  // Returns or sets the default line color index for borders.
@property STMSWord2011MCoI defaultBorderColorThemeIndex;  // Returns or sets the default line color for borders.
@property STMSWord2011E167 defaultBorderLineStyle;  // Returns or sets the default border line style
@property STMSWord2011E168 defaultBorderLineWidth;  // Returns or sets the default line width of borders.
@property STMSWord2011E110 defaultHighlightColorIndex;  // Returns or sets the color index  used to highlight text formatted with the highlight button.
@property STMSWord2011E162 defaultOpenFormat;  // Returns or sets the default file converter used to open documents.
@property STMSWord2011E318 deletedCellColor;  // Returns or sets the color of cells that are deleted while change tracking is enabled.
@property STMSWord2011E110 deletedTextColor;  // Returns or sets the color of text that is deleted while change tracking is enabled.
@property STMSWord2011E227 deletedTextMark;  // Returns or sets the format of text that is deleted while change tracking is enabled.
@property BOOL displayGridLines;  // Returns or sets if Microsoft Word displays the document grid. 
@property BOOL displayPasteOptions;  // Returns or sets if Microsoft Word  displays the Paste Options button, which displays directly under newly pasted text.
@property BOOL dzMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between some Japanese characters.
@property BOOL enableSound;  // Returns or sets if Word makes the computer respond with a sound whenever an error occurs.
@property (readonly) BOOL envelopeFeederInstalled;  // Returns true if the current printer has a special feeder for envelopes.
@property BOOL fancyFontMenu;  // Returns or sets if the fancy font menu is shown.
@property double gridDistanceHorizontal;  // Returns or sets the amount of horizontal space between the invisible gridlines that Word uses when you draw, move, and resize autoshapes or East Asian characters in new documents.
@property double gridDistanceVertical;  // Returns or sets the amount of vertical space between the invisible gridlines that Word uses when you draw, move, and resize autoshapes or East Asian characters in new documents.
@property double gridOriginHorizontal;  // Returns or sets the point, relative to the left edge of the page, where you want the invisible grid for drawing, moving, and resizing autoshapes or East Asian characters to begin in new documents.
@property double gridOriginVertical;  // Returns or sets the point, relative to the top of the page, where you want the invisible grid for drawing, moving, and resizing autoshapes or East Asian characters to begin in new documents.
@property BOOL hfMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between some Japanese characters.
@property BOOL hiraganaMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between hiragana and katakana during a search.
@property BOOL ignoreInternetAndFileAddresses;  // Returns or sets if file name extensions,  paths, e-mail addresses, server and share names, also known as UNC paths, and Internet addresses, also known as URLs, are ignored while checking spelling.
@property BOOL ignoreMixedDigits;  // Returns or sets if words that contain numbers are ignored while checking spelling.
@property BOOL ignoreUppercase;  // Returns or sets if words in all uppercase letters are ignored while checking spelling.
@property BOOL inlineConversion;  // Returns or sets if Microsoft Word displays an unconfirmed character string in the Japanese Input Method Editor as an insertion between existing character strings.
@property BOOL insertKeyForPaste;  // Returns or sets if the insert key can be used for pasting the clipboard contents.
@property STMSWord2011E318 insertedCellColor;  // Returns or sets the color of cells that are inserted while change tracking is enabled.
@property STMSWord2011E110 insertedTextColor;  // Returns or sets the color of text that is inserted while change tracking is enabled.
@property STMSWord2011E225 insertedTextMark;  // Returns or sets how Microsoft Word formats inserted text while change tracking is enabled. If change tracking is not enabled, this property is ignored. Use this property with the inserted text color property to control the look of inserted text.
@property BOOL iterationMarkMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between types of repetition marks during a search.
@property BOOL kanjiMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between standard and nonstandard kanji ideography during a search.
@property BOOL keepTrackOfFormatting;  // Returns or sets if Microsoft Word keeps track of formatting.
@property BOOL kiKuMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between some Japanese characters.
@property BOOL liveWordCount;  // Returns or sets if the instant word count is displayed in the status bar.
@property BOOL mapPaperSize;  // Returns or sets if documents formatted for another country's or region's standard paper size, for example, A4 are automatically adjusted so that they're printed correctly on your country's/region's standard paper size, for example, Letter.
@property STMSWord2011E171 measurementUnit;  // Returns or sets the standard measurement unit for Microsoft Word.
@property STMSWord2011E318 mergedCellColor;  // Returns or sets the color of cells that are merged while change tracking is enabled.
@property STMSWord2011E110 moveFromTextColor;  // Returns or sets the color of text that is moved from while change tracking is enabled.
@property STMSWord2011E317 moveFromTextMark;  // Returns or sets how Microsoft Word formats moved text while change tracking is enabled. If change tracking is not enabled, this property is ignored. Use this property with the moved text color property to control the look of moved text.
@property STMSWord2011E110 moveToTextColor;  // Returns or sets the color of text that is moved to while change tracking is enabled.
@property STMSWord2011E316 moveToTextMark;  // Returns or sets how Microsoft Word formats moved text while change tracking is enabled. If change tracking is not enabled, this property is ignored. Use this property with the moved text color property to control the look of moved text.
@property BOOL oldKanaMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between new kana and old kana characters during a search.
@property BOOL overtype;  // Returns or sets if overtype mode is active. In overtype mode, the characters you type replace existing characters one by one. When overtype isn't active, the characters you type move existing text to the right.
@property BOOL pagination;  // Returns or sets if Microsoft Word repaginates documents in the background.
@property BOOL pasteAdjustParagraphSpacing;  // Returns or sets if Microsoft Word automatically adjusts the spacing of paragraphs when cutting and pasting selections.
@property BOOL pasteAdjustTableFormatting;  // Returns or sets if Microsoft Word automatically adjusts the formatting of tables when cutting and pasting selections.
@property BOOL pasteAdjustWordSpacing;  // Returns or sets if Microsoft Word automatically adjusts the spacing of words when cutting and pasting selections.
@property BOOL pasteMergeFromExcel;  // Returns or sets if text formatting will be merged when pasting from Microsoft Excel.
@property BOOL pasteMergeFromPowerPoint;  // Returns or sets if text formatting will be merged when pasting from Microsoft PowerPoint.
@property BOOL pasteMergeLists;  // Returns or sets if the formatting of pasted lists will be merged with surrounding lists.
@property BOOL pasteSmartCutPaste;  // Returns or sets if Microsoft Word intelligently pastes selections into a document.
@property BOOL pasteSmartStyleBehavior;  // Returns or sets if Microsoft Word intelligently merges styles when pasting a selection from a different document.
@property (copy) NSString *pictureEditor;  // Returns or sets the name of the application to use to edit pictures.
@property STMSWord2011E312 pictureWrapTypes;  // Returns or sets the wrapping that is used to insert or paste pictures.
@property BOOL plainEquationsUsePlainText;  // Returns or sets if equations are represented in plain text; false uses MathML
@property BOOL printComments;  // Returns or sets if Microsoft Word prints comments, starting on a new page at the end of the document.
@property BOOL printDrawingObjects;  // Returns or sets if Microsoft Word prints drawing objects.
@property BOOL printFieldCodes;  // Returns or sets if Microsoft Word prints field codes instead of field results.
@property BOOL printHiddenText;  // Returns or sets if hidden text is printed.
@property BOOL printProperties;  // Returns or sets if Microsoft Word prints document summary information on a separate page at the end of the document. 
@property BOOL printReverse;  // Returns or sets if Microsoft Word prints pages in reverse order.
@property BOOL prolongedSoundMarkMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between short and long vowel sounds during a search.
@property BOOL punctuationMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between types of punctuation marks during a search.
@property BOOL replaceSelection;  // Returns or sets if the result of typing or pasting replaces the selection. If false the result of typing or pasting is added before the selection, leaving the selection intact.
@property STMSWord2011E110 revisedLinesColor;  // Returns or sets the color of changed lines in a document with tracked changes.
@property STMSWord2011E226 revisedLinesMark;  // Returns or sets the placement of changed lines in a document with tracked changes.
@property STMSWord2011E110 revisedPropertiesColor;  // Returns or sets the color index used to mark formatting changes while change tracking is enabled. 
@property STMSWord2011E228 revisedPropertiesMark;  // Returns or sets the mark used to show formatting changes while change tracking is enabled.
@property NSInteger saveInterval;  // Returns or sets the time interval in minutes for saving autorecover information.
@property BOOL saveNormalPrompt;  // Returns or sets if Microsoft Word prompts the user for confirmation to save changes to the Normal template before it quits. if this is set to false Word automatically saves changes to the Normal template before it quits.
@property BOOL savePropertiesPrompt;  // Returns or sets if Microsoft Word prompts for document property information when saving a new document.
@property BOOL sendMailAttach;  // True if the send to command on the file menu inserts the active document as an attachment to a mail message. False if the send to command inserts the contents of the active document as text in a mail message.
@property BOOL showReadabilityStatistics;  // Returns or sets if Microsoft Word displays a list of summary statistics, including measures of readability, when it has finished checking grammar.
@property BOOL showWizardWelcome;  // Returns or sets if the welcome wizard should be shown.
@property BOOL smallKanaMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between diphthongs and double consonants during a search.
@property BOOL smartCutPaste;  // Returns or sets if Microsoft Word automatically adjusts the spacing between words and punctuation when cutting and pasting occurs.
@property BOOL smartParagraphSelection;  // Returns or sets if Microsoft Word includes the paragraph mark in a selection when selecting most or all of a paragraph.
@property BOOL snapToGrid;  // Returns or sets if AutoShapes or East Asian characters are automatically aligned with an invisible grid when they are drawn, moved, or resized in new documents.
@property BOOL snapToShapes;  // Returns or sets if Word automatically aligns autoshapes or East Asian characters with invisible gridlines that go through the vertical and horizontal edges of other autoshapes or East Asian characters in new documents.
@property BOOL spaceMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between space markers used during a search.
@property STMSWord2011E318 splitCellColor;  // Returns or sets the color of cells that are split while change tracking is enabled.
@property BOOL suggestFromMainDictionaryOnly;  // Returns or sets if Microsoft Word draws spelling suggestions from the main dictionary only. If false it draws spelling suggestions from the main dictionary and any custom dictionaries that have been added.
@property BOOL suggestSpellingCorrections;  // Returns or sets if Microsoft Word always suggests alternative spellings for each misspelled word when checking spelling.
@property BOOL tabIndentKey;  // Returns or sets if the TAB and BACKSPACE keys can be used to increase and decrease, respectively, the left indent of paragraphs and if the BACKSPACE key can be used to change right-aligned paragraphs to centered and centered paragraphs to left-aligned.
@property BOOL tcMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between some Japanese characters.
@property BOOL trackFormatting;  // Returns or sets tracking formatting flag.
@property BOOL trackMoves;  // Returns or sets tracking moves flag.
@property BOOL updateFieldsAtPrint;  // Returns or sets if Microsoft Word updates fields automatically before printing a document. 
@property BOOL updateLinksAtOpen;  // Returns or sets if Microsoft Word automatically updates all embedded OLE links in a document when it's opened.
@property BOOL updateLinksAtPrint;  // Returns or sets if Microsoft Word updates fields automatically before printing a document.
@property BOOL useCharacterUnit;  // Returns or sets if Microsoft Word uses characters as the default measurement unit for the current document.
@property BOOL useGermanSpellingReform;  // Returns or sets if Microsoft Word uses the German post-reform spelling rules when checking spelling.
@property BOOL warnBeforeSavingPrintingSendingMarkup;  // Returns or sets if Microsoft Word displays a warning when saving, printing, or sending as e-mail a document containing comments or tracked changes.
@property BOOL zjMatchFuzzy;  // Returns or sets if Microsoft Word ignores the distinction between some Japanese characters.


@end

// Represents a single add-in, either installed or not installed.
@interface STMSWord2011AddIn : STMSWord2011BaseObject

@property (readonly) BOOL autoload;  // Returns true if the specified add-in is automatically loaded when Word is started.
@property (readonly) BOOL compiled;  // Returns true if the specified add-in is a Word add-in library. False if the add-in is a template.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property BOOL installed;  // Returns or sets if the specified add-in is installed.
@property (copy, readonly) NSString *name;  // Returns the name of the add in.
@property (copy, readonly) NSString *path;  // Returns the disk or Web path to the specified add-in.


@end

// An AppleScript object representing the Microsoft Word application.
@interface STMSWord2011Application : SBApplication

- (SBElementArray<STMSWord2011Document *> *) documents;
- (SBElementArray<STMSWord2011Window *> *) windows;
- (SBElementArray<STMSWord2011RecentFile *> *) recentFiles;
- (SBElementArray<STMSWord2011FileConverter *> *) fileConverters;
- (SBElementArray<STMSWord2011CaptionLabel *> *) captionLabels;
- (SBElementArray<STMSWord2011AddIn *> *) addIns;
- (SBElementArray<STMSWord2011CommandBar *> *) commandBars;
- (SBElementArray<STMSWord2011Template *> *) templates;
- (SBElementArray<STMSWord2011KeyBinding *> *) keyBindings;
- (SBElementArray<STMSWord2011Dictionary *> *) dictionaries;

@property BOOL Word51Menus;  // Returns or sets if Word 5.1 menus should be used.
@property (copy, readonly) STMSWord2011Document *activeDocument;  // Returns the currently active document object.
@property (copy) NSString *activePrinter;  // Returns or sets the name of the active printer
@property (copy, readonly) STMSWord2011Window *activeWindow;  // Returns the currently active window object.
@property (copy, readonly) NSString *applicationVersion;  // Returns the Microsoft Word version number as a string.
@property (copy, readonly) STMSWord2011Autocorrect *autocorrectObject;  // Returns the autocorrect object
@property (readonly) NSInteger backgroundPrintingStatus;  // Returns the number of print jobs in the background printing queue.
@property (copy) NSString *browseExtraFileTypes;  // Returns or sets to open hyperlinked HTML files in the Internet browser or Microsoft Word.  Set this property to text/html to allow hyperlinked HTML files to be opened in Microsoft Word.
@property (copy, readonly) STMSWord2011Browser *browserObject;  // Returns the browser object.  The browser object is a tool used to move the insertion point to objects in a document.
@property (copy, readonly) NSString *build;  // Returns the version and build number of the Microsoft Word application.
@property (readonly) BOOL capsLock;  // Returns if caps lock is turned on.
@property (copy, readonly) NSString *caption;  // Returns the name of the application.
@property (copy) SBObject *customizationContext;  // Returns or set a template or document object that represents the template or document in which changes to menus, toolbars, and key bindings are stored.
@property (copy) NSString *defaultSaveFormat;  // Returns or sets the default format. Common settings include: document = WordDocument, document template = Template, Word 97-2004 document = Doc97, Word XML document = XML, web page = Html, Text only = Text, RTF = Rtf, unicode text = Unicode.
@property (copy) NSString *defaultStartupPath;  // Returns or sets the complete path of the startup folder, excluding the final separator.
@property (copy) NSString *defaultTableSeparator;  // Returns or sets the single character used to separate text into cells when text is converted to a table.
@property (copy, readonly) STMSWord2011DefaultWebOptions *defaultWebOptionsObject;  // Returns the default web options object.
@property STMSWord2011E138 displayAlerts;  // Returns or sets the way certain alerts or messages are handled while an AppleScript is running.
@property BOOL displayAutoCompleteTips;  // Returns or set if Microsoft Word displays tips that suggest text for completing words, dates, or phrases as you type.
@property BOOL displayRecentFiles;  // Returns or sets if the names of recently used files are displayed on the file menu.
@property BOOL displayRibbon;  // Returns or sets if Word displays the Ribbon in at least one document window.  Setting this property to true will display the Ribbon in all windows.  Setting this property to false turns off all Ribbons in all windows.
@property BOOL displayScreenTips;  // Returns or set if comments, footnotes, endnotes, and hyperlinks are displayed as tips.  Text marked as having comments is highlighted.
@property BOOL displayScrollBars;  // Returns or sets if Word displays a scroll bar in at least one document window.  Setting this property to true will display horizontal and vertical scrollbars in all windows.  Setting this property to false turns off all scrollbars in all windows.
@property BOOL displayStatusBar;  // Returns or sets if the status bar is displayed.
@property BOOL doPrintPreview;  // Returns or set if print preview is the current view.
@property (copy, readonly) NSArray *fontNames;  // Returns the list of names of all of the available fonts
@property NSInteger keyboardScript;  // Returns or sets the current keyboard script
@property (copy, readonly) NSArray *landscapeFontNames;  // Returns the list of names of all of the available landscape fonts
@property (readonly) NSInteger localizedLanguage;  // Returns the Windows language ID for the locale that Microsoft Word is using.
@property (copy, readonly) STMSWord2011MailingLabel *mailingLabelObject;  // Returns the mailing label object.
@property (copy, readonly) STMSWord2011MathAutocorrect *mathAc;  // Returns a math autocorrect object that represents the auto correct entries for equations.
@property (copy, readonly) NSString *name;  // Returns the name of this application.
@property (copy, readonly) STMSWord2011Template *normalTemplate;  // Returns the normal template object
@property (readonly) BOOL numLock;  // Returns the state of the num lock key.  True if the keys on the numeric keypad insert numbers, false if the keys move the insertion point.
@property (copy, readonly) NSString *path;  // Returns the path to the application
@property (copy, readonly) NSString *pathSeparator;  // Returns the character used to separate folder names.
@property (copy, readonly) NSArray *portraitFontNames;  // Returns the list of names of all of the available portrait fonts
@property BOOL ribbonExpanded;  // Returns or sets if the Ribbon in expanded.
@property (copy, readonly) STMSWord2011SelectionObject *selection;  // Returns the selection object.
@property (copy, readonly) STMSWord2011WordOptions *settings;  // Returns the word options object.
@property BOOL showVisualBasicEditor;  // Return or set if the visual basic editor is visible.
@property (readonly) BOOL specialMode;  // Returns if Microsoft Word is in a special mode for example, copy text mode or move text mode.
@property BOOL startupDialog;  // Returns of sets if the project gallery dialog will be shown when starting Microsoft Word.
@property (copy) NSString *statusBar;  // Displays the specified text in the status bar. This is a write only property.
@property (copy, readonly) STMSWord2011SystemObject *system_object;  // Returns the system object
@property (readonly) NSInteger usableHeight;  // Returns the maximum height in points to which you can set the width of a Microsoft Window document window.
@property (readonly) NSInteger usableWidth;  // Returns the maximum width in pixels to which you can set the width of a Microsoft Window document window.
@property (copy) NSString *userAddress;  // Returns of set the users mailing address.
@property (readonly) BOOL userControl;  // Returns true if the application was launched by a user.  False if the program was opened programmatically.
@property (copy) NSString *userInitials;  // Returns of sets the initials, which Microsoft Word uses to construct comment marks.
@property (copy) NSString *userName;  // Returns or sets the users name, which is used on envelopes and for the author document property.

- (void) quitSaving:(STMSWord2011Savo)saving;  // Quit an application program
- (void) select;  // Make a selection
- (id) doScript:(NSString *)x;  // Execute a script
- (void) reset:(STMSWord20114000)x;  // Resets a built-in command bar or command bar control to its default configuration.
- (void) WordHelpHelpType:(STMSWord2011E238)helpType;  // Displays on-line Help information.
- (void) accept:(STMSWord20114024)x;  // Accepts the specified tracked change. The revision marks are removed, and the change is incorporated into the document.
- (void) activateObject:(STMSWord20114004)x;  // Activate this object.
- (STMSWord2011AddIn *) addAddinFileName:(NSString *)fileName install:(BOOL)install;  // Returns an add in object that represents an add-in added to the list of available add-ins.
- (STMSWord2011CoauthLock *) addCoauthLockToRange:(STMSWord2011TextRange *)toRange toParagraph:(STMSWord2011Paragraph *)toParagraph toColumn:(STMSWord2011Column *)toColumn toCell:(STMSWord2011Cell *)toCell toRow:(STMSWord2011Row *)toRow toTable:(STMSWord2011Table *)toTable toSelection:(STMSWord2011SelectionObject *)toSelection lockType:(STMSWord2011E332)lockType inRange:(STMSWord2011SelectionObject *)inRange inCoauthoring:(STMSWord2011Coauthoring *)inCoauthoring inCoauthor:(STMSWord2011Coauthor *)inCoauthor;  // Add a co-authoring lock.
- (void) arrangeWindowsArrangeStyle:(STMSWord2011E260)arrangeStyle;  // Arrange windows on the screen.
- (NSInteger) buildKeyCodeKey1:(STMSWord2011E240)key1 key2:(STMSWord2011E240)key2 key3:(STMSWord2011E240)key3 key4:(STMSWord2011E240)key4;  // Returns a unique number for the specified key combination.
- (STMSWord2011E102) canContinuePreviousList:(STMSWord20114023)x listTemplate:(STMSWord2011ListTemplate *)listTemplate;  // Returns whether the formatting from the previous list can be continued.
- (double) centimetersToPointsCentimeters:(double)centimeters;  // Converts a measurement from centimeters to points.
- (void) changeFileOpenDirectoryPath:(NSString *)path;  // Sets the folder in which Microsoft Word searches for documents.
- (BOOL) checkGrammar:(STMSWord20114002)x textToCheck:(NSString *)textToCheck;  // Checks a string for grammatical errors. Returns a boolean to indicate whether the string contains grammatical errors. True if the string contains no errors.
- (BOOL) checkSpelling:(STMSWord20114003)x textToCheck:(NSString *)textToCheck customDictionary:(STMSWord2011Dictionary *)customDictionary ignoreUppercase:(BOOL)ignoreUppercase mainDictionary:(STMSWord2011Dictionary *)mainDictionary customDictionary2:(STMSWord2011Dictionary *)customDictionary2 customDictionary3:(STMSWord2011Dictionary *)customDictionary3 customDictionary4:(STMSWord2011Dictionary *)customDictionary4 customDictionary5:(STMSWord2011Dictionary *)customDictionary5 customDictionary6:(STMSWord2011Dictionary *)customDictionary6 customDictionary7:(STMSWord2011Dictionary *)customDictionary7 customDictionary8:(STMSWord2011Dictionary *)customDictionary8 customDictionary9:(STMSWord2011Dictionary *)customDictionary9 customDictionary10:(STMSWord2011Dictionary *)customDictionary10;  // Checks a string for spelling errors. Returns true if the string has no spelling errors.
- (NSString *) cleanStringItemToCheck:(NSString *)itemToCheck;  // Removes nonprinting characters character codes 1 – 29 and special Microsoft Word characters from the specified string or changes them to spaces character code 32. Returns the result as a string.
- (void) clear:(STMSWord20114012)x;  // Removes the object.
- (void) clearFormatting:(STMSWord20114011)x;  // Removes text and paragraph formatting from a selection or from the formatting specified in a find or replace operation.
- (void) convertNumbersToText:(STMSWord20114009)x numberType:(STMSWord2011E158)numberType;  // Changes the list numbers and listnum fields in the document object to text.
- (void) copyObject:(STMSWord20114020)x NS_RETURNS_NOT_RETAINED;  // Copies the content of the object to the clipboard.
- (NSInteger) countNumberedItems:(STMSWord20114010)x numberType:(STMSWord2011E158)numberType level:(NSInteger)level;  // Returns the number of bulleted or numbered items and listnum fields in the document object.
- (STMSWord2011Document *) createNewDocumentAttachedTemplate:(STMSWord2011Template *)attachedTemplate newTemplate:(BOOL)newTemplate newDocumentType:(STMSWord2011E291)newDocumentType;  // Create a new document
- (void) createNewEquationFromRange:(STMSWord2011TextRange *)fromRange inDocument:(STMSWord2011Document *)inDocument inRange:(STMSWord2011SelectionObject *)inRange inSelection:(STMSWord2011SelectionObject *)inSelection;  // Creates an equation, from the text equation contained within the specified range, and returns a text range object that contains the new equation.
- (void) createNewFieldTextRange:(STMSWord2011TextRange *)textRange fieldType:(STMSWord2011E183)fieldType fieldText:(NSString *)fieldText preserveFormatting:(BOOL)preserveFormatting;  // Create a new field
- (void) cutObject:(STMSWord20114021)x;  // Removes the object from the document and places it on the clipboard.
- (BOOL) doWordRepeatTimes:(NSInteger)times;  // Repeats the most recent editing action one or more times. Returns true if the commands were repeated successfully.
- (STMSWord2011KeyBinding *) findKeyKeyCode:(NSInteger)keyCode key_code_2:(STMSWord2011E240)key_code_2;  // Returns a key binding object that represents the specified key combination
- (STMSWord2011Border *) getBorder:(STMSWord20114019)x whichBorder:(STMSWord2011E122)whichBorder;  // Returns the specified border object.
- (NSString *) getDefaultFilePathFilePathType:(STMSWord2011E230)filePathType;  // Returns the default folders for items such as documents, templates, and graphics.
- (STMSWord2011Dialog *) getDialog:(STMSWord2011E186)x;  // Returns a dialog object for the specified dialog.
- (NSString *) getInternationalInformation:(STMSWord2011E115)x;  // Get the specified international information
- (NSArray *) getKeysBoundToKeyCategory:(STMSWord2011E239)keyCategory command:(NSString *)command;  // Returns a list key binding objects that represents all the key combinations assigned to the specified item.
- (STMSWord2011ListGallery *) getListGallery:(STMSWord2011E150)x;  // Returns the specified list gallery object object.
- (NSDictionary *) getSpellingSuggestionsItemToCheck:(NSString *)itemToCheck customDictionary:(STMSWord2011Dictionary *)customDictionary ignoreUppercase:(BOOL)ignoreUppercase mainDictionary:(STMSWord2011Dictionary *)mainDictionary suggestionMode:(STMSWord2011E256)suggestionMode customDictionary2:(STMSWord2011Dictionary *)customDictionary2 customDictionary3:(STMSWord2011Dictionary *)customDictionary3 customDictionary4:(STMSWord2011Dictionary *)customDictionary4 customDictionary5:(STMSWord2011Dictionary *)customDictionary5 customDictionary6:(STMSWord2011Dictionary *)customDictionary6 customDictionary7:(STMSWord2011Dictionary *)customDictionary7 customDictionary8:(STMSWord2011Dictionary *)customDictionary8 customDictionary9:(STMSWord2011Dictionary *)customDictionary9 customDictionary10:(STMSWord2011Dictionary *)customDictionary10;  // Returns a record that specifies the error kind and a list of words.  The AEKeyword for the error kind is type and AEKeyword for the list is list.
- (STMSWord2011SynonymInfo *) getSynonymInfoObjectItemToCheck:(NSString *)itemToCheck languageID:(STMSWord2011E182)languageID;  // Returns a synonym info object that contains the information from the thesaurus on the synonyms, antonyms, or related words and expressions for the specified word or phrase.
- (NSString *) getUserPropertyPropertyType:(STMSWord2011E292)propertyType;
- (STMSWord2011WebPageFont *) getWebpageFont:(STMSWord2011MChS)x;  // Return the specified web page font object for a given character set.
- (double) inchesToPointsInches:(double)inches;  // Converts a measurement from inches to points.
- (void) insertText:(NSString *)text at:(SBObject *)at;  // Insert the string at the specified location.
- (void) insertAutoTextAt:(STMSWord2011TextRange *)at;  // Attempts to match the text in the specified range or the text surrounding the range with an existing auto text entry name.  If any such match is found, the auto text entry is inserted.  If no match an error occurs.
- (void) insertBreakAt:(STMSWord2011TextRange *)at breakType:(STMSWord2011E169)breakType;  // Inserts a break in the specified place of the specified kind.
- (void) insertCaptionAt:(STMSWord2011TextRange *)at captionLabel:(STMSWord2011E210)captionLabel title:(NSString *)title captionPosition:(STMSWord2011E117)captionPosition;  // Inserts a caption immediately preceding or following the specified range.
- (void) insertCrossReferenceAt:(STMSWord2011TextRange *)at referenceType:(STMSWord2011E211)referenceType referenceKind:(STMSWord2011E212)referenceKind referenceItem:(NSString *)referenceItem insertAsHyperlink:(BOOL)insertAsHyperlink includePosition:(BOOL)includePosition;  // Inserts a cross-reference to a heading, bookmark, footnote, or endnote, or to an item for which a caption label is defined.
- (void) insertDatabaseAt:(STMSWord2011TextRange *)at format:(STMSWord2011E180)format style:(NSInteger)style linkToSource:(BOOL)linkToSource connection:(NSString *)connection SQLStatement:(NSString *)SQLStatement SQLStatement1:(NSString *)SQLStatement1 passwordDocument:(NSString *)passwordDocument passwordTemplate:(NSString *)passwordTemplate writePassword:(NSString *)writePassword writePasswordTemplate:(NSString *)writePasswordTemplate dataSource:(NSString *)dataSource from:(NSInteger)from to:(NSInteger)to includeFields:(BOOL)includeFields;  // Retrieves data from a data source and inserts the data as a table in place of the specified range.
- (void) insertDateTimeAt:(STMSWord2011TextRange *)at dateTimeFormat:(NSString *)dateTimeFormat insertAsField:(BOOL)insertAsField;  // Insert the correct date or time, or both, either as text or as a time field at the specified location.
- (void) insertFileAt:(STMSWord2011TextRange *)at fileName:(NSString *)fileName fileRange:(NSString *)fileRange confirmConversions:(BOOL)confirmConversions link:(BOOL)link;
- (void) insertParagraphAt:(STMSWord2011TextRange *)at;  // Replaces the specified range with a new paragraph.  If you do not want to replace the range, use the collapse range method before using this method.
- (void) insertSymbolAt:(STMSWord2011TextRange *)at characterNumber:(NSInteger)characterNumber font:(NSString *)font unicode:(BOOL)unicode bias:(STMSWord2011E274)bias;  // Inserts a symbol in place of the specified range.  If you do not want to replace the range, use the collapse range method before using this method.
- (NSString *) keyStringKeyCode:(NSInteger)keyCode key_code_2:(STMSWord2011E240)key_code_2;  // Returns the key combination string for the specified keys 
- (void) largeScroll:(STMSWord20114005)x down:(NSInteger)down up:(NSInteger)up toRight:(NSInteger)toRight toLeft:(NSInteger)toLeft;  // Scrolls a window by the specified number of screens. This method is equivalent to clicking just before or just after the scroll boxes on the horizontal and vertical scroll bars.
- (double) linesToPointsLines:(double)lines;  // Converts a measurement from lines to points. 1 line = 12 points.
- (void) listCommandsListAllCommands:(BOOL)listAllCommands;  // Creates a new document and then inserts a table of Microsoft Word commands along with their associated shortcut keys and menu assignments.
- (double) millimetersToPointsMillimeters:(double)millimeters;  // Converts a measurement from millimeters to points.
- (void) organizerCopySource:(NSString *)source destination:(NSString *)destination name:(NSString *)name organizerObjectType:(STMSWord2011E263)organizerObjectType;  // Copies the specified autotext entry, toolbar, style, or macro project item from the source document or template to the destination document or template.
- (void) organizerDeleteSource:(NSString *)source name:(NSString *)name organizerObjectType:(STMSWord2011E263)organizerObjectType;  // Deletes the specified style, autotext entry, toolbar, or macro project item from a document or template.
- (void) organizerRenameSource:(NSString *)source name:(NSString *)name newName:(NSString *)newName organizerObjectType:(STMSWord2011E263)organizerObjectType;  // Renames the specified style, autotext entry, toolbar, or macro project item in a document or template.
- (void) pageScroll:(STMSWord20114007)x down:(NSInteger)down up:(NSInteger)up;  // Scrolls through the window page by page.
- (double) picasToPointsPicas:(double)picas;  // Converts a measurement from picas to points.
- (double) pointsToCentimetersPoints:(double)points;  // Converts a measurement from points to centimeters.
- (double) pointsToInchesPoints:(double)points;  // Converts a measurement from points to inches.
- (double) pointsToLinesPoints:(double)points;  // Converts a measurement from points to lines. 1 line = 12 points.
- (double) pointsToMillimetersPoints:(double)points;  // Converts a measurement from points to millimeters.
- (double) pointsToPicasPoints:(double)points;  // Converts a measurement from points to picas.
- (void) printOut:(STMSWord20114001)x append:(BOOL)append printOutRange:(STMSWord2011E254)printOutRange outputFileName:(NSString *)outputFileName pageFrom:(NSInteger)pageFrom pageTo:(NSInteger)pageTo printOutItem:(STMSWord2011E252)printOutItem printCopies:(NSInteger)printCopies printOutPageType:(STMSWord2011E253)printOutPageType printToFile:(BOOL)printToFile collate:(BOOL)collate fileName:(NSString *)fileName manualDuplexPrint:(BOOL)manualDuplexPrint;  // Prints out all or part of the specified or active document. This command has been deprecated; use the Print command in the Standard Suite.
- (void) reject:(STMSWord20114025)x;  // Rejects the specified tracked change. The revision marks are removed, leaving the original text intact.
- (void) removeNumbers:(STMSWord20114008)x numberType:(STMSWord2011E158)numberType;  // Removes numbers or bullets from the document
- (void) remveEmphemeralLocksInRange:(STMSWord2011SelectionObject *)inRange inCoauthoring:(STMSWord2011Coauthoring *)inCoauthoring inCoauthor:(STMSWord2011Coauthor *)inCoauthor;
- (void) resetContinuationNotice:(STMSWord20114015)x;  // Resets the footnote or endnote continuation notice to the default notice. The default notice is blank.
- (void) resetContinuationSeparator:(STMSWord20114014)x;  // Resets the footnote or endnote continuation separator to the default separator. The default separator is a long horizontal line that separates document text from notes continued from the previous page.
- (void) resetIgnoreAll;  // Clears the list of words that were previously ignored during a spelling check. After you run this method, previously ignored words are checked along with all the other words.
- (void) resetSeparator:(STMSWord20114013)x;  // Resets the footnote or endnote separator to the default separator. The default separator is a short horizontal line that separates document text from notes.
- (STMSWord2011Language *) retrieveLanguage:(STMSWord2011E182)x;  // Returns the language object for the specified language.
- (void) runVBMacroMacroName:(NSString *)macroName;  // Runs a Visual Basic macro.
- (void) screenRefresh;  // Updates the display on the monitor with the current information in the video memory buffer. You can use this method after using the screen updating property to disable screen updates.
- (void) setDefaultFilePathFilePathType:(STMSWord2011E230)filePathType path:(NSString *)path;  // Sets the default folders for items such as documents, templates, and graphics.
- (void) setUserPropertyPropertyType:(STMSWord2011E292)propertyType propertyValue:(NSString *)propertyValue;
- (void) smallScroll:(STMSWord20114006)x down:(NSInteger)down up:(NSInteger)up toRight:(NSInteger)toRight toLeft:(NSInteger)toLeft;  // Scrolls a window by the specified number of lines. This method is equivalent to clicking the scroll arrows on the horizontal and vertical scroll bars.
- (void) substituteFontUnavailableFont:(NSString *)unavailableFont substituteFont:(NSString *)substituteFont;  // Sets font-mapping options, which are reflected in the font substitution dialog box
- (void) unlink:(STMSWord20114017)x;
- (void) unloadAddinsRemoveFromList:(BOOL)removeFromList;  // Unloads all loaded add-ins and, depending on the value of the remove from list argument, removes them from the list of add-ins.
- (void) update:(STMSWord20114016)x;  // Updates the values shown in a built-in Microsoft Word dialog box, updates the specified link, or updates the entries shown in specified index, table of authorities, table of figures or table of contents.
- (void) updatePageNumbers:(STMSWord20114022)x;  // Updates the page numbers for items in the specified table of contents or table of figures.
- (void) updateSource:(STMSWord20114018)x;
- (void) automaticLength:(STMSWord20114027)x;  // Specifies that the first segment of the callout line the segment attached to the text callout box be scaled automatically when the callout is moved. Applies only to callouts whose lines consist of more than one segment.
- (void) customDrop:(STMSWord20114028)x drop:(double)drop;  // Sets the vertical distance in points from the edge of the text bounding box to the place where the callout line attaches to the text box.
- (void) customLength:(STMSWord20114029)x length:(double)length;  // Specifies that the first segment of the callout, line the segment attached to the text callout box, retain a fixed length whenever the callout is moved. Applies only to callouts whose lines consist of more than one segment.
- (void) oneColorGradient:(STMSWord20114031)x gradientStyle:(STMSWord2011MGdS)gradientStyle gradientVariant:(NSInteger)gradientVariant gradientDegree:(double)gradientDegree;  // Sets the specified fill to a one-color gradient.
- (void) patterned:(STMSWord20114032)x pattern:(STMSWord2011PpTy)pattern;  // Sets the specified fill to a pattern.
- (void) presetDrop:(STMSWord20114030)x DropType:(STMSWord2011MCDt)DropType;  // Specifies whether the callout line attaches to the top, bottom, or center of the callout text box or whether it attaches at a point that's a specified distance from the top or bottom of the text box.
- (void) presetGradient:(STMSWord20114033)x style:(STMSWord2011MGdS)style gradientVariant:(NSInteger)gradientVariant presetGradientType:(STMSWord2011MPGb)presetGradientType;  // Sets the specified fill to a preset gradient.
- (void) presetTextured:(STMSWord20114034)x presetTexture:(STMSWord2011MPzT)presetTexture;  // Sets the specified fill to a preset texture
- (void) resetRotation:(STMSWord20114039)x;  // Resets the extrusion rotation around the x-axis and the y-axis to zero so that the front of the extrusion faces forward. This method doesn't reset the rotation around the z-axis.
- (void) saveAsPicture:(STMSWord20114026)x pictureType:(STMSWord2011MPiT)pictureType fileName:(NSString *)fileName;  // Saves the shape in the requested file using the stated graphic format
- (void) solid:(STMSWord20114035)x;  // Sets the specified fill to a uniform color. Use this method to convert a gradient, textured, patterned, or background fill back to a solid fill.
- (void) twoColorGradient:(STMSWord20114036)x gradientStyle:(STMSWord2011MGdS)gradientStyle gradientVariant:(NSInteger)gradientVariant;  // Sets the specified fill to a two-color gradient.
- (void) userPicture:(STMSWord20114037)x pictureFile:(NSString *)pictureFile;  // Fills the specified shape with one large image. If you want to fill the shape with small tiles of an image, use the user textured method.
- (void) userTextured:(STMSWord20114038)x textureFile:(NSString *)textureFile;  // Fills the specified shape with small tiles of an image. If you want to fill the shape with one large image, use the user picture method.
- (void) closeUp:(STMSWord20114041)x;  // Removes any spacing before the specified paragraphs.

////FIXME: removing "duplicate" with different argument types --EWW
//- (STMSWord2011Border *) getBorder:(STMSWord20114040)x whichBorder:(STMSWord2011E122)whichBorder;  // Returns the specified border object.
- (void) indentCharWidth:(STMSWord20114050)x count:(NSInteger)count;  // Indents one or more paragraphs by a specified number of characters.
- (void) indentFirstLineCharWidth:(STMSWord20114051)x count:(NSInteger)count;  // Indents the first line of one or more paragraphs by a specified number of characters.
- (void) openOrCloseUp:(STMSWord20114043)x;  // If spacing before the specified paragraphs is zero, this method sets spacing to 12 points. If spacing before the paragraphs is greater than zero, this method sets spacing to zero.
- (void) openUp:(STMSWord20114042)x;  // Sets spacing before the specified paragraphs to 12 points.

//FIXME: removing "duplicate" with different argument types --EWW
//- (void) reset:(STMSWord20114046)x;  // Removes paragraph formatting that differs from the underlying style. For example, if you manually right align a paragraph and the underlying style has a different alignment, the reset method changes the alignment to match the style formatting.
- (void) space1:(STMSWord20114047)x;  // Single-spaces the specified paragraphs. The exact spacing is determined by the font size of the largest characters in each paragraph.
- (void) space15:(STMSWord20114048)x;  // Formats the specified paragraphs with 1.5-line spacing. The exact spacing is determined by adding 6 points to the font size of the largest character in each paragraph.
- (void) space2:(STMSWord20114049)x;  // Double-spaces the specified paragraphs. The exact spacing is determined by adding 12 points to the font size of the largest character in each paragraph.
- (void) tabHangingIndent:(STMSWord20114044)x count:(NSInteger)count;  // Sets a hanging indent to a specified number of tab stops. Can be used to remove tab stops from a hanging indent if the value of the count argument is a negative number.
- (void) tabIndent:(STMSWord20114045)x count:(NSInteger)count;  // Sets the left indent for the specified paragraphs to a specified number of tab stops. Can also be used to remove the indent if the value of the count argument is a negative number.
- (void) autoFit:(STMSWord20114060)x;  // Changes the width of a table column to accommodate the width of the text without changing the way text wraps in the cells.
- (STMSWord2011TextRange *) convertRowToText:(STMSWord20114059)x separator:(STMSWord2011E177)separator nestedTables:(BOOL)nestedTables;  // Converts a row to text and returns a text range object that represents the delimited text.

//FIXME: removing "duplicate" with different argument types --EWW
//- (STMSWord2011Border *) getBorder:(STMSWord20114052)x whichBorder:(STMSWord2011E122)whichBorder;  // Returns the specified border object.

- (void) setLeftIndent:(STMSWord20114058)x leftIndent:(double)leftIndent rulerStyle:(STMSWord2011E141)rulerStyle;  // Sets the indentation for a row or rows in a table.
- (void) setTableItemHeight:(STMSWord20114057)x rowHeight:(NSInteger)rowHeight heightRule:(STMSWord2011E133)heightRule;  // Sets the height of table rows.
- (void) setTableItemWidth:(STMSWord20114056)x columnWidth:(double)columnWidth rulerStyle:(STMSWord2011E141)rulerStyle;  // Sets the width of columns or cells in a table
- (void) sortAscending:(STMSWord20114054)x;  // Sorts paragraphs or table rows in ascending alphanumeric order. The first paragraph or table row is considered a header record and isn't included in the sort. Use the sort method to include the header record in a sort.
- (void) sortDescending:(STMSWord20114055)x;  // Sorts paragraphs or table rows in descending alphanumeric order. The first paragraph or table row is considered a header record and isn't included in the sort. Use the sort method to include the header record in a sort.
- (void) tableSort:(STMSWord20114053)x excludeHeader:(BOOL)excludeHeader fieldNumber:(NSInteger)fieldNumber sortFieldType:(STMSWord2011E178)sortFieldType sortOrder:(STMSWord2011E179)sortOrder fieldNumberTwo:(NSInteger)fieldNumberTwo sortFieldTypeTwo:(STMSWord2011E178)sortFieldTypeTwo sortOrderTwo:(STMSWord2011E179)sortOrderTwo fieldNumberThree:(NSInteger)fieldNumberThree sortFieldTypeThree:(STMSWord2011E178)sortFieldTypeThree sortOrderThree:(STMSWord2011E179)sortOrderThree sortColumn:(BOOL)sortColumn separator:(STMSWord2011E176)separator caseSensitive:(BOOL)caseSensitive languageID:(STMSWord2011E182)languageID;  // Sort a table object.  For the column object only the first field is used

@end

// Represents a single AutoText entry.
@interface STMSWord2011AutoTextEntry : STMSWord2011BaseObject

@property (copy) NSString *autoTextValue;  // Returns or sets the value of this auto text entry.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy) NSString *name;  // Returns or sets the name of this auto text entry.
@property (copy, readonly) NSString *styleName;  // Returns the name of the style applied to the specified auto text entry.

- (STMSWord2011TextRange *) insertAutoTextEntryWhere:(STMSWord2011TextRange *)where richText:(BOOL)richText;  // Inserts the auto text entry in place of the specified range. Returns a text range object that represents the auto text entry.

@end

// Represents a single bookmark.
@interface STMSWord2011Bookmark : STMSWord2011BaseObject

@property (readonly) BOOL column;  // True if the specified bookmark is a table column.
@property (readonly) BOOL empty;  // True if the specified bookmark is empty. An empty bookmark marks a location of a collapsed selection, it doesn't mark any text.
@property NSInteger endOfBookmark;  // Returns or sets the ending character position of the bookmark.
@property (copy, readonly) NSString *name;  // The name of the bookmark object.
@property NSInteger startOfBookmark;  // Returns or sets the starting character position of the bookmark.
@property (readonly) STMSWord2011E160 storyType;  // Returns the story type for the bookmark.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the portion of a document that's referred to by the bookmark.

- (STMSWord2011Bookmark *) copyBookmarkName:(NSString *)name NS_RETURNS_NOT_RETAINED;  // Sets the bookmark specified by the name argument to the location marked by another bookmark, and returns a bookmark object.

@end

// Represents options associated with border object.
@interface STMSWord2011BorderOptions : STMSWord2011BaseObject

@property BOOL alwaysInFront;  // Returns or sets if page borders are displayed in front of the document text.
@property STMSWord2011E272 distanceFrom;  // Returns or sets a value that indicates whether the specified page border is measured from the edge of the page or from the text it surrounds.
@property NSInteger distanceFromBottom;  // Returns or sets the space in points between the text and the bottom border.
@property NSInteger distanceFromLeft;  // Returns or sets the space in points between the text and the left border.
@property NSInteger distanceFromRight;  // Returns or sets the space in points between the right edge of the text and the right border. 
@property NSInteger distanceFromTop;  // Returns or sets the space in points between the text and the top border.
@property BOOL enableBorders;  // Returns or sets border formatting for the specified object.
@property BOOL enableFirstPageInSection;  // Returns or sets if page borders are enabled for the first page in the section.
@property BOOL enableOtherPagesInSection;  // Returns or sets if page borders are enabled for all pages in the section except for the first page. 
@property (readonly) BOOL hasHorizontal;  // Returns true if a horizontal border can be applied to the object. 
@property (readonly) BOOL hasVertical;  // Returns true if a vertical border can be applied to the object. 
@property (copy) NSColor *insideColor;  // Returns or sets the RGB color of the inside borders
@property STMSWord2011E110 insideColorIndex;  // Returns or sets the color index of the inside borders. 
@property STMSWord2011MCoI insideColorThemeIndex;  // Returns or sets the color of the inside borders.
@property STMSWord2011E167 insideLineStyle;  // Returns or sets the inside border for the specified object.
@property STMSWord2011E168 insideLineWidth;  // Returns or sets the line width of the inside border of an object.
@property BOOL joinBorders;  // Returns or sets if vertical borders at the edges of paragraphs and tables are removed so that the horizontal borders can connect to the page border.
@property (copy) NSColor *outsideColor;  // Returns or sets the RGB color of the outside borders
@property STMSWord2011E110 outsideColorIndex;  // Returns or sets the color index of the outside borders. 
@property STMSWord2011MCoI outsideColorThemeIndex;  // Returns or sets the color of the outside borders.
@property STMSWord2011E167 outsideLineStyle;  // Returns or sets the outside border for the specified object.
@property STMSWord2011E168 outsideLineWidth;  // Returns or sets the line width of the outside border of an object.
@property BOOL shadow;  // Returns or sets if the specified border is formatted as shadowed.
@property BOOL surroundFooter;  // Returns or sets if a page border encompasses the document footer.
@property BOOL surroundHeader;  // Returns or sets if a page border encompasses the document header.

- (void) applyPageBordersToAllSections;  // Applies the specified page-border formatting to all sections in a document.

@end

// Represents a border of an object.
@interface STMSWord2011Border : STMSWord2011BaseObject

@property STMSWord2011E271 artStyle;  // Returns or sets the graphical page-border design for a document.
@property NSInteger artWidth;  // Returns or sets the width in points of the specified graphical page border.
@property (copy) NSColor *color;  // Returns or sets the RGB color for the specified border object. 
@property STMSWord2011E110 colorIndex;  // Returns or sets the color index for the specified border.
@property STMSWord2011MCoI colorThemeIndex;  // Returns or sets the color for the specified border or font object.
@property (readonly) BOOL inside;  // Returns true if an inside border can be applied to the specified object.
@property STMSWord2011E167 lineStyle;  // Returns or sets the border line style for the specified object.
@property STMSWord2011E168 lineWidth;  // Returns or sets the line width of an object's border.
@property BOOL visible;  // Returns or sets if the border object is visible


@end

// Represents the browser tool used to move the insertion point to objects in a document. This tool is comprised of the three buttons at the bottom of the vertical scroll bar.
@interface STMSWord2011Browser : STMSWord2011BaseObject

@property STMSWord2011E206 browserTarget;  // Returns or sets the document item that the previous and next methods locate.

- (void) nextForBrowser;  // Moves the selection to the next item indicated by the browser target. Use the browser target property to change the browser target.
- (void) previousForBrowser;  // Moves the selection to the previous item indicated by the browser target. Use the browser target property to change the browser target.

@end

@interface STMSWord2011BuildingBlockCategory : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011BuildingBlock *> *) buildingBlocks;

@property (copy, readonly) STMSWord2011BuildingBlockType *buildingBlockType;  // Returns a building block type object that represents the type of building block for a building block category.
@property (readonly) NSInteger entry_index;  // Returns an integer that represents the position of an item in a collection.
@property (copy, readonly) NSString *name;  // Returns the name of the specified object.

- (STMSWord2011BuildingBlock *) addBuildingBlockToCategoryName:(NSString *)name fromLocation:(STMSWord2011TextRange *)fromLocation objectDescription:(NSString *)objectDescription insertOptions:(STMSWord2011E330)insertOptions;  // Creates a new building block.

@end

// Represents a type of building block.
@interface STMSWord2011BuildingBlockType : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011BuildingBlockCategory *> *) buildingBlockCategories;

@property (readonly) NSInteger entry_index;  // Returns an integer that represents the position of an item in a collection.
@property (copy, readonly) NSString *name;  // Returns a String that represents the localized name of a building block type.


@end

@interface STMSWord2011BuildingBlock : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011BuildingBlockType *buildingBlockType;  // Returns a building block type object that represents the type for a building block.
@property (copy, readonly) STMSWord2011BuildingBlockCategory *category;  // Returns a Category object that represents the category for a building block.
@property (copy) NSString *objectDescription;  // Gets or sets a string that represents the description for a building block.
@property (readonly) NSInteger entry_index;  // Returns an integer that represents the position of an item in a collection.
@property (copy, readonly) NSString *identifier;  // Returns a string that represents the internal identification number for a building block.
@property NSInteger insertOptions;  // Gets or sets an integer that represents how to insert the contents of a building block into a document.
@property (copy) NSString *name;  // Gets or sets a string that represents the name of a building block.
@property (copy) NSString *value;  // Gets or sets a string that represents the contents of a building block.

- (STMSWord2011TextRange *) insertBuildingBlockInLocation:(STMSWord2011TextRange *)inLocation asRichText:(BOOL)asRichText;  // Inserts the value of a building block into a document and returns a text range object that represents the contents of the building block within the document.

@end

// Represents a single caption label.
@interface STMSWord2011CaptionLabel : STMSWord2011BaseObject

@property (readonly) BOOL builtIn;  // Returns true if this is a built-in caption label.
@property (readonly) STMSWord2011E210 captionLabelId;  // Returns a constant that represents the type for the specified caption label if the built in property of the caption label object is true.
@property STMSWord2011E117 captionLabelPosition;  // Returns or sets the position of caption label text.
@property NSInteger chapterStyleLevel;  // Returns or sets the heading style that marks a new chapter when chapter numbers are included with the specified caption label. The number 1 corresponds to Heading 1, 2 corresponds to Heading 2, and so on.
@property BOOL includeChapterNumber;  // Returns or sets if a chapter number is included with page numbers or a caption label.
@property (copy, readonly) NSString *name;  // Returns the name for the caption label
@property STMSWord2011E153 numberStyle;  // Returns or sets the number style for the caption label object.
@property STMSWord2011E120 separator;  // Returns or sets the character between the chapter number and the sequence number.


@end

// Represents a single check box form field.
@interface STMSWord2011CheckBox : STMSWord2011BaseObject

@property BOOL autoSize;  // True sizes the check box according to the font size of the surrounding text. False sizes the check box according to the size property.
@property BOOL checkBoxDefault;  // Returns or sets the default check box value. True if the default value is checked. 
@property BOOL checkBoxValue;  // Returns or sets if the check box is selected.  True if the check box is selected.
@property double checkboxSize;  // Returns or sets the size of the specified check box in points.
@property (readonly) BOOL valid;  // Returns if the check box object is valid.


@end

// Represents a co-authoring lock
@interface STMSWord2011CoauthLock : STMSWord2011BaseObject

@property BOOL isHeader_footer_lock;  // returns if this lock is a header/footer lock.
@property (copy, readonly) STMSWord2011Coauthor *lockOwner;  // Get the owner of the co-authoring lock.
@property STMSWord2011E332 lockType;  // Get the type of the co-authoring lock.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Gets a text range object that represents the portion of a document that contains the co-authoring lock.

- (void) unlock;  // Remove the co-authoring lock.

@end

// Represents a co-authoring update
@interface STMSWord2011CoauthUpdate : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011TextRange *textObject;  // Gets a text range object that represents the portion of a document that contains the co-authoring update.


@end

// Represents a coauthor
@interface STMSWord2011Coauthor : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011CoauthLock *> *) coauthLocks;

@property (copy, readonly) NSString *coauthorEmailAddress;  // The email address of coauthor.
@property (copy, readonly) NSString *coauthorId;  // The ID of coauthor.
@property (copy, readonly) NSString *coauthorName;  // The name of coauthor.
@property BOOL isMe;  // returns if this coauthor is me.


@end

// Represents a coauthoring
@interface STMSWord2011Coauthoring : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Coauthor *> *) coauthors;
- (SBElementArray<STMSWord2011CoauthLock *> *) coauthLocks;
- (SBElementArray<STMSWord2011CoauthUpdate *> *) coauthUpdates;
- (SBElementArray<STMSWord2011Conflict *> *) conflicts;

@property BOOL canMerge;  // returns if coauthoring can merge.
@property BOOL canShare;  // returns if coauthoring can share.
@property (copy) STMSWord2011Coauthor *myself;  // returns me as author.
@property BOOL pendingUpdates;  // returns if any updates are pending.


@end

// Represents a conflict
@interface STMSWord2011Conflict : STMSWord2011BaseObject

@property (readonly) STMSWord2011E216 conflictType;  // Returns the revision type.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the conflict


@end

// Represents a custom mailing label.
@interface STMSWord2011CustomLabel : STMSWord2011BaseObject

@property (readonly) BOOL dotMatrix;  // True if the printer type for the specified custom label is dot matrix. False if the printer type is either laser or ink jet.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property double height;  // Returns or sets the height of the object.
@property double horizontalPitch;  // Returns or sets the horizontal distance in points between the left edge of one custom mailing label and the left edge of the next mailing label.
@property (copy) NSString *name;  // Returns or set the name of the custom mailing label.
@property NSInteger numberAcross;  // Returns or sets the number of custom mailing labels across a page.
@property NSInteger numberDown;  // Returns or sets the number of custom mailing labels down the length of a page.
@property STMSWord2011E233 pageSize;  // Returns or sets the page size for the specified custom mailing label.
@property double sideMargin;  // Returns or sets the side margin widths in points for the specified custom mailing label.
@property double topMargin;  // Returns or sets the distance in points between the top edge of the page and the top boundary of the body text.
@property (readonly) BOOL valid;  // True if the various properties for example, height, width, and number down for the specified custom label work together to produce a valid mailing label.
@property double verticalPitch;  // Returns or sets the vertical distance between the top of one mailing label and the top of the next mailing label.
@property double width;  // Returns or sets the width of the object.


@end

// Represents a single data merge field in a data source.
@interface STMSWord2011DataMergeDataField : STMSWord2011BaseObject

@property (copy, readonly) NSString *dataMergeDataFieldValue;  // Returns the contents of the mail merge data field or mapped data field for the current record. Use the active record property to set the active record in a data merge data source.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *name;  // Returns the name of the data merge data field object.


@end

// Represents the data merge data source in a data merge operation.
@interface STMSWord2011DataMergeDataSource : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011DataMergeFieldName *> *) dataMergeFieldNames;
- (SBElementArray<STMSWord2011DataMergeDataField *> *) dataMergeDataFields;

@property STMSWord2011E193 activeRecord;  // Returns back the index of the current active record or an enumeration specifying the record
@property (copy, readonly) NSString *connectString;  // Returns the connection string for the specified data merge data source.
@property NSInteger firstRecord;  // Returns or sets the number of the first data record to be merged in a data merge operation. 
@property (copy, readonly) NSString *headerSourceName;  // Returns the path and file name of the header source attached to the specified mail merge main document.
@property (readonly) STMSWord2011E195 headerSourceType;  // Returns a value that indicates the way the header source is being supplied for the mail merge operation.
@property NSInteger lastRecord;  // Returns or sets the number of the last data record to be merged in a data merge operation. 
@property (readonly) STMSWord2011E195 mailMergeDataSourceType;  // Returns the type of data merge data source.
@property (copy, readonly) NSString *name;  // Returns the name of the data merge data source.
@property (copy) NSString *queryString;  // Returns or sets the query string, SQL statement, used to retrieve a subset of the data in a data merge data source.

- (BOOL) findRecordFindText:(NSString *)findText fieldName:(NSString *)fieldName;  // Searches the contents of the specified data merge data source for text in a particular field. Returns true if the search text is found.

@end

// Represents a data merge field name in a data source.
@interface STMSWord2011DataMergeFieldName : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *name;  // The name of the data merge field name object


@end

// Represents a single data merge field in a document.
@interface STMSWord2011DataMergeField : STMSWord2011BaseObject

@property (copy) STMSWord2011TextRange *dataMergeFieldRange;  // Returns or sets a text range object that represents a field's code. A field's code is everything that's enclosed by the field characters including the leading space and trailing space characters.
@property (readonly) STMSWord2011E183 formFieldType;  // The type of this data merge field
@property BOOL locked;  // Returns or sets if the specified field is locked. When a field is locked, you cannot update the field results.
@property (copy, readonly) STMSWord2011DataMergeField *nextDataMergeField;  // Returns the next data merge field
@property (copy, readonly) STMSWord2011DataMergeField *previousMakeMergeField;  // Returns the previous data merge field


@end

// Represents the data merge functionality in Word.
@interface STMSWord2011DataMerge : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011DataMergeField *> *) dataMergeFields;

@property (copy, readonly) STMSWord2011DataMergeDataSource *dataSource;  // Returns or sets the destination of the data merge results.
@property STMSWord2011E192 destination;  // Returns or sets the destination of the data merge results.
@property (copy) NSString *mailAddressFieldName;  // Returns or sets the name of the field that contains e-mail addresses that are used when the data merge destination is electronic mail.
@property BOOL mailAsAttachment;  // Returns or sets if the merge documents are sent as attachments when the data merge destination is an e-mail message or a fax.
@property (copy) NSString *mailSubject;  // Returns or sets the subject line used when the data merge destination is electronic mail.
@property STMSWord2011E190 mainDocumentType;  // Returns or sets the data merge main document type.
@property (readonly) STMSWord2011E191 state;  // Returns the current state of a data merge operation.
@property BOOL suppressBlankLines;  // Returns or sets if blank lines are suppressed when data merge fields in a data merge main document are empty.
@property BOOL viewDataMergeFieldCodes;  // Returns or sets if merge field names are displayed in a data merge main document. False if information from the current data record is displayed. 

- (void) check;  // Simulates the data merge operation, pausing to report each error as it occurs.
- (void) createDataSourceName:(NSString *)name passwordDocument:(NSString *)passwordDocument writePassword:(NSString *)writePassword headerRecord:(NSString *)headerRecord MSQuery:(BOOL)MSQuery SQLStatement:(NSString *)SQLStatement SQLStatement1:(NSString *)SQLStatement1 connection:(NSString *)connection linkToSource:(BOOL)linkToSource;  // Creates a Word document that uses a table to store data for a data merge. The new data source is attached to the specified document, which becomes a main document if it's not one already.
- (void) createHeaderSourceName:(NSString *)name passwordDocument:(NSString *)passwordDocument writePassword:(NSString *)writePassword headerRecord:(NSString *)headerRecord;  // Creates a Word document that stores a header record that's used in place of the data source header record in a mail merge. This method attaches the new header source to the specified document, which becomes a main document if it's not one already.
- (void) editDataSource;  // Opens or switches to the mail merge data source.
- (void) editHeaderSource;  // Opens the header source attached to a mail merge main document, or activates the header source if it's already open.
- (void) editMainDocument;  // Activates the mail merge main document associated with the specified header source or data source document.
- (void) executeDataMergePause:(BOOL)pause;  // Performs the specified data merge operation. Performs the specified data merge operation.
- (STMSWord2011DataMergeField *) makeNewDataMergeAskFieldTextRange:(STMSWord2011TextRange *)textRange name:(NSString *)name prompt:(NSString *)prompt defaultAskText:(NSString *)defaultAskText askOnce:(BOOL)askOnce;  // Create a new data merge ask field
- (STMSWord2011DataMergeField *) makeNewDataMergeFillInFieldTextRange:(STMSWord2011TextRange *)textRange prompt:(NSString *)prompt defaultFillInText:(NSString *)defaultFillInText askOnce:(BOOL)askOnce;  // Create a new data merge fill in field
- (STMSWord2011DataMergeField *) makeNewDataMergeIfFieldTextRange:(STMSWord2011TextRange *)textRange mergeField:(NSString *)mergeField comparison:(STMSWord2011E196)comparison compareTo:(NSString *)compareTo trueText:(NSString *)trueText falseText:(NSString *)falseText;  // Create a new data merge if field
- (STMSWord2011DataMergeField *) makeNewDataMergeNextFieldTextRange:(STMSWord2011TextRange *)textRange;  // Create a new data merge next field
- (STMSWord2011DataMergeField *) makeNewDataMergeNextIfFieldTextRange:(STMSWord2011TextRange *)textRange mergeField:(NSString *)mergeField comparison:(STMSWord2011E196)comparison compareTo:(NSString *)compareTo;  // Create a new data merge next if field
- (STMSWord2011DataMergeField *) makeNewDataMergeRecFieldTextRange:(STMSWord2011TextRange *)textRange;  // Create a new data merge rec field
- (STMSWord2011DataMergeField *) makeNewDataMergeSequenceFieldTextRange:(STMSWord2011TextRange *)textRange;  // Create a new data merge sequence field
- (STMSWord2011DataMergeField *) makeNewDataMergeSetFieldTextRange:(STMSWord2011TextRange *)textRange name:(NSString *)name valueText:(NSString *)valueText;  // Create a new data merge set field
- (STMSWord2011DataMergeField *) makeNewDataMergeSkipIfFieldTextRange:(STMSWord2011TextRange *)textRange mergeField:(NSString *)mergeField comparison:(STMSWord2011E196)comparison compareTo:(NSString *)compareTo;  // Create a new data merge skip if field
- (void) openDataSourceName:(NSString *)name format:(STMSWord2011E162)format confirmConversions:(BOOL)confirmConversions readOnly:(BOOL)readOnly linkToSource:(BOOL)linkToSource addToRecentFiles:(BOOL)addToRecentFiles passwordDocument:(NSString *)passwordDocument passwordTemplate:(NSString *)passwordTemplate revert:(BOOL)revert writePassword:(NSString *)writePassword writePasswordTemplate:(NSString *)writePasswordTemplate connection:(NSString *)connection SQLStatement:(NSString *)SQLStatement SQLStatement1:(NSString *)SQLStatement1;  // Attaches a data source to the specified document, which becomes a main document if it's not one already.
- (void) openHeaderSourceName:(NSString *)name format:(STMSWord2011E162)format confirmConversions:(BOOL)confirmConversions readOnly:(BOOL)readOnly addToRecentFiles:(BOOL)addToRecentFiles passwordDocument:(NSString *)passwordDocument passwordTemplate:(NSString *)passwordTemplate revert:(BOOL)revert writePassword:(NSString *)writePassword writePasswordTemplate:(NSString *)writePasswordTemplate;  // Attaches a mail merge header source to the specified document.
- (void) useAddressBookBookType:(NSString *)bookType;  // Selects the address book that's used as the data source for a mail merge operation.

@end

// Contains global application-level attributes used by Microsoft Word when you save a document as a Web page or open a Web page. You can return or set attributes either at the application global level or at the document level.
@interface STMSWord2011DefaultWebOptions : STMSWord2011BaseObject

@property BOOL allowPng;  // Returns or sets if PNG, Portable Network Graphics, is allowed as an image format when you save a document as a Web page.
@property BOOL alwaysSaveInDefaultEncoding;  // Returns or saves if the default encoding is used when you save a Web page or plain text document, independent of the file's original encoding when opened.  The default value is False.
@property BOOL checkIfOfficeIsHtmleditor;  // Returns or sets if Microsoft Word checks to see whether an Office application is the default HTML editor when you start Word.
@property BOOL checkIfWordIsDefaultHtmleditor;  // Returns or sets if Microsoft Word checks to see whether it is the default HTML editor when you start Word. The default value is true.
@property STMSWord2011MtEn encoding;  // Returns or sets the document encoding, code page or character set, to be used by the Web browser when you view the saved document
@property NSInteger pixelsPerInch;  // Returns or sets the density, pixels per inch, of graphics images and table cells on a Web page. The range of settings is usually from 19 to 480, and common settings for popular screen sizes are 72, 96, and 120.
@property STMSWord2011MSsz screenSize;  // Returns or sets the ideal minimum screen size, width by height, in pixels, that you should use when viewing the saved document in a Web browser.
@property BOOL updateLinksOnSave;  // Returns or sets if hyperlinks and paths to all supporting files are automatically updated before you save the document as a Web page, ensuring that the links are up-to-date at the time the document is saved.
@property BOOL useLongFileNames;  // Returns or sets if long file names are used when you save the document as a Web page.


@end

// Represents a built-in dialog box.
@interface STMSWord2011Dialog : STMSWord2011BaseObject

@property STMSWord2011E185 defaultDialogTab;  // Returns or sets the active tab when the specified dialog box is displayed.
@property (readonly) STMSWord2011E186 dialogType;  // The built-in dialog this object represents.

- (NSInteger) displayWordDialogTimeOut:(NSInteger)timeOut;  // Displays the specified built-in Word dialog box until either the user closes it or the specified amount of time has passed. Returns a Long that indicates which button was clicked to close the dialog box.
- (void) executeDialog;  // Applies the current settings of a Microsoft Word dialog box.
- (NSInteger) showTimeOut:(NSInteger)timeOut;  // Displays and carries out actions initiated in the specified built-in Word dialog box. Returns a number which indicates the button used to dismiss the dialog box.

@end

// Represents a single version of a document.
@interface STMSWord2011DocumentVersion : STMSWord2011BaseObject

@property (copy, readonly) NSString *comment;  // Returns the comment associated with the specified version of a document.
@property (copy, readonly) NSDate *dateValue;  // The date and time that the document version was saved.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *savedBy;  // Returns the name of the user who saved the specified version of the document.

- (void) openVersion;  // Opens the specified version of the document.

@end

// Represents a Microsoft Word document.
@interface STMSWord2011Document : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011DocumentProperty *> *) documentProperties;
- (SBElementArray<STMSWord2011CustomDocumentProperty *> *) customDocumentProperties;
- (SBElementArray<STMSWord2011Bookmark *> *) bookmarks;
- (SBElementArray<STMSWord2011Table *> *) tables;
- (SBElementArray<STMSWord2011Footnote *> *) footnotes;
- (SBElementArray<STMSWord2011Endnote *> *) endnotes;
- (SBElementArray<STMSWord2011WordComment *> *) WordComments;
- (SBElementArray<STMSWord2011Section *> *) sections;
- (SBElementArray<STMSWord2011Paragraph *> *) paragraphs;
- (SBElementArray<STMSWord2011Word *> *) words;
- (SBElementArray<STMSWord2011Sentence *> *) sentences;
- (SBElementArray<STMSWord2011Character *> *) characters;
- (SBElementArray<STMSWord2011Field *> *) fields;
- (SBElementArray<STMSWord2011FormField *> *) formFields;
- (SBElementArray<STMSWord2011WordStyle *> *) WordStyles;
- (SBElementArray<STMSWord2011Frame *> *) frames;
- (SBElementArray<STMSWord2011TableOfFigures *> *) tablesOfFigures;
- (SBElementArray<STMSWord2011Variable *> *) variables;
- (SBElementArray<STMSWord2011Revision *> *) revisions;
- (SBElementArray<STMSWord2011TableOfContents *> *) tablesOfContents;
- (SBElementArray<STMSWord2011TableOfAuthorities *> *) tablesOfAuthorities;
- (SBElementArray<STMSWord2011Window *> *) windows;
- (SBElementArray<STMSWord2011Index *> *) indexes;
- (SBElementArray<STMSWord2011Subdocument *> *) subdocuments;
- (SBElementArray<STMSWord2011StoryRange *> *) storyRanges;
- (SBElementArray<STMSWord2011HyperlinkObject *> *) hyperlinkObjects;
- (SBElementArray<STMSWord2011Shape *> *) shapes;
- (SBElementArray<STMSWord2011ListTemplate *> *) listTemplates;
- (SBElementArray<STMSWord2011WordList *> *) WordLists;
- (SBElementArray<STMSWord2011InlineShape *> *) inlineShapes;
- (SBElementArray<STMSWord2011DocumentVersion *> *) documentVersions;
- (SBElementArray<STMSWord2011ReadabilityStatistic *> *) readabilityStatistics;
- (SBElementArray<STMSWord2011GrammaticalError *> *) grammaticalErrors;
- (SBElementArray<STMSWord2011SpellingError *> *) spellingErrors;
- (SBElementArray<STMSWord2011MathObject *> *) mathObjects;

@property (copy, readonly) STMSWord2011Window *activeWindow;  // Returns a window object that represents the active window, the window with the focus. If there are no windows open, an error occurs.
@property (copy) STMSWord2011Template *attachedTemplate;  // Returns of sets a template object that represents the template attached to the specified document. To set this property, specify either the name of the template or a template object.
@property BOOL autoHyphenation;  // Returns or sets if automatic hyphenation is turned on for the specified document.
@property (copy) STMSWord2011Shape *backgroundShape;  // Returns or sets a shape object that represents the background image for the specified document.
@property STMSWord2011E184 clickAndTypeParagraphStyle;  // Returns or sets the default paragraph style applied to text by the Click and Type feature in the specified document.
@property (copy, readonly) STMSWord2011Coauthoring *coauthoring;
@property STMSWord2011E314 compatibleVersion;  // Returns or sets the compatibility options to a given application version.
@property NSInteger consecutiveHyphensLimit;  // Returns or sets the maximum number of consecutive lines that can end with hyphens. If this property is set to zero, any number of consecutive lines can end with hyphens.
@property (copy, readonly) STMSWord2011DataMerge *dataMerge;  // Returns the data merge object.
@property double defaultTabStop;  // Returns or sets the interval in points between the default tab stops in the specified document.
@property (readonly) STMSWord2011E184 defaultTableStyle;  // Returns the default table style for this document.
@property (copy, readonly) STMSWord2011OfficeTheme *documentTheme;  // Returns an office theme object that represents the Microsoft Office theme applied to a document.
@property (readonly) STMSWord2011E222 document_type;  // Returns the document type.
@property STMSWord2011E108 eastAsianLineBreak;  // Returns or sets the line break control level for the specified document. This property is ignored if the “east asian line break control” property is set to false. Note that “east asian line break control” is a paragraph format property.
@property BOOL embedTrueTypeFonts;  // Returns or set if Microsoft Word embeds TrueType fonts in a document when it's saved. This allow others to view the document with the same fonts that were used to create it.
@property (copy, readonly) STMSWord2011EndnoteOptions *endnoteOptions;  // Returns the endnote options object.
@property (copy, readonly) STMSWord2011Envelope *envelopeObject;  // Returns the envelop object.
@property (copy, readonly) STMSWord2011FieldOptions *fieldOptions;
@property (copy, readonly) STMSWord2011FootnoteOptions *footnoteOptions;  // Returns the footnote options object.
@property (copy, readonly) NSString *fullName;  // Returns the full name of the document.
@property BOOL grammarChecked;  // True if a grammar check has been run on the document. False if some of the document hasn't been checked for grammar. To recheck the grammar in the document, set the grammar checked property to false.
@property double gridDistanceHorizontal;  // Returns or sets the amount of horizontal space between the invisible gridlines that Microsoft Word uses when you draw, move, and resize shape object or east asian characters in the document.
@property double gridDistanceVertical;  // Returns or sets the amount of vertical space between the invisible gridlines that Microsoft Word uses when you draw, move, and resize shape object or east asian characters in the document.
@property BOOL gridOriginFromMargin;  // Returns or sets if Microsoft Word starts the character grid from the upper-left corner of the page.
@property double gridOriginHorizontal;  // Returns or sets the point, relative to the left edge of the page, where you want the invisible grid for drawing, moving, and resizing shape object or east asian characters to begin in the document.
@property double gridOriginVertical;  // Returns or sets the point, relative to the top of the page, where you want the invisible grid for drawing, moving, and resizing shape object or east asian characters to begin in the document.
@property NSInteger gridSpaceBetweenHorizontalLines;  // Returns or sets the interval at which Microsoft Word displays horizontal character gridlines in print layout view.
@property NSInteger gridSpaceBetweenVerticalLines;  // Returns or sets the interval at which Microsoft Word displays vertical character gridlines in print layout view.
@property (readonly) BOOL hasPassword;  // True if a password is required to open the specified document.
@property BOOL hyphenateCaps;  // Returns or sets if words in all capital letters can be hyphenated.
@property NSInteger hyphenationZone;  // Returns or sets the width of the hyphenation zone, in points. The hyphenation zone is the maximum amount of space that Microsoft Word leaves between the end of the last word in a line and the right margin.
@property (readonly) BOOL integralsUsesSubscripts;  // Gets or sets a value that specifies the default location of limits for integrals.
@property (readonly) BOOL isMasterDocument;  // True if the specified document is a master document. A master document includes one or more subdocuments.
@property (readonly) BOOL isSubdocument;  // True if the specified document is opened in a separate document window as a subdocument of a master document.
@property STMSWord2011E107 justificationMode;  // Returns or sets the character spacing adjustment for the specified document.
@property (copy) STMSWord2011LetterContent *letterContent;  // Return or sets the letter content object associated with the document.
@property (readonly) STMSWord2011E327 mathBinaryOperatorBreak;  // Gets or sets a value that specifies where Microsoft Word places binary operators when equations span two or more lines.
@property (readonly) STMSWord2011E326 mathDefaultJustification;  // Gets or sets a value that indicates the default justification.
@property (copy, readonly) NSString *mathFontName;  // Gets or sets the name of the font that is used in a document to display equations.
@property (readonly) double mathLeftMargin;  // Gets or sets a value that specifies the left margin for equations.
@property (readonly) double mathRightMargin;  // Gets or sets a value that specifies the right margin for equations.
@property (readonly) STMSWord2011E328 mathSubtractionOperator;  // Gets or sets a value that specifies how Microsoft Word handles a subtraction operator that falls before a line break.
@property (readonly) double mathWrap;  // Gets or sets a value that specifies the placement of the second line of an equation that wraps to a new line.
@property (copy, readonly) NSString *name;  // Returns the name of the document.
@property (readonly) BOOL naryUsesSubscripts;  // Gets or sets a value that specifies the default location of limits for n-ary objects other than integrals
@property (copy) NSString *noLineBreakAfter;  // Returns or sets the kinsoku characters after which Microsoft Word will not break a line.
@property (copy) NSString *noLineBreakBefore;  // Returns or sets the kinsoku characters before which Microsoft Word will not break a line.
@property (copy) STMSWord2011PageSetup *pageSetup;  // Returns or sets the page setup object.
@property (copy) NSString *password;  // Sets a password that must be supplied to open the specified document. This is write-only property
@property (copy, readonly) NSString *path;  // Returns the path to the document.
@property BOOL printFormsData;  // Returns or sets if Microsoft Word prints onto a preprinted form only the data entered in the corresponding online form.
@property BOOL printPostScriptOverText;  // Returns or sets if PRINT field instructions such as PostScript commands in a document are to be printed on top of text and graphics when a PostScript printer is used.
@property BOOL printRevisions;  // Returns or sets if revision marks are printed with the document. False if revision marks aren't printed that is, tracked changes are printed as if they'd been accepted.
@property (readonly) STMSWord2011E234 protectionType;  // Returns the protection type for the specified document.
@property (readonly) BOOL readOnly;  // True if changes to the document cannot be saved to the original document.
@property BOOL readOnlyRecommended;  // Returns or set if Word displays a message box whenever a user opens the document, suggesting that it be opened as read-only.
@property BOOL removeDateAndTime;  // Returns or sets if Microsoft Word removes date and time from revisions upon saving a document.
@property BOOL removePersonalInformation;  // Returns or sets if Microsoft Word removes all user information from comments, revisions, and the properties dialog box upon saving a document.
@property (readonly) STMSWord2011E161 saveFormat;  // Returns the file format of the specified document or file converter. Will be a unique number that specifies an external file converter or a constant.
@property BOOL saveFormsData;  // Returns or sets if Microsoft Word saves the data entered in a form as a tab-delimited record for use in a database.
@property BOOL saveSubsetFonts;  // Returns or sets if Microsoft Word saves a subset of the embedded TrueType fonts with the document.
@property BOOL saveVersionsOnClose;  // Sets or returns whether or not versions are automatically saved when a document is closed.
@property BOOL saved;  // Returns or set the saved state. True if the specified document or template hasn't changed since it was last saved. False if Microsoft Word displays a prompt to save changes when the document is closed.
@property (copy) NSString *showWordCommentsBy;  // Returns or sets the name of the reviewer whose comments are shown in the comments pane. You can choose to show comments either by a single reviewer or by all reviewers. To view the comments by all reviewers, set this property to 'All Reviewers'.
@property BOOL showGrammaticalErrors;  // Returns or sets if grammatical errors are marked by a wavy green line in the document. To view grammatical errors in your document, you must set the check grammar as you type property of the Word options class to true.
@property BOOL showHiddenBookmarks;  // Returns or sets if hidden bookmarks are shown.
@property BOOL showRevisions;  // Returns or sets if tracked changes in the specified document are shown on the screen.
@property BOOL showSpellingErrors;  // Returns or sets if Microsoft Word underlines spelling errors in the document.  To view spelling errors in your document, you must set the check grammar as you type property of the Word options class to true.
@property BOOL snapToGrid;  // Returns or sets if shape object or east asian characters are automatically aligned with an invisible grid when they are drawn, moved, or resized in the specified document.
@property BOOL snapToShapes;  // Returns or sets if Microsoft Word automatically aligns shape object or east asian characters with invisible gridlines that go through the vertical and horizontal edges of other shape object or east asian characters in the document.
@property BOOL spellingChecked;  // True if a spelling check has been run on the document. False if some of the document hasn't been checked for spelling. To see if the document contains spelling errors, get the count of spelling errors for the document.
@property BOOL subdocumentsExpanded;  // Returns or set if the subdocuments in the document are expanded.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a range object that represents the main document story.
@property BOOL trackRevisions;  // Returns or sets if changes are tracked in the document.
@property (copy, readonly) NSArray *unavailableFonts;  // Returns a list of fonts used in the document that are not available on the current system.
@property BOOL updateStylesOnOpen;  // Returns or sets if the styles in the specified document are updated to match the styles in the attached template each time the document is opened.
@property (readonly) BOOL useDefaultMathSettings;  // Gets or sets a value that indicates whether to use the default math settings when creating new equations.
@property (readonly) BOOL useSmallFractions;  // Gets or sets a value that indicates whether to use small fractions in equations contained within the document.
@property (copy, readonly) STMSWord2011WebOptions *webOptions;  // Returns the web options object.
@property (copy) NSString *writePassword;  // Sets a password for saving changes to the specified document. This is write-only property
@property (readonly) BOOL writeReserved;  // True if the specified document is protected with a write password.

- (void) acceptAllRevisions;  // Accepts all tracked changes in the document.
- (void) acceptAllShownRevisions;  // Accepts all shown tracked changes.
- (void) applyDocumentThemeFileName:(NSString *)fileName;  // Applies an Office theme to the document.
- (void) autoFormat;  // Automatically formats a document
- (BOOL) canCheckIn;  // Returns True if Word can check in a specified document to a server.
- (void) changeDefaultTableStyleStyle:(STMSWord2011E184)style changeInTemplate:(BOOL)changeInTemplate;  // Sets the default table style.
- (void) checkConsistency;  // Searches all text in a Japanese language document and displays instances where character usage is inconsistent for the same words.
- (void) checkInSaveChanges:(BOOL)saveChanges comments:(NSString *)comments makePublic:(BOOL)makePublic;  // Returns a document from a local computer to a server, and sets the local document to read-only so that it cannot be edited locally.
- (void) checkInWithVersionSaveChanges:(BOOL)saveChanges comments:(NSString *)comments makePublic:(BOOL)makePublic versionType:(STMSWord2011E331)versionType;  // Returns a document from a local computer to a server, and sets the local file to read-only so that it cannot be edited locally.
- (void) closePrintPreview;  // Switches the specified document from print preview to the previous view. If the specified document isn't in print preview, an error occurs.
- (void) comparePath:(NSString *)path authorName:(NSString *)authorName target:(STMSWord2011E297)target detectFormatChanges:(BOOL)detectFormatChanges ignoreAllComparisonWarnings:(BOOL)ignoreAllComparisonWarnings addToRecentFiles:(BOOL)addToRecentFiles;  // Compares this document with another.
- (NSInteger) computeStatisticsStatistic:(STMSWord2011E155)statistic includeFootnotesAndEndnotes:(BOOL)includeFootnotesAndEndnotes;  // Computes a set of readability statistics for this document.  This must be called before accessing the readability statistics for this document.
- (void) copyStylesFromTemplateTemplate:(NSString *)template_ NS_RETURNS_NOT_RETAINED;  // Copies styles from the specified template to a document.
- (STMSWord2011LetterContent *) createLetterContentDateFormat:(NSString *)dateFormat includeHeaderFooter:(BOOL)includeHeaderFooter pageDesign:(NSString *)pageDesign letterStyle:(STMSWord2011E245)letterStyle letterhead:(BOOL)letterhead letterheadLocation:(STMSWord2011E246)letterheadLocation letterheadSize:(double)letterheadSize recipientName:(NSString *)recipientName recipientAddress:(NSString *)recipientAddress salutation:(NSString *)salutation salutationType:(STMSWord2011E247)salutationType recipientReference:(NSString *)recipientReference mailingInstructions:(NSString *)mailingInstructions attentionLine:(NSString *)attentionLine subject:(NSString *)subject ccList:(NSString *)ccList returnAddress:(NSString *)returnAddress senderName:(NSString *)senderName closing:(NSString *)closing senderCompany:(NSString *)senderCompany senderJobTitle:(NSString *)senderJobTitle senderInitials:(NSString *)senderInitials enclosureCount:(NSInteger)enclosureCount;  // Create a new letter content object for use with the letter wizard.
- (STMSWord2011TextRange *) createRangeStart:(NSInteger)start end:(NSInteger)end;  // Returns a text range object by using the specified starting and ending character positions.
- (void) dataForm;  // Displays the data form dialog box, in which you can modify data records. You can use this method with a mail merge main document, a mail merge data source, or any document that contains data delimited by table cells or separator characters
- (void) deleteAllComments;  // Deletes all comments.
- (void) deleteAllShownComments;  // Deletes all shown comments.
- (void) fitToPages;  // Decreases the font size of text just enough so that the document will fit on one fewer pages. An error occurs if Word is unable to reduce the page count by one.
- (void) followHyperlinkAddress:(NSString *)address subAddress:(NSString *)subAddress newWindow:(BOOL)newWindow addHistory:(BOOL)addHistory extraInfo:(NSString *)extraInfo;  // This method resolves the hyperlink, downloads the target document, and displays the document in the appropriate application. If the hyperlink uses the file protocol, this method opens the document instead of downloading it.
- (NSString *) getActiveWritingStyleLanguageID:(STMSWord2011E182)languageID;  // Returns the writing style for a specified language.
- (NSArray *) getCrossReferenceItemsReferenceType:(STMSWord2011E211)referenceType;  // Returns an list of items that can be cross-referenced based on the specified cross-reference type.
- (BOOL) getDocumentCompatibilityCompatibilityItem:(STMSWord2011E231)compatibilityItem;  // Returns the current state of the specified compatibility item for this document. Compatibility options affect how a document is displayed in Microsoft Word.
- (STMSWord2011StoryRange *) getStoryRangeStoryType:(STMSWord2011E160)storyType;  // Returns a range object that represents the story specified by the story type argument.
- (void) makeCompatibilityDefault;  // Uses the correct settings of the document compatibility options set by the set compatibility options method as the default for new documents.
- (void) manualHyphenation;  // Initiates manual hyphenation of a document, one line at a time. The user is prompted to accept or decline suggested hyphenations.
- (STMSWord2011Field *) markEntryForTableOfContentsRange:(STMSWord2011TextRange *)range entry:(NSString *)entry tableID:(NSString *)tableID level:(NSInteger)level;  // Inserts a table of contents entry field after the specified range. The method returns a field object representing the new field.
- (STMSWord2011Field *) markEntryForTableOfFiguresRange:(STMSWord2011TextRange *)range entry:(NSString *)entry tableID:(NSString *)tableID level:(NSInteger)level;  // Inserts a table of figures entry field after the specified range. The method returns a field object representing the new field.
- (STMSWord2011Field *) markForIndexRange:(STMSWord2011TextRange *)range entry:(NSString *)entry crossReference:(NSString *)crossReference bookmarkName:(NSString *)bookmarkName;  // Inserts an index entry field after the specified range. The method returns a field object representing the new field.
- (void) mergeFileName:(NSString *)fileName;  // Merges the changes marked with revision marks from one document to another.
- (void) mergeSubdocumentsFirstSubdocument:(STMSWord2011Subdocument *)firstSubdocument lastSubdocument:(STMSWord2011Subdocument *)lastSubdocument;  // Merges the specified subdocuments of a master document into a single subdocument.
- (void) presentIt;  // Opens PowerPoint with the specified Word document loaded.
- (void) printPreview;  // Switches the view to print preview.
- (void) protectProtectionType:(STMSWord2011E234)protectionType noReset:(BOOL)noReset password:(NSString *)password useIrm:(BOOL)useIrm enforceStyleLocks:(BOOL)enforceStyleLocks;  // Helps to protect the specified document from changes. When a document is protected, users can make only limited changes, such as adding annotations, making revisions, or completing a form.
- (BOOL) redoTimes:(NSInteger)times;  // Redoes the last action that was undone. It reverses the undo method. Returns true if the actions were redone successfully.
- (void) rejectAllRevisions;  // Rejects all tracked changes in the document.
- (void) rejectAllShownRevisions;  // Rejects all shown tracked changes.
- (void) reload;  // Reloads a cached document by resolving the hyperlink to the document and downloading it.
- (void) removeReminder;  // Remove the document's reminder.
- (void) repaginate;  // Repaginates the entire document
- (void) runLetterWizardLetterContent:(STMSWord2011LetterContent *)letterContent wizardMode:(BOOL)wizardMode;  // Runs the Letter Wizard on the document
- (void) saveAsFileName:(NSString *)fileName fileFormat:(STMSWord2011E161)fileFormat lockComments:(BOOL)lockComments password:(NSString *)password addToRecentFiles:(BOOL)addToRecentFiles writePassword:(NSString *)writePassword readOnlyRecommended:(BOOL)readOnlyRecommended embedTruetypeFonts:(BOOL)embedTruetypeFonts saveNativePictureFormat:(BOOL)saveNativePictureFormat saveFormsData:(BOOL)saveFormsData textEncoding:(NSInteger)textEncoding insertLineBreaks:(BOOL)insertLineBreaks allowSubstitutions:(BOOL)allowSubstitutions lineEndingType:(STMSWord2011E311)lineEndingType HTMLDisplayOnlyOutput:(BOOL)HTMLDisplayOnlyOutput maintainCompatibility:(BOOL)maintainCompatibility;  // Saves the document with a new name or format.
- (void) saveVersionComment:(NSString *)comment;  // Saves a version of the document with a comment.
- (void) sendHtmlMail;  // Opens a message window for sending the specified document, formatted as html, through Microsoft Outlook.
- (void) sendMail;  // Opens a message window for sending the specified document through your registered mail program.
- (void) setActiveWritingStyleLanguageID:(STMSWord2011E182)languageID writingStyle:(NSString *)writingStyle;  // Sets the writing style for the specified language.
- (void) setDocumentCompatibilityCompatibilityItem:(STMSWord2011E231)compatibilityItem isCompatible:(BOOL)isCompatible;  // Sets the current state of the specified compatibility item for this document. Compatibility options affect how a document is displayed in Microsoft Word.
- (void) setReminderAt:(NSDate *)at;  // Create or modify a reminder for the document.
- (BOOL) undoTimes:(NSInteger)times;  // Undoes the last action or a sequence of actions, which are displayed in the undo list. Returns true if the actions were successfully undone.
- (void) undoClear;  // Clear the list of actions that can be undone.
- (void) unprotectPassword:(NSString *)password;  // Removes protection from the specified document. If the document isn't protected, this method generates an error.
- (void) updateStyles;  // Copies all styles from the attached template into the document, overwriting any existing styles in the document that have the same name.
- (void) upgrade;  // upgrade document
- (void) viewPropertyBrowser;  // Displays the property window for the selected control in the specified document.
- (void) webPagePreview;  // Displays a preview of the document as it would look if saved as a Web page.

@end

// Represents a dropped capital letter at the beginning of a paragraph.
@interface STMSWord2011DropCap : STMSWord2011BaseObject

@property double distanceFromText;  // Returns or sets the distance in points between the dropped capital letter and the paragraph text. 
@property STMSWord2011E172 dropPosition;  // Returns or sets the position of a dropped capital letter.
@property (copy) NSString *fontName;  // Returns or sets the name of the font for the dropped capital letter.
@property NSInteger linesToDrop;  // Returns or sets the height in lines of the specified dropped capital letter.

- (void) enable;  // Formats the first character in the specified paragraph as a dropped capital letter.

@end

// Represents a drop-down form field that contains a list of items in a form.
@interface STMSWord2011DropDown : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011ListEntry *> *) listEntries;

@property NSInteger dropDownDefault;  // Returns or sets the default drop-down item. The first item in a drop-down form field is 1, the second item is 2, and so on.
@property NSInteger dropDownValue;  // Returns or sets the number of the selected item in a drop-down form field.
@property (readonly) BOOL valid;  // Returns if the drop down object is valid.


@end

// A representation of the options associated with endnotes.
@interface STMSWord2011EndnoteOptions : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011TextRange *endnoteContinuationNotice;  // Returns a text range object that represents the endnote continuation notice.
@property (copy, readonly) STMSWord2011TextRange *endnoteContinuationSeparator;  // Returns a text range object that represents the endnote continuation separator.
@property STMSWord2011E175 endnoteLocation;  // Returns or sets the position of all endnotes.
@property STMSWord2011E152 endnoteNumberStyle;  // Returns or sets the number style for endnotes.
@property STMSWord2011E173 endnoteNumberingRule;  // Returns or sets the way footnotes or endnotes are numbered after page breaks or section breaks.
@property (copy, readonly) STMSWord2011TextRange *endnoteSeparator;  // Returns a text range object that represents the endnote separator.
@property NSInteger endnoteStartingNumber;  // Returns or sets the starting endnote number.

- (void) endnoteConvert;  // Converts endnotes to footnotes, or vice versa.
- (void) swapWithFootnotes;  // Converts all footnotes in a document to endnotes and vice versa.

@end

// Represents an endnote.
@interface STMSWord2011Endnote : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) STMSWord2011TextRange *noteReference;  // Returns a text range object that represents a endnote mark.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the portion of a document that's contained in the endnote object.


@end

// Represents an envelope.
@interface STMSWord2011Envelope : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011TextRange *address;  // Returns the envelope delivery address as a text range object.
@property double addressFromLeft;  // Returns or sets the distance in points between the left edge of the envelope and the delivery address.
@property double addressFromTop;  // Returns or sets the distance in points between the top edge of the envelope and the delivery address.
@property (copy, readonly) STMSWord2011WordStyle *addressStyle;  // Returns a Word style object that represents the delivery address style for the envelope.
@property BOOL defaultFaceUp;  // Returns or sets if envelopes are fed face up by default.
@property double defaultHeight;  // Returns or sets the default envelope height, in points.
@property BOOL defaultOmitReturnAddress;  // Returns or sets if the return address is omitted from envelopes by default.
@property STMSWord2011E244 defaultOrientation;  // Returns or sets the default orientation for feeding envelopes.
@property BOOL defaultPrintFIMA;  // Returns or sets if a Facing Identification Mark FIM-A to envelopes by default. A FIM-A code is used to presort courtesy reply mail. The default print barcode property must be set to true before this property is set.
@property BOOL defaultPrintBarCode;  // Returns or sets if a POSTNET bar code is added to envelopes or mailing labels by default. For U.S. mail only. This property must be set to true before the default print FIMA property is set
@property (copy) NSString *defaultSize;  // Returns or sets the default envelope size. If you set either the default height or default width property, the property  is automatically changed to return custom size.
@property double defaultWidth;  // Returns or sets the default envelope width, in points.
@property STMSWord2011E207 feedSource;  // Returns or sets the paper tray for the envelope.
@property (copy, readonly) STMSWord2011TextRange *returnAddress;  // Returns the envelope return address as a text range object.
@property double returnAddressFromLeft;  // Returns or sets the distance in points between the left edge of the envelope and the return address.
@property double returnAddressFromTop;  // Returns or sets the distance in points between the top edge of the envelope and the return address.
@property (copy, readonly) STMSWord2011WordStyle *returnAddressStyle;  // Returns a Word style object that represents the return address style for the envelope.

- (void) insertEnvelopeDataExtractAddress:(BOOL)extractAddress address:(NSString *)address autoText:(NSString *)autoText omitReturnAddress:(BOOL)omitReturnAddress returnAddress:(NSString *)returnAddress returnAutotext:(NSString *)returnAutotext printBarCode:(BOOL)printBarCode printFIMA:(BOOL)printFIMA envelopeSize:(NSString *)envelopeSize envelopeHeight:(NSInteger)envelopeHeight envlopeWidth:(NSInteger)envlopeWidth feedSource:(BOOL)feedSource addressFromLeft:(NSInteger)addressFromLeft addressFromTop:(NSInteger)addressFromTop returnAddressFromLeft:(NSInteger)returnAddressFromLeft returnAddressFromTop:(NSInteger)returnAddressFromTop defaultFaceUp:(BOOL)defaultFaceUp defaultOrientation:(STMSWord2011E244)defaultOrientation sizeFromPageSetup:(BOOL)sizeFromPageSetup showPageSetupDialog:(BOOL)showPageSetupDialog createNewDocument:(BOOL)createNewDocument;  // Inserts an envelope as a separate section at the beginning of the specified document.
- (void) printOutEnvelopeExtractAddress:(BOOL)extractAddress address:(NSString *)address autoText:(NSString *)autoText omitReturnAddress:(BOOL)omitReturnAddress returnAddress:(NSString *)returnAddress returnAutotext:(NSString *)returnAutotext printBarCode:(BOOL)printBarCode printFIMA:(BOOL)printFIMA envelopeSize:(NSString *)envelopeSize envelopeHeight:(NSInteger)envelopeHeight envlopeWidth:(NSInteger)envlopeWidth feedSource:(BOOL)feedSource addressFromLeft:(NSInteger)addressFromLeft addressFromTop:(NSInteger)addressFromTop returnAddressFromLeft:(NSInteger)returnAddressFromLeft returnAddressFromTop:(NSInteger)returnAddressFromTop defaultFaceUp:(BOOL)defaultFaceUp defaultOrientation:(STMSWord2011E244)defaultOrientation sizeFromPageSetup:(BOOL)sizeFromPageSetup showPageSetupDialog:(BOOL)showPageSetupDialog;
- (void) updateDocument;  // Updates the envelope in the document with the current envelope settings.

@end

@interface STMSWord2011FieldOptions : STMSWord2011BaseObject

@property BOOL locked;


@end

// Represents a field.
@interface STMSWord2011Field : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy) STMSWord2011TextRange *fieldCode;  // Returns a text range object that represents a field's code. A field's code is everything that's enclosed by the field characters including the leading space and trailing space characters.
@property (readonly) STMSWord2011E187 fieldKind;  // Returns the type of link for a field object.
@property (copy) NSString *fieldText;  // Returns or sets data in an ADDIN field. The data is not visible in the field code or result. It is only accessible by returning the value of the data property. If the field isn't an ADDIN field, this property will cause an error.
@property (readonly) STMSWord2011E183 fieldType;  // Returns the field type.
@property (copy, readonly) STMSWord2011InlineShape *inlineShape;  // Returns the inline shape object associated with this field
@property (copy, readonly) STMSWord2011LinkFormat *linkFormat;  // Returns the link format object associated with this field object.
@property BOOL locked;  // Returns or sets if the specified field is locked. When a field is locked, you cannot update the field results.
@property (copy, readonly) STMSWord2011Field *nextField;  // Returns the next field object.
@property (copy, readonly) STMSWord2011Field *previousField;  // Returns the previous field object.
@property (copy) STMSWord2011TextRange *resultRange;  // Returns or sets a text range object that represents a field's result. You can access a field result without changing the view from field codes.
@property BOOL showCodes;  // Returns or sets if field codes are displayed for the specified field instead of field results.

- (void) clickObject;  // Clicks the specified field. If the field is a GOTOBUTTON field, this method moves the insertion point to the specified location or selects the specified bookmark. If the field is a HYPERLINK field, this method jumps to the target location.
- (BOOL) updateField;  // Updates the result of the field object. When applied to a field object, returns true if the field is updated successfully.

@end

// Represents a file converter that's used to open or save files.
@interface STMSWord2011FileConverter : STMSWord2011BaseObject

@property (readonly) BOOL canOpen;  // Returns true if the specified file converter is designed to open files.
@property (readonly) BOOL canSave;  // Returns true if the specified file converter is designed to save files.
@property (copy, readonly) NSString *className;  // Returns a unique name that identifies the file converter.
@property (copy, readonly) NSString *extensions;  // Returns the file name extensions associated with the specified file converter object.
@property (copy, readonly) NSString *formatName;  // Returns the name of the specified file converter.
@property (copy, readonly) NSString *name;  // Returns the name of the file converter.
@property (readonly) NSInteger openFormat;  // Returns the file format of the specified file converter. It will be a unique number that represents an external file converter.
@property (copy, readonly) NSString *path;  // Returns the disk or Web path to the specified file converter. 
@property (readonly) NSInteger saveFormat;  // Returns the file format of the specified document or file converter. It will be a unique number that specifies an external file converter.


@end

// Represents the criteria for a find operation.
@interface STMSWord2011Find : STMSWord2011BaseObject

@property (copy) NSString *content;  // Returns or sets the text in the find object.
@property (copy, readonly) STMSWord2011Font *fontObject;  // Returns the font object associated with this find object.
@property BOOL format;  // Returns or set if formatting is included in the find operation.
@property BOOL forward;  // Returns or sets if the find operation searches forward through the document. False if it searches backward through the document.
@property (readonly) BOOL found;  // True if the search produces a match.
@property (copy, readonly) STMSWord2011Frame *frame;  // Returns the frame object associated with the find object.
@property NSInteger highlight;  // Returns or sets if highlight formatting is included in the find criteria
@property STMSWord2011E182 languageID;  // Returns or sets the language for the find object
@property STMSWord2011E182 languageIDEastAsian;  // Returns or sets an east asian language for the template.
@property BOOL matchAllWordForms;  // Returns or sets if all forms of the text to find are found by the find operation for instance, if the text to find is sit, sat and sitting are found as well.
@property BOOL matchByte;  // Returns or sets if Microsoft Word distinguishes between full-width and half-width letters or characters during a search.
@property BOOL matchCase;  // Returns or sets if the find operation is case sensitive.
@property BOOL matchFuzzy;  // Returns or sets if Microsoft Word uses the nonspecific search options for Japanese text during a search.
@property BOOL matchSoundsLike;  // Returns or sets if words that sound similar to the text to find are returned by the find operation.
@property BOOL matchWholeWord;  // Returns or sets if the find operation locates only entire words and not text that's part of a larger word.
@property BOOL matchWildcards;  // Returns or sets if the text to find contains wildcards.
@property BOOL noProofing;  // Returns or sets if Microsoft Word finds or replaces text that the spelling and grammar checker ignores.
@property (copy) STMSWord2011ParagraphFormat *paragraphFormat;  // Returns or sets the paragraph format object associated with the find object.
@property (copy, readonly) STMSWord2011Replacement *replacement;  // Returns the replacement object associated with the find object.
@property STMSWord2011E184 style;  // Returns or sets the Word style associated with the find object.
@property STMSWord2011E182 supplementalLanguageID;  // Returns or sets the language for the text range object
@property STMSWord2011E265 wrap;  // Returns or sets what happens if the search begins at a point other than the beginning of the document and the end of the document is reached or vice versa if forward is set to false or if the search text isn't found in the specified selection or range. 

- (void) clearAllFuzzyOptions;  // Clears all nonspecific search options associated with Japanese text.
- (STMSWord2011EFRt) executeFindFindText:(NSString *)findText matchCase:(BOOL)matchCase matchWholeWord:(BOOL)matchWholeWord matchWildcards:(BOOL)matchWildcards matchSoundsLike:(BOOL)matchSoundsLike matchAllWordForms:(BOOL)matchAllWordForms matchForward:(BOOL)matchForward wrapFind:(STMSWord2011E265)wrapFind findFormat:(BOOL)findFormat replaceWith:(NSString *)replaceWith replace:(STMSWord2011E273)replace;  // Runs the specified find operation. Returns true if the find operation is successful.
- (void) setAllFuzzyOptions;  // Activates all nonspecific search options associated with Japanese text.

@end

// Contains font attributes, such as font name, size, and color, for an object.
@interface STMSWord2011Font : STMSWord2011BaseObject

@property BOOL allCaps;  // Returns or sets if the font is formatted as all capital letters.
@property STMSWord2011E124 animation;  // Returns or sets the type of animation applied to the font.
@property (copy) NSString *asciiName;  // Returns or sets the font used for Latin text characters with character codes from 0 through 127. 
@property BOOL bold;  // Returns or sets if the font is formatted as bold.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this text range object.
@property (copy) NSColor *color;  // Returns or sets the RGB color of the font object.
@property STMSWord2011E110 colorIndex;  // Returns or sets the color for the font object using an index.
@property STMSWord2011MCoI colorThemeIndex;  // Returns or sets the color for the specified border or font object.
@property BOOL disableCharacterSpaceGrid;  // Returns or sets if Microsoft Word ignores the number of characters per line for the corresponding font object.
@property BOOL doubleStrikeThrough;  // Returns or sets if the specified font is formatted as double strikethrough text.
@property (copy) NSString *eastAsianName;  // Returns or sets an East Asian font name.
@property BOOL emboss;  // Returns or sets if the specified font is formatted as embossed.
@property STMSWord2011E114 emphasisMark;  // Returns or sets the emphasis mark for a character or designated character string.
@property BOOL engrave;  // Returns or sets if the specified font is formatted as engraved.
@property NSInteger fontPosition;  // Returns or sets the position of text in points relative to the base line. A positive number raises the text, and a negative number lowers it.
@property double fontSize;  // Returns or sets the font size.
@property BOOL hidden;  // Returns or sets if the font is formatted as hidden text.
@property BOOL italic;  // Returns or sets if the font is formatted as italic.
@property double kerning;  // Returns or sets the minimum font size for which Microsoft Word will adjust kerning automatically.
@property (copy) NSString *name;  // Returns or sets the font name associated with this font object.
@property (copy) NSString *otherName;  // Returns or sets the font used for characters with character codes from 128 through 255.
@property BOOL outline;  // Returns or sets if the specified font is formatted as outline.
@property NSInteger scaling;  // Returns or sets the scaling percentage applied to the font. This property stretches or compresses text horizontally as a percentage of the current size. The scaling range is from 1 through 600.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the font object.
@property BOOL shadow;  // Returns or sets if the specified font is formatted as shadowed.
@property BOOL smallCaps;  // Returns or sets if the font is formatted as small capital letters.
@property double spacing;  // Returns or sets the spacing in points between characters.
@property BOOL strikeThrough;  // Returns or sets if the font is formatted as strikethrough text.
@property BOOL subscript;  // Returns or sets if the font is formatted as subscript.
@property BOOL superscript;  // Returns or sets if the font is formatted as superscript.
@property STMSWord2011E113 underline;  // Returns or sets the type of underline applied to the font.
@property (copy) NSColor *underlineColor;  // Returns or sets the RGB color of the underline for the font object.
@property STMSWord2011MCoI underlineColorThemeIndex;  // Returns a value specifying the color of the underline for the selected text.

- (void) growFont;  // Increases the font size to the next available size. If the selection or range contains more than one font size, each size is increased to the next available setting.
- (void) reset;  // Removes changes that were made to a font.
- (void) setAsFontTemplateDefault;  // Sets the font formatting as the default for the active document and all new documents based on the active template. The default font formatting is stored in the Normal style.
- (void) shrinkFont;  // Decreases the font size to the next available size. If the selection or range contains more than one font size, each size is decreased to the next available setting.

@end

// A representation of the options associated with footnotes.
@interface STMSWord2011FootnoteOptions : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011TextRange *footnoteContinuationNotice;  // Returns a text range object that represents the footnote continuation notice.
@property (copy, readonly) STMSWord2011TextRange *footnoteContinuationSeparator;  // Returns a text range object that represents the footnote continuation separator.
@property STMSWord2011E174 footnoteLocation;  // Returns or sets the position of all footnotes.
@property STMSWord2011E152 footnoteNumberStyle;  // Returns or sets the number style for footnotes.
@property STMSWord2011E173 footnoteNumberingRule;  // Returns or sets the way footnotes or endnotes are numbered after page breaks or section breaks. 
@property (copy, readonly) STMSWord2011TextRange *footnoteSeparator;  // Returns a text range object that represents the footnote separator.
@property NSInteger footnoteStartingNumber;  // Returns or sets the starting footnote number. 

- (void) footnoteConvert;  // Converts endnotes to footnotes, or vice versa.
- (void) swapWithEndnotes;  // Converts all footnotes in a document to endnotes and vice versa.

@end

// Represents a footnote positioned at the bottom of the page or beneath text.
@interface STMSWord2011Footnote : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) STMSWord2011TextRange *noteReference;  // Returns a text range object that represents a footnote mark.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the portion of a document that's contained in the footnote object.


@end

// Represents a single form field.
@interface STMSWord2011FormField : STMSWord2011BaseObject

@property BOOL calculateOnExit;  // Returns or sets if references to the specified form field are automatically updated whenever the field is exited.
@property (copy, readonly) STMSWord2011CheckBox *checkBox;  // Returns the check box object associated with the form filed object.
@property (copy, readonly) STMSWord2011DropDown *dropDown;  // Returns the drop down object associated with the form filed object.
@property BOOL enabled;  // Returns or sets if this form field object is enabled.
@property (copy) NSString *formFieldResult;  // Returns or sets a string that represents the result of the specified form field.
@property (readonly) STMSWord2011E183 formFieldType;  // The type of this form field.
@property (copy) NSString *helpText;  // Returns or sets the text that's displayed in a message box when the form field has the focus and the user presses F1.
@property (copy) NSString *name;  // Returns or sets the name of the form field.
@property (copy, readonly) STMSWord2011FormField *nextFormField;  // Returns the next form field object.
@property BOOL ownHelp;  // Returns or set the source of the text that's displayed in a message box when a form field has the focus and the user presses F1. If true, the text specified by the helptext property is displayed. If false, the text in the autotext entry is displayed
@property BOOL ownStatus;  // Returns or sets the source of the text that's displayed in the status bar when a form field has the focus. If true, the text specified by the status text property is displayed. If false, the text of the autotext entry is displayed.
@property (copy, readonly) STMSWord2011FormField *previousFormField;  // Returns the previous form field object.
@property (copy) NSString *statusText;  // Returns or sets the text that's displayed in the status bar when a form field has the focus.
@property (copy, readonly) STMSWord2011TextInput *textInput;  // Returns the text input object associated with the form filed object.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the form field object.


@end

// Represents a frame.
@interface STMSWord2011Frame : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this frame object.
@property double height;  // Returns or sets the height of the object.
@property STMSWord2011E134 heightRule;  // Returns or sets the rule for determining the height of the specified frame.
@property double horizontalDistanceFromText;  // Returns or sets the horizontal distance between a frame and the surrounding text, in points.
@property double horizontalPosition;  // Returns or sets the horizontal distance between the edge of the frame and the item specified by the relative horizontal position property.
@property BOOL lockAnchor;  // Returns or sets if the specified frame is locked. The frame anchor indicates where the frame will appear in Draft view. You cannot reposition a locked frame anchor.
@property STMSWord2011E236 relativeHorizontalPosition;  // Returns or sets what the horizontal position of a frame is relative.
@property STMSWord2011E237 relativeVerticalPosition;  // Returns or sets what the vertical position of a frame is relative.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the frame object.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the frame object.
@property BOOL textWrap;  // Returns or sets if document text wraps around the specified frame.
@property double verticalDistanceFromText;  // Returns or sets the vertical distance in points between a frame and the surrounding text.
@property double verticalPosition;  // Returns or sets the vertical distance between the edge of the frame and the item specified by the relative vertical position property. 
@property double width;  // Returns or sets the width of the object.
@property STMSWord2011E134 widthRule;  // Returns or sets the rule used to determine the width of a frame.


@end

// Represents a single header or footer.
@interface STMSWord2011HeaderFooter : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011PageNumber *> *) pageNumbers;
- (SBElementArray<STMSWord2011Shape *> *) shapes;

@property (readonly) STMSWord2011E163 headerFooterIndex;  // Returns a constant that represents the specified header or footer in a document or section.
@property (readonly) BOOL isHeader;  // Returns true if this object is a header.
@property BOOL linkToPrevious;  // Returns or sets if the specified header or footer is linked to the corresponding header or footer in the previous section. When a header or footer is linked, its contents are the same as in the previous header or footer.
@property (copy, readonly) STMSWord2011PageNumberOptions *pageNumberOptions;  // Return the page number options object associated with this header footer object.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the header or footer.


@end

// Represents a style used to build a table of contents or figures.
@interface STMSWord2011HeadingStyle : STMSWord2011BaseObject

@property NSInteger level;  // Returns or sets the level for the heading style in a table of contents or table of figures.
@property STMSWord2011E184 style;  // Returns or sets the style associated with the heading style object.


@end

// Represents a hyperlink.
@interface STMSWord2011HyperlinkObject : STMSWord2011BaseObject

@property (copy) NSString *emailSubject;  // Returns or sets the text string for the specified hyperlink’s subject line. The subject line is appended to the hyperlink’s Internet address, or URL.
@property (readonly) BOOL extraInfoRequired;  // Returns true if extra information is required to resolve the specified hyperlink.
@property (copy) NSString *hyperlinkAddress;  // Returns or sets the address, for example, a file name or URL of the specified hyperlink. 
@property (readonly) STMSWord2011MHlT hyperlinkType;  // The type of this hyperlink
@property (copy, readonly) NSString *name;  // The name of this hyperlink object.
@property (copy) NSString *screenTip;  // Returns or sets the text that appears as a screen tip when the mouse pointer is positioned over the specified hyperlink.
@property (copy, readonly) STMSWord2011Shape *shape;
@property (copy) NSString *subAddress;  // Returns or sets a named location in the destination of the specified hyperlink. 
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the hyperlink.
@property (copy) NSString *textToDisplay;  // Returns or sets the specified hyperlink's visible text in a document.

- (void) createNewDocumentForHyperlinkFileName:(NSString *)fileName editNow:(BOOL)editNow overwrite:(BOOL)overwrite;  // Creates a new document linked to the specified hyperlink.
- (void) followNewWindow:(BOOL)newWindow extraInfo:(NSString *)extraInfo;  // Displays a cached document associated with the specified hyperlink object, if it's already been downloaded. Otherwise, this method resolves the hyperlink, downloads the target document, and displays the document in the appropriate application.

@end

// Represents a single index.
@interface STMSWord2011Index : STMSWord2011BaseObject

@property BOOL accentedLetters;  // Returns or sets if the specified index contains separate headings for accented letters, for example, words that begin with À are under one heading and words that begin with A are under another.
@property STMSWord2011E119 headingSeparator;  // Returns or sets the text between alphabetic groups, entries that start with the same letter in the index.  
@property STMSWord2011E105 indexFilter;  // Returns or sets a value that specifies how Microsoft Word classifies the first character of entries in the specified index. 
@property STMSWord2011E214 indexType;  // Returns or sets the index type.
@property NSInteger numberOfColumns;  // Sets or returns the number of columns for each page of an index.
@property BOOL rightAlignPageNumbers;  // Returns or sets if page numbers are aligned with the right margin in an index. 
@property STMSWord2011E106 sortBy;  // Returns or sets the sorting criteria for the specified index.
@property STMSWord2011E170 tabLeader;  // Returns or sets the character between entries and their page numbers in an index. 
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the index


@end

// Represents a custom key assignment in the current context.
@interface STMSWord2011KeyBinding : STMSWord2011BaseObject

@property (copy, readonly) SBObject *bindingContext;  // Returns an object that represents the storage location of the specified key binding. This property can return a document or template object.
@property (copy, readonly) NSString *bindingKeyString;  // Returns the key combination string for the specified keys.
@property (copy, readonly) NSString *command;  // Returns the command assigned to the specified key combination.
@property (copy, readonly) NSString *commandParameter;  // Returns the command parameter assigned to the specified shortcut key.
@property (readonly) STMSWord2011E239 keyCategory;  // Returns the type of item assigned to the specified key binding.
@property (readonly) NSInteger keyCode;  // Returns a unique number for the first key in the specified key binding.  You create this number by using the build key code method.
@property (readonly) NSInteger key_code_2;  // Returns a unique number for the second key in the specified key binding. You create this number by using the build key code method.
- (BOOL) protected;  // Returns true if you cannot change the specified key binding in the customize keyboard dialog box. 

- (void) disable;  // Removes the specified key combination if it's currently assigned to a command. After you use this method, the key combination has no effect.
- (void) executeKeyBinding;  // Runs the command associated with the specified key combination.
- (void) rebindKeyCategory:(STMSWord2011E239)keyCategory command:(NSString *)command commandParameter:(NSString *)commandParameter;  // Changes the command assigned to the specified key binding.

@end

// Represents the elements of a letter created by the letter wizard.
@interface STMSWord2011LetterContent : STMSWord2011BaseObject

@property (copy) NSString *attentionLine;  // Returns or sets the attention line text for a letter created by the letter wizard.
@property (copy) NSString *ccList;  // Returns or sets the carbon copy recipients for a letter created by the letter wizard.
@property (copy) NSString *closing;  // Returns or sets the closing text for a letter created by the letter wizard, for example, Sincerely yours.
@property (copy) NSString *dateFormat;  // Returns or sets the date for a letter created by the letter wizard. 
@property NSInteger enclosureCount;  // Returns or sets the number of enclosures for a letter created by the letter wizard. 
@property BOOL includeHeaderFooter;  // Returns or sets if the header and footer from the page design template are included in a letter created by the letter wizard.
@property STMSWord2011E245 letterStyle;  // Returns or sets the layout of a letter created by the letter wizard.
@property BOOL letterhead;  // Returns or sets if space is reserved for a preprinted letterhead in a letter created by the letter wizard.
@property STMSWord2011E246 letterheadLocation;  // Returns or sets the location of the preprinted letterhead in a letter created by the letter wizard.
@property double letterheadSize;  // Returns or sets the amount of space in points to be reserved for a preprinted letterhead in a letter created by the letter wizard.
@property (copy) NSString *mailingInstructions;  // Returns or sets the mailing instruction text for a letter created by the letter wizard, for example, Certified Mail.
@property (copy) NSString *pageDesign;  // Returns or sets the name of the template attached to the document created by the letter wizard.
@property (copy) NSString *recipientAddress;  // Returns or sets the return address for a letter created with the letter wizard.
@property (copy) NSString *recipientName;  // Returns or sets the name of the person who'll be receiving the letter created by the letter wizard.
@property (copy) NSString *recipientReference;  // Returns or sets the reference line, for example, In reply to: for a letter created by the letter wizard.
@property (copy) NSString *returnAddress;  // Returns or sets the return address for a letter created with the letter wizard. 
@property (copy) NSString *salutation;  // Returns or sets the salutation text for a letter created by the letter wizard.
@property STMSWord2011E247 salutationType;  // Returns or sets the type of salutation for a letter created by the letter wizard.  
@property (copy, readonly) NSString *senderCity;
@property (copy) NSString *senderCompany;  // Returns or sets the company name of the person creating a letter with the letter wizard.
@property (copy) NSString *senderInitials;  // Returns or sets the initials of the person creating a letter with the letter wizard. 
@property (copy) NSString *senderJobTitle;  // Returns or sets the job title of the person creating a letter with the letter wizard.
@property (copy) NSString *senderName;  // Returns or sets the name of the person creating a letter with the letter wizard. 
@property (copy) NSString *subject;  // Returns or sets the subject text of a letter created by the letter wizard.


@end

// Represents line numbers in the left margin or to the left of each newspaper-style column.
@interface STMSWord2011LineNumbering : STMSWord2011BaseObject

@property BOOL activeLine;  // Returns or sets if line numbering is active for the specified document, section, or sections.
@property NSInteger countBy;  // Returns or sets the numeric increment for line numbers. For example, if the count by property is set to 5, every fifth line will display the line number. Line numbers are only displayed in print layout view and print preview.
@property double distanceFromText;  // Returns or sets the distance in points between the right edge of line numbers and the left edge of the document text.
@property STMSWord2011E173 restartMode;  // Returns or sets the way line numbering runs— that is, whether it starts over at the beginning of a new page or section or runs continuously.
@property NSInteger startingNumber;  // Returns or sets the starting line number.


@end

// Represents the linking characteristics for a picture.
@interface STMSWord2011LinkFormat : STMSWord2011BaseObject

@property BOOL autoUpdate;  // Returns or sets if the specified link is updated automatically when the container file is opened or when the source file is changed.
@property (readonly) STMSWord2011E200 linkType;  // Returns the link type.
@property BOOL locked;  // Returns or sets if inline shape object is locked to prevent automatic updating.
@property BOOL savePictureWithDocument;  // Returns or sets if the specified picture is saved with the document.
@property (copy) NSString *sourceFullName;  // Returns or sets the path and name of the source file for the specified picture.
@property (copy, readonly) NSString *sourceName;  // Returns the name of the source file for the specified picture.
@property (copy, readonly) NSString *sourcePath;  // Returns the path of the source file for the specified picture.

- (void) breakLink;  // Breaks the link between the source file and the specified picture.

@end

// Represents an item in a drop-down form field.
@interface STMSWord2011ListEntry : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy) NSString *name;  // Returns or sets the name of this list entry object.


@end

// Represents the list formatting attributes that can be applied to the paragraphs in a range.
@interface STMSWord2011ListFormat : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011WordList *WordList;  // Returns a Word list object that represents the first formatted list contained in the list format object.
@property NSInteger listLevelNumber;  // Returns or sets the list level for the first paragraph in the list format object.
@property (copy) STMSWord2011InlineShape *listPictureBullet;
@property (copy, readonly) NSString *listString;  // Returns a string that represents the appearance of the list value of the first paragraph in the range for the list format object. For example, the second paragraph in an alphabetic list would return B.
@property (copy, readonly) STMSWord2011ListTemplate *listTemplate;  // Returns a list template object that represents the list formatting for the list format object.
@property (readonly) STMSWord2011E159 listType;  // Returns the type of lists that are contained in the range for the list format object.
@property (readonly) NSInteger listValue;  // Returns the numeric value of the first paragraph in the range for the specified list format object. For example, the list value property applied to the second paragraph in an alphabetic list would return 2.
@property (readonly) BOOL singleList;  // Returns if the specified list format object contains only one list.
@property (readonly) BOOL singleListTemplate;  // True if the entire list format object uses the same list template

- (void) applyBulletDefaultDefaultListBehavior:(STMSWord2011E289)defaultListBehavior;  // Adds bullets and formatting to the paragraphs in the range for the list format object. If the paragraphs are already formatted with bullets, this method removes the bullets and formatting.
- (void) applyListFormatTemplateListTemplate:(STMSWord2011ListTemplate *)listTemplate continuePreviousList:(BOOL)continuePreviousList applyTo:(STMSWord2011E137)applyTo defaultListBehavior:(STMSWord2011E289)defaultListBehavior;  // Applies a set of list-formatting characteristics to the list format object
- (void) applyNumberDefaultDefaultListBehavior:(STMSWord2011E289)defaultListBehavior;  // Adds the default numbering scheme to the paragraphs in the range for the list format object. If the paragraphs are already formatted as a numbered list, this method removes the numbers and formatting.
- (void) applyOutlineNumberDefaultDefaultListBehavior:(STMSWord2011E289)defaultListBehavior;  // Adds the default outline-numbering scheme to the paragraphs in the range for the list format object. If the paragraphs are already formatted as an outline-numbered list, this method removes the numbers and formatting.
- (void) listIndent;  // Increases the list level of the paragraphs in the range for the list format object, in increments of one level.
- (void) listOutdent;  // Decreases the list level of the paragraphs in the range for the list format object, in increments of one level.

@end

// Represents a single gallery of list formats.
@interface STMSWord2011ListGallery : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011ListTemplate *> *) listTemplates;

- (BOOL) modifiedIndex:(NSInteger)index;  // if the specified list template is not the built-in list template for that position in the list gallery. Index goes from 1 to 7
- (void) resetListGalleryIndex:(NSInteger)index;  // Resets the list template specified by index for the specified list gallery to the built-in list template format.

@end

// Represents a single list level, either the only level for a bulleted or numbered list or one of the nine levels of an outline numbered list.
@interface STMSWord2011ListLevel : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) STMSWord2011Font *fontObject;  // Returns the font object associated with this list level object.
@property (copy) NSString *linkedStyle;  // Returns or sets the name of the style that's linked to the specified list level object.
@property STMSWord2011E143 listLevelAlignment;  // Returns or sets a constant that represents the alignment for the list level of the list template.
@property (copy) NSString *numberFormat;  // Returns or sets the number format for the specified list level.
@property double numberPosition;  // Returns or sets the position in points of the number or bullet for the specified list level object.
@property STMSWord2011E151 numberStyle;  // Returns or sets the number style for the list level object.
@property (copy, readonly) STMSWord2011InlineShape *pictureBullet;
@property NSInteger resetOnHigher;  // Returns or sets the list level that must appear before the specified list level restarts numbering at 1.
@property NSInteger startAt;  // Returns or sets the starting number for the specified list level object.
@property double tabPosition;  // Returns or sets the tab position for the specified list level object.
@property double textPosition;  // Returns or sets the position in points for the second line of wrapping text for the specified list level object.
@property STMSWord2011E149 trailingCharacter;  // Returns or sets the character inserted after the number for the specified list level.

- (STMSWord2011InlineShape *) applyPictureBulletPath:(NSString *)path;

@end

// Represents a single list template that includes all the formatting that defines a list.
@interface STMSWord2011ListTemplate : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011ListLevel *> *) listLevels;

@property (copy) NSString *name;  // Returns or sets the name of this list template object.
@property BOOL outlineNumbered;  // Returns or sets if the specified list template object is outline numbered.

- (STMSWord2011ListTemplate *) convertLevel:(NSInteger)level;  // Converts a multiple-level list to a single-level list, or vice versa.

@end

// Represents a mailing label.
@interface STMSWord2011MailingLabel : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011CustomLabel *> *) customLabels;

@property (copy) NSString *defaultLabelName;  // Returns or sets the name for the default mailing label.
@property STMSWord2011E207 defaultLaserTray;  // Returns or sets the default paper tray that contains sheets of mailing labels
@property BOOL defaultPrintBarCode;  // Returns or sets if a POSTNET bar code is added to envelopes or mailing labels by default. For U.S. mail only. This property must be set to true before the default print FIMA property is set

- (STMSWord2011Document *) createNewMailingLabelDocumentName:(NSString *)name address:(NSString *)address autoText:(NSString *)autoText extractAddress:(BOOL)extractAddress laserTray:(STMSWord2011E207)laserTray singleLabel:(BOOL)singleLabel row:(NSInteger)row column:(NSInteger)column;  // Creates a new label document using either the default label options or ones that you specify. Returns a document object that represents the new document.
- (void) printOutMailingLabelName:(NSString *)name address:(NSString *)address extractAddress:(BOOL)extractAddress laserTray:(STMSWord2011E207)laserTray singleLabel:(BOOL)singleLabel row:(NSInteger)row column:(NSInteger)column;  // Prints a label or a page of labels with the same address.

@end

// Represents an equation that has an accent mark above the base.
@interface STMSWord2011MathAccent : STMSWord2011BaseObject

- (NSInteger) char;  // Gets or sets an integer that represents the accent character for the accent object.
- (void) setChar: (NSInteger)a_char;
@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.


@end

// Represents an individual entry in the Math AutoCorrect engine.
@interface STMSWord2011MathAutocorrectEntry : STMSWord2011BaseObject

@property (copy) NSString *autocorrectValue;  // Gets or sets a string that represents the contents of an equation auto correct entry.
@property (readonly) NSInteger entry_index;  // Gets an integer that represents the position of an item in the collection.
@property (copy) NSString *name;  // Gets or sets a string that represents the name of an equation auto correct entry.


@end

// Represents the Math AutoCorrect feature in Microsoft Word.
@interface STMSWord2011MathAutocorrect : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MathAutocorrectEntry *> *) mathAutocorrectEntries;
- (SBElementArray<STMSWord2011MathRecognizedFunction *> *) mathRecognizedFunctions;

@property BOOL replaceText;  // Gets or sets whether Microsoft Word automatically replaces strings in equations with the corresponding math AutoCorrect definitions.
@property BOOL useOutsideEquations;  // Gets or sets whether Microsoft Word uses math autocorrect rules outside equations in a document.

- (void) addMathAcEntryName:(NSString *)name value:(NSString *)value;  // Creates an equation auto correct entry.
- (void) addMathRecognizedFunctionName:(NSString *)name;  // Creates a new recognized function.

@end

// Represents the mathematical overbar for an object in an equation.
@interface STMSWord2011MathBar : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property BOOL isTopBar;  // Gets or sets the position of a bar in a bar object. True specifies a mathematical overbar. False specifies a mathematical underbar


@end

// Represents an invisible box around an equation or part of an equation to which you can assign properties that affect the layout or mathematical formatting of the entire box.
@interface STMSWord2011MathBorderBox : STMSWord2011BaseObject

@property BOOL bottomLeftToTopRightStrikethrough;  // Gets or sets if a diagonal strikethrough from lower left to upper right is drawn.
@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property BOOL hideBottom;  // Gets or sets whether to hide the bottom border of an equation's bounding box.
@property BOOL hideLeft;  // Gets or sets whether to hide the left border of an equation's bounding box.
@property BOOL hideRight;  // Gets or sets whether to hide the right border of an equation's bounding box.
@property BOOL hideTop;  // Gets or sets whether to hide the top border of an equation's bounding box.
@property BOOL horizontalStrikethrough;  // Gets or sets if a horizontal strikethrough is drawn.
@property BOOL topLeftToBottomRightStrikethrough;  // Gets or sets if a diagonal strikethrough from upper left to lower right is drawn.
@property BOOL verticalStrikethrough;  // Gets or sets if vertical strikethrough is drawn.


@end

// Represents an invisible box around an equation or part of an equation to which you can apply properties that affect the mathematical or formatting properties, such as line breaks.
@interface STMSWord2011MathBox : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property BOOL isDifferential;  // Gets or sets whether the box acts as the mathematical differential, in which case the box receives the appropriate horizontal spacing for a differential.
@property BOOL isOperatorEmulator;  // Gets or sets if the box and its contents behave as a single operator and inherits the properties of an operator.
@property BOOL nonBreaking;  // Gets or sets whether breaks are allowed inside the box object.


@end

// Represents individual line breaks in an equation.
@interface STMSWord2011MathBreak : STMSWord2011BaseObject

@property NSInteger alignAt;  // Gets or sets an integer that represents the operator in one line, to which to align consecutive lines in an equation.
@property (copy, readonly) STMSWord2011TextRange *textRange;  // Returns a text range object that represents the portion of a document that is contained in the specified object.


@end

// Represents a delimiter object, consisting of opening and closing delimiters, e.g. parentheses, braces, brackets, or vertical bars, and one or more elements contained inside the delimiters.
@interface STMSWord2011MathDelimiter : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MathObject *> *) mathObjects;

@property NSInteger beginningCharacter;  // Gets or sets an Integer that represents the beginning delimiter character in a delimiter object.
@property STMSWord2011E325 delimiterShape;  // Gets or sets the appearance of delimiters, e.g. parentheses, braces, and brackets, in relationship to the content that they surround.
@property NSInteger endingCharacter;  // Gets or sets an Integer that represents the ending delimiter character in a delimiter object.
@property BOOL hideLeftDelimiter;  // Gets or sets whether to hide the opening delimiter in a delimiter object.
@property BOOL hideRightDelimiter;  // Gets or sets whether to hide the closing delimiter in a delimiter object.
@property NSInteger separatorCharacter;  // Gets or sets an Integer that represents the separator character in a delimiter object when the delimiter object contains two or more arguments.
@property BOOL shouldGrow;  // Gets or sets whether delimiter characters grow to the full height of the arguments that they contain.


@end

// Represents a mathematical equation array object, consisting of one or more equations that can be vertically justified as a unit respect to surrounding text on the line.
@interface STMSWord2011MathEquationArray : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MathObject *> *) mathObjects;

@property BOOL distributeEqually;  // Gets or sets if the equations in an equation array are distributed equally within the margins of its container, such as a column, cell, or page width.
@property NSInteger rowSpacing;  // Gets or sets an integer that represents the spacing between the rows in an equation array.
@property STMSWord2011E323 rowSpacingRule;  // Gets or sets the spacing rule that defines spacing in an equation array.
@property BOOL useMaxWidth;  // Gets or sets whether the equations in an equation array are spaced to the maximum width of the equation array.
@property STMSWord2011E321 verticalAlignment;  // Gets or sets the type of vertical alignment for an equation array with respect to the text that surrounds the array.


@end

// Represents a fraction, consisting of a numerator and denominator separated by a fraction bar. The fraction bar can be horizontal or diagonal, depending on the fraction properties.
@interface STMSWord2011MathFraction : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *denominator;  // Returns a math object object that represents the denominator for an equation that contains a fraction.
@property STMSWord2011E322 fractionType;  // Gets or sets the layout of a fraction, whether it is stacked, skewed, linear, or without a fraction bar.
@property (copy, readonly) STMSWord2011MathObject *numerator;  // Returns a math object object that represents the numerator for the fraction.


@end

// Represents a math func object that represents a type of mathematical function that consists of a function name, such as sin or cos, and an argument.
@interface STMSWord2011MathFunc : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property (copy, readonly) STMSWord2011MathObject *funcName;  // Returns an OMath object that represents the name of a mathematical function, such as sin or cos.


@end

// Represents a mathematical function or structure such as fractions, integrals, sums, and radicals.
@interface STMSWord2011MathFunction : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MathObject *> *) mathObjects;

@property (copy, readonly) STMSWord2011MathAccent *accent;  // Returns a math accent object that represents a base character with a combining accent mark.
@property (copy, readonly) STMSWord2011MathBorderBox *borderBox;  // Returns a math border box object that represents a border drawn around an equation or part of an equation.
@property (copy, readonly) STMSWord2011MathBox *box;  // Returns a math box object to which you can apply properties.
@property (copy, readonly) STMSWord2011MathDelimiter *delimiter;  // Returns an math delimiter object that represents the delimiter function
@property (copy, readonly) STMSWord2011MathEquationArray *equationArray;  // Returns a math equation array object that represents an equation array function.
@property (copy, readonly) STMSWord2011MathFraction *fraction;  // Returns a math fraction object that represents a fraction.
@property (copy, readonly) STMSWord2011MathFunc *func;  // Returns a math func object that represents a type of mathematical function.
@property (readonly) STMSWord2011E319 functionType;  // Gets the type of the function.
@property (copy, readonly) STMSWord2011MathGroupChar *groupChar;  // Returns a math group char object that represents a horizontal character placed above or below text in an equation.
@property (copy, readonly) STMSWord2011MathLeftScripts *leftScripts;
@property (copy, readonly) STMSWord2011MathLowerLimit *lowerLimit;  // Returns a math lower limit object that represents the lower limit for a function.
@property (copy, readonly) STMSWord2011MathObject *mathObj;  // Returns an OMath object that represents the equation.
@property (copy, readonly) STMSWord2011MathMatrix *matrix;  // Returns a math matrix object that represents a mathematical matrix.
@property (copy, readonly) STMSWord2011MathNary *nary;  // Returns a math nary object that represents the n-ary operation.
@property (copy, readonly) STMSWord2011MathBar *overbar;  // Returns a math bar object that represents the mathematical overbar for an object.
@property (copy, readonly) STMSWord2011MathPhantom *phantom;  // Returns a math phantom object that represents an object used for advanced layout of an equation.
@property (copy, readonly) STMSWord2011MathRadical *radical;  // Returns a math radical object that represents the mathematical radical function.
@property (copy, readonly) STMSWord2011MathSubAndSuperScript *subAndSuperScript;  // Returns a math sub and super script object that represents a mathematical subscript-superscript object that consists of a base, a subscript, and a superscript.
@property (copy, readonly) STMSWord2011MathSubscript *subscript;  // Returns a math subscript object that represents the mathematical subscript function.
@property (copy, readonly) STMSWord2011MathSuperscript *superscript;  // Returns a math superscript object that represents the mathematical superscript function.
@property (copy, readonly) STMSWord2011TextRange *textRange;  // Returns a text range object that represents the portion of a document that is contained in the math function.
@property (copy, readonly) STMSWord2011MathUpperLimit *upperLimit;  // Returns a math upper limit object that represents upper limit function.


@end

// Represents a group character object, consisting of a character drawn above or below text, often with the purpose of visually grouping items.
@interface STMSWord2011MathGroupChar : STMSWord2011BaseObject

@property BOOL alignTop;  // Returns or sets whether the grouping character is aligned vertically with the surrounding text or whether the base text that is either above or below the grouping character is aligned vertically with the surrounding text.
@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property BOOL isOnTop;  // Gets or sets whether the grouping character is placed above the base text of the group character object. False displays the group character under the base text.
@property NSInteger theCharacter;  // Gets or sets an integer that represents the character placed above or below text in a group character object.


@end

// Represents an equation that contains a superscript or subscript to the left of the base.
@interface STMSWord2011MathLeftScripts : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property (copy, readonly) STMSWord2011MathObject *subscript;  // Returns a math object object that represents the subscript for a pre-sub-superscript object.
@property (copy, readonly) STMSWord2011MathObject *superscript;  // Returns a math object object that represents the superscript for a pre-sub-superscript object.

- (STMSWord2011MathFunction *) convertLeftScriptsToSubAndSuperScripts;  // Converts an equation with a superscript or subscript to the left of the base of the equation to an equation with a base of a superscript or subscript.

@end

// Represents the lower limit mathematical construct, consisting of text on the baseline and reduced-size text immediately below it.
@interface STMSWord2011MathLowerLimit : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property (copy, readonly) STMSWord2011MathObject *limit;  // Returns a math object object that represents the limit of the lower limit object. 

- (STMSWord2011MathFunction *) lowerLimitToUpperLimit;

@end

// Represents a matrix column.
@interface STMSWord2011MathMatrixColumn : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MathObject *> *) mathObjects;

@property NSInteger columnIndex;  // Gets an integer that represents the ordinal position of a matrix column within the collection of matrix columns.
@property STMSWord2011E320 horizontalAlignment;  // Gets or sets the horizontal alignment for arguments in a matrix column.


@end

// Represents a matrix row.
@interface STMSWord2011MathMatrixRow : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MathObject *> *) mathObjects;

@property NSInteger rowIndex;  // Gets an integer that represents the ordinal position of a matrix row within the collection of matrix rows.


@end

// Represents an equation matrix.
@interface STMSWord2011MathMatrix : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MathMatrixRow *> *) mathMatrixRows;
- (SBElementArray<STMSWord2011MathMatrixColumn *> *) mathMatrixColumns;

@property NSInteger columnGap;  // Gets or sets an integer that represents the spacing between columns in a matrix.
@property STMSWord2011E323 columnGapRule;  // Gets or sets the spacing rule for the space that appears between columns in a matrix.
@property NSInteger columnSpacing;  // Gets or sets an integer that represents the spacing for columns in a matrix.
@property BOOL hidePlaceholders;  // Gets or sets whether placeholders in a matrix are hidden from display.
@property NSInteger rowSpacing;  // Gets or sets an integer that represents the spacing for rows in a matrix. 
@property STMSWord2011E323 rowSpacingRule;  // Gets or sets the spacing rule for rows in a matrix.
@property STMSWord2011E321 verticalAlignment;  // Gets or sets the vertical alignment for a matrix.

- (STMSWord2011MathMatrixColumn *) addMatrixColumnBeforeColumn:(STMSWord2011MathMatrixColumn *)beforeColumn;  // Creates a matrix column and adds it to a matrix and returns a math matrix column object.
- (STMSWord2011MathMatrixRow *) addMatrixRowBeforeRow:(STMSWord2011MathMatrixRow *)beforeRow;  // Creates a matrix row and adds it to a matrix and returns a math matrix row object.

@end

// Represents the mathematical n-ary object, consisting of an n-ary object, a base/operand, and optional upper limits and lower limits.
@interface STMSWord2011MathNary : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property BOOL hidesLowerLimit;  // Gets or sets whether to hide the lower limit of an n-ary operator.
@property BOOL hidesUpperLimit;  // Gets or sets whether to hide the upper limit of an n-ary operator.
@property (copy, readonly) STMSWord2011MathObject *lowerLimit;  // Returns a math object object that represents the lower limit of an n-ary operator.
@property NSInteger operatorCharacter;  // Gets or sets an integer that represents a character used as the n-ary operator.
@property BOOL shouldGrow;  // Gets or sets whether n-ary operators grow to the full height of the arguments that they contain.
@property (copy, readonly) STMSWord2011MathObject *upperLimit;  // Returns a math object object that represents the upper limit of an n-ary operator.
@property BOOL useSubAndSuperScriptPositioning;  // Gets or sets the positioning of n-ary limits in the subscript-superscript or upper limit-lower limit position.


@end

// Represents an equation
@interface STMSWord2011MathObject : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MathFunction *> *) mathFunctions;
- (SBElementArray<STMSWord2011MathBreak *> *) mathBreaks;

@property NSInteger alignPoint;  // Gets or sets an integer that represents the character position of the alignment point in the equation.
@property (readonly) NSInteger argumentIndex;  // Gets an integer that specifies the argument index of this component relative to the containing math object.
@property (copy, readonly) STMSWord2011MathFunction *containingFunction;  // Gets the math function that represents the parent, or containing, function.
@property STMSWord2011E324 displayType;  // Sets or returns the display type of the equation.
@property STMSWord2011E326 justification;  // Gets or sets the justification for the equation.
@property (readonly) NSInteger nestingLevel;  // Returns an integer that represents the nesting level for the math object.
@property (copy, readonly) STMSWord2011MathObject *parentArgument;  // Gets a math object that represents the parent, or containing, argument.
@property (copy, readonly) STMSWord2011MathMatrixColumn *parentColumn;  // Gets a math matrix column object that represents the parent column in a matrix.
@property (copy, readonly) STMSWord2011MathObject *parentObject;  // Gets the math object that represents the parent object.
@property (copy, readonly) STMSWord2011MathMatrixRow *parentRow;  // Gets a math matrix row object that represents the parent row in a matrix.
@property NSInteger scriptSize;  // Gets or sets an integer that represents the script size of an argument, for example, text, script, or script-script.
@property (copy, readonly) STMSWord2011TextRange *textRange;  // Gets a text range object that represents the portion of a document that contains the equation.

- (void) addMathFunctionInLocation:(STMSWord2011TextRange *)inLocation mathFunctionType:(STMSWord2011E319)mathFunctionType numberOfArguments:(NSInteger)numberOfArguments numberOfColumns:(NSInteger)numberOfColumns;  // Inserts a new structure, such as a fraction, into an equation at the specified position.
- (void) buildUp;  // Converts an equation to professional/built up format.
- (void) convertToLiteralText;  // Converts an equation to literal text.
- (void) convertToMathText;  // Converts an equation to math text.
- (void) convertToNormalText;  // Converts an equation to normal text.
- (STMSWord2011MathBreak *) insertMathBreakAtRange:(STMSWord2011TextRange *)atRange;  // Inserts a break into an equation and returns a math break object that represents the break.
- (void) linearize;  // Converts an equation to linear/built down format.

@end

// Represents a phantom object, which has two primary uses: 1. adding the spacing of the phantom base without displaying that base or 2. suppressing part of the glyph from spacing considerations.
@interface STMSWord2011MathPhantom : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property BOOL showsInvisibles;  // Gets or sets whether the contents of a phantom object are visible.
@property BOOL smash;  // Gets or sets if the contents of the phantom are visible but that the height is not taken into account in the spacing of the layout.
@property BOOL transparent;  // Gets or sets whether a phantom object is transparent.
@property BOOL zeroAscent;  // Gets or sets whether the ascent of the phantom contents is ignored in the spacing of the layout.
@property BOOL zeroDescent;  // Gets or sets whether the descent of the phantom contents is ignored in the spacing of the layout.
@property BOOL zeroWidth;  // Gets or sets whether the width of a phantom object is ignored in the spacing of the layout.


@end

// Represents the mathematical radical object, consisting of a radical, a base, and an optional degree.
@interface STMSWord2011MathRadical : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *degree;  // Returns a math object object that represents the degree for a radical.
@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property BOOL hideDegree;  // Gets or sets whether to hide the degree for the radical.


@end

@interface STMSWord2011MathRecognizedFunction : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Gets an integer that represents the position of an item in the collection.
@property (copy, readonly) NSString *name;  // Gets a string that represents the name of an equation recognized function.


@end

// Represents an equation with a base that contains a superscript or subscript.
@interface STMSWord2011MathSubAndSuperScript : STMSWord2011BaseObject

@property BOOL alignScripts;  // Gets or sets whether to horizontally align subscripts and superscripts in the sub-superscript object.
@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property (copy, readonly) STMSWord2011MathObject *subscript;  // Returns a math object object that represents the subscript for a subscript-superscript object.
@property (copy, readonly) STMSWord2011MathObject *superscript;  // Returns a math object object that represents the superscript for a subscript-superscript object.

- (STMSWord2011MathFunction *) convertSubAndSuperScriptsToLeftScripts;  // Converts an equation with a base superscript or subscript to an equation with a superscript or subscript to the left of the base.
- (STMSWord2011MathFunction *) removeSubscript;  // Removes the subscript for an equation and returns a math function object that represents the updated equation without the subscript.
- (STMSWord2011MathFunction *) removeSuperscript;  // Removes the superscript for an equation and returns a math function object that represents the updated equation without the superscript.

@end

// Represents an equation with a base that contains a subscript.
@interface STMSWord2011MathSubscript : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property (copy, readonly) STMSWord2011MathObject *subscript;  // Returns a math object that represents the subscript for a subscript object.


@end

// Represents an equation with a base that contains a superscript.
@interface STMSWord2011MathSuperscript : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property (copy, readonly) STMSWord2011MathObject *superscript;  // Returns a math object object that represents the superscript for a superscript object.


@end

// Represents the upper limit mathematical construct, consisting of text on the baseline and reduced-size text immediately above it.
@interface STMSWord2011MathUpperLimit : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011MathObject *equationBase;  // Returns a math object object that represents the base of the equation object.
@property (copy, readonly) STMSWord2011MathObject *limit;  // Returns a math object object that represents the limit of the upper limit object.

- (STMSWord2011MathFunction *) upperLimitToLowerLimit;

@end

// Represents options associated with page number objects
@interface STMSWord2011PageNumberOptions : STMSWord2011BaseObject

@property STMSWord2011E120 chapterPageSeparator;  // Returns or sets the separator character used between the chapter number and the page number. 
@property NSInteger headingLevelForChapter;  // Returns or sets the heading level style that's applied to the chapter titles in the document. Can be a number from zero through 8, corresponding to heading levels 1 through 9.
@property BOOL includeChapterNumber;  // Returns or sets if a chapter number is included with page numbers.
@property STMSWord2011E154 numberStyle;  // Returns or sets the number style for the page number objects.
@property BOOL restartNumberingAtSection;  // Returns or sets if page numbering starts at 1 again at the beginning of the specified section.
@property BOOL showFirstPageNumber;  // Returns or sets if the page number appears on the first page in the section.
@property NSInteger startingNumber;  // Returns or sets the starting page number.


@end

// Represents a page number in a header or footer.
@interface STMSWord2011PageNumber : STMSWord2011BaseObject

@property STMSWord2011E121 alignment;  // Returns or sets a constant that represents the alignment for the page number.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.


@end

// Represents the page setup description.
@interface STMSWord2011PageSetup : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011TextColumn *> *) textColumns;

@property double bottomMargin;  // Returns or sets the distance in points between the bottom edge of the page and the bottom boundary of the body text.
@property double charsLine;  // Returns or sets the number of characters per line in the document grid.
@property BOOL differentFirstPageHeaderFooter;  // Returns or set if a different header or footer is used on the first page.
@property STMSWord2011E207 firstPageTray;  // Returns or sets the paper tray to use for the first page of a document or section.
@property double footerDistance;  // Returns or sets the distance in points between the footer and the bottom of the page.
@property double gutter;  // Returns or sets the amount in points of extra margin space added to each page in a document or section for binding. 
@property STMSWord2011E283 gutterPosition;  // Returns or sets on which side the gutter appears in a document.
@property double headerDistance;  // Returns or sets the distance in points between the header and the top of the page.
@property STMSWord2011E278 layoutMode;  // Returns or sets the layout mode for the current document.
@property double leftMargin;  // Returns or sets the distance in points between the left edge of the page and the left boundary of the body text.
@property BOOL lineBetweenTextColumns;  // Returns or sets if vertical lines appear between all the columns.
@property (copy) STMSWord2011LineNumbering *lineNumbering;  // Returns or sets the line numbering object that represents the line numbers for the specified page setup object.
@property double linesPage;  // Returns or sets the number of lines per page in the document grid.
@property BOOL mirrorMargins;  // Returns or sets if the inside and outside margins of facing pages are the same width.
@property BOOL oddAndEvenPagesHeaderFooter;  // Returns or sets if the specified page setup object has different headers and footers for odd-numbered and even-numbered pages.
@property STMSWord2011E208 orientation;  // Returns or sets the orientation of the page.
@property STMSWord2011E207 otherPagesTray;  // Returns or sets the paper tray to be used for all but the first page of a document or section.
@property double pageHeight;  // Returns or sets the height of the page in points.
@property double pageWidth;  // Returns or sets the width of the page in points.
@property STMSWord2011E232 paperSize;  // Returns or sets the paper size.
@property double rightMargin;  // Returns or sets the distance in points between the right edge of the page and the right boundary of the body text.
@property STMSWord2011E219 sectionStart;  // Returns or sets the type of section break for the specified object.
@property BOOL showGrid;  // Determines whether to show the grid.
@property double spacingBetweenTextColumns;  // Returns or sets the spacing in points between columns.
@property BOOL suppressEndnotes;  // Returns or sets if endnotes are printed at the end of the next section that doesn't suppress endnotes. Suppressed endnotes are printed before the endnotes in that section.
@property BOOL textColumnsEvenlySpaced;  // Returns or sets if text columns are evenly spaced.
@property double topMargin;  // Returns or sets the distance in points between the top edge of the page and the top boundary of the body text.
@property STMSWord2011E146 verticalAlignment;  // Returns or sets the vertical alignment of text on each page in a document or section.
@property double widthOfTextColumns;  // Returns or sets the width of all text columns

- (void) setAsPageSetupTemplateDefault;  // Sets the specified page setup formatting as the default for the active document and all new documents based on the active template.
- (void) setNumberOfTextColumnsNumberOfColumns:(NSInteger)numberOfColumns;  // Arranges text into the specified number of text columns. 
- (void) togglePortrait;  // Switches between portrait and landscape page orientations for a document or section.

@end

// Represents a window pane.
@interface STMSWord2011Pane : STMSWord2011BaseObject

@property BOOL browseToWindow;  // Returns or sets if lines wrap at the right edge of the pane rather than at the right margin of the page.
@property (readonly) NSInteger browseWidth;  // Returns the width in points of the area in which text wraps in the specified pane. This property works only when you're in web layout view.
@property BOOL displayRulers;  // Returns or sets if rulers are displayed for the window
@property BOOL displayVerticalRuler;  // Returns or sets if vertical rulers are displayed for the window
@property (copy, readonly) STMSWord2011Document *document;  // Returns a document object associated with this pane.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property NSInteger horizontalPercentScrolled;  // Returns or sets the horizontal scroll position as a percentage of the pane width.
@property NSInteger minimumFontSize;  // Returns or sets the minimum font size in points displayed for the specified pane.
@property (copy, readonly) STMSWord2011Pane *nextPane;  // Returns the next pane object.
@property (copy, readonly) STMSWord2011Pane *previousPane;  // Returns the previous pane object.
@property (copy, readonly) STMSWord2011SelectionObject *selection;  // Returns the selection object that represents a selected text range or the insertion point.
@property NSInteger verticalPercentScrolled;  // Returns or sets the vertical scroll position as a percentage of the pane width.
@property (copy, readonly) STMSWord2011View *view;  // Returns a view object that represents the view for the pane.

- (STMSWord2011Zoom *) getZoomZoomType:(STMSWord2011E202)zoomType;  // Returns a zoom object of the specified type for this pane.

@end

@interface STMSWord2011RangeEndnoteOptions : STMSWord2011BaseObject

@property STMSWord2011E175 endnoteLocation;  // Returns or sets the position of endnotes in a range or selection.
@property STMSWord2011E152 endnoteNumberStyle;  // Returns or sets the number style for endnotes in a range or selection.
@property STMSWord2011E173 endnoteNumberingRule;  // Returns or sets the way footnotes or endnotes are numbered after page breaks or section breaks.
@property NSInteger endnoteStartingNumber;  // Returns or sets the starting endnote number in a range or selection.


@end

@interface STMSWord2011RangeFootnoteOptions : STMSWord2011BaseObject

@property STMSWord2011E174 footnoteLocation;  // Returns or sets the position of footnotes in a range or selection.
@property STMSWord2011E152 footnoteNumberStyle;  // Returns or sets the number style for footnotes in a range or selection.
@property STMSWord2011E173 footnoteNumberingRule;  // Returns or sets the way footnotes or endnotes are numbered after page breaks or section breaks. 
@property NSInteger footnoteStartingNumber;  // Returns or sets the starting number for footnotes in a range or selection.


@end

// Represents a recently used file.
@interface STMSWord2011RecentFile : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *name;  // The name of the recently used file.
@property (copy, readonly) NSString *path;  // Returns the disk or Web path to the recent file.
@property BOOL readOnly;  // Returns or sets if changes to the document cannot be saved to the original document. 

- (STMSWord2011Document *) openRecentFile;  // Opens the recent file and returns a document object.

@end

// Represents the replace criteria for a find-and-replace operation.
@interface STMSWord2011Replacement : STMSWord2011BaseObject

@property (copy) NSString *content;  // Returns or sets the text to replace in the specified range or selection.
@property (copy, readonly) STMSWord2011Font *fontObject;  // The font object associated with this replacement object.
@property (copy, readonly) STMSWord2011Frame *frame;  // The frame object associated with this replacement object.
@property NSInteger highlight;  // Returns or sets if highlight formatting is applied to the replacement text.
@property STMSWord2011E182 languageID;  // Returns or sets the language for the replacement object
@property STMSWord2011E182 languageIDEastAsian;  // Returns or sets an east asian language for the template.
@property BOOL noProofing;  // Returns or sets if Microsoft Word finds or replaces text that the spelling and grammar checker ignores.
@property (copy) STMSWord2011ParagraphFormat *paragraphFormat;  // Returns or set the paragraph format object associated with this replacement object.
@property STMSWord2011E184 style;  // Returns or sets the Word style associated with the replacement object.


@end

// Property of View: a person who has made tracked changes in the viewed document.
@interface STMSWord2011Reviewer : STMSWord2011BaseObject

@property BOOL visible;


@end

// Represents a change marked with a revision mark.
@interface STMSWord2011Revision : STMSWord2011BaseObject

@property (copy, readonly) NSString *author;  // Returns the name of the user who made the specified tracked change. 
@property (copy, readonly) id cells;
@property (copy, readonly) NSDate *dateValue;  // The date and time that the tracked change was made.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *formatDescription;
@property (copy, readonly) STMSWord2011TextRange *movedRange;
@property (readonly) STMSWord2011E216 revisionType;  // Returns the revision type.
@property (copy, readonly) id style;
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the revision


@end

// Represents the current selection in a window or pane. A selection represents either a selected or highlighted area in the document, or it represents the insertion point if nothing in the document is selected.
@interface STMSWord2011SelectionObject : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Table *> *) tables;
- (SBElementArray<STMSWord2011Word *> *) words;
- (SBElementArray<STMSWord2011Sentence *> *) sentences;
- (SBElementArray<STMSWord2011Character *> *) characters;
- (SBElementArray<STMSWord2011Footnote *> *) footnotes;
- (SBElementArray<STMSWord2011Endnote *> *) endnotes;
- (SBElementArray<STMSWord2011WordComment *> *) WordComments;
- (SBElementArray<STMSWord2011Cell *> *) cells;
- (SBElementArray<STMSWord2011Section *> *) sections;
- (SBElementArray<STMSWord2011Paragraph *> *) paragraphs;
- (SBElementArray<STMSWord2011Field *> *) fields;
- (SBElementArray<STMSWord2011FormField *> *) formFields;
- (SBElementArray<STMSWord2011Frame *> *) frames;
- (SBElementArray<STMSWord2011Bookmark *> *) bookmarks;
- (SBElementArray<STMSWord2011HyperlinkObject *> *) hyperlinkObjects;
- (SBElementArray<STMSWord2011Column *> *) columns;
- (SBElementArray<STMSWord2011Row *> *) rows;
- (SBElementArray<STMSWord2011InlineShape *> *) inlineShapes;
- (SBElementArray<STMSWord2011Shape *> *) shapes;
- (SBElementArray<STMSWord2011MathObject *> *) mathObjects;

@property (readonly) BOOL IPAtEndOfLine;  // Returns true if the insertion point is at the end of a line that wraps to the next line. False if the selection isn't collapsed, if the insertion point isn't at the end of a line, or if the insertion point is positioned before a paragraph mark.
@property (readonly) NSInteger bookmarkId;  // Returns the number of the bookmark that encloses the beginning of the selection. The number corresponds to the position of the bookmark in the document, 1 for the first bookmark, 2 for the second one, and so on.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with the selection
@property (copy, readonly) STMSWord2011ColumnOptions *columnOptions;  // Returns a column options object for this selection.
@property BOOL columnSelectMode;  // Returns or set if column selection mode is active. When this mode is active, the letters COL appear on the status bar.
@property (copy) NSString *content;  // Returns or sets the text in the selection.
@property (copy, readonly) STMSWord2011Document *document;  // Returns the document object associated with the selection.
@property (copy, readonly) STMSWord2011EndnoteOptions *endnoteOptions;  // Returns the endnote options object for the selection.
@property BOOL extendMode;  // Returns or set if extend mode is active.
@property (copy, readonly) STMSWord2011Find *findObject;  // Returns the find object associated with the selection.
@property double fitTextWidth;  // Returns or sets the width in the current measurement units in which Microsoft Word fits the text in the current selection. 
@property (copy, readonly) STMSWord2011Font *fontObject;  // The font object associated with the selection.
@property (copy, readonly) STMSWord2011FootnoteOptions *footnoteOptions;  // Returns the footnote options object for the selection.
@property (copy) STMSWord2011TextRange *formattedText;  // Returns or sets a text range object that includes the formatted text in the selection.
@property (copy, readonly) STMSWord2011HeaderFooter *headerFooterObject;  // Returns the header footer object associated with the selection.
@property (readonly) BOOL isEndOfRowMark;  // Returns true if the selection is collapsed and is located at the end-of-row mark in a table.
@property STMSWord2011E182 languageID;  // Returns or sets the language for the selection object
@property STMSWord2011E182 languageIDEastAsian;  // Returns or sets an east asian language for the selection.
@property BOOL noProofing;  // Returns or sets if Microsoft Word finds or replaces text that the spelling and grammar checker ignores.
@property STMSWord2011E270 orientation;  // Returns or sets the orientation of text in the selection when the text direction feature is enabled.
@property (copy) STMSWord2011PageSetup *pageSetup;  // Returns or set the page setup object associated with the selection.
@property (copy) STMSWord2011ParagraphFormat *paragraphFormat;  // Returns or set the paragraph object associated with the selection.
@property (readonly) NSInteger previousBookmarkId;  // Returns the number of the last bookmark that starts before or at the same place as the selection, It returns zero if there's no corresponding bookmark.
@property (copy, readonly) STMSWord2011RangeEndnoteOptions *rangeEndnoteOptions;
@property (copy, readonly) STMSWord2011RangeFootnoteOptions *rangeFootnoteOptions;
@property (copy, readonly) STMSWord2011RowOptions *rowOptions;
@property NSInteger selectionEnd;  // Returns or sets the ending character position of the selection.
@property STMSWord2011E261 selectionFlags;  // Returns or sets properties of the selection.
@property (readonly) BOOL selectionIsActive;  // Returns if the selection is active.
@property NSInteger selectionStart;  // Returns or sets the starting character position of the selection.
@property (readonly) STMSWord2011E209 selectionType;  // Returns the selection type.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the selection
@property (copy) NSString *showWordCommentsBy;  // Returns or sets the name of the reviewer whose comments are shown in the comments pane. You can choose to show comments either by a single reviewer or by all reviewers. To view the comments by all reviewers, set this property to 'All Reviewers'.
@property BOOL showHiddenBookmarks;  // Returns or sets if hidden bookmarks are included in the elements of the selection
@property BOOL startIsActive;  // Returns or sets if the beginning of the selection is active. If the selection is not collapsed to an insertion point, either the beginning or the end of the selection is active.
@property (readonly) NSInteger storyLength;  // Returns the number of characters in the story that contains the selection
@property (readonly) STMSWord2011E160 storyType;  // Returns the story type for the selection.
@property STMSWord2011E184 style;  // Returns or sets the Word style associated with the selection object.
@property STMSWord2011E182 supplementalLanguageID;  // Returns or sets the language for the selection
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the selection

- (double) calculateSelection;  // Calculates a mathematical expression within a selection.
- (void) copyFormat NS_RETURNS_NOT_RETAINED;  // Copies the character formatting of the first character in the selected text. If a paragraph mark is selected, Word copies paragraph formatting in addition to character formatting.
- (void) createTextbox;  // Adds a default-size text box around the selection. If the selection is an insertion point, this method changes the pointer to a cross-hair pointer so that the user can draw a text box.
- (STMSWord2011TextRange *) endKeyMove:(STMSWord2011E295)move extend:(STMSWord2011E249)extend;  // Moves or extends the selection to the end of the specified unit. This method returns the new range object or missing value if an error occurred.
- (void) escapeKey;  // Cancels a mode such as extend or column select.
- (id) expandBy:(STMSWord2011E129)by;  // Expands the selection. Returns the number of characters added to the range or selection.
- (void) extendCharacter:(NSString *)character;  // Extends the selection to the next larger unit of text. The progression of selected units of text is as follows: word, sentence, paragraph, section, entire document. The selection is extended by moving the active end of the selection.
- (STMSWord2011Field *) getNextField;  // Returns the next field object.
- (STMSWord2011Field *) getPreviousField;  // Returns the previous field object.
- (NSString *) getSelectionInformationInformationType:(STMSWord2011E266)informationType;  // Returns information about the selection. 
- (NSInteger) homeKeyMove:(STMSWord2011E295)move extend:(STMSWord2011E249)extend;  // Moves or extends the selection to the beginning of the specified unit. This method returns the new range object or missing value if an error occurred.
- (void) insertCellsShiftCells:(STMSWord2011E135)shiftCells;  // Adds cells to an existing table. The number of cells inserted is equal to the number of cells in the selection.
- (void) insertColumnsPosition:(STMSWord2011EiRL)position;  // Inserts columns to the left of the column that contains the selection. If the selection isn't in a table, an error occurs. The number of columns inserted is equal to the number of columns selected.
- (void) insertFormulaFormula:(NSString *)formula numberFormat:(NSString *)numberFormat;  // Inserts an = Formula field that contains a formula at the selection. The formula replaces the selection, if the selection isn't collapsed.
- (void) insertRowsPosition:(STMSWord2011EiAb)position numberOfRows:(NSInteger)numberOfRows;  // Inserts the specified number of new rows above the row that contains the selection. If the selection isn't in a table, an error occurs.
- (STMSWord2011Revision *) nextRevisionWrap:(BOOL)wrap;  // Locates and returns the next tracked change as a revision object. The changed text becomes the current selection. Use the properties of the resulting revision object to see what type of change it is, who made it, and so forth.
- (void) pasteFormat;  // Applies formatting copied with the copy format method to the selection. If a paragraph mark was selected when the copy format method was used, Word applies paragraph formatting in addition to character formatting.
- (void) pasteObject;
- (STMSWord2011Revision *) previousRevisionWrap:(BOOL)wrap;  // Locates and returns the previous tracked change as a revision object. The changed text becomes the current selection. Use the properties of the resulting revision object to see what type of change it is, who made it, and so forth.
- (void) selectCell;  // Selects the entire cell containing the current selection. To use this method, the current selection must be contained within a single cell.
- (void) selectColumn;  // Selects the column that contains the insertion point, or selects all columns that contain the selection. If the selection isn't in a table, an error occurs.
- (void) selectCurrentAlignment;  // Extends the selection forward until text with a different paragraph alignment is encountered.
- (void) selectCurrentColor;  // Extends the selection forward until text with a different color is encountered.
- (void) selectCurrentFont;  // Extends the selection forward until text in a different font or font size is encountered.
- (void) selectCurrentIndent;  // Extends the selection forward until text with different left or right paragraph indents is encountered.
- (void) selectCurrentSpacing;  // Extends the selection forward until a paragraph with different line spacing is encountered.
- (void) selectCurrentTabs;  // Extends the selection forward until a paragraph with different tab stops is encountered.
- (void) selectRow;  // Selects the row that contains the insertion point, or selects all rows that contain the selection. If the selection isn't in a table, an error occurs.
- (void) shrinkDiscontiguousSelection;  // Deselects all but the most recently selected text when a selection contains multiple, unconnected selections.
- (void) shrinkSelection;  // Shrinks the selection to the next smaller unit of text. The progression is as follows: entire document, section, paragraph, sentence, word, insertion point.
- (void) speakText;  // Have the selected text be spoken.
- (void) splitTableInSelection;  // Inserts an empty paragraph above the first row in the selection. If the selection isn't in the first row of the table, the table is split into two tables.
- (void) typeBackspace;  // Deletes the character preceding a collapsed selection, an insertion point. If the selection isn't collapsed to an insertion point, the selection is deleted.
- (void) typeParagraph;  // Inserts a new, blank paragraph. If the selection isn't collapsed to an insertion point, it's replaced by the new paragraph.
- (void) typeTextText:(NSString *)text;  // Inserts the specified text. If the Word options property replace selection is true, the selection is replaced by the specified text. If replace selection is false, the specified text is inserted before the selection.

@end

// Represents a subdocument within a document or range.
@interface STMSWord2011Subdocument : STMSWord2011BaseObject

@property (readonly) BOOL hasFile;  // Returns true if the specified subdocument has been saved to a file.
@property (readonly) NSInteger level;  // Returns the heading level used to create the subdocument.
@property BOOL locked;  // Returns or sets if a subdocument in a master document is locked.
@property (copy, readonly) NSString *name;  // The name of the subdocument.
@property (copy, readonly) NSString *path;  // Returns the disk or Web path to the specified subdocument.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the subdocument.

- (STMSWord2011Document *) openSubdocument;  // Opens the specified subdocument. Returns a document object representing the opened object.
- (void) splitSubdocumentTextRange:(STMSWord2011TextRange *)textRange;  // Divides an existing subdocument into two subdocuments at the same level in master document view or outline view. The division is at the beginning of the specified range.

@end

// Contains information about the computer system.
@interface STMSWord2011SystemObject : STMSWord2011BaseObject

@property (readonly) STMSWord2011E118 country;  // Returns the country or region designation of the system
@property STMSWord2011E139 cursor;  // Returns or sets the state of the pointer.
@property (readonly) NSInteger horizontalResolution;  // Returns the horizontal display resolution, in pixels.
@property (copy, readonly) NSString *operatingSystem;  // Returns the name of the current operating system.
@property (copy, readonly) NSString *processorType;  // Returns the type of processor that the system is using.
@property (copy, readonly) NSString *systemVersion;  // Returns the version number of the operating system.
@property (readonly) NSInteger verticalResolution;  // Returns the vertical display resolution, in pixels.

- (NSString *) getPrivateProfileStringFileName:(NSString *)fileName section:(NSString *)section key:(NSString *)key;  // Returns a string in a settings file.
- (NSString *) getProfileStringSection:(NSString *)section key:(NSString *)key;  // Returns a string from the application's settings file.
- (void) setPrivateProfileStringFileName:(NSString *)fileName section:(NSString *)section key:(NSString *)key privateProfileString:(NSString *)privateProfileString;  // Sets a string in a settings file.
- (void) setProfileStringSection:(NSString *)section key:(NSString *)key profileString:(NSString *)profileString;  // Sets a string from the application's settings file.

@end

// Represents a single tab stop. 
@interface STMSWord2011TabStop : STMSWord2011BaseObject

@property STMSWord2011E145 alignment;  // Returns or sets a constant that represents the alignment for the specified tab stop.
@property (readonly) BOOL customTab;  // Returns if the specified tab stop is a custom tab stop.
@property (copy, readonly) STMSWord2011TabStop *nextTabStop;  // Returns the next tab stop object
@property (copy, readonly) STMSWord2011TabStop *previousTabStop;  // Returns the previous tab stop object
@property STMSWord2011E170 tabLeader;  // Returns or sets the leader for the specified tab stop object
@property double tabStopPosition;  // Returns or sets the position of a tab stop relative to the left margin.


@end

// Represents a single table of authorities in a document
@interface STMSWord2011TableOfAuthorities : STMSWord2011BaseObject

@property NSInteger category;  // Returns or sets the category of entries to be included in a table of authorities.
@property (copy) NSString *entrySeparator;  // Returns or sets the characters up to five that separate a table of authorities entry and its page number. The default is a tab character with a dotted leader.
@property BOOL includeCategoryHeader;  // Returns or sets if the category name for a group of entries appears in the table of authorities.
@property (copy) NSString *includeSequenceName;  // Returns or sets the Sequence SEQ field identifier for a table of authorities.
@property BOOL keepEntryFormatting;  // Returns or sets if formatting from table of authorities entries is applied to the entries in the specified table of authorities.
@property (copy) NSString *pageNumberSeparator;  // Returns of sets the characters up to five that separate individual page references in a table of authorities. The default is a comma and a space.
@property (copy) NSString *pageRangeSeparator;  // Returns or sets the characters up to five that separate a range of pages in a table of authorities. The default is an en dash.
@property BOOL passim;  // Returns or sets if five or more page references to the same authority are replaced with Passim.
@property (copy) NSString *separator;  // Returns or sets the characters up to five between the sequence number and the page number. A hyphen is the default character.
@property STMSWord2011E170 tabLeader;  // Returns or sets the character between entries and their page numbers in a table of authorities.
@property (copy) NSString *tableOfAuthoritiesBookmark;  // Returns or sets the name of the bookmark from which to collect table of authorities entries.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the table of authorities object.


@end

// Represents a single table of contents in a document.
@interface STMSWord2011TableOfContents : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011HeadingStyle *> *) headingStyles;

@property BOOL includePageNumbers;  // Returns or sets if page numbers are included in the table of contents.
@property NSInteger lowerHeadingLevel;  // Returns or sets the ending heading level for a table of contents.
@property BOOL rightAlignPageNumbers;  // Returns or sets if page numbers are aligned with the right margin in a table of contents.
@property STMSWord2011E170 tabLeader;  // Returns or sets the character between entries and their page numbers in a table of contents.
@property (copy) NSString *tableId;  // Returns or sets a one-letter identifier that's used to build a table of contents or table of figures from TOC fields.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the table of contents object.
@property NSInteger upperHeadingLevel;  // Returns or sets the starting heading level for a table of contents.
@property BOOL useFields;  // Returns or sets if table of contents entry fields are used to create a table of contents.
@property BOOL useHeadingStyles;  // Returns or sets if built-in heading styles are used to create a table of contents.


@end

// Represents a single table of figures in a document.
@interface STMSWord2011TableOfFigures : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011HeadingStyle *> *) headingStyles;

@property (copy) NSString *caption;  // Returns or sets the label that identifies the items to be included in a table of figures.
@property BOOL includeLabel;  // Returns or sets if the caption label and caption number are included in a table of figures.
@property BOOL includePageNumbers;  // Returns or sets if page numbers are included in the table of figures.
@property NSInteger lowerHeadingLevel;  // Returns or sets the ending heading level for a table of figures.
@property BOOL rightAlignPageNumbers;  // Returns or sets if page numbers are aligned with the right margin in a table of figures.
@property STMSWord2011E170 tabLeader;  // Returns or sets the character between entries and their page numbers in a table of figures.
@property (copy) NSString *tableId;  // Returns or sets a one-letter identifier that's used to build a table of figures from TOC fields.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the table of figures object.
@property NSInteger upperHeadingLevel;  // Returns or sets the starting heading level for a table of figures.
@property BOOL useFields;  // Returns or sets if table of figures entry fields are used to create a table of figures.
@property BOOL useHeadingStyles;  // Returns or sets if built-in heading styles are used to create a table of figures.


@end

// Represents a document template.
@interface STMSWord2011Template : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011AutoTextEntry *> *) autoTextEntries;
- (SBElementArray<STMSWord2011DocumentProperty *> *) documentProperties;
- (SBElementArray<STMSWord2011CustomDocumentProperty *> *) customDocumentProperties;
- (SBElementArray<STMSWord2011ListTemplate *> *) listTemplates;
- (SBElementArray<STMSWord2011BuildingBlock *> *) buildingBlocks;
- (SBElementArray<STMSWord2011BuildingBlockType *> *) buildingBlockTypes;

@property STMSWord2011E108 eastAsianLineBreak;  // Returns or sets the line break control level for the specified template. This property is ignored if the “east asian line break control” property is set to false. Note that “east asian line break control” is a paragraph format property.
@property (copy, readonly) NSString *fullName;  // Specifies the name of the template including the drive or Web path.
@property STMSWord2011E107 justificationMode;  // Returns or sets the character spacing adjustment for the specified template.
@property STMSWord2011E182 languageID;  // Returns or sets the language for the template object
@property STMSWord2011E182 languageIDEastAsian;  // Returns or sets an east asian language for the template.
@property (copy, readonly) NSString *name;  // Returns the name of the template.
@property (copy) NSString *noLineBreakAfter;  // Returns or sets the kinsoku characters after which Microsoft Word will not break a line.
@property (copy) NSString *noLineBreakBefore;  // Returns or sets the kinsoku characters before which Microsoft Word will not break a line.
@property BOOL noProofing;  // Returns or sets if the spelling and grammar checker should ignore documents based on this template.
@property (copy, readonly) NSString *path;  // Returns the disk or Web path to the template file.
@property BOOL saved;  // Return or set if the template hasn't changed since it was last saved. False if Microsoft Word displays a prompt to save changes when the document is closed.
@property (readonly) STMSWord2011E101 templateType;  // Returns the template type.

- (STMSWord2011BuildingBlock *) addBuildingBlockToTemplateName:(NSString *)name type:(STMSWord2011E329)type category:(NSString *)category fromLocation:(STMSWord2011TextRange *)fromLocation objectDescription:(NSString *)objectDescription insertOptions:(STMSWord2011E330)insertOptions;  // Creates a new building block entry in a template and returns a building block object that represents the new building block entry.
- (STMSWord2011AutoTextEntry *) appendToSpikeRange:(STMSWord2011TextRange *)range;  // Deletes the specified range and adds the contents of the range to the Spike which is a built-in autotext entry.
- (STMSWord2011Document *) openAsDocument;  // Opens the specified template as a document and returns a document object. Opening a template as a document allows the user to edit the contents of the template.

@end

// Represents a single text column.
@interface STMSWord2011TextColumn : STMSWord2011BaseObject

@property double spaceAfter;  // Returns or sets the amount of spacing in points after the text column.
@property double width;  // Returns or sets the width of the object.


@end

// Represents a single text form field.
@interface STMSWord2011TextInput : STMSWord2011BaseObject

@property (copy) NSString *defaultTextInput;  // Returns or sets the text that represents the default text box contents.
@property (copy, readonly) NSString *format;  // Returns the formatting string for this text input object.
@property (readonly) STMSWord2011E188 textInputFieldType;  // Returns the type of text form field.
@property (readonly) BOOL valid;  // Returns if the text input object is valid.
@property NSInteger width;  // Returns or sets the width of the object.

- (void) editTypeFormFieldType:(STMSWord2011E188)formFieldType defaultType:(NSString *)defaultType typeFormat:(NSString *)typeFormat enabled:(BOOL)enabled;  // Sets options for the specified text form field.

@end

// Represents options that control how text is retrieved from a text range object.
@interface STMSWord2011TextRetrievalMode : STMSWord2011BaseObject

@property BOOL includeFieldCodes;  // Returns or sets if the text retrieved from the specified range includes field codes.
@property BOOL includeHiddenText;  // Returns or sets if the text retrieved from the specified range includes hidden text.
@property STMSWord2011E202 viewType;  // Returns or sets the view for the text retrieval mode object.


@end

// Represents a variable stored as part of a document. Document variables are used to preserve macro settings in between macro sessions.
@interface STMSWord2011Variable : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *name;  // The name of the variable
@property (copy) NSString *variableValue;  // Returns or sets the value of a variable as a string.


@end

// Contains the view attributes, show all, field shading, table gridlines, and so on, for a window or pane.
@interface STMSWord2011View : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Reviewer *> *) reviewers;

@property BOOL browseToWindow;  // Returns or sets if lines wrap at the right edge of the window rather than at the right margin of the page.
@property BOOL conflictMode;  // Returns or sets the Conflict Mode.
@property BOOL dataMergeDataView;  // Returns or sets if data merge data is displayed instead of data merge fields in the specified window.
@property BOOL draft;  // Returns or sets if all the text in a window is displayed in the same sans-serif font with minimal formatting to speed up display.
@property NSInteger enlargeFontsLessThan;  // Returns or sets the point size below which screen fonts are automatically scaled to the larger size.
@property STMSWord2011E229 fieldShading;  // Returns or sets on-screen shading for form fields.
@property BOOL fullScreen;  // Returns or sets if the window is in full-screen view.
@property BOOL magnifier;  // Returns or sets if the pointer is displayed as a magnifying glass in print preview, indicating that the user can click to zoom in on a particular area of the page or zoom out to see an entire page or spread of pages.
@property STMSWord2011E301 revisionsMode;  // Returns or sets the way Microsoft Word shows revisions.
@property STMSWord2011E300 revisionsView;  // Returns or sets whether Microsoft Word shows revisions based on the final or the original document.
@property STMSWord2011E203 seekView;  // Returns or sets the document element displayed in print layout view.
@property BOOL showAll;  // Returns or sets if all nonprinting characters such as hidden text, tab marks, space marks, and paragraph marks are displayed. 
@property BOOL showBookmarks;  // Returns or sets if square brackets are displayed at the beginning and end of each bookmark.
@property BOOL showComments;  // Returns or sets if Microsoft Word displays comments.
@property BOOL showDrawings;  // Returns or sets if objects created with the drawing tools are displayed in print layout view.
@property BOOL showFieldCodes;  // Returns or sets if field codes are displayed.
@property BOOL showFirstLineOnly;  // Returns or sets if only the first line of body text is shown in outline view.
@property BOOL showFormat;  // Returns or set if character formatting is visible in outline view.
@property BOOL showFormatChanges;  // Returns or sets if Microsoft Word displays formatting changes.
@property BOOL showHiddenText;  // Returns or set if text formatted as hidden text is displayed. 
@property BOOL showHighlight;  // Returns or sets if highlight formatting is displayed and printed with a document.
@property BOOL showHyphens;  // Returns or sets if optional hyphens are displayed. An optional hyphen indicates where to break a word when it falls at the end of a line.
@property BOOL showInsertionsAndDeletions;  // Returns or sets if Microsoft Word displays insertions and deletions.
@property BOOL showMainTextLayer;  // Returns or sets if the text in the specified document is visible when the header and footer areas are displayed.
@property BOOL showObjectAnchors;  // Returns or set if object anchors are displayed next to items that can be positioned in print layout view.
@property BOOL showOptionalBreaks;  // Returns or sets if Microsoft Word displays optional line breaks.
@property BOOL showOtherAuthors;  // Returns or sets whether Microsoft Word shows other authors who are also editing the document.
@property BOOL showParagraphs;  // Returns or sets if paragraph marks are displayed. 
@property BOOL showPicturePlaceHolders;  // Returns or sets if blank boxes are displayed as placeholders for pictures.
@property BOOL showRevisionsAndComments;  // Returns or sets if Microsoft Word displays revisions and comments.
@property BOOL showSpaces;  // Returns or sets if space characters are displayed.
@property BOOL showTabs;  // Returns or sets if tab characters are displayed.
@property BOOL showTextBoundaries;  // Returns or sets if dotted lines are displayed around page margins, text columns, objects, and frames in print layout view. 
@property STMSWord2011E204 splitSpecial;  // Returns or sets the active window pane.
@property BOOL tableGridlines;  // Returns or sets if table gridlines are displayed. 
@property STMSWord2011E202 viewType;  // Returns or sets the view type.
@property BOOL wrapToWindow;  // Returns or sets if lines wrap at the right edge of the document window rather than at the right margin or the right column boundary.
@property (copy, readonly) STMSWord2011Zoom *zoom;  // Returns the zoom object associated with this view object.

- (void) collapseOutlineTextRange:(STMSWord2011TextRange *)textRange;  // Collapses the text under the selection or the specified range by one heading level.
- (void) expandOutlineTextRange:(STMSWord2011TextRange *)textRange;  // Expands the text under the selection or the specified range by one heading level.
- (void) nextHeaderFooter;  // If the selection is in a header, this method moves to the next header within the current section or to the first header in the following section. If the selection is in a footer, this method moves to the next footer.
- (void) previousHeaderFooter;  // If the selection is in a header, this method moves to the previous header within the current section or to the last header in the previous section. If the selection is in a footer, this method moves to the previous footer.
- (void) showAllHeadings;  // Toggles between showing all text, headings and body text, and showing only headings.
- (void) showHeadingLevel:(NSInteger)level;  // Shows all headings up to the specified heading level and hides subordinate headings and body text. This method generates an error if the view isn't outline view or master document view.

@end

// Contains document-level attributes used by Microsoft Word when you save a document as a Web page or open a Web page.
@interface STMSWord2011WebOptions : STMSWord2011BaseObject

@property BOOL allowPng;  // Returns or sets if PNG, Portable Network Graphics, is allowed as an image format when you save a document as a Web page.
@property (copy, readonly) NSString *docKeywords;  // Returns the keywords associated with a document.
@property (copy, readonly) NSString *docTitle;  // Returns the title for a Web document.
@property STMSWord2011MtEn encoding;  // Returns or sets the document encoding, code page or character set, to be used by the Web browser when you view the saved document
@property NSInteger pixelsPerInch;  // Returns or sets the density, pixels per inch, of graphics images and table cells on a Web page. The range of settings is usually from 19 to 480, and common settings for popular screen sizes are 72, 96, and 120.
@property BOOL roundTripHTML;  // Returns or sets if whether to save an HTML document with information that is specific to Microsoft Word. Setting this property to true allows you to preserve all Word settings in an HTML document.
@property STMSWord2011MSsz screenSize;  // Returns or sets the ideal minimum screen size, width by height, in pixels, that you should use when viewing the saved document in a Web browser.
@property BOOL useLongFileNames;  // Returns or sets if long file names are used when you save the document as a Web page.

- (void) useDefaultFolderSuffix;  // Sets the folder suffix for the specified document to the default suffix for the language support you have selected or installed.

@end

// Represents a window. Many document characteristics, such as scroll bars and rulers, are actually properties of the window.
@interface STMSWord2011Window : STMSWord2011BasicWindow

- (SBElementArray<STMSWord2011Pane *> *) panes;

@property STMSWord2011E103 IMEMode;  // Returns or sets the default start-up mode for the Japanese Input Method Editor, IME
@property (readonly) BOOL active;  // Returns if the window is active.
@property (copy, readonly) STMSWord2011Pane *activePane;  // Returns a pane object that represents the active pane for the window 
@property (copy) NSString *caption;  // Returns or sets the caption text for the document window.
@property BOOL displayHorizontalScrollBar;  // Returns or sets if the horizontal scroll bar is visible
@property BOOL displayRulers;  // Returns or sets if rulers are displayed for the window
@property BOOL displayScreenTips;  // Returns or set if comments, footnotes, endnotes, and hyperlinks are displayed as tips.  Text marked as having comments is highlighted.
@property BOOL displayVerticalRuler;  // Returns or sets if vertical rulers are displayed for the window
@property BOOL displayVerticalScrollBar;  // Returns or sets if the vertical scroll bar is visible
@property (copy, readonly) STMSWord2011Document *document;  // Returns a document object associated with the pane. 
@property BOOL documentMap;  // Returns or sets if the document map is visible.
@property NSInteger documentMapPercentWidth;  // Returns or sets the width of the document map as a percentage of the width of the specified window.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property NSInteger height;  // Returns or sets the height of the object.
@property NSInteger horizontalPercentScrolled;  // Returns or sets the horizontal scroll position as a percentage of the document width.
@property NSInteger leftPosition;  // Returns or sets the horizontal position of the object.
@property (copy, readonly) STMSWord2011Window *nextWindow;  // Returns the next window object
@property (copy, readonly) STMSWord2011Window *previousWindow;  // Returns the previous window object
@property (copy, readonly) STMSWord2011SelectionObject *selection;  // Returns the selection object that represents a selected text range or the insertion point.
@property NSInteger splitVertical;  // Returns or sets the vertical split percentage for the specified window. To remove the split, set this property to zero or set the split window property to false.
@property BOOL splitWindow;  // Returns or sets if the window is split into multiple panes. When setting this to true the window is split into two equal-sized window panes.
@property double styleAreaWidth;  // Returns or sets the width of the style area in points.
@property NSInteger top;  // Returns or sets the vertical position of the object.
@property NSInteger verticalPercentScrolled;  // Returns or sets the vertical scroll position as a percentage of the document width.
@property (copy, readonly) STMSWord2011View *view;  // Returns a view object that represents the view for the window.
@property NSInteger width;  // Returns or sets the width of the object.
@property (readonly) NSInteger windowNumber;  // Returns the window number of the document displayed in the specified window. For example, if the caption of the window is Sales.doc:2, this property returns the number 2.
@property STMSWord2011E198 windowState;  // Returns or sets the state of the window.
@property (readonly) STMSWord2011E201 windowType;  // Returns the window type.

- (void) toggleShowAllReviewers;  // Toggles whether or not all reviewers are shown in this window.

@end

// Contains magnification options, for example, the zoom percentage for a window or pane.
@interface STMSWord2011Zoom : STMSWord2011BaseObject

@property NSInteger pageColumns;  // Returns or sets the number of pages to be displayed side by side on-screen at the same time in print layout view or print preview.
@property STMSWord2011E205 pageFit;  // Returns or sets the view magnification of a window so that either the entire page is visible or the entire width of the page is visible.
@property NSInteger pageRows;  // Returns or sets the number of pages to be displayed one above the other on-screen at the same time in print layout view or print preview. 
@property NSInteger percentage;  // Returns or sets the magnification for a window as a percentage.


@end



/*
 * Drawing Suite
 */

@interface STMSWord2011Adjustment : STMSWord2011BaseObject

@property double adjustment_value;  // Returns or sets a floating point adjustment for a shape.


@end

// Contains properties and methods that apply to line callouts.
@interface STMSWord2011CalloutFormat : STMSWord2011BaseObject

@property BOOL accent;  // Returns or sets if a vertical accent bar separates the callout text from the callout line.
@property STMSWord2011MCAt angle;  // Returns or sets the angle of the callout line. If the callout line contains more than one line segment, this property returns or sets the angle of the segment that is farthest from the callout text box.
@property BOOL autoAttach;  // Returns or sets if the place where the callout line attaches to the callout text box changes depending on whether the origin of the callout line, where the callout points to, is to the left or right of the callout text box.
@property (readonly) BOOL autoLength;  // Returns if the length of the callout line is automatically set. Use the automatic length method to set this property to true, and use the custom length method to set this property to false.
@property (readonly) double calloutFormatLength;  // When the AutoLength property of the specified callout is set to False, the Length property returns the length in points of the first segment of the callout line, the segment attached to the text callout box.
@property BOOL calloutHasBorder;  // Returns or sets whether the text in the specified callout is surrounded by a border.
@property STMSWord2011MCot calloutType;  // Returns or sets the callout type.
@property (readonly) double drop;  // For callouts with an explicitly set drop value, this property returns the vertical distance in points from the edge of the text bounding box to the place where the callout line attaches to the text box.
@property (readonly) STMSWord2011MCDt dropType;  // Returns a value that indicates where the callout line attaches to the callout text box.
@property double gap;  // Returns or sets the horizontal distance in points between the end of the callout line and the text bounding box.


@end

// Represents fill formatting for a shape. A shape can have a solid, gradient, texture, pattern, picture, or semi-transparent fill.
@interface STMSWord2011FillFormat : STMSWord2011BaseObject

@property (copy) NSColor *backColor;  // Returns or sets a RGB color that represents the background color for the specified fill or patterned line.
@property STMSWord2011MCoI backColorThemeIndex;  // Returns or sets the specified fill background color.
@property (readonly) STMSWord2011MFdT fillType;  // Returns the shape fill format type.
@property (copy) NSColor *foreColor;  // Returns or sets a RGB color that represents the foreground color for the fill, line, or shadow.
@property STMSWord2011MCoI foreColorThemeIndex;  // Returns or sets the specified foreground fill or solid color.
@property (readonly) STMSWord2011MGCt gradientColorType;  // Returns the gradient color type for the specified fill.
@property (readonly) double gradientDegree;  // Returns a value that indicates how dark or light a one-color gradient fill is. A value of zero means that black is mixed in with the shape's foreground color to form the gradient; a value of 1 means that white is mixed in. Values between 1 and zero blend.
@property (readonly) STMSWord2011MGdS gradientStyle;  // Returns the gradient style for the specified fill.
@property (readonly) NSInteger gradientVariant;  // Returns the gradient variant for the specified fill as an integer value from 1 to 4 for most gradient fills. If the gradient style is from center gradient, this property returns either 1 or 2.
@property (readonly) STMSWord2011PpTy pattern;  // Returns the value that represents the pattern applied to the specified fill or line.
@property (readonly) STMSWord2011MPGb presetGradientType;  // Returns the preset gradient type for the specified fill.
@property (readonly) STMSWord2011MPzT presetTexture;  // Returns the preset texture for the specified fill.
@property (copy, readonly) NSString *textureName;  // Returns the name of the custom texture file for the specified fill.
@property (readonly) STMSWord2011MxtT textureType;  // Returns the texture type for the specified fill.
@property double transparency;  // Returns or sets the degree of transparency of the specified fill, shadow, or line as a value between 0.0, opaque, and 1.0, clear.
@property BOOL visible;  // Returns or sets if the specified object, or the formatting applied to it, is visible.


@end

// Represents the glow formatting for a shape or range of shapes.
@interface STMSWord2011GlowFormat : STMSWord2011BaseObject

@property (copy) NSColor *color;  // Returns or sets the color for the specified glow format.
@property STMSWord2011MCoI colorThemeIndex;  // Returns or sets the color for the specified glow format.
@property double radius;  // Returns or sets the length of the radius for the specified glow format.


@end

// Represents horizontal line formatting.
@interface STMSWord2011HorizontalLineFormat : STMSWord2011BaseObject

@property STMSWord2011E280 alignment;  // Returns or sets a constant that represents the alignment for the specified horizontal line.
@property BOOL noShade;  // Returns or sets if Microsoft Word draws the specified horizontal line without 3-D shading.
@property double percentWidth;  // Returns or sets the length of the specified horizontal line expressed as a percentage of the window width.
@property STMSWord2011E281 widthType;  // Returns or sets the width type for the specified horizontal line format object.


@end

// Represents a graphic object in the text layer of a document.
@interface STMSWord2011InlineShape : STMSWord2011BaseObject

@property (copy) NSString *alternativeText;  // Returns or sets the alternative text associated with a shape in a Web page.
@property (readonly) NSInteger anchorID;  // Returns the anchor id for the specified shape.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with the inline shape
@property (readonly) NSInteger editID;  // Returns the edit id for the specified shape.
@property (copy, readonly) STMSWord2011Field *field;  // Returns a field object that represents the field associated with the specified inline shape.
@property (copy, readonly) STMSWord2011FillFormat *fillFormat;  // Returns the fill format object associated with this inline shape object.
@property (copy, readonly) STMSWord2011GlowFormat *glowFormat;  // Returns the formatting properties for a glow effect.
@property double height;  // Returns or sets the height of the object.
@property (copy, readonly) STMSWord2011HorizontalLineFormat *horizontalLineFormat;  // Returns the horizontal line format object associated with this inline shape object.
@property (copy, readonly) STMSWord2011HyperlinkObject *hyperlink;  // Returns the hyperlink object associated with this inline shape object.
@property double inlineShapeScaleHeight;  // Returns or sets the height of the specified inline shape relative to its original size. 
@property double inlineShapeScaleWidth;  // Returns or sets the width of the specified inline shape relative to its original size. 
@property (readonly) STMSWord2011E259 inlineShapeType;  // The type of this inline shape.
@property BOOL isInlinePlaceholder;  // Returns true if a shape is a placeholder.
@property (readonly) BOOL isPictureBullet;  // Returns true if an InlineShape object is a picture bullet.
@property (copy, readonly) STMSWord2011LineFormat *lineFormat;  // Returns the line format object associated with this inline shape object.
@property (copy, readonly) STMSWord2011LinkFormat *linkFormat;  // Returns the link format object associated with this inline shape object.
@property BOOL lockAspectRatio;  // Returns or set if the specified shape retains its original proportions when you resize it.
@property (copy, readonly) STMSWord2011PictureFormat *pictureFormat;  // Returns the picture format object associated with this inline shape object.
@property (copy, readonly) STMSWord2011ReflectionFormat *reflectionFormat;  // Returns the formatting properties for a reflection effect.
@property (copy, readonly) STMSWord2011ShadowFormat *shadow;  // Returns the shadow format object associated with this shape object.
@property (copy, readonly) STMSWord2011SoftEdgeFormat *softEdgeFormat;  // Returns the formatting properties for a soft edge effect.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the text for the inline shape.
@property double width;  // Returns or sets the width of the object.
@property (copy, readonly) STMSWord2011WordArtFormat *wordArtFormat;  // Returns the word art format object associated with the word art shape object.

- (STMSWord2011Shape *) convertToShape;  // Converts an inline shape to a free-floating shape.
- (STMSWord2011Border *) getBorderWhichBorder:(STMSWord2011E122)whichBorder;  // Returns the specified border object.
- (void) reset;  // Removes changes that were made to an inline shape.

@end

// Represents a horizontal line object in the text layer of a document.
@interface STMSWord2011InlineHorizontalLine : STMSWord2011InlineShape

@property (copy, readonly) NSString *fileName;  // The file name that contains the picture of the horizontal line.


@end

// Represents a picture bullet object in the text layer of a document.
@interface STMSWord2011InlinePictureBullet : STMSWord2011InlineShape

@property (copy, readonly) NSString *fileName;  // The file name that contains the picture of the picture bullet.


@end

// Represents a picture object in the text layer of a document.
@interface STMSWord2011InlinePicture : STMSWord2011InlineShape

@property (copy, readonly) NSString *fileName;  // The file name that contains the picture.
@property (readonly) BOOL linkToFile;  // Returns true if the picture shape is linked to the file.
@property (copy, readonly) STMSWord2011PictureFormat *pictureFormat;  // Returns the picture format object associated with this inline picture object.
@property (readonly) BOOL saveWithDocument;  // Specifies if the picture should be saved with the document.


@end

// Represents line and arrowhead formatting. For a line, the line format object contains formatting information for the line itself; for a shape with a border, this object contains formatting information for the shape's border.
@interface STMSWord2011LineFormat : STMSWord2011BaseObject

@property (copy) NSColor *backColor;  // Returns or sets a RGB color that represents the background color for the specified fill or patterned line.
@property STMSWord2011MCoI backColorThemeIndex;  // Returns or sets the background color for a patterned line.
@property STMSWord2011MAhL beginArrowheadLength;  // Returns or sets the length of the arrowhead at the beginning of the specified line.
@property STMSWord2011MAhS beginArrowheadStyle;  // Returns or sets the style of the arrowhead at the beginning of the specified line.
@property STMSWord2011MAhW beginArrowheadWidth;  // Returns or sets the width of the arrowhead at the beginning of the specified line.
@property STMSWord2011MlDs dashStyle;  // Returns or sets the dash style for the specified line.
@property STMSWord2011MAhL endArrowheadLength;  // Returns or sets the length of the arrowhead at the end of the specified line.
@property STMSWord2011MAhS endArrowheadStyle;  // Returns or sets the style of the arrowhead at the end of the specified line.
@property STMSWord2011MAhW endArrowheadWidth;  // Returns or sets the width of the arrowhead at the end of the specified line.
@property (copy) NSColor *foreColor;  // Returns or sets a RGB color that represents the foreground color for the fill, line, or shadow.
@property STMSWord2011MCoI foreColorThemeIndex;  // Returns or sets the foreground color for the line.
@property STMSWord2011MLnS lineStyle;  // Returns or sets the line format style.
@property STMSWord2011PpTy pattern;  // Returns or sets a value that represents the pattern applied to the specified fill or line.
@property double transparency;  // Returns or sets the degree of transparency of the specified fill, shadow, or line as a value between 0.0, opaque and 1.0, clear.
@property BOOL visible;  // Returns or sets if the specified object, or the formatting applied to it, is visible.
@property double weight;  // Returns or sets the thickness of the specified line in points.


@end

// Represents a Microsoft Office theme.
@interface STMSWord2011OfficeTheme : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011ThemeColorScheme *themeColorScheme;  // Returns the color scheme of a Microsoft Office theme.
@property (copy, readonly) STMSWord2011ThemeEffectScheme *themeEffectScheme;  // Returns the effects scheme of a Microsoft Office theme.
@property (copy, readonly) STMSWord2011ThemeFontScheme *themeFontScheme;  // Returns the font scheme of a Microsoft Office theme.


@end

// Contains properties and methods that apply to pictures. 
@interface STMSWord2011PictureFormat : STMSWord2011BaseObject

@property double brightness;  // Returns or sets the brightness of the specified picture . The value for this property must be a number from 0.0, dimmest to 1.0, brightest.
@property double contrast;  // Returns or sets the contrast for the specified picture. The value for this property must be a number from 0.0, the least contrast to 1.0, the greatest contrast.
@property double cropBottom;  // Returns or sets the number of points that are cropped off the bottom of the specified picture.
@property double cropLeft;  // Returns or sets the number of points that are cropped off the left side of the specified picture.
@property double cropRight;  // Returns or sets the number of points that are cropped off the right side of the specified picture.
@property double cropTop;  // Returns or sets the number of points that are cropped off the top of the specified picture.
@property (copy) NSColor *transparencyColor;  // Returns or sets the transparent color for the specified picture as a RGB color. For this property to take effect, the transparent background property must be set to true.
@property BOOL transparentBackground;  // Returns or sets if the parts of the picture that are defined with a transparent color actually appear transparent.


@end

// Represents the reflection effect in Office graphics.
@interface STMSWord2011ReflectionFormat : STMSWord2011BaseObject

@property STMSWord2011MRfT reflectionType;  // Returns or sets the type of the reflection format object.


@end

// Represents shadow formatting for a shape.
@interface STMSWord2011ShadowFormat : STMSWord2011BaseObject

@property double blur;  // Returns or sets the blur, in points, of the specified shadow.
@property (copy) NSColor *foreColor;  // Returns or sets a RGB color that represents the foreground color for the fill, line, or shadow.
@property STMSWord2011MCoI foreColorThemeIndex;  // Returns or sets the foreground color for the shadow format.
@property BOOL obscured;  // Returns or sets if the shadow of the specified shape appears filled in and is obscured by the shape, even if the shape has no fill. If false the shadow has no fill and the outline of the shadow is visible through the shape if the shape has no fill.
@property double offsetX;  // Returns or sets the horizontal offset in points of the shadow from the specified shape. A positive value offsets the shadow to the right of the shape; a negative value offsets it to the left.
@property double offsetY;  // Returns or sets the vertical offset in points of the shadow from the specified shape. A positive value offsets the shadow below the shape; a negative value offsets it above the shape.
@property BOOL rotateWithShape;  // Returns or sets whether to rotate the shadow when rotating the shape.
@property STMSWord2011MSSt shadowStyle;  // Returns or sets the style of shadow formatting to apply to a shape.
@property STMSWord2011MSdT shadowType;  // Returns or sets the shape shadow type.
@property double size;  // Returns or sets the width of the shadow.
@property double transparency;  // Returns or sets the degree of transparency of the specified fill, shadow, or line as a value between 0.0, opaque and 1.0, clear.
@property BOOL visible;  // Returns or sets if the specified object, or the formatting applied to it, is visible.


@end

// Represents an object in the drawing layer.
@interface STMSWord2011Shape : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Adjustment *> *) adjustments;

@property (copy, readonly) STMSWord2011TextRange *anchor;  // Returns a text range object that represents the anchoring range for the specified shape.
@property (readonly) NSInteger anchorID;  // Returns the anchor id for the specified shape.
@property STMSWord2011MAsT autoShapeType;  // Returns or sets the shape type for the specified shape object, which must represent an autoshape.
@property (readonly) BOOL child;  // True if the shape is a child shape.
@property (readonly) NSInteger editID;  // Returns the edit id for the specified shape.
@property (copy, readonly) STMSWord2011FillFormat *fillFormat;  // Return the fill format object associated with this shape object.
@property (copy, readonly) STMSWord2011GlowFormat *glowFormat;  // Returns the formatting properties for a glow effect.
@property BOOL hasChart;  // True if the specified shape has a chart.
@property double height;  // Returns or sets the height of the object.
@property (readonly) BOOL horizontalFlip;  // Returns true if the shape has been flipped horizontally. 
@property (copy, readonly) STMSWord2011HyperlinkObject *hyperlink;  // Returns the hyperlink object associated with this shape object.
@property BOOL isPlaceholder;  // Returns true if a shape is a placeholder.
@property double leftPosition;  // Returns or sets the horizontal position of the object.
@property (copy, readonly) STMSWord2011LineFormat *lineFormat;  // Returns the line format object associated with this shape object.
@property (copy, readonly) STMSWord2011LinkFormat *linkFormat;  // Returns the link format object associated with this shape object.
@property BOOL lockAnchor;  // Returns or sets if the specified shape object's anchor is locked to the anchoring range. When a shape has a locked anchor, you cannot move the shape's anchor by dragging it, the anchor doesn't move as the shape is moved.
@property BOOL lockAspectRatio;  // Returns or sets if the specified shape retains its original proportions when you resize it. If false, you can change the height and width of the shape independently of one another when you resize it.
@property (copy) NSString *name;  // Returns or sets the name of this shape object.
@property (copy, readonly) STMSWord2011ReflectionFormat *reflectionFormat;  // Returns the formatting properties for a reflection effect.
@property STMSWord2011E236 relativeHorizontalPosition;  // Returns or sets if the horizontal position of the shape is relative.
@property STMSWord2011E237 relativeVerticalPosition;  // Returns or sets if the vertical position of the shape is relative.
@property double rotation;  // Returns or sets the number of degrees the specified shape is rotated around the z-axis. A positive value indicates clockwise rotation; a negative value indicates counterclockwise rotation.
@property (copy, readonly) STMSWord2011ShadowFormat *shadow;  // Returns the shadow format object associated with this shape object.
@property (readonly) STMSWord2011MShp shapeType;  // Returns the shape type.
@property (copy, readonly) STMSWord2011SoftEdgeFormat *softEdgeFormat;  // Returns the formatting properties for a soft edge effect.
@property (copy, readonly) STMSWord2011TextFrame *textFrame;  // Returns the text frame object associated with this shape object.
@property (copy, readonly) STMSWord2011ThreeDFormat *threeDFormat;  // Returns the threeD format object associated with this shape object.
@property double top;  // Returns or sets the vertical position of the object.
@property (readonly) BOOL verticalFlip;  // Returns true if the shape has been flipped vertically.
@property BOOL visible;  // Returns or sets if the shape object is visible.
@property double width;  // Returns or sets the width of the object.
@property (copy, readonly) STMSWord2011WrapFormat *wrapFormat;  // Returns the wrap format object associated with this shape object.
@property (readonly) NSInteger zOrderPosition;  // Returns the position of the specified shape in the z-order.

- (void) apply;  // Applies to the specified shape formatting that has been copied using the pick up method.
- (STMSWord2011Frame *) convertToFrame;  // Converts the specified shape to a frame. Returns a frame object that represents the new frame.
- (STMSWord2011InlineShape *) convertToInlineShape;  // Converts the specified shape in the drawing layer of a document to an inline shape in the text layer. You can convert only picture shapes.
- (void) flipFlipCommand:(STMSWord2011MFlC)flipCommand;  // Flips a shape horizontally or vertically.
- (void) pickUp;  // Copies the formatting of the specified shape. Use the apply method to apply the copied formatting to another shape.
- (void) rerouteConnections;  // Reroutes the connections between shapes.
- (void) setShapesDefaultProperties;  // Applies the formatting of the specified shape to a default shape for that document. New shapes inherit many of their attributes from the default shape.
- (void) zOrderZOrderCommand:(STMSWord2011MZoC)zOrderCommand;  // Moves the specified shape in front of or behind other shapes.

@end

// Represents an callout object in the drawing layer.
@interface STMSWord2011Callout : STMSWord2011Shape

@property (copy, readonly) STMSWord2011CalloutFormat *calloutFormat;  // Returns the callout format object associated with this callout shape object.
@property (readonly) STMSWord2011MCot calloutType;  // Return the type of this callout


@end

// The line shape uses begin line X, begin line Y, end line X, and end line Y when created
@interface STMSWord2011LineShape : STMSWord2011Shape

@property double beginLineX;  // Returns or sets the starting X coordinate for the line shape.
@property double beginLineY;  // Returns or sets the starting Y coordinate for the line shape.
@property double endLineX;  // Returns or sets the ending X coordinate for the line shape.
@property double endLineY;  // Returns or sets the ending Y coordinate for the line shape.


@end

// Represents an picture object in the drawing layer.
@interface STMSWord2011Picture : STMSWord2011Shape

@property (copy, readonly) NSString *fileName;  // The name of the file containing the picture.
@property (readonly) BOOL linkToFile;  // Returns true if the picture shape is linked to the file.
@property (copy, readonly) STMSWord2011PictureFormat *pictureFormat;  // Returns the picture format object associated with this picture shape.
@property (readonly) BOOL saveWithDocument;  // Specifies if the picture should be saved with the document.

- (void) scaleHeightFactor:(double)factor relativeToOriginalSize:(BOOL)relativeToOriginalSize scale:(STMSWord2011MSFr)scale;  // Scales the height of the picture shape by a specified factor.
- (void) scaleWidthFactor:(double)factor relativeToOriginalSize:(BOOL)relativeToOriginalSize scale:(STMSWord2011MSFr)scale;  // Scales the width of the shape by a specified factor.

@end

// Represents the soft edge formatting for a shape or range of shapes.
@interface STMSWord2011SoftEdgeFormat : STMSWord2011BaseObject

@property STMSWord2011MSET softEdgeType;  // Returns or sets the type soft edge format object.


@end

// Represents a standard horizontal line object in the text layer of a document.
@interface STMSWord2011StandardInlineHorizontalLine : STMSWord2011InlineShape


@end

// Represents an text box object in the drawing layer.
@interface STMSWord2011TextBox : STMSWord2011Shape

@property (readonly) STMSWord2011TxOr textOrientation;  // Returns the orientation of the text inside the text shape.


@end

// Represents the text frame in a shape object. Contains the text in the text frame as well as the properties that control the margins and orientation of the text frame.
@interface STMSWord2011TextFrame : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011TextRange *containingRange;  // Returns a text range object that represents the entire story in a series of shapes with linked text frames that the specified text frame belongs to.
@property (readonly) BOOL hasText;  // Returns true if the specified shape has text associated with it.
@property double marginBottom;  // Returns or sets the distance in points between the bottom of the text frame and the bottom of the inscribed rectangle of the shape that contains the text.
@property double marginLeft;  // Returns or sets the distance in points between the left edge of the text frame and the left edge of the inscribed rectangle of the shape that contains the text.
@property double marginRight;  // Returns or sets the distance in points between the right edge of the text frame and the right edge of the inscribed rectangle of the shape that contains the text.
@property double marginTop;  // Returns or sets the distance in points between the top of the text frame and the top of the inscribed rectangle of the shape that contains the text.
@property (copy) STMSWord2011TextFrame *nextTextframe;  // Returns or sets the next text frame object.
@property STMSWord2011TxOr orientation;  // Returns or sets the orientation of the text inside the frame.
@property (readonly) BOOL overflowing;  // Returns if the text inside the specified text frame doesn't all fit within the frame.
@property (copy) STMSWord2011TextFrame *previousTextframe;  // Returns or sets the previous text frame object.
@property (copy, readonly) STMSWord2011TextRange *textRange;  // Returns a text range object that represents the text range for this text frame.
@property BOOL textwrappingAllowed;  // Allow textwrapping of overlay objects.

- (void) breakForwardLink;  // Breaks the forward link for the specified text frame, if such a link exists.
- (BOOL) validLinkTargetTargetTextframe:(STMSWord2011TextFrame *)targetTextframe;  // Determines whether the text frame of one shape can be linked to the text frame of another shape. Returns false if target textframe already contains text or is already linked, or if the shape doesn't support attached text.

@end

// Represents the color scheme of a Microsoft Office 2007 theme.
@interface STMSWord2011ThemeColorScheme : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011ThemeColor *> *) themeColors;

- (NSColor *) getCustomColorName:(NSString *)name;  // Returns the custom color for the specified Microsoft Office theme.
- (void) loadThemeColorSchemeFileName:(NSString *)fileName;  // Loads the color scheme of a Microsoft Office theme from a file
- (void) saveThemeColorSchemeFileName:(NSString *)fileName;  // Saves the color scheme of a Microsoft Office theme to a file.

@end

// Represents a color in the color scheme of a Microsoft Office 2007 theme.
@interface STMSWord2011ThemeColor : STMSWord2011BaseObject

@property (copy) NSColor *RGB;  // Returns or sets a value of a color in the color scheme of a Microsoft Office theme.
@property (readonly) STMSWord2011MCSI themeColorSchemeIndex;  // Returns the index value a color scheme of a Microsoft Office theme.


@end

// Represents the effect scheme of a Microsoft Office theme.
@interface STMSWord2011ThemeEffectScheme : STMSWord2011BaseObject

- (void) loadThemeEffectSchemeFileName:(NSString *)fileName;  // Loads the effects scheme of a Microsoft Office theme from a file

@end

// Represents the font scheme of a Microsoft Office theme.
@interface STMSWord2011ThemeFontScheme : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011MinorThemeFont *> *) minorThemeFonts;
- (SBElementArray<STMSWord2011MajorThemeFont *> *) majorThemeFonts;

- (void) loadThemeFontSchemeFileName:(NSString *)fileName;  // Loads the font scheme of a Microsoft Office theme from a file.
- (void) saveThemeFontSchemeFileName:(NSString *)fileName;  // Saves the font scheme of a Microsoft Office theme to a file.

@end

// Represents a container for the font schemes of a Microsoft Office 2007 theme.
@interface STMSWord2011ThemeFont : STMSWord2011BaseObject

@property (copy) NSString *name;  // Returns or sets a value specifying the font to use for a selection.


@end

// Represents a container for the font schemes of a Microsoft Office 2007 theme.
@interface STMSWord2011MajorThemeFont : STMSWord2011ThemeFont


@end

// Represents a container for the font schemes of a Microsoft Office 2007 theme.
@interface STMSWord2011MinorThemeFont : STMSWord2011ThemeFont


@end

// Represents a collection of major and minor fonts in the font scheme of a Microsoft Office 2007 theme.
@interface STMSWord2011ThemeFonts : STMSWord2011BaseObject


@end

// Represents a shape's three-dimensional formatting.
@interface STMSWord2011ThreeDFormat : STMSWord2011BaseObject

@property double ZDistance;  // Returns or sets a Single that represents the distance from the center of an object or text.
@property double bevelBottomDepth;  // Returns or sets the depth/height of the bottom bevel.
@property double bevelBottomInset;  // Returns or sets the inset size/width for the bottom bevel.
@property STMSWord2011MBlT bevelBottomType;  // Returns or sets the bevel type for the bottom bevel.
@property double bevelTopDepth;  // Returns or sets the depth/height of the top bevel.
@property double bevelTopInset;  // Returns or sets the inset size/width for the top bevel.
@property STMSWord2011MBlT bevelTopType;  // Returns or sets the bevel type for the top bevel.
@property (copy) NSColor *contourColor;  // Returns or sets the color of the contour of an object or text.
@property STMSWord2011MCoI contourColorThemeIndex;  // Returns or sets the color for the specified contour.
@property double contourWidth;  // Returns or sets the width of the contour of an object or text.
@property double depth;  // Returns or sets the depth of the shape's extrusion.
@property (copy) NSColor *extrusionColor;  // Returns or sets a RGB color that represents the color of the shape's extrusion.
@property STMSWord2011MCoI extrusionColorThemeIndex;  // Returns or sets the color for the specified extrusion.
@property STMSWord2011MExC extrusionColorType;  // Returns or sets a value that indicates what will determine the extrusion color.
@property double fieldOfView;  // Returns or sets the amount of perspective for an object or text.
@property double lightAngle;  // Returns or sets the angle of the lighting.
@property BOOL perspective;  // Returns or sets if the extrusion appears in perspective that is, if the walls of the extrusion narrow toward a vanishing point. If false, the extrusion is a parallel, or orthographic, projection that is, if the walls don't narrow toward a vanishing point.
@property STMSWord2011MPzC presetCamera;  // Returns a constant that represents the camera preset.
@property STMSWord2011MExD presetExtrusionDirection;  // Returns or sets the direction taken by the extrusion's sweep path leading away from the extruded shape, the front face of the extrusion.
@property STMSWord2011MPLd presetLightingDirection;  // Returns or sets the position of the light source relative to the extrusion.
@property STMSWord2011MLtT presetLightingRig;  // Returns a constant that represents the lighting preset.
@property STMSWord2011MlSf presetLightingSoftness;  // Returns or sets the intensity of the extrusion lighting.
@property STMSWord2011MPMt presetMaterial;  // Returns or sets the extrusion surface material.
@property STMSWord2011M3DF presetThreeDFormat;  // Returns or sets the preset extrusion format. Each preset extrusion format contains a set of preset values for the various properties of the extrusion.
@property BOOL projectText;  // Returns or sets whether text on a shape rotates with shape.
@property double rotationX;  // Returns or sets the rotation of the extruded shape around the x-axis in degrees. A positive value indicates upward rotation; a negative value indicates downward rotation.
@property double rotationY;  // Returns or sets the rotation of the extruded shape around the y-axis, in degrees. A positive value indicates rotation to the left; a negative value indicates rotation to the right.
@property double rotationZ;  // Returns or sets the rotation of the extruded shape around the z-axis, in degrees. A positive value indicates clockwise rotation; a negative value indicates anti-clockwise rotation.
@property BOOL visible;  // Returns or sets if the specified object, or the formatting applied to it, is visible.


@end

// Contains properties and methods that apply to WordArt objects.
@interface STMSWord2011WordArtFormat : STMSWord2011BaseObject

@property STMSWord2011MTxA alignment;  // Returns or sets a constant that represents the alignment for the specified text effect.
@property BOOL bold;  // Returns or sets if the text of the word art shape is formatted as bold.
@property (copy) NSString *fontName;  // Returns or sets the font name of the font used by this word art shape.
@property double fontSize;  // Returns or sets the font size of the font used by this word art shape.
@property BOOL italic;  // Returns or sets if the text of the word art shape is formatted as italic.
@property BOOL kernedPairs;  // Returns or sets if character pairs in a WordArt object have been kerned. 
@property BOOL normalizedHeight;  // Returns or sets if all characters, both uppercase and lowercase, in the specified WordArt are the same height.
@property STMSWord2011MPTs presetShape;  // Returns or sets the shape of the specified WordArt.
@property STMSWord2011MPXF presetWordArtEffect;  // Returns or sets the style of the specified WordArt.
@property BOOL rotatedChars;  // Returns or sets if characters in the specified WordArt are rotated 90 degrees relative to the WordArt's bounding shape. If false, characters in the specified WordArt retain their original orientation relative to the bounding shape.
@property double tracking;  // Returns or sets the ratio of the horizontal space allotted to each character in the specified WordArt in relation to the width of the character. Can be a value from zero through 5.
@property (copy) NSString *wordArtText;  // Returns or sets the text associated with this word art shape.

- (void) toggleVerticalText;  // Switches the text flow in the specified WordArt from horizontal to vertical, or vice versa.

@end

// Represents an word art object in the drawing layer.
@interface STMSWord2011WordArt : STMSWord2011Shape

@property (readonly) BOOL bold;  // Returns if the text of the word art shape is formatted as bold.
@property (copy, readonly) NSString *fontName;  // Returns the font name of the font used by this word art shape.
@property (readonly) double fontSize;  // Returns the font size of the font used by this word art shape.
@property (readonly) BOOL italic;  // Returns if the text of the word art shape is formatted as italic.
@property (readonly) STMSWord2011MPXF presetWordArtEffect;  // Returns the style of the specified word art.
@property (copy, readonly) STMSWord2011WordArtFormat *wordArtFormat;  // Returns the word art format object associated with the word art shape object.
@property (copy, readonly) NSString *wordArtText;  // The text associated with this word art shape.


@end

// Represents all the properties for wrapping text around a shape.
@interface STMSWord2011WrapFormat : STMSWord2011BaseObject

@property BOOL allowOverlap;  // Returns or sets a value that specifies whether a given shape can overlap other shapes.
@property double distanceBottom;  // Returns or sets the distance in points between the document text and the bottom edge of the text-free area surrounding the specified shape.
@property double distanceLeft;  // Returns or sets the distance in points between the document text and the left edge of the text-free area surrounding the specified shape.
@property double distanceRight;  // Returns or sets the distance in points between the document text and the right edge of the text-free area surrounding the specified shape.
@property double distanceTop;  // Returns or sets the distance in points between the document text and the top edge of the text-free area surrounding the specified shape.
@property STMSWord2011E268 wrapSide;  // Returns or sets a value that indicates whether the document text should wrap on both sides of the specified shape, on either the left or right side only, or on the side of the shape that's farthest from the page margin.
@property STMSWord2011E267 wrapType;  // Returns or sets the wrap type for the specified shape.


@end



/*
 * Text Suite
 */

// Represents a single built-in or user-defined style. The Word style object includes style attributes, font, font style, paragraph spacing, and so on, as properties of the Word style object.
@interface STMSWord2011WordStyle : STMSWord2011BaseObject

@property BOOL automaticallyUpdate;  // True if the style is automatically redefined based on the selection. False if Word prompts for confirmation before redefining the style based on the selection.
@property STMSWord2011E184 baseStyle;  // Returns or sets an existing style on which you can base the formatting of another style.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this cell object.
@property (readonly) BOOL builtIn;  // Returns true if the specified object is one of the built-in styles in Word.
@property (copy, readonly) NSString *objectDescription;  // Returns the description of the specified style. For example, a typical description for the Heading 2 style might be Normal, Font: Arial, 12 pt, Bold, Italic, Space Before 12 pt After 3 pt, KeepWithNext, Level 2.
@property (copy, readonly) STMSWord2011Font *fontObject;  // Returns the font object associated with this Word style object.
@property (copy, readonly) STMSWord2011Frame *frame;  // Returns the frame object associated with this Word style object.
@property (readonly) BOOL inUse;  // Returns true if the specified style is a built-in style that has been modified or applied in the document or a new style that has been created in the document.
@property STMSWord2011E182 languageID;  // Returns or sets the language for the Word style object
@property STMSWord2011E182 languageIDEastAsian;  // Returns or sets an east asian language for the template.
@property (readonly) NSInteger listLevelNumber;  // Returns the list level for the specified style.
@property (copy, readonly) STMSWord2011ListTemplate *listTemplate;  // Returns the list template object associated with this Word style object.
@property (copy) NSString *nameLocal;  // Returns or sets the name of a built-in style in the language of the user. Setting this property renames a user-defined style or adds an alias to a built-in style. 
@property STMSWord2011E184 nextParagraphStyle;  // Returns or sets the style to be applied automatically to a new paragraph inserted after a paragraph formatted with the specified style.
@property BOOL noProofing;  // Returns or sets if Microsoft Word finds or replaces text that the spelling and grammar checker ignores for this Word style
@property BOOL noSpaceBetweenSame;  // Returns or sets if Microsoft Word suppresses space between paragraphs of the same style
@property (copy) STMSWord2011ParagraphFormat *paragraphFormat;  // Returns or sets the paragraph format object associated with this Word style object.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the Word style.
@property (readonly) STMSWord2011E128 styleType;  // Returns the style type.
@property (copy, readonly) STMSWord2011TableStyle *tableStyle;  // Returns table style properties for this style.

- (void) linkToListTemplateListTemplate:(STMSWord2011ListTemplate *)listTemplate listLevelNumber:(NSInteger)listLevelNumber;  // Links the specified style to a list template so that the style's formatting can be applied to lists.

@end

// Represents all the formatting for a paragraph.
@interface STMSWord2011ParagraphFormat : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011TabStop *> *) tabStops;

@property BOOL addSpaceBetweenEastAsianAndAlpha;  // Returns or sets if Microsoft Word is set to automatically add spaces between Japanese and Latin text for the specified paragraphs.
@property BOOL addSpaceBetweenEastAsianAndDigit;  // Returns or sets if Microsoft Word is set to automatically add spaces between Japanese text and numbers for the specified paragraphs.
@property STMSWord2011E142 alignment;  // Returns or sets a constant that represents the alignment for the specified paragraphs.
@property BOOL autoAdjustRightIndent;  // Returns or sets if Microsoft Word is set to automatically adjust the right indent for the specified paragraphs if you’ve specified a set number of characters per line.
@property STMSWord2011E104 baseLineAlignment;  // Returns or sets a constant that represents the vertical position of fonts on a line.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this text range object.
@property double characterUnitFirstLineIndent;  // Returns or sets the value in characters for a first-line or hanging indent. Use a positive value to set a first-line indent, and use a negative value to set a hanging indent.
@property double characterUnitLeftIndent;  // Returns or sets the left indent value in characters for the specified paragraphs.
@property double characterUnitRightIndent;  // Returns or sets the right indent value in characters for the specified paragraphs.
@property BOOL disableLineHeightGrid;  // Returns or sets if Microsoft Word aligns characters in the specified paragraphs to the line grid when a set number of lines per page is specified.
@property BOOL eastAsianLineBreakControl;
@property double firstLineIndent;  // Returns or sets the value in points for a first line or hanging indent. Use a positive value to set a first-line indent, and use a negative value to set a hanging indent.
@property BOOL halfWidthPunctuationOnTopOfLine;  // Returns or sets if Microsoft Word changes punctuation symbols at the beginning of a line to half-width characters for the specified paragraphs.
@property BOOL hangingPunctuation;  // Returns or sets if hanging punctuation is enabled for the specified paragraphs.
@property BOOL hyphenation;  // Returns or sets if the specified paragraphs are included in automatic hyphenation. False if the specified paragraphs are to be excluded from automatic hyphenation.
@property BOOL keepTogether;  // Returns or sets if all lines in the specified paragraphs remain on the same page when Microsoft Word repaginates the document.
@property BOOL keepWithNext;  // Returns or sets if the specified paragraph remains on the same page as the paragraph that follows it when Microsoft Word repaginates the document.
@property double lineSpacing;  // Returns or sets the line spacing in points for the specified paragraphs.
@property STMSWord2011E157 lineSpacingRule;  // Returns or sets the line spacing for the specified paragraphs.
@property double lineUnitAfter;  // Returns or sets the amount of spacing in gridlines after the specified paragraphs.
@property double lineUnitBefore;  // Returns or sets the amount of spacing in gridlines before the specified paragraphs.
@property BOOL noLineNumber;  // Returns or set if line numbers are repressed for the specified paragraphs.
@property STMSWord2011E269 outlineLevel;  // Returns or sets the outline level for the specified paragraphs.
@property BOOL pageBreakBefore;  // Returns or sets if a page break is forced before the specified paragraphs.
@property double paragraphFormatLeftIndent;  // Returns or sets the left indent in points for the specified paragraphs.
@property double paragraphFormatRightIndent;  // Returns or sets the right indent in points for the specified paragraphs.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the paragraph format object.
@property double spaceAfter;  // Returns or sets the spacing in points after the specified paragraphs.
@property BOOL spaceAfterAuto;  // Returns or sets if Microsoft Word automatically sets the amount of spacing after the specified paragraphs.
@property double spaceBefore;  // Returns or sets the spacing in points before the specified paragraphs.
@property BOOL spaceBeforeAuto;  // Returns or sets if Microsoft Word automatically sets the amount of spacing before the specified paragraphs.
@property STMSWord2011E184 style;  // Returns or sets the Word style associated with the replacement object.
@property BOOL widowControl;  // Returns or sets if the first and last lines in the specified paragraph remain on the same page as the rest of the paragraph when Word repaginates the document.
@property BOOL wordWrap;  // Returns or sets if Microsoft Word wraps Latin text in the middle of a word in the specified paragraphs or text frames.


@end

// Represents a single paragraph in a selection, range, or document.
@interface STMSWord2011Paragraph : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011TabStop *> *) tabStops;

@property BOOL addSpaceBetweenEastAsianAndAlpha;  // Returns or sets if Microsoft Word is set to automatically add spaces between Japanese and Latin text for the specified paragraphs.
@property BOOL addSpaceBetweenEastAsianAndDigit;  // Returns or sets if Microsoft Word is set to automatically add spaces between Japanese text and numbers for the specified paragraphs.
@property STMSWord2011E142 alignment;  // Returns or sets a constant that represents the alignment for the specified paragraphs.
@property BOOL autoAdjustRightIndent;  // Returns or sets if Microsoft Word is set to automatically adjust the right indent for the specified paragraphs if you’ve specified a set number of characters per line.
@property STMSWord2011E104 baseLineAlignment;  // Returns or sets a constant that represents the vertical position of fonts on a line.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this text range object.
@property double characterUnitFirstLineIndent;  // Returns or sets the value in characters for a first-line or hanging indent. Use a positive value to set a first-line indent, and use a negative value to set a hanging indent.
@property double characterUnitLeftIndent;  // Returns or sets the left indent value in characters for the specified paragraphs.
@property double characterUnitRightIndent;  // Returns or sets the right indent value in characters for the specified paragraphs.
@property BOOL disableLineHeightGrid;  // Returns or sets if Microsoft Word aligns characters in the specified paragraphs to the line grid when a set number of lines per page is specified.
@property (copy, readonly) STMSWord2011DropCap *dropCap;  // Returns the drop cap object associated with this paragraph object.
@property BOOL eastAsianLineBreakControl;
@property double firstLineIndent;  // Returns or sets the value in points for a first line or hanging indent. Use a positive value to set a first-line indent, and use a negative value to set a hanging indent.
@property BOOL halfWidthPunctuationOnTopOfLine;  // Returns or sets if Microsoft Word changes punctuation symbols at the beginning of a line to half-width characters for the specified paragraphs.
@property BOOL hangingPunctuation;  // Returns or sets if hanging punctuation is enabled for the specified paragraphs.
@property BOOL hyphenation;  // Returns or sets if the specified paragraphs are included in automatic hyphenation. False if the specified paragraphs are to be excluded from automatic hyphenation.
@property BOOL keepTogether;  // Returns or sets if all lines in the specified paragraphs remain on the same page when Microsoft Word repaginates the document.
@property BOOL keepWithNext;  // Returns or sets if the specified paragraph remains on the same page as the paragraph that follows it when Microsoft Word repaginates the document.
@property double lineSpacing;  // Returns or sets the line spacing in points for the specified paragraphs.
@property STMSWord2011E157 lineSpacingRule;  // Returns or sets the line spacing for the specified paragraphs.
@property double lineUnitAfter;  // Returns or sets the amount of spacing in gridlines after the specified paragraphs.
@property double lineUnitBefore;  // Returns or sets the amount of spacing in gridlines before the specified paragraphs.
@property BOOL noLineNumber;  // Returns or set if line numbers are repressed for the specified paragraphs.
@property STMSWord2011E269 outlineLevel;  // Returns or sets the outline level for the specified paragraphs.
@property BOOL pageBreakBefore;  // Returns or sets if a page break is forced before the specified paragraphs.
@property (copy) STMSWord2011ParagraphFormat *paragraphFormat;  // Returns or sets the paragraph format object associated with this paragraph object.
@property double paragraphLeftIndent;  // Returns or sets the left indent in points for the specified paragraphs.
@property NSInteger paragraph_id;  // Returns the paragraph id for the specified paragraphs.
@property double rightIndent;  // Returns or sets the right indent in points for the specified paragraphs.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the paragraph object.
@property double spaceAfter;  // Returns or sets the spacing in points after the specified paragraphs.
@property double spaceBefore;  // Returns or sets the spacing in points before the specified paragraphs.
@property STMSWord2011E184 style;  // Returns or sets the Word style associated with the replacement object.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the portion of a document that's contained in the section object.
@property NSInteger text_id;  // Returns the text id for the specified paragraphs.
@property BOOL widowControl;  // Returns or sets if the first and last lines in the specified paragraph remain on the same page as the rest of the paragraph when Word repaginates the document.
@property BOOL wordWrap;  // Returns or sets if Microsoft Word wraps Latin text in the middle of a word in the specified paragraphs or text frames.

- (void) indent;  // Indents one or more paragraphs by one level.
- (STMSWord2011Paragraph *) nextParagraph;  // Returns the next paragraph object.
- (void) outdent;  // Removes one level of indent for one or more paragraphs.
- (void) outlineDemote;  // Applies the next heading level style Heading 1 through Heading 8 to the specified paragraph or paragraphs. For example, if a paragraph is formatted with the Heading 2 style, this method demotes the paragraph by changing the style to Heading 3.
- (void) outlineDemoteToBody;  // Demotes the specified paragraph or paragraphs to body text by applying the Normal style.
- (void) outlinePromote;  // Applies the previous heading level style Heading 1 through Heading 8 to the specified paragraph or paragraphs. For example, if a paragraph is formatted with the Heading 2 style, this method promotes the paragraph by changing the style to Heading 1.
- (STMSWord2011Paragraph *) previousParagraph;  // Returns the previous paragraph object.

@end

// Represents a single section in a selection, range, or document.
@interface STMSWord2011Section : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;
@property (copy) STMSWord2011PageSetup *pageSetup;  // Returns or sets a page setup object associated with this section object
@property BOOL protectedForForms;  // Returns or sets if the specified section is protected for forms. When a section is protected for forms, you can select and modify text only in form fields.
@property (readonly) NSInteger sectionIndex;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the portion of a document that's contained in the section object.

- (STMSWord2011HeaderFooter *) getFooterIndex:(STMSWord2011E163)index;  // Returns a specific footer object
- (STMSWord2011HeaderFooter *) getHeaderIndex:(STMSWord2011E163)index;  // Returns a specific header object

@end

// Contains shading attributes for an object.
@interface STMSWord2011Shading : STMSWord2011BaseObject

@property (copy) NSColor *backgroundPatternColor;  // Returns or sets the RGB color that's applied to the background of the shading object.
@property STMSWord2011E110 backgroundPatternColorIndex;  // Returns or sets the color index that's applied to the background of the shading object.
@property STMSWord2011MCoI backgroundPatternColorThemeIndex;  // Returns or sets the color that's applied to the background of the shading object.
@property (copy) NSColor *foregroundPatternColor;  // Returns or sets the RGB color that's applied to the foreground of the shading object.
@property STMSWord2011E110 foregroundPatternColorIndex;  // Returns or sets the color index that's applied to the foreground of the shading object.
@property STMSWord2011MCoI foregroundPatternColorThemeIndex;  // Returns or sets the color that's applied to the foreground of the shading object. This color is applied to the dots and lines in the shading pattern.
@property STMSWord2011E112 texture;  // Returns or sets the shading texture for the specified object.


@end

// Represents a contiguous area in a document. Each text range object is defined by a starting and ending character position.
@interface STMSWord2011TextRange : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Character *> *) characters;
- (SBElementArray<STMSWord2011Word *> *) words;
- (SBElementArray<STMSWord2011Sentence *> *) sentences;
- (SBElementArray<STMSWord2011Table *> *) tables;
- (SBElementArray<STMSWord2011Footnote *> *) footnotes;
- (SBElementArray<STMSWord2011Endnote *> *) endnotes;
- (SBElementArray<STMSWord2011WordComment *> *) WordComments;
- (SBElementArray<STMSWord2011Cell *> *) cells;
- (SBElementArray<STMSWord2011Section *> *) sections;
- (SBElementArray<STMSWord2011Paragraph *> *) paragraphs;
- (SBElementArray<STMSWord2011Field *> *) fields;
- (SBElementArray<STMSWord2011FormField *> *) formFields;
- (SBElementArray<STMSWord2011Frame *> *) frames;
- (SBElementArray<STMSWord2011Bookmark *> *) bookmarks;
- (SBElementArray<STMSWord2011Revision *> *) revisions;
- (SBElementArray<STMSWord2011HyperlinkObject *> *) hyperlinkObjects;
- (SBElementArray<STMSWord2011Subdocument *> *) subdocuments;
- (SBElementArray<STMSWord2011Column *> *) columns;
- (SBElementArray<STMSWord2011Row *> *) rows;
- (SBElementArray<STMSWord2011Shape *> *) shapes;
- (SBElementArray<STMSWord2011ReadabilityStatistic *> *) readabilityStatistics;
- (SBElementArray<STMSWord2011GrammaticalError *> *) grammaticalErrors;
- (SBElementArray<STMSWord2011SpellingError *> *) spellingErrors;
- (SBElementArray<STMSWord2011InlineShape *> *) inlineShapes;
- (SBElementArray<STMSWord2011MathObject *> *) mathObjects;
- (SBElementArray<STMSWord2011CoauthLock *> *) coauthLocks;
- (SBElementArray<STMSWord2011CoauthUpdate *> *) coauthUpdates;
- (SBElementArray<STMSWord2011Conflict *> *) conflicts;

@property BOOL bold;  // Returns or sets if the text associated with the text range is formatted as bold.
@property (readonly) NSInteger bookmarkId;  // Returns the number of the bookmark that encloses the beginning of the text range. The number corresponds to the position of the bookmark in the document, 1 for the first bookmark, 2 for the second one, and so on.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this text range object.
@property STMSWord2011E125 character_case;  // Synonym for case
- (STMSWord2011E125) case;  // Returns or sets a constant that represents the case of the text in the text range.
- (void) setCase: (STMSWord2011E125)a_case;
@property (copy, readonly) STMSWord2011ColumnOptions *columnOptions;
@property BOOL combineCharacters;
@property (copy) NSString *content;  // Returns or sets the text in the text range.
@property BOOL disableCharacterSpaceGrid;  // Returns or sets if Microsoft Word ignores the number of characters per line for the corresponding text range object.
@property STMSWord2011E114 emphasisMark;  // Returns or sets the emphasis mark for a character or designated character string.
@property (readonly) NSInteger endOfContent;  // Returns the ending character position of the text range.
@property (copy, readonly) STMSWord2011EndnoteOptions *endnoteOptions;  // Returns the endnote options object for this text range.
@property (copy, readonly) STMSWord2011FieldOptions *fieldOptions;
@property (copy, readonly) STMSWord2011Find *findObject;  // Returns the find object associated with this text range.
@property double fitTextWidth;  // Returns or sets the width in which Microsoft Word fits the text in the text range.
@property (copy, readonly) STMSWord2011Font *fontObject;  // Returns the font object associated with this text range.
@property (copy, readonly) STMSWord2011FootnoteOptions *footnoteOptions;  // Returns the footnote options object for this text range.
@property (copy) STMSWord2011TextRange *formattedText;  // Returns or sets a text range object that includes the formatted text in the text range.
@property BOOL grammarChecked;  // True if a grammar check has been run on the text range. False if some of the text range hasn't been checked for grammar. To recheck the grammar in the document, set the grammar checked property to false.
@property STMSWord2011E110 highlightColorIndex;  // Returns or sets the highlight color for the text range.
@property STMSWord2011E309 horizontalInVertical;
@property (readonly) BOOL isEndOfRowMark;  // Returns true if the text range is collapsed and is located at the end-of-row mark in a table.
@property BOOL italic;  // Returns or sets if the text associated with the text range is formatted as italic.
@property STMSWord2011E182 languageID;  // Returns or sets the language for the text range object
@property STMSWord2011E182 languageIDEastAsian;  // Returns or sets an east asian language for the template.
@property (copy, readonly) STMSWord2011ListFormat *listFormat;  // Returns the list format object associated with this text range.
@property (copy, readonly) STMSWord2011TextRange *nextStoryRange;  // Returns a text range object that refers to the next story
@property BOOL noProofing;  // Returns or sets if the spelling and grammar checker should ignore documents based on this text range.
@property STMSWord2011E270 orientation;  // Returns or sets the orientation of text in a text range when the text direction feature is enabled.
@property (copy) STMSWord2011PageSetup *pageSetup;  // Returns or sets the page setup object associated with this text range.
@property (copy) STMSWord2011ParagraphFormat *paragraphFormat;  // Returns or sets the paragraph format object associated with this text range.
@property (readonly) NSInteger previousBookmarkId;  // Returns the number of the last bookmark that starts before or at the same place as the text range, It returns zero if there's no corresponding bookmark.
@property (copy, readonly) STMSWord2011RangeEndnoteOptions *rangeEndnoteOptions;
@property (copy, readonly) STMSWord2011RangeFootnoteOptions *rangeFootnoteOptions;
@property (copy, readonly) STMSWord2011RowOptions *rowOptions;
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with this text range.
@property (copy) NSString *showWordCommentsBy;  // Returns or sets the name of the reviewer whose comments are shown in the comments pane. You can choose to show comments either by a single reviewer or by all reviewers. To view the comments by all reviewers, set this property to 'All Reviewers'.
@property BOOL showHiddenBookmarks;  // Returns or sets if hidden bookmarks are included in the elements of this text range.
@property BOOL spellingChecked;  // True if a spelling check has been run on the text range. False if some of the text range hasn't been checked for spelling. To see if the document contains spelling errors, get the count of spelling errors for the text range.
@property (readonly) NSInteger startOfContent;  // Returns the starting character position of the text range.
@property (readonly) NSInteger storyLength;  // Returns the number of characters in the story that contains the text range.
@property (readonly) STMSWord2011E160 storyType;  // Returns the story type for the text range.
@property STMSWord2011E184 style;  // Returns or sets the Word style for this range.
@property BOOL subdocumentsExpanded;  // Returns or sets if the subdocuments in the specified text range are expanded.
@property STMSWord2011E182 supplementalLanguageID;  // Returns or sets the language for the text range object
@property (copy) STMSWord2011TextRetrievalMode *textRetrievalMode;  // Returns or sets the text retrieval object that controls how text is retrieved from this text range.
@property STMSWord2011E308 twoLinesInOne;  // Returns or sets whether Microsoft Word sets two lines of text in one and specifies the characters that enclose the text, if any.  Read/write
@property STMSWord2011E113 underline;  // Returns or sets the type of underline applied to the text range.

- (void) autoFormatTextRange;  // Automatically formats a text range.
- (double) calculateRange;  // Calculates a mathematical expression within a text range.
- (STMSWord2011TextRange *) changeEndOfRangeBy:(STMSWord2011E129)by extendType:(STMSWord2011E249)extendType;  // Moves or extends the ending character position of a range or selection to the end of the nearest specified text unit. This method returns the new range object or missing value if an error occurred.
- (STMSWord2011TextRange *) changeStartOfRangeBy:(STMSWord2011E129)by extendType:(STMSWord2011E249)extendType;  // Moves or extends the start position of the specified range or selection to the beginning of the nearest specified text unit. This method returns the new range object or missing value if an error occurred.
- (BOOL) checkGrammar;  // Begins a grammar check for the text range.  Returns true if the text range had no errors
- (BOOL) checkSpellingCustomDictionary:(STMSWord2011Dictionary *)customDictionary ignoreUppercase:(BOOL)ignoreUppercase mainDictionary:(STMSWord2011Dictionary *)mainDictionary customDictionary2:(STMSWord2011Dictionary *)customDictionary2 customDictionary3:(STMSWord2011Dictionary *)customDictionary3 customDictionary4:(STMSWord2011Dictionary *)customDictionary4 customDictionary5:(STMSWord2011Dictionary *)customDictionary5 customDictionary6:(STMSWord2011Dictionary *)customDictionary6 customDictionary7:(STMSWord2011Dictionary *)customDictionary7 customDictionary8:(STMSWord2011Dictionary *)customDictionary8 customDictionary9:(STMSWord2011Dictionary *)customDictionary9 customDictionary10:(STMSWord2011Dictionary *)customDictionary10;  // Begins a spelling check for the text range.  Returns true if the text range had no errors
- (void) checkSynonyms;  // Displays the thesaurus dialog box, which lists alternative word choices, or synonyms, for the text in the text range.
- (STMSWord2011TextRange *) collapseRangeDirection:(STMSWord2011E132)direction;  // Collapses this text range to the starting or ending position and returns a new text range object. After a text range is collapsed, the starting and ending points are equal.
- (NSInteger) computeTextRangeStatisticsStatistic:(STMSWord2011E155)statistic;  // Returns a statistic based on the contents of the specified text range.
- (STMSWord2011Table *) convertToTableSeparator:(STMSWord2011E177)separator numberOfRows:(NSInteger)numberOfRows numberOfColumns:(NSInteger)numberOfColumns initialColumnWidth:(NSInteger)initialColumnWidth tableFormat:(STMSWord2011E180)tableFormat applyBorders:(BOOL)applyBorders applyShading:(BOOL)applyShading applyFont:(BOOL)applyFont applyColor:(BOOL)applyColor applyHeadingRows:(BOOL)applyHeadingRows applyLastRow:(BOOL)applyLastRow applyFirstColumn:(BOOL)applyFirstColumn applyLastColumn:(BOOL)applyLastColumn autoFit:(BOOL)autoFit autoFitBehavior:(STMSWord2011E288)autoFitBehavior defaultTableBehavior:(STMSWord2011E287)defaultTableBehavior;  // Converts text within a text range to a table.
- (void) copyAsPicture NS_RETURNS_NOT_RETAINED;  // Copies the content of the text range as a picture.
- (void) copyObject NS_RETURNS_NOT_RETAINED;  // Copies the content of the text range to the clipboard.
- (void) cutObject;  // Removes the content of the text range from the document and places it on the clipboard.
- (STMSWord2011TextRange *) expandBy:(STMSWord2011E129)by;  // Expands the specified range. This method returns the new range object or missing value if an error occurred.
- (NSString *) getRangeInformationInformationType:(STMSWord2011E266)informationType;  // Returns requested information about the text range. 
- (STMSWord2011TextRange *) goToNextWhat:(STMSWord2011E130)what;  // Returns a text range object that refers to the start position of the next item or location specified by the what argument.
- (STMSWord2011TextRange *) goToPreviousWhat:(STMSWord2011E130)what;  // Returns a text range object that refers to the start position of the previous item or location specified by the what argument.
- (BOOL) inRangeTextRange:(STMSWord2011TextRange *)textRange;  // Returns true if the text range to which the method is applied is contained in the range specified by the text range argument.
- (BOOL) inStoryTextRange:(STMSWord2011TextRange *)textRange;  // Returns true if the text range to which the method is applied is in the same story as the range specified by the text range argument.
- (BOOL) isEquivalentTextRange:(STMSWord2011TextRange *)textRange;  // True if the selection or range to which this method is applied is equal to the range specified by the text range argument. This method compares the starting and ending character positions, as well as the story type.
- (void) modifyEnclosureEnclosureStyle:(STMSWord2011E277)enclosureStyle enclosureType:(STMSWord2011E276)enclosureType enclosedText:(NSString *)enclosedText;  // Adds, modifies, or removes an enclosure around the specified character or characters.
- (STMSWord2011TextRange *) moveEndOfRangeBy:(STMSWord2011E129)by count:(NSInteger)count;  // Moves the ending character position of the range.  This method returns the new text range object or missing value if an error occurred.
- (STMSWord2011TextRange *) moveRangeBy:(STMSWord2011E129)by count:(NSInteger)count;  // Collapses the specified range to its start or end position and then moves the collapsed object by the specified number of units. This method returns the new range object or missing value if an error occurred.
- (STMSWord2011TextRange *) moveRangeEndUntilCharacters:(NSString *)characters count:(STMSWord2011E294)count;  // Moves the end position of the specified range until any of the specified characters are found in the document. This method returns the new range object or missing value if an error occurred.
- (STMSWord2011TextRange *) moveRangeEndWhileCharacters:(NSString *)characters count:(STMSWord2011E294)count;  // Moves the ending character position of a the specified range while any of the specified characters are found in the document. This method returns the new range object or missing value if an error occurred.
- (STMSWord2011TextRange *) moveRangeStartUntilCharacters:(NSString *)characters count:(STMSWord2011E294)count;  // Moves the start position of the specified range until one of the specified characters is found in the document. This method returns the new range object or missing value if an error occurred.
- (STMSWord2011TextRange *) moveRangeStartWhileCharacters:(NSString *)characters count:(STMSWord2011E294)count;  // Moves the start position of the specified range while any of the specified characters are found in the document. This method returns the new range object or missing value if an error occurred.
- (STMSWord2011TextRange *) moveRangeUntilCharacters:(NSString *)characters count:(STMSWord2011E294)count;  // Moves the specified range until one of the specified characters is found in the document. This method returns the new range object or missing value if an error occurred.
- (STMSWord2011TextRange *) moveRangeWhileCharacters:(NSString *)characters count:(STMSWord2011E294)count;  // Moves the specified range while any of the specified characters are found in the document. This method returns the new range object or missing value if an error occurred.
- (STMSWord2011TextRange *) moveStartOfRangeBy:(STMSWord2011E129)by count:(NSInteger)count;  // Moves the starting character position of the range. This method returns the new text range object or missing value if an error occurred.
- (STMSWord2011TextRange *) navigateTo:(STMSWord2011E130)to position:(STMSWord2011E131)position count:(NSInteger)count name:(NSString *)name;  // Returns a text range object that represents the start position of the specified item, such as a page, bookmark, or field.
- (STMSWord2011TextRange *) nextRangeBy:(STMSWord2011E129)by count:(NSInteger)count;  // Returns a text range object relative to the specified text range.
- (STMSWord2011TextRange *) nextSubdocument;  // Returns a new text range object to the next subdocument. If there isn't another subdocument, an error occurs.
- (void) pasteAndFormatType:(STMSWord2011E293)type;  // Pastes the selected table cells and formats them as specified.
- (void) pasteAppendTable;  // Merges pasted cells into an existing table by inserting the pasted rows between the selected rows. No cells are overwritten.
- (void) pasteAsNestedTable;  // Pastes a cell or group of cells as a nested table into the text range.
- (void) pasteExcelTableLinkedToExcel:(BOOL)linkedToExcel wordFormatting:(BOOL)wordFormatting RTF:(BOOL)RTF;  // Pastes and formats a Microsoft Excel table.
- (void) pasteObject;  // Inserts the contents of the clipboard at the specified text range.
- (void) pasteSpecialLink:(BOOL)link placement:(STMSWord2011E243)placement displayAsIcon:(BOOL)displayAsIcon dataType:(STMSWord2011E251)dataType iconLabel:(NSString *)iconLabel;  // Inserts the contents of the clipboard. Unlike with the paste method, with paste special you can control the format of the pasted information and optionally establish a link to the source file - for example, a Microsoft Excel worksheet.
- (void) phoneticGuideText:(NSString *)text alignmentType:(STMSWord2011E310)alignmentType raise:(NSInteger)raise fontSize:(NSInteger)fontSize fontName:(NSString *)fontName;
- (STMSWord2011TextRange *) previousRangeBy:(STMSWord2011E129)by count:(NSInteger)count;  // Returns a text range object relative to the specified text range.
- (STMSWord2011TextRange *) previousSubdocument;  // Returns a new text range object to the previous subdocument. If there isn't another subdocument, an error occurs.
- (void) relocateDirection:(STMSWord2011E224)direction;  // In outline view, moves the paragraphs within the text range after the next visible paragraph or before the previous visible paragraph. Body text moves with a heading only if the body text is collapsed in outline view or if it's part of the text range.
- (STMSWord2011TextRange *) setRangeStart:(NSInteger)start end:(NSInteger)end;  // Returns a text range object by using the specified starting and ending character positions.
- (void) sortExcludeHeader:(BOOL)excludeHeader fieldNumber:(NSInteger)fieldNumber sortFieldType:(STMSWord2011E178)sortFieldType sortOrder:(STMSWord2011E179)sortOrder fieldNumberTwo:(NSInteger)fieldNumberTwo sortFieldTypeTwo:(STMSWord2011E178)sortFieldTypeTwo sortOrderTwo:(STMSWord2011E179)sortOrderTwo fieldNumberThree:(NSInteger)fieldNumberThree sortFieldTypeThree:(STMSWord2011E178)sortFieldTypeThree sortOrderThree:(STMSWord2011E179)sortOrderThree sortColumn:(BOOL)sortColumn separator:(STMSWord2011E176)separator caseSensitive:(BOOL)caseSensitive languageID:(STMSWord2011E182)languageID;  // Sorts the paragraphs in the specified text range.
- (void) sortAscending;  // Sorts paragraphs or table rows in ascending alphanumeric order. The first paragraph or table row is considered a header record and isn't included in the sort. Use the sort method to include the header record in a sort.
- (void) sortDescending;  // Sorts paragraphs or table rows in descending alphanumeric order. The first paragraph or table row is considered a header record and isn't included in the sort. Use the sort method to include the header record in a sort.
- (NSDictionary *) textRangeSpellingSuggestionsCustomDictionary:(STMSWord2011Dictionary *)customDictionary ignoreUppercase:(BOOL)ignoreUppercase mainDictionary:(STMSWord2011Dictionary *)mainDictionary suggestionMode:(STMSWord2011E256)suggestionMode customDictionary2:(STMSWord2011Dictionary *)customDictionary2 customDictionary3:(STMSWord2011Dictionary *)customDictionary3 customDictionary4:(STMSWord2011Dictionary *)customDictionary4 customDictionary5:(STMSWord2011Dictionary *)customDictionary5 customDictionary6:(STMSWord2011Dictionary *)customDictionary6 customDictionary7:(STMSWord2011Dictionary *)customDictionary7 customDictionary8:(STMSWord2011Dictionary *)customDictionary8 customDictionary9:(STMSWord2011Dictionary *)customDictionary9 customDictionary10:(STMSWord2011Dictionary *)customDictionary10;  // Returns a record that contains the spelling error type and the list of words suggested as replacements for the first word in the specified range

@end

@interface STMSWord2011Character : STMSWord2011TextRange


@end

@interface STMSWord2011GrammaticalError : STMSWord2011TextRange


@end

@interface STMSWord2011Sentence : STMSWord2011TextRange


@end

@interface STMSWord2011SpellingError : STMSWord2011TextRange


@end

@interface STMSWord2011StoryRange : STMSWord2011TextRange


@end

@interface STMSWord2011Word : STMSWord2011TextRange


@end



/*
 * Proofing Suite
 */

// Represents a single autocorrect entry.
@interface STMSWord2011AutocorrectEntry : STMSWord2011BaseObject

@property (copy) NSString *autocorrectValue;  // Returns or sets the value of the auto correct entry.
@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy) NSString *name;  // Returns or sets the name of the auto correct entry.
@property (readonly) BOOL richText;  // Returns if formatting is stored with the autocorrect entry replacement text.

- (void) applyCorrectionToRange:(STMSWord2011TextRange *)toRange;  // Replaces a range with the value of the specified autocorrect entry.

@end

// Represents the autocorrect functionality in Word.
@interface STMSWord2011Autocorrect : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011AutocorrectEntry *> *) autocorrectEntries;
- (SBElementArray<STMSWord2011FirstLetterException *> *) firstLetterExceptions;
- (SBElementArray<STMSWord2011TwoInitialCapsException *> *) twoInitialCapsExceptions;
- (SBElementArray<STMSWord2011OtherCorrectionsException *> *) otherCorrectionsExceptions;

@property BOOL correctDays;  // Returns or sets if Word automatically capitalizes the first letter of days of the week.
@property BOOL correctInitialCaps;  // Returns or sets if Word automatically makes the second letter lowercase if the first two letters of a word are typed in uppercase. For example, WOrd is corrected to Word.
@property BOOL correctSentenceCaps;  // Returns or sets if Word automatically capitalizes the first letter in each sentence.
@property BOOL correctTableCaps;  // Returns or sets if Word automatically capitalizes the first letter in each table cell.
@property BOOL firstLetterAutoAdd;  // Returns or sets if Word automatically adds abbreviations to the list of autocorrect first letter exceptions.
@property BOOL otherCorrectionsAutoAdd;  // Returns or sets if Microsoft Word automatically adds words to the list of other autocorrect exceptions. Word adds a word to this list if you delete and then retype a word that you didn't want Word to correct.
@property BOOL replaceText;  // Returns or sets if Microsoft Word automatically replaces specified text with entries from the autocorrect list.
@property BOOL replaceTextFromSpellingChecker;  // Returns or sets if Microsoft Word automatically replaces misspelled text with suggestions from the spelling checker as the user types.
@property BOOL showAutocorrectSmartButton;  // Returns or sets if Word shows the AutoCorrect smart button which allows you to review the correction when an automatic correction occurs.
@property BOOL turnOnAutocorrect;  // Returns or sets if Word automatically corrects spelling and formatting as you type.
@property BOOL twoInitialCapsAutoAdd;  // Returns or sets if Microsoft Word automatically adds words to the list of autocorrect initial caps exceptions.


@end

// Represents a dictionary.
@interface STMSWord2011Dictionary : STMSWord2011BaseObject

@property (readonly) STMSWord2011E255 dictionaryType;  // Returns the dictionary type.
@property STMSWord2011E182 languageID;  // Returns or sets the language for the dictionary object
@property BOOL languageSpecific;  // Returns or sets if the custom dictionary is to be used only with text formatted for a specific language.
@property (copy, readonly) NSString *name;  // Returns or sets the name of this dictionary object.
@property (copy, readonly) NSString *path;  // Returns the disk or Web path to the specified dictionary.
@property (readonly) BOOL readOnly;  // Returns true if the specified dictionary cannot be changed.


@end

// Represents an abbreviation excluded from automatic correction.
@interface STMSWord2011FirstLetterException : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *name;  // The name of this first letter exception object.


@end

// Represents a language used for proofing or formatting in Microsoft Word.
@interface STMSWord2011Language : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011Dictionary *activeGrammarDictionary;  // Returns a dictionary object that represents the active grammar dictionary for the specified language
@property (copy, readonly) STMSWord2011Dictionary *activeHyphenationDictionary;  // Returns a dictionary object that represents the active hyphenation dictionary for the specified language.
@property (copy, readonly) STMSWord2011Dictionary *activeSpellingDictionary;  // Returns a dictionary object that represents the active spelling dictionary for the specified language.
@property (copy, readonly) STMSWord2011Dictionary *activeThesaurusDictionary;  // Returns a dictionary object that represents the active thesaurus dictionary for the specified language.
@property (copy) NSString *defaultWritingStyle;  // Returns or sets the default writing style used by the grammar checker for the specified language. The name of the writing style is the localized name for the specified language.
@property (readonly) STMSWord2011E182 languageID;  // Returns an enumeration that identifies the specified language.
@property (copy, readonly) NSString *name;  // Returns the name of the language
@property (copy, readonly) NSString *nameLocal;  // Returns the name of a proofing tool language in the language of the user.
@property STMSWord2011E255 spellingDictionaryType;  // Returns or sets the proofing tool type
@property (copy, readonly) NSArray *writingStyleList;  // Returns a list of strings that contains the names of all writing styles available for the specified language.


@end

// Represents a single auto correct exception.
@interface STMSWord2011OtherCorrectionsException : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *name;  // Returns the name of this other corrections exception object.


@end

// Represents one of the readability statistics for a document or range.
@interface STMSWord2011ReadabilityStatistic : STMSWord2011BaseObject

@property (copy, readonly) NSString *name;  // The name of this readability statistic object.
@property (readonly) double readabilityValue;  // The value of this readability statistic object.


@end

// Represents the information about synonyms, antonyms, related words, or related expressions for the specified range or a given string.
@interface STMSWord2011SynonymInfo : STMSWord2011BaseObject

@property (copy, readonly) NSArray *antonyms;  // Returns a list of antonyms for the word or phrase.
@property (copy, readonly) NSString *context;  // Returns the word or phrase that was looked up by the thesaurus.
@property (readonly) BOOL found;  // Returns true if the thesaurus finds synonyms, antonyms, related words, or related expressions for the word or phrase.
@property (readonly) NSInteger meaningCount;  // Returns the number of entries in the list of meanings found in the thesaurus for the word or phrase. Returns zero if no meanings were found.
@property (copy, readonly) NSArray *meanings;  // Returns the list of meanings for the word or phrase.
@property (copy, readonly) NSArray *partOfSpeech;  // Returns a list of the parts of speech corresponding to the meanings found for the word or phrase looked up in the thesaurus.
@property (copy, readonly) NSArray *relatedExpressions;  // Returns a list of expressions related to the specified word or phrase. 
@property (copy, readonly) NSArray *relatedWords;  // Returns a list of words related to the specified word or phrase.

- (NSArray *) getSynonymListForItemToCheck:(NSString *)itemToCheck;  // Get the list of synonyms for a particular word
- (NSArray *) getSynonymListFromMeaningIndex:(NSInteger)meaningIndex;  // Get the list of synonyms using an index into the list of meanings

@end

// Represents a single initial-capital autocorrect exception.
@interface STMSWord2011TwoInitialCapsException : STMSWord2011BaseObject

@property (readonly) NSInteger entry_index;  // Returns the index for the position of the object in its container element list.
@property (copy, readonly) NSString *name;  // The name of this two initial caps exception object.


@end



/*
 * Table Suite
 */

// Represents a single table cell.
@interface STMSWord2011Cell : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Table *> *) tables;

@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this cell object.
@property double bottomPadding;  // Returns or sets the amount of space in points to add below the contents of a single cell or all the cells in a table.
@property (copy, readonly) STMSWord2011Column *column;  // Returns the column object that contains this cell object.
@property (readonly) NSInteger columnIndex;  // Returns the number of the column that contains the specified cell.
@property BOOL fitText;  // Returns or sets if Microsoft Word visually reduces the size of text typed into a cell so that it fits within the column width.
@property double height;  // Returns or sets the height of the object.
@property STMSWord2011E133 heightRule;  // Returns or sets the rule for determining the height of the specified cells.
@property double leftPadding;  // Returns or sets the amount of space in points to add to the left of the contents of a single cell or all the cells in a table.
@property (readonly) NSInteger nestingLevel;  // Returns the nesting level of the specified cell.
@property (copy, readonly) STMSWord2011Cell *nextCell;  // Returns the next cell object
@property double preferredWidth;  // Returns or sets the preferred width in points for the specified cell.
@property STMSWord2011E290 preferredWidthType;  // Returns or sets the preferred unit of measurement to use for the width of the specified column.
@property (copy, readonly) STMSWord2011Cell *previousCell;  // Returns the previous cell object
@property double rightPadding;  // Returns or sets the amount of space in points to add to the right of the contents of a single cell or all the cells in a table.
@property (copy, readonly) STMSWord2011Row *row;  // Returns the row object that contains this cell object.
@property (readonly) NSInteger rowIndex;  // Returns the number of the row that contains the specified cell.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the cell object.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the portion of a document that's contained in the cell object.
@property double topPadding;  // Returns or sets the amount of space in points to add above the contents of a single cell or all the cells in a table.
@property STMSWord2011E147 verticalAlignment;  // Returns or sets the vertical alignment of text in one or more cells of a table.
@property double width;  // Returns or sets the width of the object.
@property BOOL wordWrap;  // Returns or set  if Microsoft Word wraps text to multiple lines and lengthens the cell so that the cell width remains the same.

- (void) autoSum;  // Inserts an = Formula field that calculates and displays the sum of the values in table cells above or to the left of the cell specified in the expression.
- (void) formulaFormulaString:(NSString *)formulaString numberFormatString:(NSString *)numberFormatString;  // Inserts an = Formula field that contains the specified formula into a table cell.
- (void) mergeCellWith:(STMSWord2011Cell *)with;  // Merges the specified table cell with another cell. The result is a single table cell.
- (void) splitCellNumberOfRows:(NSInteger)numberOfRows numberOfColumns:(NSInteger)numberOfColumns;  // Splits a single table cell into multiple cells.

@end

// Represents options that can be set for columns.
@interface STMSWord2011ColumnOptions : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this cell object.
@property double defaultWidth;  // Returns or sets the default width of columns.
@property (readonly) NSInteger nestingLevel;
@property double preferredWidth;  // Returns or sets the preferred width in points for the specified columns. 
@property STMSWord2011E290 preferredWidthType;  // Returns or sets the preferred unit of measurement to use for the width of the specified columns. 
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with columns.

- (void) distributeWidth;  // Adjusts the width of the specified columns or cells so that they're equal.

@end

// Represents a single table column.
@interface STMSWord2011Column : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this column object.
@property (readonly) NSInteger columnIndex;  // Returns the index for the position of the object in its container element list.
@property (readonly) BOOL isFirst;  // Returns if the specified column is the first one in the table.
@property (readonly) BOOL isLast;  // Returns if the specified column is the last one in the table.
@property (readonly) NSInteger nestingLevel;  // Returns the nesting level of the specified column.
@property (copy, readonly) STMSWord2011Column *nextColumn;  // Returns the next column object
@property double preferredWidth;  // Returns or sets the preferred width in points for the specified column.
@property STMSWord2011E290 preferredWidthType;  // Returns or sets the preferred unit of measurement to use for the width of the specified column.
@property (copy, readonly) STMSWord2011Column *previousColumn;  // Returns the previous column object
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the column object.
@property double width;  // Returns or sets the width of the object.


@end

@interface STMSWord2011Condition : STMSWord2011BaseObject

@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns the border options object associated with this condition.
@property double bottomPadding;
@property (copy, readonly) STMSWord2011Font *fontObject;
@property double leftPadding;
@property (copy) STMSWord2011ParagraphFormat *paragraphFormat;
@property double rightPadding;
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with this condition.
@property double topPadding;


@end

// Represents options that can be set for rows.
@interface STMSWord2011RowOptions : STMSWord2011BaseObject

@property STMSWord2011E144 alignment;  // Returns or sets a constant that represents the alignment for rows.
@property BOOL allowBreakAcrossPages;  // Returns or sets if the text in a table row or rows are allowed to split across a page break.
@property BOOL allowOverlap;  // Returns or sets a value that specifies whether the specified rows can overlap other rows.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this cell object.
@property double distanceBottom;  // Returns or sets the distance in points between the document text and the bottom edge of the specified table. This property doesn't have any effect if wrap around text is false. 
@property double distanceLeft;  // Returns or sets the distance in points between the document text and the left edge of the specified table. This property doesn't have any effect if wrap around text is false.
@property double distanceRight;  // Returns or sets the distance in points between the document text and the right edge of the specified table. This property doesn't have any effect if wrap around text is false.
@property double distanceTop;  // Returns or sets the distance in points between the document text and the top edge of the specified table. This property doesn't have any effect if wrap around text is false.
@property BOOL headingFormat;  // Returns or sets if the specified row or rows are formatted as a table heading. Rows formatted as table headings are repeated when a table spans more than one page.
@property double height;  // Returns or sets the height of the object.
@property STMSWord2011E133 heightRule;  // Returns or sets the rule for determining the height of the specified rows.
@property double horizontalPosition;  // Returns or sets the horizontal distance between the edge of the rows.
@property (readonly) NSInteger nestingLevel;
@property STMSWord2011E236 relativeHorizontalPosition;  // Specifies to what the horizontal position of a group of rows is relative.
@property STMSWord2011E237 relativeVerticalPosition;  // Specifies to what the vertical position of a group of rows is relative.
@property double rowLeftIndent;  // Returns or sets the left indent in points for the specified rows.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with rows.
@property double spaceBetweenColumns;  // Returns or sets the distance in points between text in adjacent columns of the specified row or rows.
@property double verticalPosition;  // Returns or sets the vertical distance between the edge of the rows.
@property BOOL wrapAroundText;  // Returns or sets whether text should wrap around the specified rows. 

- (void) distributeRowHeight;  // Adjusts the height of the specified rows or cells so that they're equal.

@end

// Represents a row in a table.
@interface STMSWord2011Row : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Cell *> *) cells;

@property STMSWord2011E144 alignment;  // Returns or sets a constant that represents the alignment for the specified row.
@property BOOL allowBreakAcrossPages;  // Returns or sets if the text in a row or rows are allowed to split across a page break.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this table object.
@property BOOL headingFormat;  // Returns or sets if the specified row or rows are formatted as a table heading. Rows formatted as table headings are repeated when a table spans more than one page.
@property double height;  // Returns or sets the height of the object.
@property STMSWord2011E133 heightRule;  // Returns or sets the rule for determining the height of the specified rows.
@property (readonly) BOOL isFirst;  // Returns if the specified row is the first one in the table.
@property (readonly) BOOL isLast;  // Returns if the specified row is the last one in the table.
@property (readonly) NSInteger nestingLevel;  // Returns the nesting level of the specified row.
@property (copy, readonly) STMSWord2011Row *nextRow;  // Returns the next row object
@property (copy, readonly) STMSWord2011Row *previousRow;  // Returns the previous row object
@property (readonly) NSInteger rowIndex;  // Returns the index for the position of the object in its container element list.
@property double rowLeftIndent;  // Returns or sets the left indent in points for the specified rows.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the row object.
@property double spaceBetweenColumns;  // Returns or sets the distance in points between text in adjacent columns of the specified row or rows.  
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the portion of a document that's contained in the row object.


@end

@interface STMSWord2011TableStyle : STMSWord2011BaseObject

@property STMSWord2011E144 alignment;  // Returns or sets a constant that represents the alignment for the specified row.
@property BOOL allowBreakAccrossPage;
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this table object.
@property (copy, readonly) STMSWord2011Condition *bottomLeftCellCondition;  // Returns the conditional style for the bottom left cell.
@property double bottomPadding;  // Returns or sets the amount of space in points to add below the contents of a single cell or all the cells in a table.
@property (copy, readonly) STMSWord2011Condition *bottomRightCellCondition;  // Returns the conditional style for the bottom right cell.
@property NSInteger columnStripe;
@property (copy, readonly) STMSWord2011Condition *evenColumnCondition;  // Returns the conditional style for even column bands.
@property (copy, readonly) STMSWord2011Condition *evenRowCondition;  // Returns the conditional style for even row bands.
@property (copy, readonly) STMSWord2011Condition *firstColumnCondition;  // Returns the conditional style for the first column.
@property (copy, readonly) STMSWord2011Condition *firstRowCondition;  // Returns the conditional style for the first row.
@property (copy, readonly) STMSWord2011Condition *lastColumnCondition;  // Returns the conditional style for the last column.
@property (copy, readonly) STMSWord2011Condition *lastRowCondition;  // Returns the conditional style for the last row.
@property double leftPadding;  // Returns or sets the amount of space in points to add to the left of the contents of a single cell or all the cells in a table.
@property (copy, readonly) STMSWord2011Condition *oddColumnCondition;  // Returns the conditional style for odd column bands.
@property (copy, readonly) STMSWord2011Condition *oddRowCondition;  // Returns the conditional style for odd row bands.
@property double rightPadding;  // Returns or sets the amount of space in points to add to the right of the contents of a single cell or all the cells in a table.
@property double rowLeftIndent;  // Returns or sets the left indent in points for this table style.
@property NSInteger rowStripe;
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with this table style.
@property double spacing;  // Returns or sets the spacing between the cells in a table.
@property (copy, readonly) STMSWord2011Condition *topLeftCellCondition;  // Returns the conditional style for the top left cell.
@property double topPadding;  // Returns or sets the amount of space in points to add above the contents of a single cell or all the cells in a table.
@property (copy, readonly) STMSWord2011Condition *topRightCellCondition;  // Returns the conditional style for the top right cell.


@end

// Represents a single table.
@interface STMSWord2011Table : STMSWord2011BaseObject

- (SBElementArray<STMSWord2011Column *> *) columns;
- (SBElementArray<STMSWord2011Row *> *) rows;
- (SBElementArray<STMSWord2011Table *> *) tables;

@property BOOL allowAutoFit;  // Returns or sets if Microsoft Word will automatically resize cells in a table to fit their contents.
@property BOOL allowPageBreaks;  // Returns or sets if Microsoft Word allows to break the specified table across pages.
@property BOOL applyStyleFirstColumn;
@property BOOL applyStyleHeadingRows;
@property BOOL applyStyleLastColumn;
@property BOOL applyStyleLastRow;
@property (readonly) STMSWord2011E180 autoFormatType;  // Returns the type of automatic formatting that's been applied to the specified table.
@property (copy, readonly) STMSWord2011BorderOptions *borderOptions;  // Returns back border options object associated with this table object.
@property double bottomPadding;  // Returns or sets the amount of space in points to add below the contents of a single cell or all the cells in a table.
@property (copy, readonly) STMSWord2011ColumnOptions *columnOptions;  // Returns the column options object associated with this table object.
@property double leftPadding;  // Returns or sets the amount of space in points to add to the left of the contents of a single cell or all the cells in a table.
@property (readonly) NSInteger nestingLevel;  // Returns the nesting level of the specified table.
@property (readonly) NSInteger numberOfColumns;  // Returns the number of columns in this table
@property (readonly) NSInteger numberOfRows;  // Returns the number of rows in this table
@property double preferredWidth;  // Returns or sets the preferred width in points for the specified table.
@property STMSWord2011E290 preferredWidthType;  // Returns or sets the preferred unit of measurement to use for the width of the specified table. 
@property double rightPadding;  // Returns or sets the amount of space in points to add to the right of the contents of a single cell or all the cells in a table.
@property (copy, readonly) STMSWord2011RowOptions *rowOptions;  // Returns the row options object associated with this table object.
@property (copy, readonly) STMSWord2011Shading *shading;  // Returns the shading object associated with the table object.
@property double spacing;  // Returns or sets the spacing between the cells in a table.
@property STMSWord2011E184 style;  // Returns or sets the Word style associated with the table object.
@property (copy, readonly) STMSWord2011TextRange *textObject;  // Returns a text range object that represents the portion of a document that's contained in the table object.
@property double topPadding;  // Returns or sets the amount of space in points to add above the contents of a single cell or all the cells in a table.
@property (readonly) BOOL uniform;  // Returns if all the rows in a table have the same number of columns.

- (void) autoFitBehaviorBehavior:(STMSWord2011E288)behavior;  // Determines how Microsoft Word resizes a table when the autofit feature is used. Word can resize the table based on the content of the table cells or the width of the document window.
- (void) autoFormatTableTableFormat:(STMSWord2011E180)tableFormat applyBorders:(BOOL)applyBorders applyShading:(BOOL)applyShading applyFont:(BOOL)applyFont applyColor:(BOOL)applyColor applyHeadingRows:(BOOL)applyHeadingRows applyLastRow:(BOOL)applyLastRow applyFirstColumn:(BOOL)applyFirstColumn applyLastColumn:(BOOL)applyLastColumn autoFit:(BOOL)autoFit;  // Applies a predefined look to a table.
- (STMSWord2011TextRange *) convertToTextSeparator:(STMSWord2011E177)separator nestedTables:(BOOL)nestedTables;  // Converts a table to text and returns a text range object that represents the delimited text.
- (STMSWord2011Cell *) getCellFromTableRow:(NSInteger)row column:(NSInteger)column;  // Returns a cell object that represents a cell in a table.
- (STMSWord2011Table *) splitTableRow:(NSInteger)row;  // Inserts an empty paragraph immediately above the specified row in the table, and returns a table object that contains both the specified row and the rows that follow it.
- (void) updateAutoFormat;  // Updates the table with the characteristics of a predefined table format. For example, if you apply a table format with auto format and then insert rows and columns, the table may no longer match the predefined look.

@end

#pragma clang diagnostic pop
