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
  int _Type;
  NSMutableArray<NSString*>* _Code;
  NSMutableArray<NSString*>* _Result;
  STTag* _Tag;
}

@property int Type;
@property (strong, nonatomic) NSMutableArray<NSString*>* Code;
@property (strong, nonatomic) NSMutableArray<NSString*>* Result;
//FIXME:    public Tag Tag { get; set; }
@property (strong, nonatomic) STTag *Tag;

@end
