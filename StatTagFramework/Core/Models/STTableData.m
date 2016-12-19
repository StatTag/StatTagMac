//
//  STTableData.m
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTableData.h"
#import "STConstants.h"

@implementation STTableData

@synthesize Data = _Data;

-(instancetype)init
{
  self = [super init];
  return self;
}

-(instancetype)initWithData:(NSArray<NSArray<NSString*>*>*)data
{
  self = [super init];
  if(self)
  {
    [self replaceData:data];
  }
  return self;
}

-(void)replaceData:(NSArray<NSArray<NSString*>*>*)data
{
  for(NSInteger row = 0; row < [data count]; row++)
  {
    for(NSInteger col = 0; col < [data[row] count]; col++)
    {
      [self addValue:data[row][col] atRow:row andColumn:col];
    }
  }
}

-(instancetype)initWithRows:(NSInteger)rows andCols:(NSInteger)cols
{
  self = [super init];
  if(self)
  {
    [self setDataSizeWithRows:rows andCols:cols];
  }
  return self;
}

-(instancetype)initWithRows:(NSInteger)rows andCols:(NSInteger)cols andData:(NSArray<NSArray<NSString*>*>*)data
{
  self = [super init];
  if(self)
  {
    [self setDataSizeWithRows:rows andCols:cols];
    [self replaceData:data];
  }
  return self;
}


-(void)setDataSizeWithRows:(NSInteger)rows andCols:(NSInteger)cols
{
  _Data = [[NSMutableArray<NSMutableArray<NSString*>*> alloc] init];
  for(NSInteger r = 0; r < rows ; r++)
  {
    [_Data addObject:[[NSMutableArray<NSString*> alloc] initWithCapacity:cols]];
  }
}

-(NSInteger)numRows
{
  NSInteger rows = 0;
  if([self Data] != nil)
  {
    rows = [[self Data] count];
  }
  return rows;
}
-(NSInteger)numColumns
{
  NSInteger cols = 0;
  if([self Data] != nil)
  {
    NSInteger rows = 0;
    for(NSArray<NSArray*>* a in [self Data])
    {
      rows++;
      cols = MAX(cols, [a count]);
    }
  }
  return cols;
}


-(NSString*)valueAtRow:(NSInteger)row andColumn:(NSInteger)col
{
  NSString* d;
  if([self Data] != nil && [[self Data] count] > row && [[self Data] objectAtIndex:row] != nil && [[[self Data] objectAtIndex:row] count] > col)
  {
    return [[[self Data] objectAtIndex:row] objectAtIndex:col];
  }
  
  return d;
}
-(NSInteger)numItems
{
  NSInteger numItems = 0;
  if([self Data] != nil)
  {
    numItems = [[[self Data] valueForKeyPath:@"@unionOfArrays.self"] count];
  }
  return numItems;
}

-(NSString*)GetDataAtIndex:(NSInteger)index
{
  if ([self Data] == nil || index >= [self numItems])
  {
    return @"";
  }
  
  NSArray<NSString*>* items = [[self Data] valueForKeyPath:@"@unionOfArrays.self"];
  if(items != nil && [items count] > index)
  {
    return [items objectAtIndex:index];
  }
  
  return @"";
  //  NSInteger columns = [self numColumns];
  //  return [self valueAtRow:(index / columns) andColumn:(index % columns)];
  //  return [[[data Data] objectAtIndex:(index / columns)] objectAtIndex:(index % columns)];
}


-(void)addValue:(NSString*)value atRow:(NSInteger)row andColumn:(NSInteger)col
{
  //data not initialized - set it up
  if([self Data]==nil)
  {
    [self setDataSizeWithRows:row+1 andCols:col+1];
  }
  //if we don't have containing arrays at the requested row index
  if([[self Data] count] < row + 1 || [[self Data] objectAtIndex:row] == nil)
  {
    NSInteger dataRows = [[self Data] count];
    //extend the array if required
    if(row > (dataRows - 1))
    {
      for(NSInteger r = dataRows; r < row + 1; r ++)
      {
        [_Data addObject:[[NSMutableArray<NSString*> alloc] init]];
      }
    }
  }
  
  if([[[self Data] objectAtIndex:row ] count] < col + 1 || [[[self Data] objectAtIndex:row] objectAtIndex:col] == nil)
  {
    NSInteger dataCols = [[[self Data] objectAtIndex:row] count];
    //extend the array if required
    if(col > (dataCols - 1))
    {
      for(NSInteger c = dataCols; c < col + 1; c ++)
      {
        [[_Data objectAtIndex:row ] addObject:@""];
      }
    }
  }
  
  [[_Data objectAtIndex:row] setObject:value atIndexedSubscript:col];
  
}

-(NSString*) description
{
  NSMutableString* desc = [[NSMutableString alloc] init];
  if([self Data] != nil)
  {
    for(NSInteger x = 0; x < [[self Data] count]; x++)
    {
      [desc appendString:[NSString stringWithFormat:@"(%ld)%@\n", x, [[[self Data] objectAtIndex:x ] componentsJoinedByString:@","]]];
    }
  }
  return desc;
}

-(NSString*) indexedDescription
{
  NSMutableString* desc = [[NSMutableString alloc] init];
  if([self Data] != nil)
  {
    NSInteger index = 0;
    for(NSInteger x = 0; x < [self numRows]; x++)
    {
      for(NSInteger y = 0; y < [[[self Data] objectAtIndex:x ] count]; y++)
      {
        [desc appendString:[NSString stringWithFormat:@"(%ld,%ld) [%ld] : %@\t", (long)x, (long)y, (long)index, [self valueAtRow:x andColumn:y]]];
        index ++;
      }
      [desc appendString:@"\n"];
    }
  }
  return desc;
  
}



//MARK: JSON
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setValue:[self Data] forKey:@"Data"];
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

+(NSArray<STTableData*>*)DeserializeList:(id)List error:(NSError**)outError
{
  NSMutableArray<STTableData*>* ar = [[NSMutableArray<STTableData*> alloc] init];
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

//MARK: Copy
-(id)copyWithZone:(NSZone *)zone
{
  STTableData *td = [[[self class] allocWithZone:zone] init];
  td.Data = [_Data copy];
  return td;
}


@end
