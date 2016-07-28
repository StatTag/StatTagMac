//
//  STDocumentManager.m
//  StatTag
//
//  Created by Eric Whitley on 7/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STDocumentManager.h"
#import "StatTag.h"

#import "STStatsManager.h"
#import "STTagManager.h"
#import "STCodeFile.h"
#import "STMSWord2011.h"
#import "STGlobals.h"
#import "STThisAddIn.h"
#import "STCodeFile.h"
#import "STFieldCreator.h"

@implementation STDocumentManager

@synthesize TagManager = _TagManager;
@synthesize StatsManager = _StatsManager;
@synthesize FieldManager = _FieldManager;

NSString* const ConfigurationAttribute = @"StatTag Configuration";

-(instancetype) init {
  self = [super init];
  if(self){
    DocumentCodeFiles = [[NSMutableDictionary<NSString*, NSMutableArray<STCodeFile*>*> alloc] init];
    _TagManager = [[STTagManager alloc] init:self];
    _StatsManager = [[STStatsManager alloc] init:self];
    _FieldManager = [[STFieldCreator alloc] init];
  }
  return self;
}


/**
  Provider a wrapper to check if a variable exists in the document.
  @remarks: Needed because Word interop doesn't provide a nice check mechanism, and uses exceptions instead.
  @param variable: The variable to check
  @returns : True if a variable exists and has a value, false otherwise
*/
-(BOOL)DocumentVariableExists:(STMSWord2011Variable*)variable {
  
  @try {
    NSString* value = [variable variableValue];
    NSLog(@"DocumentVariableExists: variable: %@ has value: %@", [variable name], value);
    return true;
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
  }
  
  return false;
}

/**
 Save the referenced code files to the current Word document.
 @param document: The Word document of interest
*/
-(void) SaveCodeFileListToDocument:(STMSWord2011Document*) document {
  
  NSLog(@"SaveCodeFileListToDocument - Started");
  SBElementArray<STMSWord2011Variable*>* variables = [document variables];
  STMSWord2011Variable* variable = [variables objectWithName:ConfigurationAttribute];

  @try {
    NSMutableArray<STCodeFile*>* files = [self GetCodeFileList:document];
    BOOL hasCodeFiles = (files != nil && [files count] > 0);
    NSString* attribute = [STCodeFile SerializeList:files error:nil];
    if(![self DocumentVariableExists:variable]) {
      if (hasCodeFiles)
      {
        NSLog(@"%@", [NSString stringWithFormat:@"Document variable does not exist.  Adding attribute value of %@", attribute]);
        [WordHelpers createOrUpdateDocumentVariableWithName:ConfigurationAttribute andValue:attribute];
      }
      else
      {
        NSLog(@"There are no code files to add.");
      }
    } else {
      if (hasCodeFiles)
      {
        NSLog(@"%@", [NSString stringWithFormat:@"Document variable already exists.  Updating attribute value to %@", attribute]);
        variable.variableValue = attribute;
      }
      else {
        NSLog(@"There are no code files - removing existing variable");
        [variables removeObject:variable]; //can we do this?
      }
    }
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
    
  }
  NSLog(@"SaveCodeFileListToDocument - Finished");
}



/**
  Load the list of associated Code Files from a Word document.
  @param document: The Word document of interest
*/
-(void)LoadCodeFileListFromDocument:(STMSWord2011Document*)document {
  NSLog(@"LoadCodeFileListFromDocument - Started for doc at path %@", [document fullName]);

  NSLog(@"variables : count: %lu", (unsigned long)[[document variables] count]);
  
  NSArray<STMSWord2011Variable*>* variables = [document variables];
  STMSWord2011Variable* variable;
  for(STMSWord2011Variable* var in variables) {
    NSLog(@"variable name: %@ with value : %@", [var name], [var variableValue]);
    if([[var name] isEqualToString:ConfigurationAttribute]) {
      variable = var;
    }
  }
  
  @try {
    if([self DocumentVariableExists:variable]) {
      NSLog(@"variable : %@ has value : %@", [variable name], [variable variableValue]);
      NSMutableArray<STCodeFile*>* list = [[NSMutableArray<STCodeFile*> alloc] initWithArray:[STCodeFile DeserializeList:[variable variableValue] error:nil]];
      [DocumentCodeFiles setObject:list forKey:[document fullName]];
      NSLog(@"Document variable existed, loaded %lu code files", (unsigned long)[list count]);
    } else {
      [DocumentCodeFiles setObject:[[NSMutableArray<STCodeFile*> alloc] init] forKey:[document fullName]];
      NSLog(@"Document variable does not exist, no code files loaded");
    }
    NSString* value = [variable variableValue];
    NSLog(@"DocumentVariableExists: variable: %@ has value: %@", [variable name], value);
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
    //Marshal.ReleaseComObject(variable);
    //Marshal.ReleaseComObject(variables);
  }

  NSLog(@"LoadCodeFileListFromDocument - Finished");
}


