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
#import "SCMarkerCollection.h"
#import "SCMarker.h"

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
-(SCMarkerHandle*)MarkerAdd:(int)marker
{
  marker = [SCHelpers Clamp:marker min:0 max:(int)[[_scintilla Markers] Count] - 1];
  //marker = [SCHelpers Clamp:marker min:0 max:[[_scintilla Markers] count]];
  int handle = (int)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERADD wParam:_Index lParam:marker];

  SCMarkerHandle* markerHandle = [[SCMarkerHandle alloc] init];
  markerHandle.Value = handle;
  return markerHandle;
}

/// Removes the specified <see cref="Marker" /> from the line.
/// @param marker : The zero-based index of the marker to remove from the line or -1 to delete all markers from the line.
/// @remark If the same marker has been added to the line more than once, this will delete one copy each time it is used
-(void)MarkerDelete:(int)marker
{
  marker = [SCHelpers Clamp:marker min:-1 max:(int)[[_scintilla Markers] Count] - 1];
  //marker = [SCHelpers Clamp:marker min:-1 max:[[_scintilla Markers] count]];
  [ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERDELETE wParam:_Index lParam:marker];
}

/// Returns a bit mask indicating which markers are present on the line.
/// @returns An unsigned 32-bit value with each bit cooresponding to one of the 32 zero-based <see cref="Marker" /> indexes.
-(int)MarkerGet
{
  uint result = (uint)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERGET wParam:_Index lParam:0];
  return result;
//  var mask = scintilla.DirectMessage(NativeMethods.SCI_MARKERGET, new IntPtr(Index)).ToInt32();
//  return unchecked((uint)mask);
}


/// <summary>
/// Efficiently searches from the current line forward to the end of the document for the specified markers.
/// </summary>
/// <param name="markerMask">An unsigned 32-bit value with each bit cooresponding to one of the 32 zero-based <see cref="Margin" /> indexes.</param>
/// <returns>If found, the zero-based line index containing one of the markers in <paramref name="markerMask" />; otherwise, -1.</returns>
/// <remarks>For example, the mask for marker index 10 is 1 shifted left 10 times (1 &lt;&lt; 10).</remarks>
-(int)MarkerNext:(uint)markerMask
{
  //var mask = unchecked((int)markerMask);
  int mask = (int)markerMask;
  int result = (int)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERNEXT wParam:_Index lParam:mask];
  return result;
  //return scintilla.DirectMessage(NativeMethods.SCI_MARKERNEXT, new IntPtr(Index), new IntPtr(mask)).ToInt32();
}

/// <summary>
/// Efficiently searches from the current line backward to the start of the document for the specified markers.
/// </summary>
/// <param name="markerMask">An unsigned 32-bit value with each bit corresponding to one of the 32 zero-based <see cref="Margin" /> indexes.</param>
/// <returns>If found, the zero-based line index containing one of the markers in <paramref name="markerMask" />; otherwise, -1.</returns>
/// <remarks>For example, the mask for marker index 10 is 1 shifted left 10 times (1 &lt;&lt; 10).</remarks>
-(int)MarkerPrevious:(uint)markerMask
{
  //var mask = unchecked((int)markerMask);
  int mask = (int)markerMask;
  int result = (int)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERPREVIOUS wParam:_Index lParam:mask];
  return result;
  //return scintilla.DirectMessage(NativeMethods.SCI_MARKERPREVIOUS, new IntPtr(Index), new IntPtr(mask)).ToInt32();
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


-(NSString*)Text {
  int start = (int)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_POSITIONFROMLINE wParam:_Index lParam:0];
  int length = (int)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_LINELENGTH wParam:_Index lParam:0];
//  int ptr = (int)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_GETRANGEPOINTER wParam:start lParam:length];
  
  char* ptr = (char*)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_GETRANGEPOINTER wParam:start lParam:length];
  
  if (ptr == 0)
    return @"";
  
  NSString* s = [NSString stringWithUTF8String: ptr];
  //again... this isn't right...
  if([s length] > length) {
    s = [s substringToIndex:length];
  }
  return s;

  //var text = new string((sbyte*)ptr, 0, length.ToInt32(), scintilla.Encoding);
  //return text;
}

-(NSString*)description
{
  return [NSString stringWithFormat:@"Index:%ld, Height:%d, Length:%d, Text:%@", [self Index], [self Height], [self Length], [self Text]];
}

@end
