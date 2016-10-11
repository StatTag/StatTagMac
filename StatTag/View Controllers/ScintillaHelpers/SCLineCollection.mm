//
//  LineCollection.m
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "SCLineCollection.h"
#import "SCLine.h"
#import "SCHelpers.h"
#import "SCScintilla.h"
#import "Scintilla/Scintilla.h"
#import "Scintilla/ScintillaView.h"
#import "SCPerLine.h"

@implementation SCLineCollection

//@synthesize Count = _Count;
@synthesize scintilla = _scintilla;
//@synthesize lines = _lines;



NSMutableArray<SCPerLine*>* _perLineData;

// The 'step' is a break in the continuity of our line starts. It allows us
// to delay the updating of every line start when text is inserted/deleted.
NSInteger stepLine;
NSInteger stepLength;

-(id)initWithScintilla:(SCScintilla*)sc
{
  self = [super init];
  if(self) {
    _scintilla = sc;
    _lines = [[NSMutableArray<SCLine*> alloc] init];
    _perLineData = [[NSMutableArray<SCPerLine*> alloc] init];
    [self populateLinesFromContent: [[_scintilla scintillaView] string]];
    
//    this.perLineData = new GapBuffer<PerLine>();
//    this.perLineData.Add(new PerLine { Start = 0 });
//    this.perLineData.Add(new PerLine { Start = 0 }); // Terminal
    
  }
  return self;
}

-(void)populateLinesFromContent:(NSString*)content
{
  //NSArray<NSString*>* ca = [content componentsSeparatedByString:@"\r\n"];
  //for(NSString* c in ca) {
  //
  //}
  long numLines = [[content componentsSeparatedByString:@"\r\n"] count];
  int i;
  for(i = 0; i < numLines; i ++ ) {
    SCLine* line = [self addLineAtIndex:i];
    [_lines addObject:line];
  }
}


/// <summary>
/// Adjust the number of CHARACTERS in a line.
/// </summary>
-(void)AdjustLineLength:(int)index delta:(int)delta
{
  [self MoveStep: index];
  stepLength += delta;
  
  // Invalidate multibyte flag
  SCPerLine* perLine = _perLineData[index];
  perLine.ContainsMultibyte = Unknown;
  _perLineData[index] = perLine;
}

/// <summary>
/// Converts a BYTE offset to a CHARACTER offset.
/// </summary>
-(NSInteger)ByteToCharPosition:(NSInteger) pos
{
//  Debug.Assert(pos >= 0);
//  Debug.Assert(pos <= scintilla.DirectMessage(NativeMethods.SCI_GETLENGTH).ToInt32());
  
  NSInteger line = [ScintillaView directCall:[_scintilla scintillaView] message:SCI_LINEFROMPOSITION wParam:pos lParam:0];
  NSInteger byteStart = [ScintillaView directCall:[_scintilla scintillaView] message:SCI_POSITIONFROMLINE wParam:line lParam:0];

  NSInteger count = [self CharPositionFromLine: line] + [self GetCharCount: byteStart length:pos - byteStart];

  //FIXME: all of this...
  
  return count;
}

/// <summary>
/// Returns the number of CHARACTERS in a line.
/// </summary>
-(NSInteger)CharLineLength:(NSInteger) index
{
//  Debug.Assert(index >= 0);
//  Debug.Assert(index < Count);
  
  // A line's length is calculated by subtracting its start offset from
  // the start of the line following. We keep a terminal (faux) line at
  // the end of the list so we can calculate the length of the last line.
  
  if (index + 1 <= stepLine)
    return _perLineData[index + 1].Start - _perLineData[index].Start;
  else if (index <= stepLine)
    return (_perLineData[index + 1].Start + stepLength) - _perLineData[index].Start;
  else
    return (_perLineData[index + 1].Start + stepLength) - (_perLineData[index].Start + stepLength);
}

/// Returns the CHARACTER offset where the line begins.
-(NSInteger)CharPositionFromLine:(NSInteger)index
{
  //  Debug.Assert(index >= 0);
  //  Debug.Assert(index < perLineData.Count); // Allow query of terminal line start
  
  NSInteger start = _perLineData[index].Start;
  if (index > stepLine)
    start += stepLength;
  
  return start;
}


-(NSInteger)CharToBytePosition:(NSInteger) pos
{
//  Debug.Assert(pos >= 0);
//  Debug.Assert(pos <= TextLength);
  
  // Adjust to the nearest line start
  NSInteger line = [self LineFromCharPosition: pos];
  
  //FIXME: not implemented
//  var bytePos = scintilla.DirectMessage(NativeMethods.SCI_POSITIONFROMLINE, new IntPtr(line)).ToInt32();
//  
  NSInteger bytePos = [ScintillaView directCall:[_scintilla scintillaView] message:SCI_POSITIONFROMLINE wParam:line lParam:0];

  
  pos -= [self CharPositionFromLine: line];
  
  // Optimization when the line contains NO multibyte characters
  if (![self LineContainsMultibyteChar: line]) {
    return (bytePos + pos);
  }
  
  while (pos > 0)
  {
    // Move char-by-char
    bytePos = [ScintillaView directCall:[_scintilla scintillaView] message:SCI_POSITIONRELATIVE wParam:bytePos lParam:1];
    pos--;
  }
  
  return bytePos;
}

-(void)DeletePerLine:(int)index
{
//  Debug.Assert(index != 0);
  
  [self MoveStep: index];
  
  // Subtract the line length
  stepLength -= [self CharLineLength: index];
  
  // Remove the line
  [_perLineData removeObjectAtIndex:index];
  
  // Move the step to the line before the one removed
  stepLine--;
}


