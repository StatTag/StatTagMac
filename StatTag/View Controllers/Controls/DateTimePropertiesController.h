//
//  DateTimePropertiesController.h
//  StatTag
//
//  Created by Eric Whitley on 10/7/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STTag;

@interface DateTimePropertiesController : NSViewController


@property (strong, nonatomic) STTag* tag;


@property (strong) IBOutlet NSArrayController *dateOptionsArrayController;
@property (strong) IBOutlet NSArrayController *timeOptionsArrayController;


@property (weak) IBOutlet NSButton *showDateCheckbox;
@property (weak) IBOutlet NSPopUpButton *dateOptionsList;

@property (weak) IBOutlet NSButton *showTimeCheckbox;
@property (weak) IBOutlet NSPopUpButton *timeOptionsList;

@property BOOL useDateFormat;
@property BOOL useTimeFormat;

@end
