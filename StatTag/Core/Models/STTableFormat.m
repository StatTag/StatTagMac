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


@implementation STTableFormat

@synthesize IncludeColumnNames = _IncludeColumnNames;
@synthesize IncludeRowNames = _IncludeRowNames;


//MARK: copying

-(id)copyWithZone:(NSZone *)zone
{
  STTableFormat *format = [[[self class] allocWithZone:zone] init];//[[STTableFormat alloc] init];
  
  format.IncludeColumnNames = _IncludeColumnNames;
  format.IncludeRowNames = _IncludeRowNames;
  
  return format;
}

//This is going to start out assuming left to right filling.  In the future
//this will have different fill options.
-(NSArray<NSString*>*)Format:(STTable*)tableData valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter {
  
  if(valueFormatter == nil) {
    valueFormatter = [[STBaseValueFormatter alloc] init];
  }
  
  NSMutableArray<NSString*> *formattedResults = [[NSMutableArray<NSString*> alloc] init];
  
  if (tableData == nil || [tableData Data] == nil)
  {
    return formattedResults;
  }

  BOOL canIncludeColumnNames = (_IncludeColumnNames && [tableData ColumnNames] != nil && [[tableData ColumnNames] count] > 0);

  if (canIncludeColumnNames)
  {
    [formattedResults addObjectsFromArray:[tableData ColumnNames]];
  }

  BOOL canIncludeRowNames = (_IncludeRowNames && [tableData RowNames] != nil && [[tableData RowNames] count] > 0);
  for (int rowIndex = 0; rowIndex < [tableData RowSize]; rowIndex++)
  {
    if (canIncludeRowNames)
    {
      [formattedResults addObject:[tableData RowNames][rowIndex]];
    }
    for (int columnIndex = 0; columnIndex < tableData.ColumnSize; columnIndex++)
    {
      int index = (rowIndex * tableData.ColumnSize) + columnIndex;
      //NOTE: we can send in [NSNull null] - if that happens, do an extra check and replace with empty string - otherwise, we get the string literal "<null>"
      [formattedResults addObject:[NSString stringWithFormat:@"%@", ([[tableData Data][index] isEqual:[NSNull null]] ? @"" : [tableData Data][index])]];
    }
  }

  /*
   Leaving this in here for reference
   not exactly sure why we can't update the string object directly if it's a pointer to the item in the array
      for (NSString* fr __strong in formattedResults) {
        NSLog(@"fr: %@", fr);
        fr = [valueFormatter Finalize:fr];
        NSLog(@"fr (finalized): %@", fr);
      }  
   */
  for(int i = 0; i < [formattedResults count]; i++) {
    NSString* fr = [valueFormatter Finalize:[formattedResults objectAtIndex:i]];
    [formattedResults replaceObjectAtIndex:i withObject:fr];
  }

  // If we have rows and columns, we want to include a blank first value so
  // it fits nicely into an N x M table.
  // Note that we do NOT use the valueFormatter here.  We absolutely want this to
  // be blank, so we don't touch it.
  if (canIncludeColumnNames && canIncludeRowNames && [formattedResults count] > 0)
  {
    [formattedResults insertObject:@"" atIndex:0];
  }
  
  return formattedResults;  
}
-(NSArray<NSString*>*)Format:(STTable*)tableData {
  return [self Format:tableData valueFormatter:nil];
}




//MARK: JSON
//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setValue:@([[NSNumber numberWithInteger:[self IncludeColumnNames]] boolValue]) forKey:@"IncludeColumnNames"];
  [dict setValue:@([[NSNumber numberWithInteger:[self IncludeRowNames]] boolValue]) forKey:@"IncludeRowNames"];
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    [self setValue:[dict valueForKey:key] forKey:key];
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
