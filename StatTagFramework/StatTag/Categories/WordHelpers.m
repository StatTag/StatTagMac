//
//  WordHelpers.m
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "WordHelpers.h"
#import "STMSWord2011.h"
#import <StatTagFramework/StatTagFramework.h>
#import "WordASOC.h"

@implementation WordHelpers


//because we use the WordHelpers to load applescripts from the bundle, we don't want to keep loading them every time. So we're going to use a sharedInstance and just fire off the "load my applescripts" call in the init
static WordHelpers* sharedInstance = nil;
+ (instancetype)sharedInstance
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  if (self = [super init]) {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    [frameworkBundle loadAppleScriptObjectiveCScripts];
    //NSLog(@"just set our bundle shared instance");
  }
  return self;
}

+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range {
  //@autoreleasepool {
    STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
    STMSWord2011Document* doc = [app activeDocument];
    return [[self class] DuplicateRange: range forDoc:doc];
  //}
}

+(void)setRange:(STMSWord2011TextRange**)range start:(NSInteger)start end:(NSInteger)end {
  /*//@autoreleasepool {
    STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
    STMSWord2011Document* doc = [app activeDocument];
    //return [doc createRangeStart:start end:end];
    *range = [doc createRangeStart:start end:end];
  //}*/

  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];
  [WordHelpers setRange:range start:start end:end withDoc:doc];
}

+(void)setRange:(STMSWord2011TextRange**)range start:(NSInteger)start end:(NSInteger)end withDoc:(STMSWord2011Document*)doc {
  *range = [doc createRangeStart:start end:end];
}

+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range forDoc:(STMSWord2011Document*)doc {
  return [doc createRangeStart:[range startOfContent] end:[range endOfContent]];
}

+(BOOL)FindText:(NSString*)text inRange:(STMSWord2011TextRange*)range{
  BOOL found = false;
  
  /*
    OK, so why is this commented out?
   
   "find" in Word is just totally broken. Even more than noted earlier.
   
   If you have a string ">" as defined by a range
   And you are searching for string ">"
   ...you will get back FALSE
   
   So for now we're just using Obj-C string literal matching (case insensitive)
   
   */
//  //message our sharedInstance so we load applescripts (once)
//  [[self class] sharedInstance];
//  WordASOC *stuff = [[NSClassFromString(@"WordASOC") alloc] init];
//  if(text != nil) {
//    found = [[stuff findText:text atRangeStart:[NSNumber numberWithInteger:[range startOfContent]] andRangeEnd:[NSNumber numberWithInteger:[range endOfContent]]] boolValue];
//    return found;
//  }
//  return found;
  
  if([[range content] rangeOfString:text options: NSCaseInsensitiveSearch].location != NSNotFound ) {
    found = true;
  }
  
  return found;
  
}


+(void)createOrUpdateDocumentVariableWithName:(NSString*)variableName andValue:(NSString*)variableValue {
  //message our sharedInstance so we load applescripts (once)
  //@autoreleasepool {
    [[self class] sharedInstance];
    WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
    if(variableName != nil) {
      [asoc createOrUpdateDocumentVariableWithName:variableName andValue:variableValue];
    }
  //}
}


+(void)updateContent:(NSString*)text inRange:(STMSWord2011TextRange**)range {
  
  //  //- (STMSWord2011TextRange *) moveRangeBy:(STMSWord2011E129)by count:(NSInteger)count;  // Collapses the specified range to its start or end position and then moves the collapsed object by the specified number of units. This method returns the new range object or missing value if an error occurred.
  //  // -> STMSWord2011E129ACharacterItem -> characters
  if(text == nil) {
    text = @"";
  }
  
  [*range setContent: text];
  
  [WordHelpers setRange:range start:[*range startOfContent] end:([*range startOfContent] + [text length])];
}

+(void)UpdateLinkFormat:(STMSWord2011LinkFormat*)linkFormat {
  //@autoreleasepool {
    [[self class] sharedInstance];
    WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
    [asoc UpdateLinkFormat:linkFormat];
  //}
}

