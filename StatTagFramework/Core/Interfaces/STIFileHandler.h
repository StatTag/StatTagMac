//
//  STIFileHandler.h
//  StatTag
//
//  Created by Eric Whitley on 6/17/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STIFileHandler <NSObject>

- (NSArray*) ReadAllLines:(NSURL*)filePath error:(NSError**)error;
- (BOOL) Exists:(NSURL*)filePath error:(NSError**)error;
- (void) Copy:(NSURL*)sourceFile toDestinationFile: (NSURL*)destinationFile error:(NSError**)error;
- (void) WriteAllLines:(NSURL*)filePath withContent: (NSArray*)content error:(NSError**)error;
- (void) WriteAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error;

- (void) AppendAllText:(NSURL*)filePath withContent: (NSString*)content error:(NSError**)error;

- (void) Move:(NSURL*)sourceFileName destFileName:(NSURL*)destFileName error:(NSError**)error;
- (void) Delete:(NSURL*)path error:(NSError**)error;

-(NSFileHandle*)OpenWrite:(NSURL*)filePath;

@end
