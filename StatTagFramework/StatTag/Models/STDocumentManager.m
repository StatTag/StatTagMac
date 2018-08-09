//
//  STDocumentManager.m
//  StatTag
//
//  Created by Eric Whitley on 7/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STDocumentManager.h"
#import "StatTagFramework.h"

#import "STStatsManager.h"
#import "STTagManager.h"
#import "STCodeFile.h"
#import "STMSWord2011.h"
#import "STGlobals.h"
#import "STThisAddIn.h"
#import "STCodeFile.h"
#import "STFieldGenerator.h"
#import "STUIUtility.h"
#import "STFilterFormat.h"
#import "STTableUtil.h"
#import "STSettingsManager.h"
#import "STDocumentMetadata.h"

@implementation STDocumentManager

@synthesize TagManager = _TagManager;
@synthesize StatsManager = _StatsManager;
@synthesize FieldManager = _FieldManager;
@synthesize SettingsManager = _SettingsManager;

@synthesize wordFieldsTotal = _wordFieldsTotal;
@synthesize wordFieldsUpdated = _wordFieldsUpdated;
@synthesize wordFieldUpdateStatus = _wordFieldUpdateStatus;

NSString* const ConfigurationAttribute = @"StatTag Configuration";
NSString* const MetadataAttribute = @"StatTag Metadata";

-(instancetype) init {
  self = [super init];
  if(self){
    _SettingsManager = nil;
    DocumentCodeFiles = [[NSMutableDictionary<NSString*, NSMutableArray<STCodeFile*>*> alloc] init];
    _TagManager = [[STTagManager alloc] init:self];
    _StatsManager = [[STStatsManager alloc] initWithDocumentManager:self andSettingsManager:[self SettingsManager]];
    _FieldManager = [[STFieldGenerator alloc] init];
    
    _wordFieldsTotal = @0;
    _wordFieldsUpdated = @0;
    _wordFieldUpdateStatus = @"";
  }
  return self;
}

-(NSNumber*)wordFieldsTotal {
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* document = [app activeDocument];
  NSMutableArray<STMSWord2011Field*>* fields = [WordHelpers getAllFieldsInDocument:document];
  NSInteger fieldsCount = [fields count];
  return [NSNumber numberWithInteger:fieldsCount];
}

-(STMSWord2011Document*)activeDocument {
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* document = [app activeDocument];
  return document;
}


-(void)SetSettingsManager:(STSettingsManager*)settingsManager
{
  [self SetSettingsManager:settingsManager];
  if([self StatsManager] == nil)
  {
    self.StatsManager = [[STStatsManager alloc] initWithDocumentManager:self andSettingsManager:[self SettingsManager]];
  }
  else
  {
    [[self StatsManager] setSettingsManager:[self SettingsManager]];
  }
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
    if(value != nil) //do we want to do  && [value length] > 0 ?
    {
      return true;
    }
    //#pragma unused(value)
    //NSLog(@"DocumentVariableExists: variable: %@ has value: %@", [variable name], value);
    return false;
  }
  @catch (NSException *exception) {
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
  }
  @finally {
  }
  
  return false;
}


//MARK: document metadata

-(void)SimpleSaveChanges
{
  STDocumentMetadata* metadata = [self LoadMetadataFromDocument:[self activeDocument] createIfEmpty:true];
//  var metadata = Manager.LoadMetadataFromDocument(ActiveDocument, true);
//  metadata.RepresentMissingValues = missingValueSettings1.GetMissingValuesSelection();
//  metadata.CustomMissingValue = missingValueSettings1.GetCustomMissingValueString();
  [self SaveMetadataToDocument:[self activeDocument] metadata:metadata];
//  Manager.SaveMetadataToDocument(ActiveDocument, metadata);
}

/**
Creates a document metadata container that will hold information about the StatTag environment
used to create the Word document.
*/
-(STDocumentMetadata*)CreateDocumentMetadata
{
  STDocumentMetadata* metadata = [[STDocumentMetadata alloc] init];
  
  metadata.StatTagVersion = [STUIUtility GetVersionLabel];
  metadata.RepresentMissingValues = [[[self SettingsManager] Settings] RepresentMissingValues];
  metadata.CustomMissingValue = [[[self SettingsManager] Settings] CustomMissingValue];
  metadata.MetadataFormatVersion = [STDocumentMetadata CurrentMetadataFormatVersion];
  metadata.TagFormatVersion = [STTag CurrentTagFormatVersion];

  return metadata;
}

/**
 Saves associated metadata about StatTag to the properties in the supplied document.
@param document: The Word Document object we are saving the metadata to
@param metadata: The metadata object to be serialized and saved
*/
-(void)SaveMetadataToDocument:(STMSWord2011Document*)document metadata:(STDocumentMetadata*)metadata
{
  //Log("SaveMetadataToDocument - Started");

  SBElementArray<STMSWord2011Variable*>* variables = [document variables];
  STMSWord2011Variable* variable = [variables objectWithName:MetadataAttribute];
  
  //NSString* value = [variable variableValue];
  
  //var variable = variables[MetadataAttribute];
  if(metadata == nil)
  {
    metadata = [self CreateDocumentMetadata];
  }
  NSString* attribute = [metadata Serialize:nil];

  if (![self DocumentVariableExists:variable])
  {
    //Log(string.Format("Metadata variable does not exist.  Adding attribute value of {0}", attribute));
    [WordHelpers createOrUpdateDocumentVariableWithName:MetadataAttribute andValue:attribute];
  }
  else
  {
    //Log(string.Format("Metadata variable already exists.  Updating attribute value to {0}", attribute));
    [WordHelpers createOrUpdateDocumentVariableWithName:MetadataAttribute andValue:attribute];
  }

  // Historically we just saved the code file list.  Starting in v3.1 we save more metadata, so the original
  // call to save the code file list is just called afterwards.
  [self SaveCodeFileListToDocument:document];
  //  Log("SaveMetadataToDocument - Finished");
}

-(STDocumentMetadata*)LoadMetadataFromCurrentDocument:(bool)createIfEmpty
{
  STMSWord2011Document* document = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
  
  return [self LoadMetadataFromDocument:document createIfEmpty:createIfEmpty];
}


/**
 Loads associated metadata about StatTag from the properties in the supplied document.
@param document: The Word document of interest
@param createIfEmpty: If true, and there is no metadata for the document, a default instance of the metadata will be created.  If false, and no metadata exists, null will be returned.
*/
-(STDocumentMetadata*)LoadMetadataFromDocument:(STMSWord2011Document*)document createIfEmpty:(bool)createIfEmpty
{
  //Log("LoadMetadataFromDocument - Started");
  STDocumentMetadata* metadata = nil;
  // Right now, we don't worry about holding on to metadata from the document (outside of the code file list),
  // we just read it and log it so we know a little more about the document.

  SBElementArray<STMSWord2011Variable*>* variables = [document variables];
  STMSWord2011Variable* variable = [variables objectWithName:MetadataAttribute];

//  NSString* value = [variable variableValue];
//  NSLog(@"value: %@", value);

  
  if([self DocumentVariableExists:variable])
  {
//    NSLog(@"variable: %@", variable);
//    NSLog(@"variableValue: %@", [variable variableValue]);
    metadata = [STDocumentMetadata Deserialize:[variable variableValue] error:nil];
  }
  else if (createIfEmpty)
  {
    metadata = [self CreateDocumentMetadata];
  }
  
  //Log("LoadMetadataFromDocument - Finished");
  
  return metadata;
}

//MARK: other... stuff.
/**
 Save the referenced code files to the current Word document.
 @param document: The Word document of interest
*/
-(void) SaveCodeFileListToDocument:(STMSWord2011Document*) document {
  
  if(document == nil) {
    document = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
  }
  
  //NSLog(@"SaveCodeFileListToDocument - Started");
  SBElementArray<STMSWord2011Variable*>* variables = [document variables];
  STMSWord2011Variable* variable = [variables objectWithName:ConfigurationAttribute];
  
  @try {
    NSMutableArray<STCodeFile*>* files = [self GetCodeFileList:document];
    BOOL hasCodeFiles = (files != nil && [files count] > 0);
    NSString* attribute = [STCodeFile SerializeList:files error:nil];
    if(![self DocumentVariableExists:variable]) {
      if (hasCodeFiles)
      {
        //NSLog(@"%@", [NSString stringWithFormat:@"Document variable does not exist.  Adding attribute value of %@", attribute]);
        [WordHelpers createOrUpdateDocumentVariableWithName:ConfigurationAttribute andValue:attribute];
      }
      else
      {
        //NSLog(@"There are no code files to add.");
      }
    } else {
      if (hasCodeFiles)
      {
        //NSLog(@"%@", [NSString stringWithFormat:@"Document variable already exists.  Updating attribute value to %@", attribute]);
        variable.variableValue = attribute;
      }
      else {
        //NSLog(@"There are no code files - removing existing variable");
        [variables removeObject:variable]; //can we do this?
      }
    }
  }
  @catch (NSException *exception) {
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
  }
  @finally {
    
  }
  //NSLog(@"SaveCodeFileListToDocument - Finished");
}


