//
//  TagGridView.m
//  StatTag
//
//  Created by Eric Whitley on 10/6/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagGridView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TagGridView

@synthesize filterColumns = _filterColumns;
@synthesize filterRows = _filterRows;

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

-(void)setFilterColumns:(NSArray<NSNumber *> *)filterColumns
{
  _filterColumns = filterColumns;
  NSInteger maxVal = [[_filterColumns valueForKeyPath:@"@max.intValue"] intValue] + 1;//vals are 0-based indexes
  if(maxVal > [self numCols])
  {
    [self setNumCols:maxVal];
  }
}
-(NSArray<NSNumber *> *)filterColumns
{
  return _filterColumns;
}

-(void)setFilterRows:(NSArray<NSNumber *> *)filterRows
{
  _filterRows = filterRows;
  NSInteger maxVal = [[_filterRows valueForKeyPath:@"@max.intValue"] intValue] + 1;//vals are 0-based indexes
  if(maxVal > [self numRows])
  {
    [self setNumRows:maxVal];
  }
}
-(NSArray<NSNumber *> *)filterRows
{
  return _filterRows;
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
//    CGSize size = CGSizeMake(200, 200);
//    NSImage* pat = [self drawStripedBoxWithSize:size withBackgroundColor:[NSColor redColor] andStrokeColor:[NSColor whiteColor] withLineWidth:1.0 atAtAngle:45 andSpaceBetweenLine:2.0];
//    if(pat != nil) {
//      _cellFillColor = [NSColor colorWithPatternImage:pat];
//    }
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
//  NSInteger numColsToShow = _numCols;
//  if(_showFilteredColumns == NO && [self filterColumns] != nil && [[self filterColumns] count] < _numCols)
//  {
//    numColsToShow = _numCols - [[self filterColumns] count];
//  }
//  return numColsToShow;
}

-(NSInteger)numRowsToDraw
{
  return _numRows;
//  NSInteger numRowsToShow = _numRows;
//  if(_showFilteredRows == NO && [self filterRows] != nil && [[self filterRows] count] < _numRows)
//  {
//    numRowsToShow = _numRows - [[self filterRows] count];
//  }
//  return numRowsToShow;
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

//
//-(NSImage*)drawStripedBoxWithSize:(CGSize)size withBackgroundColor:(NSColor*)bgColor andStrokeColor:(NSColor*)strokeColor withLineWidth:(CGFloat)lineWidth atAtAngle:(CGFloat)angle andSpaceBetweenLine:(CGFloat)space
//{
//
////  NSImage *bgImage = [[NSImage alloc] initWithSize:size];
////  [bgImage lockFocus];
//
//  CIContext *context = [CIContext contextWithOptions:nil];
//  CIFilter *filter = [CIFilter filterWithName:@"CIStripesGenerator"];
//  [filter setDefaults];
//  [filter setValue:bgColor forKey:@"inputColor0"];
//  [filter setValue:strokeColor forKey:@"inputColor1"];
//  // 2
//  CGImageRef cgimg =
//  [context createCGImage:filter.outputImage fromRect:CGRectMake(0, 0, size.width, size.height)];
//  // 3
//  NSImage *bgImage = [[NSImage alloc] initWithCGImage:cgimg size:size];
//  // 4
//  CGImageRelease(cgimg);
//  
////  [bgImage unlockFocus];
//
//  return bgImage;
//  
////  return bgImage;
//
////  //NSImage *bigImage = [[[NSImagealloc] initWithSize:size] autorelease];
////  CGSize doubledSize = CGSizeMake(size.height * 2.0, size.width * 2.0);
////  NSImage* bgImage = [[NSImage alloc] initWithSize:doubledSize];
//// 
////
////  [bgImage lockFocus];
////  
//////  NSImage *bg = [NSImageimageNamed:@"bg"];
//////  NSColor *backgroundColor = [NSColorcolorWithPatternImage:bg];
//////  [backgroundColor set];
//////  NSRectFill([selfbounds]);
////
////  
////
////  CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
////
////
////  
////  [bgColor set];
////  
//////  NSRect rect = NSInsetRect([self rectOfCellAtColumn:x row:0], 0.5, 0.5);
////  
////  CGContextClearRect(context, NSMakeRect(0, 0, doubledSize.width, doubledSize.height));
////  
////  //filled w/ our background
////  CGContextSetFillColorWithColor(context, [bgColor CGColor]);
////  //CGContextFillEllipseInRect(context, NSMakeRect(0, 0, size.width, size.height));
////
////  CGContextTranslateCTM(context, doubledSize.width/2, doubledSize.height/2);
////  //move our origin point to the center so when we rotate we keep relative position
////  CGFloat radians = M_PI*angle/180;
////  CGContextRotateCTM(context, radians);
////  
////  NSInteger numLines = size.width / (lineWidth + space);
////  
////  for(NSInteger x = 0; x < numLines; x++)
////  {
////    NSRect rect = NSMakeRect(x * (lineWidth + space), 0, lineWidth, size.height);
////    CGPathRef path = CGPathCreateWithRect(rect, NULL);
////    [strokeColor setFill];
////    CGContextAddPath(context, path);
////    CGContextDrawPath(context, kCGPathFillStroke);
////    CGPathRelease(path);
////  }
////  
////
////  
////  //CGContextTranslateCTM(context, 0, 0);
////
//////  CGPathRef path = CGPathCreateWithRect(rect, NULL);
//////  [[UIColor redColor] setFill];
//////  [[UIColor greenColor] setStroke];
//////  CGContextAddPath(context, path);
//////  CGContextDrawPath(context, kCGPathFillStroke);
//////  CGPathRelease(path);
////  
////  //NSBezierPath strokePath = [NSBezierPath ]
////  
//////  let color1Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: color1Width, height: color1Height))
//////  color1.setFill()
//////  color1Path.fill()
////
////  
//////  [_headerFillColor set];
//////  [NSBezierPath fillRect:rect];
////  
////  //viewPattern.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*135/180))
////  
////  
////  [bgImage unlockFocus];
////  
////  
////  //NSBitmapImageRep *imgRep = [[toSave representations] objectAtIndex: 0];
////  //NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
////
////  return bgImage;
//}



@end
