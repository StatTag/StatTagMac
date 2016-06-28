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
- (NSArray*) ReadAllLines:(NSURL*)filePath error:(NSError**)error {
  return [self lines];
}
- (BOOL) Exists:(NSURL*)filePath error:(NSError**)error {
  return true;
}
- (void) Copy:(NSURL*)sourceFile toDestinationFile: (NSURL*)destinationFile error:(NSError**)error {
}
- (void) WriteAllLines:(NSURL*)filePath withContent: (NSArray*)content error:(NSError**)error {
  self.lines = content;
}
- (void) WriteAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error {
  self.lines = [NSArray arrayWithObject:content];
}
@end
