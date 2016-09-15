//
//  StatTagWord2011AutomationTests.m
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

/*
 
 http://robnapier.net/scripting-bridge
 
 */

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagWord2011AutomationTests : XCTestCase {
  STMSWord2011Application* app;
  STMSWord2011Document* doc;
}

@end

@implementation StatTagWord2011AutomationTests

- (void)setUp {
  [super setUp];
  
  app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  doc = [app activeDocument];

}

- (void)tearDown {
  [super tearDown];
}

-(void)testAppleScriptBridge {
  //[WordHelpers TestAppleScript];
  NSLog(@"find : %hhd", [WordHelpers FindText:@"asdfx" inRange:[doc createRangeStart:[[doc textObject] startOfContent] end:([[doc textObject] endOfContent])]]);
}

-(void)testWordAPI_ExecuteFind {
  
  //https://www.macosxautomation.com/applescript/apps/errata.html
  //http://appscript.sourceforge.net/asoc.html
  //http://stackoverflow.com/questions/25984559/objective-c-scripting-bridge-and-apple-remote-desktop
  //http://burnignorance.com/iphone-development-tips/call-apple-script-function-handler-from-cocoa-application/
  //http://stackoverflow.com/questions/16529800/pass-variable-or-string-from-os-x-cocoa-app-to-applescript
  //ftp://ftp.mactech.com/pri/article-submissions/07-ArticleGalleysToReview/!Archived%20Files/old%20versions%20of%20VBA%20guide/23.04%20VBA-Chapter%203.pdf
  //https://discussions.apple.com/thread/2642843?tstart=0
  //https://en.wikibooks.org/wiki/AppleScript_Programming/Sample_Programs/MS_Word_2008
  //http://stackoverflow.com/questions/14040096/office-mac-2011-how-to-create-a-new-word-document-and-save-it-with-applescript
  //http://macscripter.net/viewtopic.php?id=41958
  //http://www.satimage.fr/software/en/smile/computing/as_types/as_data_types.html
  //http://stackoverflow.com/questions/26935431/why-cant-i-add-these-two-strings-together
  //http://macscripter.net/viewtopic.php?pid=146835#p146835
  //http://macscripter.net/viewtopic.php?id=30478
  //http://pastebin.com/NJ6cG9BF
  //https://discussions.apple.com/thread/2642843?tstart=0
  //http://uchcode.github.io/2015/09/27/01.html

  STMSWord2011TextRange* range = [doc textObject];
  STMSWord2011Find *find = [range findObject];
  NSLog(@"BEGINNING: range -> start: %ld, end : %ld, content : %@", (long)[range startOfContent], (long)[range endOfContent], [range content]);
  
  BOOL really;
  STMSWord2011EFRt resultWorked;
  /*
   STMSWord2011EFRtTextRange = '\003\036\000\000',
   STMSWord2011EFRtInsertionPoint = '\003\036\000\001'
   */
  
  NSString* theText = @"<test field>";

  @try
  {
    
    resultWorked = [find executeFindFindText:theText
                    matchCase:YES
               matchWholeWord:YES //?
               matchWildcards:NO
              matchSoundsLike:NO
            matchAllWordForms:NO
                 matchForward:YES
                     wrapFind:STMSWord2011E265FindStop
                   findFormat:NO
                  replaceWith:@""
                      replace:STMSWord2011E273ReplaceNone];
    
//[result executeFindFindText:text matchCase:true matchWholeWord:false matchWildcards:false matchSoundsLike:false matchAllWordForms:false matchForward:true wrapFind:STMSWord2011E265FindStop findFormat:false replaceWith:@"" replace:STMSWord2011E273ReplaceNone]
    
//      [find executeFindFindText:@"FirstText"
//                         matchCase:YES
//                    matchWholeWord:YES
//                    matchWildcards:YES
//                   matchSoundsLike:NO
//                 matchAllWordForms:NO
//                      matchForward:YES
//                          wrapFind:STMSWord2011E265FindContinue
//                        findFormat:NO
//                       replaceWith:@"SecondText"
//                           replace:STMSWord2011E273ReplaceAll];
    
  }
  @catch(NSException * e)
  {
    NSLog(@"exception : %@", [e description]);
  }
  @finally
  {
  }

  NSLog(@"really : %hhd", really);
  NSLog(@"resultWorked : %u", resultWorked);
  NSLog(@"FOUND : %hhd", [find found]);
  NSLog(@"ENDING: range -> start: %ld, end : %ld, content : %@", (long)[range startOfContent], (long)[range endOfContent], [range content]);

  
}

