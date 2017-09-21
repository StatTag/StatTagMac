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

#include <CoreServices/CoreServices.h>
#include "NSURL+FileAccess.h"
#import <StatTagFramework/StatTagFramework.h>

@implementation FileMonitor

//NSInteger _monitoredFileDescriptor;

//static void *FileMonitorContext = &FileMonitorContext;

@synthesize monitoredFileDescriptor = _monitoredFileDescriptor;
@synthesize isMonitoring = _isMonitoring;
@synthesize stream = _stream;

/*
 [self addObserver:self
 forKeyPath:NSStringFromSelector(@selector(FilePathURL))
 options:(NSKeyValueObservingOptionNew |
 NSKeyValueObservingOptionOld)
 context:FileMonitorContext];
 
 */
//- (void)beginObservingFilePath//Key:(NSString*)keyPath ForObject:(id)object
//{
//  [self addObserver:self
//         forKeyPath:NSStringFromSelector(@selector(filePath))
//            options:(NSKeyValueObservingOptionNew |
//                     NSKeyValueObservingOptionOld)
//            context:FileMonitorContext];
//  
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//  if ([keyPath isEqualToString:NSStringFromSelector(@selector(filePath))]) {
//    NSLog(@"path changed");
//  }
//}


//MARK: delegate methods and helper prep methods
-(void)fileDidChange:(NSDictionary*)fileInfo
{
  //NSLog(@"fileInfo: %@", fileInfo);
  if([[self delegate] respondsToSelector:@selector(fileDidChange:)]) {
    [[self delegate] fileDidChange:fileInfo];
  }
}

-(NSDictionary*)fileInfoDictionaryForOperation:(FileChangeOperationType)operation withOriginalPath:(NSURL*)originalFilePath andNewPath:(NSURL*)newPath
{
  NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:originalFilePath, @"originalFilePath", @(operation), @"operation", newPath, @"newPath", nil];
  return dict;
}



-(void)fileChangedForOperation:(FileChangeOperationType)operation withOriginalPath:(NSURL*)originalFilePath andNewPath:(NSURL*)newPath
{
  if([originalFilePath isEqual: [self filePath]] && (
                                                     //FIXME: need to address renaming from (good)->(bad)->(good) etc.
        (operation == FileChangeOperationTypeRenameOrMove)// && ![originalFilePath fileExistsAtPath] && ![_lastNewPath isEqual:newPath])//![_lastNewPath isEqual:newPath] && ![originalFilePath isEqual:[self filePath]])
        || (operation == FileChangeOperationTypeContentsChanged)
        || (operation == FileChangeOperationTypeDelete && ![originalFilePath fileExistsAtPath] )
      )) {
    //we have situations where the events fire back to back for "the same" operation (EX: move file to trash seems to fire twice - once for the root move and once for the file path chang). We want to ignore subsequent events for file moves if the target paths are the same as they were previously (origin file path should always be the same)
    //_lastOriginalPath = originalFilePath;
    _lastNewPath = newPath;
    [self fileDidChange:[self fileInfoDictionaryForOperation:operation withOriginalPath:originalFilePath andNewPath:newPath]];
  }
}

//-(void)observeChangesForObject:(id)object withKeyPath:(NSString*)keypath
//{
//  _observedKeyPath = keypath;
//  [[self observedObject] removeObserver:self forKeyPath:_observedKeyPath];
//  
//  [object addObserver:self
//           forKeyPath:keypath
//              options:(NSKeyValueObservingOptionNew |
//                       NSKeyValueObservingOptionOld)
//              context:FileMonitorContext];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context {
//  
//  if (context == FileMonitorContext) {
//    NSLog(@"code file path changed somewhere");
//    if ([object isKindOfClass:[STCodeFile class]]) { //shouldn't we just do responds to selector? [keypath] ?
//      if ([keyPath isEqualToString:NSStringFromSelector(@selector(FilePath))]) {
//        NSLog(@"actual code file URL changedd");
//      }
//    }
////    NSLog(@"code file path changed");
////    FileMonitor* f = objc_getAssociatedObject(self, FileMonitorPropertyKey);
////    if(f != nil) {
////      [f setFilePath:[self FilePathURL]];
////      [f restartMonitor];
////    }
//  } else {
//    // Any unrecognized context must belong to super
//    [super observeValueForKeyPath:keyPath
//                         ofObject:object
//                           change:change
//                          context:context];
//  }
//}


