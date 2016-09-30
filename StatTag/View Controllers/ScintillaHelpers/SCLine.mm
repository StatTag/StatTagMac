//
//  SCLine.m
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "Scintilla/Scintilla.h"
#import "Scintilla/ScintillaView.h"

#import "SCLine.h"
#import "SCHelpers.h"
#import "SCScintilla.h"
#import "SCMarkerHandle.h"

@implementation SCLine

@synthesize scintilla = _scintilla;
@synthesize Index = _Index;

-(id)initWithScintilla:(SCScintilla*)sc atIndex:(long)index
{
  self = [super init];
  if(self) {
    _scintilla = sc;
    //FIXME: not sure why, but everything seems to be offset by 1 if we leave Index 0-based
    _Index = index + 1; //this seems like an extraordinarily bad idea
  }
  return self;
}

/// <summary>
/// Expands any parent folds to ensure the line is visible.
/// </summary>
-(void) EnsureVisible
{
  [ScintillaView directCall:[_scintilla scintillaView] message:SCI_ENSUREVISIBLE wParam:_Index lParam:0];
}

/// Adds the specified to the line.
/// @param marker : The zero-based index of the marker to add to the line.
/// @returns A SCMarkerHandle which can be used to track the line.
/// @remark This method does not check if the line already contains the marker
-(SCMarkerHandle*)MarkerAdd:(NSInteger)marker
{
  marker = [SCHelpers Clamp:marker min:0 max:[[_scintilla Markers] count] - 1];
  //marker = [SCHelpers Clamp:marker min:0 max:[[_scintilla Markers] count]];
  long handle = [ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERADD wParam:_Index lParam:marker];

  SCMarkerHandle* markerHandle = [[SCMarkerHandle alloc] init];
  markerHandle.Value = handle;
  return markerHandle;
}

/// Removes the specified <see cref="Marker" /> from the line.
/// @param marker : The zero-based index of the marker to remove from the line or -1 to delete all markers from the line.
/// @remark If the same marker has been added to the line more than once, this will delete one copy each time it is used
-(void)MarkerDelete:(NSInteger)marker
{
  marker = [SCHelpers Clamp:marker min:-1 max:[[_scintilla Markers] count] - 1];
  //marker = [SCHelpers Clamp:marker min:-1 max:[[_scintilla Markers] count]];
  [ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERDELETE wParam:_Index lParam:marker];
}

/// Returns a bit mask indicating which markers are present on the line.
/// @returns An unsigned 32-bit value with each bit cooresponding to one of the 32 zero-based <see cref="Marker" /> indexes.
-(NSInteger)MarkerGet
{
  NSInteger result = [ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERGET wParam:_Index lParam:0];
  return result;
//  var mask = scintilla.DirectMessage(NativeMethods.SCI_MARKERGET, new IntPtr(Index)).ToInt32();
//  return unchecked((uint)mask);
}


// <summary>
/// Gets the height of the line in pixels.
/// </summary>
/// <returns>The height in pixels of the line.</returns>
/// <remarks>Currently all lines are the same height.</remarks>
-(int)Height
{
  int result = (int)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_TEXTHEIGHT wParam:_Index lParam:0];
  return result;
//    return scintilla.DirectMessage(NativeMethods.SCI_TEXTHEIGHT, new IntPtr(Index)).ToInt32();
}

-(int)Length
{
  //FIXME: incomplete
  //https://github.com/jacobslusser/ScintillaNET/blob/dac00e526da95693f6b59b8276c5580846a4e63a/src/ScintillaNET/Line.cs#L411
  return 0;
  //return scintilla.Lines.CharLineLength(Index);
}


@end
