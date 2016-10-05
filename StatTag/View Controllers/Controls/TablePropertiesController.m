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

@synthesize tablePropertiesDetailFormatView = _tablePropertiesDetailFormatView;


-(void)fillWithView:(NSView*)parentView withView:(NSView*)newView {
  
  if(parentView != newView) {
  
    NSRect f = [parentView frame];
    f.size.width = newView.frame.size.width;
    f.size.height = newView.frame.size.height;
    parentView.frame = f;

    newView.frame = [parentView bounds];
    
    [newView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [parentView addSubview:newView];
    
    [parentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(newView)]];
    
    [parentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(newView)]];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[self checkboxShowRowNames] setControlSize:NSSmallControlSize];
  [[self checkboxShowColumnNames] setControlSize:NSSmallControlSize];
  [[self checkboxUseThousandsSeparator] setControlSize:NSSmallControlSize];
}

- (void)viewDidAppear {
  [super viewDidAppear];
  self.numericPropertiesViewController.delegate = self;
  self.numericPropertiesViewController.tag = self.tag;
  
  self.numericPropertiesViewController.tag = self.tag;
  self.numericPropertiesViewController.delegate = self;
  [self fillWithView:_tablePropertiesDetailFormatView withView:[_numericPropertiesViewController view]];
  
}

- (void)decimalPlacesDidChange:(NumericValuePropertiesController*)controller {
  NSLog(@"decimal places changed");
  if([[self delegate] respondsToSelector:@selector(decimalPlacesDidChange:)]) {
    [[self delegate] decimalPlacesDidChange:self];
  }
}

- (void)useThousandsSeparatorDidChange:(NumericValuePropertiesController*)controller {
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
