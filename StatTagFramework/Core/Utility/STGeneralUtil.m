//
//  STGeneralUtil.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STGeneralUtil.h"
#import "STFileHandler.h"

@implementation STGeneralUtil

/**
 Convert a string array to an object array to avoid potential issues (per ReSharper).

 @param data: The string array to convert
 @Nil if the string array is null, otherwise an object-cast array representation of the original string array.
*/
+(NSArray*)StringArrayToObjectArray:(NSArray<NSString*>*) data
{
  return data;
//  if (data == nil)
//  {
//    return nil;
//  }
//  
//  return data.Select(x => x as object).ToArray();
}

+(BOOL)IsStringNullOrEmpty:(NSString*)str
{
    return (str == nil || ([str length] == 0));
}

+(BOOL)CreateDirectory:(NSString*)path
{
  NSFileManager* fileManager = [NSFileManager defaultManager];
  BOOL isDir = YES;
  if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
    NSError* error;
    BOOL result = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    return result;
  }
  
  return YES;
}

+(BOOL)DirectoryExists:(NSString*)path
{
  NSFileManager* fileManager = [NSFileManager defaultManager];
  BOOL isDir = YES;
  return [fileManager fileExistsAtPath:path isDirectory:&isDir];
}

// Clean the files out of a directory given a directory path (path), a filter string (filter), and
// a flag to indicate if the directory itself should be deleted (deleteDirectory).
+(void)CleanDirectory:(NSString*)path filter:(NSString*)filter deleteDirectory:(BOOL)deleteDirectory
{
  NSArray<NSString*>* files = [STGeneralUtil GetFilesInFolder:path filter:filter];
  NSFileManager* fileManager = [NSFileManager defaultManager];
  for(NSString* file in files) {
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", path, file] error:nil];
  }
  
  if (deleteDirectory) {
    [fileManager removeItemAtPath:path error:nil];
  }
}

+(NSArray<NSString*>*)GetFilesInFolder:(NSString*)path filter:(NSString*)filter
{
  NSFileManager* fileManager = [NSFileManager defaultManager];
  NSArray<NSString*>* files = [fileManager contentsOfDirectoryAtPath:path error:nil];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:filter];
  return [files filteredArrayUsingPredicate:predicate];
}

+(void)CopyFile:(NSURL*)sourceFile toDestinationFile:(NSURL*)destinationFile
{
  STFileHandler* fileHandler = [[STFileHandler alloc] init];
  [fileHandler Copy:sourceFile toDestinationFile:destinationFile error:nil];
}

@end
