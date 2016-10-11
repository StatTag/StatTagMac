//
//  LineCollection.h
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCScintilla;
@class SCLine;

@interface SCLineCollection : NSObject {
  SCScintilla* _scintilla;
  //long _Count;
  NSMutableArray<SCLine*>* _lines;
}

@property (strong, nonatomic) SCScintilla* scintilla;
//@property (nonatomic) long Count;
//@property (strong, nonatomic) NSArray<SCLine*>* lines;


-(id)initWithScintilla:(SCScintilla*)sc;



/// Adjust the number of CHARACTERS in a line.
-(void)AdjustLineLength:(int)index delta:(int)delta;

/// Converts a BYTE offset to a CHARACTER offset.

/// Returns the number of CHARACTERS in a line.
-(NSInteger)CharLineLength:(NSInteger) index;

/// Returns the CHARACTER offset where the line begins.
-(NSInteger)CharPositionFromLine:(NSInteger)index;

-(NSInteger)CharToBytePosition:(NSInteger) pos;

-(void)DeletePerLine:(int)index;

/// Gets the number of CHARACTERS int a BYTE range.
-(NSInteger)GetCharCount:(NSInteger)pos length:(NSInteger)length;


/// Gets the number of CHARACTERS in a BYTE range.
+(NSInteger)GetCharCount:(NSString*)text length:(NSInteger)length; //Encoding encoding);

/// Gets a value indicating whether all the document lines are visible (not hidden).
/// @returns true if all the lines are visible; otherwise, false.
-(BOOL)AllLinesVisible;

-(NSInteger)Count;

-(SCLine*)addLineAtIndex:(NSInteger)index;

-(NSArray<SCLine*>*)Lines;

-(BOOL)LineContainsMultibyteChar:(NSInteger)index;

/// Returns the line index containing the CHARACTER position.
-(NSInteger)LineFromCharPosition:(NSInteger)pos;


/// Tracks a new line with the given CHARACTER length.
-(void)InsertPerLine:(NSInteger)index length:(NSInteger)length;

-(void) MoveStep:(NSInteger) line;

-(void)RebuildLineData;



@end
