//
//  ValueProperties.m
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "ValuePropertiesController.h"
#import "StatTag.h"

@interface ValuePropertiesController ()

@end

@implementation ValuePropertiesController


-(void)awakeFromNib {
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[self listTagValueType] setControlSize:NSControlSizeSmall];
  [[self tagValueTypeArrayController] addObjects: [STConstantsValueFormatType GetList]];
}


- (void)viewWillAppear {
  //just in case we don't have a format for some reason
  if([[self tag] ValueFormat] == nil) {
    STValueFormat* f = [[STValueFormat alloc] init];
    [f setFormatType:[STConstantsValueFormatType Default]];
    [self willChangeValueForKey:@"self.tag.ValueFormat.FormatType"];
    self.tag.ValueFormat = f;
    [self didChangeValueForKey:@"self.tag.ValueFormat.FormatType"];
  }
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"ValuePropertiesController" owner:self topLevelObjects:nil];
  }
  return self;
}


- (IBAction)selectValueType:(id)sender {
  [_delegate valueTypeDidChange:self];
}




@end
