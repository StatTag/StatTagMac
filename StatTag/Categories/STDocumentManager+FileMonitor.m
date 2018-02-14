//
//  STDocumentManager+FileMonitor.m
//  StatTag
//
//  Created by Eric Whitley on 10/18/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STDocumentManager+FileMonitor.h"
#import "STCodeFile.h"

#import "FileMonitor.h"
#import "StatTagShared.h"
#import "STCodeFile+FileAttributes.h"
#import "STCodeFile+FileMonitor.h"
#import "STDocumentManager+FileMonitor.h"
#import <objc/runtime.h>

@implementation FileChangeNotificationData

@synthesize FileDeletedInformation = _FileDeletedInformation;
@synthesize FileModifiedInformation = _FileModifiedInformation;
@synthesize FileMovedInformation = _FileMovedInformation;

//this is a really dumb data structure, but it's mean to be simple so we can step through some things for now
// can refactor later

-(instancetype)init
{
  self = [super init];
  if(self)
  {
  }
  return self;
}

-(instancetype)initWithFilePath:(NSString*)filePath
{
  self = [super init];
  if(self)
  {
    [self setFilePath:filePath];
  }
  return self;
}

-(BOOL)fileModified
{
  if([self FileModifiedInformation] != nil && [[[self FileModifiedInformation] allKeys] count] > 0)
  {
    return YES;
  }
  return NO;
}

-(BOOL)fileMoved
{
  if([self FileMovedInformation] != nil && [[[self FileMovedInformation] allKeys] count] > 0)
  {
    return YES;
  }
  return NO;
}
-(BOOL)fileDeleted
{
  if([self FileDeletedInformation] != nil && [[[self FileDeletedInformation] allKeys] count] > 0)
  {
    return YES;
  }
  return NO;
}

-(void)setNotificationData:(NSDictionary*)d
{
  if(d != nil && [[d allKeys] containsObject:@"operation"] && [[d allKeys] containsObject:@"originalFilePath"])
  {
    FileChangeOperationType operation = (FileChangeOperationType)[(NSNumber*)[d objectForKey:@"operation"] integerValue];
    //  FileChangeOperationTypeRenameOrMove = 1,
    //  FileChangeOperationTypeContentsChanged = 2,
    //  FileChangeOperationTypeDelete = 3
    NSURL* newPath = [d valueForKey:@"newPath"];
    //NSURL* originalFilePath = [d valueForKey:@"originalFilePath"];

    if(operation == FileChangeOperationTypeRenameOrMove)
    {
      //if we have a change that "resets" our position back to the "original" file path, wipe out the change data
      //user moved the file around, but returned it back to the original position, so we're fine
      if(newPath != nil)
      {
        if([[newPath path] isEqualToString:[self filePath]])
        {
          //file moved back into original position - wiped out all notifications for moved/renamed events
          _FileMovedInformation = nil;
        } else {
          _FileMovedInformation = d;
        }
      }
    } else if (operation == FileChangeOperationTypeContentsChanged)
    {
      _FileModifiedInformation = d;
    } else if (operation == FileChangeOperationTypeDelete)
    {
      _FileDeletedInformation = d;
    }
  }
}

-(NSString*)description
{
  return [NSString stringWithFormat:@"path: %@, fileMoved:%hhd, fileModified:%hhd, fileDeleted:%hhd, fileMovedInformation:%@, fileModifiedInformation:%@, fileDeletedInformation:%@", [self filePath], [self fileMoved], [self fileModified], [self fileDeleted], [self FileMovedInformation], [self FileModifiedInformation], [self FileDeletedInformation]];
}

@end

@implementation STDocumentManager (FileMonitor)

//think about whether all of this should be in the shared object... it would make this easier, but...

static void *FileMonitorArrayPropertyKey = &FileMonitorArrayPropertyKey;
static void *FileNotificationArrayPropertyKey = &FileNotificationArrayPropertyKey;

-(void)startMonitoringCodeFiles
{
  [self stopMonitoringCodeFiles];
  //FIXME: we shouldn't have this both here and in the code file - consolidate this
  for(STCodeFile* cf in [self GetCodeFileList]) {
    if([cf fileAccessibleAtPath])
    {
      //[fm observeChangesForObject:cf withKeyPath:NSStringFromSelector(@selector(FilePathURL))];
      FileMonitor* fm = [[FileMonitor alloc] init];
      [fm setFilePath:[cf FilePathURL]];
      [fm startMonitoring];
      [fm setDelegate:self];
      [[self fileMonitors] addObject:fm];
      //[[[StatTagShared sharedInstance] fileMonitors] addObject:fm];
    }
  }
}

-(void)stopMonitoringCodeFiles
{
  //turn off our monitoring - the other view must manage it
  /*
  for(FileMonitor* fm in [[StatTagShared sharedInstance] fileMonitors])
  {
    [fm stopMonitoring];
  }
  [[[StatTagShared sharedInstance] fileMonitors] setArray:[[NSMutableArray<FileMonitor*> alloc] init]];
   */
  for(FileMonitor* fm in [self fileMonitors])
  {
    [fm stopMonitoring];
  }
  [[self fileMonitors] setArray:[[NSMutableArray<FileMonitor*> alloc] init]];
}


