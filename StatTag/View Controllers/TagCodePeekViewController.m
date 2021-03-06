//
//  TagCodePeekViewController.m
//  StatTag
//
//  Created by Eric Whitley on 4/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "TagCodePeekViewController.h"
#import "STTag.h"
#import "STTag+TagContent.h"

#import "ViewUtils.h"
#import "ScintillaEmbeddedViewController.h"

@interface TagCodePeekViewController ()

@end

@implementation TagCodePeekViewController

@synthesize tag = _tag;
@synthesize codeFile = _codeFile;
@synthesize sourceEditor = _sourceEditor;



//static STCodeFile* codeFile;

//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"TagCodePeekViewController";
}

-(id)init {
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}
- (void)awakeFromNib {
//  [self sourceView] addSubview:[
  
  
}

//MARK: view events
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
}


-(void)viewWillAppear
{
  //not sure where or why, but our subviews are being lost when we load this in viewDidLoad
  //they still exist, but aren't in the view hierarchy
  //unclear on what I'm missing here
  [ViewUtils fillView:[self sourceView] withView:[[self sourceEditor] view]];

  [[self sourceEditor] hideLineNumbers];
  [[self sourceEditor] hideSelectionMargin];
  [[self sourceEditor] setUsesInfoBar:NO];
  [[self sourceEditor] setEditable:NO];
}

-(STTag*)tag
{
  return _tag;
}

-(void)setTag:(STTag *)tag
{
  _tag = tag;
  [[self tagLabel] setStringValue:[tag Name]];
  [[self tagCodePreview] setStringValue:[tag tagContent]];
  //[self loadSourceViewFromCodeFile:[tag CodeFile] limitToSource:[tag tagContent]];

  [[self sourceEditor] loadSource:[tag tagContent] withPackageIdentifier:[[tag CodeFile] StatisticalPackage]];
  
  [[self view] setNeedsLayout:YES];
  [[self view] setNeedsDisplay:YES];
}

-(STCodeFile*)codeFile
{
  return _codeFile;
}

-(void)setCodeFile:(STCodeFile*)codeFile withStart:(NSNumber*)startIndex andEnd:(NSNumber*)endIndex
{
  _tag = nil;
  _codeFile = codeFile;
  [[self tagLabel] setStringValue:[codeFile FileName]];
  [[self tagCodePreview] setStringValue:[codeFile ContentString]];
  
  NSArray* subArray = [[codeFile Content] subarrayWithRange:NSMakeRange([startIndex integerValue], ([endIndex integerValue] - [startIndex integerValue] + 1))];
  NSString *joinedString = [subArray componentsJoinedByString:@"\r"];
  
  [[self sourceEditor] loadSource:joinedString withPackageIdentifier:[codeFile StatisticalPackage]];
  
  [[self view] setNeedsLayout:YES];
  [[self view] setNeedsDisplay:YES];
}


@end
