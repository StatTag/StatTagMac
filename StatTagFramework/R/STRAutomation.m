//
//  STRAutomation.m
//  StatTag
//
//  Created by Eric Whitley on 12/19/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "StatTagFramework.h"
#import "STRAutomation.h"
#import "STRParser.h"
#import "STCommandResult.h"
#import "STTag.h"
#import <RCocoa/RCocoa.h>
#import "STTable.h"
#import "STTableUtil.h"
#import "STRVerbatimDevice.h"
#import "STGeneralUtil.h"

@implementation STRAutomation

static NSString* const MATRIX_DIMENSION_NAMES_ATTRIBUTE = @"dimnames";
static NSString* const TemporaryImageFileFolder = @"STTemp-Figures";
static NSString* const TemporaryImageFileFilter = @"SELF EndsWith '.png'";

-(instancetype)init
{
  self = [super init];
  if(self) {
    Parser = [[STRParser alloc] init];
    VerbatimLog = [STRVerbatimDevice GetInstance];
  }
  return self;
}

-(BOOL)Initialize:(STCodeFile*)codeFile withLogManager:(STLogManager*)logManager
{
  if (Engine == nil) {
    Engine = [RCEngine GetInstance:VerbatimLog];
  }

  if (Engine != nil && codeFile != nil) {
    // If a code file is provided, we will attempt to set the working directory in
    // R to the same directory as the file.  This is done to avoid issues where,
    // because we're executing R from an app, it uses the working directory as the
    // app bundle directory (which users would not have rights to).
    // Since Initialize is called once per file execution, we want to make sure this
    // is called here so any subsequent code execution where the working directory
    // is changed is respected and we don't overwrite it.
    STTag* valueTag = [[STTag alloc] init];
    valueTag.Type = [STConstantsTagType Value];
    NSString* escapedPath = [codeFile.FilePath stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    [self RunCommand:[NSString stringWithFormat:@"setwd(dirname('%@'))", escapedPath] tag:valueTag];
  }
  
  if (Engine != nil) {
    // Initialize the temporary directory we'll use for figures
    NSString* path = [[codeFile FilePath] stringByDeletingLastPathComponent];
    if (![STGeneralUtil IsStringNullOrEmpty:path]) {
      TemporaryImageFilePath = [NSMutableString stringWithFormat:@"%@/%@", path, TemporaryImageFileFolder];
    }
    else {
      TemporaryImageFilePath = [NSMutableString stringWithFormat:@"./%@", TemporaryImageFileFolder];
    }
      
    // Make sure the temp image folder is established.
    [STGeneralUtil CreateDirectory:TemporaryImageFilePath];
      
    // Now, set up the R environment so it uses the PNG graphic device by default (if no other device
    // is specified).
    NSString* defaultGraphicsFunction = [NSString stringWithFormat:@".stattag_png = function() { png(filename=paste(\"%@/\", \"StatTagFigure%%03d.png\", sep=\"\")) }", TemporaryImageFilePath];
    NSArray<NSString*>* graphicOptions = [NSArray<NSString*> arrayWithObjects:defaultGraphicsFunction, @"options(device=\".stattag_png\")", nil];
    [self RunCommands:graphicOptions];
    return YES;
  }

  return NO;
}

-(void)dealloc
{
  if (Engine != nil) {
    // Part of our cleanup is ensuring all graphic devices are closed out.  Not everyone will do this
    // in their code, and if not it can cause our process to stay running.
    @try {
      [self RunCommand:@"graphics.off()"];
    }
    @catch(NSException* e) {
      // We are attempting to close graphic devices, but if it fails, it may not be catastrophic.
      // For now, we are supressing notification to the user, since it may be a false alarm.
    }
  }
  
  [self CleanTemporaryImageFolder:YES];
}

// Helper method to clean out the temporary folder used for storing images
-(void) CleanTemporaryImageFolder:(BOOL)deleteFolder
{
  if ([STGeneralUtil DirectoryExists:TemporaryImageFileFolder]) {
    // TODO: Can we make this less brute-force?  We want to ensure we're not trying to access
    // a file that's associated with an open graphics device.
    [self RunCommand:@"graphics.off()"];
    
    [STGeneralUtil CleanDirectory:TemporaryImageFileFolder filter:TemporaryImageFileFilter deleteDirectory:deleteFolder];
  }
}

+(BOOL)IsAppInstalled {
  //we're checking to see if the framework is installed, so let's see if we can create a class from the framework
  //FIXME: we're not using the right class name here - this would work (which is bad) if we have our R framework installed, but the main R framework is not available - so figure this out
  if (NSClassFromString(@"REngine")) {
    return YES;
  }
  return NO;
  //return [STCocoaUtil appIsPresentForBundleID:[[self class] determineInstalledAppBundleIdentifier]];
}


-(NSArray<STCommandResult*>*)RunCommands:(NSArray<NSString*>*)commands
{
  return [self RunCommands:commands tag:nil];
}

-(NSArray<STCommandResult*>*)RunCommands:(NSArray<NSString*>*)commands tag:(STTag*)tag
{
  // If there is no tag, and we're just running a big block of code, it's much easier if we can just
  // send that to the R engine at once.  Otherwise we have to worry about collapsing commands, function
  // definitions, etc.
  if (tag == nil) {
    NSString* singleCommand = [commands componentsJoinedByString:@"\r\n"];
    commands = @[ singleCommand ];
  }
  else {
    commands = [Parser CollapseMultiLineCommands:commands];
  }

  NSMutableArray<STCommandResult*>* commandResults = [[NSMutableArray<STCommandResult*> alloc] init];
  BOOL isVerbatimTag = (tag != nil && [[tag Type] isEqualToString:[STConstantsTagType Verbatim]]);
  BOOL isFigureTag = (tag != nil && [[tag Type] isEqualToString:[STConstantsTagType Figure]]);
  NSSortDescriptor* imageFileDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];
  for (NSString* command in commands) {
    if ([Parser IsTagStart:command]) {
      // Start the verbatim logging cache, if that's what the user wants for this output
      if (isVerbatimTag) {
        [VerbatimLog StartCache];
      }
      // If we're going to be doing a figure, we want to clean out the old images so we know
      // exactly which ones we're writing to.
      else if (isFigureTag) {
        [self CleanTemporaryImageFolder:NO];
      }
    }

    STCommandResult* result = [self RunCommand:command tag:tag];
    if (result != nil && ![result IsEmpty] && !isVerbatimTag) {
      [commandResults addObject:result];
    }
    else if ([Parser IsTagEnd:command]) {
      if (isVerbatimTag) {
        [VerbatimLog StopCache];
        STCommandResult* verbatimResult = [[STCommandResult alloc] init];
        verbatimResult.VerbatimResult = [[VerbatimLog GetCache] componentsJoinedByString:@""];
        [commandResults addObject:verbatimResult];
      }
      // If this is the end of a figure tag, only proceed with this temp file processing if we don't
      // already have a figure result of some sort.
      else if (isFigureTag) {
        NSUInteger index = [commandResults indexOfObjectPassingTest:
         ^(STCommandResult* obj, NSUInteger idx, BOOL *stop) {
           return (BOOL)!([STGeneralUtil IsStringNullOrEmpty:[obj FigureResult]]);
         }];
        if (index == NSNotFound) {
          // Make sure the graphics device is closed. We're going with the assumption that a device
          // was open and a figure was written out.
          [self RunCommand:@"graphics.off()"];
          
          // If we don't have the file specified normally, we will use our fallback mechanism of writing to a
          // temporary directory.
          NSArray<NSString*>* files = [STGeneralUtil GetFilesInFolder:TemporaryImageFilePath filter:TemporaryImageFileFilter];
          if ([files count] == 0) {
            continue;
          }
          files = [files sortedArrayUsingDescriptors:@[imageFileDescriptor]];
          NSURL* tempImageFileURL = [NSURL fileURLWithPath: [NSString stringWithFormat:@"%@/%@", TemporaryImageFilePath,[files objectAtIndex:0]] isDirectory:NO];
          NSString* imageFolder = [TemporaryImageFilePath stringByDeletingLastPathComponent];
          NSString* imageFile = [NSString stringWithFormat:@"%@/%@.png", imageFolder, [STTagUtil TagNameAsFileName:tag]];
          NSURL* imageFileURL = [NSURL fileURLWithPath:imageFile isDirectory:NO];
          [STGeneralUtil CopyFile:tempImageFileURL toDestinationFile:imageFileURL];
          
          STCommandResult* imageResult = [[STCommandResult alloc] init];
          imageResult.FigureResult = imageFile;
          [commandResults addObject:imageResult];
        }
      }
    }
  }
  
  return commandResults;
}