/**
 Insert an image (given a definition from an tag) into the current Word document at the current cursor location.
 */
-(void) InsertImage:(STTag*) tag {
  //[NSException raise:@"InsertImage not implemented" format:@"InsertImage not implemented"];
  
  NSLog(@"InsertImage - Started");
  if (tag == nil)
  {
    NSLog(@"The tag is null, no action will be taken");
    return;
  }

  if ([tag CachedResult] == nil || [[tag CachedResult] count] == 0)
  {
    NSLog(@"The tag has no cached results - unable to insert image");
    return;
  }

  NSString* fileName = [[[tag CachedResult] firstObject] FigureResult];
  [WordHelpers insertImageAtPath:fileName];
  
  NSLog(@"InsertImage - Finished");
  
}


/**
 Insert a table tag into the current selection.

 @remark: This assumes that the tag is known to be a table result.</remarks>
*/
-(void) InsertTable:(STMSWord2011SelectionObject*)selection tag:(STTag*) tag {
  [NSException raise:@"InsertTable not implemented" format:@"InsertTable not implemented"];
}

/**
 Determine if an updated tag pair resulted in a table having different dimensions.  This purely
 looks at structure of the table with headers - it does not (currently) factor in data changes.
*/
-(BOOL) IsTableTagChangingDimensions:(STUpdatePair<STTag*>*) tagUpdatePair {
// TODO: Move to utility class and write tests

  if (tagUpdatePair == nil || [tagUpdatePair New] == nil || [tagUpdatePair Old] == nil)
  {
    return false;
  }
  
  if (![[tagUpdatePair Old] IsTableTag] || ![[tagUpdatePair New]IsTableTag])
  {
    return false;
  }
  
  // Are we changing the display of headers?
  if (tagUpdatePair.Old.TableFormat.IncludeColumnNames != tagUpdatePair.New.TableFormat.IncludeColumnNames
      || tagUpdatePair.Old.TableFormat.IncludeRowNames != tagUpdatePair.New.TableFormat.IncludeRowNames)
  {
    NSLog(@"Table dimensions have changed based on header settings");
    return true;
  }
  
  return false;
}


