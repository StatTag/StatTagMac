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

#import "SCHelpers.h"
#import "SCLineCollection.h"

@implementation SCScintilla

@synthesize scintillaView = _scintillaView;
@synthesize Markers = _Markers;

-(id)initWithScintillaView:(ScintillaView*)sc
{
  self = [super init];
  if(self) {
    _scintillaView = sc;
    _Lines = [[SCLineCollection alloc] initWithScintilla:self];
  }
  return self;
}


/// Clears any undo or redo history.
/// @remark This will also cause SetSavePoint to be called but will not raise the SavePointReached event
-(void)EmptyUndoBuffer
{
  [ScintillaView directCall:[self scintillaView] message:SCI_EMPTYUNDOBUFFER wParam:0 lParam:0];
}


/**
  @summary Returns the line that contains the document position specified.
  @param position : The zero-based document character position.
  @returns The zero-based document line index containing the character "."
 */
-(NSInteger)LineFromPosition:(NSInteger) position
{
  position = [SCHelpers Clamp:position min:0 max:[[[self scintillaView] string] length]];
//  position = Helpers.Clamp(position, 0, TextLength);
  
//  return Lines.LineFromCharPosition(position);
  return [[self Lines] LineFromCharPosition: position];
}


/// @summary Scrolls the display the number of lines and columns specified.
/// @parameter lines : The number of lines to scroll.
/// @parameter name : The number of columns to scroll.
/// @remark Negative values scroll in the opposite direction. A column is the width in pixels of a space character in the Default style.
-(void)LineScroll:(NSInteger)lines columns:(NSInteger)columns
{
  [ScintillaView directCall:[self scintillaView] message:SCI_LINESCROLL wParam:columns lParam:lines];
}

-(NSInteger) LinesOnScreen
{
  NSInteger result = (int)[ScintillaView directCall:[self scintillaView] message:SCI_LINESONSCREEN wParam:0 lParam:0];
  return result;
}

//-(SCLineCollection*)Lines {
//  SCLineCollection* lines = [[SCLineCollection alloc] initWithScintilla:self];
//  return lines;
//}

@end
