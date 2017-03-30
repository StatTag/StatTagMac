//
//  UnlinkedTagsViewController.m
//  StatTag
//
//  Created by Eric Whitley on 3/30/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "UnlinkedTagsViewController.h"

@interface UnlinkedTagsViewController ()

@end

@implementation UnlinkedTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSString *)nibName
{
  return @"UnlinkedTagsViewController";
}

//restoring at runtime with storyboards
-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}


@end