/**
 For a given Word document, remove all of the field tags for a single table.  This
 is in preparation to then re-insert the table in response to a dimension change.
*/
-(BOOL)RefreshTableTagFields:(STTag*)tag document:(STMSWord2011Document*)document {
  //[NSException raise:@"RefreshTableTagFields not implemented" format:@"RefreshTableTagFields not implemented"];


  NSLog(@"RefreshTableTagFields - Started");
  SBElementArray<STMSWord2011Field*>* fields = [document fields];
  int fieldsCount = [fields count];
  bool tableRefreshed = false;
  
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  
  // Fields is a 1-based index
  NSLog(@"Preparing to process %d} fields", fieldsCount);
  for (int index = fieldsCount - 1; index >= 0; index--)
  {
    STMSWord2011Field* field = fields[index];
    if (field == nil)
    {
      NSLog(@"Null field detected at index %d", index);
      continue;
    }
    
    
    if (![_TagManager IsStatTagField:field])
    {
      //Marshal.ReleaseComObject(field);
      continue;
    }


    NSLog(@"Processing StatTag field");
    STFieldTag* fieldTag = [_TagManager GetFieldTag:field];
    if (fieldTag == nil)
    {
      NSLog(@"The field tag is null or could not be found");
      //Marshal.ReleaseComObject(field);
      continue;
    }
    
    if ([tag isEqual:fieldTag])
    {
      BOOL isFirstCell = ([fieldTag TableCellIndex] != nil &&
                          [[fieldTag TableCellIndex] integerValue] == 0);
      int firstFieldLocation = -1;
      if (isFirstCell)
      {
        [field select];
        STMSWord2011SelectionObject* selection = [app selection];
        
        firstFieldLocation = [selection selectionStart]; //selection.Range.Start;
        //Marshal.ReleaseComObject(selection);
        
        NSLog(@"First table cell found at position %d", firstFieldLocation);
      }
      
      //field.Delete();
      [field delete]; //does this work?
      
      if (isFirstCell)
      {
        [app selection].selectionStart = firstFieldLocation;
        [app selection].selectionEnd = firstFieldLocation;
        
        NSLog(@"Set position, attempting to insert table");
        [self InsertField:tag];
        tableRefreshed = true;
      }
    }
    
    //Marshal.ReleaseComObject(field);
  }
  
  [WordHelpers toggleAllFieldCodes];
  
  NSLog(@"RefreshTableTagFields - Finished, Returning %d", tableRefreshed);
  return tableRefreshed;

}


/**
 Processes all inline shapes within the document, which will include our inserted figures.
 If the shape can be updated, we will process the update.
*/
-(void)UpdateInlineShapes:(STMSWord2011Document*)document {
  //[NSException raise:@"UpdateInlineShapes not implemented" format:@"UpdateInlineShapes not implemented"];
  
  SBElementArray<STMSWord2011InlineShape*>* shapes = [document inlineShapes];
  if (shapes == nil)
  {
    return;
  }
  
  int shapesCount = [shapes count];
  for (int shapeIndex = 0; shapeIndex <= shapesCount; shapeIndex++)
  {
    STMSWord2011InlineShape* shape = shapes[shapeIndex];
    if (shape != nil)
    {
      STMSWord2011LinkFormat* linkFormat = [shape linkFormat];
      if (linkFormat != nil)
      {
        NSLog(@"linkFormat : autoUpdate : %hhd for path : %@", [linkFormat autoUpdate], [linkFormat sourceFullName]);
        
        if([WordHelpers imageExistsAtPath:[linkFormat sourceFullName]]) {
          linkFormat.sourceFullName = [linkFormat sourceFullName];
          linkFormat.sourceFullName = [linkFormat sourceFullName];
          NSLog(@"updating shape[%d] with file path : '%@'", shapeIndex, [linkFormat sourceFullName]);
        } else {
          NSLog(@"UpdateInlineShapes tried to update a file and can't find image at requested path - '%@'", [linkFormat sourceFullName]);
        }
        // see thread - http://stackoverflow.com/questions/38621644/word-applescript-update-link-format-working-with-inline-shapes
        //linkFormat.Update(); //so this doesn't exist in any useful way - so we have to "update" by setting the full source path - _twice_.  First time just breaks things. Second time - it sticks.
        //Marshal.ReleaseComObject(linkFormat);
      }
      
      //Marshal.ReleaseComObject(shape);
    }
  }

  
}


/**
 Update all of the field values in the current document.

  @remark This does not invoke a statistical package to recalculate values, it assumes
  that has already been done.  Instead it just updates the displayed text of a field
  with whatever is set as the current cached value.

 @param tagUpdatePair: An optional tag to update.  If specified, the contents of the tag (including its underlying data) will be refreshed.
 The reaason this is an Tag and not a FieldTag is that the function is only called after a change to the main tag reference.
 If not specified, all tag fields will be updated

 @param matchOnPosition: If set to true, an tag will only be matched if its line numbers (in the code file) are a match.  This is used when updating after disambiguating two tags with the same name, but isn't needed otherwise.
 */
