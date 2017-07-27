//
//  TablePropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TablePropertiesController.h"

#import "StatTagFramework.h"
#import "ViewUtils.h"
#import "AppKitCompatibilityDeclarations.h"

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
  
  //Enter the values or ranges to exclude, separated by commas: (e.g. 1, 3, 8-10)
  
  //it's possible the filter isn't set on the tag, so if that's the case, set it to exclude
  if([[[[self tag] TableFormat] RowFilter] Type] == nil || ![[STConstantsFilterType GetList] containsObject: [[[[self tag] TableFormat] RowFilter] Type]] )
  {
    [[[[self tag] TableFormat] RowFilter] setType:[STConstantsFilterType Exclude]];
  }
  if([[[[self tag] TableFormat] ColumnFilter] Type] == nil || ![[STConstantsFilterType GetList] containsObject: [[[[self tag] TableFormat] ColumnFilter] Type]] )
  {
    [[[[self tag] TableFormat] ColumnFilter] setType:[STConstantsFilterType Exclude]];
  }

  // Tables will have rows and columns, and so we will allow non-numeric types to flow
  // through when inserting results into the document.
  [[self tag] ValueFormat].AllowInvalidTypes = YES;
  
  self.numericPropertiesViewController.decimalPlaces = [[[self tag] ValueFormat] DecimalPlaces];
  self.numericPropertiesViewController.useThousands = [[[self tag] ValueFormat] UseThousands];
  self.numericPropertiesViewController.enableThousandsControl = YES;
  self.numericPropertiesViewController.delegate = self;
  
  [ViewUtils fillView:_tablePropertiesDetailFormatView withView:[_numericPropertiesViewController view]];  
}

- (void)decimalPlacesDidChange:(NumericValuePropertiesController*)controller {
  //NSLog(@"decimal places changed");
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

-(NSString*)filterToolTip
{
  return @"Enter the values or ranges to exclude, separated by commas: (e.g. 1, 3, 8-10)";
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

/*
-(void)control:(NSControl*)control didFailToFormatString:(nonnull NSString *)string errorDescription:(nullable NSString *)error
{
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSAlertStyleWarning];
  if(control == [self columnFilterTextField] || control == [self rowFilterTextField])
  {
    [alert setMessageText:@"Invalid filter"];
  }
  [alert setInformativeText:error];
  [alert addButtonWithTitle:@"Ok"];
  [alert runModal];
  
}
*/

-(void)controlTextDidChange:(NSNotification *)obj
{
}

//https://lists.apple.com/archives/cocoa-dev/2010/Mar/msg00314.html

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
  if ([obj object] == [self columnFilterTextField] || [obj object] == [self rowFilterTextField]) {
    NSLog(@"editing ended");
  }
  /*
  NSTextField *textField = [notification object];
  NSView *nextKeyView = [textField nextKeyView];
  NSUInteger whyEnd = [[[notification userInfo] objectForKey:@"NSTextMovement"] unsignedIntValue];
  BOOL returnKeyPressed = (whyEnd == NSReturnTextMovement);
  BOOL tabOrBacktabToSelf = ((whyEnd == NSTabTextMovement || whyEnd == NSBacktabTextMovement) && (nextKeyView == nil || nextKeyView == textField));
  if (returnKeyPressed || tabOrBacktabToSelf)
    NSLog(@"focus stays");
  else
    NSLog(@"focus leaves");
   */
}

-(void)control:(NSControl*)control didFailToValidatePartialString:(nonnull NSString *)string errorDescription:(nullable NSString *)error
{
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSAlertStyleWarning];
  if(control == [self columnFilterTextField] || control == [self rowFilterTextField])
  {
    [alert setMessageText:@"Invalid table filter"];
  }
  [alert setInformativeText:error];
  [alert addButtonWithTitle:@"Ok"];
  [alert runModal];
}


@end
