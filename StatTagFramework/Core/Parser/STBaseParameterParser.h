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
  NSMutableDictionary<NSString*,NSRegularExpression*>* _RegexCache;
}

+(NSString *)StringValueMatch;
+(NSString *)IntValueMatch;
+(NSString *)BoolValueMatch;

@property NSMutableDictionary<NSString*,NSRegularExpression*>* RegexCache;

+ (instancetype)sharedInstance;

+(void)Parse:(NSString*)tagText Tag:(STTag*)tag;

+(NSRegularExpression*) BuildRegex:(NSString*)name valueMatch:(NSString*)valueMatch  isQuoted:(BOOL)isQuoted;

+(NSString*)GetParameter:(NSString*) name valueMatch:(NSString*)valueMatch text:(NSString*)text defaultValue:(NSString*)defaultValue quoted:(BOOL)quoted;
+(NSString*)GetParameter:(NSString*) name valueMatch:(NSString*)valueMatch text:(NSString*)text defaultValue:(NSString*)defaultValue;
+(NSString*)GetParameter:(NSString*) name valueMatch:(NSString*)valueMatch text:(NSString*)text;

+(NSString*)GetStringParameter:(NSString*)name text:(NSString*)text defaultValue:(NSString*)defaultValue quoted:(BOOL)quoted;
+(NSString*)GetStringParameter:(NSString*)name text:(NSString*)text defaultValue:(NSString*)defaultValue;
+(NSString*)GetStringParameter:(NSString*)name text:(NSString*)text;

+(NSNumber*) GetIntParameter:(NSString*)name text:(NSString*)text defaultValue:(NSNumber*)defaultValue;
+(NSNumber*) GetIntParameter:(NSString*)name text:(NSString*)text;

+(BOOL) GetBoolParameter:(NSString*)name text:(NSString*)text defaultValue:(BOOL)defaultValue;
+(BOOL) GetBoolParameter:(NSString*)name text:(NSString*)text;



@end