+(BOOL)imageExistsAtPath:(NSString*)filePath {
  if(filePath != nil) {
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
    BOOL readable = [[NSFileManager defaultManager] isReadableFileAtPath:filePath];
    if (!exists || isDir || !readable) {
      //NSLog(@"Couldn't insert image at path. isDir : %hhd, exists : %hhd, readable : %hhd", isDir, exists, readable);
      return false;
    } else {
      NSURL* theFileURL = [NSURL fileURLWithPath:filePath];
      if(theFileURL != nil)
      {
        NSImage* tempImage = [[NSImage alloc] initWithContentsOfFile:[theFileURL path]];
        if(tempImage != nil) {
          return true;
        }
      }
      //we need a better way of logging this - the entire approach to logging needs to be reviewed
      [[STLogManager sharedInstance] WriteException:[NSString stringWithFormat:@"Couldn't insert image at path. NSImage can't read file : %@", theFileURL]];
      //NSLog(@"Couldn't insert image at path. NSImage can't read file : %@", theFileURL);
      return false;

//      NSString *loweredExtension = [[theFileURL pathExtension] lowercaseString];
//      NSSet *validImageExtensions = [NSSet setWithArray:[NSImage imageTypes]];
//      if ([validImageExtensions containsObject:loweredExtension]) {
//        return true;
//      } else {
//        //NSLog(@"Couldn't insert image at path. NSImage does not support extension : %@", loweredExtension);
//        return false;
//      }
    }
  }
  return false;
}

+(BOOL)insertImageAtPath:(NSString*)filePath {
  //@autoreleasepool {
    //FIXME: we need some better error handling, etc. for all of this
    [[self class] sharedInstance];
    WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
    
    if([[self class] imageExistsAtPath:filePath]) {
      NSURL* theFileURL = [NSURL fileURLWithPath:filePath];
      NSString* hfsPath = (NSString*)CFBridgingRelease(CFURLCopyFileSystemPath((CFURLRef)theFileURL, kCFURLHFSPathStyle));
      
      //MARK: FIXME - get rid of kCFURLHFSPathStyle - we should update the AppleScript to support POSIX paths
      /*
      Leaving the above warning and commenting...
       Our AppleScript wants an HFS path - but those are not ideal and support is deprecated as of 10.9
       https://developer.apple.com/library/content/releasenotes/CoreFoundation/RN-CoreFoundation/
       
       "The use of kCFURLHFSPathStyle is deprecated. The Carbon File Manager, which uses HFS style paths, is deprecated. HFS style paths are unreliable because they can arbitrarily refer to multiple volumes if those volumes have identical volume names. You should instead use kCFURLPOSIXPathStyle wherever possible."
       
       We should probably go back and change the AppleScript, then circle back and fix this
       */
      BOOL inserted = [[asoc insertImageAtPath:hfsPath] boolValue];
      return inserted;//[[asoc insertImageAtPath:hfsPath] boolValue];
    }
  return false;
  //}
  
//  if(filePath != nil) {
//    //do more file path checking...
//    //applescript wants file paths separators as ":" instead of "/"
//    NSURL* theFileURL = [NSURL fileURLWithPath:filePath];
//
//    //NSLog(@"reading file path %@", filePath);
//    
//    BOOL isDir;
//    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
//    BOOL readable = [[NSFileManager defaultManager] isReadableFileAtPath:filePath];
//    if (!exists || isDir || !readable) {
//      //this should kick back an error
//      // 1) We can't specify a directory
//      // 2) File should exist
//      // 3) File should be readable
//      //NSLog(@"Couldn't insert image at path. isDir : %hhd, exists : %hhd, readable : %hhd", isDir, exists, readable);
//    } else {
//      //great example - http://stackoverflow.com/questions/12044450/case-insensitive-checking-of-suffix-of-nsstring
//      NSString *loweredExtension = [[theFileURL pathExtension] lowercaseString];
//      NSSet *validImageExtensions = [NSSet setWithArray:[NSImage imageFileTypes]];
//      if ([validImageExtensions containsObject:loweredExtension]) {
//        NSString* hfsPath = (NSString*)CFBridgingRelease(CFURLCopyFileSystemPath((CFURLRef)theFileURL, kCFURLHFSPathStyle));
//        [asoc insertImageAtPath:hfsPath];
//      } else {
//        //format not supported - throw error
//        //NSLog(@"Couldn't insert image at path. NSImage does not support extension : %@", loweredExtension);
//      }
//    }
//    
//  }
}

