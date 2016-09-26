//
//  NSMutableArray+Stack.h
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides a simple Stack-like set of methods for NSMutableArray so we can approximate the C# stack used in FieldCreator
 
 We need basic "LIFO" (last-in-first-out) behavior.
 */
@interface NSMutableArray (Stack)
- (void) push: (id)item;
- (id) pop;
- (id) peek;
@end