-(void)testWordAPI_FieldInsert {
  //- (void) createNewFieldTextRange:(STMSWord2011TextRange *)textRange fieldType:(STMSWord2011E183)fieldType fieldText:(NSString *)fieldText preserveFormatting:(BOOL)preserveFormatting;  // Create a new field

  NSString* theText = @"<test field>";
  
//  STMSWord2011TextRange* aRange = [doc createRangeStart:[[doc textObject] startOfContent] end:([[doc textObject] startOfContent] + [theText length])];


  STMSWord2011TextRange* aRange = [doc createRangeStart:0 end:0];
  
//  NSLog(@"aRange -> start: %ld, end : %ld, content : %@", (long)[aRange startOfContent], (long)[aRange endOfContent], [aRange content]);
  
  STFieldCreator* creator = [[STFieldCreator alloc] init];
  NSArray<STMSWord2011Field*>* fields = [creator InsertField:aRange theString:theText];
  NSLog(@"fields count : %lu, values : %@", (unsigned long)[fields count], fields);
  
//  [app createNewFieldTextRange:aRange fieldType:STMSWord2011E183FieldEmpty fieldText:@"sample field" preserveFormatting:false];
//  STMSWord2011Field* firstField = [app fields]
  
}

-(void)testWordAPI_Range {
  
  STMSWord2011Field* firstField = [[doc fields] firstObject];
  if(firstField != nil) {
    
    NSLog(@"firstField fieldText : %@", [firstField fieldText]);
    
    STMSWord2011TextRange* range = [firstField fieldCode];//which is a range...
    NSLog(@"range content : %@", [range content]);
    NSLog(@"range start : %ld , end : %ld", (long)[range startOfContent], (long)[range endOfContent]);
    
    STMSWord2011TextRange* rangeCopy = [doc createRangeStart:[range startOfContent] end:[range endOfContent]];
    
    NSLog(@"range: (%@), rangeCopy: (%@)", NSStringFromClass([range class]), NSStringFromClass([rangeCopy class]));

    NSLog(@"rangeCopy == range : %hhd", [rangeCopy isEqual:range]);
    NSLog(@"rangeCopy content : %@", [rangeCopy content]);
    NSLog(@"rangeCopy start : %ld , end : %ld", (long)[rangeCopy startOfContent], (long)[rangeCopy endOfContent]);
    
    NSLog(@"Properties same? %hhd", [[range properties] isEqualToDictionary: [rangeCopy properties]]);
    NSLog(@"range properties : %@", [range properties]);
    NSLog(@"rangeCopy properties : %@", [rangeCopy properties]);

    [rangeCopy select];
    //go look...
    
  } else {
    NSLog(@"field is nil");
  }
  

  
}

- (void)testStringFunction {
  NSLog(@"'%@' length : %d", @"", [self getLengthForString:@""]);
  
  NSString* text = @"abc";
  NSLog(@"'%@' length : %d", text, [self getLengthForString:text]);

  text = @"";
  NSLog(@"'%@' length : %d", text, [self getLengthForString:text]);

  
}

- (int)getLengthForString:(NSString*)text {
  return [text length];
}

