//
//  STFigureFormat.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTableFormat.h"
#import "STTable.h"
#import "STIValueFormatter.h"
#import "STBaseValueFormatter.h"
#import "STFilterFormat.h"
#import "STTableData.h"

@implementation STTableFormat

@synthesize RowFilter = _RowFilter;
@synthesize ColumnFilter = _ColumnFilter;


//MARK: copying

-(id)copyWithZone:(NSZone *)zone
{
  STTableFormat *format = [[[self class] allocWithZone:zone] init];//[[STTableFormat alloc] init];
  
  format.RowFilter = [_RowFilter copyWithZone: zone];
  format.ColumnFilter = [_ColumnFilter copyWithZone: zone];

  return format;
}

-(instancetype) init
{
  self = [super init];
  if(self)
  {
    _RowFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Row]];
    _ColumnFilter = [[STFilterFormat alloc] initWithPrefix:[STConstantsFilterPrefix Column]];
  }
  return self;
}

//This is going to start out assuming left to right filling.  In the future
//this will have different fill options.
-(STTableData*)Format:(STTable*)tableData valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter {
  
  if(valueFormatter == nil) {
    valueFormatter = [[STBaseValueFormatter alloc] init];
  }
  
  
  if (tableData == nil || [tableData Data] == nil)
  {
    return [[STTableData alloc] init];
  }

//  BOOL canIncludeColumnNames = (_IncludeColumnNames && [tableData ColumnNames] != nil && [[tableData ColumnNames] count] > 0);
//
//  if (canIncludeColumnNames)
//  {
//    [formattedResults addObjectsFromArray:[tableData ColumnNames]];
//  }
//
//  BOOL canIncludeRowNames = (_IncludeRowNames && [tableData RowNames] != nil && [[tableData RowNames] count] > 0);

  //var formattedResults = new string[tableData.RowSize, tableData.ColumnSize];
  STTableData* formattedResults = [[STTableData alloc] init];
  
  for (NSInteger row = 0; row < [tableData RowSize]; row++)
  {
//    if (canIncludeRowNames)
//    {
//      [formattedResults addObject:[tableData RowNames][rowIndex]];
//    }
    //NSMutableArray<NSString*>* inner = [[NSMutableArray<NSString*> alloc] init];
    for (NSInteger column = 0; column < tableData.ColumnSize; column++)
    {
      // If we are not filtering, and the first cell is blank, don't finalize it.  We purposely want to
      // allow that cell to have an empty string (not an empty placeholder value) to account for the
      // intersection of row and column names.
      if (row == 0 && column == 0 && ![[self RowFilter] Enabled] && ![[self ColumnFilter] Enabled])
      {
        
        [formattedResults addValue: [[tableData Data] valueAtRow:row andColumn:column] atRow:row andColumn:column];
        continue;
      }

      [formattedResults addValue: [valueFormatter Finalize:[[tableData Data] valueAtRow:row andColumn:column]] atRow:row andColumn:column];

//      NSInteger index = (rowIndex * tableData.ColumnSize) + columnIndex;
//      //NOTE: we can send in [NSNull null] - if that happens, do an extra check and replace with empty string - otherwise, we get the string literal "<null>"
//      [formattedResults addObject:[NSString stringWithFormat:@"%@", ([[tableData Data][index] isEqual:[NSNull null]] ? @"" : [tableData Data][index])]];
    }
  }

  /*
   Leaving this in here for reference
   not exactly sure why we can't update the string object directly if it's a pointer to the item in the array
      for (NSString* fr __strong in formattedResults) {
        //NSLog(@"fr: %@", fr);
        fr = [valueFormatter Finalize:fr];
        //NSLog(@"fr (finalized): %@", fr);
      }  
   */
//  for(NSInteger i = 0; i < [formattedResults count]; i++) {
//    NSString* fr = [valueFormatter Finalize:[formattedResults objectAtIndex:i]];
//    [formattedResults replaceObjectAtIndex:i withObject:fr];
//  }

  // If we have rows and columns, we want to include a blank first value so
  // it fits nicely into an N x M table.
  // Note that we do NOT use the valueFormatter here.  We absolutely want this to
  // be blank, so we don't touch it.
//  if (canIncludeColumnNames && canIncludeRowNames && [formattedResults count] > 0)
//  {
//    [formattedResults insertObject:@"" atIndex:0];
//  }
  
  return formattedResults;  
}
-(STTableData*)Format:(STTable*)tableData {
  return [self Format:tableData valueFormatter:nil];
}




//MARK: JSON
//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setValue:[[self RowFilter] toDictionary] forKey:@"RowFilter"];
  [dict setValue:[[self ColumnFilter] toDictionary] forKey:@"ColumnFilter"];
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  if(dict == nil || [dict isKindOfClass:[[NSNull null] class]])
  {
    return;
  }

  for (NSString* key in dict) {
    if([key isEqualToString:@"RowFilter"] || [key isEqualToString:@"ColumnFilter"]) {
      NSDictionary *objDict = (NSDictionary*)[dict valueForKey:key];
      if(objDict != nil) {
        [self setValue:[[STFilterFormat alloc] initWithDictionary:objDict] forKey:key];
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

+(NSArray<STTableFormat*>*)DeserializeList:(NSString*)List error:(NSError**)outError
{
  NSMutableArray<STTableFormat*>* ar = [[NSMutableArray<STTableFormat*> alloc] init];
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
    if(dict != nil  && ![dict isKindOfClass:[[NSNull null] class]])
    {
      [self setWithDictionary:dict];
    }
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
