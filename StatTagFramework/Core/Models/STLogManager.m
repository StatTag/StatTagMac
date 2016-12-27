//
//  STLogManager.m
//  StatTag
//
//  Created by Eric Whitley on 7/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STLogManager.h"
#import "STProperties.h"
#import "STCocoaUtil.h"
#import "STFileHandler.h"

@implementation STLogManager

@synthesize Enabled = _Enabled;
@synthesize FileHandler = _FileHandler;

@synthesize LogFilePath = _LogFilePath;
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
    NSLog(@"Exception creating URL (%@): %@", NSStringFromClass([self class]), p);
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
    //stream = FileHandler.OpenWrite(logFilePath);
    
    // Check write access
    NSURL* logPath = [NSURL fileURLWithPath:logFilePath];
    NSFileHandle* __unused stream = [[self FileHandler] OpenWrite: logPath];
  }
  @catch (NSException* exc)
  {
    return false;
  }
  @finally
  {
  }
  
  return true;
  
  //
//  NSError *error;
//  NSStringEncoding encoding;
//  NSString *fileContents = [NSString stringWithContentsOfFile:logFilePath
//                                                 usedEncoding:&encoding
//                                                        error:&error];
//
//  NSLog(@"logFilePath : %@", logFilePath);
//  NSLog(@"error : %@", [error localizedDescription]);
//  
//  if(fileContents != nil) {
//    //this returns YES for some invalid paths... ex: "my awesome file" (not a path) so we should probably review
//    // http://stackoverflow.com/questions/2455735/why-does-nsfilemanager-return-true-on-fileexistsatpath-when-there-is-no-such-fil
//    return [[NSFileManager defaultManager] isWritableFileAtPath:logFilePath];
//  } else {
//    //also - go back and review this. This apparently also returns YES if the file already exists... so we may not need all of the checks.
//    BOOL createdFile = [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
//    /*
//     From: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSFileManager_Class/index.html#//apple_ref/occ/instm/NSFileManager/createFileAtPath:contents:attributes:
//     If you specify nil for the attributes parameter, this method uses a default set of values for the owner, group, and permissions of any newly created directories in the path.
//     */
//    //do we want to alert the user if this fails?
//    return createdFile;
//  }
//  
}


/**
 Updates the internal settings used by this log manager, when given a set of application properties.

 @remark : This should ba called any time the application properties are loaded or updated.

 @param properties : Application properties
 */
-(void)UpdateSettings:(STProperties*)properties {
  [self UpdateSettings:[properties EnableLogging] filePath:[properties LogLocation]];
}

/**
 Updates the internal settings used by this log manager, when given a set of application properties.

 @remark : This should ba called any time the application properties are loaded or updated. If the log path is not valid, we will disable logging.
 
  @param enabled : If logging is enabled by the user
  @param filePath : The path of the log file to write to.
 */
-(void)UpdateSettings:(BOOL)enabled filePath:(NSString*)filePath {
  //self.LogFilePath = filePath;
  [self setLogFilePathWithString:filePath];
  _Enabled = (enabled && [self IsValidLogPath:[[self LogFilePath] path]]);
}


/**
  Writes a message to the log file.
 @remark : Can be safely called any time, even if logging is disabled.
 @param text : The text to write to the log file.
*/
-(void) WriteMessage:(NSString*)text
{
  if (_Enabled && [self IsValidLogPath:[[self LogFilePath] path]])
  {

    //                FileHandler.AppendAllText(LogFilePath, string.Format("{0} - {1}\r\n", DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss.fff"), text));

    NSError* err;
    [[self FileHandler] AppendAllText:[self LogFilePath] withContent:[NSString stringWithFormat:@"%@ - %@\r\n", [dateFormatter stringFromDate:[NSDate date]], text] error:&err];
    
//    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:[self LogFilePath]];
//    if(myHandle) {
//      [myHandle seekToEndOfFile];
//      
//      [myHandle writeData:[[NSString stringWithFormat:@"%@ - %@\r\n", [dateFormatter stringFromDate:[NSDate date]], text] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
  }
}

/**
 Writes the details of an exception to the log file.
 @remark Can be safely called any time, even if logging is disabled. Recursively called for all inner exceptions.
 @param exc : The exception to write to the log file.
*/
-(void)WriteException:(NSException*) exc
{
  NSArray* stackTrace = [exc callStackSymbols];
  [self WriteMessage:[NSString stringWithFormat:@"Error: %@\r\nmacOS: %@\r\nHardware: %@\r\nStack trace: %@", [exc description], [STCocoaUtil macOSVersion], [STCocoaUtil machineModel], stackTrace]];
}





@end
