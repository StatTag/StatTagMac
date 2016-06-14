//
//  STCodeFileAction.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCodeFileAction.h"

@implementation STCodeFileAction

@synthesize Label;
@synthesize Action;
@synthesize Parameter;

//FIXME: just blindly copying for now - this should probably be "description"
-(NSString*)ToString {
  return Label;
}
-(NSString*)description {
  return [self ToString];
}

@end
