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
  NSString* _ValueResult;
  NSString* _FigureResult;
  STTable* _TableResult;
}

@property (copy, nonatomic) NSString* ValueResult;
@property (copy, nonatomic) NSString* FigureResult;
@property (strong, nonatomic) STTable* TableResult;

-(BOOL)IsEmpty;
-(NSString*)ToString;

@end