/**
  Load the list of associated Code Files from a Word document.
  @param document: The Word document of interest
*/
-(void)LoadCodeFileListFromDocument:(STMSWord2011Document*)document {
  //NSLog(@"LoadCodeFileListFromDocument - Started for doc at path %@", [document fullName]);

  //NSLog(@"variables : count: %lu", (unsigned long)[[document variables] count]);
  
  NSArray<STMSWord2011Variable*>* variables = [document variables];
  STMSWord2011Variable* variable;
  for(STMSWord2011Variable* var in variables) {
    //NSLog(@"variable name: %@ with value : %@", [var name], [var variableValue]);
    if([[var name] isEqualToString:ConfigurationAttribute]) {
      variable = var;
    }
  }
  
  @try {
    if([self DocumentVariableExists:variable]) {
      //NSLog(@"variable : %@ has value : %@", [variable name], [variable variableValue]);
      NSMutableArray<STCodeFile*>* list = [[NSMutableArray<STCodeFile*> alloc] initWithArray:[STCodeFile DeserializeList:[variable variableValue] error:nil]];
      [DocumentCodeFiles setObject:list forKey:[document fullName]];
      //NSLog(@"Document variable existed, loaded %lu code files", (unsigned long)[list count]);
    } else {
      [DocumentCodeFiles setObject:[[NSMutableArray<STCodeFile*> alloc] init] forKey:[document fullName]];
      //NSLog(@"Document variable does not exist, no code files loaded");
    }
    NSString* value = [variable variableValue];
    #pragma unused(value)
    //NSLog(@"DocumentVariableExists: variable: %@ has value: %@", [variable name], value);
  }
  @catch (NSException *exception) {
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
  }
  @finally {
    //Marshal.ReleaseComObject(variable);
    //Marshal.ReleaseComObject(variables);
  }

  //NSLog(@"LoadCodeFileListFromDocument - Finished");
}


/**
 Insert an image (given a definition from an tag) into the current Word document at the current cursor location.
 */
-(void) InsertImage:(STTag*) tag {
  //[NSException raise:@"InsertImage not implemented" format:@"InsertImage not implemented"];
  
  //NSLog(@"InsertImage - Started");
  if (tag == nil)
  {
    //NSLog(@"The tag is null, no action will be taken");
    return;
  }

  if ([tag CachedResult] == nil || [[tag CachedResult] count] == 0)
  {
    //NSLog(@"The tag has no cached results - unable to insert image");
    return;
  }

  NSString* fileName = [[[tag CachedResult] firstObject] FigureResult];
  BOOL inserted = [WordHelpers insertImageAtPath:fileName];
  if(inserted == NO)
  {
    NSDictionary* errorInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[[tag CodeFile] StatisticalPackage], @"StatisticalPackage", [NSString stringWithFormat:@"Unable to insert image at path '%@'", fileName], @"ErrorDescription", nil];

    @throw [NSException exceptionWithName:NSGenericException
                                   reason:[NSString stringWithFormat:@"There was an error while inserting the image: %@", [fileName lastPathComponent]]
                                 userInfo:errorInfo];
  }
  //NSLog(@"InsertImage - Finished");
  
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
  
  ////NSLog(@"IsTableTagChangingDimensions [tagUpdatePair New] className: %@", [[tagUpdatePair New] className]);
  ////NSLog(@"IsTableTagChangingDimensions [tagUpdatePair New] className: %@", [[tagUpdatePair Old] className]);
  
  if (![[tagUpdatePair Old] IsTableTag] || ![[tagUpdatePair New]IsTableTag])
  {
    return false;
  }
  
  // Are we changing the display of headers?
//  if (tagUpdatePair.Old.TableFormat.IncludeColumnNames != tagUpdatePair.New.TableFormat.IncludeColumnNames
//      || tagUpdatePair.Old.TableFormat.IncludeRowNames != tagUpdatePair.New.TableFormat.IncludeRowNames)
//  {
//    //NSLog(@"Table dimensions have changed based on header settings");
//    return true;
//  }
  
  if (![tagUpdatePair.Old.TableFormat.ColumnFilter isEqual:tagUpdatePair.New.TableFormat.ColumnFilter]
    || ![tagUpdatePair.Old.TableFormat.RowFilter isEqual:tagUpdatePair.New.TableFormat.RowFilter])
  {
    //NSLog(@"Table dimensions have changed based on filter settings");
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


  //NSLog(@"RefreshTableTagFields - Started");
  NSMutableArray<STMSWord2011Field*>* fields = [WordHelpers getAllFieldsInDocument:document];
  NSInteger fieldsCount = [fields count];
  bool tableRefreshed = false;
  
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  
  // Fields is a 1-based index
  //NSLog(@"Preparing to process %ld} fields", fieldsCount);
  for (NSInteger index = fieldsCount - 1; index >= 0; index--)
  {
    STMSWord2011Field* field = fields[index];
    if (field == nil)
    {
      //NSLog(@"Null field detected at index %ld", index);
      continue;
    }
    
    
    if (![[_TagManager class] IsStatTagField:field])
    {
      //Marshal.ReleaseComObject(field);
      continue;
    }


    //NSLog(@"Processing StatTag field");
    STFieldTag* fieldTag = [_TagManager GetFieldTag:field];
    if (fieldTag == nil)
    {
      //NSLog(@"The field tag is null or could not be found");
      continue;
    }
    
    if ([tag isEqual:fieldTag])
    {
      BOOL isFirstCell = ([fieldTag TableCellIndex] != nil &&
                          [[fieldTag TableCellIndex] integerValue] == 0);
      NSInteger firstFieldLocation = -1;
      if (isFirstCell)
      {
        [WordHelpers select:field];
        STMSWord2011SelectionObject* selection = [app selection];
        
        firstFieldLocation = [selection selectionStart]; //selection.Range.Start;
        
        //NSLog(@"First table cell found at position %ld", firstFieldLocation);
      }
      
      [field delete]; //does this work?
      
      if (isFirstCell)
      {
        [app selection].selectionStart = firstFieldLocation;
        [app selection].selectionEnd = firstFieldLocation;
        
        //NSLog(@"Set position, attempting to insert table");
        [self InsertField:tag];
        tableRefreshed = true;
      }
    }
    
  }
  
  //[WordHelpers toggleAllFieldCodes];
  
  //NSLog(@"RefreshTableTagFields - Finished, Returning %d", tableRefreshed);
  return tableRefreshed;

}

+(void)toggleWordFieldsForTags:(NSArray<STTag*>*)tags
{
  for(STTag* tag in tags)
  {
    [self toggleWordFieldsForTag:tag];
  }
}

