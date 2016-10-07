//
//  StatTagNeedsWordViewController.h
//  StatTag
//
//  Created by Eric Whitley on 10/7/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class StatTagShared;

@interface StatTagNeedsWordViewController : NSViewController


@property (weak) IBOutlet NSImageView *statTagLogoImage;

@property (weak) IBOutlet NSTextField *topText;
@property (weak) IBOutlet NSTextField *middleText;
@property (weak) IBOutlet NSTextField *statusMessage;

@property (weak, nonatomic) StatTagShared* statTagShared;
@property (strong, nonatomic) NSString* statusMessageText;


@end
