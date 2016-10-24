//
//  TagGridView.m
//  StatTag
//
//  Created by Eric Whitley on 10/6/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagGridView.h"

@implementation TagGridView

//- (void)drawRect:(NSRect)dirtyRect {
//  [super drawRect:dirtyRect];
//}

const NSInteger DEFAULT_GRIDSIZE = 4;

-(id)init {
  self = [super init];
  if(self) {
    [self configureGrid];
  }
  return self;
}

-(id)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if(self) {
    [self configureGrid];
  }
  return self;
}

-(void)configureGrid {
  if(_gridSize == 0) {
    _gridSize = DEFAULT_GRIDSIZE;
  }
  if(_cellLineColor == nil) {
    _cellLineColor = [NSColor grayColor];
  }
  if(_cellFillColor == nil) {
    _cellFillColor = [NSColor whiteColor];
  }
  if(_headerFillColor == nil) {
    _headerFillColor = [NSColor darkGrayColor];
  }
  if(_headerLineColor == nil) {
    _headerLineColor = _cellFillColor;
  }
}

//MARK: grid drawing


- (BOOL) isFlipped {
  //top down
  return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];

  //http://stackoverflow.com/questions/18344776/drawing-board-grid-with-cocoa

  for (NSUInteger x = 0; x < _gridSize; x++) {
    for (NSUInteger y = 0; y < _gridSize; y++) {
      [_cellFillColor set];
      [NSBezierPath fillRect:[self rectOfCellAtColumn:x row:y]];
      
      [_cellLineColor set];
      [NSBezierPath strokeRect:[self rectOfCellAtColumn:x row:y]];
    }
  }
  
  if(_useColumnLabels) {
    //if we're also using row labels, offset by one - we don't want columns and rows to get headers
    NSInteger startAtCol = _useRowLabels ? 1 : 0;
    for (NSUInteger x = startAtCol; x < _gridSize; x++) {
      NSRect rect = NSInsetRect([self rectOfCellAtColumn:x row:0], 0.5, 0.5);
      
      [_headerFillColor set];
      [NSBezierPath fillRect:rect];

      [_headerLineColor set];
      [NSBezierPath strokeRect:rect];
    }
  }
  if(_useRowLabels) {
    //if we're also using column labels, offset by one - we don't want columns and rows to get headers
    NSInteger startAtCol = _useColumnLabels ? 1 : 0;
    for (NSUInteger x = startAtCol; x < _gridSize; x++) {
      NSRect rect = NSInsetRect([self rectOfCellAtColumn:0 row:x], 0.5, 0.5);

      [_headerFillColor set];
      [NSBezierPath fillRect:rect];
      
      [_headerLineColor set];
      [NSBezierPath strokeRect:rect];
    }
  }
    
}

- (NSRect)rectOfCellAtColumn:(NSUInteger)column row:(NSUInteger)row {
  NSRect frame = [self frame];
  CGFloat cellWidth = frame.size.width / _gridSize;
  CGFloat cellHeight = frame.size.height / _gridSize;
  CGFloat x = column * cellWidth;
  CGFloat y = row * cellHeight;
  NSRect rect = NSMakeRect(x, y, cellWidth, cellHeight);
  NSAlignmentOptions alignOpts = NSAlignMinXNearest | NSAlignMinYNearest |
  NSAlignMaxXNearest | NSAlignMaxYNearest ;
  return [self backingAlignedRect:rect options:alignOpts];
}


@end