-(STCommandResult*)RunCommand:(NSString*)command
{
  return [self RunCommand:command tag:nil];
}

-(STCommandResult*)HandleTableResult:(STTag*)tag command:(NSString*)command result:(RCSymbolicExpression*)result
{
  // We take a hint from the tag type to identify tables.  Because of how open R is with its
  // return of results, a user can just specify a variable and get the result.
  if ([[tag Type] isEqualToString:[STConstantsTagType Table]]) {
    STCommandResult* commandResult = [[STCommandResult alloc] init];
    commandResult.TableResult = [self GetTableResult:command result:result];
    return commandResult;
  }
  return nil;
}

-(STCommandResult*)HandleImageResult:(STTag*)tag command:(NSString*)command result:(RCSymbolicExpression*)result
{
  if ([Parser IsImageExport:command]) {
    // Attempt to extract the save location (either a file name, relative path, or absolute path)
    // If it is empty, we will assign one to the image based on the tag name, and use that so
    // the image is properly imported.
    NSString* saveLocation = [Parser GetImageSaveLocation:command];
    if ([STGeneralUtil IsStringNullOrEmpty:saveLocation]) {
      saveLocation = @"\"tmp\"";
    }
    STCommandResult* commandResult = [[STCommandResult alloc] init];
    commandResult.FigureResult = [self GetExpandedFilePath:saveLocation];
    return commandResult;
  }
  return nil;
}

