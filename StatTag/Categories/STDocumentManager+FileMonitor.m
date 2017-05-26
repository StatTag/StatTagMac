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

@implementation STDocumentManager (FileMonitor)


-(void)startMonitoringCodeFiles
{
  [self stopMonitoringCodeFiles];
  for(STCodeFile* cf in [self GetCodeFileList]) {
    FileMonitor* fm = [[FileMonitor alloc] init];
    [fm setFilePath:[cf FilePathURL]];
    [fm startMonitoring];
    [[[StatTagShared sharedInstance] fileMonitors] addObject:fm];
  }
}

-(void)stopMonitoringCodeFiles
{
  //turn off our monitoring - the other view must manage it
  for(FileMonitor* fm in [[StatTagShared sharedInstance] fileMonitors])
  {
    [fm stopMonitoring];
  }
  [[[StatTagShared sharedInstance] fileMonitors] setArray:[[NSMutableArray<FileMonitor*> alloc] init]];
}


@end
