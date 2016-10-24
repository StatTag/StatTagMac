//
//  STCodeFile+FileAttributes.m
//  StatTag
//
//  Created by Eric Whitley on 10/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCodeFile+FileAttributes.h"
#import "STFileHandler.h"

@implementation STCodeFile (FileAttributes)


-(NSDate*)modificationDate
{
  NSDate * fileLastModifiedDate = nil;
  
  NSError * error = nil;
  NSDictionary * attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[self FilePath] error:&error];
  if (attrs && !error)
  {
    fileLastModifiedDate = [attrs fileModificationDate];
  }
  
  return fileLastModifiedDate;
}

-(NSDate*)creationDate
{
  NSDate * fileLastModifiedDate = nil;
  
  NSError * error = nil;
  NSDictionary * attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[self FilePath] error:&error];
  if (attrs && !error)
  {
    fileLastModifiedDate = [attrs fileCreationDate];
  }
  
  return fileLastModifiedDate;
}

-(BOOL)fileAccessibleAtPath
{
  NSError* error;
  return [STFileHandler Exists:[self FilePathURL] error:&error];
}

-(NSString*)codeFileToolTipMessage
{
  //This should NOT be here. I'm cheating and sticking this here instead of dealing with the NSTableView delegate
  // - I can't figure out how to do view-based column-specific tooltips using the delegates. Cell-based? Yes. View-based? No.
  if([self fileAccessibleAtPath])
  {
    return nil;
  }
  return @"File not accessible. File might not exist at specified path or you might not have permission to access it.";
}

@end
