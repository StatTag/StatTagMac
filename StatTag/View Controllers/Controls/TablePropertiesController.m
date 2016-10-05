//
//  TablePropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TablePropertiesController.h"

#import "StatTag.h"

@interface TablePropertiesController ()

@end

@implementation TablePropertiesController

- (void)viewDidLoad {
  [super viewDidLoad];
  [[self checkboxShowRowNames] setControlSize:NSSmallControlSize];
  [[self checkboxShowColumnNames] setControlSize:NSSmallControlSize];
  [[self checkboxUseThousandsSeparator] setControlSize:NSSmallControlSize];
}


- (IBAction)stepperChangeDecimalPlaces:(id)sender {
  [_delegate useThousandsSeparatorDidChange:self];
}

- (IBAction)checkedColumnNames:(id)sender {
  [_delegate showColumnNamesDidChange:self];
}

- (IBAction)checkedRowNames:(id)sender {
  [_delegate showRowNamesDidChange:self];
}

- (IBAction)checkedThousandsSeparator:(id)sender {
  [_delegate useThousandsSeparatorDidChange:self];
}


@end
