//
//  STStataAutomation.m
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STStataAutomation.h"
#import "StatTagFramework.h"
#import "STCocoaUtil.h"
#import "STTableUtil.h"
#import "STTableData.h"
#import "STTable.h"

@implementation STStataAutomation


NSString* const LocalMacroPrefix = @"_";
NSString* const StatTagTempMacroName = @"__st_tmp_display_value";
NSString* const DisablePagingCommand = @"set more off";
NSString* const RegisterParameter = @"/Register";
NSString* const UnregisterParameter = @"/Unregister";

NSString* const StatTagVerbatimLogName = @"__stattag_verbatim_log_tmp.log";
NSString* const StatTagVerbatimLogIdentifier = @"stattag-verbatim";

NSString* const EndLoggingCommand = @"log close";

NSString* const CapturePrefix = @"capture {\r\nnoisily {\r\n";
NSString* const CaptureSuffix = @"\r\n}\r\n}";

NSString* const DisplayWorkingDirectoryCommand = @"display \"`c(pwd)'\"";

//NSString* StaticAppBundleIdentifier;// = @"com.stata.stata14";
@synthesize AppBundleIdentifier = _AppBundleIdentifier;

+(NSArray<NSString*>*) StataProcessNames {
  return [NSArray arrayWithObjects:
          @"com.stata.stata20",
          @"com.stata.stata19",
          @"com.stata.stata18",
          @"com.stata.stata17",
          @"com.stata.stata16",
          @"com.stata.stata15",
          @"com.stata.stata14",
          @"com.stata.stata13",
          nil];
}

+(NSString*)determineInstalledAppBundleIdentifier {
  for(NSString* bundleID in [[self class]StataProcessNames]) {
    if ([STCocoaUtil appIsPresentForBundleID:bundleID]) {
      return bundleID;
    }
  }
  return nil;
}

typedef NS_ENUM(NSInteger, ScalarType) {
  NotFound = 0,
  Numeric = 1,
  String = 2
};

const NSInteger StataHidden = 1;
const NSInteger MinimizeStata = 2;
const NSInteger ShowStata = 3;

//static STStataAutomation* sharedInstance = nil;
//+ (instancetype)sharedInstance
//{
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    sharedInstance = [[self alloc] init];
//    //sharedInstance.AppBundleIdentifier = [[self class] determineInstalledAppBundleIdentifier] ;
//  });
//  return sharedInstance;
//}

-(instancetype)init {
  self = [super init];
  if(self) {
    //id Application;
    Parser = [[STStataParser alloc] init];
    OpenLogs = [[NSMutableArray<STStataParserLog*> alloc] init];
    IsTrackingVerbatim = false;
    _AppBundleIdentifier = [[self class] determineInstalledAppBundleIdentifier];
    if([[self class] IsAppInstalled]){
      @autoreleasepool {
        Application = [SBApplication applicationWithBundleIdentifier:_AppBundleIdentifier];
      }
    }
  }
  return self;
}

+(BOOL)IsAppInstalled {
  return [STCocoaUtil appIsPresentForBundleID:[[self class] determineInstalledAppBundleIdentifier]];
}
  
+(BOOL)IsAppRunning {
  BOOL running = false;
  @autoreleasepool {
    STStataApplication *s = [SBApplication applicationWithBundleIdentifier:[[self class] determineInstalledAppBundleIdentifier]];
    if([s isRunning]) {
      running = true;
    }
  }
  return running;
}

+(NSURL*)AppPath {
  return [STCocoaUtil appURLForBundleId:[[self class] determineInstalledAppBundleIdentifier]];
}


-(NSArray<NSRunningApplication*>*)getRunningApps {
  if(_AppBundleIdentifier != nil) {
    return [NSRunningApplication runningApplicationsWithBundleIdentifier:_AppBundleIdentifier];
  }
  return nil;
}
-(void)Show{
  NSArray *apps = [self getRunningApps];
  if ([apps count] > 0) {
    [(NSRunningApplication *)[apps objectAtIndex:0] activateWithOptions: (NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps)];
  }
}

-(void)Hide{
  NSArray *apps = [self getRunningApps];
  if ([apps count] > 0) {
    [(NSRunningApplication *)[apps objectAtIndex:0] hide];
  }
}

-(BOOL)Initialize:(STCodeFile*)codeFile withLogManager:(STLogManager*)logManager
{
  @try {
    OpenLogs = [[NSMutableArray<STStataParserLog*> alloc] init];
    _AppBundleIdentifier = [[self class] determineInstalledAppBundleIdentifier];

    if (_AppBundleIdentifier == nil) {
      return FALSE;
    }

    if([[self class] IsAppInstalled]){
      @autoreleasepool {
        Application = [SBApplication applicationWithBundleIdentifier:_AppBundleIdentifier];
      }
    }
    [Application DoCommand:DisablePagingCommand stopOnError:true addToReview:true];
    [self Show];

    // Initialize the application to use the file path's folder as the working directory.
    // We do this at the beginning so that if the user overwrites it during the script,
    // we will respect that change.
    if (codeFile != nil) {
      NSString* path = [codeFile.FilePath stringByDeletingLastPathComponent];
      [self RunCommand:[NSString stringWithFormat:@"cd \"%@\"", path]];
    }
  }
  @catch (NSException* exception) {
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
    //NSLog(@"Exception Initialize %@: %@", NSStringFromClass([self class]), [exception description]);
    return false;
  }
  @finally {
  }
  return true;

}



/**
 Determine if a command is one that would return a result of some sort.
 @param command : The command to evaluate
*/
-(BOOL)IsReturnable:(NSString*)command
{
  return [Parser IsValueDisplay:command] || [Parser IsImageExport:command] || [Parser IsTableResult:command];
}

