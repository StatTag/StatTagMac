//
//  TablePropertiesController.h
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STTag;

//protocol for interacting with this control
@class TablePropertiesController;
@protocol TablePropertiesControllerDelegate <NSObject>
- (void)decimalPlacesDidChange:(TablePropertiesController*)controller;
- (void)showColumnNamesDidChange:(TablePropertiesController*)controller;
- (void)showRowNamesDidChange:(TablePropertiesController*)controller;
- (void)useThousandsSeparatorDidChange:(TablePropertiesController*)controller;
@end


@interface TablePropertiesController : NSViewController {
}

@property (strong) STTag* tag;

@property (weak) IBOutlet NSButton *checkboxShowColumnNames;
@property (weak) IBOutlet NSButton *checkboxShowRowNames;

@property (weak) IBOutlet NSTextField *textboxDecimalPlaces;
@property (weak) IBOutlet NSStepper *stepperDecimalPlaces;
@property (weak) IBOutlet NSButton *checkboxUseThousandsSeparator;

@property (nonatomic, weak) id<TablePropertiesControllerDelegate> delegate;


@end
