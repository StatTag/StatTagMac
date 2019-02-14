//
//  ConfigInfoViewController.m
//  StatTag
//
//  Created by Eric Whitley on 2/14/19.
//  Copyright © 2019 StatTag. All rights reserved.
//

#import "ConfigInfoViewController.h"

#import "StatTagFramework.h"
#import "StatTagShared.h"


@interface ConfigInfoViewController ()

@end

@implementation ConfigInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidAppear {
  //
  [[[self configInfoTextView] textStorage] setAttributedString:[STCocoaUtil getAssociatedAppInfoAttributedString]];
}

@end
