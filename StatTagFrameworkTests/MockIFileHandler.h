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
  BOOL _exists;
  
  int _Copy_wasCalled;
  int _WriteAllLines_wasCalled;
  int _WriteAllText_wasCalled;
  int _ReadAllLines_wasCalled;
}
@property (readwrite, nonatomic, copy) NSArray<NSString*>* lines;
@property (readwrite, nonatomic) BOOL exists;
@property (readwrite, nonatomic) int Copy_wasCalled;
@property (readwrite, nonatomic) int WriteAllLines_wasCalled;
@property (readwrite, nonatomic) int WriteAllText_wasCalled;
@property (readwrite, nonatomic) int ReadAllLines_wasCalled;

- (NSArray*) ReadAllLines:(NSURL*)filePath error:(NSError**)error;
- (BOOL) Exists:(NSURL*)filePath error:(NSError**)error;
- (void) Copy:(NSURL*)sourceFile toDestinationFile: (NSURL*)destinationFile error:(NSError**)error;
- (void) WriteAllLines:(NSURL*)filePath withContent: (NSArray*)content error:(NSError**)error;
- (void) WriteAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error;
@end
