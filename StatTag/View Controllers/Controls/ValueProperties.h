//
//  ValueProperties.h
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DisclosureViewController.h"

//protocol for interacting with this control
@class ValueProperties;
@protocol ValuePropertiesDelegate <NSObject>
- (void)valueTypeDidChange:(ValueProperties*)controller;
@end


@interface ValueProperties : DisclosureViewController


//containing stackview
@property (weak) IBOutlet NSStackView *stackView;

//buttons

@property (weak) IBOutlet NSButton *buttonDefault;
@property (weak) IBOutlet NSTextField *labelDefault;

@property (weak) IBOutlet NSButton *buttonPercentage;

@property (weak) IBOutlet NSButton *buttonDateTime;

@property (weak) IBOutlet NSButton *buttonNumeric;

@property (nonatomic, weak) id<ValuePropertiesDelegate> delegate;


@end