//public void UpdateFields(UpdatePair<Tag> tagUpdatePair = null, bool matchOnPosition = false)
-(void)UpdateFields:(STUpdatePair<STTag*>*)tagUpdatePair matchOnPosition:(BOOL)matchOnPosition {
  
  NSLog(@"UpdateFields - Started");
  
  STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];

  STMSWord2011Document* document = [application activeDocument];
  
  //FIXME: we need to do something different...
  //Cursor.Current = Cursors.WaitCursor;
  //application.ScreenUpdating = false;
  
  //[WordHelpers disableScreenUpdates];
  
  @try
  {
    BOOL tableDimensionChange = [self IsTableTagChangingDimensions:tagUpdatePair];
    if (tableDimensionChange)
    {
      NSLog(@"Attempting to refresh table with tag name: %@", tagUpdatePair.New.Name);
      if ([self RefreshTableTagFields:[tagUpdatePair New] document:document])
      {
        NSLog(@"Completed refreshing table - leaving UpdateFields");
        return;
      }
    }
    
    //currently not working...
    [self UpdateInlineShapes:document];
    
    SBElementArray<STMSWord2011Field*>* fields = [document fields];
    int fieldsCount = [fields count];
    // Fields is a 1-based index
    NSLog(@"Preparing to process %d fields", fieldsCount);
    
    //FIXME: it's 1-based in Windows - but on the Mac? We should check...
    for (int index = 0; index < fieldsCount; index++)
    {
      STMSWord2011Field* field = fields[index];
      if (field == nil)
      {
        NSLog(@"Null field detected at index %d", index);
        continue;
      }
      
      if (![_TagManager IsStatTagField:field])
      {
        //Marshal.ReleaseComObject(field);
        continue;
      }
      
      NSLog(@"Processing StatTag field");
      NSLog(@"RefreshTableTagFields -> found field : %@ and json : %@", [[field fieldCode] content], [field fieldText]);

      
      STFieldTag* tag = [_TagManager GetFieldTag:field];
      if (tag == nil)
      {
        NSLog(@"The field tag is null or could not be found");
        //Marshal.ReleaseComObject(field);
        continue;
      }
      
      // If we are asked to update an tag, we are only going to update that
      // tag specifically.  Otherwise, we will process all tag fields.
      if (tagUpdatePair != nil)
      {
        // Determine if this is a match, factoring in if we should be doing a more exact match on the tag.
        if ((!matchOnPosition && ![tag isEqual: tagUpdatePair.Old])
            || (matchOnPosition && ![tag EqualsWithPosition:tagUpdatePair.Old]))
        {
          //FIXME: note that the original conditions in the c# were slightly different...
          /*
           if ((!matchOnPosition && !tag.Equals(tagUpdatePair.Old))
           || matchOnPosition && !tag.EqualsWithPosition(tagUpdatePair.Old))
           */
          continue;
        }
        
        NSLog(@"Processing only a specific tag with label: %@", tagUpdatePair.New.Name);
        tag = [[STFieldTag alloc] initWithTag:[tagUpdatePair New] andFieldTag:tag];
        [_TagManager UpdateTagFieldData:field tag:tag];
      }
      
      NSLog(@"Inserting field for tag: %@", tag.Name);
      [field select];
      [self InsertField:tag];
      
      //Marshal.ReleaseComObject(field);
    }
    //Marshal.ReleaseComObject(fields);
  }
  @catch (NSException *exception) {
    NSLog(@"UpdateFields exception : %@", exception.reason);
  }
  @finally
  {
    //Marshal.ReleaseComObject(document);
    
    //Cursor.Current = Cursors.Default;
    //application.ScreenUpdating = true;
    //[WordHelpers enableScreenUpdates];
  }
  
  [WordHelpers toggleAllFieldCodes];
  
  NSLog(@"UpdateFields - Finished");
  
  
}
-(void)UpdateFields:(STUpdatePair<STTag*>*)tagUpdatePair {
  [self UpdateFields:tagUpdatePair matchOnPosition:false];
}
-(void)UpdateFields {
  [self UpdateFields:nil];
}

//MARK: Wrappers around TagManager calls

-(NSDictionary<NSString*, NSArray<STTag*>*>*)FindAllUnlinkedTags {
  return [_TagManager FindAllUnlinkedTags];
}

-(NSArray<STTag*>*)GetTags {
  return [_TagManager GetTags];
}

