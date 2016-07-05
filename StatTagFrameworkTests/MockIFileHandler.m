//
//  MockIFileHandler.m
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "MockIFileHandler.h"

@implementation MockIFileHandler

@synthesize lines = _lines;
@synthesize exists = _exists;
@synthesize Copy_wasCalled = _Copy_wasCalled;
@synthesize WriteAllLines_wasCalled = _WriteAllLines_wasCalled;
@synthesize WriteAllText_wasCalled = _WriteAllText_wasCalled;
@synthesize ReadAllLines_wasCalled = _ReadAllLines_wasCalled;

-(instancetype)init {
  self = [super init];
  if(self) {
    _exists = false;
    _Copy_wasCalled = 0;
    _WriteAllLines_wasCalled = 0;
    _WriteAllText_wasCalled = 0;
    _ReadAllLines_wasCalled = 0;
  }
  return self;
}

- (NSArray*) ReadAllLines:(NSURL*)filePath error:(NSError**)error {
  _ReadAllLines_wasCalled = _ReadAllLines_wasCalled + 1;
  return [self lines];
}
- (BOOL) Exists:(NSURL*)filePath error:(NSError**)error {
  return _exists;
}
- (void) Copy:(NSURL*)sourceFile toDestinationFile: (NSURL*)destinationFile error:(NSError**)error {
  _Copy_wasCalled = _Copy_wasCalled + 1;
}
- (void) WriteAllLines:(NSURL*)filePath withContent: (NSArray*)content error:(NSError**)error {
  //self.lines = content;
  _WriteAllLines_wasCalled = _WriteAllLines_wasCalled + 1;
}
- (void) WriteAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error {
  //self.lines = [NSArray arrayWithObject:content];
  _WriteAllText_wasCalled = _WriteAllText_wasCalled + 1;
}
@end
