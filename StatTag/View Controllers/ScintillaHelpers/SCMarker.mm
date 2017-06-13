//
//  SCMarker.m
//  StatTag
//
//  Created by Eric Whitley on 10/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "SCMarker.h"

#import "Scintilla/Scintilla.h"
#import "Scintilla/ScintillaView.h"

#import "SCScintilla.h"
#import "SCHelpers.h"



@implementation SCMarker


//MARK: init

-(instancetype)init
{
  self = [super init];
  if(self){
    
  }
  return self;
}

/// Initializes a new instance of the <see cref="Marker" /> class.
/// <param name="scintilla">The <see cref="Scintilla" /> control that created this marker.</param>
/// <param name="index">The index of this style within the <see cref="MarkerCollection" /> that created it.</param>
-(instancetype)initWithScintilla:(SCScintilla*)scintilla atIndex:(int)index
{
  self = [super init];
  if(self){
    _scintilla = scintilla;
    _Index = index;
  }
  return self;
}



//MARK: core methods

/// Sets the marker symbol to a custom image.
/// <param name="image">The Bitmap to use as a marker symbol.</param>
/// <remarks>Calling this method will also update the <see cref="Symbol" /> property to <see cref="MarkerSymbol.RgbaImage" />.</remarks>
//public unsafe void DefineRgbaImage(Bitmap image)
//{
//  if (image == null)
//    return;
//  
//  scintilla.DirectMessage(NativeMethods.SCI_RGBAIMAGESETWIDTH, new IntPtr(image.Width));
//  scintilla.DirectMessage(NativeMethods.SCI_RGBAIMAGESETHEIGHT, new IntPtr(image.Height));
//  
//  var bytes = Helpers.BitmapToArgb(image);
//  fixed (byte* bp = bytes)
//  scintilla.DirectMessage(NativeMethods.SCI_MARKERDEFINERGBAIMAGE, new IntPtr(Index), new IntPtr(bp));
//}

/// Removes this marker from all lines.
-(void)DeleteAll
{
//  scintilla.MarkerDeleteAll(Index);
}

/// Sets the foreground alpha transparency for markers that are drawn in the content area.
/// <param name="alpha">The alpha transparency ranging from 0 (completely transparent) to 255 (no transparency).</param>
/// <remarks>See the remarks on the <see cref="SetBackColor" /> method for a full explanation of when a marker can be drawn in the content area.</remarks>
/// <seealso cref="SetBackColor" />
-(void)SetAlpha:(int)alpha
{
  alpha = [SCHelpers Clamp:alpha min:0 max:255];
  [ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERSETALPHA wParam:_Index lParam:alpha];
}

/// Sets the background color of the marker.
/// <param name="color">The <see cref="Marker" /> background Color. The default is White.</param>
/// <remarks>
/// The background color of the whole line will be drawn in the <paramref name="color" /> specified when the marker is not visible
/// because it is hidden by a <see cref="Margin.Mask" /> or the <see cref="Margin.Width" /> is zero.
/// </remarks>
/// <seealso cref="SetAlpha" />
-(void)SetBackColor:(NSColor*)color
{
  //var colour = ColorTranslator.ToWin32(color);
  //    [mEditor setColorProperty: SCI_MARKERSETBACK parameter: n value: [NSColor blackColor]];
  
  [[[self scintilla] scintillaView] setColorProperty:SCI_MARKERSETBACK parameter:_Index value:color];
  //scintilla.DirectMessage(NativeMethods.SCI_MARKERSETBACK, new IntPtr(Index), new IntPtr(colour));
}

/// Sets the foreground color of the marker.
/// <param name="color">The <see cref="Marker" /> foreground Color. The default is Black.</param>
-(void)SetForeColor:(NSColor*)color
{
//  var colour = ColorTranslator.ToWin32(color);
//  scintilla.DirectMessage(NativeMethods.SCI_MARKERSETFORE, new IntPtr(Index), new IntPtr(colour));
  [[[self scintilla] scintillaView] setColorProperty:SCI_MARKERSETFORE parameter:_Index value:color];
}


/// <summary>
/// Gets or sets the marker symbol.
/// </summary>
/// <returns>
/// One of the <see cref="ScintillaNET.MarkerSymbol" /> enumeration values.
/// The default is <see cref="ScintillaNET.MarkerSymbol.Circle" />.
/// </returns>
-(void)setSymbol:(MarkerSymbol)symbol
{
  int markerSymbol = (int)symbol;
  [ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERDEFINE wParam:_Index lParam:markerSymbol];
  //    scintilla.DirectMessage(NativeMethods.SCI_MARKERDEFINE, new IntPtr(Index), new IntPtr(markerSymbol));
}
-(MarkerSymbol)Symbol
{
  return (MarkerSymbol)[ScintillaView directCall:[_scintilla scintillaView] message:SCI_MARKERSYMBOLDEFINED wParam:_Index lParam:0];
//    return (MarkerSymbol)scintilla.DirectMessage(NativeMethods.SCI_MARKERSYMBOLDEFINED, new IntPtr(Index));

}





//MARK: constants

/// An unsigned 32-bit mask of all <see cref="Margin" /> indexes where each bit cooresponds to a margin index.
-(uint)MaskAll
{
  return (uint)-1;
}
/// An unsigned 32-bit mask of folder <see cref="Margin" /> indexes (25 through 31) where each bit cooresponds to a margin index.
/// <seealso cref="Margin.Mask" />
-(uint)MaskFolders
{
  return SC_MASK_FOLDERS;
}