-(STTag*)FindTag:(NSString*)tagID {
  return [[self TagManager] FindTagByID:tagID];
}


//MARK: add / update

/**
 Given an tag, insert the result into the document at the current cursor position.
 
 @remark This method assumes the tag result is already refreshed.  It does not attempt to refresh or recalculate it.
 */
-(void) InsertField:(id)tag {
  NSLog(@"InsertField for Tag");
  if([tag isKindOfClass:[STFieldTag class]]) {
    [self InsertFieldWithFieldTag:tag];
  } else if ([tag isKindOfClass:[STTag class]]) {
    [self InsertFieldWithFieldTag:[[STFieldTag alloc] initWithTag:tag]];
  }
}


/**
 Given an tag, insert the result into the document at the current cursor position.

 @remark This method assumes the tag result is already refreshed.  It does not attempt to refresh or recalculate it.
 */
-(void) InsertFieldWithFieldTag:(STFieldTag*)tag {
  NSLog(@"InsertField - Started");

  if(tag == nil) {
    NSLog(@"The tag is null");
    return;
  }
  
  if([[tag Type] isEqualToString:[STConstantsTagType Figure]]) {
    NSLog(@"Detected a Figure tag");
    [self InsertImage:tag];
    return;
  }
  
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];

  @try {
    STMSWord2011SelectionObject* selection = [app selection];
    if(selection == nil) {
      NSLog(@"There is no active selection");
      return;
    }

    // If the tag is a table, and the cell index is not set, it means we are inserting the entire
    // table into the document.  Otherwise, we are able to just insert a single table cell.
    if([tag IsTableTag] && [tag TableCellIndex] != nil) {
      // if (tag.IsTableTag() && !tag.TableCellIndex.HasValue)
      NSLog(@"Inserting a new table tag");
      [self InsertTable:selection tag:tag];
    } else {
      NSLog(@"Inserting a single tag field");
      //FIXME: unclear if we should use textObject or formattedText
      STMSWord2011TextRange* range = [selection textObject];
      [self CreateTagField:range tagIdentifier:[tag Name] displayValue:[tag FormattedResult] tag:tag];
      //Marshal.ReleaseComObject(range);
    }
    //Marshal.ReleaseComObject(selection);
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
    //Marshal.ReleaseComObject(document);
  }

  NSLog(@"InsertField - Finished");

}


/**
Insert an StatTag field at the currently specified document range.

@param range: The range to insert the field at
@param tagIdentifier: The visible identifier of the tag (does not need to be globablly unique)
@param displayValue: The value that should display when the field is shown.
@param tag: The tag to be inserted
 */
-(void)CreateTagField:(STMSWord2011TextRange*)range tagIdentifier:(NSString*)tagIdentifier displayValue:(NSString*)displayValue tag:(STTag*)tag {
  NSLog(@"CreateTagField - Started");

//  [app createNewFieldTextRange:range fieldType:type fieldText:text preserveFormatting:preserveFormatting];
//  return [[range fields] lastObject];
  
  //C# - XML - can't use it as we don't have support for InsertXML
  //  range.InsertXML(OpenXmlGenerator.GenerateField(tagIdentifier, displayValue, tag));
  
  //C# prior to XML - which we can't use
  //var fields = FieldManager.InsertField(range, string.Format("{3}MacroButton {0} {1}{3}ADDIN {2}{4}{4}",
  //    Constants.FieldDetails.MacroButtonName, displayValue, tagIdentifier, FieldCreator.FieldOpen, FieldCreator.FieldClose));
  //Log(string.Format("Inserted field with identifier {0} and display value {1}", tagIdentifier, displayValue));

  NSArray<STMSWord2011Field*>* fields = [_FieldManager InsertField:range theString:
                                         
                                         [NSString stringWithFormat:@"%@MacroButton %@ %@%@ADDIN %@%@%@",
                                          
                                          [STFieldCreator FieldOpen],
                                          [STConstantsFieldDetails MacroButtonName],
                                          displayValue,
                                          [STFieldCreator FieldOpen],
                                          tagIdentifier,
                                          [STFieldCreator FieldClose],
                                          [STFieldCreator FieldClose]
                                          
                                          //0    Constants.FieldDetails.MacroButtonName,
                                          //1    displayValue,
                                          //2    tagIdentifier,
                                          //3    FieldCreator.FieldOpen,
                                          //4    FieldCreator.FieldClose
                                          
                                          ]
                                         ];
  
//  NSArray<STMSWord2011Field*>* fields = [_FieldManager InsertField:range theString:@"<MacroButton test test>"];

//    NSArray<STMSWord2011Field*>* fields = [_FieldManager InsertField:range theString:@"< = 5 + < PAGE > >"];

  
//  NSLog(@"fields : %@", fields);
//  
//  NSLog(@"Inserted field with identifier %@ and display value %@", tagIdentifier, displayValue);
  
  STMSWord2011Field* dataField = [fields firstObject];
  //@property (copy) NSString *fieldText;  // Returns or sets data in an ADDIN field. The data is not visible in the field code or result. It is only accessible by returning the value of the data property. If the field isn't an ADDIN field, this property will cause an error.
  dataField.fieldText = [tag Serialize:nil];
  
  
  
  //var dataField = fields.First();
  //dataField.Data = tag.Serialize();
  
  NSLog(@"CreateTagField - Finished");
}




