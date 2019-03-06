//
//  STLogManager.m
//  StatTag
//
//  Created by Eric Whitley on 7/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STLogManager.h"
#import "STUserSettings.h"
#import "STCocoaUtil.h"
#import "STFileHandler.h"

#import "STSettingsManager.h"


//@import CocoaLumberjack;


@implementation STLogManager

@synthesize Enabled = _Enabled;
@synthesize FileHandler = _FileHandler;

@synthesize LogFilePath = _LogFilePath;

@synthesize logLevel = _logLevel;
@synthesize wroteHeader = _wroteHeader;

//@synthesize settings = _settings;
//@synthesize settingsManager = _settingsManager;


//singleton
static STLogManager *sharedInstance = nil;


- (void) setLogFilePath:(NSURL*)p {
  _LogFilePath = p;//[p stringByExpandingTildeInPath];
}
- (NSURL*)LogFilePath {
  return _LogFilePath;
}
-(void)setLogFilePathWithString:(NSString*)p
{
  @try {
    NSURL* url = [NSURL fileURLWithPath:p];
    [self setLogFilePath:url];
  }
  @catch (NSException * e) {
    //NSLog(@"Exception creating URL (%@): %@", NSStringFromClass([self class]), p);
  }
  @finally {
  }
}

-(instancetype)init {
  self = [super init];
  if(self) {
    //_LogFilePath = @"";
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss.SSS";
    _FileHandler = [[STFileHandler alloc] init];
    _logLevel = STLogError;
    _wroteHeader = FALSE;
    
    _settingsManager = [[STSettingsManager alloc] init];
    
  }
  return self;
}

-(instancetype)initWithFileHandler:(NSObject<STIFileHandler>*)handler
{
  self = [super init];
  if(self) {
    //_LogFilePath = @"";
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss.SSS";
    _FileHandler = handler != nil ? handler : [[STFileHandler alloc] init];
  }
  return self;
}

