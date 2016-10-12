//
//  SCLine.h
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCScintilla;
@class SCMarkerHandle;

@interface SCLine : NSObject {
  SCScintilla* _scintilla;
  long _Index;
}

@property (strong, nonatomic) SCScintilla* scintilla;
@property (nonatomic) long Index;

-(int)Height;
-(int)Length;
-(void) EnsureVisible;

-(id)initWithScintilla:(SCScintilla*)sc atIndex:(long)index;

-(SCMarkerHandle*)MarkerAdd:(int)marker;
-(void)MarkerDelete:(int)marker;
-(int)MarkerGet;
-(int)MarkerNext:(uint)markerMask;
-(int)MarkerPrevious:(uint)markerMask;

-(NSString*)Text;

@end
