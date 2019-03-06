//
//  AboutViewController.h
//  StatTag
//
//  Created by Eric Whitley on 3/29/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConfigInfoViewController.h"

@interface AboutViewController : NSViewController


@property (weak) IBOutlet NSTextField *statTagLinkField;

@property (weak) IBOutlet NSTextField *gitHubLinkField;

@property (weak) IBOutlet NSTextField *buildTextField;


@property (unsafe_unretained) IBOutlet NSTextView *aboutTextView;

@property (weak) IBOutlet NSTextField *citationLabel;

@property (unsafe_unretained) IBOutlet NSTextView *acknoweldgementsTextView;

@property (strong) IBOutlet ConfigInfoViewController *systemInfoViewController;
@property (weak) IBOutlet NSView *systemInfoView;




@end
