//
//  SCScintilla.h
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScintillaView;
@class SCLineCollection;
@class SCMarkerCollection;

@interface SCScintilla : NSObject {
  ScintillaView* _scintillaView;
  //NSMutableArray* _Markers;
}

@property (strong, nonatomic) ScintillaView* scintillaView;
//@property (strong, nonatomic) NSMutableArray* Markers;

-(void)EmptyUndoBuffer;
-(void)LineScroll:(NSInteger)lines columns:(NSInteger)columns;
-(NSInteger)LinesOnScreen;
-(id)initWithScintillaView:(ScintillaView*)sc;

-(NSInteger)LineFromPosition:(NSInteger) position;

//-(SCLineCollection*)Lines;
@property (strong, nonatomic) SCLineCollection* Lines;

@property (strong, nonatomic) SCMarkerCollection* Markers;

@end