/// <summary>
/// Gets the number of CHARACTERS int a BYTE range.
/// </summary>
-(NSInteger)GetCharCount:(NSInteger)pos length:(NSInteger)length
{
  NSInteger ptr = [ScintillaView directCall:[_scintilla scintillaView] message:SCI_GETRANGEPOINTER wParam:pos lParam:length];
  return [self GetCharCount:ptr length:length];
  //GetCharCount(ptr, length, scintilla.Encoding);
  //FIXME: go back and review encoding from scintilla vs encoding from the string
}

/// <summary>
/// Gets the number of CHARACTERS in a BYTE range.
/// </summary>
+(NSInteger)GetCharCount:(NSString*)text length:(NSInteger)length //Encoding encoding)
{
  if (text == nil || length == 0)
    return 0;
  
  // Never use SCI_COUNTCHARACTERS. It counts CRLF as 1 char!
  //var count = encoding.GetCharCount((byte*)text, length);
  // this is not a great idea for Unicode
  //FIXME: this is flat out wrong because we're ignoring encoding
  NSInteger count = [text length];//???????
  return count;
}

/// <summary>
/// Gets a value indicating whether all the document lines are visible (not hidden).
/// </summary>
/// <returns>true if all the lines are visible; otherwise, false.</returns>
-(BOOL)AllLinesVisible
{
  return [ScintillaView directCall:[_scintilla scintillaView] message:SCI_GETALLLINESVISIBLE wParam:0 lParam:0] != 0;
}

-(NSInteger)Count {
  
  // Subtract the terminal line
//  return (perLineData.Count - 1);
  return [_lines count];
}

-(SCLine*)addLineAtIndex:(NSInteger)index
{
  index = [SCHelpers Clamp:index min:0 max: [self Count] - (long)1]; //Clamp(index, 0, Count - 1);
//  index = [SCHelpers Clamp:index min:0 max: [self Count]]; //Clamp(index, 0, Count - 1);
  SCLine* line = [[SCLine alloc] initWithScintilla:_scintilla atIndex:index];
  return line;
}

-(NSArray<SCLine*>*)Lines {
  return _lines;
}

-(BOOL)LineContainsMultibyteChar:(NSInteger)index
{
  SCPerLine* perLine = _perLineData[index];
  if (perLine.ContainsMultibyte == Unknown)
  {
    perLine.ContainsMultibyte = [ScintillaView directCall:[_scintilla scintillaView] message:SCI_LINELENGTH wParam:index lParam:0] == [self CharLineLength:index] ? No : Yes;
    _perLineData[index] = perLine;
  }
  
  return (perLine.ContainsMultibyte == Yes);
}

/// Returns the line index containing the CHARACTER position.
-(NSInteger)LineFromCharPosition:(NSInteger)pos
{
  //Debug.Assert(pos >= 0);
  
  // Iterative binary search
  // http://en.wikipedia.org/wiki/Binary_search_algorithm
  // System.Collections.Generic.ArraySortHelper.InternalBinarySearch
  
  NSInteger low = 0;
  NSInteger high = [self Count] - 1;
  
  while (low <= high)
  {
    NSInteger mid = low + ((high - low) / 2);
    NSInteger start = [self CharPositionFromLine: mid];
    
    if (pos == start)
      return mid;
    else if (start < pos)
      low = mid + 1;
    else
      high = mid - 1;
  }
  
  // After while exit, 'low' will point to the index where 'pos' should be
  // inserted (if we were creating a new line start). The line containing
  // 'pos' then would be 'low - 1'.
  return low - 1;
}



/// <summary>
/// Tracks a new line with the given CHARACTER length.
/// </summary>
-(void)InsertPerLine:(NSInteger)index length:(NSInteger)length
{
  [self MoveStep: index];
  
  SCPerLine* data;
  NSInteger lineStart = 0;
  
  // Add the new line length to the existing line start
  data = _perLineData[index];
  lineStart = data.Start;
  data.Start += length;
  _perLineData[index] = data;
  
  // Insert the new line
  data = [[SCPerLine alloc] initWithStart:lineStart andContainsMultibyte: Unknown];
  [_perLineData insertObject:data atIndex:index];
  
  // Move the step
  stepLength += length;
  stepLine++;
}

-(void) MoveStep:(NSInteger) line
{
  if (stepLength == 0)
  {
    stepLine = line;
  }
  else if (stepLine < line)
  {
    SCPerLine* data;
    while (stepLine < line)
    {
      stepLine++;
      data = _perLineData[stepLine];
      data.Start += stepLength;
      _perLineData[stepLine] = data;
    }
  }
  else if (stepLine > line)
  {
    SCPerLine* data;
    while (stepLine > line)
    {
      data = _perLineData[stepLine];
      data.Start -= stepLength;
      _perLineData[stepLine] = data;
      stepLine--;
    }
  }
}

-(void)RebuildLineData
{
  stepLine = 0;
  stepLength = 0;
  
  _perLineData = [[NSMutableArray<SCPerLine*> alloc] init];
  [_perLineData addObject:[[SCPerLine alloc] initWithStart:0 andContainsMultibyte: Unknown]];
  [_perLineData addObject:[[SCPerLine alloc] initWithStart:0 andContainsMultibyte: Unknown]]; // Terminal

  //FIXME: deal with this...
//  // Fake an insert notification
//  var scn = new NativeMethods.SCNotification();
//  scn.linesAdded = scintilla.DirectMessage(NativeMethods.SCI_GETLINECOUNT).ToInt32() - 1;
//  scn.position = 0;
//  scn.length = scintilla.DirectMessage(NativeMethods.SCI_GETLENGTH).ToInt32();
//  scn.text = scintilla.DirectMessage(NativeMethods.SCI_GETRANGEPOINTER, new IntPtr(scn.position), new IntPtr(scn.length));
//  TrackInsertText(scn);
}

@end
