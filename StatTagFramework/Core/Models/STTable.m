//
//  STTable.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTable.h"
#import "STTableData.h"

@implementation STTable

@synthesize RowSize = _RowSize;
@synthesize ColumnSize = _ColumnSize;
@synthesize Data = _Data; //type is double
@synthesize FormattedCells = _FormattedCells;

-(id)init {
  self = [super init];
  if(self) {
    _Data = [[STTableData alloc] init];//[[NSMutableArray alloc] init];
  }
  return self;
}

-(id)init:(NSInteger)rowSize columnSize:(NSInteger)columnSize data:(STTableData*)data {
  self = [super init];
  if(self) {

    if ((data == nil && (rowSize * columnSize != 0))
        || (data != nil
            && ([data numRows] != rowSize
                || [data numColumns] != columnSize)))
    {
      [NSException raise:@"The dimensions of the data do not match the row and column dimensions." format:@"The dimensions of the data do not match the row and column dimensions."];
    }
    
    _RowSize = rowSize;
    _ColumnSize = columnSize;
    _Data = data;//[[NSMutableArray alloc] initWithArray:data];
  }
  return self;
}

/**
 @brief Determines if this table is empty - meaning it has no data, or does not have a column or row dimension specified.
 @returns true if empty, false otherwise
 */
-(BOOL)isEmpty {
  return (_Data == nil || [_Data numRows] == 0 || _RowSize == 0 || _ColumnSize == 0);
}


/**
 Our approach has been to sequentially number table cells, so this is used to pull out data at the appropriate 2D location.
*/
+(NSString*)GetDataAtIndex:(STTableData*)data index:(NSInteger)index
{
  if (data == nil || index >= [data numItems])
  {
    return @"";
  }
  
  return [data GetDataAtIndex:index];
  
  //NSInteger columns = [data numColumns];
  //return [data valueAtRow:(index / columns) andColumn:(index % columns)];
  //  return [[[data Data] objectAtIndex:(index / columns)] objectAtIndex:(index % columns)];
}

-(NSString*)ToString {
  //FIXME: the original code makes use of ToString in places, but it's not clear how the default implementation works (STTableFormat)
  //for now, it appears the original c# just returns class name as the default ToString
  
  //return @"Table";
  return NSStringFromClass([self class]);
  
}
-(NSString*)description {
  return [self ToString];
}





//MARK: JSON
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];  
  //[dict setValue:[self RowNames] forKey:@"RowNames"];
  //[dict setValue:[self ColumnNames] forKey:@"ColumnNames"];
  [dict setValue:[NSNumber numberWithInteger:[self RowSize]] forKey:@"RowSize"];
  [dict setValue:[NSNumber numberWithInteger:[self ColumnSize]] forKey:@"ColumnSize"];
  [dict setValue:[[self Data] toDictionary] forKey:@"Data"];
  [dict setValue:[self FormattedCells] forKey:@"FormattedCells"];
  
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    if([key isEqualToString:@"Data"]) {
      id aValue = [dict valueForKey:key];
      NSDictionary *objDict = aValue;
      if(objDict != nil) {
        [self setValue:[[STTableData alloc] initWithDictionary:objDict] forKey:key];
      }
    } else {
      [self setValue:[dict valueForKey:key] forKey:key];
    }
  }
}

-(NSString*)Serialize:(NSError**)outError
{
  return [STJSONUtility SerializeObject:self error:nil];
}

+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
  return [STJSONUtility SerializeList:list error:nil];
}

+(NSArray<STTable*>*)DeserializeList:(id)List error:(NSError**)outError
{
  NSMutableArray<STTable*>* ar = [[NSMutableArray<STTable*> alloc] init];
  for(id x in [STJSONUtility DeserializeList:List forClass:[self class] error:nil]) {
    if([x isKindOfClass:[self class]])
    {
      [ar addObject:x];
    }
  }
  return ar;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
  self = [super init];
  if (self) {
    [self setWithDictionary:dict];
  }
  return self;
}

-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
{
  self = [super init];
  if (self) {
    
    NSError *error = nil;
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (!error && JSONDictionary) {
      [self setWithDictionary:JSONDictionary];
    } else {
      if (outError) {
        *outError = [NSError errorWithDomain:STStatTagErrorDomain
                                        code:[error code]
                                    userInfo:@{NSUnderlyingErrorKey: error}];
      }
    }
  }
  return self;
}


@end
