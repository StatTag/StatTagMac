//
//  STTag.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTag.h"
#import "STConstants.h"
#import "STCodeFile.h"
#import "STValueFormat.h"
#import "STFigureFormat.h"
#import "STTableFormat.h"
#import "STCommandResult.h"
#import "STFactories.h"
#import "STTable.h"

@implementation STTag

@synthesize CodeFile = _CodeFile;
@synthesize Type = _Type;
@synthesize Name = _Name;
@synthesize RunFrequency = _RunFrequency;
@synthesize ValueFormat = _ValueFormat;
@synthesize FigureFormat = _FigureFormat;
@synthesize TableFormat = _TableFormat;
@synthesize CachedResult = _CachedResult;
@synthesize LineStart = _LineStart;
@synthesize LineEnd = _LineEnd;

@synthesize Id = _Id;
- (NSString*) Id {
  return [NSString stringWithFormat:@"%@--%@", (_Name == nil ? @"" : _Name), (_CodeFile == nil || [_CodeFile FilePath] == nil ? @"" : [_CodeFile FilePath])];
}

@synthesize FormattedResult = _FormattedResult;
- (NSString*) FormattedResult {
  if (_CachedResult == nil || [_CachedResult count] == 0)
  {
    return [STConstantsPlaceholders EmptyField];
  }
  
  // When formatting a value, it is possible the user has selected multiple
  // display commands.  We will only return the last cached result, and format
  // that if our formatter is available.
  STCommandResult* lastValue = [_CachedResult lastObject];
  NSString* formattedValue = [lastValue ToString];
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([[_Type stringByTrimmingCharactersInSet: ws] length] > 0 && _ValueFormat != nil ) {
    formattedValue = [_ValueFormat Format:[lastValue ToString] valueFormatter:[STFactories GetValueFormatter:_CodeFile]];
  }
  
  // Table tags should never return the placeholder.  We assume that there could reasonably
  // be empty cells at some point, so we will not correct those like we do for individual values.  
  return (![self IsTableTag ] && [[formattedValue stringByTrimmingCharactersInSet: ws] length] == 0) ?
  [STConstantsPlaceholders EmptyField] : formattedValue;
}


-(instancetype)init{
  self = [super init];
  
  //different from our original c# - we want these initialized so they're available later
  // tag type will govern whether or not we care about them
  self.TableFormat = [[STTableFormat alloc] init];
  self.ValueFormat = [[STValueFormat alloc] init];
 // self.ValueFormat.FormatType = [STConstantsValueFormatType Default];
  self.FigureFormat = [[STFigureFormat alloc] init];
  self.Name = @"";
  
  return self;
}

-(instancetype)initWithTag:(STTag*)tag {
  //can't do the following or the type is wrong for any of our subclasses
  //  STTag *newTag = [tag copy];
  //  return newTag;
  
  self = [super init];
  if(self){
    self.CodeFile = [[tag CodeFile] copy];
    self.Type = [[tag Type] copy];
    self.Name = [[self class] NormalizeName:[tag Name]]; //Name = NormalizeName(tag.Name);
    self.RunFrequency = [[tag RunFrequency] copy];
    self.ValueFormat = [[tag ValueFormat] copy];
    self.FigureFormat = [[tag FigureFormat] copy];
    self.TableFormat = [[tag TableFormat] copy];
    self.LineStart = [[tag LineStart ] copy];
    self.LineEnd = [[tag LineEnd] copy];
    self.CachedResult = [[tag CachedResult] copy];
    NSLog(@"tag CachedResult = %@", [tag CachedResult]);
    NSLog(@"self CachedResult = %@", [self CachedResult]);
    NSLog(@"tag(self) FormattedResult : %@", [self FormattedResult]);
  }
  //fix any missing members
  if(self.Name == nil) {
    self.Name = @"";
  }
  if(self.TableFormat == nil) {
    self.TableFormat = [[STTableFormat alloc] init];
  }
  if(self.ValueFormat == nil) {
    self.ValueFormat = [[STValueFormat alloc] init];
  }
  if(self.FigureFormat == nil) {
    self.FigureFormat = [[STFigureFormat alloc] init];
  }
  // self.ValueFormat.FormatType = [STConstantsValueFormatType Default];

  return self;
}


