//
//  STCommandResult.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STTable;

@interface STCommandResult : NSObject {
  NSString* ValueResult;
  NSString* FigureResult;
  STTable *TableResult;
}

@property (nonatomic, copy) NSString* ValueResult;
@property (nonatomic, copy) NSString* FigureResult;
@property STTable *TableResult;

-(BOOL)IsEmpty;
-(NSString*)ToString;

@end