- (void)testExample {

  //STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  NSLog(@"app : %@", app);

  NSLog(@"app -> isRunning : %hhd", [app isRunning]);
  
  //STMSWord2011Document* doc = [app activeDocument];
  NSLog(@"doc : %@", doc);
  
  NSLog(@"doc -> fullname : %@", [doc fullName]);
  NSLog(@"doc -> variables (count) : %lu", (unsigned long)[[doc variables] count]);
  NSLog(@"doc -> variables : %@", [doc variables]);

  STDocumentManager* manager = [[STDocumentManager alloc] init];
  
  [manager LoadCodeFileListFromDocument:doc];
  NSLog(@"GetCodeFileList : %@", [manager GetCodeFileList]);
  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];
  NSLog(@"GetCodeFileList : %@", [manager GetCodeFileList]);
  
  NSLog(@"GetTags : %@", [manager GetTags]);
  
  STStatsManager* stats = [[STStatsManager alloc] init:manager];
  for(STCodeFile* cf in [manager GetCodeFileList]) {
    NSLog(@"codeFile content: %@", [cf Content]);
    NSLog(@"original codeFile tags");
    NSLog(@"======================");
    for(STTag* tag in [cf Tags]) {
      NSLog(@"original codeFile tag -> name: %@, type: %@", [tag Name], [tag Type]);
      NSLog(@"original codeFile tag -> formatted result: %@", [tag FormattedResult]);
    }
    
    //STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf];
    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
    
    //[STConstantsParserFilterMode ExcludeOnDemand]
    
    NSLog(@"new codeFile tags");
    NSLog(@"======================");
    for(STTag* tag in [cf Tags]) {
      NSLog(@"new codeFile tag -> name: %@, type: %@", [tag Name], [tag Type]);
      NSLog(@"new codeFile tag -> formatted result: %@", [tag FormattedResult]);
    }

    
    NSLog(@"result length : %lu", (unsigned long)[[result UpdatedTags] count]);
    for(STTag* tag in [result UpdatedTags]) {
      NSLog(@"tag -> name: %@, type: %@", [tag Name], [tag Type]);
      NSLog(@"tag -> formatted result: %@", [tag FormattedResult]);
      //FormattedResult
    }
    
  }
  
}


-(void)testWordAPI_UpdateTagFieldsFromCodeFile {
  //InsertFieldWithFieldTag
  
  //go read this about field codes
  //https://groups.google.com/forum/#!msg/microsoft.public.mac.office.word/jzksDl1ebCw/YGddKCkIJdYJ
  
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];
  
  [manager GetTags];
  
  STStatsManager* stats = [[STStatsManager alloc] init:manager];
  for(STCodeFile* cf in [manager GetCodeFileList]) {
    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
  }

  [manager UpdateFields];
  
}

-(void)testWordAPI_InsertTagFieldsFromCodeFile {
  
  STDocumentManager* manager = [[STDocumentManager alloc] init];

  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];
  
  [manager GetTags];
  
  for(STTag* tag in [manager GetTags]) {
    NSLog(@"original codeFile tag -> name: %@, type: %@", [tag Name], [tag Type]);
    NSLog(@"original codeFile tag -> formatted result: %@", [tag FormattedResult]);
    [manager InsertField:tag];
  }

//  for(STMSWord2011Field* f in [doc fields]) {
//    NSLog(@" ");
//    NSLog(@"field : %@", [[f fieldCode] content]);
//    NSLog(@"field text : %@", [f fieldText]);
//  }
  
//  STStatsManager* stats = [[STStatsManager alloc] init:manager];
//  for(STCodeFile* cf in [manager GetCodeFileList]) {
//    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
//  }
//  [manager UpdateFields];


  for(STMSWord2011Field* field in [doc fields]) {
    //[field toggleShowCodes];
    field.showCodes = ![field showCodes];
    field.showCodes = ![field showCodes];
  }

  
}

