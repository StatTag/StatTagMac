//
//  SamplesInstallerViewController.h
//  StatTag
//
//  Created by Eric Whitley on 5/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SamplesInstallerViewController : NSViewController
  @property (weak) IBOutlet NSPopUpButton *downloadPathPopUp;
  @property (weak) IBOutlet NSButton *startDownloadButton;

  @property (strong, nonatomic) NSURL* fileSourceURI;
  @property (strong, nonatomic) NSURL* defaultDownloadFolderURI;
  
@end