/**
 Add a code file reference to our master list of files in the document.  This should be used when
 discovering code files to link to the document.
*/
-(void)AddCodeFile:(NSString*)fileName document:(STMSWord2011Document*)document {

  //NSMutableArray<STCodeFile*>* files = [[NSMutableArray<STCodeFile*> alloc] initWithArray:[self GetCodeFileList:document]];
  NSMutableArray<STCodeFile*>* files = [self GetCodeFileList:document];

  //  if (files.Any(x => x.FilePath.Equals(fileName, StringComparison.CurrentCultureIgnoreCase)))
  //  {
  //    Log(string.Format("Code file {0} already exists and won't be added again", fileName));
  //    return;
  //  }

  NSString* package = [STCodeFile GuessStatisticalPackage:fileName];
  STCodeFile* file = [[STCodeFile alloc] init];
  file.FilePath = fileName;
  file.StatisticalPackage = package;
  [file LoadTagsFromContent];
  [file SaveBackup:nil];
  //FIXME: if this is a copy of the array, then this won't add anything...
  // which makes me wonder if this is supposed to return a pointer to the actual array instead...
  [files addObject:file];
  NSLog(@"Added code file %@", fileName);
  
}
-(void)AddCodeFile:(NSString*)fileName {
  [self AddCodeFile:fileName document:nil];
}



/**
  Helper accessor to get the list of code files associated with a document.  If the code file list
  hasn't been established yet for the document, it will be created and returned.
*/
-(NSMutableArray<STCodeFile*>*)GetCodeFileList {
  return [self GetCodeFileList:nil];
}

-(NSMutableArray<STCodeFile*>*)GetCodeFileList:(STMSWord2011Document*)document {
  if(document == nil) {
    NSLog(@"No document specified, so fetching code file list for active document.");
    document = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
  }
  if(document == nil) {
    NSLog(@"Attempted to access code files for a null document.  Returning empty collection.");
    return [[NSMutableArray<STCodeFile*> alloc] init];
  }

  NSString* fullName = [document fullName];
  if([DocumentCodeFiles objectForKey:fullName] == nil) {
    [DocumentCodeFiles setValue:[[NSMutableArray<STCodeFile*> alloc] init] forKey:fullName];
  }
  
  return DocumentCodeFiles[fullName];
}

/**
 Helper setter to update a document's list of associated code files.
*/
-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files {
  [self SetCodeFileList:files document:nil];
}

-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files document:(STMSWord2011Document*)document {
  if(document == nil) {
    NSLog(@"No document specified, so getting a reference to the active document.");
    document = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
  }
  if(document == nil) {
    NSLog(@"Attempted to set the code files for a null document.  Throwing exception.");
    [NSException raise:@"The Word document must be specified." format:@"The Word document must be specified."];
  }
  [DocumentCodeFiles setValue:[[NSMutableArray<STCodeFile*> alloc] initWithArray: files ] forKey:[document fullName]];
}


@end