//MARK: initializers
-(instancetype) init
{
  self = [super init];
  if(self)
  {
    [self setup];
    //[self beginObservingFilePath];
  }
  return self;
}

-(void)dealloc
{
  //NSLog(@"File Watcher - deallocating");
  [[self observedObject] removeObserver:self forKeyPath:_observedKeyPath];
  if(_isMonitoring)
  {
    [self stopMonitoring];
  }
}

-(void)setup
{
  _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  _monitoredFileDescriptor = -1;
}

//MARK: general start / stop monitoring

-(void)restartMonitor
{
  //we're just going to stop and restart the monitors
  _lastOriginalPath = [self filePath];
  _lastNewPath = [self filePath];
  [self stopMonitoring];
  [self startMonitoring];
}

- (void)startMonitoring {
  //NSLog(@"FileMonitor: Start Monitoring -> %@", [[self filePath] path]);
  
  //const char *c = [[[self filePath] path] UTF8String];
  //_monitoredFileDescriptor= open(c , O_RDONLY);

  _monitoredFileDescriptor = open([[[self filePath] path] cStringUsingEncoding:NSUTF8StringEncoding], O_RDONLY);

  //NSLog(@"file descriptor: %ld", (long)_monitoredFileDescriptor);
  
  [self startMonitoringWithFSEvents];
  [self startMonitoringWithGCD];
}

- (void)stopMonitoring {
  //NSLog(@"FileMonitor: Stop Monitoring -> %@", [[self filePath] path]);

  [self stopMonitoringWithFSEvents];
  [self stopMonitoringWithGCD];
}

//MARK: FSEvents

- (void)startMonitoringWithFSEvents {
  
  //stop if we're already monitoring
  if (_stream && _isMonitoring)
  {
    [self stopMonitoringWithFSEvents];
  }

  
  void *appPointer = (__bridge void *)self;
  FSEventStreamContext context = {0, appPointer, NULL, NULL, NULL};
  NSTimeInterval latency = 1.0;

  //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //NSArray *pathsToWatch = [NSArray arrayWithObject:[defaults stringForKey:@"SomeKey"]];
  
  NSArray *pathsToWatch = [NSArray arrayWithObject:[[self filePath] path]];
  
  /*
  NSError* error = [[NSError alloc] init];
  NSString *fileID = nil;
  [[self filePath] getResourceValue:&fileID forKey:NSURLFileResourceIdentifierKey error:&error]; //NS_AVAILABLE(10_7, 5_0);
  */

  //_monitoredFileDescriptor = open([[[self filePath] path] cStringUsingEncoding:NSUTF8StringEncoding], O_RDONLY);
  
  //void *fsevents_callback = NULL;
  
  //https://stackoverflow.com/questions/13594545/fseventstream-what-does-the-kfseventstreamcreateflagignoreself-flag-do
  //great example
  //https://stackoverflow.com/questions/18415285/osx-fseventstreameventflags-not-working-correctly
  //just use a wrapper?
  //https://github.com/rastersize/CDEvents
  //https://github.com/mz2/SCEvents/blob/master/SCEvents.m
  //handling renames
  //https://stackoverflow.com/questions/8314348/cocoa-fsevents-kfseventstreamcreateflagfileevents-flag-and-renamed-events?rq=1
  //
  //deletes/removes don't seem to fire events?
  // https://gist.github.com/nielsbot/5155671
  /*
   NSString *fileID = nil;
   [url getResourceValue:&fileID forKey:NSURLFileResourceIdentifierKey error:&error]; //NS_AVAILABLE(10_7, 5_0);
   */
  /*
   https://stackoverflow.com/questions/7300998/tracking-file-renaming-deleting-with-fsevents-on-lion
   https://stackoverflow.com/questions/13594545/fseventstream-what-does-the-kfseventstreamcreateflagignoreself-flag-do
   https://gist.github.com/braveg1rl/3322773
   https://stackoverflow.com/questions/11123007/check-which-files-have-changed-in-macfsevents-in-perl
   https://developer.apple.com/library/content/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html
   https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/Introduction/Introduction.html
   
   --good samples
   https://stackoverflow.com/questions/7095985/changing-the-pathstowatch-in-fsevents
   https://stackoverflow.com/questions/5799003/is-it-possible-to-use-fsevents-to-get-notifications-that-a-folder-has-been-moved?rq=1
   https://stackoverflow.com/questions/8562265/how-to-get-folder-changes-notificationsfolder-watcher-in-cocoa
   https://forums.macrumors.com/threads/tracking-file-system-changes.831806/
   
   //others
   https://github.com/bnoordhuis/fsevents/blob/fsevents-rewrite/binding.cc
   https://github.com/facebook/watchman/blob/master/watcher/fsevents.cpp
   https://github.com/mz2/SCEvents
   
   Apple
   https://developer.apple.com/library/content/samplecode/CocoaSlideCollection/Listings/CocoaSlideCollection_Model_AAPLFileTreeWatcherThread_m.html
   */
  
  _stream = FSEventStreamCreate(
                              NULL,
                               &feCallback,
                               &context,
                               (__bridge CFArrayRef) pathsToWatch,
                               kFSEventStreamEventIdSinceNow, //[lastEventId unsignedLongLongValue],
                               (CFAbsoluteTime) latency,
                               kFSEventStreamCreateFlagNoDefer | kFSEventStreamCreateFlagWatchRoot | kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagMarkSelf | kFSEventStreamCreateFlagIgnoreSelf//we're ignoring events we create - like file writes from our own editor
                               );
                              //kFSEventStreamCreateFlagNoDefer
  
  //need to monitor
  //path changes (move, rename - for file and parent(s))
  //final deletion (file deleted after move)
  //content change
  //how do we handle situations where the file is deleted and recreated? (certain text editors)
  if (_stream != NULL) {
    FSEventStreamScheduleWithRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    _isMonitoring = FSEventStreamStart(_stream);
  }
}

