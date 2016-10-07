//
//  PercentagePropertiesController.h
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NumericValuePropertiesController.h"

@class STTag;

//protocol for interacting with this control
@class PercentagePropertiesController;
@protocol PercentagePropertiesControllerDelegate <NSObject>
- (void)decimalPlacesDidChange:(NumericValuePropertiesController*)controller;
- (void)useThousandsSeparatorDidChange:(NumericValuePropertiesController*)controller;
@end


@interface PercentagePropertiesController : NSViewController <NumericValuePropertiesControllerDelegate> {
}

@property (strong) STTag* tag;


@property (nonatomic, weak) id<PercentagePropertiesControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet NSView *percentagePropertiesDetailFormatView;
@property (strong) IBOutlet NumericValuePropertiesController *numericPropertiesViewController;


@end
