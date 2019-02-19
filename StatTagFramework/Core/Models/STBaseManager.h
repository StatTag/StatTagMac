//
//  STBaseManager.h
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLogManager.h"

@class STLogManager;

@interface STBaseManager : NSObject {
  STLogManager* _Logger;
}

@property (strong, nonatomic) STLogManager* Logger;

-(instancetype)init;

/**
 Wrapper around a LogManager instance.  Since logging is not always enabled/available for this object
 the wrapper only writes if a logger is accessible.
 */
-(void)Log:(id)logMessage;
-(void)Log:(id)logMessage logLevel:(STLogLevel)logLevel;

/**
 Wrapper around a LogManager instance.  Since logging is not always enabled/available for this object
 the wrapper only writes if a logger is accessible.
 */
-(void)LogException:(id)logMessage;


@end
