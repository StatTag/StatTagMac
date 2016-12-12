//
//  TablePropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "PercentagePropertiesController.h"

#import "StatTagFramework.h"
#import "ViewUtils.h"

@interface PercentagePropertiesController ()

@end



@implementation PercentagePropertiesController

@synthesize percentagePropertiesDetailFormatView = _percentagePropertiesDetailFormatView;


- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear {
  [super viewWillAppear];

  self.numericPropertiesViewController.decimalPlaces = [[[self tag] ValueFormat] DecimalPlaces];
  self.numericPropertiesViewController.useThousands = [[[self tag] ValueFormat] UseThousands];
  self.numericPropertiesViewController.enableThousandsControl = NO;
  self.numericPropertiesViewController.delegate = self;
  
  [ViewUtils fillView:_percentagePropertiesDetailFormatView withView:[_numericPropertiesViewController view]];
  
}

- (void)decimalPlacesDidChange:(NumericValuePropertiesController*)controller {
  if([[self delegate] respondsToSelector:@selector(decimalPlacesDidChange:)]) {
    [[self delegate] decimalPlacesDidChange:controller];
  }
}

- (void)useThousandsSeparatorDidChange:(NumericValuePropertiesController*)controller {
  if([[self delegate] respondsToSelector:@selector(useThousandsSeparatorDidChange:)]) {
    [[self delegate] useThousandsSeparatorDidChange:controller];
  }
}

@end