+(void)toggleWordFieldsForTag:(STTag*)tag
{
  for(STMSWord2011Field* field in [[[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument] fields]) {
    if(field != nil && tag != nil && [[[field fieldCode] content] containsString:[NSString stringWithFormat:@"MacroButton %@", [STConstantsFieldDetails MacroButtonName]]] && [[[[field nextField] fieldCode] content] hasSuffix:[NSString stringWithFormat:@"ADDIN %@", [tag Name]]])
    {
      field.showCodes = NO;
      field.showCodes = NO;
      field.nextField.showCodes = NO;
      field.nextField.showCodes = NO;
      
//      field.showCodes = ![field showCodes];
//      field.showCodes = ![field showCodes];
//      [[field nextField] setShowCodes:![[field nextField] showCodes]];
//      [[field nextField] setShowCodes:![[field nextField] showCodes]];
    }
  }
}


/**
 Processes all inline shapes within the document, which will include our inserted figures.
 If the shape can be updated, we will process the update.
*/
-(void)UpdateInlineShapes:(STMSWord2011Document*)document {
  
  SBElementArray<STMSWord2011InlineShape*>* shapes = [document inlineShapes];
  if (shapes == nil)
  {
    return;
  }
  
  NSInteger shapesCount = [shapes count];
  for (NSInteger shapeIndex = 0; shapeIndex <= shapesCount; shapeIndex++)
  {
    STMSWord2011InlineShape* shape = shapes[shapeIndex];
    if (shape != nil)
    {
      STMSWord2011LinkFormat* linkFormat = [shape linkFormat];
      if (linkFormat != nil)
      {
        //NSLog(@"linkFormat : autoUpdate : %hhd for path : %@", [linkFormat autoUpdate], [linkFormat sourceFullName]);
        
        if([WordHelpers imageExistsAtPath:[linkFormat sourceFullName]]) {
          linkFormat.sourceFullName = [linkFormat sourceFullName];
          linkFormat.sourceFullName = [linkFormat sourceFullName];
          //NSLog(@"updating shape[%ld] with file path : '%@'", shapeIndex, [linkFormat sourceFullName]);
        } else {
          //NSLog(@"UpdateInlineShapes tried to update a file and can't find image at requested path - '%@'", [linkFormat sourceFullName]);
        }
        // see thread - http://stackoverflow.com/questions/38621644/word-applescript-update-link-format-working-with-inline-shapes
        //linkFormat.Update(); //so this doesn't exist in any useful way - so we have to "update" by setting the full source path - _twice_.  First time just breaks things. Second time - it sticks.
      }
    }
  }

  
}



/// <summary>
/// Processes all content controls within the document, which may include verbatim output.
/// Handles renaming of tags as well, if applicable.
/// </summary>
/// <param name="document">The current document to process</param>
/// <param name="tagUpdatePair"></param>
-(void)UpdateVerbatimEntries:(STMSWord2011Document*)document tagUpdatePair:(STUpdatePair<STTag*>*)tagUpdatePair
{
  NSArray<STMSWord2011Shape*>* shapes = [document shapes];
  if([shapes count] == 0)
  {
    return;
  }
  
  STTagManager* tm = [self TagManager];
  
  NSInteger shapeCount = [shapes count];
  for (NSInteger index = 0; index <= shapeCount; index++)
  {
    STMSWord2011Shape* shape = [shapes objectAtIndex:index];
    if (shape != nil)
    {
      if ([STTagManager IsStatTagShape:shape])
      {
        STTag* tag = [tm FindTag:[shape name]];
        if (tag == nil)
        {
          [self Log:[NSString stringWithFormat:@"No tag was found for the control with ID: %@", [shape name]]];
          continue;
        }
        
        if ([tag Type] != [STConstantsTagType Verbatim])
        {
          [self Log:[NSString stringWithFormat:@"The tag (%@) was inserted as verbatim but is now a different type.  We are unable to update it.", [tag Id]]];
        }
        
        // If the tag update pair is set, it will be in response to renaming.  Make sure
        // we apply the new tag name to the control
        if (tagUpdatePair != nil && [[tagUpdatePair Old] isEqual:tag])
        {
          [shape setName:[[tagUpdatePair New] Id]];
        }

        [[[shape textFrame] textRange] setContent:[tag FormattedResult]];
      }
    }
  }
  
}

-(void)UpdateVerbatimEntries:(STMSWord2011Document*)document
{
  [self UpdateVerbatimEntries:document tagUpdatePair:nil];
}

/**
 Update all of the field values in the current document.

  @remark This does not invoke a statistical package to recalculate values, it assumes
  that has already been done.  Instead it just updates the displayed text of a field
  with whatever is set as the current cached value.

 @param tagUpdatePair: An optional tag to update.  If specified, the contents of the tag (including its underlying data) will be refreshed.
 The reason this is an Tag and not a FieldTag is that the function is only called after a change to the main tag reference.
 If not specified, all tag fields will be updated

 @param matchOnPosition: If set to true, an tag will only be matched if its line numbers (in the code file) are a match.  This is used when updating after disambiguating two tags with the same name, but isn't needed otherwise.
 */
//public void UpdateFields(UpdatePair<Tag> tagUpdatePair = null, bool matchOnPosition = false)
-(void)UpdateFields:(STUpdatePair<STTag*>*)tagUpdatePair matchOnPosition:(BOOL)matchOnPosition ignoreIndexes:(NSArray<NSNumber*>*)ignoreIndexes {
  
  //NSLog(@"UpdateFields - Started");
  
  STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
  //NSLog(@"Application (%@) : %@", [application name], application );
  STMSWord2011Document* document = [application activeDocument];
  
  //[[application settings] setAnimateScreenMovements:NO]; //nope...
  
  
  
  //FIXME: we need to do something different...
  //Cursor.Current = Cursors.WaitCursor;
  //application.ScreenUpdating = false;
  
  //[WordHelpers disableScreenUpdates];
  
  [self setValue:@"Updating Fields" forKey:@"wordFieldUpdateStatus"];
  
  
  @try
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"tagUpdateStart" object:self userInfo:@{@"tagName":[[tagUpdatePair New] Name], @"codeFileName":[[[tagUpdatePair New] CodeFile] FileName], @"type" : @"field"}];
    });

    dispatch_async(dispatch_get_main_queue(), ^{
      BOOL tableDimensionChange = [self IsTableTagChangingDimensions:tagUpdatePair];
      if (tableDimensionChange) {
        //NSLog(@"Attempting to refresh table with tag name: %@", tagUpdatePair.New.Name);
        [self setValue:@"Updating Table Fields" forKey:@"wordFieldUpdateStatus"];
        if ([self RefreshTableTagFields:[tagUpdatePair New] document:document]) {
          //NSLog(@"Completed refreshing table - leaving UpdateFields");
          return;
        }
      }
      
      NSMutableArray<STMSWord2011Field*>* fields = [WordHelpers getAllFieldsInDocument:document];
      NSInteger fieldsCount = [fields count];
      // Fields is a 1-based index
      //NSLog(@"Preparing to process %ld fields", fieldsCount);

      [self setValue:@"Updating Fields" forKey:@"wordFieldUpdateStatus"];

      //FIXME: it's 1-based in Windows - but on the Mac? We should check...
      for (NSInteger index = 0; index < fieldsCount; index++) {
        
        STMSWord2011Field* field = fields[index];
        if (field == nil) {
          //NSLog(@"Null field detected at index %ld", index);
          continue;
        }
        
        if (![[_TagManager class] IsStatTagField:field]) {
          [self setValue:[NSNumber numberWithInteger:index+1] forKey:@"wordFieldsUpdated"];
          continue;
        }

        if (ignoreIndexes != nil && [ignoreIndexes count] > 0) {
          NSNumber *entryIndex = [NSNumber numberWithInteger:[field entry_index]];
          NSUInteger matchingIndex = [ignoreIndexes indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
              if ([(NSNumber *) obj compare:entryIndex] == 0) {
                *stop = YES;
                return YES;
              }
              return NO;
          }];

          if (matchingIndex != NSNotFound) {
            continue;
          }
        }

        //NSLog(@"Processing StatTag field");
        //NSLog(@"RefreshTableTagFields -> found field : %@ and json : %@", [[field fieldCode] content], [field fieldText]);
        
        STFieldTag* tag = [_TagManager GetFieldTag:field];
        
        //NSLog(@"after tag generation");
        //NSLog(@"tag has FormattedResult : %@", [tag FormattedResult]);
        
        if (tag == nil)
        {
          //NSLog(@"The field tag is null or could not be found");
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
            continue;
          }
          
          //NSLog(@"Processing only a specific tag with label: %@", tagUpdatePair.New.Name);
          tag = [[STFieldTag alloc] initWithTag:[tagUpdatePair New] andFieldTag:tag];
          [_TagManager UpdateTagFieldData:field tag:tag];
        }
        
        //turnign this off for now - this doesn't address changing tag definitions - ex: hey, our formatting specs changed
        // since we're storign json in the field itself this is a problem
        //NSLog(@"Inserting field for tag: %@", tag.Name);
        //let's see if we can avoid udpating content that already matches our desired result
        // this is insanely inefficient and risky, but for now we're going to just see if it works
  //      NSString* fieldText = [[[field fieldCode] formattedText] content];
  //      NSRange r1 = [fieldText rangeOfString:[NSString stringWithFormat:@"MacroButton %@ ", [STConstantsFieldDetails MacroButtonName]]];
  //      NSRange r2 = [fieldText rangeOfString:@" ADDIN "];
  //      NSRange fieldContentRange = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
  //      NSString* fieldContent = [fieldText substringWithRange:fieldContentRange];
  //      if(![fieldContent isEqualToString:[tag FormattedResult]])
  //      {
          [WordHelpers select:field];
          [self InsertField:tag];
  //      }
        
        [self setValue:[NSNumber numberWithInteger:index+1] forKey:@"wordFieldsUpdated"];
        
      }
      
      //Moved here to see about updating after field updates
      // trying to address the situation where we don't have data in the field before we update it
      //NOTE: No - this isn't great because we're updating ALL shapes
      //also adding in a really quick check for "only do this to figures"
      if([[[tagUpdatePair Old] Type] isEqualToString:[STConstantsTagType Figure]] || [[[tagUpdatePair New] Type] isEqualToString:[STConstantsTagType Figure]])
      {
        //NSLog(@"before UpdateInlineShapes");
        [self setValue:@"Updating Inline Shapes" forKey:@"wordFieldUpdateStatus"];
        [self UpdateInlineShapes:document];
        //NSLog(@"after UpdateInlineShapes");
      }

      if([[[tagUpdatePair Old] Type] isEqualToString:[STConstantsTagType Verbatim]] || [[[tagUpdatePair New] Type] isEqualToString:[STConstantsTagType Verbatim]])
      {
        //NSLog(@"before UpdateVerbatimEntries");
        [self setValue:@"Updating Verbatim Field" forKey:@"wordFieldUpdateStatus"];
        [self UpdateVerbatimEntries:document tagUpdatePair:tagUpdatePair];
        //NSLog(@"after UpdateVerbatimEntries");
        
      }
    });
    
  }
  @catch (NSException *exception) {
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
  }
  @finally
  {
    //Cursor.Current = Cursors.Default;
    //application.ScreenUpdating = true;
    //[WordHelpers enableScreenUpdates];

  }

  //[WordHelpers toggleAllFieldCodes];
  //[[application settings] setAnimateScreenMovements:YES]; //Nope...
  
  //NSLog(@"UpdateFields - Finished");
  
  
}
-(void)UpdateFields:(STUpdatePair<STTag*>*)tagUpdatePair ignoreIndexes:(NSArray<NSNumber*>*)ignoreIndexes {
  [self UpdateFields:tagUpdatePair matchOnPosition:false ignoreIndexes:ignoreIndexes];
}
-(void)UpdateFields:(STUpdatePair<STTag*>*)tagUpdatePair {
  [self UpdateFields:tagUpdatePair matchOnPosition:false ignoreIndexes:nil];
}
-(void)UpdateFields {
  [self UpdateFields:nil ignoreIndexes:nil];
}

