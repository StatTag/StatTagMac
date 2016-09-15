//
//  STAppleScript_DummyUI.m
//  StatTag
//
//  Created by Eric Whitley on 8/17/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STAppleScript_DummyUI.h"
#import "StatTag.h"
#import "STWindowLauncher.h"
#import "STUpdateOutputController.h"

@implementation STAppleScript_DummyUI

STUpdateOutputController* updateOutputController;


-(id)performDefaultImplementation {
  
  if(updateOutputController == nil)
    updateOutputController = [[STUpdateOutputController alloc] initWithWindowNibName:@"STUpdateOutputController"];
  
  [updateOutputController showWindow:self];
  
  //NSString* result = [STWindowLauncher openUpdateOutput];
  return [NSNumber numberWithBool:YES];
}

@end