+(instancetype)tagWithName:(NSString*)name andCodeFile:(STCodeFile*)codeFile {
  return [[self class] tagWithName:name andCodeFile:codeFile andType:nil];
}

+(instancetype)tagWithName:(NSString*)name andCodeFile:(STCodeFile*)codeFile andType:(NSString*)type {
  STTag* tag = [[[self class] alloc] init];
  tag.Name = name;
  tag.CodeFile = codeFile;
  tag.Type = type;
  return tag;
}

-(id)copyWithZone:(NSZone *)zone
{
  NSLog(@"tag - copyWithZone");

  STTag *tag = [[[self class] allocWithZone:zone] init];

  tag.CodeFile = [_CodeFile copyWithZone: zone];
  tag.Type = [_Type copy];
  tag.Name = [STTag NormalizeName:_Name]; //Name = NormalizeName(tag.Name);
  tag.RunFrequency = [_RunFrequency copy];
  tag.ValueFormat = [_ValueFormat copyWithZone: zone];
  tag.FigureFormat = [_FigureFormat copyWithZone: zone];
  tag.TableFormat = [_TableFormat copyWithZone: zone];
  tag.CachedResult = [_CachedResult copyWithZone: zone];
  tag.LineStart = [_LineStart copy];
  tag.LineEnd = [_LineEnd copy];
  
  return tag;
}


//MARK: JSON methods

-(NSDictionary *)toDictionary {
  
  //NSError* error;
  
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  //note: codefile is flagged as "jsonignore"
  [dict setValue:_Type forKey:@"Type"];
  [dict setValue:[STTag NormalizeName:_Name] forKey:@"Name"];
  [dict setValue:_RunFrequency forKey:@"RunFrequency"];
  if(_ValueFormat != nil ) { //&& [_ValueFormat respondsToSelector:@selector(toDictionary)]
    [dict setObject:[_ValueFormat toDictionary] forKey:@"ValueFormat"];
  }
  if(_FigureFormat != nil) {
    [dict setObject:[_FigureFormat toDictionary] forKey:@"FigureFormat"];
  }
  if(_TableFormat != nil) {
    [dict setObject:[_TableFormat toDictionary] forKey:@"TableFormat"];
  }
  if(_CachedResult != nil) {
    //go back and look at this - shouldn't be serializelist
    NSMutableArray<NSDictionary*>* a = [[NSMutableArray<NSDictionary*> alloc] init];
    for (STCommandResult* c in _CachedResult) {
      [a addObject:[c toDictionary]];
    }
    [dict setObject:a forKey:@"CachedResult"];
    //[dict setObject:[[self class]SerializeList:_CachedResult error:&error] forKey:@"CachedResult"];
  }
  [dict setValue:_LineStart forKey:@"LineStart"];
  [dict setValue:_LineEnd forKey:@"LineEnd"];
  [dict setValue:[self Id] forKey:@"Id"]; //this is a read only item
  [dict setValue:[self FormattedResult] forKey:@"FormattedResult"];
  
  return dict;
  
}

