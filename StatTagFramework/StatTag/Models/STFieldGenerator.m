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
 
 The entire approach isn't particularly good. It desperatley needs to be refactored.

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
  return @"<";
}
+(NSString*)FieldClose {
  return @">";
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
    NSArray<STMSWord2011Field*>* fields = [[self class] InsertField:range theString:[NSString stringWithFormat:@"%@MacroButton %@ %@%@ADDIN %@%@%@", [self FieldOpen], [STConstantsFieldDetails MacroButtonName], displayValue, [self FieldOpen], tagIdentifier, [self FieldClose], [self FieldClose] ]];
    
    STMSWord2011Field* dataField = [fields firstObject];
    dataField.fieldText = [tag Serialize:nil];
    
    // This is a terrible hack, I know, but it's the only way I've found to get fields
    // to appear correctly after doing this insert.
    //[WordHelpers toggleFieldCodesInRange:range];
    [STDocumentManager toggleWordFieldsForTag:tag];    
  }
}


+(void)offsetAllRanges:(NSMutableArray<STMSWord2011TextRange*>*)ranges EndsBy:(NSInteger)removeEnd {
  @autoreleasepool {
    for (NSInteger index = 0; index < [ranges count] ; index++) {
      STMSWord2011TextRange* range = [ranges objectAtIndex:index];
      if(([range endOfContent] - removeEnd) > 0 && [range startOfContent] != [range endOfContent]) {
        //NSLog(@"OFFSETTING range -> ( %ld, %ld) content : %@", (long)[range startOfContent], (long)[range endOfContent], [range content]);
        //NSLog(@"trying to set end to %d", [range endOfContent] - removeEnd);
        [WordHelpers setRange:&range Start:[range startOfContent] end:([range endOfContent] - removeEnd)];
        [ranges replaceObjectAtIndex:index withObject:range];
        
        //NSLog(@"OFFSETTING range -> ( %ld, %ld) content : %@", (long)[range startOfContent], (long)[range endOfContent], [range content]);
      }
    }
  }
}