- (void)stopMonitoringWithFSEvents {
  if (_stream && _isMonitoring)
  {
    FSEventStreamStop(_stream);
    //FSEventStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    FSEventStreamInvalidate(_stream);
    FSEventStreamRelease(_stream);
  }
  _isMonitoring = false;
}

void feCallback(ConstFSEventStreamRef streamRef, void* pClientCallBackInfo,
                       size_t numEvents, void* pEventPaths, const FSEventStreamEventFlags eventFlags[],
                       const FSEventStreamEventId eventIds[])
{
  //NSLog(@"received an event");

  
  int __count = 0 ;
  char **pathsList = pEventPaths;
  
  FileMonitor* fileMonitor = (__bridge FileMonitor*)pClientCallBackInfo;
  //NSLog(@"original path : %@", [[fileMonitor filePath] path]);
  
  //printf("callback #%u\n", ++__count ) ;
  const char * flags[] = {
    "MustScanSubDirs",
    "UserDropped",
    "KernelDropped",
    "EventIdsWrapped",
    "HistoryDone",
    "RootChanged",
    "Mount",
    "Unmount",
    "ItemCreated",
    "ItemRemoved",
    "ItemInodeMetaMod",
    "ItemRenamed",
    "ItemModified",
    "ItemFinderInfoMod",
    "ItemChangeOwner",
    "ItemXattrMod",
    "ItemIsFile",
    "ItemIsDir",
    "ItemIsSymlink",
    "OwnEvent"
  } ;
  
  /*
   
   FSEvent Stream EventFlag       Description
   None                           Default Flag. A change occurred in this directory but no event flag was set with this change.
   MustScanSubDirs                Informs the application needs to rescan the affected directory and subdirectories under it.
   UserDropped                    Error occurred during setting flag, application should perform full scan of directory for changes.
   KernelDropped                  Error occurred during setting flag, application should perform full scan of directory for changes.
   EventIdsWrapped                64-bit event ID counter wrapped around, previously-issued event ID’s are no longer valid
   HistoryDone                    Marker Flag to indicate when previous set flags should be ignored.
   RootChanged                    Flag set when change occurred in a directory along the path of a watched directory.
   Mount                          A volume was mounted under one that was being watched.
   Unmount                        A volume was unmounted under one that was being watched.
   ItemCreated                    Flag set when a file or directory is created
   ItemRemoved                    Flag set when file or directory is deleted
   ItemInodeMetaMod               Flag set when inode metadata has been modified
   ItemRenamed                    Flag set when file or directory is renamed
   ItemModified                   Flag set when file or directory is modified
   ItemFinderInfoMod              File’s finder metadata was modified
   ItemChangeOwner                Owner of file or directory has been changed.
   ItemXattrMod                   Extended attributes of file or directory modified
   ItemIsFile                     Item is a file
   ItemIsDir                      Item is a directory
   ItemIsSymlink                  Item is a symbolic link
   */
  
  //if the root changed, but the path is the same (which can happen if the parent attributes changed) - ignore. We don't care.
  
  char newPath[ MAXPATHLEN ];
  int rc;

  NSInteger fileDescriptor = [fileMonitor monitoredFileDescriptor];
  NSLog(@"file descriptor: %ld", (long)fileDescriptor);

  rc = fcntl((int)fileDescriptor, F_GETPATH, newPath );
  if ( rc == -1 ) {
    perror( "fnctl F_GETPATH" );
    return;
  }
  
  NSString *newPathString = [[NSString alloc] initWithUTF8String: newPath ];
  NSURL* newPathURL = [NSURL fileURLWithPath:[newPathString stringByExpandingTildeInPath]];
  //NSLog(@"new path: %@", newPathString);
  
  //kFSEventStreamEventFlagItemRenamed
  //kFSEventStreamEventFlagItemModified
  //kFSEventStreamEventFlagItemRemoved
  
  //NSMutableSet<NSNumber*>* operations = [[NSMutableSet<NSNumber*> alloc] init];
  
  for(int i = 0; i<numEvents; i++)
  {

    if (eventFlags[i] & kFSEventStreamEventFlagItemRenamed){
      NSLog(@"FileWatcher: rename or path change");
      [fileMonitor fileChangedForOperation:FileChangeOperationTypeRenameOrMove withOriginalPath:[fileMonitor filePath] andNewPath:newPathURL];
      break;
      //[operations addObject:@(FileChangeOperationTypeRenameOrMove)];
    } else if (eventFlags[i] & kFSEventStreamEventFlagItemModified){
      NSLog(@"FileWatcher: file contents modified");
      [fileMonitor fileChangedForOperation:FileChangeOperationTypeContentsChanged withOriginalPath:[fileMonitor filePath] andNewPath:newPathURL];
      break;
      //[operations addObject:@(FileChangeOperationTypeContentsChanged)];
      //[self fileChangedForOperation:FileChangeOperationTypeContentsChanged ]
    } else if(eventFlags[i] & kFSEventStreamEventFlagRootChanged){
      //for now we're ignoring these
      NSLog(@"FileWatcher: root changed");
      [fileMonitor fileChangedForOperation:FileChangeOperationTypeRenameOrMove withOriginalPath:[fileMonitor filePath] andNewPath:newPathURL];
      break;
    }
    /*
    if(eventFlags[i] & kFSEventStreamEventFlagItemIsFile)
    {
      NSLog(@"kFSEventStreamEventFlagItemIsFile");
      if(eventFlags[i]  & kFSEventStreamEventFlagKernelDropped)
      {
        NSLog(@"kFSEventStreamEventFlagKernelDropped");
      }
      if(eventFlags[i]  & kFSEventStreamEventFlagItemRemoved)
      {
        NSLog(@"kFSEventStreamEventFlagItemRemoved");
      }
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemRemoved){
      NSLog(@"kFSEventStreamEventFlagItemRemoved");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemIsDir){
      NSLog(@"kFSEventStreamEventFlagItemIsDir");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemIsSymlink){
      NSLog(@"kFSEventStreamEventFlagItemIsSymlink");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemIsHardlink){
      NSLog(@"kFSEventStreamEventFlagItemIsHardlink");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemInodeMetaMod){
      NSLog(@"kFSEventStreamEventFlagItemInodeMetaMod");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemCreated){
      NSLog(@"kFSEventStreamEventFlagItemCreated");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemRenamed){
      NSLog(@"kFSEventStreamEventFlagItemRenamed");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemModified){
      NSLog(@"kFSEventStreamEventFlagItemModified");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemXattrMod){
      NSLog(@"kFSEventStreamEventFlagItemXattrMod");
    } else if(eventFlags[i] & kFSEventStreamEventFlagItemFinderInfoMod){
      NSLog(@"kFSEventStreamEventFlagItemFinderInfoMod");
    } else if(eventFlags[i] & kFSEventStreamEventFlagUserDropped){
      NSLog(@"kFSEventStreamEventFlagUserDropped");
    } else if(eventFlags[i] & kFSEventStreamEventFlagKernelDropped){
      NSLog(@"kFSEventStreamEventFlagKernelDropped");
    } else {
      NSLog(@"no file event found");
    }
    */

    //RootChanged - need to figure out how we're handling this w/ TextEdit's behavior
    
//    printf("numEvents : %u\n", (int)numEvents ) ;
//    printf("%u\n", i ) ;
//    printf("\tpath %s\n", pathsList[i]) ;//new name?
//    printf("\tflags: ") ;
    /*
    long bit = 1 ;
    for( int index=0, count = sizeof( flags ) / sizeof( flags[0]); index < count; ++index )
    {
      if ( ( eventFlags[i] & bit ) != 0 )
      {
        //printf("flag found: %d \n", index ) ;
        printf("%s ", flags[ index ] ) ;
      } else {
        //  printf("flag not found: %d \n", index ) ;
      }
      bit <<= 1 ;
    }
     */
//    printf("\n") ;
    
  }
  
  //FSEventStreamFlushSync( stream ) ;
  
  /*
  char** ppPaths = (char**)pEventPaths; int i;
  
  for (i = 0; i < numEvents; i++)
  {
    NSLog(@"Event Flags %u Event Id %llu", (unsigned int)eventFlags[i], eventIds[i]);
    NSLog(@"Path changed: %@",
          [NSString stringWithUTF8String:ppPaths[i]]);
  }
   */
}

