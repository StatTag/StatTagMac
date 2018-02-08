//
//  STGeneralUtil.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STGeneralUtil : NSObject

/**
 Convert a string array to an object array to avoid potential issues (per ReSharper).
 
 @remark The objective-c version of this method is NOT really doing anything. It's in here to maintain parity w/ the c# so it might minimize impact during initial porting.
 
 @param data The string array to convert
 @Nil if the string array is null, otherwise an object-cast array representation of the original string array.
 */
+(NSArray*)StringArrayToObjectArray:(NSArray<NSString*>*) data;
+(BOOL)IsStringNullOrEmpty:(NSString*)str;

@end
