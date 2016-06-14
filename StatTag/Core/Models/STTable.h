//
//  STTable.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief A table is a generic representation of a matrix, vector, list, etc. from different
        statistical packages.  It provides a consistent interface across the statistical
        package representations, but is not necessarily an optimized view of the data.

 */
@interface STTable : NSObject {
  NSMutableArray<NSString *> *RowNames;
  NSMutableArray<NSString *> *ColumnNames;
  int RowSize;
  int ColumnSize;
  NSMutableArray<NSNumber *> *Data; //type is double
  NSMutableArray<NSString *> *FormattedCells;
}

@property NSMutableArray<NSString *> *RowNames;
@property NSMutableArray<NSString *> *ColumnNames;
@property int RowSize;
@property int ColumnSize;
@property NSMutableArray<NSNumber *> *Data; //type is double
@property NSMutableArray<NSString *> *FormattedCells;

-(id)init;
-(id)init:(NSArray <NSString *>*)rowNames columnNames:(NSArray <NSString *>*)columnNames rowSize:(int)rowSize columnSize:(int)columnSize data:(NSArray <NSNumber *>*)data;
-(BOOL)isEmpty;
-(NSString*)ToString;

@end