-(void)EnsureLoggingForVerbatim:(STTag*)tag
{
  // If there is no open log, we will start one
  
  //FIXME: this will probably fail - figure out how to test this
  //  if (OpenLogs.Find(x => x.LogType.Equals("log", StringComparison.CurrentCultureIgnoreCase)) == null)
  NSPredicate* predLog = [NSPredicate predicateWithFormat:@"LogType == [c] %@", @"log"];
  STStataParserLog* stLog = [[OpenLogs filteredArrayUsingPredicate: predLog] firstObject];

  //![[OpenLogs valueForKey:@"LogType.lowercaseString"] containsObject:[@"log" lowercaseString]]
  if (stLog == nil)
  {
    NSString* verbatimLogFile = [StatTagVerbatimLogName copy];

    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    //if ([[result stringByTrimmingCharactersInSet:ws] length] == 0)
    if ([tag CodeFile] != nil && [[[[tag CodeFile] FilePath] stringByTrimmingCharactersInSet:ws] length] > 0)
    {
      //verbatimLogFile = Path.Combine(Path.GetDirectoryName(tag.CodeFile.FilePath), StatTagVerbatimLogName);
      verbatimLogFile = [[[[[tag CodeFile] FilePathURL] path] stringByDeletingLastPathComponent] stringByAppendingPathComponent:StatTagVerbatimLogName];
    }
    [self RunCommand:[NSString stringWithFormat:@"log using \"%@\", text replace", verbatimLogFile]];

    // We use a special identifier so we know it is a StatTag initiated log during processing, and that
    // it can be closed.  Otherwise we may confuse it with a log the user started.
    STStataParserLog* spl = [[STStataParserLog alloc] init];
    [spl setLogType:StatTagVerbatimLogIdentifier];
    [spl setLogPath:verbatimLogFile];
    [OpenLogs addObject:spl];
  }
}


-(NSArray<STCommandResult*>*)RunCommands:(NSArray<NSString*>*)commands tag:(STTag*)tag {
  @try {
    NSMutableArray<STCommandResult*>* commandResults = [[NSMutableArray<STCommandResult*> alloc] init];
    IsTrackingVerbatim = (tag != nil && [[tag Type] isEqualToString: [STConstantsTagType Verbatim]]);
    NSString* startingVerbatimCommand = @"";   // Tracks in the log where we begin pulling verbatim output from
    for(NSString* command in commands) {
      if([Parser IsStartingLog:command]) {
        [OpenLogs addObjectsFromArray:[Parser GetLogs:command]];
      }
      
      // Ensure logging is taking place if the user has identified this as verbatim output.
      if ([Parser IsTagStart:command] && IsTrackingVerbatim)
      {
        startingVerbatimCommand = command;
        [self EnsureLoggingForVerbatim:tag];
      }
      
      STCommandResult* result = [self RunCommand:command tag:tag];
      if(result != nil && ![result IsEmpty] && !IsTrackingVerbatim) {
        [commandResults addObject:result];
      }
      else if ([Parser IsTagEnd:command] && IsTrackingVerbatim)
      {
        // Log management can get tricky.  If the user has established their own log file as part of their do file, we have
        // to manage closing and reopening the log when we need to access content.  Otherwise Stata will keep the log file
        // locked and we can't access it.
        STStataParserLog* logToRead = nil;

        //var verbatimLog = OpenLogs.Find(x => x.LogType.Equals(StatTagVerbatimLogIdentifier,
        //                                                      StringComparison.CurrentCultureIgnoreCase));
        NSPredicate* predVerbatimLog = [NSPredicate predicateWithFormat:@"LogType == [c] %@",StatTagVerbatimLogIdentifier];
        STStataParserLog* verbatimLog = [[OpenLogs filteredArrayUsingPredicate: predVerbatimLog] firstObject];

        //var regularLog = OpenLogs.Find(x => x.LogType.Equals("log",
        //                                                     StringComparison.CurrentCultureIgnoreCase));
        NSPredicate* predLog = [NSPredicate predicateWithFormat:@"LogType == [c] %@", @"log"];
        STStataParserLog* regularLog = [[OpenLogs filteredArrayUsingPredicate:predLog] firstObject];

        if (verbatimLog != nil)
        {
          [self RunCommand: EndLoggingCommand];
          logToRead = verbatimLog;
        }
        else if (regularLog != nil)
        {
          logToRead = regularLog;
          [self RunCommand: EndLoggingCommand];
        }
        
        // If we don't have a log for some reason, just continue on (with no verbatim output).
        if (logToRead == nil)
        {
          continue;
        }
        
        // Pull the text and parse out the relevant lines that we want
        //        var verbatimOutput = CreateVerbatimOutputFromLog(logToRead, startingVerbatimCommand, command);
        NSString* verbatimOutput = [self CreateVerbatimOutputFromLog:logToRead startingVerbatimCommand:startingVerbatimCommand endingVerbatimCommand:command];
        
        //        commandResults.Add(new CommandResult() { VerbatimResult = verbatimOutput });
        STCommandResult* r = [[STCommandResult alloc] init];
        [r setVerbatimResult:verbatimOutput];
        [commandResults addObject:r];
        
        // Now that we have the output, we have to perform some cleanup for the log.  If we have a verbatim
        // log that we created, we will clean it up.  Otherwise we need to re-enable the logging for the
        // user-defined log.
        if (verbatimLog != nil)
        {
          [OpenLogs removeObject:verbatimLog];
          NSError* error;
          [[NSFileManager defaultManager] removeItemAtPath:[[verbatimLog LogPath] stringByExpandingTildeInPath] error:&error];
        }
        else
        {
          [self RunCommand:[NSString stringWithFormat:@"log using \"%@\"", [logToRead LogPath]]];
        }
      }
    }

    [self ResolveCommandPromises:commandResults];
    return commandResults;
  }
  @catch (NSException* exception) {
    // If we catch an exception, the script is going to stop operating.  So we will check to see
    // if any log files are open, and close them for the user.  Otherwise the log will remain
    // open.
    //NSLog(@"%@", exception.reason);
    //NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    //NSLog(@"%@", [NSThread callStackSymbols]);
    
    //NSLog(@"Exception Initialize %@: %@", NSStringFromClass([self class]), [exception description]);
    for(STStataParserLog* openLog in OpenLogs) {
      
      // We have a special log type identifier we use for tracking verbatim output.  The Replace call
      // for each log command is a cheat to make sure that type is converted to log (instead of if/elses).
      [self RunCommand:[NSString stringWithFormat:@"%@ close", [[openLog LogType] stringByReplacingOccurrencesOfString:StatTagVerbatimLogIdentifier withString:@"log"] ]];
    }
    // Since we have closed all logs, clear the list we were tracking.
    [OpenLogs removeAllObjects];
    
    IsTrackingVerbatim = false;
    
    @throw exception; //... eh.... this isn't a very Cocoa thing to do
  }
  @finally {
  }
}

