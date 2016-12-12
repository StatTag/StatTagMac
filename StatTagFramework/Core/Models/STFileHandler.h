//
//  STFileHandler.h
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIFileHandler.h"

/**
 @brief Lightweight wrapper on top of the File class from System.IO (.NET)
 */
@interface STFileHandler : NSObject<STIFileHandler> {
  
}


- (NSArray*) ReadAllLines:(NSURL*)filePath error:(NSError**)error;

+ (NSString*) ReadAllLinesAsStringBlock:(NSURL*)filePath error:(NSError**)error;
- (NSString*) ReadAllLinesAsStringBlock:(NSURL*)filePath error:(NSError**)error;

- (BOOL) Exists:(NSURL*)filePath error:(NSError**)error;
+ (BOOL) Exists:(NSURL*)filePath error:(NSError**)error;
- (void) Copy:(NSURL*)sourceFile toDestinationFile: (NSURL*)destinationFile error:(NSError**)error;
- (void) WriteAllLines:(NSURL*)filePath withContent: (NSArray*)content error:(NSError**)error;
- (void) WriteAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error;

- (void) AppendAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error;
-(NSFileHandle*)OpenWrite:(NSURL*)filePath;


@end