-(void)testWordAPI_InsertTagField {
  //InsertFieldWithFieldTag
  
  //go read this about field codes
  //https://groups.google.com/forum/#!msg/microsoft.public.mac.office.word/jzksDl1ebCw/YGddKCkIJdYJ
  
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  
  STCommandResult* result = [[STCommandResult alloc] init];
  result.ValueResult = @"10.0";
  
  STTag* tag = [[STTag alloc] init];
  tag.Type = [STConstantsTagType Value];
  tag.Name = @"my test tag";
  tag.CachedResult = [[NSMutableArray<STCommandResult*> alloc] initWithObjects:result, nil];
  
  [manager InsertField:tag];
  
  
  
  
}



-(void)testSaveCodeFileListToDocument {
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  
  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];

//  for(STCodeFile* cf in [manager GetCodeFileList]) {
//    NSLog(@"codeFile content: %@", [cf Content]);
//  }
  
  NSLog(@" ");
  NSLog(@"SAVING variable list");
  NSLog(@"=====================");
  [manager SaveCodeFileListToDocument:doc];
  
  NSLog(@" ");
  NSLog(@"LOADING variable list");
  NSLog(@"=====================");
  [manager LoadCodeFileListFromDocument:doc];
  
}

-(void)testDocumentVariablesWithASOC {

  SBElementArray<STMSWord2011Variable*>* variables = [doc variables];

  NSLog(@" ");
  NSLog(@"original collection...");
  NSLog(@"=====");
  for(STMSWord2011Variable* v in variables) {
    NSLog(@"collection var name : '%@' with value : '%@'", [v name], [v variableValue]);
  }
  
  NSString* ConfigurationAttribute = @"StatTag Configuration";
  [WordHelpers createOrUpdateDocumentVariableWithName:ConfigurationAttribute andValue:@"test value"];
  NSLog(@"CREATED variable");

  NSLog(@" ");
  NSLog(@"updated collection...");
  NSLog(@"=====");
  for(STMSWord2011Variable* v in variables) {
    NSLog(@"collection var name : '%@' with value : '%@'", [v name], [v variableValue]);
  }

  STMSWord2011Variable* variable = [variables objectWithName:ConfigurationAttribute];
  NSLog(@"FOUND variable name : '%@' with value : '%@'", [variable name], [variable variableValue]);
  [variables removeObject:variable]; //can we do this?
  NSLog(@"deleted variable...");

  NSLog(@" ");
  NSLog(@"AFTER deleted collection...");
  NSLog(@"=====");
  for(STMSWord2011Variable* v in variables) {
    NSLog(@"UPDATED collection var name : '%@' with value : '%@'", [v name], [v variableValue]);
  }

  NSLog(@" ");
  NSLog(@"about to recreate existing variable");
  [WordHelpers createOrUpdateDocumentVariableWithName:ConfigurationAttribute andValue:@"recreated test value"];
  NSLog(@"just recreate variable");
  NSLog(@"RECREATED variable name : '%@' with value : '%@'", [variable name], [variable variableValue]);

  
  NSLog(@" ");
  NSLog(@"about to update existing variable");
  [WordHelpers createOrUpdateDocumentVariableWithName:ConfigurationAttribute andValue:@"updated test value"];
  NSLog(@"just updated variable");
  NSLog(@"UPDATED variable name : '%@' with value : '%@'", [variable name], [variable variableValue]);

  
  
}

-(void)testDocumentVariables {
  NSString* ConfigurationAttribute = @"StatTag Configuration";
  SBElementArray<STMSWord2011Variable*>* variables = [doc variables];
  for(STMSWord2011Variable* v in variables) {
    NSLog(@"collection var name : '%@' with value : '%@'", [v name], [v variableValue]);
  }
  
  STMSWord2011Variable* variable = [variables objectWithName:ConfigurationAttribute];
  NSLog(@"Found FIXED variable name : '%@' with value : '%@'", [variable name], [variable variableValue]);

//  variable = nil;
  
  if(variable == nil || [variable name] == nil) {

    NSLog(@"variable is nil - creating a new variable");
    STMSWord2011Variable *var = [[[app classForScriptingClass:@"variable"] alloc] initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"name", ConfigurationAttribute, @"value", @"test value", nil]];
    [[doc variables] addObject:var];
  } else {
    NSLog(@"variable NOT nil - keep what we have");
  }
  
  
