//
//  WordHelpers.m
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>
#import "WordFind.h"

@implementation WordFind

-(NSNumber *)square:(NSNumber *)aNumber {
  _scriptFile = nil;
  _scriptFile = NSClassFromString(@"WordFindScript");
  
  NSNumber* squared = [_scriptFile square:@3];
  NSLog(@"Result: %@", squared);
  return squared;

}

@end