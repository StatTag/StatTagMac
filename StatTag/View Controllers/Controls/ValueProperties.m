//
//  ValueProperties.m
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "ValueProperties.h"

@interface ValueProperties ()

@end

@implementation ValueProperties

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


- (void)viewWillAppear {
  
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"ValueProperties" owner:self topLevelObjects:nil];
  }
  return self;
}


- (IBAction)selectValueType:(id)sender {
  [_delegate valueTypeDidChange:self];
}




@end
