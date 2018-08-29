//
//  ValueProperties.m
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "ValuePropertiesController.h"
#import "StatTagFramework.h"
#import "ViewUtils.h"
#import "AppKitCompatibilityDeclarations.h"

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
  [self setUIPropertiesForTag];
  
}

-(void)setUIPropertiesForTag
{
  self.numericPropertiesController.decimalPlaces = [[[self tag] ValueFormat] DecimalPlaces];
  self.numericPropertiesController.useThousands = [[[self tag] ValueFormat] UseThousands];
  self.numericPropertiesController.enableThousandsControl = YES;
  self.numericPropertiesController.delegate = self;
  
  self.percentagePropertiesController.tag = [self tag]; // being a wee bit inconsistent here...
  self.percentagePropertiesController.delegate = self;
  
  self.dateTimePropertiesController.tag = [self tag]; // being a wee bit inconsistent here...
  
  [self displayChildViews];

}

-(void)displayChildViews {
  if([[[[self tag] ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType Numeric]]) {
    [[self detailedOptionsView] setHidden: NO];
    self.numericPropertiesController.decimalPlaces = [[[self tag] ValueFormat] DecimalPlaces];
    self.numericPropertiesController.useThousands = [[[self tag] ValueFormat] UseThousands];
    [ViewUtils fillView:_detailedOptionsView withView:[_numericPropertiesController view]];
  } else if([[[[self tag] ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType Percentage]]) {
    [[self detailedOptionsView] setHidden: NO];
    [ViewUtils fillView:_detailedOptionsView withView:[_percentagePropertiesController view]];
  } else if([[[[self tag] ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType DateTime]]) {
    //FIXME: need view controller!
    [[self detailedOptionsView] setHidden: NO];
    [ViewUtils fillView:_detailedOptionsView withView:[_dateTimePropertiesController view]];
  } else {
    [_detailedOptionsView setSubviews:[NSArray array]];
    [[self detailedOptionsView] setHidden: YES];
  }
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"ValuePropertiesController" owner:self topLevelObjects:nil];
  }
  return self;
}

-(void)resetTagUI
{
  NSLog(@"ValuePropertiesController - resetting tag UI");

  [self setUIPropertiesForTag];
  [[self numericPropertiesController] resetTagUI];
  
//  [self setUIPropertiesForTag];

//  [_delegate valueTypeDidChange:self];
//  [[self numericPropertiesController] resetTagUI];
}

- (IBAction)selectValueType:(id)sender {
  [self displayChildViews];
  [_delegate valueTypeDidChange:self];
}

- (void)decimalPlacesDidChange:(NumericValuePropertiesController*)controller {
  [[[self tag] ValueFormat] setDecimalPlaces:[controller decimalPlaces]];
}

- (void)useThousandsSeparatorDidChange:(NumericValuePropertiesController*)controller {
  [[[self tag] ValueFormat] setUseThousands:[controller useThousands]];
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

@end