/**
 Adds one or more new Word.Field to the specified Word.Range.
 
 This method allows to insert nested fields at the specified range.
 
 @code
 <c>InsertField(Application.Selection.Range, {{= {{PAGE}} - 1}};</c>
 will produce
 { = { PAGE } - 1 }
 @endcode
 
 @param range: The Word.Range where to add the Word.Field.
 @param theString: The string to convert to one or more Word.Field objects.
 @param fieldOpen: The special code to mark the start of a Word.Field.
 @param fieldClose">The special code to mark the end of a Word.Field.
 @returns The newly created Word.Field
 
 @remark A solution for VBA has been taken from [this](http://stoptyping.co.uk/word/nested-fields-in-vba)
 article and adopted for C# by the author.
*/
+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen fieldClose:(NSString*)fieldClose
{
  

    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];

    if(range == nil) {
      [NSException raise:@"Argument is null" format:@"Range is null"];
    }
    if(fieldOpen == nil || [[fieldOpen stringByTrimmingCharactersInSet: ws] length] == 0) {
      [NSException raise:@"Argument is null" format:@"fieldOpen is null"];
    }
    if(fieldClose == nil || [[fieldClose stringByTrimmingCharactersInSet: ws] length] == 0) {
      [NSException raise:@"Argument is null" format:@"fieldClose is null"];
    }
    if(![theString containsString:fieldOpen] || ![theString containsString:fieldClose]) {
      [NSException raise:@"Missing required value" format:@"theString does not contain fieldOpen and fieldClose"];
    }

    NSMutableArray<STMSWord2011Field*>* fields = [[NSMutableArray<STMSWord2011Field*> alloc] init];
    // Special case. If we do not check this, the algorithm breaks.
    if([theString isEqualToString:[NSString stringWithFormat:@"%@%@", fieldOpen, fieldClose]]){
      [fields addObject:[self InsertEmpty:range]];

      return fields;
    }
    
    // TODO: Implement additional error handling.
    STMSWord2011Field* result;
    
    //original c# - using a "Stack"
    //where it's "last in, first out" - https://msdn.microsoft.com/en-us/library/3278tedw%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396
    //we've got faux-stack behavior appended to NSMutableArray via a Category (go look in StatTag/Categories)
    
    NSMutableArray<STMSWord2011TextRange*>* fieldStack = [[NSMutableArray<STMSWord2011TextRange*> alloc] init];
    
    [WordHelpers updateContent:theString inRange:&range];
    
    [fieldStack push:range];

    STMSWord2011TextRange* searchRange = [WordHelpers DuplicateRange:range];
    
    STMSWord2011TextRange* fieldRange = nil;
    NSInteger loop = 0;

    while([searchRange startOfContent] != [searchRange endOfContent]) {

      loop = loop + 1;

      STMSWord2011TextRange* nextOpen = [[self class] FindNextOpen:[WordHelpers DuplicateRange:searchRange] text:fieldOpen];
      STMSWord2011TextRange* nextClose = [[self class] FindNextClose:[WordHelpers DuplicateRange:searchRange] text:fieldClose];

      if(nextClose == nil) {
        break;
      }
      // See which marker comes first.
      if([nextOpen startOfContent] < [nextClose startOfContent]) {

        [WordHelpers updateContent:@"" inRange:&nextOpen];
        
        [self offsetAllRanges:fieldStack EndsBy:[fieldOpen length]];
        //our ranges don't update on content changes...
        [WordHelpers setRange:&searchRange Start:[nextOpen endOfContent] end:([searchRange endOfContent] - [fieldOpen length])];
        
        // Field open, so push a new range to the stack.
        [fieldStack push:[WordHelpers DuplicateRange:nextOpen]];
      } else {

        [WordHelpers updateContent:@"" inRange:&nextClose];

        [self offsetAllRanges:fieldStack EndsBy:[fieldClose length]];

        // Move start of main search region onwards past the end marker.
        //searchRange = [WordHelpers setRangeStart:[nextClose endOfContent] end:[searchRange endOfContent] - [fieldClose length]];
        [WordHelpers setRange:&searchRange Start:[nextClose endOfContent] end:([searchRange endOfContent] - [fieldClose length])];
        
        // Field close, so pop the last range from the stack and insert the field.
        fieldRange = [fieldStack pop];
        [WordHelpers setRange:&fieldRange Start:[fieldRange startOfContent] end:[nextClose endOfContent]];
        
        result = [self InsertEmpty:fieldRange];
        result.showCodes = NO;
        result.showCodes = NO;
        //result.showCodes = ![result showCodes];
        //result.showCodes = ![result showCodes];
        
        //offset our range by 2 because we've introduced a field (with braces internally)
        [WordHelpers setRange:&searchRange Start:[searchRange startOfContent]+4 end:([searchRange endOfContent]+4 )];

        [fields addObject:result];
        
      }
      
    }
    
    
    // To avoid having a blank space at the end of the field, we need to explicitly trim
    // out a blank space that exists between the nested field delimiters.
    
    //original c#
    //  spaceRange.Delete(Word.WdUnits.wdCharacter, 1);
    // https://msdn.microsoft.com/en-us/library/office/ff845114.aspx?f=255&MSPPError=-2147217396
    // Delete : "Deletes the specified number of characters or words."
    /*
     Unit : Optional : Variant
     The unit by which the collapsed range is to be deleted. Can be one of the WdUnits constants.

     Count : Optional : Variant
     The number of units to be deleted. To delete units after the range, collapse the range and use a positive number. To delete units before the range, collapse the range and use a negative number.
     */
    /*
     In our version, things are a bit different - we don't seem to have a "delete" method like that...
     
     Word.WdUnits -> STMSWord2011E129
     wdCharacter -> STMSWord2011E129ACharacterItem
     
     I explored doing something like this...
     ---
     STMSWord2011TextRange* spaceRange = [WordHelpers DuplicateRange:fieldRange];
     [WordHelpers setRange:&spaceRange Start:[spaceRange endOfContent] end:[spaceRange endOfContent]];
     [WordHelpers setRange:&spaceRange Start:[spaceRange startOfContent] end:[spaceRange startOfContent]];
     [WordHelpers updateContent:@"" inRange:&spaceRange];

     
     but that doesn't
     a) do what we need it to do by removing the character
     b) impact fieldRange since it's not "linked" to other range changes like the Windows version of Word
     
     so we're going to do something else...
     */
    @autoreleasepool {
      STMSWord2011TextRange* spaceRange = [WordHelpers DuplicateRange:fieldRange];
      [WordHelpers setRange:&spaceRange Start:[spaceRange endOfContent]+2 end:[spaceRange endOfContent]+3];
      [WordHelpers select:spaceRange];
      
      STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
      STMSWord2011SelectionObject* selection = [app selection];
      [selection typeBackspace];
      
      
      // Move the current selection after all inserted fields.
      NSInteger newPos = [fieldRange endOfContent] + [[fieldRange fields] count] + 1;
      [WordHelpers setRange:&fieldRange Start:newPos end:newPos];
      
      [WordHelpers select:fieldRange];
    }

    // Update the result of the outer field object.
    if(result != nil) {
      [result updateField];
    }

    return fields;
  
}
+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range {
  return [self InsertField:range theString:[NSString stringWithFormat:@"%@%@", [[self class] FieldOpen], [[self class] FieldClose]] fieldOpen:[[self class] FieldOpen] fieldClose:[[self class] FieldClose]];
}
+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString {
  return [self InsertField:range theString:theString fieldOpen:[[self class]FieldOpen] fieldClose:[[self class]FieldClose]];
}
+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen {
  return [self InsertField:range theString:theString fieldOpen:fieldOpen fieldClose:[[self class]FieldClose]];
}




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
    NSLog(@"AddFieldToRange - range(%ld, %ld)", [range startOfContent], [range endOfContent]);
    
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


+(STMSWord2011TextRange*)FindNextOpen:(STMSWord2011TextRange*)range text:(NSString*)text {
  @autoreleasepool {
    BOOL found = [[self class] CreateFind:&range text:text];
    STMSWord2011TextRange* result = [WordHelpers DuplicateRange:range];

    if(!found) {
      // Make sure that the next closing field will be found first.
      result = [result collapseRangeDirection:STMSWord2011E132CollapseEnd];
    }
    
    return result;
  }
}

+(STMSWord2011TextRange*)FindNextClose:(STMSWord2011TextRange*)range text:(NSString*)text {
  //FIXME: review use of "duplicate" vs "copy" - unclear based on the C# API
  // API: https://msdn.microsoft.com/en-us/library/office/ff837543.aspx?f=255&MSPPError=-2147217396
  // Maybe? If this is really just a flat copy then this should work?
  // apparently with scripting bridge you have to use a dedicated "duplicateTo" method?
  // http://stackoverflow.com/questions/3293053/how-to-perform-equivalent-of-applescript-copy-command-from-scripting-bridge
  if([self CreateFind:&range text:text] == true) {
    return [WordHelpers DuplicateRange:range];
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
     NSLog(@"CreateFind : returned %u for range: %@ and text: '%@'", resultWorked, range, text);

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
        [WordHelpers setRange:range Start:([*range startOfContent] + rangeOfTextInContent.location) end:([*range startOfContent] + rangeOfTextInContent.location + rangeOfTextInContent.length)];
      }
    }
  }
  return result;
}




@end
