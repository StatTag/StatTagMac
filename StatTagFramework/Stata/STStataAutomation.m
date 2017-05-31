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


NSString *const LocalMacroPrefix = @"_";
NSString *const StatTagTempMacroName = @"__st_tmp_display_value";
NSString *const DisablePagingCommand = @"set more off";
NSString *const RegisterParameter = @"/Register";
NSString *const UnregisterParameter = @"/Unregister";
//NSString* StaticAppBundleIdentifier;// = @"com.stata.stata14";
@synthesize AppBundleIdentifier = _AppBundleIdentifier;

+(NSArray<NSString*>*) StataProcessNames {
  return [NSArray arrayWithObjects:
          @"com.stata.stata14",
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
    OpenLogs = [[NSMutableArray<NSString*> alloc] init];
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
    OpenLogs = [[NSMutableArray<NSString*> alloc] init];
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

-(NSArray<STCommandResult*>*)RunCommands:(NSArray<NSString*>*)commands tag:(STTag*)tag {
  @try {
    NSMutableArray<STCommandResult*>* commandResults = [[NSMutableArray<STCommandResult*> alloc] init];
    for(NSString* command in commands) {
      if([Parser IsStartingLog:command]) {
        [OpenLogs addObjectsFromArray:[Parser GetLogType:command]];
      }
      STCommandResult* result = [self RunCommand:command];
      if(result != nil && ![result IsEmpty]) {
        [commandResults addObject:result];
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
    for(NSString* openLog in OpenLogs) {
      [self RunCommand:[NSString stringWithFormat:@"%@ close", openLog]];
    }
    // Since we have closed all logs, clear the list we were tracking.
    [OpenLogs removeAllObjects];
    @throw exception; //... eh.... this isn't a very Cocoa thing to do
  }
  @finally {
  }
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

  if([Parser IsImageExport:command]) {
    
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
