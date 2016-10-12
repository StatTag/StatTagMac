//
//  SCMarkerCollection.h
//  StatTag
//
//  Created by Eric Whitley on 10/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCScintilla;
@class SCMarker;

@interface SCMarkerCollection : NSObject {
  NSMutableArray<SCMarker*>* _markers;
}

@property (weak, nonatomic) SCScintilla* scintilla;
@property (strong, nonatomic) NSMutableArray<SCMarker*>* markers;

-(instancetype)init;
-(instancetype)initWithScintilla:(SCScintilla*)scintilla;

/// Gets the number of markers in the <see cref="MarkerCollection" />.
// <returns>This property always returns 32.</returns>
-(int)Count;

///Gets a <see cref="Marker" /> object at the specified index.
/// <param name="index">The marker index.</param>
/// <returns>An object representing the marker at the specified <paramref name="index" />.</returns>
/// <remarks>Markers 25 through 31 are used by Scintilla for folding.</remarks>
-(SCMarker*) marketAtIndex:(int)index;

@end
