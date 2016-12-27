//
//  NumericValuePropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "NumericValuePropertiesController.h"
#import "StatTagFramework.h"

@interface NumericValuePropertiesController ()

@end

@implementation NumericValuePropertiesController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidAppear {
  if([self maxNumSize] <= 0)
  {
    [self setValue:@10 forKey:@"maxNumSize"];
  }
}

- (IBAction)stepperChangeDecimalPlaces:(id)sender {
  if([[self delegate] respondsToSelector:@selector(decimalPlacesDidChange:)]) {
    [[self delegate] decimalPlacesDidChange:self];
  }
}

- (IBAction)checkedThousandsSeparator:(id)sender {
  if([[self delegate] respondsToSelector:@selector(useThousandsSeparatorDidChange:)]) {
    [[self delegate] useThousandsSeparatorDidChange:self];
  }
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
  //make sure your text box delegate is set to file's owner
  //http://stackoverflow.com/questions/7716758/objective-c-convert-nsstring-into-nsinteger

  //this needs some thought - but pay care that you do NOT modify the text field, but instead issue an update
  // via KVO to the model - everything else is listening to the MODEL
  if([aNotification object] == _textboxDecimalPlaces) {
    //trim
    NSString* myString = [[_textboxDecimalPlaces stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger number = [myString integerValue];
    if (number > _maxNumSize) {
      number = _maxNumSize;
    }
    if (number < 0) {
      number = 0;
    }
    [self setDecimalPlaces:(NSInteger)number];
    //self.decimalPlaces = (int)number;
    
    [[self delegate] decimalPlacesDidChange:self];
  }
}

@end
