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

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"TagBasicPropertiesController" owner:self topLevelObjects:nil];
  }
  return self;
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