+(void)UpdateAllImageLinks {
  @autoreleasepool {
    [[self class] sharedInstance];
    WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
    [asoc UpdateAllImageLinks];
  }
}

//none of these actually work in Word - leaving them here so we know we tried
//+(void)disableScreenUpdates {
//  [[self class] sharedInstance];
//  WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
//  [asoc disableScreenUpdates];
//}
//+(void)enableScreenUpdates {
//  [[self class] sharedInstance];
//  WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
//  [asoc enableScreenUpdates];
//}

// Awful little hack... something with the way the InsertField method works returns fields
// with special characters in the embedded fields.  A workaround is toggling the fields
// to show and hide codes.
+(void)toggleAllFieldCodes {
  @autoreleasepool {
    STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
    STMSWord2011Document* doc = [app activeDocument];
    
    
    for(STMSWord2011Field* field in [doc fields]) {
      field.showCodes = NO;
      field.showCodes = NO;
      //field.showCodes = ![field showCodes];
      //field.showCodes = ![field showCodes];
    }
  }
  
}

+(void)toggleFieldCodesInRange:(STMSWord2011TextRange*)range
{
  @autoreleasepool {
    for(STMSWord2011Field* field in [range fields]) {
      field.showCodes = NO;
      field.showCodes = NO;
      //field.showCodes = ![field showCodes];
      //field.showCodes = ![field showCodes];
    }
  }
}

//http://stackoverflow.com/questions/37239287/cocoa-scripting-returning-the-cloned-objects-from-a-duplicate-command/37251569#37251569
//http://stackoverflow.com/questions/1247013/how-to-extract-applescript-data-from-a-nsappleeventdescriptor-in-cocoa-and-parse
//http://stackoverflow.com/questions/6804541/getting-applescript-return-value-in-obj-c

+(STMSWord2011Table*)createTableAtRange:(STMSWord2011TextRange*)range withRows:(NSInteger)rows andCols:(NSInteger)cols {
  //@autoreleasepool {

    [[self class] sharedInstance];
    WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
    BOOL created_table = [[asoc createTableAtRangeStart:[NSNumber numberWithInteger:[range startOfContent]] andRangeEnd:[NSNumber numberWithInteger:[range endOfContent]] withRows:[NSNumber numberWithInteger:rows] andCols:[NSNumber numberWithInteger:cols]] boolValue];

    // If we created a table, get the reference to it.  The range in which we created the table will have the table within its
    // tables collection.  We will pull back the last one, assuming that there really is only 1 in here.
    if(created_table) {
      STMSWord2011Table* table = [[range tables] lastObject];
      return table;
    }

    return nil;
  //}

  /*
   tried alternatives to doing this in AppleScript
   
   1) SB to call into "initWithProperties" and add to tables - didn't work
   2) random "be lazy" and try to message over the type to SB directly, hoping it would infer types - nope
   3) tried to see if we could be really really lazy and just throw NSData at the object... nope.
   
   So - going to AppleScript it is...
   
   */

  //nope
  //  NSAppleEventDescriptor* result = [asoc createTableAtRange:range withRows:[NSNumber numberWithInteger:rows] andCols:[NSNumber numberWithInteger:cols]];
  //  NSData *data = [result data];
  //  STMSWord2011Table* myTable;
  //  [data getBytes:&myTable length:[data length]];
  //  //NSLog(@"table class kind : %@", NSStringFromClass([table class]));
  
  
  
  //try as I might... adding objects... just can't get it to work.
  // the object never seems to be added...
  
//  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
//  STMSWord2011Document* doc = [app activeDocument];
//  
//  STMSWord2011Table *table = [[[app classForScriptingClass:@"table"] alloc]
//                              initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                  range, @"text object",
//                                                  [NSNumber numberWithInteger:rows], @"number of rows",
//                                                  [NSNumber numberWithInteger:cols], @"number of columns",
//                                                  nil]];
//  if(table) {
//    [[doc tables] addObject:table];
////    //NSLog(@"test string something %d", [[[table rows] get] count]);
////    //NSLog(@"table has rows : %d, columns : %d", [[table rows] count], [[table columns] count]);
//    //STMSWord2011Table *thisTable = [[[doc tables] lastObject] get];
//    
//    //return thisTable;
//    return table;
//  }
//  
//  return nil;
  
}