/**
 Helper function to retrieve Cells from a Selection.  This guards against exceptions
 and just returns null when thrown (indicating no Cells found).
 */
-(SBElementArray<STMSWord2011Cell*>*)GetCells:(STMSWord2011SelectionObject*)selection {
  @try {
    return [selection cells];
  }
  @catch (NSException *exception) {
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
  }
  return nil;
}

/**
  Utility method that assumes the cursor is in a single cell of an existing table.  It then finds the maximum number
  of cells that it can fill in that fit within the dimensions of that table, and that use the available data for
  the resulting table.
 */
-(SBElementArray<STMSWord2011Cell*>*)SelectExistingTableRange:(STMSWord2011Cell*)selectedCell table:(STMSWord2011Table*)table dimensions:(NSArray<NSNumber*>*)dimensions {

  SBElementArray<STMSWord2011Column*>* columns = [table columns];
  SBElementArray<STMSWord2011Row*>* rows = [table rows];

  NSInteger endColumn = MIN([columns count], [selectedCell columnIndex] + [[dimensions objectAtIndex:[STConstantsDimensionIndex Columns]] integerValue] - 1);
  NSInteger endRow = MIN([rows count], [selectedCell rowIndex] + [[dimensions objectAtIndex:[STConstantsDimensionIndex Rows]] integerValue] - 1);
  
  //NSLog(@"Selecting in existing to row %ld, column %ld", (long)endRow, (long)endColumn);
  //NSLog(@"Selected table has %ld rows and %ld columns", (long)[rows count], (long)[columns count]);
  //NSLog(@"Table to insert has dimensions %ld by %ld", [dimensions[0] integerValue], [dimensions[1] integerValue]);

  STMSWord2011Cell* endCell = [table getCellFromTableRow:endRow column:endColumn];
  
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* document = [app activeDocument];
  
  [WordHelpers select:[document createRangeStart:[[selectedCell textObject] startOfContent] end:[[endCell textObject] endOfContent]]];
  
  SBElementArray<STMSWord2011Cell*>* cells = [self GetCells:[app selection]];
  
  return cells;
}



/// <summary>
/// Inserts a rich text edit control
/// </summary>
/// <param name="selection"></param>
/// <param name="tag"></param>
-(void)InsertVerbatim:(STMSWord2011SelectionObject*)selection tag:(STTag*)tag
{
  //[self Log:@"InsertVerbatim - Started"];
  
  if (tag == nil)
  {
    [self Log:@"Unable to insert the verbatim output because the tag is null"];
    return;
  }
  
  STCommandResult* result = [[tag CachedResult] firstObject];
  if (result != nil)
  {
    //STMSWord2011TextRange* range = [selection formattedText];//unclear if this is what we want to use
    NSInteger rangeStart = [selection selectionStart];
    NSInteger rangeEnd = [selection selectionEnd];
    
    //we have to offload this directly to AppleScript so we can do what we need to
    [WordHelpers insertTextboxAtRangeStart:rangeStart andRangeEnd:rangeEnd forShapeName:[tag Id] withShapetext:[result VerbatimResult] andFontSize:9.0 andFontFace:@"Courier New"];
  }
  
  //[self Log:@"InsertVerbatim - Finished"];
}


/**
 Insert a table tag into the current selection.

 @remark This assumes that the tag is known to be a table result.
 */
