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


/// Clears any undo or redo history.
/// @remark This will also cause SetSavePoint to be called but will not raise the SavePointReached event
-(void)EmptyUndoBuffer
{
  [ScintillaView directCall:[self scintillaView] message:SCI_EMPTYUNDOBUFFER wParam:0 lParam:0];
}


/// @summary Scrolls the display the number of lines and columns specified.
/// @parameter lines : The number of lines to scroll.
/// @parameter name : The number of columns to scroll.
/// @remark Negative values scroll in the opposite direction. A column is the width in pixels of a space character in the Default style.
-(void)LineScroll:(int)lines columns:(int)columns
{
  [ScintillaView directCall:[self scintillaView] message:SCI_LINESCROLL wParam:columns lParam:lines];
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
