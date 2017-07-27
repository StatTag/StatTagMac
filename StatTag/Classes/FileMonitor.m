//
//  FileMonitor.m
//  StatTag
//
//  Created by Eric Whitley on 10/18/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

//https://developer.apple.com/library/content/samplecode/Lister/Listings/ListerKit_DirectoryMonitor_swift.html
//http://www.davidhamrick.com/2011/10/10/handling-filesystem-events-with-gcd.html
//https://randexdev.com/2012/03/how-to-detect-directory-changes-using-gcd/
//http://stackoverflow.com/questions/11355144/file-monitoring-using-grand-central-dispatch

//https://developer.apple.com/library/content/samplecode/DocInteraction/Listings/Classes_DirectoryWatcher_m.html#//apple_ref/doc/uid/DTS40010052-Classes_DirectoryWatcher_m-DontLinkElementID_6

//http://www.aichengxu.com/view/6564017

//might want to look at this:
//https://github.com/gurinderhans/SwiftFSWatcher
//https://blog.beecomedigital.com/2015/06/27/developing-a-filesystemwatcher-for-os-x-by-using-fsevents-with-swift-2/
//http://stackoverflow.com/questions/24150061/how-to-monitor-a-folder-for-new-files-in-swift


//extending this with injectible blocks
// http://stackoverflow.com/questions/12343833/cocoa-monitor-a-file-for-modifications

//full list of vnodes https://developer.apple.com/reference/dispatch

#import "FileMonitor.h"

@implementation FileMonitor

dispatch_queue_t queue;
dispatch_source_t fileMonitorSource;

-(instancetype) init
{
  self = [super init];
  if(self)
  {
    [self setup];
  }
  return self;
}

-(void)dealloc
{
  [self stopMonitoring];
}

-(void)setup
{
  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  monitoredFileDescriptor = -1;
}

-(void)startMonitoring
{
  if([self filePath] != nil && fileMonitorSource == nil && monitoredFileDescriptor == -1) {
    
    const char *c = [[[self filePath] path] UTF8String];
    monitoredFileDescriptor= open(c , O_RDONLY);
    
    //https://www.cocoanetics.com/2013/08/monitoring-a-folder-with-gcd/
    //http://stackoverflow.com/questions/12343833/cocoa-monitor-a-file-for-modifications
    //https://github.com/tblank555/iMonitorMyFiles
    //kFSEventStreamCreateFlagFileEvents
    //https://stackoverflow.com/questions/1772209/file-level-filesystem-change-notification-in-mac-os-x
    //https://stackoverflow.com/questions/8314348/cocoa-fsevents-kfseventstreamcreateflagfileevents-flag-and-renamed-events
    //https://stackoverflow.com/questions/7300998/tracking-file-renaming-deleting-with-fsevents-on-lion
    //https://developer.apple.com/library/content/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html
    //consider a delegate model (vs notification) - with a shared instance
    //https://github.com/njdehoog/Witness
    //__block typeof(self) blockSelf = self;
    fileMonitorSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,monitoredFileDescriptor,
                                    DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE,
                                    queue);

    if(fileMonitorSource)
    {
      // Copy the filename for later use.
      NSInteger length = strlen(c);
      char* newString = (char*)malloc(length + 1);
      newString = strcpy(newString, c);
      dispatch_set_context(fileMonitorSource, newString);
    }
    
    //do we want our own queue?
    dispatch_source_set_event_handler(fileMonitorSource, ^
      {
        //notify or whatever we need to do...
        unsigned long flags = dispatch_source_get_data(fileMonitorSource);
        if(flags & DISPATCH_VNODE_DELETE)
        {
          //
          //dispatch_source_cancel(fileMonitorSource);
          //NSLog(@"DISPATCH_VNODE_DELETE");
          dispatch_async(dispatch_get_main_queue(), ^{

          NSDictionary *fileInfo = @{@"originalFilePath":[[self filePath] path]};
  
          [[NSNotificationCenter defaultCenter] postNotificationName:@"codeFileDeleted" object:self userInfo:fileInfo];
          });

          //NOTE some apps delete and recreate the file on save!
          //http://www.davidhamrick.com/2011/10/13/Monitoring-Files-With-GCD-Being-Edited-With-A-Text-Editor.html
          
          //dispatch_source_cancel(fileMonitorSource);

          
        } else if (flags & DISPATCH_VNODE_WRITE) {
          //NSLog(@"DISPATCH_VNODE_WRITE");
          dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *fileInfo = @{@"originalFilePath":[[self filePath] path]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"codeFileEdited" object:self userInfo:fileInfo];
          
          });
        } else if (flags & DISPATCH_VNODE_EXTEND) {
          //changed in size - likely due to write activity
          //NSLog(@"DISPATCH_VNODE_EXTEND");
        } else if (flags & DISPATCH_VNODE_ATTRIB) {
          //NSLog(@"DISPATCH_VNODE_ATTRIB");
        } else if (flags & DISPATCH_VNODE_LINK) {
          //dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"DISPATCH_VNODE_LINK");
          //});
        } else if (flags & DISPATCH_VNODE_RENAME) {
          //this also does file moves (path was "renamed" for file descriptor)
          
          //https://developer.apple.com/library/content/documentation/General/Conceptual/ConcurrencyProgrammingGuide/GCDWorkQueues/GCDWorkQueues.html
          //old file name we stored in the context
          //const char*  oldFilename = (char*)dispatch_get_context(fileMonitorSource);

          
          //FILE *file = fdopen([filehandle fileDescriptor], "r");
          
          //NSFileHandle* fn = [[NSFileHandle alloc] initWithFileDescriptor:monitoredFileDescriptor];
          dispatch_async(dispatch_get_main_queue(), ^{

            char* originalPath = (char*)dispatch_get_context(fileMonitorSource);
            //NSLog(@"original file path : %@", [NSString stringWithUTF8String:originalPath]);

            char newPath[MAXPATHLEN];
            //if (fcntl(monitoredFileDescriptor, F_GETPATH, newPath) != -1)
              //NSLog(@"new file path : %@", [NSString stringWithUTF8String:newPath]);

            NSDictionary *fileInfo = @{@"originalFilePath":@(originalPath),
                                       @"newFilePath":@(newPath)};
            
            [self setFilePath:[NSURL URLWithString:@(newPath)]];
            
            //broadcast the file rename
            [[NSNotificationCenter defaultCenter] postNotificationName:@"codeFileRenamed" object:self userInfo:fileInfo];

            //store the updated path as our path
            NSInteger length = strlen(newPath);
            char* newString = (char*)malloc(length + 1);
            newString = strcpy(newString, newPath);
            dispatch_set_context(fileMonitorSource, newString);

            
            free(originalPath);
            //free(newPath);

          });
          
          //NSLog(@"DISPATCH_VNODE_RENAME");
        } else if (flags & DISPATCH_VNODE_REVOKE) {
          //NSLog(@"DISPATCH_VNODE_REVOKE");
        }
        
      });
    dispatch_source_set_cancel_handler(fileMonitorSource, ^
      {
        //NSLog(@"cancel");
        //char* fileStr = (char*)dispatch_get_context(fileMonitorSource);
        //free(fileStr);
        close(monitoredFileDescriptor);
        monitoredFileDescriptor = -1;
        fileMonitorSource = nil;
       });
    dispatch_resume(fileMonitorSource);
    
    
    // sometime later
    
  }

  
}

-(void)stopMonitoring
{
  if(fileMonitorSource != nil)
  {
    dispatch_source_cancel(fileMonitorSource);
  }
}

@end
