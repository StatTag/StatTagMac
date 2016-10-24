//
//  TablePropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TablePropertiesController.h"

#import "StatTag.h"
#import "ViewUtils.h"

@interface TablePropertiesController ()

@end



@implementation TablePropertiesController

@synthesize tablePropertiesDetailFormatView = _tablePropertiesDetailFormatView;

- (void)viewDidLoad {
  [super viewDidLoad];
  [[self checkboxShowRowNames] setControlSize:NSSmallControlSize];
  [[self checkboxShowColumnNames] setControlSize:NSSmallControlSize];
  [[self checkboxUseThousandsSeparator] setControlSize:NSSmallControlSize];
}

- (void)viewWillAppear {
  [super viewWillAppear];
  self.numericPropertiesViewController.decimalPlaces = [[[self tag] ValueFormat] DecimalPlaces];
  self.numericPropertiesViewController.useThousands = [[[self tag] ValueFormat] UseThousands];
  self.numericPropertiesViewController.enableThousandsControl = YES;
  self.numericPropertiesViewController.delegate = self;
  
  [ViewUtils fillView:_tablePropertiesDetailFormatView withView:[_numericPropertiesViewController view]];  
}

- (void)decimalPlacesDidChange:(NumericValuePropertiesController*)controller {
  NSLog(@"decimal places changed");
  [[[self tag] ValueFormat] setDecimalPlaces:[controller decimalPlaces]];
  if([[self delegate] respondsToSelector:@selector(decimalPlacesDidChange:)]) {
    [[self delegate] decimalPlacesDidChange:self];
  }
}

- (void)useThousandsSeparatorDidChange:(NumericValuePropertiesController*)controller {
  [[[self tag] ValueFormat] setUseThousands:[controller useThousands]];
  if([[self delegate] respondsToSelector:@selector(useThousandsSeparatorDidChange:)]) {
    [[self delegate] useThousandsSeparatorDidChange:self];
  }
}


- (IBAction)checkedColumnNames:(id)sender {
  if([[self delegate] respondsToSelector:@selector(showColumnNamesDidChange:)]) {
    [_delegate showColumnNamesDidChange:self];
  }
}

- (IBAction)checkedRowNames:(id)sender {
  if([self delegate] != nil) {
    [_delegate showRowNamesDidChange:self];
  }
}



@end
