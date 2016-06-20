//
//  STJSONUtility.h
//  StatTag
//
//  Created by Eric Whitley on 6/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STJSONUtility : NSObject

+ (NSDate*)dateFromString:(NSString*)dateString;
+ (NSString*)convertDateToDateString:(NSDate*)date;

@end