-(NSArray<NSNumber*>*)InsertTable:(STMSWord2011SelectionObject*)selection tag:(STTag*)tag {

  //NSLog(@"InsertTable - Started");
  NSMutableArray<NSNumber*>* addedFields = [[NSMutableArray alloc] init];

  //FIXME: more "end of document padding"
  //we're going to insert a pad after the table for the moment - same issue we have with field insertions at the end of the document
  @autoreleasepool {
  NSInteger selectionStart = [selection selectionStart];
  NSInteger selectionEnd = [selection selectionEnd];

  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];
  NSInteger fieldCloseLength = [[STFieldGenerator FieldClose] length];
  NSInteger docEndOfContent = [[doc textObject] endOfContent];

  STMSWord2011TextRange* selectionRange = [selection textObject];
  if((selectionEnd + fieldCloseLength) > docEndOfContent) {
    STMSWord2011TextRange* padRange = [WordHelpers DuplicateRange:selectionRange];
    [WordHelpers setRange:&padRange start:selectionEnd end:selectionEnd];
    
    //NSLog(@"startOfContent: %ld", [padRange startOfContent]);
    //NSLog(@"endOfContent: %ld", [padRange endOfContent]);
    
    for(NSInteger i = 0; i < fieldCloseLength; i++) {
      [WordHelpers insertParagraphAtRange:padRange];
    }
    [WordHelpers setRange:&padRange start:[padRange startOfContent] end:[padRange endOfContent] + fieldCloseLength];
    [WordHelpers selectTextAtRangeStart:selectionStart andEnd:selectionEnd];
    selection = [[[[STGlobals sharedInstance] ThisAddIn] Application] selection];
  }

  
  
  if (tag == nil) {
    //NSLog(@"Unable to insert the table because the tag is nil");
    return addedFields;
  }
  
  if (![tag HasTableData]) {
    STMSWord2011TextRange* selectionRange = [selection textObject];
    [self CreateTagField:selectionRange tagIdentifier:[tag Id] displayValue:[STConstantsPlaceholders EmptyField] tag:tag withDoc:doc];
    //NSLog(@"Unable to insert the table because there are no cached results for the tag");
    return addedFields;
  }
  
  SBElementArray<STMSWord2011Cell*>* cells = [self GetCells:selection];
  [tag UpdateFormattedTableData];

  STTable* table = [[[tag CachedResult] firstObject] TableResult];
  NSArray<NSNumber*>* dimensions = [tag GetTableDisplayDimensions];
  
  NSInteger cellsCount = cells == nil ? 0 : [cells count];  // Because of the issue we mention below, pull the cell count right away
  
  // Insert a new table if there is none selected.
  if (cellsCount == 0) {
    //NSLog(@"No cells selected, creating a new table");
    STMSWord2011Table* wordTable = [self CreateWordTableForTableResult:selection table:table format:[tag TableFormat] dimensions:dimensions];
    [WordHelpers select:wordTable];
    
    // The table will be the size we need.  Update these tracking variables with the cells and
    // total size so that we can begin inserting data.
    cells = [self GetCells:selection];
    cellsCount = [[dimensions objectAtIndex:0] integerValue] * [[dimensions objectAtIndex:1] integerValue];
  }
  // Our heuristic is that a single cell selected with the selection being the same position most
  // likely means the user has their cursor in a table.  We are going to assume they want us to
  // fill in that table.
  else if (cellsCount == 1 && [[selection textObject] startOfContent] == [[selection textObject] endOfContent]) {
    //NSLog(@"Cursor is in a single table cell, selecting table");
    cells = [self SelectExistingTableRange:[cells firstObject] table:[[selection tables] firstObject] dimensions:dimensions];
    cellsCount = [cells count];
  }
  
  NSArray<NSString*>* displayData = [STTableUtil GetDisplayableVector:[table FormattedCells] format:[tag TableFormat]];
  if (displayData == nil || [displayData count] == 0) {
    [STUIUtility WarningMessageBoxWithTitle:@"There are no table results to insert." andDetail:@"" logger:[self Logger]];
    return addedFields;
  }
  
  if (cells == nil) {
    //NSLog(@"Unable to insert the table because the cells collection came back as nil.");
    return addedFields;
  }

  /*
   This is way more gnarly than the Windows version.
   
   In the Mac version, if we adjust ANY of the cell data inside of the cell list, the cell list is sort of... invalidated.  We modified the range info, etc. so the meaning of "the cell" is lost.  The reference to the object will be there, but the object loses the row/column position info as well as the key bit - the text range.
   
   So we have to do this differently... we have to build a reference to our origin table, then store and re-use the row/column (think: x,y) positions - then we can run through that (x,y) list and rebuild the cell (referencing the origin table)
   
   To do that, we're going to abuse NSPoint
   
   1) We have a cell collection
   2) cells in the collection have positions within their parent table - we store those points (x,y) in an array (our point array)
   3) cells (in the Mac version) do NOT have pointers to their parent table - BUT they do have a text range with a start/end position
   4) we get our first cell in our cell list
   5) we iterate through the list of the tables in the document
   6) we take our “key” cell (1,1) and ask the table to return its (1,1) cell
   7) since the cell is a copy in the Mac version, we can’t just do a pointer / equivalency check (not the same object) - BUT we can compare the text range start / end - “same cell”
   8) once we have the “same” cell, we know it’s the same table
   9) we store that table reference
   10) then - we iterate through our point array and then say “get cell from table”
   
   */
  
  NSMutableArray<NSValue*>* cellPoints = [[NSMutableArray<NSValue*> alloc] init];
  for (STMSWord2011Cell* cell in cells) {
    NSPoint point;
    point.x = [cell rowIndex];
    point.y = [cell columnIndex];
    [cellPoints addObject:[NSValue valueWithPoint:point]];
    //NSLog(@"cell (%ld,%ld)", [cell rowIndex], [cell columnIndex]);
  }
  
  STMSWord2011Cell* findCell = [cells firstObject];
  STMSWord2011Table* cellTable;

  for(STMSWord2011Table* aTable in [doc tables]) {
    STMSWord2011Cell* tableCell = [aTable getCellFromTableRow:[findCell rowIndex] column:[findCell columnIndex]];
    if([[findCell textObject] startOfContent] == [[tableCell textObject] startOfContent]
       && [[findCell textObject] endOfContent] == [[tableCell textObject] endOfContent]) {
      cellTable = aTable;
      break;
    }
  }
  
  //NSLog(@"cell Points : %@", cellPoints);

  // Wait, why aren't I using a for (NSInteger index = 0...) loop instead of this foreach?
  // There is some weird issue with the Cells collection that was crashing when I used
  // a for loop and index.  After a few iterations it was chopping out a few of the
  // cells, which caused a crash.  No idea why, and moved to this approach in the interest
  // of time.  Long-term it'd be nice to figure out what was causing the crash.
  NSInteger index = 0;
  for (NSValue* value in cellPoints) {
    NSPoint cellPoint = [value pointValue];
    STMSWord2011Cell* cell = [cellTable getCellFromTableRow:cellPoint.x column:cellPoint.y];
    
    if (index >= [displayData count]) {
      //NSLog(@"Index %ld is beyond result cell length of %ld", index, [displayData count]);
      break;
    }
    
    // When inserting a field in a table cell, the cell object will often give us back a range that
    // extends one character too far.  For some reason (still not known), if we use this range as-is,
    // we fail to insert a new field.  Instead, we will just insert at the beginning of the cell.
    STMSWord2011TextRange* range = [cell textObject];
    [WordHelpers setRange:&range start:([range startOfContent]) end:([range startOfContent]) withDoc:doc];

    // Make a copy of the tag and set the cell index.  This will let us discriminate which cell an tag
    // value is related with, since we have multiple fields (and therefore multiple copies of the tag) in the
    // document.  Note that we are wiping out the cached value to just have the individual cell value present.
    STCommandResult* commandResult = [[STCommandResult alloc] init];
    commandResult.ValueResult = [displayData objectAtIndex:index];
    NSMutableArray<STCommandResult*>* cachedResult = [[NSMutableArray<STCommandResult*> alloc] init];
    [cachedResult addObject:commandResult];
    STFieldTag* innerTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:[NSNumber numberWithInteger:index]];
    innerTag.CachedResult = cachedResult;
    
    STMSWord2011Field* field = [self CreateTagField:range tagIdentifier:[NSString stringWithFormat:@"%@%@%ld", [tag Name], [STConstantsReservedCharacters TagTableCellDelimiter], index] displayValue:[innerTag FormattedResult] tag:innerTag withDoc:doc];
    [addedFields addObject:[NSNumber numberWithInteger:[field entry_index]]];
    index++;
  }
  
  [self WarnOnMismatchedCellCount:cellsCount dataLength:[displayData count] ];
  
  // Once the table has been inserted, re-select it (inserting fields messes with the previous selection) and
  // insert a new line after it.  This gives us spacing after a table so inserting multiple tables doesn't have
  // them all glued together.
  
  [WordHelpers select:[[selection tables] firstObject]];
  
  STMSWord2011SelectionObject* tableSelection = [app selection];
  [self InsertNewLineAndMoveDown:tableSelection];
  return addedFields;
  //NSLog(@"InsertTable - Finished");
  }
}


/**
 Helper method to insert a new line in the document at the current selection, and then move the cursor down.  This gives us a way to insert extra space after a table is inserted.

 @param selection: The selection to insert the new line after.
 */
-(void)InsertNewLineAndMoveDown:(STMSWord2011SelectionObject*) selection
{
  [[selection textObject] collapseRangeDirection:STMSWord2011E132CollapseEnd];
  STMSWord2011TextRange* range = [selection textObject];
  [WordHelpers insertParagraphAtRange:range];
  [[selection textObject] moveRangeBy:STMSWord2011E129ALineItem count:1];
}

/**
  Create a new table in the Word document at the current selection point.  This assumes we have a
  statistical result containing a table that needs to be inserted.
 */
-(STMSWord2011Table*)CreateWordTableForTableResult:(STMSWord2011SelectionObject*)selection table:(STTable*)table format:(STTableFormat*)format dimensions:(NSArray<NSNumber*>*)dimensions {
 
  //NSLog(@"CreateWordTableForTableResult - Started");

  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* __unused doc = [app activeDocument];

  @try {
    NSInteger rowCount = [[dimensions objectAtIndex:0] integerValue];
    NSInteger columnCount = [[dimensions objectAtIndex:1] integerValue];
    //    NSInteger rowCount = (format.IncludeColumnNames) ? (table.RowSize + 1) : (table.RowSize);
    //    NSInteger columnCount = (format.IncludeRowNames) ? (table.ColumnSize + 1) : (table.ColumnSize);

    //NSLog(@"Table dimensions r=%ld, c=%ld", rowCount, columnCount);

    
    STMSWord2011Table* wordTable = [WordHelpers createTableAtRange:[[app selection] textObject] withRows:rowCount andCols:columnCount];
    [WordHelpers select:wordTable];
    
    STMSWord2011BorderOptions* borders = [wordTable borderOptions];
    borders.insideLineStyle = STMSWord2011E167LineStyleSingle;
    borders.outsideLineStyle = STMSWord2011E167LineStyleSingle; //for some reason this is yellow...
    return wordTable;
  }
  @catch (NSException *exception) {
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
  }
  @finally {
  }
  
  //NSLog(@"CreateWordTableForTableResult - Finished");
  return nil;
}