/// Folder end marker index. This marker is typically configured to display the <see cref="MarkerSymbol.BoxPlusConnected" /> symbol.
-(int)FolderEnd
{
  return SC_MARKNUM_FOLDEREND;
}

/// Folder open marker index. This marker is typically configured to display the <see cref="MarkerSymbol.BoxMinusConnected" /> symbol.
-(int)FolderOpenMid
{
  return SC_MARKNUM_FOLDEROPENMID;
}
/// Folder mid tail marker index. This marker is typically configured to display the <see cref="MarkerSymbol.TCorner" /> symbol.
-(int)FolderMidTail
{
  return SC_MARKNUM_FOLDERMIDTAIL;
}
/// Folder tail marker index. This marker is typically configured to display the <see cref="MarkerSymbol.LCorner" /> symbol.
-(int)FolderTail
{
  return SC_MARKNUM_FOLDERTAIL;
}
/// Folder sub marker index. This marker is typically configured to display the <see cref="MarkerSymbol.VLine" /> symbol.
-(int)FolderSub
{
  return SC_MARKNUM_FOLDERSUB;
}
/// Folder marker index. This marker is typically configured to display the <see cref="MarkerSymbol.BoxPlus" /> symbol.
-(int)Folder
{
  return SC_MARKNUM_FOLDER;
}
/// Folder open marker index. This marker is typically configured to display the <see cref="MarkerSymbol.BoxMinus" /> symbol.
-(int)FolderOpen
{
  return SC_MARKNUM_FOLDEROPEN;
}

@end



/*
 
 
 typedef NS_ENUM(int, MarkerSymbol) {
 /// A circle. This symbol is typically used to indicate a breakpoint.
 Circle = SC_MARK_CIRCLE,
 /// A rectangel with rounded edges.
 RoundRect = SC_MARK_ROUNDRECT,
 /// An arrow (triangle) pointing right.
 Arrow = SC_MARK_ARROW,
 /// A rectangle that is wider than it is tall.
 SmallRect = SC_MARK_SMALLRECT,
 /// An arrow and tail pointing right. This symbol is typically used to indicate the current line of execution.
 ShortArrow = SC_MARK_SHORTARROW,
 /// An invisible symbol useful for tracking the movement of lines.
 Empty = SC_MARK_EMPTY,
 /// An arrow (triangle) pointing down.
 ArrowDown = SC_MARK_ARROWDOWN,
 /// A minus (-) symbol.
 Minus = SC_MARK_MINUS,
 /// A plus (+) symbol.
 Plus = SC_MARK_PLUS,
 /// A thin vertical line. This symbol is typically used on the middle line of an expanded fold block.
 VLine = SC_MARK_VLINE,
 /// A thin 'L' shaped line. This symbol is typically used on the last line of an expanded fold block.
 LCorner = SC_MARK_LCORNER,
 /// A thin 't' shaped line. This symbol is typically used on the last line of an expanded nested fold block.
 TCorner = SC_MARK_TCORNER,
 /// A plus (+) symbol with surrounding box. This symbol is typically used on the first line of a collapsed fold block.
 BoxPlus = SC_MARK_BOXPLUS,
 /// A plus (+) symbol with surrounding box and thin vertical line. This symbol is typically used on the first line of a collapsed nested fold block.
 BoxPlusConnected = SC_MARK_BOXPLUSCONNECTED,
 /// A minus (-) symbol with surrounding box. This symbol is typically used on the first line of an expanded fold block.
 BoxMinus = SC_MARK_BOXMINUS,
 /// A minus (-) symbol with surrounding box and thin vertical line. This symbol is typically used on the first line of an expanded nested fold block.
 BoxMinusConnected = SC_MARK_BOXMINUSCONNECTED,
 /// Similar to a <see cref="LCorner" />, but curved.
 LCornerCurve = SC_MARK_LCORNERCURVE,
 /// Similar to a <see cref="TCorner" />, but curved.
 TCornerCurve = SC_MARK_TCORNERCURVE,
 /// Similar to a <see cref="BoxPlus" /> but surrounded by a circle.
 CirclePlus = SC_MARK_CIRCLEPLUS,
 /// Similar to a <see cref="BoxPlusConnected" />, but surrounded by a circle.
 CirclePlusConnected = SC_MARK_CIRCLEPLUSCONNECTED,
 /// Similar to a <see cref="BoxMinus" />, but surrounded by a circle.
 CircleMinus = SC_MARK_CIRCLEMINUS,
 /// Similar to a <see cref="BoxMinusConnected" />, but surrounded by a circle.
 CircleMinusConnected = SC_MARK_CIRCLEMINUSCONNECTED,
 /// A special marker that displays no symbol but will affect the background color of the line.
 Background = SC_MARK_BACKGROUND,
 /// Three dots (ellipsis).
 DotDotDot = SC_MARK_DOTDOTDOT,
 /// Three bracket style arrows.
 Arrows = SC_MARK_ARROWS,
 // PixMap = SC_MARK_PIXMAP,
 /// A rectangle occupying the entire marker space.
 FullRect = SC_MARK_FULLRECT,
 /// A rectangle occupying only the left edge of the marker space.
 LeftRect = SC_MARK_LEFTRECT,
 /// A special marker left available to plugins.
 Available = SC_MARK_AVAILABLE,
 /// A special marker that displays no symbol but will underline the current line text.
 Underline = SC_MARK_UNDERLINE,
 /// A user-defined image. Images can be set using the <see cref="Marker.DefineRgbaImage" /> method.
 RgbaImage = SC_MARK_RGBAIMAGE,
 /// A left-rotated bookmark.
 Bookmark = SC_MARK_BOOKMARK
 // Character = SC_MARK_CHARACTER
 };

 */
