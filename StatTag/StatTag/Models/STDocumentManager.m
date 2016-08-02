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
#import "STUIUtility.h"



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

/**
 Helper function to retrieve Cells from a Selection.  This guards against exceptions
 and just returns null when thrown (indicating no Cells found).
 */
-(SBElementArray<STMSWord2011Cell*>*)GetCells:(STMSWord2011SelectionObject*)selection {
  @try {
    return [selection cells];
  }
  @catch (NSException *exception) {
    NSLog(@"GetCells %@", exception.reason);
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

  int endColumn = MIN([columns count], [selectedCell columnIndex] + [[dimensions objectAtIndex:[STConstantsDimensionIndex Columns]] integerValue] - 1);
  int endRow = MIN([rows count], [selectedCell rowIndex] + [[dimensions objectAtIndex:[STConstantsDimensionIndex Rows]] integerValue] - 1);
  
  NSLog(@"Selecting in existing to row %d, column %d", endRow, endColumn);
  NSLog(@"Selected table has %d rows and %d columns", [rows count], [columns count]);
  NSLog(@"Table to insert has dimensions %d by %d", [dimensions[0] integerValue], [dimensions[1] integerValue]);

  STMSWord2011Cell* endCell = [table getCellFromTableRow:endRow column:endColumn];
  
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* document = [app activeDocument];
  
  [[document createRangeStart:[[selectedCell textObject] startOfContent] end:[[endCell textObject] endOfContent]] select];
  
  SBElementArray<STMSWord2011Cell*>* cells = [self GetCells:[app selection]];
  
  return cells;
}



/**
 Insert a table tag into the current selection.

 @remark This assumes that the tag is known to be a table result.
 */
-(void)InsertTable:(STMSWord2011SelectionObject*)selection tag:(STTag*)tag {

  NSLog(@"InsertTable - Started");
  
  if (tag == nil)
  {
    NSLog(@"Unable to insert the table because the tag is nil");
    return;
  }
  
  if (![tag HasTableData])
  {
    STMSWord2011TextRange* selectionRange = [selection textObject];
    [self CreateTagField:selectionRange tagIdentifier:[tag Id] displayValue:[STConstantsPlaceholders EmptyField] tag:tag];
    NSLog(@"Unable to insert the table because there are no cached results for the tag");
    return;
  }
  
  SBElementArray<STMSWord2011Cell*>* cells = [self GetCells:selection];
  [tag UpdateFormattedTableData];

  STTable* table = [[[tag CachedResult] firstObject] TableResult];
  NSArray<NSNumber*>* dimensions = [tag GetTableDisplayDimensions];
  
  int cellsCount = cells == nil ? 0 : [cells count];  // Because of the issue we mention below, pull the cell count right away
  
  // Insert a new table if there is none selected.
  if (cellsCount == 0)
  {
    NSLog(@"No cells selected, creating a new table");
 
    [self CreateWordTableForTableResult:selection table:table format:[tag TableFormat]];
    // The table will be the size we need.  Update these tracking variables with the cells and
    // total size so that we can begin inserting data.
    cells = [self GetCells:selection];
    cellsCount = [[table FormattedCells] count];
  }
  // Our heuristic is that a single cell selected with the selection being the same position most
  // likely means the user has their cursor in a table.  We are going to assume they want us to
  // fill in that table.
  else if (cellsCount == 1 && [[selection textObject] startOfContent] == [[selection textObject] endOfContent])
  {
    NSLog(@"Cursor is in a single table cell, selecting table");
    cells = [self SelectExistingTableRange:[cells firstObject] table:[[selection tables] firstObject] dimensions:dimensions];
    //cells = SelectExistingTableRange(cells.OfType<Cell>().First(), selection.Tables[1], dimensions);
    cellsCount = [cells count];
  }
  
  if (table.FormattedCells == nil || [[table FormattedCells] count] == 0)
  {
    [STUIUtility WarningMessageBox:@"There are no table results to insert." logger:_Logger];
    return;
  }
  
  if (cells == nil)
  {
    NSLog(@"Unable to insert the table because the cells collection came back as nil.");
    return;
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
    NSLog(@"cell (%d,%d)", [cell rowIndex], [cell columnIndex]);
  }
  
  STMSWord2011Cell* findCell = [cells firstObject];
  STMSWord2011Table* cellTable;
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];

  for(STMSWord2011Table* aTable in [doc tables]) {
    //- (STMSWord2011Cell *) getCellFromTableRow:(NSInteger)row column:(NSInteger)column;  // Returns a cell object that represents a cell in a table.
    STMSWord2011Cell* tableCell = [aTable getCellFromTableRow:[findCell rowIndex] column:[findCell columnIndex]];
    if([[findCell textObject] startOfContent] == [[tableCell textObject] startOfContent]
       && [[findCell textObject] endOfContent] == [[tableCell textObject] endOfContent]) {
      cellTable = aTable;
      break;
    }
  }
  
  NSLog(@"cell Points : %@", cellPoints);
//  NSLog(@"cell table : %@", [[cells firstObject] ]);
  //- (STMSWord2011Cell *) getCellFromTableRow:(NSInteger)row column:(NSInteger)column;  // Returns a cell object that represents a cell in a table.


  // Wait, why aren't I using a for (int index = 0...) loop instead of this foreach?
  // There is some weird issue with the Cells collection that was crashing when I used
  // a for loop and index.  After a few iterations it was chopping out a few of the
  // cells, which caused a crash.  No idea why, and moved to this approach in the interest
  // of time.  Long-term it'd be nice to figure out what was causing the crash.
  int index = 0;
  //for (STMSWord2011Cell* cell in cells)
  //for (int index = cellsCount - 1; index >= 0; index--)
  for (NSValue* value in cellPoints)
  {
    
    NSPoint cellPoint = [value pointValue];
    STMSWord2011Cell* cell = [cellTable getCellFromTableRow:cellPoint.x column:cellPoint.y];
    //STMSWord2011Cell* cell = [cells objectAtIndex:index];
    
//    if (index >= [[table FormattedCells] count])
//    {
//      NSLog(@"Index %d is beyond result cell length of %d", index, [[table FormattedCells] count]);
//      break;
//    }
    
    STMSWord2011TextRange* range = [cell textObject];
    
    // Make a copy of the tag and set the cell index.  This will let us discriminate which cell an tag
    // value is related with, since we have multiple fields (and therefore multiple copies of the tag) in the
    // document.  Note that we are wiping out the cached value to just have the individual cell value present.
    STCommandResult* commandResult = [[STCommandResult alloc] init];
    commandResult.ValueResult = [[table FormattedCells] objectAtIndex:index];
    NSMutableArray<STCommandResult*>* cachedResult = [[NSMutableArray<STCommandResult*> alloc] init];
    [cachedResult addObject:commandResult];
    STFieldTag* innerTag = [[STFieldTag alloc] initWithTag:tag andTableCellIndex:[NSNumber numberWithInteger:index]];
    innerTag.CachedResult = cachedResult;
    
    [self CreateTagField:range tagIdentifier:[NSString stringWithFormat:@"%@%@%d", [tag Name], [STConstantsReservedCharacters TagTableCellDelimiter], index] displayValue:[innerTag FormattedResult] tag:innerTag];
    index++;
    //Marshal.ReleaseComObject(range);
  }
  
  [self WarnOnMismatchedCellCount:cellsCount dataLength:[[table FormattedCells] count] ];
  
  //Marshal.ReleaseComObject(cells);
  
  // Once the table has been inserted, re-select it (inserting fields messes with the previous selection) and
  // insert a new line after it.  This gives us spacing after a table so inserting multiple tables doesn't have
  // them all glued together.
  [[[selection tables] firstObject] select];
  STMSWord2011SelectionObject* tableSelection = [[[[STGlobals sharedInstance] ThisAddIn] Application] selection];
  [self InsertNewLineAndMoveDown:tableSelection];
  //Marshal.ReleaseComObject(tableSelection);
  
  NSLog(@"InsertTable - Finished");
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
-(void)CreateWordTableForTableResult:(STMSWord2011SelectionObject*)selection table:(STTable*)table format:(STTableFormat*)format {
 
  NSLog(@"CreateWordTableForTableResult - Started");

  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];

  @try {
    int rowCount = (format.IncludeColumnNames) ? (table.RowSize + 1) : (table.RowSize);
    int columnCount = (format.IncludeRowNames) ? (table.ColumnSize + 1) : (table.ColumnSize);

    NSLog(@"Table dimensions r=%d, c=%d", rowCount, columnCount);

    
    STMSWord2011Table* wordTable = [WordHelpers createTableAtRange:[[app selection] textObject] withRows:rowCount andCols:columnCount];

    [wordTable select];
    STMSWord2011BorderOptions* borders = [wordTable borderOptions];
    borders.insideLineStyle = STMSWord2011E167LineStyleSingle;
    borders.outsideLineStyle = STMSWord2011E167LineStyleSingle;
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
  }
  
  NSLog(@"CreateWordTableForTableResult - Finished");

}


