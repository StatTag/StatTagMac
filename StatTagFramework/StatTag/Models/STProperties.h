//
//  STProperties.h
//  StatTag
//
//  Created by Eric Whitley on 7/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  User preferences and settings for StatTag.
 */
@interface STProperties : NSObject {
  NSString* _StataLocation;
  BOOL _EnableLogging;
  NSString* _LogLocation;
}

@property (copy, nonatomic) NSString* StataLocation;
@property (nonatomic) BOOL EnableLogging;
@property (copy, nonatomic) NSString* LogLocation;


@end
