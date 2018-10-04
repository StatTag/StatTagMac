//
//  TagBasicPropertiesController.m
//  StatTag
//
//  Created by Eric Whitley on 10/2/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagBasicPropertiesController.h"
#import "StatTagFramework.h"

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

-(void)resetTagUI
{
  NSLog(@"TagBasicPropertiesController - resetting tag UI");
  NSString* tagName = [[self tag] Name] == nil ? @"" : [[self tag] Name];
  [[self tagNameTextbox] setStringValue:tagName];
  [[self tagTypeList] selectItemAtIndex:0];

  if([[self delegate] respondsToSelector:@selector(tagTypeDidChange:)]) {
    [[self delegate] tagTypeDidChange:self];
  }
}

- (IBAction)tagFrequencySelectionChanged:(id)sender {
  if([[self delegate] respondsToSelector:@selector(tagFrequencyDidChange:)]) {
    [[self delegate] tagFrequencyDidChange:self];
  }
}

- (IBAction)tagTypeChanged:(id)sender {
  if([[self delegate] respondsToSelector:@selector(tagTypeDidChange:)]) {
    [[self delegate] tagTypeDidChange:self];
  }
}


-(STTag*)tag
{
  return _tag;
}

-(void)setTag:(STTag *)tag
{
  _tag = tag;
  
  [self resetTagUI];
}


//http://www.tomdalling.com/blog/cocoa/implementing-your-own-cocoa-bindings/


@end