-(STCommandResult*)HandleValueResult:(STTag*)tag command:(NSString*)command result:(RCSymbolicExpression*)result
{
  // If we have a value command, we will pull out the last relevant line from the output.
  // Because we treat every type of output as a possible value result, we are only going
  // to capture the result if it's flagged as a tag.
  if ([[tag Type] isEqualToString:[STConstantsTagType Value]]) {
    NSArray* data = [result AsCharacter];
    if (data != nil) {
      STCommandResult* valueResult = [[STCommandResult alloc] init];
      valueResult.ValueResult = [self GetValueResult:result];
      return valueResult;
    }
  }
  return nil;
}

-(STCommandResult*)RunCommand:(NSString*)command tag:(STTag*)tag
{
    @autoreleasepool {
      NSDictionary *errorInfo;
      RCSymbolicExpression* result;
      @try {
        result = [Engine Evaluate:command];
      }
      @catch(NSException* exception) {
        errorInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"ErrorCode", [STConstantsStatisticalPackages R], @"StatisticalPackage", [exception reason], @"ErrorDescription", nil];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:[NSString stringWithFormat:@"There was an error while parsing the R command: %@", command]
                                     userInfo:errorInfo];
      }@finally {
      }

      if (result == nil) {
        return nil;
      }

      
      @try {
        // If there is no tag associated with the command that was run, we aren't going to bother
        // parsing and processing the results.  This is for blocks of codes in between tags
        if (tag != nil) {
          // Start with tables
          STCommandResult* commandResult = [self HandleTableResult:tag command:command result:result];
          if (commandResult != nil) {
            return commandResult;
          }

          // Image comes next, because everything else we will count as a value type.
          commandResult = [self HandleImageResult:tag command:command result:result];
          if (commandResult != nil) {
            return commandResult;
          }

          commandResult = [self HandleValueResult:tag command:command result:result];
          if (commandResult != nil) {
            return commandResult;
          }
        }
      }
      @catch(NSException* exception)
      {
        errorInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"ErrorCode", [STConstantsStatisticalPackages R], @"StatisticalPackage", [exception reason], @"ErrorDescription", nil];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:[NSString stringWithFormat:@"There was an error while running the R command: %@", command]
                                     userInfo:errorInfo];
      }@finally {
      }
        
        
    }
  return nil;
}