//  STMSWord2011Variable *var2 = [[doc variables] lastObject];
  
//  STMSWord2011Variable* var = [[STMSWord2011Variable alloc] initWithProperties:@{
//                                                @"name" : @"test",
//                                                @"variableValue" : @"value"}];

//  NSLog(@"temp var name : '%@' with value : '%@'", [var2 name], [var2 variableValue]);
  
  //        [variables addObject:var];

  
}

-(void)testUpdateInlineShapesWithASOC {
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  //[WordHelpers UpdateInlineShapes:doc];
  [manager UpdateInlineShapes:doc];
  //[WordHelpers UpdateAllImageLinks];
}

-(void)testInsertInlineShapeWithASOC {
  
//  NSString* path = @"/Users/ewhitley/Desktop/word.png";
  NSString* path = @"/Users/ewhitley/Desktop/word.pdf";
//  NSString* path = @"Users:ewhitley:Desktop:word.png";

//  NSURL* theFileURL = [NSURL fileURLWithPath:path];
//  NSString* hfsPath = (NSString*)CFBridgingRelease(CFURLCopyFileSystemPath((CFURLRef)theFileURL, kCFURLHFSPathStyle));

  
//  STMSWord2011InlinePicture* shape = [[[app classForScriptingClass:@"inline picture"] alloc] initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
//           hfsPath, @"file name",
//           [NSNumber numberWithBool:YES], @"link to file",
//           [NSNumber numberWithBool:YES], @"save with document",
//          nil]];
//  [[[app selection] inlineShapes] addObject:shape];

  [WordHelpers insertImageAtPath:path];
  
  
  NSLog(@"did we add the shape?");
  NSLog(@"count : %d", [[doc inlineShapes] count]);
  
  for(STMSWord2011InlineShape* s in [doc inlineShapes]) {
    NSLog(@"path : %@", [[s linkFormat] sourceFullName]);
  }

  
//  http://answers.microsoft.com/en-us/mac/forum/macoffice2011-macword/applescript-place-an-image-behind-text/d73562c1-ca8c-4c18-9005-dfcb0182e858
  
//  filename -> some path
//  object linkToFile = true;
//  object saveWithDocument = true;
//  application.Selection.InlineShapes.AddPicture(fileName, linkToFile, saveWithDocument);

  
  
}


-(void)testTagFigureInsertWithASOC {
//          public void InsertImage(Tag tag)
  
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  
  
  STCommandResult* result = [[STCommandResult alloc] init];
  result.FigureResult = @"/Users/ewhitley/Desktop/word.png";

  STTag* tag = [[STTag alloc] init];
  tag.Name = @"test tag";
  tag.Type = [STConstantsTagType Figure];
  tag.CachedResult = [[NSMutableArray<STCommandResult*> alloc] init];

  [[tag CachedResult] addObject:result];

  NSLog(@"[[tag CachedResult] count] : %d", [[tag CachedResult] count]);
  
  [manager InsertImage:tag];
  
}


-(void)testInsertTable {
  STMSWord2011TextRange* selection = [[app selection] textObject];
  STMSWord2011Table* table = [WordHelpers createTableAtRange:selection withRows:4 andCols:3];
  NSLog(@"table rows : %d, cols : %d", [[table rows] count], [[table columns] count]);
}