//Singleton
+ (STLogManager*)sharedInstance {
  if (sharedInstance == nil) {
    sharedInstance = [[super allocWithZone:NULL] init];
  }
  return sharedInstance;
}
+ (id)allocWithZone:(NSZone*)zone {
  return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone {
  return self;
}

/**
 Determine if a given path is accessible and can be opened with write access.
 
 @param logFilePath : The file path to check
 
 @returns : True if the path is valid, false otherwise.
 */

-(BOOL)IsValidLogPath:(NSString*)logFilePath {
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if (logFilePath == nil || [[logFilePath stringByTrimmingCharactersInSet: ws] length] == 0) {
    return false;
  }

  //if we have tilde paths, expand the full path
  logFilePath = [logFilePath stringByExpandingTildeInPath];

  //this entire approach is very "C#" and not very "Apple"
  //we really should completely change this to use the Apple style exception/error handling
  @try
  {
    // Check write access
    NSURL* logPath = [NSURL fileURLWithPath:logFilePath];
    NSFileHandle* __unused stream = [[self FileHandler] OpenWrite: logPath];
    if(stream == nil) {
      return false;
    }
  }
  @catch (NSException* exc)
  {
    return false;
  }
  @finally
  {
  }
  
  return true;
}

-(void)WriteHeader
{
  if(![self wroteHeader])
  {
    //write the header info
    //NSLog(@"Log Exception: %@", [exc description]);
    [self setWroteHeader:YES];
    [self WriteMessage:[NSString stringWithFormat:@"macOS: %@; Hardware: %@; Memory: %@; StatTag: %@", [STCocoaUtil macOSVersion], [STCocoaUtil machineModel], [STCocoaUtil physicalMemory], [STCocoaUtil bundleVersionInfo]]];
    [self WriteMessage:[NSString stringWithFormat:@"Word: %@", [STCocoaUtil getAssociatedAppInfo]]];
  }
}

/**
 Updates the internal settings used by this log manager, when given a set of application settings.

 @remark : This should ba called any time the application settings are loaded or updated.

 @param settings : Application settings
 */
-(void)UpdateSettings:(STUserSettings*)settings {
  [self UpdateSettings:[settings EnableLogging] filePath:[settings LogLocation] logLevel:[settings LogLevel]];
}

/**
 Updates the internal settings used by this log manager, when given a set of application settings.

 @remark : This should ba called any time the application settings are loaded or updated. If the log path is not valid, we will disable logging.
 
  @param enabled : If logging is enabled by the user
  @param filePath : The path of the log file to write to.
 */
-(void)UpdateSettings:(BOOL)enabled filePath:(NSString*)filePath logLevel:(STLogLevel)logLevel {
  //self.LogFilePath = filePath;
  [self setLogFilePathWithString:filePath];
  _Enabled = (enabled && [self IsValidLogPath:[[self LogFilePath] path]]);
  _logLevel = logLevel;
  
}

-(void) WriteLog:(id)message logLevel:(STLogLevel)logLevel
{
  if(logLevel >= [self logLevel])
  {
    if([message isKindOfClass:[NSException class]] | [message isKindOfClass:[NSError class]])
    {
      [self WriteException:message];
    } else if ([message isKindOfClass:[NSString class]]) {
      [self WriteMessage: message];
    } else if ([message respondsToSelector:@selector(description)]){
      [self WriteMessage: [message description]];
    }
  }
}

/**
  Writes a message to the log file.
 @remark : Can be safely called any time, even if logging is disabled.
 @param text : The text to write to the log file.
*/
-(void) WriteMessage:(NSString*)text
{
  //dispatch_async(dispatch_get_main_queue(), ^{
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSLog(@"%@", text);
  });

  
  //if (_Enabled && [self IsValidLogPath:[[self LogFilePath] path]])
  if (_Enabled)
  {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

      NSError* err;

      if(![self IsValidLogPath:[[self LogFilePath] path]]) {

        [self setLogFilePathWithString:[STLogManager defaultLogFilePath]];
        [_settingsManager Load]; //be careful here - avoid enabling logging when setting settings for now - otherweise - infinite loop
        _settings = [_settingsManager Settings]; //just for setup
        [_settings setLogLocation:[[self LogFilePath] path]];
        [_settingsManager setSettings:_settings];
        
        [[NSFileManager defaultManager] createFileAtPath:[[self LogFilePath] path] contents:[[NSData alloc] init] attributes:nil];

      }
      if([self IsValidLogPath:[[self LogFilePath] path]]) {
        [self WriteHeader];
        [[self FileHandler] AppendAllText:[self LogFilePath] withContent:[NSString stringWithFormat:@"%@ - %@\r\n", [dateFormatter stringFromDate:[NSDate date]], text] error:&err];
      }
    });
    
  }
}

+(NSString*) allowedExtensions_Log {
  return @"txt/TXT/log/LOG";
}
+(NSString*) defaultLogFileName {
 return @"StatTag.log";
}
+(NSString*) defaultLogFilePath {
  NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  return [documentsDirectory stringByAppendingPathComponent:[STLogManager defaultLogFileName]];
}


/**
 Writes the details of an exception to the log file.
 @remark Can be safely called any time, even if logging is disabled. Recursively called for all inner exceptions.
 @param exc : The exception to write to the log file.
*/
-(void)WriteException:(id) exc
{
  if(exc == nil) { return; }

  NSArray* stackTrace;
  NSString* errorDescription;
  if([exc isKindOfClass:[NSException class]])
  {
    stackTrace = [exc callStackSymbols];
    errorDescription = [exc description];
  }
  if([exc isKindOfClass:[NSError class]])
  {
    errorDescription = [exc description];
  }
  if([exc isKindOfClass:[NSString class]])
  {
    errorDescription = exc;
  }

  [self WriteMessage:[NSString stringWithFormat:@"Error: %@/r/nStack trace: %@", errorDescription, stackTrace]];

//  //NSLog(@"Log Exception: %@", [exc description]);
//  [self WriteMessage:[NSString stringWithFormat:@"Error: %@, macOS: %@, Hardware: %@, Stack trace: %@", errorDescription, [STCocoaUtil macOSVersion], [STCocoaUtil machineModel], stackTrace]];

}





@end
