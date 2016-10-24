//
//  DateTimePropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/7/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "DateTimePropertiesController.h"

#import "StatTag.h"

@interface DateTimePropertiesController ()

@end

@implementation DateTimePropertiesController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //FIXME:
  //this should be moved somewhere central in the model instead - we should have this dictionary available in constants
  
  //date format list
  [_dateOptionsArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [STConstantsDateFormats MMDDYYYY], @"title",
                                          [STConstantsDateFormats MMDDYYYY], @"content",
                                          nil]];
  [_dateOptionsArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [STConstantsDateFormats MonthDDYYYY], @"title",
                                          [STConstantsDateFormats MonthDDYYYY], @"content",
                                          nil]];

  //time format list
  [_timeOptionsArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [STConstantsTimeFormats HHMM], @"title",
                                          [STConstantsTimeFormats HHMM], @"content",
                                          nil]];
  [_timeOptionsArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [STConstantsTimeFormats HHMMSS], @"title",
                                          [STConstantsTimeFormats HHMMSS], @"content",
                                          nil]];
}



-(BOOL)useDateFormat {
  if([[STConstantsDateFormats GetList] containsObject:[[[self tag] ValueFormat] DateFormat]]) {
    return YES;
  }
  return NO;
}
-(void)setUseDateFormat:(BOOL)useDateFormat {
  //set the new value as appropriate
  //enable the control (for some reason bindings crashed for the popup)
  if (useDateFormat) {
    NSString* dateFormat = [[[self dateOptionsList] selectedItem] representedObject];
    if(!dateFormat || [dateFormat isEqualToString:@""]) {
      [[self dateOptionsList] selectItemAtIndex:0] ;
    }
    [[[self tag] ValueFormat] setDateFormat:[[[self dateOptionsList] selectedItem] representedObject]];
    [[self dateOptionsList] setEnabled:YES];
  } else {
    [[[self tag] ValueFormat] setDateFormat:@""];
    [[self dateOptionsList] setEnabled:NO];
  }
}


-(BOOL)useTimeFormat {
  if([[STConstantsTimeFormats GetList] containsObject:[[[self tag] ValueFormat] TimeFormat]]) {
    return YES;
  }
  return NO;
}
-(void)setUseTimeFormat:(BOOL)useTimeFormat {
  //set the new value as appropriate
  //enable the control (for some reason bindings crashed for the popup)
  if (useTimeFormat) {
    NSString* timeFormat = [[[self timeOptionsList] selectedItem] representedObject];
    if(!timeFormat || [timeFormat isEqualToString:@""]) {
      [[self timeOptionsList] selectItemAtIndex:0] ;
    }
    [[[self tag] ValueFormat] setTimeFormat:[[[self timeOptionsList] selectedItem] representedObject]];
    [[self timeOptionsList] setEnabled:YES];
  } else {
    [[[self tag] ValueFormat] setTimeFormat:@""];
    [[self timeOptionsList] setEnabled:NO];
  }
}

-(void)viewWillAppear {

  //it's possible we have invalid / unknown date formats specified - if so, clear it and set "uses date" to no
  if(![[[[self tag] ValueFormat] DateFormat] isEqualToString:@""] && ![[STConstantsDateFormats GetList] containsObject:[[[self tag] ValueFormat] DateFormat]]) {
    [[[self tag] ValueFormat] setDateFormat:@""];
  }
  if([self useDateFormat]) {
    [[self dateOptionsList] setEnabled:YES];
  } else {
    [[self dateOptionsList] setEnabled:NO];
  }
  
  //same w/ time
  if(![[[[self tag] ValueFormat] TimeFormat] isEqualToString:@""] && ![[STConstantsTimeFormats GetList] containsObject:[[[self tag] ValueFormat] TimeFormat]]) {
    [[[self tag] ValueFormat] setTimeFormat:@""];
  }
  if([self useTimeFormat]) {
    [[self timeOptionsList] setEnabled:YES];
  } else {
    [[self timeOptionsList] setEnabled:NO];
  }
  
}


- (IBAction)showDateCheckboxDidChange:(id)sender {
}


- (IBAction)showTimeCheckboxDidChange:(id)sender {
}



@end
