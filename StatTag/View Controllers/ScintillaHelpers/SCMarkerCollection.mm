//
//  SCMarkerCollection.m
//  StatTag
//
//  Created by Eric Whitley on 10/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "SCMarkerCollection.h"

#import "Scintilla/Scintilla.h"
#import "Scintilla/ScintillaView.h"

#import "SCScintilla.h"
#import "SCHelpers.h"
#import "SCMarker.h"


@implementation SCMarkerCollection

-(instancetype)init {
  self = [super init];
  if(self)
  {
    _markers = [[NSMutableArray<SCMarker*> alloc] init];
  }
  return self;
}

-(instancetype)initWithScintilla:(SCScintilla*)scintilla {
  self = [super init];
  if(self)
  {
    _scintilla = scintilla;
    _markers = [[NSMutableArray<SCMarker*> alloc] init];
  }
  return self;
}

/// Gets the number of markers in the <see cref="MarkerCollection" />.
// <returns>This property always returns 32.</returns>
-(int)Count
{
  return (MARKER_MAX + 1);
}


///Gets a <see cref="Marker" /> object at the specified index.
/// <param name="index">The marker index.</param>
/// <returns>An object representing the marker at the specified <paramref name="index" />.</returns>
/// <remarks>Markers 25 through 31 are used by Scintilla for folding.</remarks>
-(SCMarker*) marketAtIndex:(int)index
{
  index = [SCHelpers Clamp:index min:0 max:([self Count] -1)];//Helpers.Clamp(index, 0, Count - 1);
  return [[SCMarker alloc] initWithScintilla:_scintilla atIndex:index];
  // initWithScintilla:_scintilla atIndex:index];// Marker(scintilla, index);
}


@end
