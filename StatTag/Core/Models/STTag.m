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
  return [NSString stringWithFormat:@"%@--%@", _Name, (_CodeFile == nil ? @"" : [[_CodeFile FilePath] path])];
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
  if ([[_Type stringByTrimmingCharactersInSet: ws] length] == 0 && _ValueFormat != nil ) {
    formattedValue = [_ValueFormat Format:[lastValue ToString] valueFormatter:[STFactories GetValueFormatter:_CodeFile]];
  }
  
  // Table tags should never return the placeholder.  We assume that there could reasonably
  // be empty cells at some point, so we will not correct those like we do for individual values.
  return (!IsTableTag() && string.IsNullOrWhiteSpace(formattedValue)) ?
  Constants.Placeholders.EmptyField : formattedValue;
}


-(instancetype)init{
  self = [super init];
  return self;
}

+(instancetype)initWithTag:(STTag*)tag {
  STTag *newTag = [tag copy];
  return newTag;
}


-(id)copyWithZone:(NSZone *)zone
{
  NSLog(@"tag - copyWithZone");

  STTag *tag = [[STTag alloc] init];

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


//TODO: JSON methods

/*
 /// <summary>
 /// Serialize the current object, excluding circular elements like CodeFile
 /// </summary>
 /// <returns></returns>
 public string Serialize()
 {
 Name = NormalizeName(Name);
 return JsonConvert.SerializeObject(this);
 }
 
 /// <summary>
 /// Create a new Tag object given a JSON string
 /// </summary>
 /// <param name="json"></param>
 /// <returns></returns>
 public static Tag Deserialize(string json)
 {
 var tag = JsonConvert.DeserializeObject<Tag>(json);
 tag.Name = NormalizeName(tag.Name);
 return tag;
 }
 */


//MARK: equality
- (NSUInteger)hash {
  return ((_Name != nil && _CodeFile != nil) ? [[NSString stringWithFormat:@"%@--%@", _Name, [[_CodeFile FilePath] path]] hash] : 0);
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

  if ([[_Name stringByTrimmingCharactersInSet: ws] length] == 0) {
    return _Name;
  }

  if ([[_Type stringByTrimmingCharactersInSet: ws] length] == 0) {
    return _Type;
  }

  return [super description];
}

- (BOOL) EqualsWithPosition:(STTag*)tag {
  return [self isEqual:tag] && [_LineStart isEqual:[tag LineStart]] && [_LineEnd isEqual:[tag LineEnd]];
}

+ (NSString*)NormalizeName:(NSString*)label {

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  
  if ([[label stringByTrimmingCharactersInSet: ws] length] == 0) {
    return @"";
  }

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



@end