// Iterate through a list of command results and resolve any outstanding promises on the results.
-(void)ResolveCommandPromises:(NSMutableArray<STCommandResult*>*)commandResults
{
    for (int index = 0; index < [commandResults count]; index++) {
        STCommandResult* result = [commandResults objectAtIndex:index];
        if (![STGeneralUtil IsStringNullOrEmpty:[result TableResultPromise]]) {
            // Yes, we are expanding the file paths twice.  The problem is that depending on how the file is written (putexcel
            // being the first example we ran into), it may not actually be on disk when teh first GetExpandedFilePath is called.
            // Because that method requires a file to exist before it will accept it, we need to do the expansion again since
            // otherwise we could have just a relative path.
            result.TableResult = [STDataFileToTable GetTableResult:[self GetExpandedFilePath:[result TableResultPromise]]];
            result.TableResultPromise = nil;
        }
    }
}


/// <summary>
/// Given an internal reference that StatTag maintains to a log file, pull out the relevant log lines (excluding
/// the commands that would be written there too).  This returns a string with newlines represented as \r\n.s
/// </summary>
/// <param name="logToRead"></param>
/// <param name="startingVerbatimCommand"></param>
/// <param name="endingVerbatimCommand"></param>
/// <returns></returns>
-(NSString*)CreateVerbatimOutputFromLog:(STStataParserLog*)logToRead startingVerbatimCommand:(NSString*)startingVerbatimCommand endingVerbatimCommand:(NSString*)endingVerbatimCommand
{
  //STFileHandler
  NSError* error;
  if([STFileHandler Exists:[NSURL fileURLWithPath:[logToRead LogPath]] error:&error])
  {
    STFileHandler* fh = [[STFileHandler alloc] init];
    NSString* text = [[fh ReadAllLines:[NSURL fileURLWithPath:[logToRead LogPath]] error:&error] componentsJoinedByString:@"\r"];
    //var text = File.ReadAllText(logToRead.LogPath).Replace("\r\n", "\r");
    NSInteger startIndex = [text rangeOfString:startingVerbatimCommand].location;
    NSInteger endIndex = [text rangeOfString:endingVerbatimCommand].location;

    if (startIndex == NSNotFound || endIndex == NSNotFound)
    {
      return text;
    }

    startIndex += [startingVerbatimCommand length] + 1;
    //    var substring = text.Substring(startIndex, endIndex - startIndex - additionalOffset).TrimEnd('\r').Split(new char[] { '\r' });

    //            var substring = text.Substring(startIndex, endIndex - startIndex - additionalOffset).TrimEnd('\r').Split(new char[] { '\r' });
    
    NSString* substringS = [text substringWithRange:NSMakeRange(startIndex, endIndex - startIndex)];
    substringS = [substringS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray<NSString*>* substring = [substringS componentsSeparatedByString:@"\r"];

    // Lines prefixed with ". " or "> " are from Stata to echo our commands and can be removed.  Note that we somtimes
    // end up with a line that is just a period - this is a ". " line that got trimmed and can be removed (but
    // we only do that if it is the last line, not globally).
    // Stata will put the first line of the command with a ". " prefix, and if it runs over will then use "> " continuation.
    // So that we don't pull out valid lines starting with "> ", we will sequentially iterate over the list of log lines and
    // track the state so that we only pull out "> " lines if they are preceded by a ". " or "> " line.
    NSMutableArray<NSString*>* interimLines = [[NSMutableArray<NSString*> alloc] init];
    BOOL previousLineCommand = FALSE;
    for (int index = 0; index < [substring count]; index++) {
      NSString* line = [substring objectAtIndex:index];
      if (line == NULL) {
        continue;
      }
      
      if ([line hasPrefix:@". "]) {
        previousLineCommand = TRUE;
      }
      else if (previousLineCommand && [line hasPrefix:@"> "]) {
        previousLineCommand = TRUE;
      }
      else {
        previousLineCommand = FALSE;
        [interimLines addObject:line];
      }
    }
    if ([interimLines count] > 0 && [[interimLines lastObject] isEqualToString:@"."]) {
      [interimLines removeLastObject];
    }

    // Go through the lines until we find the first non-blank line.  That's what we will use as the first actual line
    // in the verbatim results.
    int firstIndex = 0;
    for (int index = 0; index < [interimLines count]; index++) {
      if ([interimLines[index] length] > 0) {
        firstIndex = index;
        break;
      }
    }

    // Now go through and remove all lines at the end that are blanks.
    for (int index = [interimLines count] - 1; index >= 0; index--) {
      if ([interimLines[index] length] > 0) {
        break;
      }
      [interimLines removeLastObject];
    }

    NSRange range;
    range.location = firstIndex;
    range.length = ([interimLines count] - firstIndex);
    NSArray<NSString*>* finalLines = [interimLines subarrayWithRange:range];
    return [finalLines componentsJoinedByString:@"\r\n"];
    
  }
  
  return nil;
  
}




/**
 Run a collection of commands and provide all applicable results.
*/
-(NSArray<STCommandResult*>*)RunCommands:(NSArray<NSString*>*)commands {
  return [self RunCommands:commands tag:nil];
}


-(NSString*)GetMacroValue:(NSString*)name
{
  //Per Stata support (2017-AUG-15), "You should use StReturnString, not MacroValue for the returned results. MacroValue is for local macros, StReturn* is for e(), r(), s(), and c()."
  NSString* result = [Application StReturnString:name];

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  if ([[result stringByTrimmingCharactersInSet:ws] length] == 0)
  {
    result = [Application MacroValue:name];
  }
  if ([[result stringByTrimmingCharactersInSet:ws] length] == 0)
  {
    // If we get an empty string, try it with the prefix for local macros
    result = [Application MacroValue:[NSString stringWithFormat:@"%@%@",LocalMacroPrefix, name]];
  }
  return result;
}

/**
  Determine the string result for a command that returns a single value.  This includes
  macros and scalars.
 */
-(NSString*)GetDisplayResult:(NSString*) command
{
  NSString* name;
  
  // Display values with calculations in them require special handling.  The API does not
  // process them directly, so our workaround is to introduce a local macro to process the
  // calculation, and then use the downstream macro result handler to pull out the result.
  // This will work even if the same local macro is defined multiple times in the same
  // execution.  We eventually decided to do this for ALL display values.  While it is
  // admittedly some execution overhead, it saves time (and potential errors) trying to
  // parse every command so see if it's a calculation or system variable (e.g., _pi, _N, _b[val]).
  name = [Parser GetValueName:command];
  command = [NSString stringWithFormat:@"local %@ = %@", StatTagTempMacroName, name];
  [self RunCommand:command];
  command = [NSString stringWithFormat:@"display `%@'", StatTagTempMacroName];
  
  if([Parser IsMacroDisplayValue:command]) {
    name = [Parser GetMacroValueName:command];
    return [self GetMacroValue:name];
  }
  
  name = [Parser GetValueName:command];
  
  //FIXME: really go through this... seems cumbersome and error prone
  NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
  NSNumber* numValue = [nf numberFromString:name];
  ScalarType scalarType = NotFound;
  if(numValue) {
    scalarType = [numValue integerValue];
  }

  switch (scalarType) {
    case String:
      return [Application ScalarString:name];
    case Numeric:
      return [NSString stringWithFormat:@"%f", [Application ScalarNumeric:name]];
    default:
      // If it's not a scalar type, it's assumed to be a saved type that can be returned
      return [Application StReturnString:name];
  }
}

/**
 Combines the different components of a matrix command into a single structure.
 */
-(STTable*)GetTableResult:(NSString*) command
{
  NSString* matrixName = [Parser GetTableName:command];
  
  
  NSArray<NSString*>* rowNames = [Application MatrixRowNames:matrixName];
  NSArray<NSString*>* columnNames = [Application MatrixColNames:matrixName];
  NSInteger rowCount = [Application MatrixRowDim:matrixName] + ((rowNames != nil && [rowNames count] > 0) ? 1 : 0);
  NSInteger columnCount = [Application MatrixColDim:matrixName] + ((columnNames != nil && [columnNames count] > 0) ? 1 : 0);

  NSArray<NSString*>* data = [self ProcessForMissingValues:[Application MatrixData:matrixName]];
  STTableData* arrayData = [STTableUtil MergeTableVectorsToArray:rowNames columnNames:columnNames data:data totalRows:rowCount totalColumns:columnCount];
  STTable* table = [[STTable alloc] init:rowCount columnSize:columnCount data:arrayData];

  return table;
}


/**
  Identify missing values from the Stata API and explicitly set them to a null result.

  @remark Stata represents missing values as very large integers.  If we don't account for
  those results, we will display large integers as a result.  To clean up the results, we
  will detect missing values and set them to null.
*/
-(NSArray<NSString*>*)ProcessForMissingValues:(NSArray<NSNumber*>*)data {
  //FIXME: we can't do nilable fixed type arrays with NSNumber or NSString... so go back and review this.
  NSMutableArray<NSString*>* cleanedData = [[NSMutableArray<NSString*> alloc] initWithCapacity:[data count]];
  double missingValue = [Application UtilGetStMissingValue];
  for(NSInteger index = 0; index < [data count]; index++) {
    [cleanedData addObject:([data[index]doubleValue] >= missingValue) ? (NSString*)[NSNull null] : [NSString stringWithFormat:@"%@", data[index]]];
  }
  return cleanedData;
}

// Return an expanded, full file path - accounting for variables, functions, relative paths, etc.
-(NSString*)GetExpandedFilePath:(NSString*)saveLocation
{
    // If the save location is not a macro, and it appears to be a relative path, translate it into a fully
    // qualified path based on Stata's current environment.
    if([Parser HasMacroInCommand:saveLocation]) {
        NSArray<NSString*>* macros = [Parser GetMacros:saveLocation];
        for (NSString* macro in macros) {
            NSString* result = [self GetMacroValue:macro];
            saveLocation = [Parser ReplaceMacroWithValue:saveLocation macro:macro value:result];
        }
    }
    else if ([Parser IsRelativePath:saveLocation]) {
        // Attempt to find the current working directory.  If we are not able to find it, or the value we end up
        // creating doesn't exist, we will ust proceed with whatever image location we had previously.
        NSArray<NSString*>* displayCommand = @[DisplayWorkingDirectoryCommand];
        STTag* valueTag = [[STTag alloc] init];
        valueTag.Type = [STConstantsTagType Value];
        NSArray<STCommandResult*>* results = [self RunCommands:displayCommand tag:valueTag];
        if (results != nil && [results count] > 0) {
            NSString* path = [[results firstObject] ValueResult];
            NSString* correctedPath = [[path stringByAppendingPathComponent:saveLocation] stringByResolvingSymlinksInPath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:correctedPath]) {
                saveLocation = correctedPath;
            }
        }
    }

    return saveLocation;
}

