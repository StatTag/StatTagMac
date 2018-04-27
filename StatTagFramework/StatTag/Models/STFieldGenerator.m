//
//  STFieldGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 7/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

/*
 
 NOTE: this is placeholder code.
 
 The original c# could do things in Word that the Mac version simply can't
 
 * Find is broken
 * Ranges don't "self adjust" as other ranges are changed
 * The "delete" method doesn't exist
 
 That's just to start
 
 The entire approach isn't particularly good. It needs to be refactored.

 */
 
#import "STFieldGenerator.h"
#import "StatTagFramework.h"
#import "WordHelpers.h"

@implementation STFieldGenerator

-(instancetype)init {
  self = [super init];
  if(self) {
  }
  return self;
}


+(NSString*)FieldOpen {
  return @"<<||$$";
  //return @"\U000E0053";
  //return @"<";
}
+(NSString*)FieldClose {
  return @"$$||>>";
  //return @"\U000E0054";
  //  return @">";
}


/**
 Insert a StatTag nested field at the document range specified in the parameters.
*/
+(void)GenerateField:(STMSWord2011TextRange*)range tagIdentifier:(NSString*)tagIdentifier displayValue:(NSString*)displayValue tag:(STFieldTag*)tag
{
  
  //-(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen fieldClose:(NSString*)fieldClose

  //  InsertField(range, string.Format("{3}MacroButton {0} {1}{3}ADDIN {2}{4}{4}",
  //Constants.FieldDetails.MacroButtonName,
  //displayValue,
  //tagIdentifier,
  //FieldOpen,
  //FieldClose));
  @autoreleasepool {
//    NSArray<STMSWord2011Field*>* fields = [[self class] InsertField:range theString:[NSString stringWithFormat:@"%@MacroButton %@ %@%@ADDIN %@%@%@", [self FieldOpen], [STConstantsFieldDetails MacroButtonName], [[self class] escapeMacroContent:displayValue] , [self FieldOpen], tagIdentifier, [self FieldClose], [self FieldClose] ]];

    NSArray<STMSWord2011Field*>* fields = [[self class] InsertField:range displayValue:[STFieldGenerator escapeMacroContent:displayValue] macroButtonName:[STConstantsFieldDetails MacroButtonName] tagIdentifier:tagIdentifier withDoc:nil];

    
    STMSWord2011Field* dataField = [fields firstObject];
    dataField.fieldText = [tag Serialize:nil];
    
    // This is a terrible hack, I know, but it's the only way I've found to get fields
    // to appear correctly after doing this insert.
    //[WordHelpers toggleFieldCodesInRange:range];
    [STDocumentManager toggleWordFieldsForTag:tag];    
  }
}

+(NSString*)escapeMacroContent:(NSString*)content
{
  
//  NSError *error = nil;
//  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([\"{}><])" options:NSRegularExpressionCaseInsensitive error:&error];
//  NSString *modifiedString = [regex stringByReplacingMatchesInString:content options:0 range:NSMakeRange(0, [content length]) withTemplate:@"\\\\$1"];

  return content;
}

+(void)offsetAllRanges:(NSMutableArray<STMSWord2011TextRange*>*)ranges EndsBy:(NSInteger)removeEnd {
  @autoreleasepool {
    for (NSInteger index = 0; index < [ranges count] ; index++) {
      STMSWord2011TextRange* range = [ranges objectAtIndex:index];
      if(([range endOfContent] - removeEnd) > 0 && [range startOfContent] != [range endOfContent]) {
        ////NSLog(@"OFFSETTING range -> ( %ld, %ld) content : %@", (long)[range startOfContent], (long)[range endOfContent], [range content]);
        ////NSLog(@"trying to set end to %d", [range endOfContent] - removeEnd);
        [WordHelpers setRange:&range start:[range startOfContent] end:([range endOfContent] - removeEnd)];
        [ranges replaceObjectAtIndex:index withObject:range];
        
        ////NSLog(@"OFFSETTING range -> ( %ld, %ld) content : %@", (long)[range startOfContent], (long)[range endOfContent], [range content]);
      }
    }
  }
}

/**
 Inserts a StatTag field into the document
 
 This is a replacement for the original field insertion method. Please read notes below on why we're mixing field insertion methods.
 
 Method inserts a field into Word then inserts an inner field within that field.
 */
