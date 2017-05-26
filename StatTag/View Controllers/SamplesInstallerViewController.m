//
//  SamplesInstallerViewController.m
//  StatTag
//
//  Created by Eric Whitley on 5/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "SamplesInstallerViewController.h"

@interface SamplesInstallerViewController ()

@end

@implementation SamplesInstallerViewController

  
  
//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"SamplesInstallerViewController";
}
  
-(id)init {
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  [self setup];
  return self;
}
  
-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  [self setup];
  return self;
}

-(void)setup
{
  //if([self defaultDownloadFolderURI] == nil)
  //{
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    _defaultDownloadFolderURI = [[NSURL alloc] initWithString:[dirs firstObject]];
  //}
  //if([self fileSourceURI] == nil)
  //{
    _fileSourceURI = [[NSURL alloc] initWithString:@"https://github.com/StatTag/Simple-Code-Examples/archive/master.zip"];
  //}
  
  NSMenuItem* item = [[[self downloadPathPopUp] menu] itemWithTag:1];
  //fix our download folder icon
  NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kToolbarDownloadsFolderIcon)];
  [item setImage:icon];
  
  //apple restricted icons located at
  // /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources
  // you can't really use these
  
  //[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kToolbarDownloadsFolderIcon)];
  
  //gray toolbar icon from the finder left toolbar pane (NOT a folder)
  //[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kToolbarDownloadsFolderIcon)];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewDidAppear
{
}
  
- (IBAction)startDownload:(id)sender {
  
  //https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/OSXHIGuidelines/SystemProvided.html
    
}

- (IBAction)downloadPathPopUpChanged:(id)sender {
}
  
  
@end
