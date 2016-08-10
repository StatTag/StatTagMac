//
//  STManageCodeFilesController.m
//  StatTag
//
//  Created by Eric Whitley on 8/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STManageCodeFilesController.h"

@interface STManageCodeFilesController ()

@end

@implementation STManageCodeFilesController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


- (void)windowWillClose:(NSNotification *)notification {
  [[NSApplication sharedApplication] stopModal];
}


@end