-(void)setWithDictionary:(NSDictionary*)dict {
  
  NSError* error;
  
  for (NSString* key in dict) {
    if([key isEqualToString:@"Id"]) {
      //skip the read-only properties
    } else if([key isEqualToString:@"CodeFilePath"] || [key isEqualToString:@"TableCellIndex"] ) {
      //skip the properties from fieldtag
    } else if([key isEqualToString:@"CodeFile"]) {
      //NSLog(@"STTag - attempting to recover CodeFile with value %@", [dict valueForKey:key]);
      id aValue = [dict valueForKey:key];
      NSDictionary *objDict = aValue;
      if(objDict != nil) {
        [self setValue:[[STCodeFile alloc] initWithDictionary:objDict] forKey:key];
      }
    } else if([key isEqualToString:@"Name"]) {
      //NSLog(@"STTag - attempting to recover normalized Name with value %@, normalized value: %@", [dict valueForKey:key], [STTag NormalizeName:[dict valueForKey:key]]);
      [self setValue:[[self class] NormalizeName:[dict valueForKey:key]] forKey:key];
    } else if([key isEqualToString:@"CachedResult"]) {
      //[self setValue:[[self class] Deserialize:[dict valueForKey:key] error:&error] forKey:key];
      [self setValue:[STCommandResult DeserializeList:[dict valueForKey:key] error:&error] forKey:key];
      NSLog(@"NSError: %@", [error localizedDescription]);
    } else if([key isEqualToString:@"FigureFormat"]) {
      [self setValue:[[STFigureFormat alloc] initWithDictionary:[dict valueForKey:key]] forKey:key];
    } else if([key isEqualToString:@"ValueFormat"]) {
      [self setValue:[[STValueFormat alloc] initWithDictionary:[dict valueForKey:key]] forKey:key];
    } else if([key isEqualToString:@"TableFormat"]) {
      [self setValue:[[STTableFormat alloc] initWithDictionary:[dict valueForKey:key]] forKey:key];
    } else {
      [self setValue:[dict valueForKey:key] forKey:key];
    }
  }
  
  self.Name = [[self class] NormalizeName:[self Name]];

}

/**
 Serialize the current object, excluding circular elements like CodeFile
 */
-(NSString*)Serialize:(NSError**)error
{
  _Name = [[self class] NormalizeName:[self Name]];
  return [STJSONUtility SerializeObject:self error:nil];
}

/**
 Create a new Tag object given a JSON string
 */
+(instancetype)Deserialize:(NSString*)json error:(NSError**)outError
{
  //moved to dictionary setup for consistency - that method is called from all deserializers
  //leaving this here so it's clear why we deviate from the c#
  //NSError* error;
  //STTag* tag = [[[self class] alloc] initWithJSONString:json error:&error];
  //tag.Name = [[self class] NormalizeName:[tag Name]];
  //return tag;
  NSError* error;
  return [[[self class] alloc] initWithJSONString:json error:&error];
}

+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
  return [STJSONUtility SerializeList:list error:nil];
}

