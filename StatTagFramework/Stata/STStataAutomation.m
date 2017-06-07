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


//NSString* StaticAppBundleIdentifier;// = @"com.stata.stata14";
@synthesize AppBundleIdentifier = _AppBundleIdentifier;

+(NSArray<NSString*>*) StataProcessNames {
  return [NSArray arrayWithObjects:
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

-(BOOL)Initialize {
  @try {
    OpenLogs = [[NSMutableArray<STStataParserLog*> alloc] init];
    _AppBundleIdentifier = [[self class] determineInstalledAppBundleIdentifier];
    if([[self class] IsAppInstalled]){
      @autoreleasepool {
        Application = [SBApplication applicationWithBundleIdentifier:_AppBundleIdentifier];
      }
    }
    [Application DoCommand:DisablePagingCommand stopOnError:true addToReview:true];
    [self Show];
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

//method removed in C# december 2016 update
//-(NSArray<STCommandResult*>*)CombineAndRunCommands:(NSArray<NSString*>*) commands
//{
//  NSString* combinedCommand = [commands componentsJoinedByString:@"\r\n"];
//  return [self RunCommands:[NSArray<NSString*> arrayWithObjects:combinedCommand, nil]];
//}

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
      
      STCommandResult* result = [self RunCommand:command];
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
          //          OpenLogs.Remove(verbatimLog);
          [OpenLogs removeObject:verbatimLog];
          
          //          File.Delete(verbatimLog.LogPath);
          NSError* error;
          [[NSFileManager defaultManager] removeItemAtPath:[[verbatimLog LogPath] stringByExpandingTildeInPath] error:&error];
        }
        else
        {
          //RunCommand(string.Format("log using \"{0}\"", logToRead.LogPath));
          [self RunCommand:[NSString stringWithFormat:@"log using \"%@\"", [logToRead LogPath]]];
        }
      }
      
      
    }
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
      
      
      //RunCommand(string.Format("{0} close", openLog.LogType.Replace(StatTagVerbatimLogIdentifier, "log")));
      [self RunCommand:[NSString stringWithFormat:@"%@ close", [[openLog LogType] stringByReplacingOccurrencesOfString:StatTagVerbatimLogIdentifier withString:@"log"] ]];
      //[self RunCommand:[NSString stringWithFormat:@"%@ close", openLog]];
    }
    // Since we have closed all logs, clear the list we were tracking.
    [OpenLogs removeAllObjects];
    
    IsTrackingVerbatim = false;
    
    @throw exception; //... eh.... this isn't a very Cocoa thing to do
  }
  @finally {
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
    //int startIndex = text.IndexOf(startingVerbatimCommand, StringComparison.CurrentCulture);
    NSInteger endIndex = [text rangeOfString:endingVerbatimCommand].location;
    //int endIndex = text.IndexOf(endingVerbatimCommand, startIndex, StringComparison.CurrentCulture);
    
    if (startIndex == NSNotFound || endIndex == NSNotFound)
    {
      return text;
    }
    
    NSInteger additionalOffset = 1;
    startIndex += [startingVerbatimCommand length] + additionalOffset;
    //if (text[startIndex] == '\r')
    if ([[text substringWithRange:NSMakeRange(startIndex, 1)] isEqualToString:@"\r"])
    {
      additionalOffset++;
      startIndex++;
    }
    //    var substring = text.Substring(startIndex, endIndex - startIndex - additionalOffset).TrimEnd('\r').Split(new char[] { '\r' });

    //            var substring = text.Substring(startIndex, endIndex - startIndex - additionalOffset).TrimEnd('\r').Split(new char[] { '\r' });
    
    NSString* substringS = [text substringWithRange:NSMakeRange(startIndex, endIndex - startIndex - additionalOffset)];
    startIndex = 0;
    endIndex = [substringS length];
    if([[substringS substringToIndex:endIndex - 1] isEqualToString:@"\r"])
    {
      substringS = [substringS substringToIndex:(endIndex - 1)];
    }
    NSArray<NSString*>* substring = [substringS componentsSeparatedByString:@"\r"];
    
    //    var finalLines = substring.Where(line => !line.StartsWith(". ")).ToList();
    NSPredicate* predLine = [NSPredicate predicateWithFormat:@"NOT SELF BEGINSWITH[c] %@", @". "];
    NSArray<NSString*>* finalLines = [substring filteredArrayUsingPredicate:predLine];
    
    //    return string.Join("\r\n", finalLines);
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
  NSString* result = [Application MacroValue:name];
  // If we get an empty string, try it with the prefix for local macros
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  if ([[result stringByTrimmingCharactersInSet:ws] length] == 0)
  {
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
  // calculcation, and then use the downstream macro result handler to pull out the result.
  // This will work even if the same local macro is defined multiple times in the same
  // execution.
  if([Parser IsCalculatedDisplayValue:command]) {
    name = [Parser GetValueName:command];
    command = [NSString stringWithFormat:@"local %@ = %@", StatTagTempMacroName, name];
    [self RunCommand:command];
    command = [NSString stringWithFormat:@"display `%@'", StatTagTempMacroName];
  }
  
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

/**
 Run a Stata command and provide the result of the command (if one should be returned).
 @param command: The command to run, taken from a Stata do file
 @returns The result of the command, or null if the command does not provide a result.
*/
-(STCommandResult*)RunCommand:(NSString*) command
{
  if(!IsTrackingVerbatim)
  {
    if([Parser IsValueDisplay:command]) {
      STCommandResult* result = [[STCommandResult alloc] init];
      result.ValueResult = [self GetDisplayResult:command];
      return result;
    }
    if([Parser IsTableResult:command]) {
      STCommandResult* result = [[STCommandResult alloc] init];
      result.TableResult = [self GetTableResult:command];
      return result;
    }
  }
  
  
  
  NSInteger returnCode = [Application DoCommandAsync:command];
  if(returnCode != 0) {
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:[NSString stringWithFormat:@"There was an error while executing the Stata command: %@", command]
                                 userInfo:nil];
  }
  
  [Application UtilIsStataFreeEvent];
  while([Application UtilIsStataFree] == NO) {
    [NSThread sleepForTimeInterval:0.1f];
  }
  
  NSInteger stataErrorCode = [Application UtilStataErrorCode];
  //NSLog(@"stataErrorCode : %ld", stataErrorCode);

  if([Parser IsImageExport:command] && !IsTrackingVerbatim) {
    
    NSString* imageLocation = [Parser GetImageSaveLocation:command];
    if([imageLocation containsString:[[STStataParser MacroDelimitersCharacters] firstObject]])
    {
      NSArray<NSString*>* macros = [Parser GetMacros:imageLocation];
      for(NSString* macro in macros)
      {
        NSString* result = [self GetMacroValue:macro];
        imageLocation = [self ReplaceMacroWithValue:imageLocation macro:macro value:result];
      }
      
    }
    
    STCommandResult* result = [[STCommandResult alloc] init];
    result.FigureResult = imageLocation;
    return result;
  }
  return nil;
}


/**
 Given a macro name that appears in a command string, replace it with its expanded value
*/
-(NSString*)ReplaceMacroWithValue:(NSString*)originalString macro:(NSString*)macro value:(NSString*)value
{
  NSString* n = [NSString stringWithFormat:@"%@%@%@", [[STStataParser MacroDelimitersCharacters] objectAtIndex:0], macro, [[STStataParser MacroDelimitersCharacters] objectAtIndex:1]];
  return [originalString stringByReplacingOccurrencesOfString:n withString:value];
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
  return @"Could not communicate with Stata. Please ensure that Stata is installed and is, at minium, version 13.";
}


@end
