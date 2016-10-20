//
//  STCodeFile+FileAttributes.m
//  StatTag
//
//  Created by Eric Whitley on 10/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCodeFile+FileAttributes.h"

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

@end