/**
 Provide a warning to the user if the number of data cells available doesn't match
 the number of table cells they selected in the document.
*/
-(void)WarnOnMismatchedCellCount:(int)selectedCellCount dataLength:(int)dataLength
{
  if (selectedCellCount > dataLength)
  {
    [STUIUtility WarningMessageBox:[NSString stringWithFormat:@"The number of cells you have selected (%d) is larger than the number of cells in your results (%d).\r\n\r\nOnly the first %d cells have been filled in with results.", selectedCellCount, dataLength, dataLength] logger:_Logger];
  }
  else if (selectedCellCount < dataLength)
  {
    [STUIUtility WarningMessageBox:[NSString stringWithFormat:@"The number of cells you have selected (%d) is smaller than the number of cells in your results (%d).\r\n\r\nOnly the first %d cells have been used.", selectedCellCount, dataLength, selectedCellCount] logger:_Logger];
  }
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
    if([tag IsTableTag] && [tag TableCellIndex] == nil) {
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
  
  STMSWord2011Field* dataField = [fields firstObject];
  //@property (copy) NSString *fieldText;  // Returns or sets data in an ADDIN field. The data is not visible in the field code or result. It is only accessible by returning the value of the data property. If the field isn't an ADDIN field, this property will cause an error.
  dataField.fieldText = [tag Serialize:nil];
  
  NSLog(@"CreateTagField - Finished");
}


/**
 Manage the process of editing an tag via a dialog, and processing any changes within the document.

@remark: This does not call the statistical software to update values.  It assumes that the tag contains the most up-to-date cached value and that it may be used for display if needed.
*/
-(BOOL)EditTag:(STTag*)tag
{
  NSLog(@"EditTag - Started");
  
  @try
  {
    
//    var dialog = new EditTag(false, this);
//    
//    IntPtr hwnd = Process.GetCurrentProcess().MainWindowHandle;
//    Log(string.Format("Established main window handle of {0}", hwnd.ToString()));
//    
//    dialog.Tag = new Tag(tag);
//    var wrapper = new WindowWrapper(hwnd);
//    NSLog(@"WindowWrapper established as: %@", wrapper.ToString()));
//    if (DialogResult.OK == dialog.ShowDialog(wrapper))
//    {
//      // If the value format has changed, refresh the values in the document with the
//      // new formatting of the results.
//      // TODO: Sometimes date/time format are null in one and blank strings in the other.  This is causing extra update cycles that aren't needed.
//      if (dialog.Tag.ValueFormat != tag.ValueFormat)
//      {
//        Log("Updating fields after tag value format changed");
//        if (dialog.Tag.TableFormat != tag.TableFormat)
//        {
//          Log("Updating formatted table data");
//          dialog.Tag.UpdateFormattedTableData();
//        }
//        UpdateFields(new UpdatePair<Tag>(tag, dialog.Tag));
//      }
//      else if (dialog.Tag.TableFormat != tag.TableFormat)
//      {
//        Log("Updating fields after tag table format changed");
//        dialog.Tag.UpdateFormattedTableData();
//        UpdateFields(new UpdatePair<Tag>(tag, dialog.Tag));
//      }
//      
//      SaveEditedTag(dialog, tag);
//      Log("EditTag - Finished (action)");
//      return true;
//    }
  }
  @catch (NSException* exc)
  {
    NSLog(@"An exception was caught while trying to edit an tag");
    [self LogException:exc];
  }
  
  NSLog(@"EditTag - Finished (no action)");
  return false;
}

/// <summary>
/// After an tag has been edited in a dialog, handle all reference updates and saving
/// that tag in its source file.
/// </summary>
/// <param name="dialog"></param>
/// <param name="existingTag"></param>
//public void SaveEditedTag(EditTag dialog, Tag existingTag = null)
//{
//  if (dialog.Tag != null && dialog.Tag.CodeFile != null)
//  {
//    // Update the code file with whatever was in the editor window.  While the code doesn't
//    // always change, we will go ahead with the update each time instead of checking.  Note
//    // that after this update is done, the indices for the tag objects passed in can
//    // no longer be trusted until we update them.
//    var codeFile = dialog.Tag.CodeFile;
//    codeFile.UpdateContent(dialog.CodeText);
//    
//    // Now that the code file has been updated, we need to add the tag.  This may
//    // be a new tag, or an updated one.
//    codeFile.AddTag(dialog.Tag, existingTag);
//    codeFile.Save();
//  }
//}


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
  if ([_TagManager IsStatTagField:field])
  {
    STFieldTag* fieldTag = [_TagManager GetFieldTag:field];
    STTag* tag = [_TagManager FindTag:fieldTag];
    [self EditTag:tag];
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
-(void)InsertTagsInDocument:(NSArray<STTag*>*)tags
{
//  Cursor.Current = Cursors.WaitCursor;
//  Globals.ThisAddIn.Application.ScreenUpdating = false;
  @try
  {
    NSMutableArray<STTag*>* updatedTags = [[NSMutableArray<STTag*> alloc] init];
    NSMutableArray<STCodeFile*>* refreshedFiles = [[NSMutableArray<STCodeFile*> alloc] init];
    for (STTag* tag in tags)
    {
      //if (!refreshedFiles.Contains(tag.CodeFile))
      if(![refreshedFiles containsObject:[tag CodeFile]])
      {
        STStatsManagerExecuteResult* result = [_StatsManager ExecuteStatPackage:[tag CodeFile] filterMode:[STConstantsParserFilterMode TagList] tagsToRun:tags];
        if (!result.Success)
        {
          break;
        }
        
        [updatedTags addObjectsFromArray:[result UpdatedTags]];
        [refreshedFiles addObject:[tag CodeFile]];
      }
      
      [self InsertField:tag];
    }
    
    // Now that all of the fields have been inserted, sweep through and update any existing
    // tags that changed.  We do this after the fields are inserted to better manage
    // the cursor position in the document.
    // FIXME: really test this... it's really not clear if this is working.
    NSArray<STTag*> *theTags = [updatedTags valueForKey:@"Name"];
    NSOrderedSet<STTag*> *orderedSet = [NSOrderedSet<STTag*> orderedSetWithArray:theTags];
    NSSet *uniqueTags = [orderedSet set];
    updatedTags = [[NSMutableArray<STTag*> alloc] initWithArray:[uniqueTags allObjects]];
    for (STTag* updatedTag in updatedTags)
    {
      [self UpdateFields:[[STUpdatePair alloc] init:updatedTag newItem:updatedTag]];
    }
  }
  @catch (NSException* exc)
  {
    [STUIUtility ReportException:exc userMessage:@"There was an unexpected error when trying to insert the tag output into the Word sdocument." logger:_Logger];
  }
  @finally
  {
//    Globals.ThisAddIn.Application.ScreenUpdating = true;
//    Cursor.Current = Cursors.Default;
  }
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
  [[self TagManager] ProcessStatTagFields:@"UpdateUnlinkedTagsByCodeFile" configuration:actions];
  //TagManager.ProcessStatTagFields(TagManager.UpdateUnlinkedTagsByCodeFile, actions);
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
  [[self TagManager] ProcessStatTagFields:@"UpdateUnLinkedTagsByTag" configuration:actions];
  //TagManager.ProcessStatTagFields(TagManager.UpdateUnlinkedTagsByTag, actions);
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
    [self UpdateFields:update matchOnPosition:true];
    
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
