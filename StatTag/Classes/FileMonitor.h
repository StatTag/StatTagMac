//
//  FileMonitor.h
//  StatTag
//
//  Created by Eric Whitley on 10/18/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileMonitor;
@protocol FileMonitorDelegate <NSObject>
-(void)fileDidChange:(NSDictionary*)fileInfo;
@end

typedef enum {
  FileChangeOperationTypeRenameOrMove = 1,
  FileChangeOperationTypeContentsChanged = 2,
  FileChangeOperationTypeDelete = 3
} FileChangeOperationType;

@interface FileMonitor : NSObject {
  dispatch_source_t _fileSource;
  NSInteger _monitoredFileDescriptor;
  dispatch_queue_t _queue;
  dispatch_source_t _fileMonitorSource;
  NSURL* _lastOriginalPath;
  NSURL* _lastNewPath;
  NSString* _observedKeyPath;
  BOOL _isMonitoring;
}

@property (copy, nonatomic) NSURL* filePath;
@property (nonatomic, weak) id<FileMonitorDelegate> delegate;
@property (weak, nonatomic) id observedObject;
@property (readonly) NSInteger monitoredFileDescriptor;
@property (readonly) BOOL isMonitoring;

-(void)restartMonitor;
-(void)startMonitoring;
-(void)stopMonitoring;

-(void)fileChangedForOperation:(FileChangeOperationType)operation withOriginalPath:(NSURL*)originalFilePath andNewPath:(NSURL*)newPath;

//-(void)observeChangesForObject:(id)object withKeyPath:(NSString*)keypath;

@end