// Given a 2D data frame, flatten it into a 1D array that is organized as data by row.
-(NSArray<NSString*>*) FlattenDataFrame:(RCDataFrame*)dataFrame
{
    // Because we can only cast columns (not individual cells), we will go through all columns
    // first and cast them to characters so things like NA values are represented appropriately.
    // If we use the default format for these columns/cells, we end up with large negative int
    // values where NA exists.
    NSMutableArray<NSArray*>* castColumns = [[NSMutableArray<NSArray*> alloc] init];
    for (int column = 0; column < [dataFrame ColumnCount]; column++) {
        [castColumns addObject:[[dataFrame ElementAt:column] AsCharacter]];
    }

    NSMutableArray<NSString*>* data = [[NSMutableArray<NSString*> alloc] initWithCapacity:([dataFrame RowCount] * [dataFrame ColumnCount])];
    for (int row = 0; row < [dataFrame RowCount]; row++) {
        for (int column = 0; column < [dataFrame ColumnCount]; column++) {
            [data addObject:castColumns[column][row]];
        }
    }

    return data;
}

// General function to extract dimension (row/column) names for an R matrix.  This deals with
// the specific of how R packages matrix results, which is different from a data frame.
-(NSArray<NSString*>*) GetMatrixDimensionNames:(RCSymbolicExpression*) exp rowNames:(BOOL) rowNames
{
    NSArray<NSString*>* attributeNames = [exp GetAttributeNames];
    if (attributeNames == nil || [attributeNames count] == 0) {
        return nil;
    }

    BOOL hasDimensionNamesAttribute = false;
    unsigned long attributeCount = [attributeNames count];
    for (unsigned long index = 0; index < attributeCount; index++) {
        if ([attributeNames[index] isEqualToString:MATRIX_DIMENSION_NAMES_ATTRIBUTE]) {
            hasDimensionNamesAttribute = true;
            break;
        }
    }

    RCVector* dimnames = [[exp GetAttribute:MATRIX_DIMENSION_NAMES_ATTRIBUTE] AsList];
    if (dimnames == nil) {
        return nil;
    }

    // Per the R specification, the dimnames will contain 0 to 2 vectors that contain
    // dimension labels.  The first entry is for rows, and the second is for columns.
    // https://stat.ethz.ch/R-manual/R-devel/library/base/html/matrix.html
    switch ([dimnames Length]) {
        case 1: {
            // If we want columns and we only have one dimname entry, we don't have column names.
            if (!rowNames) {
                return nil;
            }
            return [[dimnames ElementAt:0] AsCharacter];
        }
        case 2: {
            return [[dimnames ElementAt:(rowNames ? 0 : 1)] AsCharacter];
        }
    }

    return nil;
}

// Return the row names (if they exist) for a matrix.
// Result is an array of strings containing the row names, or null if not present.
-(NSArray<NSString*>*) GetMatrixRowNames:(RCSymbolicExpression*) exp
{
    return [self GetMatrixDimensionNames:exp rowNames:true];
}

// Return the column names (if they exist) for a matrix.
// Result is an array of strings containing the column names, or null if not present.
-(NSArray<NSString*>*) GetMatrixColumnNames:(RCSymbolicExpression*) exp
{
    return [self GetMatrixDimensionNames:exp rowNames:false];
}

