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

@interface STDocumentManager (FileMonitor)


-(void)startMonitoringCodeFiles;
-(void)stopMonitoringCodeFiles;


@end
