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

@implementation STLogManager

@synthesize Enabled = _Enabled;

@synthesize LogFilePath = _LogFilePath;
- (void) setLogFilePath:(NSString *)p {
  _LogFilePath = [p stringByExpandingTildeInPath];
}
- (NSString*)LogFilePath {
  return _LogFilePath;
}


-(instancetype)init {
  self = [super init];
  if(self) {
    _LogFilePath = @"";
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss.SSS";
  }
  return self;
}

/**
 Determine if a given path is accessible and can be opened with write access.
 
 @param logFilePath : The file path to check
 
 @returns : True if the path is valid, false otherwise.
 */

+(BOOL)IsValidLogPath:(NSString*)logFilePath {
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if (logFilePath == nil || [[logFilePath stringByTrimmingCharactersInSet: ws] length] == 0) {
    return false;
  }

  //if we have tilde paths, expand the full path
  logFilePath = [logFilePath stringByExpandingTildeInPath];
  
  NSError *error;
  NSStringEncoding encoding;
  NSString *fileContents = [NSString stringWithContentsOfFile:logFilePath
                                                 usedEncoding:&encoding
                                                        error:&error];

  NSLog(@"logFilePath : %@", logFilePath);
  NSLog(@"error : %@", [error localizedDescription]);
  
  if(fileContents != nil) {
    //this returns YES for some invalid paths... ex: "my awesome file" (not a path) so we should probably review
    // http://stackoverflow.com/questions/2455735/why-does-nsfilemanager-return-true-on-fileexistsatpath-when-there-is-no-such-fil
    return [[NSFileManager defaultManager] isWritableFileAtPath:logFilePath];
  } else {
    //also - go back and review this. This apparently also returns YES if the file already exists... so we may not need all of the checks.
    BOOL createdFile = [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
    /*
     From: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSFileManager_Class/index.html#//apple_ref/occ/instm/NSFileManager/createFileAtPath:contents:attributes:
     If you specify nil for the attributes parameter, this method uses a default set of values for the owner, group, and permissions of any newly created directories in the path.
     */
    //do we want to alert the user if this fails?
    return createdFile;
  }
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
  self.LogFilePath = filePath;
  _Enabled = (enabled && [[self class]IsValidLogPath:[self LogFilePath]]);
}


/**
  Writes a message to the log file.
 @remark : Can be safely called any time, even if logging is disabled.
 @param text : The text to write to the log file.
*/
-(void) WriteMessage:(NSString*)text
{
  if (_Enabled && [[self class] IsValidLogPath:[self LogFilePath]])
  {

    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:[self LogFilePath]];
    if(myHandle) {
      [myHandle seekToEndOfFile];
      
      [myHandle writeData:[[NSString stringWithFormat:@"%@ - %@\r\n", [dateFormatter stringFromDate:[NSDate date]], text] dataUsingEncoding:NSUTF8StringEncoding]];
    }
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