// Return an expanded, full file path - accounting for variables, functions, relative paths, etc.
-(NSString*) GetExpandedFilePath:(NSString*) saveLocation
{
  STTag* valueTag = [[STTag alloc] init];
  valueTag.Type = [STConstantsTagType Value];
  STCommandResult* fileLocation = [self RunCommand:saveLocation tag:valueTag];
  if ([Parser IsRelativePath:fileLocation.ValueResult]) {
    // Attempt to find the current working directory.  IF we are not able to find it, or the value we end up
    // creating doesn't exist, we will just proceed with whatever image location we had previously.
    STCommandResult* workingDirResult = [self RunCommand:@"getwd()" tag:valueTag];
    if (workingDirResult != nil) {
      NSString* path = workingDirResult.ValueResult;
      NSString* correctedPath = [[path stringByAppendingPathComponent:fileLocation.ValueResult] stringByResolvingSymlinksInPath];
      if ([[NSFileManager defaultManager] fileExistsAtPath:correctedPath]) {
        fileLocation.ValueResult = correctedPath;
      }
    }
  }

  return fileLocation.ValueResult;
}

-(STTable*) GetTableResult:(NSString*)command result:(RCSymbolicExpression*)result
{
  // Check to see if we can identify a file name that contains our table data.  If one exists,
  // we will start by returning that.  If there is no file name specified, we will proceed and
  // assume we are pulling data out of some R type.
  NSString* dataFile = [Parser GetTableDataPath:command];
  if (![STGeneralUtil IsStringNullOrEmpty:dataFile]) {
    return [STDataFileToTable GetTableResult:[self GetExpandedFilePath:dataFile]];
  }

    // You'll notice that regardless of the type, we convert everything to a string.  This
    // is just a simplification that StatTag makes about the results.  Often times we are
    // doing additional formatting and will do a conversion from the string type to the right
    // numeric type and format it appropriately.
    if ([result IsDataFrame]) {
        RCDataFrame* data = [result AsDataFrame];
        int rowCount = [data RowCount] + 1;
        int columnCount = [data ColumnCount] + 1;
        STTable* table = [[STTable alloc] init];
        table.ColumnSize = columnCount;
        table.RowSize = rowCount;
        table.Data = [STTableUtil MergeTableVectorsToArray:[data RowNames] columnNames:[data ColumnNames] data:[self FlattenDataFrame:data] totalRows:rowCount totalColumns:columnCount];
        return table;
    }
    else if ([result IsList]) {
        // A list can be a collection of anything, including other vectors.
        // We will do our best to expand these.  If they are deeply nested
        // though, it becomes difficult to put these in a table structure in
        // a Word document.  For now, we'll limit to 2D structures.
        RCVector* list = [result AsList];
        unsigned long maxSize = 0;
        NSMutableArray<NSMutableArray<NSString*>*>* data = [[NSMutableArray alloc] init];
        long listLength = [list Length];
        for (unsigned long index = 0; index < listLength; index++) {
            NSArray* characterData = [[list ElementAt:index] AsCharacter];
            if (characterData == nil) {
                [data addObject:[[NSMutableArray<NSString*> alloc]init]];
            }
            else {
                NSMutableArray<NSString*>* dataAsArray = [[NSMutableArray<NSString*> alloc]init];
                unsigned long characterDataCount = [characterData count];
                for (int innerIndex = 0; innerIndex < characterDataCount; innerIndex++) {
                    [dataAsArray addObject:characterData[innerIndex]];
                }
                [data addObject:dataAsArray];
                maxSize = MAX(maxSize, [dataAsArray count]);
            }
        }

        // Build data into a vector
        NSMutableArray<NSString*>* vectorData = [[NSMutableArray<NSString*> alloc] init];
        for (unsigned long rowIndex = 0; rowIndex < maxSize; rowIndex++) {
            unsigned long columnCount = [data count];
            for (unsigned long columnIndex = 0; columnIndex < columnCount; columnIndex++) {
                [vectorData addObject:(rowIndex < [data[columnIndex] count]) ? data[columnIndex][rowIndex] : @""];
            }
        }

        STTable* table = [[STTable alloc] init];
        table.ColumnSize = [data count];
        table.RowSize = maxSize;
        table.Data = [STTableUtil MergeTableVectorsToArray:nil columnNames:[list Names] data:vectorData totalRows:(maxSize + 1) totalColumns:[data count]];
        return table;
    }
    else if ([result IsMatrix]) {
        RCCharacterMatrix* matrix = [result AsCharacterMatrix];
        NSArray<NSString*>* rowNames = [self GetMatrixRowNames:result];
        NSArray<NSString*>* columnNames = [self GetMatrixColumnNames:result];
        // Just to note this isn't an error checking columnNames for rowCount and vice-versa.  Remember that
        // if we have column names, that will take up a row of data.  Likewise, row names are an additional
        // column.
        unsigned long rowCount = [matrix RowCount] + (columnNames == nil ? 0 : 1);
        unsigned long columnCount = [matrix ColumnCount] + (rowNames == nil ? 0 : 1);

        STTable* table = [[STTable alloc] init];
        table.ColumnSize = columnCount;
        table.RowSize = rowCount;
        table.Data = [STTableUtil MergeTableVectorsToArray:rowNames columnNames:columnNames data:[self FlattenMatrix:matrix] totalRows:rowCount totalColumns:columnCount];
        return table;
    }

    int type = [result Type];
    if (type == REALSXP || type == INTSXP || type == STRSXP || type == LGLSXP) {
        NSArray* data = [result AsCharacter];
        STTable* table = [[STTable alloc] init];
        table.ColumnSize = 1;
        table.RowSize = [data count];
        table.Data = [STTableUtil MergeTableVectorsToArray:nil columnNames:nil data:data totalRows:(table.RowSize + 1) totalColumns:1];
        return table;
    }

    return nil;
}

