//
//  AlertDisclosureTextView.m
//  StatTag
//
//  Created by Eric Whitley on 3/6/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "AlertDisclosureTextView.h"

@interface AlertDisclosureTextView ()

@end

@implementation AlertDisclosureTextView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


-(NSString*)viewNibName
{
  return @"AlertDisclosureTextView";
}


-(id)init
{
  //[[NSBundle mainBundle] loadNibNamed:@"AlertDisclosureTextView" owner:self topLevelObjects:nil];
  //BOOL success = [[NSBundle mainBundle] loadNibNamed:[self viewNibName] owner:self topLevelObjects:nil];
  self = [super initWithNibName:[self viewNibName] bundle:nil];
  //NSLog(@"view is... %@", [[self view] className]);
  
  NSView* v = [self view];
  
  if (self != nil)
  {
  }
  return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//  //BOOL success = [[NSBundle mainBundle] loadNibNamed:[self viewNibName] owner:self topLevelObjects:nil];
//  //[[NSBundle mainBundle] loadNibNamed:[self viewNibName] owner:self options:nil];
//  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//  if (self != nil)
//  {
//    [[self disclosureButton] setState: NO];
//  }
//  return self;
//}

//- (void)awakeFromNib
//{
//  [[self disclosureButton] setState: NO];
//}


//-(id) initWithCoder:(NSCoder *)coder {
//  self = [super initWithCoder:coder];
//  if(self) {
//    [[NSBundle mainBundle] loadNibNamed:@"AlertDisclosureTextView" owner:self topLevelObjects:nil];
//  }
//  return self;
//}

//- (IBAction)disclosureChanged:(id)sender {
//  
//  if([sender tag] == 1)
//  {
//    NSButton* b = (NSButton*)sender;
//    if([b state] == NSOffState)
//    {
//      [[self textBoxHeightConstraint] setConstant:0];
//    } else {
//      [[self textBoxHeightConstraint] setConstant:200];
//    }
//    //[[self textView] setHidden:[b state]];
//  }
//  
//}




@end