/**
 Provide a warning to the user if the number of data cells available doesn't match
 the number of table cells they selected in the document.
*/
-(void)WarnOnMismatchedCellCount:(NSInteger)selectedCellCount dataLength:(NSInteger)dataLength
{
  //FIXME: this is not ideal - we should be separating UI from this kind of behavior
  if (selectedCellCount > dataLength)
  {
    [STUIUtility WarningMessageBoxWithTitle:@"Unable to generate table" andDetail:[NSString stringWithFormat:@"The number of cells you have selected (%ld) is larger than the number of cells in your results (%ld).\r\n\r\nOnly the first %ld cells have been filled in with results.", selectedCellCount, dataLength, dataLength] logger:[self Logger]];
  }
  else if (selectedCellCount < dataLength)
  {
    [STUIUtility WarningMessageBoxWithTitle:@"Unable to generate table" andDetail:[NSString stringWithFormat:@"The number of cells you have selected (%ld) is smaller than the number of cells in your results (%ld).\r\n\r\nOnly the first %ld cells have been used.", selectedCellCount, dataLength, selectedCellCount] logger:[self Logger]];
  }
}



//MARK: add / update

-(NSMutableArray<NSNumber*>*) InsertField:(id)tag
{
  return [self InsertField:tag insertPlaceholder:FALSE];
}

/**
 Given an tag, insert the result into the document at the current cursor position.
 
 @remark This method assumes the tag result is already refreshed.  It does not attempt to refresh or recalculate it.
 */
-(NSMutableArray<NSNumber*>*) InsertField:(id)tag insertPlaceholder:(BOOL)insertPlaceholder {
  //NSLog(@"InsertField for Tag");
  if([tag isKindOfClass:[STFieldTag class]]) {
    return [self InsertFieldWithFieldTag:tag insertPlaceholder:insertPlaceholder];
  } else if ([tag isKindOfClass:[STTag class]]) {
    return [self InsertFieldWithFieldTag:[[STFieldTag alloc] initWithTag:tag] insertPlaceholder:insertPlaceholder];
  }

  return nil;
}


/**
 Given an tag, insert the result into the document at the current cursor position.

 @remark This method assumes the tag result is already refreshed.  It does not attempt to refresh or recalculate it.
 */
-(NSMutableArray<NSNumber*>*) InsertFieldWithFieldTag:(STFieldTag*)tag insertPlaceholder:(BOOL)insertPlaceholder {
  //NSLog(@"InsertField - Started");

  NSMutableArray<NSNumber*>* addedFields = nil;

  if(tag == nil) {
    //NSLog(@"The tag is null");
    return addedFields;
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tagUpdateStart" object:self userInfo:@{@"tagName":[tag Name], @"codeFileName":[[tag CodeFile] FileName], @"type" : @"field"}];
  });
  
  if(!insertPlaceholder && [[tag Type] isEqualToString:[STConstantsTagType Figure]]) {
    //NSLog(@"Detected a Figure tag");
    [self InsertImage:tag];
    return addedFields;
  }
  
  @try {
    @autoreleasepool {
      STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
      STMSWord2011Document* __unused doc = [app activeDocument];
      STMSWord2011SelectionObject* selection = [app selection];
      if(selection == nil) {
        //NSLog(@"There is no active selection");
        return addedFields;
      }

      // If the tag is a table, and the cell index is not set, it means we are inserting the entire
      // table into the document.  Otherwise, we are able to just insert a single table cell.
      if (!insertPlaceholder && [[tag Type] isEqualToString: [STConstantsTagType Verbatim]])
      {
        [self Log:@"Inserting verbatim output"];
        [self InsertVerbatim:selection tag:tag];
      }
      else if(!insertPlaceholder && [tag IsTableTag] && [tag TableCellIndex] == nil) {
        //NSLog(@"Inserting a new table tag");
        addedFields = [self InsertTable:selection tag:tag];
      } else {
        //NSLog(@"Inserting a single tag field");
        STMSWord2011TextRange* range = [selection textObject];
        NSString* displayName = (insertPlaceholder ? [NSString stringWithFormat:@"[ %@ ]", [tag Name]] : [tag FormattedResult]);
        [self CreateTagField:range tagIdentifier:[tag Name] displayValue:displayName tag:tag withDoc:doc];
      }
      
      //reset the selection so we don't overwrite our new field(s)
      //move the selection to the end of the current selection
      [app selection].selectionStart = [[app selection] selectionEnd];
      [app selection].selectionEnd = [[app selection] selectionEnd];
      
    }
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
  }
  @finally {
    //Marshal.ReleaseComObject(document);
  }

  
  
  return addedFields;
  //NSLog(@"InsertField - Finished");

}

/**
Insert an StatTag field at the currently specified document range.

@param range: The range to insert the field at
@param tagIdentifier: The visible identifier of the tag (does not need to be globablly unique)
@param displayValue: The value that should display when the field is shown.
@param tag: The tag to be inserted
 */
-(STMSWord2011Field*)CreateTagField:(STMSWord2011TextRange*)range tagIdentifier:(NSString*)tagIdentifier displayValue:(NSString*)displayValue tag:(STTag*)tag withDoc:(STMSWord2011Document*)doc {
  //NSLog(@"CreateTagField - Started");
  //NSLog(@"Creating tag with range : (%ld,%ld) and tagIdentifier: %@ and displayValue : %@ with tag : %@", [range startOfContent], [range endOfContent], tagIdentifier, displayValue, tag);
  //C# - XML - can't use it as we don't have support for InsertXML
  //  range.InsertXML(OpenXmlGenerator.GenerateField(tagIdentifier, displayValue, tag));
  
  //C# prior to XML - which we can't use
  //var fields = FieldManager.InsertField(range, string.Format("{3}MacroButton {0} {1}{3}ADDIN {2}{4}{4}",
  //    Constants.FieldDetails.MacroButtonName, displayValue, tagIdentifier, FieldCreator.FieldOpen, FieldCreator.FieldClose));
  //Log(string.Format("Inserted field with identifier {0} and display value {1}", tagIdentifier, displayValue));
  
  NSArray<STMSWord2011Field*>* fields = [[_FieldManager class] InsertField:range displayValue:[STFieldGenerator escapeMacroContent:displayValue] macroButtonName:[STConstantsFieldDetails MacroButtonName] tagIdentifier:tagIdentifier withDoc:doc];

  /*
  NSArray<STMSWord2011Field*>* fields = [[_FieldManager class] InsertField:range theString:
                                         
                                         [NSString stringWithFormat:@"%@MacroButton %@ %@%@ADDIN %@%@%@",
                                          
                                          [STFieldGenerator FieldOpen],
                                          [STConstantsFieldDetails MacroButtonName], //StatTag
                                          [STFieldGenerator escapeMacroContent:displayValue],
                                          [STFieldGenerator FieldOpen],
                                          tagIdentifier,
                                          [STFieldGenerator FieldClose],
                                          [STFieldGenerator FieldClose]
                                          
                                          //0    Constants.FieldDetails.MacroButtonName,
                                          //1    displayValue,
                                          //2    tagIdentifier,
                                          //3    FieldCreator.FieldOpen,
                                          //4    FieldCreator.FieldClose
                                          
                                          ]
                                         withDoc: doc
                                         ];
  */
  
//  [STGlobals activateDocument];
  STMSWord2011Field* macroField = [fields firstObject];
  STMSWord2011Field* dataField = [fields lastObject];
//  [STGlobals activateDocument];
  dataField.fieldText = [tag Serialize:nil];
  
  
  return macroField;
  
  //return [dataField previousField];
  //NSLog(@"CreateTagField - Finished");
}


