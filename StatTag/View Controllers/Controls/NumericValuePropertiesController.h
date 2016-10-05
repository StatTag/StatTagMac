//
//  NumericValuePropertiesController.h
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//protocol for interacting with this control
@class NumericValuePropertiesController;
@protocol NumericValuePropertiesControllerDelegate <NSObject>
- (void)decimalPlacesDidChange:(NumericValuePropertiesController*)controller;
- (void)useThousandsSeparatorDidChange:(NumericValuePropertiesController*)controller;
@end

@class STTag;

@interface NumericValuePropertiesController : NSViewController

@property (weak) IBOutlet NSTextField *textboxDecimalPlaces;
@property (weak) IBOutlet NSStepper *stepperDecimalPlaces;
@property (weak) IBOutlet NSButton *checkboxUseThousandsSeparator;

@property (strong) STTag* tag;

@property (nonatomic, weak) id<NumericValuePropertiesControllerDelegate> delegate;


@end
