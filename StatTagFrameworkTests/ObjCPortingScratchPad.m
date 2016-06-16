//
//  ObjCPortingScratchPad.m
//  StatTag
//
//  Created by Eric Whitley on 6/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "ObjCPortingScratchPad.h"

@implementation ObjCPortingScratchPad

static NSString *myVar;
+ (NSString *)myVar { return myVar; }
+ (void)setMyVar:(NSString *)newVar { myVar = newVar; }

@end


@implementation ObjCPortingScratchPadSubclass

@end