//
//  STFileHandler.m
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//
// http://www.techotopia.com/index.php/Working_with_Files_in_Objective-C
// http://stackoverflow.com/questions/3295527/cocoa-touch-loading-a-text-file-into-an-array
// http://mikeabdullah.net/atomically-copying-a-file.html
// http://stackoverflow.com/questions/13565867/replaceitematurlwithitematurlbackupitemnameoptionsresultingitemurlerror-br
// http://stackoverflow.com/questions/17779655/objective-c-create-text-file-to-read-and-write-line-by-line-in-cocoa
// http://stackoverflow.com/questions/1820204/objective-c-creating-a-text-file-with-a-string
// http://nshipster.com/nserror/


#import "STFileHandler.h"
#import "STConstants.h"

@implementation STFileHandler


- (NSArray*) ReadAllLines:(NSURL*)filePath error:(NSError**)error {
  
  //it's possible we've got a URL w/o a file scheme (since we're setting so much with string vs. URL) - so we're going to see and try to set a file URL (which sets scheme)
  NSURL* urlWithScheme = [NSURL fileURLWithPath:[filePath path]];
  
  BOOL isDir;
  if (![[NSFileManager defaultManager] fileExistsAtPath:[urlWithScheme path] isDirectory:&isDir]) {
    NSDictionary *userInfo = @{
             NSLocalizedDescriptionKey: NSLocalizedString(@"Could not read file.", nil),
             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"There was an issue reading the file.", nil),
             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Is this a valid script file?", nil)
             };
    *error = [NSError errorWithDomain:STStatTagErrorDomain code:NSURLErrorFileDoesNotExist userInfo:userInfo];
  }
  
  NSString *fileString = [NSString stringWithContentsOfURL:urlWithScheme encoding:NSUTF8StringEncoding error:error];
  NSArray *stringArray = [fileString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  return stringArray;
}
- (BOOL) Exists:(NSURL*)filePath error:(NSError**)error {
  NSLog(@"%@ path = %@", NSStringFromSelector(_cmd), [filePath path]);
  
  BOOL isDir;
  BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[filePath path] isDirectory:&isDir];
  //isReadableFileAtPath
  if (!exists || isDir) {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Could not read file.", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"There was an issue reading the file.", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Is this a valid script file?", nil)
                               };
    if(error != nil){
      *error = [NSError errorWithDomain:STStatTagErrorDomain code:NSURLErrorFileDoesNotExist userInfo:userInfo];
    }
  }
  return exists;
}

+(BOOL) Exists:(NSURL*)filePath error:(NSError**)error {
  STFileHandler* me = [[STFileHandler alloc] init];
  return [me Exists:filePath error:error];
}

/**
 @brief Copies an existing file to a new file.
 https://msdn.microsoft.com/en-us/library/system.io.file.copy%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396
 */
- (void) Copy:(NSURL*)sourceFile toDestinationFile: (NSURL*)destinationFile error:(NSError**)error {

  //http://mikeabdullah.net/atomically-copying-a-file.html
  
  //it's possible we've got a URL w/o a file scheme (since we're setting so much with string vs. URL) - so we're going to see and try to set a file URL (which sets scheme)
  sourceFile = [NSURL fileURLWithPath:[sourceFile path]];
  destinationFile = [NSURL fileURLWithPath:[destinationFile path]];
  
  NSFileManager *manager = [NSFileManager defaultManager];
  
  // First copy into a temporary location where failure doesn't matter
  NSURL *tempDir = [manager URLForDirectory:NSItemReplacementDirectory
                                   inDomain:NSUserDomainMask
                          appropriateForURL:destinationFile
                                     create:YES
                                      error:error];
  
  //throw an error
  if (!tempDir) {
    return;
  }
  
  NSURL *tempURL = [tempDir URLByAppendingPathComponent:[destinationFile lastPathComponent]];
  
  BOOL result = [manager copyItemAtURL:sourceFile toURL:tempURL error:error];
  if (result)
  {
    // Move the complete item into place, replacing any existing item in the process
    NSURL *resultingURL;
    result = [manager replaceItemAtURL:destinationFile
                         withItemAtURL:tempURL
                        backupItemName:nil
                               options:NSFileManagerItemReplacementUsingNewMetadataOnly
                      resultingItemURL:&resultingURL
                                 error:error];
    
    if (result)
    {
      NSAssert([resultingURL.absoluteString isEqualToString:destinationFile.absoluteString],
               @"URL unexpectedly changed during replacement from:\n%@\nto:\n%@",
               destinationFile,
               resultingURL);
    }
  }
  
  // Clean up
  NSError *err;
  if (![manager removeItemAtURL:tempDir error:&err])
  {
    NSLog(@"Failed to remove temp directory after atomic copy: %@", err);
  }
  
  //return result;

}

- (void) WriteAllLines:(NSURL*)filePath withContent: (NSArray*)content error:(NSError**)error {
  NSLog(@"writing to path... %@", [filePath path]);
  NSString *contentString = [content componentsJoinedByString:@"\n"];
  
  NSLog(@"contentString now : %@", contentString);
  BOOL success = [contentString
                  writeToFile:[filePath path]
                  atomically:YES
                  encoding:NSUTF8StringEncoding
                  error:nil];
  NSLog(@"%@ success = %hhd",NSStringFromSelector(_cmd), success);
}

- (void) WriteAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error {
  BOOL success = [content writeToFile:[filePath path]
            atomically:YES
            encoding:NSStringEncodingConversionAllowLossy
            error:error];
  NSLog(@"%@ success = %hhd", NSStringFromSelector(_cmd), success);
}

@end