+(BOOL)insertParagraphAtRange:(STMSWord2011TextRange*)range {
  //@autoreleasepool {
    [[self class] sharedInstance];
    WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
    BOOL inserted_paragraph = [[asoc insertParagraphAtRangeStart:[NSNumber numberWithInteger:[range startOfContent]] andRangeEnd:[NSNumber numberWithInteger:[range endOfContent]]] boolValue];
    return inserted_paragraph;
  //}
}


+(BOOL)updateAllFields {
  //@autoreleasepool {
    [[self class] sharedInstance];
    WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
    return [[asoc updateAllFields] boolValue];
  //}
}

+(void)select:(STMSWord2011BaseObject*)wordObject {
  @autoreleasepool {
    //Word 2011 supports the "select" method - 2016 does NOT - it was removed
    if([wordObject respondsToSelector:@selector(select)]){
      // 2011...
      //if ([wordObject respondsToSelector:@selector(fieldCode)]) {
      //  STMSWord2011Field* field = (STMSWord2011Field*)wordObject;
        //STMSWord2011TextRange* tr = [field fieldCode];
        //NSLog(@"WordHelpers - select (%ld,%ld)", [tr startOfContent], [tr endOfContent]);
      //}
      [wordObject select];
      
      //STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
      //NSLog(@"WordHelpers - selection (%ld,%ld)", [[app selection] selectionStart], [[app selection] selectionEnd]);
    }
    else {
      // 2016...
      //
      // We're really really really prefer to use "isKindOfClass" but when we message "class" on an SBObject
      //   we run into issues with the compiler at runtime - something to do with scripting bridge and proxy objects
      //   when we refer to the type
      //
      // Instead, we're going to get a handle on the instance class (which we can check for type). Then we're just
      //   going to do a string comparison against the known class (names) we want to 'select'
      //
      // Our class types do NOT match the emitted sdef class names - they use the raw internal Word class names
      //   (Check the script editor)
      //
      // We then just (try...) to cast the type and approximate the previous (2011) selection
      //
      // There may be a better way to do this with Obj-C. Not clear to me if that's the case.
      NSString* woClass = NSStringFromClass([wordObject class]);
      ////NSLog(@"className : %@", woClass);
      
      if([woClass isEqualToString:@"MicrosoftWordField"]) {
        //field requires we offset the start/end character positions because they use escape sequences
        // to indicate field start "{" and field end "}" - when you select the content, those escape characters
        // aren't included
        STMSWord2011Field* field = (STMSWord2011Field*)wordObject;
        STMSWord2011TextRange* tr = [field fieldCode];
        //NSLog(@"WordHelpers - select (%ld,%ld)", [tr startOfContent], [tr endOfContent]);
        if(tr != nil) {
          NSInteger start = [tr startOfContent];
          NSInteger end = [tr endOfContent] + 1;
          if(start > 0) {
            start = start - 1;
          }
          //NSLog(@"WordHelpers - select: (MicrosoftWordField) tr (%ld,%ld)", [tr startOfContent], [tr endOfContent]);

          [WordHelpers selectTextAtRangeStart:start andEnd:end];
        }
      } else if ([woClass isEqualToString:@"MicrosoftWordTable"]) {
        //table
        STMSWord2011Table* table = (STMSWord2011Table*)wordObject;
        STMSWord2011TextRange* tr = [table textObject];
        [WordHelpers selectTextInRange:tr];
      } else if ([woClass isEqualToString:@"MicrosoftWordTextRange"]) {
        //text range
        STMSWord2011TextRange* tr = (STMSWord2011TextRange*)wordObject;

        //NSLog(@"WordHelpers - select: (MicrosoftWordTextRange) tr (%ld,%ld)", [tr startOfContent], [tr endOfContent]);
        [WordHelpers selectTextInRange:tr];
      }
    }
  }
}