//MARK: GCD

-(void)startMonitoringWithGCD
{
  if([self filePath] != nil && _fileMonitorSource == nil ) {
    //&& _monitoredFileDescriptor == -1
    
    const char *c = [[[self filePath] path] UTF8String];
//    _monitoredFileDescriptor= open(c , O_RDONLY);
//    _monitoredFileDescriptor= open(c , O_EVTONLY);
    
    //with polling
    //http://www.davidhamrick.com/2011/10/09/kqueue-in-cocoa.html
    
    //FSEvents - stream
    //https://stackoverflow.com/questions/7095985/changing-the-pathstowatch-in-fsevents
    //https://stackoverflow.com/questions/5799003/is-it-possible-to-use-fsevents-to-get-notifications-that-a-folder-has-been-moved?rq=1
    //https://stackoverflow.com/questions/7095985/changing-the-pathstowatch-in-fsevents
    //https://developer.apple.com/library/content/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html#//apple_ref/doc/uid/TP40005289-CH4-SW4
    // Parent paths monitored -
    // https://developer.apple.com/documentation/coreservices/kfseventstreamcreateflagwatchroot
    // 10.11 changes - https://developer.apple.com/library/content/releasenotes/General/APIDiffsMacOSX10_11/Objective-C/CoreServices.html
    // https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/OSX_Technology_Overview/SystemFrameworks/SystemFrameworks.html
    // https://stackoverflow.com/questions/12413804/fsevents-daemon-vs-fsevents-api
    // what's broken pre- 10.11 - https://stackoverflow.com/questions/6841010/fsevents-mysteriously-fails-to-deliver-events-in-some-folders
    
    //edits that surface as deletes
    //http://www.davidhamrick.com/2011/10/13/Monitoring-Files-With-GCD-Being-Edited-With-A-Text-Editor.html
    
    //http://www.mlsite.net/blog/?p=2655
    //http://www.duanqu.tech/questions/2203603/how-do-i-watch-for-file-changes-on-os-x
    //https://github.com/rustle/XcodersGCD/blob/master/XcodersGCD/RSTLFileMonitor.m
    //https://stackoverflow.com/questions/7748725/grand-central-dispatch-gcd-dispatch-source-flags
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

//    _fileMonitorSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,_monitoredFileDescriptor,
//                                    DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE,
//                                    _queue);

    _fileMonitorSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,_monitoredFileDescriptor,
                                                DISPATCH_VNODE_DELETE,// | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_ATTRIB
                                                _queue);

    if(_fileMonitorSource)
    {
      // Copy the filename for later use.
      NSInteger length = strlen(c);
      char* newString = (char*)malloc(length + 1);
      newString = strcpy(newString, c);
      dispatch_set_context(_fileMonitorSource, newString);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      //NSLog(@"Starting file monitor at - %@", [[self filePath] path]);
    });
    
    //do we want our own queue?
    dispatch_source_set_event_handler(_fileMonitorSource, ^
      {
        //notify or whatever we need to do...
        unsigned long flags = dispatch_source_get_data(_fileMonitorSource);
        if(flags & DISPATCH_VNODE_DELETE)
        {
          //dispatch_source_cancel(fileMonitorSource);
          //NSLog(@"DISPATCH_VNODE_DELETE");
          dispatch_async(dispatch_get_main_queue(), ^{

            //NSDictionary *fileInfo = @{@"originalFilePath":[[self filePath] path]};
            //NSLog(@"file deleted - %@", [[self filePath] path]);

            [self fileChangedForOperation:FileChangeOperationTypeDelete withOriginalPath:[self filePath] andNewPath:nil];

            
          //[[NSNotificationCenter defaultCenter] postNotificationName:@"codeFileDeleted" object:self userInfo:fileInfo];
          });

          //NOTE some apps delete and recreate the file on save!
          //http://www.davidhamrick.com/2011/10/13/Monitoring-Files-With-GCD-Being-Edited-With-A-Text-Editor.html
          
          //dispatch_source_cancel(fileMonitorSource);

          
        } else if (flags & DISPATCH_VNODE_WRITE) {
          //NSLog(@"DISPATCH_VNODE_WRITE");
          dispatch_async(dispatch_get_main_queue(), ^{
            //[self fileChangedForOperation:FileChangeOperationTypeContentsChanged withOriginalPath:[self filePath] andNewPath:nil];
            
            //NSLog(@"DISPATCH_VNODE_WRITE - %@", [[self filePath] path]);
//            NSDictionary *fileInfo = @{@"originalFilePath":[[self filePath] path]};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"codeFileEdited" object:self userInfo:fileInfo];
          });
        } else if (flags & DISPATCH_VNODE_EXTEND) {
          //changed in size - likely due to write activity
          dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"DISPATCH_VNODE_EXTEND - %@", [[self filePath] path]);
          });
        } else if (flags & DISPATCH_VNODE_ATTRIB) {
          dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"DISPATCH_VNODE_ATTRIB - %@", [[self filePath] path]);
          });
        } else if (flags & DISPATCH_VNODE_LINK) {
          dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"DISPATCH_VNODE_LINK - %@", [[self filePath] path]);
          });
        } else if (flags & DISPATCH_VNODE_RENAME) {
          //this also does file moves (path was "renamed" for file descriptor)
          
          //https://developer.apple.com/library/content/documentation/General/Conceptual/ConcurrencyProgrammingGuide/GCDWorkQueues/GCDWorkQueues.html
          //old file name we stored in the context
          //const char*  oldFilename = (char*)dispatch_get_context(fileMonitorSource);

          
          //FILE *file = fdopen([filehandle fileDescriptor], "r");
          
          //NSFileHandle* fn = [[NSFileHandle alloc] initWithFileDescriptor:monitoredFileDescriptor];
          dispatch_async(dispatch_get_main_queue(), ^{
            
            char* originalPath = (char*)dispatch_get_context(_fileMonitorSource);
            //NSLog(@"original file path : %@", [NSString stringWithUTF8String:originalPath]);

            char newPath[MAXPATHLEN];
            NSString* newFilePath;
            //NSLog(@"file descriptor: %ld", (long)_monitoredFileDescriptor);
            if (fcntl(_monitoredFileDescriptor, F_GETPATH, newPath) != -1)
            {
              newFilePath = [NSString stringWithUTF8String:newPath];
            }

//            NSDictionary *fileInfo = @{@"originalFilePath":@(originalPath),
//                                       @"newFilePath":newFilePath};
//            [self setFilePath:[NSURL URLWithString:newFilePath]];
//            NSLog(@"file renamed from '%@' to '%@'", @(originalPath), newFilePath);

//            //broadcast the file rename
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"codeFileRenamed" object:self userInfo:fileInfo];

            //store the updated path as our path
            NSInteger length = strlen(newPath);
            char* newString = (char*)malloc(length + 1);
            newString = strcpy(newString, newPath);
            dispatch_set_context(_fileMonitorSource, newString);
            
            free(originalPath);
            //free(newPath);
          });
          
          //NSLog(@"DISPATCH_VNODE_RENAME");
        } else if (flags & DISPATCH_VNODE_REVOKE) {
          dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"DISPATCH_VNODE_REVOKE - %@", [[self filePath] path]);
          });
        }
      });
    dispatch_source_set_cancel_handler(_fileMonitorSource, ^
      {
        //NSLog(@"cancel");
        //char* fileStr = (char*)dispatch_get_context(fileMonitorSource);
        //free(fileStr);
        close(_monitoredFileDescriptor);
        _monitoredFileDescriptor = -1;
        _fileMonitorSource = nil;
       });
    dispatch_resume(_fileMonitorSource);
    
    
    // sometime later
    
  }

  
}

-(void)stopMonitoringWithGCD
{
  if(_fileMonitorSource != nil)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      //NSLog(@"Stopping file monitor at - %@", [[self filePath] path]);
    });

    dispatch_source_cancel(_fileMonitorSource);
  }
}




@end
