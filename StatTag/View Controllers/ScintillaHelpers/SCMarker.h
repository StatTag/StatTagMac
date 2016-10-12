//
//  SCMarker.h
//  StatTag
//
//  Created by Eric Whitley on 10/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SCScintilla;


typedef NS_ENUM(int, MarkerSymbol) {
  /// A circle. This symbol is typically used to indicate a breakpoint.
  Circle = 0,
  /// A rectangel with rounded edges.
  RoundRect = 1,
  /// An arrow (triangle) pointing right.
  Arrow = 2,
  /// A rectangle that is wider than it is tall.
  SmallRect = 3,
  /// An arrow and tail pointing right. This symbol is typically used to indicate the current line of execution.
  ShortArrow = 4,
  /// An invisible symbol useful for tracking the movement of lines.
  Empty = 5,
  /// An arrow (triangle) pointing down.
  ArrowDown = 6,
  /// A minus (-) symbol.
  Minus = 7,
  /// A plus (+) symbol.
  Plus = 8,
  /// A thin vertical line. This symbol is typically used on the middle line of an expanded fold block.
  VLine = 9,
  /// A thin 'L' shaped line. This symbol is typically used on the last line of an expanded fold block.
  LCorner = 10,
  /// A thin 't' shaped line. This symbol is typically used on the last line of an expanded nested fold block.
  TCorner = 11,
  /// A plus (+) symbol with surrounding box. This symbol is typically used on the first line of a collapsed fold block.
  BoxPlus = 12,
  /// A plus (+) symbol with surrounding box and thin vertical line. This symbol is typically used on the first line of a collapsed nested fold block.
  BoxPlusConnected = 13,
  /// A minus (-) symbol with surrounding box. This symbol is typically used on the first line of an expanded fold block.
  BoxMinus = 14,
  /// A minus (-) symbol with surrounding box and thin vertical line. This symbol is typically used on the first line of an expanded nested fold block.
  BoxMinusConnected = 15,
  /// Similar to a <see cref="LCorner" />, but curved.
  LCornerCurve = 16,
  /// Similar to a <see cref="TCorner" />, but curved.
  TCornerCurve = 17,
  /// Similar to a <see cref="BoxPlus" /> but surrounded by a circle.
  CirclePlus = 18,
  /// Similar to a <see cref="BoxPlusConnected" />, but surrounded by a circle.
  CirclePlusConnected = 19,
  /// Similar to a <see cref="BoxMinus" />, but surrounded by a circle.
  CircleMinus = 20,
  /// Similar to a <see cref="BoxMinusConnected" />, but surrounded by a circle.
  CircleMinusConnected = 21,
  /// A special marker that displays no symbol but will affect the background color of the line.
  Background = 22,
  /// Three dots (ellipsis).
  DotDotDot = 23,
  /// Three bracket style arrows.
  Arrows = 24,
  // PixMap = SC_MARK_PIXMAP,
  /// A rectangle occupying the entire marker space.
  FullRect = 26,
  /// A rectangle occupying only the left edge of the marker space.
  LeftRect = 27,
  /// A special marker left available to plugins.
  Available = 28,
  /// A special marker that displays no symbol but will underline the current line text.
  Underline = 29,
  /// A user-defined image. Images can be set using the <see cref="Marker.DefineRgbaImage" /> method.
  RgbaImage = 30,
  /// A left-rotated bookmark.
  Bookmark = 31
  // Character = SC_MARK_CHARACTER
};


@interface SCMarker : NSObject


@property (weak, nonatomic) SCScintilla* scintilla;

/// Gets the zero-based marker index this object represents.
/// <returns>The marker index within the <see cref="MarkerCollection" />.</returns>
@property (nonatomic) long Index;

/// One of the <see cref="ScintillaNET.MarkerSymbol" /> enumeration values.
/// The default is <see cref="ScintillaNET.MarkerSymbol.Circle" />.
@property MarkerSymbol Symbol;

-(instancetype)init;
-(instancetype)initWithScintilla:(SCScintilla*)scintilla atIndex:(int)index;

-(void)DeleteAll; //FIXME: NOT IMPLEMENTED
-(void)SetAlpha:(int)alpha;
-(void)SetBackColor:(NSColor*)color;
-(void)SetForeColor:(NSColor*)color;



/// An unsigned 32-bit mask of all <see cref="Margin" /> indexes where each bit cooresponds to a margin index.
-(uint)MaskAll;
/// An unsigned 32-bit mask of folder <see cref="Margin" /> indexes (25 through 31) where each bit cooresponds to a margin index.
/// <seealso cref="Margin.Mask" />
-(uint)MaskFolders;
/// Folder end marker index. This marker is typically configured to display the <see cref="MarkerSymbol.BoxPlusConnected" /> symbol.
-(int)FolderEnd;
/// Folder open marker index. This marker is typically configured to display the <see cref="MarkerSymbol.BoxMinusConnected" /> symbol.
-(int)FolderOpenMid;
/// Folder mid tail marker index. This marker is typically configured to display the <see cref="MarkerSymbol.TCorner" /> symbol.
-(int)FolderMidTail;
/// Folder tail marker index. This marker is typically configured to display the <see cref="MarkerSymbol.LCorner" /> symbol.
-(int)FolderTail;
/// Folder sub marker index. This marker is typically configured to display the <see cref="MarkerSymbol.VLine" /> symbol.
-(int)FolderSub;
/// Folder marker index. This marker is typically configured to display the <see cref="MarkerSymbol.BoxPlus" /> symbol.;
-(int)Folder;
/// Folder open marker index. This marker is typically configured to display the <see cref="MarkerSymbol.BoxMinus" /> symbol.
-(int)FolderOpen;


@end
