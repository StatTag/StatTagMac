//
//  STUIUtility.h
//  StatTag
//
//  Created by Eric Whitley on 7/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STLogManager;

@interface STUIUtility : NSObject

+(void)WarningMessageBoxWithTitle:(NSString*)title andDetail:(NSString*)detail logger:(STLogManager*)logger;
+(void)ReportException:(NSException*)exc userMessage:(NSString*)userMessage logger:(STLogManager*)logger;

@end