-(STCommandResult*)RunCommand:(NSString*)command
{
  return [self RunCommand:command tag:nil];
}

/**
 Run a Stata command and provide the result of the command (if one should be returned).
 @param command: The command to run, taken from a Stata do file
 @returns The result of the command, or null if the command does not provide a result.
*/
-(STCommandResult*)RunCommand:(NSString*) command tag:(STTag*)tag
{
  // If we are tracking verbatim, we don't do any special tag processing.  Likewise, if we don't have
  // a tag, we don't want to do any special handling or processing of results.  This way any non-
  // tagged code is going to go ahead and be executed.
  if (!IsTrackingVerbatim && tag != nil) {
    if([Parser IsValueDisplay:command]) {
      STCommandResult* result = [[STCommandResult alloc] init];
      result.ValueResult = [self GetDisplayResult:command];
      return result;
    }

    // Because we are being more open what we allow for tables, we are now going
    // to only allow table results when we have a tag that is a table type.  Note that
    // we will short-circuit executing the command ONLY when we have a matrix type
    // of result.  If we think we have a data file, we need to execute the command.  That
    // is why we make two checks within this method for table results, the first one here for
    // matrix results, and the second one for any table result.
    if([[tag Type] isEqualToString: [STConstantsTagType Table]] && [Parser IsMatrix:command]) {
      STCommandResult* result = [[STCommandResult alloc] init];
      result.TableResult = [self GetTableResult:command];
      return result;
    }
  }

  // Additional special handling for table1.  In order to force the output of table1 to be an XLSX file,
  // we need to trap its creation.  Here we detect if it looks like a non-XLSX file extension (with two
  // common types - this is not an exhaustive list) and change the command appropriately.
  if (!IsTrackingVerbatim && tag != nil && [[tag Type] isEqualToString: [STConstantsTagType Table]]
    && [Parser IsTableResult:command] && [Parser IsTable1Command:command]) {
    NSString* result = [Parser GetTableDataPath:command];
    // We want to force XLS -> XLSX for the table1 command, and will convert CSV (which isn't valid, but people can still do it) to XLSX.
    // Since the command has already run, we do have an extra step to rename the file to the extension we want.  Keeping in mind that the
    // table1 can only create Excel files, so we are allowed to make assumptions about formats.
    if ([[result pathExtension] isEqualToString:@"xls"]) {
      command = [command stringByReplacingOccurrencesOfString:result withString:[result stringByAppendingString:@"x"]];
    }
    else if ([[result pathExtension] isEqualToString:@"csv"]) {
      NSString* newFile = [[result substringToIndex:[result length] - 4] stringByAppendingString:@".xlsx"];
      command = [command stringByReplacingOccurrencesOfString:result withString:newFile];
    }
  }

  BOOL isCapturable = [Parser IsCapturableBlock:command];
  command = isCapturable ? [NSString stringWithFormat:@"%@%@%@", CapturePrefix, command, CaptureSuffix] : command;
  NSDictionary *errorInfo;
  
  NSInteger returnCode = [Application DoCommandAsync:command];
  if(returnCode != 0) {
    errorInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:returnCode], @"ErrorCode", [STConstantsStatisticalPackages Stata], @"StatisticalPackage", [self getStataErrorDescription:returnCode], @"ErrorDescription", nil];
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:[NSString stringWithFormat:@"There was an error while executing the Stata command: %@", command]
                                 userInfo:errorInfo];
  }
  
  //[Application UtilIsStataFreeEvent]; //per Stata, this does nothing
  while([Application UtilIsStataFree] == NO) {
    [NSThread sleepForTimeInterval:0.1f];
  }
  
  NSInteger stataErrorCode = [Application UtilStataErrorCode];
  if(stataErrorCode != 0) {
    errorInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:stataErrorCode], @"ErrorCode", [STConstantsStatisticalPackages Stata], @"StatisticalPackage", [self getStataErrorDescription:stataErrorCode], @"ErrorDescription", nil];
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:[NSString stringWithFormat:@"There was an error while executing the Stata command: %@ (error code %ld)", command, stataErrorCode]
                                 userInfo:errorInfo];
  }
  #pragma unused(stataErrorCode)

  //NSLog(@"stataErrorCode : %ld", stataErrorCode);

  //FIXME: removing our capture commands before we process the image information - for now - until we can review the regex
  if (isCapturable) {
    command = [command substringFromIndex:[CapturePrefix length]];
    command = [command substringToIndex:[command length] - [CaptureSuffix length]];
  }

  if (!IsTrackingVerbatim && tag != nil) {
    if ([Parser IsImageExport:command]) {
      /*NSString* imageLocation = [Parser GetImageSaveLocation:command];
      if([imageLocation containsString:[[STStataParser MacroDelimitersCharacters] firstObject]]) {
        NSArray<NSString*>* macros = [Parser GetMacros:imageLocation];
        for(NSString* macro in macros) {
          NSString* result = [self GetMacroValue:macro];
          imageLocation = [self ReplaceMacroWithValue:imageLocation macro:macro value:result];
        }
      }*/
      
      STCommandResult* result = [[STCommandResult alloc] init];
      //result.FigureResult = imageLocation;
      result.FigureResult = [self GetExpandedFilePath:[Parser GetImageSaveLocation:command]];
      return result;
    }

    if ([[tag Type] isEqualToString: [STConstantsTagType Table]] && [Parser IsTableResult:command]) {
      STCommandResult* result = [[STCommandResult alloc] init];
      result.TableResultPromise = [self GetExpandedFilePath:[Parser GetTableDataPath:command]];
      return result;
    }
  }
  return nil;
}