+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range displayValue:(NSString*)displayValue macroButtonName:(NSString*)macroButtonName tagIdentifier:(NSString*)tagIdentifier withDoc:(STMSWord2011Document*)doc
{
  if (doc == nil) {
    STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
    doc = [app activeDocument];
  }
  if(displayValue == nil)
  {
    displayValue = @"";
  }
  if(macroButtonName == nil)
  {
    displayValue = [STConstantsFieldDetails MacroButtonName];
  }
  if(tagIdentifier == nil)
  {
    displayValue = @"";
  }
  
//=================================
  NSString* formattedValue = [NSString stringWithFormat:@"%@ %@", macroButtonName, displayValue];
  //NOTE NOTE NOTE
  /*We're using our custom AppleScript wrapper for "create new field" because we can insert a field at a specific point in a range and it will NOT overwrite the original content. Why are we using the wrapper insted of the original Obj-C interface to the AppleScript method?
  
   For some reason we cannot specify the macro button text if we do so (and we need macro button text for identifying a StatTag field). When we attempt to send in a string which should be automatically split into the button text and button label the Obj-C method instead inserts the entire string into the label. EX: "StatTag 16.5" should be split into the macro button text ("StatTag") and the display value ("16.5"), but instead the button text is left empty and the display label is set to "StatTag 16.5" (not desired).
   */
  NSInteger originalRangeStart = [range startOfContent];  // This can change after calling insertFieldAtRangeStart, so save it off
  [WordHelpers insertFieldAtRangeStart:[range startOfContent] andRangeEnd:[range endOfContent] forFieldType:STMSWord2011E183FieldMacroButton withText:formattedValue];

  // After inserting the field, different things can happen to our range.  If the range size is the same value,
  // that means it probably got inserted into a table cell, and isn't updated to reflect the range of content.
  // We will then use the formattedValue length to determine the range and set the selection.  Otherwise, we
  // trust the range and set it back 1 character to pick up the field we just created.  This range is really
  // just used to detect the field we inserted, since we have no other way to get that back from AppleScript.
  if ([range endOfContent] != [range startOfContent]) {
    [WordHelpers selectTextAtRangeStart:([range endOfContent] -1) andEnd:([range endOfContent])];
  }
  else {
    [WordHelpers selectTextAtRangeStart:(originalRangeStart) andEnd:(originalRangeStart + [formattedValue length])];
  }

  STMSWord2011Application* wordApp = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011SelectionObject* aSelection = [wordApp selection];

  STMSWord2011Field* outerField = [[aSelection fields] firstObject];
  
  STMSWord2011TextRange* outerRange = [outerField resultRange];
  
  NSInteger selectionStart = [range startOfContent];
  NSInteger selectionEnd = [outerRange endOfContent];
  
  if(outerField)
  {
    
    STMSWord2011TextRange* innerRange = [WordHelpers DuplicateRange:outerRange];    
    [WordHelpers setRange:&innerRange start:([outerRange endOfContent] - 1) end:([outerRange endOfContent] - 1) withDoc:doc];

    [outerField setShowCodes:YES];
    
    //we need to now move our cursor based on the existing selection so we can insert the nested field
    //we had all sorts of issues with inserting fields within fields when inside of text boxes
    //this isn't particularly elegant, but it seems to work
    //the challenge is that the shape has its own concept of range start/end, so if we try to explicitly set the range (as we were doing before) we wind up using the _document_ range and our nested field goes off into the nether nether
    //by explicitly retainin the selection and simply offsetting the existng selection by a certain number of characters we can use the relative position for the field insertion and everything seems to be happy
    //move the start position to the end of the field text range - 1 - so we retain our brace "}"
    //do the same thing with the end
    // right now we should be just before the ending brace of the field
    STMSWord2011TextRange* selectionRange = [[wordApp selection] textObject];
    long offsetCount = [selectionRange endOfContent] - [selectionRange startOfContent] - 1;
    [selectionRange moveStartOfRangeBy:STMSWord2011E129ACharacterItem count:offsetCount];
    [selectionRange moveEndOfRangeBy:STMSWord2011E129ACharacterItem count:-1];
        
    //NOTE NOTE NOTE
    //Here we're using the Obj-C method to create a field and NOT our custom AppleScript wrapper. Why? When we use our AppleScript wrapper we cannot seem to insert a field within a field. For some reason if we attempt to insert a field within a range that's contained within a field it simply overwrites the entire field. In testing, this method lets us insert a nested field within a pre-existing field's range (which we need for StatTag fields)
//    [wordApp createNewFieldTextRange:innerRange fieldType:STMSWord2011E183FieldAddin fieldText:tagIdentifier preserveFormatting:NO];
    [wordApp createNewFieldTextRange:selectionRange fieldType:STMSWord2011E183FieldAddin fieldText:tagIdentifier preserveFormatting:NO];

    selectionEnd = [selectionRange endOfContent] + 1;
  }
  
  [WordHelpers selectTextAtRangeStart:selectionStart andEnd:selectionEnd];
  aSelection = [wordApp selection];
  
  for(STMSWord2011Field* f in [aSelection fields])
  {
    [f setShowCodes:NO];
  }
  
  return [aSelection fields];

}

