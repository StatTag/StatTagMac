//
//  TagBasicPropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/2/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagBasicPropertiesController.h"
#import "StatTag.h"

@interface TagBasicPropertiesController ()

@end

@implementation TagBasicPropertiesController

-(void)awakeFromNib {
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[self tagNameTextbox] setControlSize:NSSmallControlSize];
  [[self tagFrequencyList] setControlSize:NSSmallControlSize];
  [[self tagTypeList] setControlSize:NSSmallControlSize];
  [[self tagFrequencyArrayController] addObjects: [STConstantsRunFrequency GetList]];
  [[self tagTypeArrayController] addObjects: [STConstantsTagType GetList]];
}

-(id)init
{
  return [super initWithNibName:@"TagBasicPropertiesController" bundle:nil];
}


-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"TagBasicPropertiesController" owner:self topLevelObjects:nil];
  }
  return self;
}

-(void)setup {
  
}

-(void)controlTextDidChange:(NSNotification *)obj {
  if ([obj object] == _tagNameTextbox) {
    [_delegate tagNameDidChange:self];
  }
}

- (IBAction)tagFrequencySelectionChanged:(id)sender {
  [_delegate tagFrequencyDidChange:self];
}

- (IBAction)tagTypeChanged:(id)sender {
  [_delegate tagTypeDidChange:self];
}



//http://www.tomdalling.com/blog/cocoa/implementing-your-own-cocoa-bindings/


@end
