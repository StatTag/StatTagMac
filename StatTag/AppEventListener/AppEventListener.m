//
//  AppEventListener.m
//  StatTag
//
//  Created by Eric Whitley on 10/7/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

// reference : https://developer.apple.com/library/content/technotes/tn2050/_index.html


#import "AppEventListener.h"

#import "StatTagShared.h"
#import "STGlobals.h"
#import "STThisAddIn.h"
#import "STMSWord2011.h"
#import "AppDelegate.h"
#import "StatTag.h"
#import "ManageCodeFilesViewController.h"

@implementation AppEventListener

+(void)startListening
{
  NSNotificationCenter *  center;
  
  NSLog(@"-[AppDelegate testNSWorkspace:]");
  
  // Get the custom notification center.
  
  center = [[NSWorkspace sharedWorkspace] notificationCenter];
  
  // Install the notifications.
  
  [center addObserver:self
             selector:@selector(appLaunched:)
                 name:NSWorkspaceDidLaunchApplicationNotification
               object:nil
   ];
  [center addObserver:self
             selector:@selector(appTerminated:)
                 name:NSWorkspaceDidTerminateApplicationNotification
               object:nil
   ];

  
//  [self listenForWord];
  //http://stackoverflow.com/questions/8812951/pumping-cocoa-message-loop-from-background-thread
//  [NSThread detachNewThreadSelector:@selector(listenForWord)
//                           toTarget:self
//                         withObject:nil];
  // Execution continues in -appLaunched: and -appTerminated:, below.
  
//  dispatch_queue_t bgQueue = dispatch_queue_create("bgQueue", NULL);
//  dispatch_async(bgQueue, ^{
//    while (1) {
//      [self updateWordViewController];
//      [NSThread sleepForTimeInterval:3.0f];
//    }
//  });
  
}

+(void)stopListening
{
  NSNotificationCenter* center = [[NSWorkspace sharedWorkspace] notificationCenter];

  [center removeObserver:self
                    name:NSWorkspaceDidLaunchApplicationNotification
                  object:nil];
  
  [center removeObserver:self
                 name:NSWorkspaceDidTerminateApplicationNotification
               object:nil];
  
}

+ (void)appLaunched:(NSNotification *)note
{
  NSLog(@"launched %@\n", [[note userInfo] objectForKey:@"NSApplicationName"]);
  NSLog(@"launched %@\n", [[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"]);
  
  //start polling our document status (no other way to do this...)
}

+ (void)appTerminated:(NSNotification *)note
{
  NSLog(@"terminated %@\n", [[note userInfo] objectForKey:@"NSApplicationName"]);
  NSLog(@"terminated %@\n", [[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"]);

//  +(NSArray<NSString*>*) ProcessNames {
//    return [NSArray arrayWithObjects:
//            @"com.microsoft.Word",
//            nil];
//  }
  //[[[STGlobals sharedInstance] ThisAddIn] ProcessNames];
  
  //[self willChangeValueForKey:@"StatTagShared.sharedInstance.wordAppStatusMessage"];
  [[StatTagShared sharedInstance] setWordAppStatusMessage:[[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"]];
  //[self didChangeValueForKey:@"StatTagShared.sharedInstance.wordAppStatusMessage"];
  
  NSString* bundleID = [[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"];
  if([[STThisAddIn ProcessNames] containsObject:bundleID]) {
    //Word did something
    NSLog(@"Caught Word Exit");
  }
  
  //BOOL ok = [self wordIsOK];
  [self updateWordViewController];
  //stop polling our document status

}

+(void)updateWordViewController {

    NSWindow* window = [[[NSApplication sharedApplication] windows] firstObject];
    StatTagShared* shared = [StatTagShared sharedInstance];
    
    if([AppEventListener wordIsOK]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [[shared docManager] LoadCodeFileListFromDocument:[shared doc]];
        shared.codeFilesViewController.codeFiles = [[shared docManager] GetCodeFileList]; //just for setup
        [[window windowController] setContentViewController:shared.mainVC ];
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [[window windowController] setContentViewController:shared.needsWordController ];
      });
    }

}

+(void)startPolling {
  [self listenForWord];
}

+(void)listenForWord {
  
//  while (1) {
//    [self updateWordViewController];
//    [NSThread sleepForTimeInterval:3.0f];
//  }

  NSRunLoop *threadRunLoop = [NSRunLoop currentRunLoop];
  while (1 && [threadRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:3]]) {
    [self updateWordViewController];
  }
}

+(void)stopPolling {
  
}

+(void)documentActivated:(NSNotification*)note
{
  
}

+(void)documentDeactivated:(NSNotification*)note
{
  
}

+(BOOL)wordIsOK {
  
  BOOL ok = NO;
  
  if([STThisAddIn IsAppInstalled]) {
    if([STThisAddIn IsAppRunning]) {
      NSInteger numDocs = [[[[[STGlobals sharedInstance] ThisAddIn] Application] documents] count];
      STMSWord2011Document* doc = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
      if(numDocs > 0 && doc != nil && [doc name] != nil) {
        [[StatTagShared sharedInstance] setWordAppStatusMessage:@""];
        ok = YES;
      } else {
        [[StatTagShared sharedInstance] setWordAppStatusMessage:@"Please open a document from within Microsoft Word"];
      }
    } else {
      [[StatTagShared sharedInstance] setWordAppStatusMessage:@"StatTag requires Microsoft Word to be running"];
    }
  } else {
    [[StatTagShared sharedInstance] setWordAppStatusMessage:@"StatTag requires Microsoft Word for macOS"];
  }
  
  return ok;
}


@end
