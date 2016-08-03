//
//  STTable.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTable.h"

@implementation STTable

@synthesize RowNames = _RowNames;
@synthesize ColumnNames = _ColumnNames;
@synthesize RowSize = _RowSize;
@synthesize ColumnSize = _ColumnSize;
@synthesize Data = _Data; //type is double
@synthesize FormattedCells = _FormattedCells;

-(id)init {
  self = [super init];
  if(self) {
    _RowNames = [[NSMutableArray alloc] init];
    _ColumnNames = [[NSMutableArray alloc] init];
  }
  return self;
}

-(id)init:(NSArray <NSString *>*)rowNames columnNames:(NSArray <NSString *>*)columnNames rowSize:(int)rowSize columnSize:(int)columnSize data:(NSArray <NSNumber *>*)data {
  self = [super init];
  if(self) {
    //note: original c# passes nil to the row/column name arrays if we send nil arguments
    //originally I had changed this to init the arrays, but this causes issues later with format checks (see STTableFormat where it checks if row/column name arrays are nil
    _RowNames = rowNames == nil ? nil : [[NSMutableArray alloc]initWithArray: rowNames];//[[NSMutableArray alloc] init];
    _ColumnNames = columnNames == nil ? nil : [[NSMutableArray alloc]initWithArray: columnNames];//[[NSMutableArray alloc] init];

    _RowSize = rowSize;
    _ColumnSize = columnSize;
    _Data = [[NSMutableArray alloc] initWithArray:data];
  }
  return self;
}

/**
 @brief Determines if this table is empty - meaning it has no data, or does not have a column or row dimension specified.
 @returns true if empty, false otherwise
 */
-(BOOL)isEmpty {
  return (_Data == nil || [_Data count] == 0 || _RowSize == 0 || _ColumnSize == 0);
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
  
  /*
   NSMutableArray<NSString*>* _RowNames;
   NSMutableArray<NSString*>* _ColumnNames;
   int _RowSize;
   int _ColumnSize;
   NSMutableArray<NSNumber*>* _Data; //type is double
   NSMutableArray<NSString*>* _FormattedCells;

   */
  
  [dict setValue:[self RowNames] forKey:@"RowNames"];
  [dict setValue:[self ColumnNames] forKey:@"ColumnNames"];
  [dict setValue:[NSNumber numberWithInteger:[self RowSize]] forKey:@"RowSize"];
  [dict setValue:[NSNumber numberWithInteger:[self ColumnSize]] forKey:@"ColumnSize"];
  [dict setValue:[self Data] forKey:@"Data"];
  [dict setValue:[self FormattedCells] forKey:@"FormattedCells"];
  
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    
//    if([key isEqualToString:@"RowSize"] || [key isEqualToString:@"ColumnSize"]) {
//      int i = [[dict valueForKey:key] integerValue];
//      [self setValue:@(i) forKey:key];
//    } else {
      [self setValue:[dict valueForKey:key] forKey:key];
//    }
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