// Take the 2D data in a matrix and flatten it to a 1D representation (by row)
// which we use internally in StatTag.
-(NSArray<NSString*>*) FlattenMatrix:(RCCharacterMatrix*) matrix
{
    NSMutableArray* data = [[NSMutableArray alloc] initWithCapacity:([matrix RowCount] * [matrix ColumnCount])];
    for (int row = 0; row < [matrix RowCount]; row++) {
        for (int column = 0; column < [matrix ColumnCount]; column++) {
            [data addObject:[matrix ElementAt:row column:column]];
        }
    }

    return data;
}

-(BOOL)IsReturnable:(NSString*)command
{
  return [Parser IsValueDisplay:command] || [Parser IsImageExport:command] || [Parser IsTableResult:command];
}

-(NSString*)GetInitializationErrorMessage
{
  return @"Could not communicate with R.  R may not be fully installed, or might be missing some of the automation pieces that StatTag requires.";
}

-(NSString*)FirstOrDefault:(NSArray*)array
{
    if (array == nil || [array count] == 0) {
        return nil;
    }
    return array[0];
}

-(NSString*)GetValueResult:(RCSymbolicExpression*) result
{
    if ([result IsDataFrame]) {
        NSArray* characterArray = [[[result AsDataFrame] ElementAt:0] AsCharacter];
        return [self FirstOrDefault:characterArray];
    }
    else if ([result IsList]) {
        NSArray* characterArray = [[[result AsList] ElementAt:0] AsCharacter];
        return [self FirstOrDefault:characterArray];
    }

    switch ([result Type]) {
        case REALSXP:
        case INTSXP:
        case STRSXP:
        case LGLSXP: {
            NSArray* characterArray = [result AsCharacter];
            return [self FirstOrDefault:characterArray];
        }
    }

    return nil;
}

@end
