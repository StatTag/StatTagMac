//
//  STCodeFile+FileMonitor.m
//  StatTag
//
//  Created by Eric Whitley on 10/18/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

// property extensions
//http://stackoverflow.com/questions/8733104/objective-c-property-instance-variable-in-category

#import "STCodeFile+FileMonitor.h"
#import "FileMonitor.h"

#import <objc/runtime.h>

static void *FileMonitorPropertyKey = &FileMonitorPropertyKey;
//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOBasics.html

@implementation STCodeFile (FileMonitor)

-(FileMonitor*)fileMonitor {
  NSLog(@"getting file monitor");
  FileMonitor* f = objc_getAssociatedObject(self, FileMonitorPropertyKey);
  if(f == nil) {
    //in case we don't have our file monitor initialized
    f = [[FileMonitor alloc] init];
    //FIXME: we need to see about looking at file path changes
    [f setFilePath:[self FilePathURL]];
    [self setFileMonitor:f];
    //[f observeChangesForObject:self withKeyPath:NSStringFromSelector(@selector(FilePath))];
  }

  return objc_getAssociatedObject(self, FileMonitorPropertyKey);
}

- (void)setFileMonitor:(FileMonitor *)fileMonitor {
  NSLog(@"setting file monitor");

  objc_setAssociatedObject(self, FileMonitorPropertyKey, fileMonitor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
