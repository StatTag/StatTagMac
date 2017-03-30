//
//  UIUtility.h
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STIResultCommandList;
@class STCodeFile;

@interface UIUtility : NSObject

+(NSObject<STIResultCommandList>*)GetResultCommandList:(STCodeFile*)file resultType:(NSString*)resultType;

+(void)setHyperlink:(NSURL*)url withTitle:(NSString*)title inTextField:(NSTextField*)inTextField;

@end