//
///**
// Adds one or more new Word.Field to the specified Word.Range.
// 
// This method allows to insert nested fields at the specified range.
// 
// @code
// <c>InsertField(Application.Selection.Range, {{= {{PAGE}} - 1}};</c>
// will produce
// { = { PAGE } - 1 }
// @endcode
// 
// @param range: The Word.Range where to add the Word.Field.
// @param theString: The string to convert to one or more Word.Field objects.
// @param fieldOpen: The special code to mark the start of a Word.Field.
// @param fieldClose">The special code to mark the end of a Word.Field.
// @returns The newly created Word.Field
// 
// @remark A solution for VBA has been taken from [this](http://stoptyping.co.uk/word/nested-fields-in-vba)
// article and adopted for C# by the author.
//*/
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen fieldClose:(NSString*)fieldClose withDoc:(STMSWord2011Document*)doc
//{
//  
//  NSMutableArray<STMSWord2011Field*>* fields = [[NSMutableArray<STMSWord2011Field*> alloc] init];
//  @autoreleasepool {
//  // Load the doc variable if it's not explicitly set
//  if (doc == nil) {
//    STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
//    doc = [app activeDocument];
//  }
//
//  //FIXME:Start of "end of document insert bug"
//  //=============================================
//  // There's a gnarly issue where if we insert a tag at the end of the document, we can actually wind up looping back up to the top because we don't have enough space to insert.
//  // This is related to the # of characters in our field close. We need -at least- the same # of padding characters at the end of the document to account for our field close or Word skips back up to the top of the document and continues along. Probably has to do with our moving to the next position as we continue through our text.
//  // I don't have the time to deal with debugging a real fix right now, so I'm going to pad the end of the area with P IF AND ONLY IF we're near the end of the document.
//  // I've left this gross/simple code to be intentional about what we're doing
//  NSInteger fieldCloseLength = [fieldClose length];
//  NSInteger textRangeStart = [range startOfContent];
//  NSInteger textRangeEnd = [range endOfContent];
//  NSInteger docEndOfContent = [[[[[[STGlobals sharedInstance] ThisAddIn] Application] activeDocument] textObject] endOfContent];
//
//    
//  if(textRangeEnd + fieldCloseLength > docEndOfContent) {
//    STMSWord2011TextRange* padRange = [WordHelpers DuplicateRange:range forDoc:doc];
//    [WordHelpers setRange:&padRange start:textRangeEnd end:textRangeEnd withDoc:doc];
//    
//    for(NSInteger i = 0; i < fieldCloseLength; i++) {
//      [WordHelpers insertParagraphAtRange:padRange];
//    }
//    [WordHelpers setRange:&padRange start:[padRange startOfContent] end:[padRange endOfContent] + fieldCloseLength withDoc:doc];
//    [WordHelpers setRange:&range start:textRangeStart end:textRangeEnd withDoc:doc];
//  }
//  //=============================================
//  
//    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//
//    if(range == nil) {
//      [NSException raise:@"Argument is null" format:@"Range is null"];
//    }
//    if(fieldOpen == nil || [[fieldOpen stringByTrimmingCharactersInSet: ws] length] == 0) {
//      [NSException raise:@"Argument is null" format:@"fieldOpen is null"];
//    }
//    if(fieldClose == nil || [[fieldClose stringByTrimmingCharactersInSet: ws] length] == 0) {
//      [NSException raise:@"Argument is null" format:@"fieldClose is null"];
//    }
//    if(![theString containsString:fieldOpen] || ![theString containsString:fieldClose]) {
//      [NSException raise:@"Missing required value" format:@"theString does not contain fieldOpen and fieldClose"];
//    }
//
//
//    // Special case. If we do not check this, the algorithm breaks.
//    if([theString isEqualToString:[NSString stringWithFormat:@"%@%@", fieldOpen, fieldClose]]){
//      [fields addObject:[self InsertEmpty:range]];
//      return fields;
//    }
//    
//    // TODO: Implement additional error handling.
//    STMSWord2011Field* result;
//    
//    //original c# - using a "Stack"
//    //where it's "last in, first out" - https://msdn.microsoft.com/en-us/library/3278tedw%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396
//    //we've got faux-stack behavior appended to NSMutableArray via a Category (go look in StatTag/Categories)
//    
//    NSMutableArray<STMSWord2011TextRange*>* fieldStack = [[NSMutableArray<STMSWord2011TextRange*> alloc] init];
//    
//    [WordHelpers updateContent:theString inRange:&range];
//    
//    [fieldStack push:range];
//
//    STMSWord2011TextRange* searchRange = [WordHelpers DuplicateRange:range forDoc:doc];
//    
//    STMSWord2011TextRange* fieldRange = nil;
//    NSInteger loop = 0;
//
//    while([searchRange startOfContent] != [searchRange endOfContent]) {
//
//      loop = loop + 1;
//
//      STMSWord2011TextRange* nextOpen = [[self class] FindNextOpen:[WordHelpers DuplicateRange:searchRange forDoc:doc] text:fieldOpen forDoc:doc];
//      STMSWord2011TextRange* nextClose = [[self class] FindNextClose:[WordHelpers DuplicateRange:searchRange forDoc:doc] text:fieldClose forDoc:doc];
//
//      if(nextClose == nil) {
//        break;
//      }
//      // See which marker comes first.
//      if([nextOpen startOfContent] < [nextClose startOfContent]) {
//
//        [WordHelpers updateContent:@"" inRange:&nextOpen];
//        
//        [self offsetAllRanges:fieldStack EndsBy:[fieldOpen length]];
//        //our ranges don't update on content changes...
//        [WordHelpers setRange:&searchRange start:[nextOpen endOfContent] end:([searchRange endOfContent] - [fieldOpen length]) withDoc:doc];
//        
//        // Field open, so push a new range to the stack.
//        [fieldStack push:[WordHelpers DuplicateRange:nextOpen forDoc:doc]];
//      } else {
//
//        [WordHelpers updateContent:@"" inRange:&nextClose];
//
//        [self offsetAllRanges:fieldStack EndsBy:[fieldClose length]];
//
//        // Move start of main search region onwards past the end marker.
//        //searchRange = [WordHelpers setRangeStart:[nextClose endOfContent] end:[searchRange endOfContent] - [fieldClose length]];
//        [WordHelpers setRange:&searchRange start:[nextClose endOfContent] end:([searchRange endOfContent] - [fieldClose length]) withDoc:doc];
//        
//        // Field close, so pop the last range from the stack and insert the field.
//        fieldRange = [fieldStack pop];
//        [WordHelpers setRange:&fieldRange start:[fieldRange startOfContent] end:[nextClose endOfContent] withDoc:doc];
//        
//        result = [self InsertEmpty:fieldRange];
//        result.showCodes = NO;
//        // TODO - ADD BACK IN THE 2ND CALL TO SET SHOWCODES = NO.  TOOK IT OUT HOPING IT COULD OFFER SOME PERFORMANCE BENEFITS.
//        //result.showCodes = NO;
//
//        //offset our range by 2 because we've introduced a field (with braces internally)
//        [WordHelpers setRange:&searchRange start:[searchRange startOfContent]+4 end:([searchRange endOfContent]+4 ) withDoc:doc];
//
//        [fields addObject:result];
//        
//      }
//      
//    }
//    
//    
//    // To avoid having a blank space at the end of the field, we need to explicitly trim
//    // out a blank space that exists between the nested field delimiters.
//    
//    //original c#
//    //  spaceRange.Delete(Word.WdUnits.wdCharacter, 1);
//    // https://msdn.microsoft.com/en-us/library/office/ff845114.aspx?f=255&MSPPError=-2147217396
//    // Delete : "Deletes the specified number of characters or words."
//    /*
//     Unit : Optional : Variant
//     The unit by which the collapsed range is to be deleted. Can be one of the WdUnits constants.
//
//     Count : Optional : Variant
//     The number of units to be deleted. To delete units after the range, collapse the range and use a positive number. To delete units before the range, collapse the range and use a negative number.
//     */
//    /*
//     In our version, things are a bit different - we don't seem to have a "delete" method like that...
//     
//     Word.WdUnits -> STMSWord2011E129
//     wdCharacter -> STMSWord2011E129ACharacterItem
//     
//     I explored doing something like this...
//     ---
//     STMSWord2011TextRange* spaceRange = [WordHelpers DuplicateRange:fieldRange];
//     [WordHelpers setRange:&spaceRange Start:[spaceRange endOfContent] end:[spaceRange endOfContent]];
//     [WordHelpers setRange:&spaceRange Start:[spaceRange startOfContent] end:[spaceRange startOfContent]];
//     [WordHelpers updateContent:@"" inRange:&spaceRange];
//
//     
//     but that doesn't
//     a) do what we need it to do by removing the character
//     b) impact fieldRange since it's not "linked" to other range changes like the Windows version of Word
//     
//     so we're going to do something else...
//     */
//    //@autoreleasepool {
//      STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
//      //STMSWord2011Document* doc = [app activeDocument];
//
//      //NSLog(@"STFieldGenerator - insertField: Touching spaceRange");
//      STMSWord2011TextRange* spaceRange = [WordHelpers DuplicateRange:fieldRange];
//      [WordHelpers setRange:&spaceRange start:[spaceRange endOfContent]+2 end:[spaceRange endOfContent]+3 withDoc:doc];
//      [WordHelpers select:spaceRange];
//      //NSLog(@"STFieldGenerator - insertField: spacerange (%ld,%ld)", [spaceRange startOfContent], [spaceRange endOfContent]);
//      
//      //STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
//      STMSWord2011SelectionObject* selection = [app selection];
//      //NSLog(@"STFieldGenerator - insertField: selection (%ld,%ld)", [[selection textObject] startOfContent], [[selection textObject] endOfContent]);
//      //NSLog(@"STFieldGenerator - insertField: selection (BEFORE typeBackspace) - '%@' (%hu), length: %ld", [selection content], [[selection content] characterAtIndex:0], [[selection content] length]);
//      //      [selection typeBackspace]; //EWW - for whatever reason this was not consistently working, so we're going to explicitly replace the content in the range instead (which may or may not result in the same intended behavior if we change how this works later - for now it's OK)
//      [selection setContent:@""];
//      //NSLog(@"STFieldGenerator - insertField: selection (AFTER typeBackspace) - '%@'", [selection content]);
//      
//      
//      // Move the current selection after all inserted fields.
//      NSInteger newPos = [fieldRange endOfContent] + [[fieldRange fields] count] + 1;
//      //NSLog(@"STFieldGenerator - insertField: newPos (%ld)", newPos);
//
//      //NSLog(@"STFieldGenerator - insertField: fieldRange BEFORE (%ld,%ld)", [fieldRange startOfContent], [fieldRange endOfContent]);
//      [WordHelpers setRange:&fieldRange start:newPos end:newPos withDoc:doc];
//      //NSLog(@"STFieldGenerator - insertField: fieldRange AFTER (%ld,%ld)", [fieldRange startOfContent], [fieldRange endOfContent]);
//      
//      [WordHelpers select:fieldRange];
//
//    // Update the result of the outer field object.
//    if(result != nil) {
//      [result updateField];
//    }
//  }
//
//  //FIXME: end section for "end of document insert" bug
//  //=============================================
//  //OK, now that we're at the end of this, go back and if we were forced to insert padding P to avoid the whole issue with Word text ranges eating back _up_ into content, remove the padding characters
//  //disabling this for now because we're having (predictable) issues with tables - complex multi-field structures
////    if(padRange != nil)
////    {
////      @autoreleasepool {
////        docEndOfContent = [[[[[[STGlobals sharedInstance] ThisAddIn] Application] activeDocument] textObject] endOfContent];
////        //right - this is weird. We should have -1 here, but when we insert multiple fields we have issues and it eats content.
////        //again - not a lot of time to debug this, so it will leave some extra P in here. For right now we're just going with it.
////        [WordHelpers setRange:&padRange Start:docEndOfContent - fieldCloseLength + 1 end:docEndOfContent];
////        [WordHelpers select:padRange];
////        [[[[[STGlobals sharedInstance] ThisAddIn] Application] selection] setContent:@""];
////      }
////    }
//  
//    return fields;
//  
//}
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range {
//  return [self InsertField:range theString:[NSString stringWithFormat:@"%@%@", [[self class] FieldOpen], [[self class] FieldClose]] fieldOpen:[[self class] FieldOpen] fieldClose:[[self class] FieldClose]];
//}
////+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString {
////  return [self InsertField:range displayValue:@"" macroButtonName:[STConstantsFieldDetails MacroButtonName] tagIdentifier:@"" withDoc:nil];
////}
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString withDoc:(STMSWord2011Document*)doc {
//  return [self InsertField:range theString:theString fieldOpen:[[self class]FieldOpen] fieldClose:[[self class]FieldClose] withDoc:doc];
//}
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen {
//  return [self InsertField:range theString:theString fieldOpen:fieldOpen fieldClose:[[self class]FieldClose]];
//}
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen fieldClose:(NSString*)fieldClose {
//  return [self InsertField:range theString:theString fieldOpen:fieldOpen fieldClose:fieldClose withDoc:nil];
//}
//


/**
Adds a new empty Word.Field to the specified Word.Range.

@param range: The Word.Range where to add the Word.Field.
@param preserveFormatting: Whether to apply the formatting of the previous Word.Field result to the new result.

@returns : The newly created Word.Field
*/
+(STMSWord2011Field*)InsertEmpty:(STMSWord2011TextRange*)range preserveFormatting:(BOOL)preserveFormatting {
  STMSWord2011Field* result = [[self class] AddFieldToRange:range type:STMSWord2011E183FieldEmpty preserveFormatting:preserveFormatting];
  return result;
}
+(STMSWord2011Field*)InsertEmpty:(STMSWord2011TextRange*)range {
  return [self InsertEmpty:range preserveFormatting:false];
}

/**
 Creates a Word.Field and adds it to the specified Word.Range
 
 @remark: The Word.Field is added to the Word.Fields collection of the specified Word.Range.
 
 @param range: The Word.Range where to add the Word.Field.
 @param type: The type of Word.Field to create.
 @param preserveFormatting: Whether to apply the formatting of the previous field result to the new result.
 @param text: Additional text needed for the Word.Field.
 
 @returns: The newly created Word.Field.

 @remark: STMSWord2011E183 is equivalent to "WdFieldType"
 */
+(STMSWord2011Field*)AddFieldToRange:(STMSWord2011TextRange*)range type:(STMSWord2011E183)type preserveFormatting:(BOOL)preserveFormatting text:(NSString*)text {

  @autoreleasepool {

    //FIXME: this needs a lot of testing.
    // the original C# gets to use a simple "add" method (see below) to add the field and then get a handle bac to that same field. In our case, we can't quite do that. It _appears_ we can add a field using "createNewFieldTextRange..." and then maybe return the field from the range we just added it to - but this should _really_ be tested.
    
    //text will pretty much always be empty - or nil - because the range contains references to the text - so we do NOT set the field text
    
    STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
    [app createNewFieldTextRange:range fieldType:type fieldText:text preserveFormatting:preserveFormatting];
    //NSLog(@"AddFieldToRange - range(%ld, %ld)", [range startOfContent], [range endOfContent]);
    
    return [[range fields] lastObject];
    
    // original c#
    //  return range.Fields.Add(
    //                          range,
    //                          type,
    //                          text ?? Type.Missing,
    //                          preserveFormatting);
    // per https://msdn.microsoft.com/en-us/library/office/ff839569.aspx?f=255&MSPPError=-2147217396
    // this adds a field to the collection AND also returns the field
    // args:
    //  Range : Required : Range object
    //  The range where you want to add the field. If the range isn't collapsed, the field replaces the range.
    //  
    //  Type : Optional : Variant
    //  Can be any WdFieldType constant. For a list of valid constants, consult the Object Browser. The default value is wdFieldEmpty.
    //  
    //  Text : Optional : Variant
    //  Additional text needed for the field. For example, if you want to specify a switch for the field, you would add it here.
    //    
    //  PreserveFormatting : Optional : Variant
    //  True to have the formatting that's applied to the field preserved during updates.
  }
}
+(STMSWord2011Field*)AddFieldToRange:(STMSWord2011TextRange*)range type:(STMSWord2011E183)type preserveFormatting:(BOOL)preserveFormatting {
  return [self AddFieldToRange:range type:type preserveFormatting:preserveFormatting text:nil];
}
+(STMSWord2011Field*)AddFieldToRange:(STMSWord2011TextRange*)range type:(STMSWord2011E183)type {
  return [self AddFieldToRange:range type:type preserveFormatting:false text:nil];
}


+(STMSWord2011TextRange*)FindNextOpen:(STMSWord2011TextRange*)range text:(NSString*)text forDoc:(STMSWord2011Document*)doc {
  @autoreleasepool {
    BOOL found = [[self class] CreateFind:&range text:text];
    STMSWord2011TextRange* result = [WordHelpers DuplicateRange:range forDoc:doc];

    if(!found) {
      // Make sure that the next closing field will be found first.
      result = [result collapseRangeDirection:STMSWord2011E132CollapseEnd];
    }
    
    return result;
  }
}

+(STMSWord2011TextRange*)FindNextClose:(STMSWord2011TextRange*)range text:(NSString*)text forDoc:(STMSWord2011Document*)doc {
  //FIXME: review use of "duplicate" vs "copy" - unclear based on the C# API
  // API: https://msdn.microsoft.com/en-us/library/office/ff837543.aspx?f=255&MSPPError=-2147217396
  // Maybe? If this is really just a flat copy then this should work?
  // apparently with scripting bridge you have to use a dedicated "duplicateTo" method?
  // http://stackoverflow.com/questions/3293053/how-to-perform-equivalent-of-applescript-copy-command-from-scripting-bridge
  if([self CreateFind:&range text:text] == true) {
    return [WordHelpers DuplicateRange:range forDoc:doc];
  }
  
  return nil;
}

//-(STMSWord2011Find*)CreateFind:(STMSWord2011TextRange*)range text:(NSString*)text {
+(BOOL)CreateFind:(STMSWord2011TextRange**)range text:(NSString*)text {
  /*
   ** Really read this ***
   
   NOTE: we changed the return type - and the behavior in this method - details:
   
   original c# 
   //  result.Execute(FindText: text, Forward: true, Wrap: Word.WdFindWrap.wdFindStop);
   it then returns this Find object so it can be used by other items
   
   But in the Mac version, it appears executeFindFindText is broken...
   http://www.textndata.com/forums/word-applescript-reference-121585.html
   http://stackoverflow.com/questions/24746273/applescripting-an-msword-find-operation
   
   1) it explodes, so you'd need to wrap it with try/catch
   2) the enumeration return isn't what's expected from the documentation - which is fine - but it returns..
      "STMSWord2011EFRtTextRange" (NSInteger) or
      "STMSWord2011EFRtInsertionPoint" (NSInteger)
     which don't help us
   3) the "found" property is completely empty - and that's what we actually need here...

   we would ideally have done someting like this...
   -----
     STMSWord2011EFRt resultWorked = [result executeFindFindText:text matchCase:true matchWholeWord:false matchWildcards:false matchSoundsLike:false matchAllWordForms:false matchForward:true wrapFind:STMSWord2011E265FindStop findFormat:false replaceWith:@"" replace:STMSWord2011E273ReplaceNone];
     //NSLog(@"CreateFind : returned %u for range: %@ and text: '%@'", resultWorked, range, text);

   So that's a bummer.
   
   If we look at the c#, though, it appears the "find" is only being used to feed back the bool "found", so we're going to work around this by interfacing with AppleScript directly (see "WordASOC") and wrapping a cheap clone of "find" ourselves - ONLY feeding back the bool from the find result (since "found" is apparently still broken there, too... so instead of...
   
   STMSWord2011Find* result = [range findObject];
   
   we're going to do our own custom helper that just returns a BOOL
   */

  BOOL result = [WordHelpers FindText:text inRange:*range];
  if(result) {
    //  range = [range moveEndOfRangeBy:STMSWord2011E129ACharacterItem count:[theString length]];
    NSString* contentString = [*range content];
    if(contentString != nil) {
      NSRange rangeOfTextInContent = [contentString rangeOfString: text];
      if (rangeOfTextInContent.location != NSNotFound) {
        [WordHelpers setRange:range start:([*range startOfContent] + rangeOfTextInContent.location) end:([*range startOfContent] + rangeOfTextInContent.location + rangeOfTextInContent.length)];
      }
    }
  }
  return result;
}




@end
