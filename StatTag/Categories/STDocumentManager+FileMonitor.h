//
//  STDocumentManager+FileMonitor.h
//  StatTag
//
//  Created by Eric Whitley on 10/18/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDocumentManager.h"

@class FileMonitor;

@interface FileChangeNotificationData : NSObject

@property (copy, nonatomic) NSString* _Nonnull filePath;

@property (readonly) BOOL fileModified;
@property (readonly) BOOL fileMoved;
@property (readonly) BOOL fileDeleted;

@property (readonly, copy, nonatomic) NSDictionary* _Nullable FileModifiedInformation;
@property (readonly, copy, nonatomic) NSDictionary* _Nullable FileMovedInformation;
@property (readonly, copy, nonatomic) NSDictionary* _Nullable FileDeletedInformation;

-(void)setNotificationData:(NSDictionary*_Nullable)d;

@end

@interface STDocumentManager (FileMonitor) <FileMonitorDelegate>


-(void)startMonitoringCodeFiles;
-(void)stopMonitoringCodeFiles;
-(void)monitorCodeFile:(STCodeFile*_Nullable)file;
-(void)stopMonitoringCodeFile:(STCodeFile*_Nullable)file;


-(void)fileDidChange:(NSDictionary*_Nullable)fileInfo;
-(NSDictionary<NSString*, FileChangeNotificationData*>*_Nonnull)getPrioritizedFileNotifications;
-(void)clearNotifications;

@property (strong, nonatomic) NSMutableArray<NSDictionary*>* _Nonnull fileNotifications;
@property (strong, nonatomic) NSMutableArray<FileMonitor*>* _Nonnull fileMonitors;


@end
