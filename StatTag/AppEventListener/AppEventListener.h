//
//  AppEventListener.h
//  StatTag
//
//  Created by Eric Whitley on 10/7/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppEventListener : NSObject


+(void)startListening;
+(void)stopListening;

+(BOOL)wordIsOK;
+(void)updateWordViewController;

@end
