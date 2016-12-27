//
//  TagGridView.h
//  StatTag
//
//  Created by Eric Whitley on 10/6/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TagGridView : NSView

//@property NSInteger gridSize;
@property BOOL useColumnLabels;
@property BOOL useRowLabels;
@property (copy, nonatomic) NSString* previewText;

@property (copy, nonatomic) NSColor* cellLineColor;
@property (copy, nonatomic) NSColor* cellFillColor;
@property (copy, nonatomic) NSColor* headerFillColor;
@property (copy, nonatomic) NSColor* headerLineColor;

@property NSInteger numRows;
@property NSInteger numCols;

@property BOOL showFilteredRows;
@property BOOL showFilteredColumns;
@property (copy, nonatomic) NSColor* filteredColumnColor;
@property (copy, nonatomic) NSColor* filteredRowColor;
@property (copy, nonatomic) NSArray<NSNumber*>* filterRows;
@property (copy, nonatomic) NSArray<NSNumber*>* filterColumns;

@end
