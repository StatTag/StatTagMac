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

@interface SCScintilla : NSObject {
  ScintillaView* _scintillaView;
  NSMutableArray* _Markers;
}

@property (strong, nonatomic) ScintillaView* scintillaView;
@property (strong, nonatomic) NSMutableArray* Markers;

-(void)EmptyUndoBuffer;
-(void)LineScroll:(int)lines columns:(int)columns;
-(int)LinesOnScreen;
-(id)initWithScintillaView:(ScintillaView*)sc;

-(SCLineCollection*)Lines;

@end
