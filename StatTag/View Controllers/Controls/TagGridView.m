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

//const NSInteger DEFAULT_GRIDSIZE = 4;
const NSInteger DEFAULT_NUMROWS = 4;
const NSInteger DEFAULT_NUMCOLS = 4;

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
//  if(_gridSize == 0) {
//    _gridSize = DEFAULT_GRIDSIZE;
//  }
  if(_numRows == 0) {
    _numRows = DEFAULT_NUMROWS;
  }
  if(_numCols == 0) {
    _numCols = DEFAULT_NUMCOLS;
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
  _showFilteredRows = NO;
  _showFilteredColumns = NO;
  _filterRows = [[NSArray<NSNumber*> alloc] init];
  _filterColumns = [[NSArray<NSNumber*> alloc] init];
  
  if(_filteredColumnColor == nil) {
    _filteredColumnColor = [NSColor lightGrayColor];
  }
  if(_filteredRowColor == nil) {
    _filteredRowColor = [NSColor lightGrayColor];
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

  for (NSUInteger x = 0; x < _numCols; x++) {
    if([self filterColumns] && [[self filterColumns] containsObject: [NSNumber numberWithInteger:x]])
    {
      //continue;
    }
    for (NSUInteger y = 0; y < _numRows; y++) {
      if([self filterRows] && [[self filterRows] containsObject: [NSNumber numberWithInteger:y]])
      {
        //continue;
      }
      if([[self filterColumns] containsObject: [NSNumber numberWithInteger:x]] || [[self filterRows] containsObject: [NSNumber numberWithInteger:y]])
      {
        [_filteredColumnColor set];
        [NSBezierPath fillRect:[self rectOfCellAtColumn:x row:y]];
      } else {
        [_cellFillColor set];
        [NSBezierPath fillRect:[self rectOfCellAtColumn:x row:y]];
      }
      //painter's model - fill first, then line over as we go
      
      [_cellLineColor set];
      [NSBezierPath strokeRect:[self rectOfCellAtColumn:x row:y]];
    }
  }
  
  if(_useColumnLabels) {
    //if we're also using row labels, offset by one - we don't want columns and rows to get headers
    NSInteger startAtCol = _useRowLabels ? 1 : 0;
    for (NSUInteger x = startAtCol; x < _numRows; x++) {
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
    for (NSUInteger x = startAtCol; x < _numRows; x++) {
      NSRect rect = NSInsetRect([self rectOfCellAtColumn:0 row:x], 0.5, 0.5);

      [_headerFillColor set];
      [NSBezierPath fillRect:rect];
      
      [_headerLineColor set];
      [NSBezierPath strokeRect:rect];
    }
  }
    
}

-(NSInteger)numColsToDraw
{
  return _numCols;
  NSInteger numColsToShow = _numCols;
  if(_showFilteredColumns == NO && [self filterColumns] != nil && [[self filterColumns] count] < _numCols)
  {
    numColsToShow = _numCols - [[self filterColumns] count];
  }
  return numColsToShow;
}

-(NSInteger)numRowsToDraw
{
  return _numRows;
  NSInteger numRowsToShow = _numRows;
  if(_showFilteredRows == NO && [self filterRows] != nil && [[self filterRows] count] < _numRows)
  {
    numRowsToShow = _numRows - [[self filterRows] count];
  }
  return numRowsToShow;
}

- (NSRect)rectOfCellAtColumn:(NSUInteger)column row:(NSUInteger)row {
  NSRect frame = [self frame];
  
  CGFloat cellWidth = frame.size.width / [self numColsToDraw];
  CGFloat cellHeight = frame.size.height / [self numRowsToDraw];
  CGFloat x = column * cellWidth;
  CGFloat y = row * cellHeight;
  NSRect rect = NSMakeRect(x, y, cellWidth, cellHeight);
  NSAlignmentOptions alignOpts = NSAlignMinXNearest | NSAlignMinYNearest |
  NSAlignMaxXNearest | NSAlignMaxYNearest ;
  return [self backingAlignedRect:rect options:alignOpts];
}


@end