//MARK: File Monitor array
-(NSMutableArray<FileMonitor*>*)fileMonitors {
  NSMutableArray<FileMonitor*>* f = objc_getAssociatedObject(self, FileMonitorArrayPropertyKey);
  if(f == nil) {
    f = [[NSMutableArray<FileMonitor*> alloc] init];
    [self setFileMonitors:f];
  }
  return objc_getAssociatedObject(self, FileMonitorArrayPropertyKey);
}

- (void)setFileMonitors:(NSArray<FileMonitor*>*)fileMonitors {
  objc_setAssociatedObject(self, FileMonitorArrayPropertyKey, [fileMonitors mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//MARK: File Monitor array
-(NSMutableArray<NSDictionary*>*)fileNotifications {
  NSMutableArray<NSDictionary*>* f = objc_getAssociatedObject(self, FileNotificationArrayPropertyKey);
  if(f == nil) {
    f = [[NSMutableArray<NSDictionary*> alloc] init];
    [self setFileNotifications:f];
  }
  return objc_getAssociatedObject(self, FileNotificationArrayPropertyKey);
}

- (void)setFileNotifications:(NSArray<FileMonitor*>*)fileNotifications {
  objc_setAssociatedObject(self, FileNotificationArrayPropertyKey, [fileNotifications mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)monitorCodeFile:(STCodeFile*)file
{
  if([file fileMonitor] == nil)
  {
    [file setFileMonitor:[[FileMonitor alloc] init]];
    [[file fileMonitor] setFilePath:[file FilePathURL]];
    //[[file fileMonitor] observeChangesForObject:file withKeyPath:NSStringFromSelector(@selector(FilePathURL))];
  }
  if(![[self fileMonitors] containsObject:[file fileMonitor]])
  {
    [[file fileMonitor] startMonitoring];
    [[self fileMonitors] addObject:[file fileMonitor]];
  }
}
-(void)stopMonitoringCodeFile:(STCodeFile*)file
{
  if([[self fileMonitors] containsObject:[file fileMonitor]])
  {
    [[file fileMonitor] stopMonitoring];
    [[self fileMonitors] removeObject:[file fileMonitor]];
  }
}


-(void)fileDidChange:(NSDictionary*)fileInfo
{
  //NSLog(@"received fileDidChange notification");
  [[self fileNotifications] addObject:fileInfo];
}

-(NSDictionary<NSString*, FileChangeNotificationData*>*)getPrioritizedFileNotifications
{
  /*
   Objective: let's tell the user what happened, but in a simplified summary form.
   
   In order of precedence:
   1) If a file was deleted, let's tell the user that - stop there. Nothing else really matters.
   2) If a single file moved...
   - 23 times we only care about the _last_ time. (origin to target)
   - if that last time puts it back into the same location (as the origin path), let's not bother the user
   3) If a file was modified, let's tell the user that the content changed
   
   For each code file we're going to wind up with one of two possible outcomes
   1) a delete
   2) a combination of a single file change and/or single file move
  */
  
  NSMutableDictionary<NSString*, FileChangeNotificationData*>* fileChanges = [[NSMutableDictionary<NSString*, FileChangeNotificationData*> alloc] init];
  
  for(NSDictionary* d in [self fileNotifications])
  {
    NSURL* codeFilePath = [d valueForKey:@"originalFilePath"];
    FileChangeNotificationData* fcd;
    if([[fileChanges allKeys] containsObject:[codeFilePath path]])
    {
      //key already exists - grab and reuse
      fcd = [fileChanges objectForKey:[codeFilePath path]];
    } else {
      fcd = [[FileChangeNotificationData alloc] initWithFilePath:[codeFilePath path]];
    }
    
    if(fcd != nil)
    {
      //add our new notification data
      [fcd setNotificationData:d];
      [fileChanges setObject:fcd forKey:codeFilePath];
    }
  }
  
  //we may have some (basically useless) notifications when we're done
  // if that's the case, remove them - we don't want to confuse things
  for(NSString* k in [fileChanges allKeys])
  {
    FileChangeNotificationData* v = [fileChanges objectForKey:k];
    if(![v fileDeleted] && ![v fileModified] && ![v fileMoved])
    {
      [fileChanges removeObjectForKey:k];
    }
  }
  
  [self clearNotifications];
  return fileChanges;
}

-(void)clearNotifications
{
  [self setFileNotifications:[[NSMutableArray<NSDictionary*> alloc] init]];
}

//-(void)monitorCodeFile:(STCodeFile*)file
//{
//  if([file fileMonitor] == nil)
//  {
//    [file setFileMonitor:[[FileMonitor alloc] init]];
//    [[file fileMonitor] setFilePath:[file FilePathURL]];
//    //[[file fileMonitor] observeChangesForObject:file withKeyPath:NSStringFromSelector(@selector(FilePathURL))];
//  }
//  if(![[self fileMonitors] containsObject:[file fileMonitor]])
//  {
//    [[file fileMonitor] startMonitoring];
//    [[self fileMonitors] addObject:[file fileMonitor]];
//  }
//}
//-(void)stopMonitoringCodeFile:(STCodeFile*)file
//{
//  if([[self fileMonitors] containsObject:[file fileMonitor]])
//  {
//    [[file fileMonitor] stopMonitoring];
//    [[self fileMonitors] removeObject:[file fileMonitor]];
//  }
//}


@end
