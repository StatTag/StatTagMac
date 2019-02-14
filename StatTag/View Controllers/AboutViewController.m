//
//  AboutViewController.m
//  StatTag
//
//  Created by Eric Whitley on 3/29/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "AboutViewController.h"
#import "UIUtility.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
  [UIUtility setHyperlink:[NSURL URLWithString:@"https://github.com/stattag"] withTitle:@"GitHub" inTextField:[self gitHubLinkField]];
  [UIUtility setHyperlink:[NSURL URLWithString:@"http://stattag.org"] withTitle:@"StatTag.org" inTextField:[self statTagLinkField]];

  NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
  
  NSString* buildInfo = [NSString stringWithFormat:@"%@ (%@)", appVersionString, appBuildString];
  [[self buildTextField] setStringValue:buildInfo];
}

- (NSString *)nibName
{
  return @"AboutViewController";
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
