//
//  STExecutionStep.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STTag;

@interface STExecutionStep : NSObject {
  int Type;
  NSMutableArray<NSString*>* Code;
  NSMutableArray<NSString*>* Result;
  //FIXME:    public Tag Tag { get; set; }
  STTag *Tag;
}

@property int Type;
@property NSMutableArray<NSString*>* Code;
@property NSMutableArray<NSString*>* Result;
//FIXME:    public Tag Tag { get; set; }
@property STTag *Tag;

@end
