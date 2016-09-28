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
  long _Count;
  NSMutableArray<SCLine*>* _lines;
}

@property (strong, nonatomic) SCScintilla* scintilla;
@property (nonatomic) long Count;
//@property (strong, nonatomic) NSArray<SCLine*>* lines;

-(id)initWithScintilla:(SCScintilla*)sc;
-(NSArray<SCLine*>*)Lines;

@end