-(void)dealloc
{
  [self Hide];
  Application = nil;
}

+(BOOL)UnregisterAutomationAPI:(NSString*) path
{
  //return RunProcess(path, UnregisterParameter);
  return true;
}

+(BOOL)RegisterAutomationAPI:(NSString*) path
{
//  return RunProcess(path, RegisterParameter);
  return true;
}


//FIXME: deal with "run process" ...

/// <summary>
/// Execute a process as an administrator.  Used for managing the automation API.
/// </summary>
/// <param name="path">Path of the process to run</param>
/// <param name="parameters">Parameters used by the process.s</param>
/// <returns>true if successful, false otherwise</returns>
//protected static bool RunProcess(string path, string parameters)
//{
//  var startInfo = new ProcessStartInfo(path, parameters)
//  {
//    WindowStyle = ProcessWindowStyle.Hidden,
//    Verb = "runas"
//  };
//  // Allows running as administrator, needed to change COM registration
//  var process = Process.Start(startInfo);
//  if (process == null)
//  {
//    return false;
//  }
//  
//  process.WaitForExit(30000);
//  
//  return (0 == process.ExitCode);
//}


-(NSString*)GetInitializationErrorMessage
{
  return @"Could not communicate with Stata. Please ensure that Stata is installed and is, at minimum, version 13.";
}


