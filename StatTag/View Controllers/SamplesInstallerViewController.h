//
//  SamplesInstallerViewController.h
//  StatTag
//
//  Created by Eric Whitley on 5/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SamplesDownloadProgressViewController.h"

@interface SamplesInstallerViewController : NSViewController <SamplesDownloadProgressDelegate> {
}

  @property (weak) IBOutlet NSButton *startDownloadButton;

  @property (strong, nonatomic) NSURL* fileSourceURI;
  @property (strong, nonatomic) NSURL* defaultDownloadFolderURI;


@property (weak) IBOutlet NSTextField *downloadPathTextField;

@property (strong, nonatomic) SamplesDownloadProgressViewController* downloadProgressViewConroller;

@end
