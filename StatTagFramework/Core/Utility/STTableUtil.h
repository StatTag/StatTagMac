//
//  STTableUtil.h
//  StatTag
//
//  Created by Eric Whitley on 12/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STTableData;
@class STTableFormat;

@interface STTableUtil : NSObject


/**
 Some statistical packages (Stata for sure, but there may be others) give us row names, column names and data as separate flat vectors.  This handles merging them into a 2D array with the data in the appropriate cells.
 
 @param rowNames : An array of row names.  If this is null or empty, no row names are added.
 @param columnNames : An array of the column names.  If this is null or empty, no column names are added.
 @param data : A vector containing the data for the array.  It is assumed this is laid out by row.
 @param totalRows : The total number of rows - this should be a combination of column names and data rows
 @param totalColumns : The total number of columns - this should be a combination of row names and data rows
 */
+(STTableData*)MergeTableVectorsToArray:(NSArray<NSString*>*)rowNames columnNames:(NSArray<NSString*>*)columnNames data:(NSArray<NSString*>*)data totalRows:(NSInteger)totalRows totalColumns:(NSInteger)totalColumns;

/**
 Our data collections will include all cells - even if the user said they should be excluded.
 
 The purpose of this utility function is to take the 2D data array, remove the columns and rows that need to be excluded, and flatten it into a vector.
 
 The reason we flatten it is Word uses a vector of cells that we will fill, so this eases the mapping into that structure.
 */
+(NSArray<NSString*>*)GetDisplayableVector:(STTableData*)data format:(STTableFormat*)format;

@end
