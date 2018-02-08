//
//  STCSVToTable.h
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STTable;

@interface STDataFileToTable : NSObject {
  
}


/**
 returns: An array containing the dimensions (R x C), or NULL if it could not determine the table size.
 */
+(NSArray<NSNumber*>*)GetCSVTableDimensions:(NSString*)tableFilePath;

/**
 returns: An array containing the dimensions (R x C), or NULL if it could not determine the table size.
 */
+(NSArray<NSNumber*>*)GetCSVTableDimensionsForPath:(NSURL*)tableFilePath;

/**
 Combines the different components of a matrix command into a single structure.
 */
+(STTable*)GetTableResult:(NSString*)tableFilePath;

/**
 Combines the different components of a matrix command into a single structure.
 */
+(STTable*)GetTableResultForPath:(NSURL*)tableFilePath;

@end