/**
 Manage the process of editing an tag via a dialog, and processing any changes within the document.

@remark: This does not call the statistical software to update values.  It assumes that the tag contains the most up-to-date cached value and that it may be used for display if needed.
*/
-(BOOL)EditTag:(STTag*)tag existingTag:(STTag*)existingTag
{
  //NSLog(@"EditTag - Started");
  
  @try
  {
    // Save the tag first, before trying to update the tags.  This way even if there is
    // an error during the updates, our results are saved.
    NSError* error;
    [self SaveEditedTag:tag existingTag:existingTag error:&error];
    if(error != nil)
    {
      return false;
    }

    // If the value format has changed, refresh the values in the document with the
    // new formatting of the results.
    // TODO: Sometimes date/time format are null in one and blank strings in the other.  This is causing extra update cycles that aren't needed.
    STUpdatePair* pair = [[STUpdatePair alloc] init:existingTag newItem:tag];
    if (![[tag ValueFormat] isEqual: [existingTag ValueFormat]])
    {
      if (![[tag TableFormat] isEqual: [existingTag TableFormat]])
      {
        [tag UpdateFormattedTableData];
      }
      [self UpdateFields:pair];
    } else if (![[tag TableFormat] isEqual: [existingTag TableFormat]])
    {
      [tag UpdateFormattedTableData];
      [self UpdateFields:pair];
    }

    return true;
  }
  @catch (NSException* exception)
  {
    //NSLog(@"An exception was caught while trying to edit an tag");
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
    [self LogException:exception];
  }
  
  //NSLog(@"EditTag - Finished (no action)");
  return false;
}

/// After an tag has been edited in a dialog, handle all reference updates and saving
/// that tag in its source file.
-(void)SaveEditedTag:(STTag*)tag existingTag:(STTag*)existingTag error:(NSError**)outError
{
  //FIXME: add the error block... - right now we never fail
  if (tag != nil && [tag CodeFile] != nil)
  {
    // Update the code file with whatever was in the editor window.  While the code doesn't
    // always change, we will go ahead with the update each time instead of checking.  Note
    // that after this update is done, the indices for the tag objects passed in can
    // no longer be trusted until we update them.
    STCodeFile* codeFile = [tag CodeFile];
    
    NSError* error;
    [codeFile UpdateContent:[codeFile ContentString] error:error];
    if(error == nil)
    {
      // Now that the code file has been updated, we need to add the tag.  This may
      // be a new tag, or an updated one.
      [codeFile AddTag:tag oldTag:existingTag matchWithPosition:NO];
      // Do NOT set position matching to YES. We do NOT want to match by position for general updates or we'll have issues where people modify lines above the tag position
      [codeFile Save:&error];
    }
  }
}

/**
  Save all changes to all code files referenced by the current document.
*/
-(void)SaveAllCodeFiles:(STMSWord2011Document*) document
{
  // Update the code files with their tags
  for (STCodeFile* file in [self GetCodeFileList:document])
  {
    [file Save:nil];
  }
}

-(void)EditTagField:(STMSWord2011Field*)field
{
  if ([[_TagManager class] IsStatTagField:field])
  {
    STFieldTag* fieldTag = [_TagManager GetFieldTag:field];
    STTag* tag = [_TagManager FindTag:fieldTag];
    [self EditTag:tag existingTag:nil];
  }
}


/**
 This is a specialized utility function to be called whenever the user clicks "Save and Insert" from the Edit Tag dialog.
*/
//-(void)CheckForInsertSavedTag:(STEditTag*)dialog
//{
//  // If the user clicked the "Save and Insert", we will perform the insertion now.
//  if (dialog.InsertInDocument)
//  {
//    Logger.WriteMessage("Inserting into document after defining tag");
//    
//    var tag = FindTag(dialog.Tag.Id);
//    if (tag == null)
//    {
//      Logger.WriteMessage(string.Format("Unable to find tag {0}, so skipping the insert", dialog.Tag.Id));
//      return;
//    }
//    
//    InsertTagsInDocument(new List<Tag>(new[] { tag }));
//  }
//}


/**
  Performs the insertion of tags into a document as fields.
*/
-(STStatsManagerExecuteResult*)InsertTagsInDocument:(NSArray<STTag*>*)tags insertPlaceholder:(BOOL)insertPlaceholder
{
//  Cursor.Current = Cursors.WaitCursor;
//  Globals.ThisAddIn.Application.ScreenUpdating = false;
  
  //NSInteger responseStatus = 0;
  STStatsManagerExecuteResult* allResults = [[STStatsManagerExecuteResult alloc] init];
  allResults.Success = true;

  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];

  
  @try
  {
    NSMutableArray<STTag*>* updatedTags = [[NSMutableArray<STTag*> alloc] init];
    NSMutableArray<STCodeFile*>* refreshedFiles = [[NSMutableArray<STCodeFile*> alloc] init];

    NSMutableArray<NSNumber*>* addedFields = [[NSMutableArray alloc] init];
    for (STTag* tag in tags)
    {
      if(![refreshedFiles containsObject:[tag CodeFile]])
      {
        STStatsManagerExecuteResult* result = [_StatsManager ExecuteStatPackage:[tag CodeFile] filterMode:[STConstantsParserFilterMode TagList] tagsToRun:tags];
        [[allResults UpdatedTags] addObjectsFromArray:[result UpdatedTags]];
        [[allResults FailedTags] addObjectsFromArray:[result FailedTags]];
        if (!result.Success)
        {
          //responseStatus = 1; //error
          allResults.Success = false;
          //break; //let's not break - let's tell them about all of the broken items across all code files
        }
        
        [updatedTags addObjectsFromArray:[result UpdatedTags]];
        [refreshedFiles addObject:[tag CodeFile]];
      }
      
      //update our tag's cached result
      if([updatedTags containsObject:tag])
      {
        tag.CachedResult = [[updatedTags objectAtIndex:[updatedTags indexOfObject:tag]] CachedResult];
      }

      @try
      {
        NSArray<NSNumber*>* fields = [self InsertField:tag insertPlaceholder:insertPlaceholder];
        if (fields != nil) {
          [addedFields addObjectsFromArray:fields];
        }
      }
      @catch (NSException* exception)
      {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tagUpdateComplete" object:self userInfo:@{@"tagName":[tag Name], @"tagID":[tag Id], @"codeFileName":[[tag CodeFile] FileName], @"type" : @"tag", @"no_result" : [NSNumber numberWithBool:YES], @"exception":exception}];
        allResults.Success = false;
        [[allResults FailedTags] addObject:tag];
      }
    }
    
    // Now that all of the fields have been inserted, sweep through and update any existing
    // tags that changed.  We do this after the fields are inserted to better manage
    // the cursor position in the document.
    // FIXME: really test this... it's really not clear if this is working.
//    NSArray<STTag*> *theTags = [updatedTags valueForKey:@"Name"];
//    NSOrderedSet<STTag*> *orderedSet = [NSOrderedSet<STTag*> orderedSetWithArray:theTags];
//    NSSet<STTag*> *uniqueTags = [orderedSet set];
//    updatedTags = [[NSMutableArray<STTag*> alloc] initWithArray:[uniqueTags allObjects]];

    NSOrderedSet<STTag*> *orderedSet = [NSOrderedSet<STTag*> orderedSetWithArray:updatedTags];
    NSSet<STTag*> *uniqueTags = [orderedSet set];
    updatedTags = [[NSMutableArray<STTag*> alloc] initWithArray:[uniqueTags allObjects]];

    if (!insertPlaceholder) {
      for (STTag* updatedTag in updatedTags) {
        [self UpdateFields:[[STUpdatePair alloc] init:updatedTag newItem:updatedTag] ignoreIndexes:addedFields];
      }
    }
  }
  @catch (NSException* exception)
  {
//    responseStatus = 1; //error
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"allTagUpdatesComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseStatus]}];
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
    [[self Logger] WriteException:exception];
    @throw exception;
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [STUIUtility ReportException:exception userMessage:@"There was an unexpected error when trying to insert the tag output into the Word document." logger:[self Logger]];
//    });
  }
  @finally
  {
//    Globals.ThisAddIn.Application.ScreenUpdating = true;
//    Cursor.Current = Cursors.Default;
  }
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"allTagUpdatesComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseStatus]}];
  return allResults;

}


