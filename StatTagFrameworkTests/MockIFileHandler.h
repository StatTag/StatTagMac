//
//  MockIFileHandler.h
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatTag.h"

//MARK: "mock" IFileHandler
/*
 Tried to use various mocking frameworks like OCMock, OCMockito, etc., but our 32bit requirement is an issue here.
 
 So - instead... we're just faking a mock object with a "convenience" class using blocks.
 
 ala: https://www.objc.io/issues/15-testing/mocking-stubbing/
 */

@interface MockIFileHandler : NSObject<STIFileHandler> {
  NSArray<NSString*>* _lines;
}
@property (readwrite, nonatomic, copy) NSArray<NSString*>* lines;
- (NSArray*) ReadAllLines:(NSURL*)filePath error:(NSError**)error;
- (BOOL) Exists:(NSURL*)filePath error:(NSError**)error;
- (void) Copy:(NSURL*)sourceFile toDestinationFile: (NSURL*)destinationFile error:(NSError**)error;
- (void) WriteAllLines:(NSURL*)filePath withContent: (NSArray*)content error:(NSError**)error;
- (void) WriteAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error;
@end