+(NSArray<STTag*>*)DeserializeList:(id)List error:(NSError**)outError
{
  NSMutableArray<STTag*>* ar = [[NSMutableArray<STTag*> alloc] init];
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






//MARK: equality
- (NSUInteger)hash {
  return ((_Name != nil && _CodeFile != nil) ? [[NSString stringWithFormat:@"%@--%@", _Name, [_CodeFile FilePath]] hash] : 0);
}

- (BOOL)isEqual:(id)object
{
  if (![object isKindOfClass:self.class]) {
    return NO;
  }

  STTag *tag = object;
  if (tag == nil)
  {
    return false;
  }
  
  //FIXME: should these be case insensitive comparisons?
  if(![_Name isEqualToString:[tag Name]]) {
    return false;
  }
  
  // Now check for equality, considering if CodeFile values are null
  if (_CodeFile == nil && [tag CodeFile] == nil)
  {
    return true;
  }
  else if (_CodeFile == nil || [tag CodeFile] == nil)
  {
    return false;
  }
  
  return [_CodeFile isEqual:[tag CodeFile]];
}

- (NSString*)ToString {
  return [self description];
}

- (NSString*)description {

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  if ([[_Name stringByTrimmingCharactersInSet: ws] length] != 0) {
    return _Name;
  }

  if ([[_Type stringByTrimmingCharactersInSet: ws] length] != 0) {
    return _Type;
  }

  return NSStringFromClass([self class]);
  //return [super description];
}

-(BOOL) Equals:(STTag*)other usePosition:(BOOL)usePosition
{
  return (usePosition) ? [self EqualsWithPosition:other] : [self isEqual:other];
}


- (BOOL) EqualsWithPosition:(STTag*)tag {
  return [self isEqual:tag] && [_LineStart integerValue] == [[tag LineStart] integerValue] && [_LineEnd integerValue] == [[tag LineEnd] integerValue];
  //return [self isEqual:tag] && [_LineStart isEqual:[tag LineStart]] && [_LineEnd isEqual:[tag LineEnd]];
}

+ (NSString*)NormalizeName:(NSString*)label {

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  
  if ([[label stringByTrimmingCharactersInSet: ws] length] == 0) {
    return @"";
  }

  //            return label.Replace(Constants.ReservedCharacters.TagTableCellDelimiter, ' ').Trim();

  return [[label stringByReplacingOccurrencesOfString:[STConstantsReservedCharacters TagTableCellDelimiter] withString:@" "] stringByTrimmingCharactersInSet: ws];
  
  return nil;
}

/**
 Determine if this tag is to represent a table
*/
- (BOOL)IsTableTag {
  return _Type != nil && [_Type isEqualToString:[STConstantsTagType Table]];
  //return Type != null && Type.Equals(Constants.TagType.Table, StringComparison.CurrentCulture);
}

/**
 Determine if there is any table data saved and available for this tag.  It will perform this check
 regardless of the tag type (although it's not expected to be called for non-table tags).
 If the table was set but has 0 dimension, this will still return true.  It asserts that a table result
 was initialized.
 */
- (BOOL)HasTableData {
  return !(_CachedResult == nil || [_CachedResult count] == 0 || [[_CachedResult firstObject] TableResult] == nil);
}

/**
 Update the underlying table data associated with this tag.
 */
- (void)UpdateFormattedTableData {
  
  if (![self IsTableTag] || ![self HasTableData])
  {
    return;
  }
  
  STTable* table = [[_CachedResult firstObject] TableResult];
  table.FormattedCells = [NSMutableArray arrayWithArray:[_TableFormat Format:table valueFormatter:[STFactories GetValueFormatter:_CodeFile]]];
}

/**
 Get the dimensions for the displayable table.  This factors in not only the data, but if column and
row labels are included.

 return type within array is: int
 */
- (NSArray<NSNumber*>*)GetTableDisplayDimensions {
 
  if (![self IsTableTag] || _TableFormat == nil || ![ self HasTableData])
  {
    return nil;
  }
  
  STTable* tableData = [[_CachedResult firstObject] TableResult];
//  NSInteger dimensions[2];
//  dimensions[0] = [tableData RowSize];
//  dimensions[1] = [tableData ColumnSize];
  
  NSMutableArray<NSNumber*>* dimensions = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:[tableData RowSize]], [NSNumber numberWithInteger:[tableData ColumnSize]], nil];
  
  if ([_TableFormat IncludeColumnNames] && [tableData ColumnNames] != nil)
  {
    dimensions[STConstantsDimensionIndex.Rows] = [NSNumber numberWithInteger:[dimensions[STConstantsDimensionIndex.Rows] integerValue] + 1];
    //dimensions[STConstantsDimensionIndex.Rows]++;
  }

  if ([_TableFormat IncludeRowNames] && [tableData RowNames] != nil)
  {
    dimensions[STConstantsDimensionIndex.Columns] = [NSNumber numberWithInteger:[dimensions[STConstantsDimensionIndex.Columns] integerValue] + 1];
    //dimensions[STConstantsDimensionIndex.Columns]++;
  }
  
  return dimensions;
}

/**
 Provide a string representation of the range of lines that this Tag spans in
 its code file.  If there is only one line, just that line number is returned.
 */
-(NSString*)FormatLineNumberRange {
  if (_LineStart == 0 || _LineEnd == 0)
  {
    return @"";
  }
  
  if ([_LineStart isEqual:_LineEnd])
  {
    return [NSString stringWithFormat:@"%@", _LineStart];
  }
  
  return [NSString stringWithFormat:@"%@ - %@", _LineStart, _LineEnd];
}


@end