/**
 Conduct an assessment of the active document to see if there are any inserted tags that do not have an associated code file in the document.

 @param document: The Word document to analyze.
 @param onlyShowDialogIfResultsFound: If true, the results dialog will only display if there is something to report
 */
-(void)PerformDocumentCheck:(STMSWord2011Document*)document onlyShowDialogIfResultsFound:(BOOL)onlyShowDialogIfResultsFound
{
  NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedResults = [_TagManager FindAllUnlinkedTags];
  STDuplicateTagResults* duplicateResults = [_TagManager FindAllDuplicateTags];
  if (onlyShowDialogIfResultsFound
      && (unlinkedResults == nil || [unlinkedResults count] == 0)
      && (duplicateResults == nil || [duplicateResults count] == 0))
  {
    return;
  }
  
  [NSException raise:@"CheckDocument not implemented" format:@"CheckDocument not implemented"];
//  var dialog = new CheckDocument(unlinkedResults, duplicateResults, GetCodeFileList(document));
//  if (DialogResult.OK == dialog.ShowDialog())
//  {
//    UpdateUnlinkedTagsByTag(dialog.UnlinkedTagUpdates);
//    UpdateRenamedTags(dialog.DuplicateTagUpdates);
//  }
}

-(void)PerformDocumentCheck:(STMSWord2011Document*)document {
  [self PerformDocumentCheck:document onlyShowDialogIfResultsFound:false];
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


//MARK: Code File Manipulation


/**
	If code files become unlinked in the document, this method is used to resolve those tags/fields
	already in the document that refer to the unlinked code file.  It applies a set of actions to ALL of
	the tags in the document for a code file.
 
	@remark: See <see cref="UpdateUnlinkedTagsByTag">UpdateUnlinkedTagsByTag</see>
	if you want to perform actions on individual tags.
 */
-(void)UpdateUnlinkedTagsByCodeFile:(NSDictionary<NSString*, STCodeFileAction*>*)actions
{
//  [[self TagManager] ProcessStatTagFields:[[self TagManager] UpdateUnlinkedTagsByCodeFile] configuration:actions];
  [[self TagManager] ProcessStatTagFields:^void(STMSWord2011Field* field, STFieldTag* fieldTag, id configuration){
    [[self TagManager] UpdateUnlinkedTagsByCodeFile:field tag:fieldTag configuration:configuration];
  } configuration:actions];
  
  //now process the shapes
  [[self TagManager] ProcessStatTagShapes:^void(STMSWord2011Shape* shape, STTag* tag, id configuration){
    [[self TagManager] UpdateUnlinkedTagsByCodeFile:shape tag:tag configuration:configuration];
  } configuration:actions];

}

/**
	When reviewing all of the tags/fields in a document for those that have unlinked code files, duplicate
	names, etc., this method is used to resolve the errors in those tags/fields.  It applies individual actions
	to each tag in the document.
 
	@remarks: Some of the actions may in fact affect multiple tags.  For example, re-linking the code file
	to the document for a single tag has the effect of re-linking it for all related tags.
 
	@remark: See <see cref="UpdateUnlinkedTagsByCodeFile">UpdateUnlinkedTagsByCodeFile</see>
	if you want to process all tags in a code file with a single action.
 */
-(void)UpdateUnlinkedTagsByTag:(NSDictionary<NSString*, STCodeFileAction*>*)actions
{
  //[[self TagManager] ProcessStatTagFields:<#^(STMSWord2011Field *, STFieldTag *, id)aFunction#> configuration:<#(id)#>

  [[self TagManager] ProcessStatTagFields:^void(STMSWord2011Field* field, STFieldTag* fieldTag, id configuration){
    [[self TagManager] UpdateUnlinkedTagsByTag:field tag:fieldTag configuration:configuration];
  } configuration:actions];

  //now process the shapes
  [[self TagManager] ProcessStatTagShapes:^void(STMSWord2011Shape* shape, STTag* tag, id configuration){
    [[self TagManager] UpdateUnlinkedTagsByTag:shape tag:tag configuration:configuration];
  } configuration:actions];

  //[[self TagManager] ProcessStatTagFields:[[self TagManager] UpdateUnlinkedTagsByTag] configuration:actions];
  //TagManager.ProcessStatTagFields(TagManager.UpdateUnlinkedTagsByTag, actions);
}


/**
 Add a code file reference to our master list of files in the document.  This should be used when
 discovering code files to link to the document.
*/
-(void)AddCodeFile:(NSString*)fileName document:(STMSWord2011Document*)document {

  //NSMutableArray<STCodeFile*>* files = [[NSMutableArray<STCodeFile*> alloc] initWithArray:[self GetCodeFileList:document]];
  NSMutableArray<STCodeFile*>* files = [self GetCodeFileList:document];

  // we don't do this - since we're using an NSSet / de-duping we just handle this w/o user feedback
  // leaving this block here to remind us of that fact
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

  //EWW: deviations from C#
  //let's not double-add existing paths
  if(![[self GetCodeFileList] containsObject:file])
  {
    [files addObject:file];
    [self SaveCodeFileListToDocument:nil];//this isn't in the C#, but we can't get our code files to "stick" without it
  }
  
  //NSLog(@"Added code file %@", fileName);
  
}
-(void)AddCodeFile:(NSString*)fileName {
  [self AddCodeFile:fileName document:nil];
}


-(void)RemoveCodeFile:(NSString*)fileName document:(STMSWord2011Document*)document {
  
  NSMutableArray<STCodeFile*>* files = [self GetCodeFileList:document];
  NSMutableArray<STCodeFile*>* discardFiles = [[NSMutableArray<STCodeFile*> alloc] init];
  
  for(STCodeFile* cf in files)
  {
    if([[cf FilePath] isEqualToString: fileName])
    {
      //found the one we want to remove
      [discardFiles addObject:cf];
    }
  }
  
  [files removeObjectsInArray:discardFiles];
  [self SaveCodeFileListToDocument:nil];//store

}
-(void)RemoveCodeFile:(NSString*)fileName {
  [self RemoveCodeFile:fileName document:nil];
}

-(void)LoadAllTagsFromCodeFiles
{
  for(STCodeFile* file in [self GetCodeFileList]) {
    [file LoadTagsFromContent];
  }
}


-(void) UpdateRenamedTags:(NSArray<STUpdatePair<STTag*>*>*) updates
{
  NSMutableArray<STCodeFile*>* affectedCodeFiles = [[NSMutableArray<STCodeFile*> alloc] init];
  for (STUpdatePair* update in updates)
  {
    // We assume that updates never affect the code file - we don't give users a way to specify
    // in the UI to change a code file - so we just take the old code file reference to use.
    STCodeFile* codeFile = [[update Old] CodeFile];
    
    if(![affectedCodeFiles containsObject:[[update Old] CodeFile]])
    {
      [affectedCodeFiles addObject:[[update Old] CodeFile]];
    }
    [self UpdateFields:update matchOnPosition:true ignoreIndexes:nil];
    
    // Add the tag to the code file - replacing the old one.  Note that we require the
    // exact line match, so we don't accidentally replace the wrong duplicate named tag.
    [codeFile AddTag:[update New] oldTag:[update Old] matchWithPosition:true];
  }
  
  for (STCodeFile* codeFile in affectedCodeFiles)
  {
    [codeFile Save:nil];
  }
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
    //NSLog(@"No document specified, so fetching code file list for active document.");
    document = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
  }
  if(document == nil) {
    //NSLog(@"Attempted to access code files for a null document.  Returning empty collection.");
    return [[NSMutableArray<STCodeFile*> alloc] init];
  }
  
  NSString* fullName = [document fullName];
  if([DocumentCodeFiles objectForKey:fullName] == nil) {
    //NSLog(@"Code file list for %@ is not yet cached.", fullName);
    [DocumentCodeFiles setValue:[[NSMutableArray<STCodeFile*> alloc] init] forKey:fullName];
    [self LoadCodeFileListFromDocument:document];
    ////NSLog(@"Loaded %@ code files from document", DocumentCodeFiles[fullName].Count);
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
    //NSLog(@"No document specified, so getting a reference to the active document.");
    document = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
  }
  if(document == nil) {
    //NSLog(@"Attempted to set the code files for a null document.  Throwing exception.");
    [NSException raise:@"The Word document must be specified." format:@"The Word document must be specified."];
  }
  [DocumentCodeFiles setValue:[[NSMutableArray<STCodeFile*> alloc] initWithArray: files ] forKey:[document fullName]];
}



@end
