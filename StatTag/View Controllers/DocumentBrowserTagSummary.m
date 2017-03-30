//
//  DocumentBrowserTagSummary.m
//  StatTag
//
//  Created by Eric Whitley on 3/28/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "DocumentBrowserTagSummary.h"

@implementation DocumentBrowserTagSummary

@synthesize tagGroupTitle = _tagGroupTitle;
@synthesize tagType = _tagType;
@synthesize tagCount = _tagCount;


-(instancetype)init {
  self = [super init];
  if(self){
    _tagGroupTitle = [[NSString alloc] init];
    _tagType = TagIndicatorViewTagTypeNormal;
    _tagCount = 0;
  }
  return self;
}

-(instancetype)initWithTitle:(NSString*)title andType:(TagIndicatorViewTagType)type andCount:(NSInteger)count {
  self = [super init];
  if(self){
    _tagType = type;
    _tagGroupTitle = title;
    _tagCount = count;
  }
  return self;
}


@end
