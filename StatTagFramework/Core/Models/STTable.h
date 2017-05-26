//
//  STTable.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONAble.h"
#import "STConstants.h"
@class STTableData;

/**
  A table is a generic representation of a matrix, vector, list, etc. from different
  statistical packages.  It provides a consistent interface across the statistical
  package representations, but is not necessarily an optimized view of the data.
 */
@interface STTable : NSObject<STJSONAble> {
  NSInteger _RowSize;
  NSInteger _ColumnSize;
  STTableData* _Data; //type is double
  STTableData* _FormattedCells;
}

@property NSInteger RowSize;
@property NSInteger ColumnSize;
@property (strong, nonatomic) STTableData* Data;
/**
 The formatted cells will be filled for all values in the Data array (meaning, these
 two collections will always be the same size).  If the user chooses to filter out
 rows or columns, they will still be present in this collection.
 */
@property (strong, nonatomic) STTableData* FormattedCells;

-(id)init;
-(id)init:(NSInteger)rowSize columnSize:(NSInteger)columnSize data:(STTableData*)data;

-(BOOL)isEmpty;
-(NSString*)ToString; //used by STTableFormat


/**
 Our approach has been to sequentially number table cells, so this is used to pull out data at the appropriate 2D location.
 */
+(NSString*)GetDataAtIndex:(STTableData*)data index:(NSInteger)index;


//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
+(NSString*)SerializeList:(NSArray<STTable*>*)list error:(NSError**)error;
+(NSArray<STTable*>*)DeserializeList:(id)List error:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;


@end
