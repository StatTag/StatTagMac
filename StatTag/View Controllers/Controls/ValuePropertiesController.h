//
//  ValueProperties.h
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DisclosureViewController.h"

#import "NumericValuePropertiesController.h"
#import "PercentagePropertiesController.h"

//protocol for interacting with this control
@class ValuePropertiesController;
@protocol ValuePropertiesControllerDelegate <NSObject>
- (void)valueTypeDidChange:(ValuePropertiesController*)controller;
@end


@class STTag;

@interface ValuePropertiesController : NSViewController <NumericValuePropertiesControllerDelegate, PercentagePropertiesControllerDelegate>

@property (strong) STTag* tag;


@property (strong) IBOutlet NSArrayController *tagValueTypeArrayController;


//containing stackview
@property (weak) IBOutlet NSStackView *stackView;

//dropdown
@property (weak) IBOutlet NSPopUpButton *listTagValueType;


//radio buttons
@property (weak) IBOutlet NSButton *buttonDefault;
@property (weak) IBOutlet NSTextField *labelDefault;
@property (weak) IBOutlet NSButton *buttonPercentage;
@property (weak) IBOutlet NSButton *buttonDateTime;
@property (weak) IBOutlet NSButton *buttonNumeric;

@property (nonatomic, weak) id<ValuePropertiesControllerDelegate> delegate;


@property (weak) IBOutlet NSView *detailedOptionsView;


@property (strong) IBOutlet NumericValuePropertiesController *numericPropertiesController;
@property (strong) IBOutlet PercentagePropertiesController *percentagePropertiesController;



@end
