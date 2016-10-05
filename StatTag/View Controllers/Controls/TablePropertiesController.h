//
//  TablePropertiesController.h
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NumericValuePropertiesController.h" //lazy... just want protocol definition

@class STTag;

//protocol for interacting with this control
@class TablePropertiesController;
@protocol TablePropertiesControllerDelegate <NSObject>
- (void)showColumnNamesDidChange:(TablePropertiesController*)controller;
- (void)showRowNamesDidChange:(TablePropertiesController*)controller;
- (void)decimalPlacesDidChange:(TablePropertiesController*)controller;
- (void)useThousandsSeparatorDidChange:(TablePropertiesController*)controller;
@end


@interface TablePropertiesController : NSViewController <NumericValuePropertiesControllerDelegate> {
//  NSView* _tablePropertiesDetailFormatView;
}

@property (strong) STTag* tag;

@property (weak) IBOutlet NSButton *checkboxShowColumnNames;
@property (weak) IBOutlet NSButton *checkboxShowRowNames;

@property (weak) IBOutlet NSTextField *textboxDecimalPlaces;
@property (weak) IBOutlet NSStepper *stepperDecimalPlaces;
@property (weak) IBOutlet NSButton *checkboxUseThousandsSeparator;

@property (nonatomic, weak) id<TablePropertiesControllerDelegate> delegate;


@property (nonatomic, strong) IBOutlet NSView *tablePropertiesDetailFormatView;
@property (strong) IBOutlet NumericValuePropertiesController *numericPropertiesViewController;
@property (weak) IBOutlet NSBox *customViewSeparatorLine;




@end
