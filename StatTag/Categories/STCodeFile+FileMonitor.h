//
//  STCodeFile+FileMonitor.h
//  StatTag
//
//  Created by Eric Whitley on 10/18/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STCodeFile.h"

@class FileMonitor;

@interface STCodeFile (FileMonitor)

@property (strong, nonatomic) FileMonitor* fileMonitor;



@end
