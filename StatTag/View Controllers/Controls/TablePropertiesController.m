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

//
//-(void)fillView:(NSView*)parentView withView:(NSView*)newView {
//  
//  if(parentView != newView) {
//  
//    NSRect f = [parentView frame];
//    f.size.width = newView.frame.size.width;
//    f.size.height = newView.frame.size.height;
//    parentView.frame = f;
//
//    newView.frame = [parentView bounds];
//    
//    [newView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    [parentView addSubview:newView];
//    
//    [parentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView]|"
//                                             options:0
//                                             metrics:nil
//                                               views:NSDictionaryOfVariableBindings(newView)]];
//    
//    [parentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|"
//                                             options:0
//                                             metrics:nil
//                                               views:NSDictionaryOfVariableBindings(newView)]];
//  }
//}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[self checkboxShowRowNames] setControlSize:NSSmallControlSize];
  [[self checkboxShowColumnNames] setControlSize:NSSmallControlSize];
  [[self checkboxUseThousandsSeparator] setControlSize:NSSmallControlSize];
}

- (void)viewWillAppear {
  [super viewWillAppear];
  //self.numericPropertiesViewController.tag = self.tag;
  self.numericPropertiesViewController.decimalPlaces = [[[self tag] ValueFormat] DecimalPlaces];
  self.numericPropertiesViewController.useThousands = [[[self tag] ValueFormat] UseThousands];
  self.numericPropertiesViewController.enableThousandsControl = YES;
  self.numericPropertiesViewController.delegate = self;
  
//  self.numericPropertiesViewController.view.wantsLayer = YES;
//  self.numericPropertiesViewController.view.layer.backgroundColor = [[NSColor whiteColor] CGColor];
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
