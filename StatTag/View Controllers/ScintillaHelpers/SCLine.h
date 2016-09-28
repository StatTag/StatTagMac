//
//  SCLine.h
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCScintilla;

@interface SCLine : NSObject {
  SCScintilla* _scintilla;
  long _Index;
}

@property (strong, nonatomic) SCScintilla* scintilla;
@property (nonatomic) long Index;

-(int)Height;
-(int)Length;
-(void) EnsureVisible;

-(id)initWithScintilla:(SCScintilla*)sc atIndex:(long)index;

@end
