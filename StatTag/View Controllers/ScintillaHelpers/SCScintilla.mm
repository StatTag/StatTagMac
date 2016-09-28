//
//  SCScintilla.m
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "SCScintilla.h"
#import "Scintilla/Scintilla.h"
#import "Scintilla/ScintillaView.h"

#import "SCLineCollection.h"

@implementation SCScintilla

@synthesize scintillaView = _scintillaView;
@synthesize Markers = _Markers;

-(id)initWithScintillaView:(ScintillaView*)sc
{
  self = [super init];
  if(self) {
    _scintillaView = sc;
  }
  return self;
}


-(int) LinesOnScreen
{
  int result = (int)[ScintillaView directCall:[self scintillaView] message:SCI_LINESONSCREEN wParam:0 lParam:0];
  return result;
}

-(SCLineCollection*)Lines {
  SCLineCollection* lines = [[SCLineCollection alloc] initWithScintilla:self];
  return lines;
}

@end