+(void)selectTextAtRangeStart:(NSInteger)rangeStart andEnd:(NSInteger)rangeEnd {
  @autoreleasepool {
    STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
    // This duplicate setting of the selection range is done to handle selection ranges across table cells.
    // Imagine you have two table cells Left and Right.  The cursor is in Right, and this method is being
    // called to select a range of text that is entirely within Left.  When we get the current selection,
    // the start and end positions represent the same spot - the cursor.  When we make the call to change
    // selectionStart, Word treats it as if we were dragging the cursor all the way over from the current
    // cursor position in the Right cell to the position in the Left cell.  You'll notice that when you
    // drag your cursor in Word, what happens is once you cross that table cell boundary it selects the entire
    // cell of both Left and Right.  So now the selection represents these two cells.  When we call to set
    // the selectionEnd, it moves the selection to the end position within the Left cell.  The problem is that
    // because it had the entire Left cell selected (and so the selectionStart position gets reset to the
    // beginning of the Left cell) it ends up selecting all the text in the cell.  This means we have a lot
    // more text selected than we actually wanted.
    // To address this, if we know we are probably crossing cell boundaries - detected if the selection we
    // start with is in a cell - we will call the selection twice.  The second call to set the selectionStart
    // and selectionEnd will work as expected, since we are doing it within the cell where the range is located.
    STMSWord2011SelectionObject* selection = [app selection];
    if ([[selection cells] count] > 0) {
      selection.selectionStart = rangeStart;
      selection.selectionEnd = rangeEnd;
      selection = [app selection];
    }
    selection.selectionStart = rangeStart;
    selection.selectionEnd = rangeEnd;
  }
}

+(void)selectTextInRange:(STMSWord2011TextRange*)textRange {
  //@autoreleasepool {
    if(textRange != nil) {
      [self selectTextAtRangeStart:[textRange startOfContent] andEnd:[textRange endOfContent]];
    }
  //}
}

+(void)setActiveDocumentByDocName:(NSString*)theName {
  [[self class] sharedInstance];
  WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
  if(theName != nil) {
    [asoc setActiveDocumentByDocName:theName];
  }
}

+(NSString*)getActiveDocumentName {
  //@autoreleasepool {
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];
  return [doc name];
}


+(void)insertTextboxAtRangeStart:(NSInteger)theRangeStart andRangeEnd:(NSInteger)theRangeEnd forShapeName:(NSString*)shapeName withShapetext:(NSString*)shapeText andFontSize:(double)fontSize andFontFace:(NSString*)fontFace
{
  [[self class] sharedInstance];

  /*
   Why are we replacing the \r\n's with \n?
   When we send the text over to AppleScript (again - because of Word issues), AppleScript has to count the # of characters - which includes the line breaks and carriage returns in order to calculate the incoming text size. We then extend the text selection to that length (which should… ideally… be the length of the verbatim result.) Turns out - there are issues. The “\r\n” are counted. BUT when we insert the text, “\r\n” is converted to a single line feed character. So - for every “\r\n” in the original text we’re losing _one_ character - because it’s replaced with (linefeed). So - we’re slowly eating away at the following text. For each missing “\r” we eat one character by incorrectly extended the text range into the subsequent content.
   */
  shapeText = [shapeText stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
  
  WordASOC *asoc = [[NSClassFromString(@"WordASOC") alloc] init];
  [asoc insertTextboxAtRangeStart:[NSNumber numberWithInteger:theRangeStart] andRangeEnd:[NSNumber numberWithInteger:theRangeEnd] forShapeName:shapeName withShapetext:shapeText andFontSize:[NSNumber numberWithDouble:fontSize] andFontFace:fontFace];
}

@end
