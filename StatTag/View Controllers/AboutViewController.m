//
//  AboutViewController.m
//  StatTag
//
//  Created by Eric Whitley on 3/29/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "AboutViewController.h"
#import "UIUtility.h"
#import "ViewUtils.h"

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
  
  
  [[[self aboutTextView] textStorage] setAttributedString: [self readAttributedStringFromBundleFile:@"StatTag_About"]];
  [[[self acknoweldgementsTextView] textStorage] setAttributedString: [self readAttributedStringFromBundleFile:@"StatTag_Acknowledgements"]];
  [[self citationLabel] setAttributedStringValue: [self readAttributedStringFromBundleFile:@"StatTag_Citation"]];

}

-(void)viewWillAppear {
  [ViewUtils fillView:[self systemInfoView] withView:[[self systemInfoViewController] view]];
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

- (IBAction)copyCitationToClipboard:(id)sender {
  NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
  [pasteboard clearContents];
  [pasteboard writeObjects:@[[[self citationLabel] stringValue]]];
}


-(NSAttributedString*)readAttributedStringFromBundleFile:(NSString*)fileName
{
  NSAttributedString* content;
  if(fileName != nil)
  {
    NSData *data;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"rtf"];
    data = [NSData dataWithContentsOfFile:filePath];
    if (data)
    {
      content = [[NSAttributedString alloc] initWithRTF:data documentAttributes:nil];
    }
  }
  return content;
}


@end
