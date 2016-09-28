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

@implementation SCLineCollection

//@synthesize Count = _Count;
@synthesize scintilla = _scintilla;
//@synthesize lines = _lines;

-(id)initWithScintilla:(SCScintilla*)sc
{
  self = [super init];
  if(self) {
    _scintilla = sc;
    _lines = [[NSMutableArray<SCLine*> alloc] init];
    [self populateLinesFromContent: [[_scintilla scintillaView] string]];
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

-(long)Count {
  return [_lines count];
}

-(SCLine*)addLineAtIndex:(long)index
{
  index = [SCHelpers Clamp:index min:0 max: [self Count] - (long)1]; //Clamp(index, 0, Count - 1);
//  index = [SCHelpers Clamp:index min:0 max: [self Count]]; //Clamp(index, 0, Count - 1);
  SCLine* line = [[SCLine alloc] initWithScintilla:_scintilla atIndex:index];
  return line;
}

-(NSArray<SCLine*>*)Lines {
  return _lines;
}

@end
