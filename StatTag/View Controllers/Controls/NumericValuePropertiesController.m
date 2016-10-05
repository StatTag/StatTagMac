//
//  NumericValuePropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "NumericValuePropertiesController.h"

@interface NumericValuePropertiesController ()

@end

@implementation NumericValuePropertiesController

- (void)viewDidLoad {
  [super viewDidLoad];
}


- (IBAction)stepperChangeDecimalPlaces:(id)sender {
  [_delegate useThousandsSeparatorDidChange:self];
}

- (IBAction)checkedThousandsSeparator:(id)sender {
  [_delegate useThousandsSeparatorDidChange:self];
}


@end
