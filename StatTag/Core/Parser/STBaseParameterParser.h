//
//  STBaseParameterParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/15/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTag.h"

@interface STBaseParameterParser : NSObject {
}

+(NSString *)StringValueMatch;
+(NSString *)IntValueMatch;
+(NSString *)BoolValueMatch;


//+(NSMutableDictionary<NSString*,NSRegularExpression*>*)RegexCache;
//+(void)setRegexCache:(NSMutableDictionary<NSString*,NSRegularExpression*>*)cache;
+ (instancetype)sharedInstance;


@end