-(void)testLogManager {
  STLogManager* log = [[[STGlobals sharedInstance] ThisAddIn] LogManager];

//  STLogManager* log = [[STLogManager alloc] init];
  log.Enabled = true;
  log.LogFilePath = @"~/Desktop/test/test.log";
  
  [log WriteMessage:@"adding line for log file..."];
  
  NSException *e = [NSException
                    exceptionWithName:@"StataException"
                    reason:@"Something horrible happened (not really - this is a test)"
                    userInfo:nil];
  [log WriteException:e];
  
  

  
}


-(void)testAppVersionInfo {
  
  
  NSString* version = [STCocoaUtil bundleVersionInfo];
  NSLog(@"version : %@", version);

  NSString* bundleID = [[[STGlobals sharedInstance] ThisAddIn] AppBundleIdentifier];
  NSLog(@"bundle info: %@", [STCocoaUtil getApplicationDetailsForBundleID:bundleID]);
  
}

-(void)testPreferences {
  STPropertiesManager* manager = [[STPropertiesManager alloc] init];
  
//  manager.Properties.StataLocation = @"My Stata Location";
//  manager.Properties.EnableLogging = NO;
  
//  [manager Save];
  [manager Load];
}

-(void)testInsertingParagraph {
  //-(void)InsertNewLineAndMoveDown:(STMSWord2011SelectionObject*) selection
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  [manager InsertNewLineAndMoveDown:[app selection]];
}

-(void)testAlertPanel {
  [STUIUtility WarningMessageBox:@"something went wrong" logger:nil];
}

-(void)testViewWordFieldJSON {
  //STTagManager* _TagManager = [[STTagManager alloc] init];
  
  
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  [manager AddCodeFile:@"/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/WindowsVersion/Word_Files_Working_Copies/simple-macro-test.do"];
  
  [manager GetTags];
  
  STStatsManager* stats = [[STStatsManager alloc] init:manager];
  for(STCodeFile* cf in [manager GetCodeFileList]) {
    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf filterMode:[STConstantsParserFilterMode IncludeAll]];
  }

  
  //  [manager UpdateFields];

  
  SBElementArray<STMSWord2011Field*>* fields = [doc fields];
  int fieldsCount = [fields count];
  // Fields is a 1-based index
  NSLog(@"Preparing to process %d fields", fieldsCount);
  
  int index = 0;
  for(STMSWord2011Field* field in [doc fields]) {
    NSLog(@"");
    NSLog(@"field (%d)", index);
    NSLog(@"==================");
    NSLog(@"fieldText : %@", [field fieldText]);
    
    if ([[manager TagManager] IsStatTagField:field]) {
      STFieldTag* fieldTag = [[manager TagManager] GetFieldTag:field];
      NSLog(@"fieldTag FormattedResult : %@", [fieldTag FormattedResult]);
    } else {
      NSLog(@"not a StatTag field");
    }
    //NSLog(@"serialized : %@", [STFieldTag Serialize:tag]);
    
    index++;
  }
  

  
}


-(void)testFieldEnumeration {
  [STWindowLauncher testGettingFields];
}

-(void)testASOCGetFieldText {
  
//  for(STMSWord2011Field* field in [doc fields]) {
//    NSLog(@"WordHelpers (%d) : %@",[field entry_index], [WordHelpers getFieldDataForFieldAtIndex:[field entry_index]]);
//  }
  //NSLog(@"WordHelpers %@",[WordHelpers getFieldDataForFieldAtIndex:2]);
  //+(NSString*)getFieldDataForFieldAtIndex:(int)theIndex
  
}


-(void)testWordFields {
  
  for(STMSWord2011Document* aDoc in [app documents]) {
    NSLog(@"%@", [aDoc path]);
    //path
    for(STMSWord2011Field* field in [aDoc fields]) {
      //NSLog(@"WordHelpers (%d) : %@",[field entry_index], [WordHelpers getFieldDataForFieldAtIndex:[field entry_index]]);
    }
  }
  
}

-(void)testAppleScriptToApp {
  [WordHelpers updateAllFields];
}

-(void)testXPC {
  
  [WordHelpers testService];

  
}

@end
