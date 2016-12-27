//
//  FileMonitor.h
//  StatTag
//
//  Created by Eric Whitley on 10/18/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileMonitor : NSObject {
  dispatch_source_t fileSource;
  NSInteger monitoredFileDescriptor;
}

@property (copy, nonatomic) NSURL* filePath;

-(void)startMonitoring;
-(void)stopMonitoring;

@end
