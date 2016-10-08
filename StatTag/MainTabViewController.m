//
//  mainTabViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
  
  NSLog(@"mainTabViewController loaded");
  
}

-(void)viewWillAppear {
  NSLog(@"tab view - viewWillAppear");
}



/*
 - (void)awakeFromNib {
 NSLog(@"tab view - awake From Nib");
 }
 


//- (NSString *)nibName
//{
//  return @"MainTabViewController";
//}

-(id) init {
  NSLog(@"tab view - init");
  self = [super init];
  return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  NSLog(@"tab view - initWithNibName");
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  return self;
}

//restoring at runtime with storyboards
*/

//-(void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabView {
//}

@end