-(NSString*)getStataErrorDescription:(NSInteger)errorCode
{
  NSString* errorDescription;
  
  switch(errorCode)
  {
    case 1: errorDescription = @"You pressed Break. This is not considered an error."; break;
    case 2: errorDescription = @"connection timed out -- see help r(2) for troubleshooting"; break;
    case 3: errorDescription = @"no dataset in use"; break;
    case 4: errorDescription = @"no; data in memory would be lost"; break;
    case 5: errorDescription = @"not sorted"; break;
    case 6: errorDescription = @"Return code from confirm existence when string does not exist."; break;
    case 7: errorDescription = @"‘___’ found where ___ expected"; break;
    case 8: errorDescription = @"error — Display generic error message and exit"; break;
    case 9: errorDescription = @"assertion is false"; break;
    case 10: errorDescription = @"error — Display generic error message and exit"; break;
    case 12: errorDescription = @"error — Display generic error message and exit"; break;
    case 18: errorDescription = @"you must start with an empty dataset"; break;
    case 100: errorDescription = @"varlist required = exp required using required"; break;
    case 101: errorDescription = @"varlist not allowed weights not allowed in range not allowed if not allowed"; break;
    case 102: errorDescription = @"too few variables specified"; break;
    case 103: errorDescription = @"too many variables specified"; break;
    case 104: errorDescription = @"nothing to input"; break;
    case 106: errorDescription = @"variable   is   in master but   in using data"; break;
    case 107: errorDescription = @"not possible with numeric variable"; break;
    case 108: errorDescription = @"not possible with string variable"; break;
    case 109: errorDescription = @"type mismatch"; break;
    case 110: errorDescription = @"already defined"; break;
    case 111: errorDescription = @"not found no variables defined"; break;
    case 119: errorDescription = @"statement out of context"; break;
    case 120: errorDescription = @"invalid %format"; break;
    case 121: errorDescription = @"invalid numlist"; break;
    case 122: errorDescription = @"invalid numlist has"; break;
    case 123: errorDescription = @"invalid numlist has"; break;
    case 124: errorDescription = @"invalid numlist has"; break;
    case 125: errorDescription = @"invalid numlist has"; break;
    case 126: errorDescription = @"invalid numlist has"; break;
    case 127: errorDescription = @"invalid numlist has"; break;
    case 130: errorDescription = @"expression too long too many SUMs"; break;
    case 131: errorDescription = @"not possible with test"; break;
    case 132: errorDescription = @"too many ’(’ or ’[’ or too many ’)’ or ’]’"; break;
    case 133: errorDescription = @"unknown function   ()"; break;
    case 135: errorDescription = @"not possible with weighted data"; break;
    case 140: errorDescription = @"repeated categorical variable in term"; break;
    case 141: errorDescription = @"repeated term"; break;
    case 145: errorDescription = @"term contains more than 8 variables"; break;
    case 146: errorDescription = @"too many variables or values (matsize too small)"; break;
    case 147: errorDescription = @"term not in model"; break;
    case 148: errorDescription = @"too few categories"; break;
    case 149: errorDescription = @"too many categories"; break;
    case 151: errorDescription = @"non r-class program may not set r()"; break;
    case 152: errorDescription = @"non e-class program may not set e()"; break;
    case 153: errorDescription = @"non s-class program may not set s()"; break;
    case 161: errorDescription = @"ado-file has commands outside of program define ...end"; break;
    case 162: errorDescription = @"ado-file does not define command"; break;
    case 170: errorDescription = @"unable to chdir"; break;
    case 175: errorDescription = @"factor level out of range"; break;
    case 180: errorDescription = @"invalid attempt to modify label"; break;
    case 181: errorDescription = @"may not label strings"; break;
    case 182: errorDescription = @"not labeled"; break;
    case 184: errorDescription = @"options   and   may not be combined"; break;
    case 190: errorDescription = @"request may not be combined with by"; break;
    case 191: errorDescription = @"request may not be combined with by() option"; break;
    case 196: errorDescription = @"could not restore sort order because variables were dropped"; break;
    case 197: errorDescription = @"invalid syntax"; break;
    case 198: errorDescription = @"invalid syntax"; break;
    case 199: errorDescription = @"unrecognized command"; break;
    case 301: errorDescription = @"last estimates not found"; break;
    case 302: errorDescription = @"last test not found"; break;
    case 303: errorDescription = @"equation not found"; break;
    case 304: errorDescription = @"ml model not found"; break;
    case 305: errorDescription = @"ml model not found Same as 304."; break;
    case 310: errorDescription = @"not possible because object(s) in use"; break;
    case 321: errorDescription = @"requested action not valid after most recent estimation command"; break;
    case 322: errorDescription = @"something that should be true of your estimation results is not"; break;
    case 399: errorDescription = @"may not drop constant"; break;
    case 401: errorDescription = @"may not use noninteger frequency weights"; break;
    case 402: errorDescription = @"negative weights encountered"; break;
    case 404: errorDescription = @"not possible with pweighted data"; break;
    case 406: errorDescription = @"not possible with analytic weights"; break;
    case 407: errorDescription = @"weights must be the same for all observations in a group"; break;
    case 409: errorDescription = @"no variance"; break;
    case 411: errorDescription = @"nonpositive values encountered has negative values"; break;
    case 412: errorDescription = @"redundant or inconsistent constraints"; break;
    case 416: errorDescription = @"missing values encountered"; break;
    case 420: errorDescription = @"groups found, 2 required"; break;
    case 421: errorDescription = @"could not determine between-subject error term; use bse() option"; break;
    case 422: errorDescription = @"could not determine between-subject basic unit; use bseunit() option"; break;
    case 430: errorDescription = @"convergence not achieved"; break;
    case 450: errorDescription = @"is not a 0/1 variable number of successes invalid"; break;
    case 451: errorDescription = @"invalid values for time variable"; break;
    case 452: errorDescription = @"invalid values for factor variable"; break;
    case 459: errorDescription = @"something that should be true of your data is not"; break;
    case 460: errorDescription = @"fpc must be >= 0"; break;
    case 461: errorDescription = @"fpc for all observations within a stratum must be the same There is a problem with your fpc variable; see [SVY] svyset."; break;
    case 462: errorDescription = @"fpc must be <= 1 if a rate, or >= no. sampled PSUs per stratum if PSU totals There is a problem with your fpc variable; see [SVY] svyset."; break;
    case 463: errorDescription = @"sum of weights equals zero"; break;
    case 464: errorDescription = @"poststratum weights must be constant within poststrata"; break;
    case 465: errorDescription = @"poststratum weights must be >= 0"; break;
    case 466: errorDescription = @"standardization weights must be constant within standard strata"; break;
    case 467: errorDescription = @"standardization weights must be >= 0"; break;
    case 471: errorDescription = @"esample() invalid"; break;
    case 480: errorDescription = @"starting values invalid or some RHS variables have missing values"; break;
    case 481: errorDescription = @"equation/system not identified"; break;
    case 482: errorDescription = @"nonpositive value(s) among   , cannot log transform"; break;
    case 491: errorDescription = @"could not find feasible values"; break;
    case 498: errorDescription = @"various messages"; break;
    case 499: errorDescription = @"various messages"; break;
    case 501: errorDescription = @"matrix operation not found"; break;
    case 503: errorDescription = @"conformability error"; break;
    case 504: errorDescription = @"matrix has missing values"; break;
    case 505: errorDescription = @"matrix not symmetric"; break;
    case 506: errorDescription = @"matrix not positive definite"; break;
    case 507: errorDescription = @"name conflict"; break;
    case 508: errorDescription = @"matrix has zero values"; break;
    case 509: errorDescription = @"matrix operators that return matrices not allowed in this context"; break;
    case 601: errorDescription = @"file   not found"; break;
    case 602: errorDescription = @"file   already exists"; break;
    case 603: errorDescription = @"file   could not be opened"; break;
    case 604: errorDescription = @"log file already open"; break;
    case 606: errorDescription = @"no log file open"; break;
    case 607: errorDescription = @"no cmdlog file open"; break;
    case 608: errorDescription = @"file is read-only; cannot be modified or erased"; break;
    case 609: errorDescription = @"file xp format"; break;
    case 610: errorDescription = @"file   not Stata format"; break;
    case 611: errorDescription = @"record too long"; break;
    case 612: errorDescription = @"unexpected end of file"; break;
    case 613: errorDescription = @"file does not contain dictionary"; break;
    case 614: errorDescription = @"dictionary invalid"; break;
    case 616: errorDescription = @"wrong number of values in checksum file"; break;
    case 621: errorDescription = @"already preserved"; break;
    case 622: errorDescription = @"nothing to restore"; break;
    case 631: errorDescription = @"host not found"; break;
    case 632: errorDescription = @"web filename not supported in this context"; break;
    case 633: errorDescription = @"may not write files over Internet"; break;
    case 639: errorDescription = @"file transmission error (checksums do not match)"; break;
    case 640: errorDescription = @"package file too long"; break;
    case 641: errorDescription = @"package file invalid"; break;
    case 651: errorDescription = @"may not seek past end of file"; break;
    case 660: errorDescription = @"proxy host not found"; break;
    case 662: errorDescription = @"proxy server refused request to send"; break;
    case 663: errorDescription = @"remote connection to proxy failed"; break;
    case 665: errorDescription = @"could not set socket nonblocking"; break;
    case 667: errorDescription = @"wrong version winsock.dll"; break;
    case 668: errorDescription = @"could not find a valid winsock.dll"; break;
    case 669: errorDescription = @"invalid URL"; break;
    case 670: errorDescription = @"invalid network port number"; break;
    case 671: errorDescription = @"unknown network protocol"; break;
    case 672: errorDescription = @"server refused to send file"; break;
    case 673: errorDescription = @"authorization required by server"; break;
    case 674: errorDescription = @"unexpected response from server"; break;
    case 675: errorDescription = @"server reported server error"; break;
    case 676: errorDescription = @"server refused request to send"; break;
    case 677: errorDescription = @"remote connection failed"; break;
    case 678: errorDescription = @"could not open local network socket"; break;
    case 681: errorDescription = @"too many open files"; break;
    case 682: errorDescription = @"could not connect to odbc dsn"; break;
    case 683: errorDescription = @"could not fetch variable in odbc table"; break;
    case 688: errorDescription = @"file is corrupt"; break;
    case 691: errorDescription = @"I/O error"; break;
    case 692: errorDescription = @"file I/O error on read"; break;
    case 693: errorDescription = @"file I/O error on write"; break;
    case 694: errorDescription = @"could not rename file"; break;
    case 695: errorDescription = @"could not copy file"; break;
    case 696: errorDescription = @"is temporarily unavailable"; break;
    case 699: errorDescription = @"insufficient disk space"; break;
    case 702: errorDescription = @"op. sys. refused to start new process"; break;
    case 703: errorDescription = @"op. sys. refused to open pipe"; break;
    case 791: errorDescription = @"system administrator will not allow you to change this setting"; break;
    case 900: errorDescription = @"no room to add more variables"; break;
    case 901: errorDescription = @"no room to add more observations"; break;
    case 902: errorDescription = @"no room to add more variables because of width"; break;
    case 903: errorDescription = @"no room to promote variable (e.g., change int to float) because of width"; break;
    case 907: errorDescription = @"maxvar too small"; break;
    case 908: errorDescription = @"matsize too small"; break;
    case 909: errorDescription = @"op. sys. refuses to provide memory"; break;
    case 910: errorDescription = @"value too small"; break;
    case 912: errorDescription = @"value too large"; break;
    case 913: errorDescription = @"op. sys. refuses to provide sufficient memory"; break;
    case 914: errorDescription = @"op. sys. refused to allow Stata to open a temporary file"; break;
    case 920: errorDescription = @"too many macros"; break;
    case 950: errorDescription = @"insufficient memory"; break;
    case 1000: errorDescription = @"system limit exceeded - see manual See [R] limits."; break;
    case 1001: errorDescription = @"too many values"; break;
    case 1002: errorDescription = @"too many by variables"; break;
    case 1003: errorDescription = @"too many options"; break;
    case 1004: errorDescription = @"command too long"; break;
    case 1400: errorDescription = @"numerical overflow"; break;
    case 2000: errorDescription = @"no observations"; break;
    case 2001: errorDescription = @"insufficient observations"; break;
    case 3698: errorDescription = @"file seek error"; break;
    case 3000: errorDescription = @"(message varies)"; break;
    case 3001: errorDescription = @"incorrect number of arguments"; break;
    case 3002: errorDescription = @"identical arguments not allowed"; break;
    case 3010: errorDescription = @"attempt to dereference NULL pointer"; break;
    case 3011: errorDescription = @"invalid lval"; break;
    case 3012: errorDescription = @"undefined operation on pointer"; break;
    case 3020: errorDescription = @"class child/parent compiled at different times"; break;
    case 3021: errorDescription = @"class compiled at different times"; break;
    case 3022: errorDescription = @"function not supported on this platform"; break;
    case 3101: errorDescription = @"matrix found where function required"; break;
    case 3102: errorDescription = @"function found where matrix required"; break;
    case 3103: errorDescription = @"view found where array required"; break;
    case 3104: errorDescription = @"array found where view required"; break;
    case 3200: errorDescription = @"conformability error"; break;
    case 3201: errorDescription = @"vector required"; break;
    case 3202: errorDescription = @"rowvector required"; break;
    case 3203: errorDescription = @"colvector required"; break;
    case 3204: errorDescription = @"matrix found where scalar required"; break;
    case 3205: errorDescription = @"square matrix required"; break;
    case 3206: errorDescription = @"invalid use of view containing op.vars"; break;
    case 3250: errorDescription = @"type mismatch"; break;
    case 3251: errorDescription = @"nonnumeric found where numeric required"; break;
    case 3252: errorDescription = @"noncomplex found where complex required"; break;
    case 3253: errorDescription = @"nonreal found where real required"; break;
    case 3254: errorDescription = @"nonstring found where string required"; break;
    case 3255: errorDescription = @"real or string required"; break;
    case 3256: errorDescription = @"numeric or string required"; break;
    case 3257: errorDescription = @"nonpointer found where pointer required"; break;
    case 3258: errorDescription = @"nonvoid found where void required"; break;
    case 3259: errorDescription = @"nonstruct found where struct required"; break;
    case 3260: errorDescription = @"nonclass found where class required"; break;
    case 3261: errorDescription = @"non class/struct found where class/struct required"; break;
    case 3300: errorDescription = @"argument out of range"; break;
    case 3301: errorDescription = @"subscript invalid"; break;
    case 3302: errorDescription = @"invalid %fmt"; break;
    case 3303: errorDescription = @"invalid permutation vector"; break;
    case 3304: errorDescription = @"struct nested too deeply"; break;
    case 3305: errorDescription = @"class nested too deeply"; break;
    case 3351: errorDescription = @"argument has missing values"; break;
    case 3352: errorDescription = @"singular matrix"; break;
    case 3353: errorDescription = @"matrix not positive definite"; break;
    case 3360: errorDescription = @"failure to converge"; break;
    case 3492: errorDescription = @"resulting string too long"; break;
    case 3498: errorDescription = @"(message varies)"; break;
    case 3499: errorDescription = @"not found"; break;
    case 3500: errorDescription = @"invalid Stata variable name"; break;
    case 3598: errorDescription = @"Stata returned error"; break;
    case 3601: errorDescription = @"invalid file handle"; break;
    case 3602: errorDescription = @"invalid filename"; break;
    case 3603: errorDescription = @"invalid file mode"; break;
    case 3611: errorDescription = @"too many open files"; break;
    case 3612: errorDescription = @"file too large for 32-bit Stata"; break;
    case 3621: errorDescription = @"attempt to write read-only file"; break;
    case 3622: errorDescription = @"attempt to read write-only file"; break;
    case 3623: errorDescription = @"attempt to seek append-only file"; break;
    case 3900: errorDescription = @"out of memory"; break;
    case 3901: errorDescription = @"macro memory in use"; break;
    case 3930: errorDescription = @"error in LAPACK routine"; break;
    case 3995: errorDescription = @"unallocated function"; break;
    case 3996: errorDescription = @"built-in unallocated"; break;
    case 3997: errorDescription = @"unimplemented opcode"; break;
    case 3998: errorDescription = @"stack overflow"; break;
    case 3999: errorDescription = @"system assertion false"; break;
    
    default:
      errorDescription = @"Unknown error";
      break;
  }
  
  if(errorCode >= 4000 && errorCode <= 4999)
  {
    errorDescription = @"Unknown class error";
  }
  
  return errorDescription;
}

@end
