//
//  STFieldTag.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STFieldTag.h"
#import "STCodeFile.h"
#import "STConstants.h"
#import "STTable.h"
#import "STCommandResult.h"

@implementation STFieldTag

@synthesize TableCellIndex = _TableCellIndex;

//@synthesize CodeFilePath = _CodeFilePath;
- (NSURL*) CodeFilePath {
  if(_CodeFile != nil) {
    return [_CodeFile FilePath];
  }
  return nil;
}
- (void) setCodeFilePath:(NSURL *)c {
  if (_CodeFile == nil)
  {
    _CodeFile = [[STCodeFile alloc] init];
    _CodeFile.FilePath = c;
  }
}

//MARK: initializers

-(instancetype)init{
  self = [super init];
  if(self){
    _TableCellIndex = nil;
  }
  return self;
}

-(instancetype)initWithTag:(STTag*)tag{
  self = [super initWithTag:tag];
  if(self){
    _TableCellIndex = nil;
  }
  return self;
}

-(instancetype)initWithTag:(STTag*)tag andTableCellIndex:(NSNumber*)tableCellIndex{
  self = [super initWithTag:tag];
  if(self){
    _TableCellIndex = tableCellIndex;
    [self SetCachedValue];
  }
  return self;
}


-(instancetype)initWithTag:(STTag*)tag andFieldTag:(STFieldTag*)fieldTag{
  if(tag != nil) {
    self = [super initWithTag:tag];
  } else {
    self = [super initWithTag:fieldTag];
  }
  if(self){
    _TableCellIndex = [fieldTag TableCellIndex];
    [self setCodeFilePath:[fieldTag CodeFilePath]]; //= [fieldTag CodeFilePath];
    [self SetCachedValue];
  }
  return self;
}

-(instancetype)initWithFieldTag:(STFieldTag*)tag{
  self = [super initWithTag:tag];
  if(self){
    _TableCellIndex = [tag TableCellIndex];
  }
  return self;
}

-(id)copyWithZone:(NSZone *)zone
{
  STFieldTag *tag = (STFieldTag *)[super copyWithZone:zone];
  return tag;
}


+(instancetype)tagWithName:(NSString*)name andCodeFile:(STCodeFile*)codeFile {
  return [[self class] tagWithName:name andCodeFile:codeFile andType:nil];
}

+(instancetype)tagWithName:(NSString*)name andCodeFile:(STCodeFile*)codeFile andType:(NSString*)type {
  STFieldTag* tag = (STFieldTag *)[super tagWithName:(NSString*)name andCodeFile:(STCodeFile*)codeFile andType:(NSString*)type ];
  return tag;
}


//MARK: JSON methods

//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)

-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:[super toDictionary]];
  [dict setObject:_TableCellIndex forKey:@"TableCellIndex"];
  [dict setObject:[[self CodeFilePath] path] forKey:@"CodeFilePath"];
  return dict;
}

//-(void)setWithDictionary:(NSDictionary*)dict {
//  for (NSString* key in dict) {
//    if([key isEqualToString:@"CodeFile"]) {
//      NSLog(@"STTag - attempting to recover CodeFile with value %@", [dict valueForKey:key]);
//      id aValue = [dict valueForKey:key];
//      NSDictionary *objDict = aValue;
//      if(objDict != nil) {
//        [self setValue:[[STCodeFile alloc] initWithDictionary:objDict] forKey:key];
//      }
//    } else if([key isEqualToString:@"Name"]) {
//      NSLog(@"STTag - attempting to recover normalized Name with value %@, normalized value: %@", [dict valueForKey:key], [STTag NormalizeName:[dict valueForKey:key]]);
//      [self setValue:[STTag NormalizeName:[dict valueForKey:key]] forKey:key];
//    } else {
//      [self setValue:[dict valueForKey:key] forKey:key];
//    }
//  }
//}
//
//-(instancetype)initWithDictionary:(NSDictionary*)dict
//{
//  self = [super init];
//  if (self) {
//    [self setWithDictionary:dict];
//  }
//  return self;
//}
//
//-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
//{
//  self = [super init];
//  if (self) {
//    
//    NSError *error = nil;
//    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
//    
//    if (!error && JSONDictionary) {
//      [super setWithDictionary:JSONDictionary];
//    } else {
//      if (outError) {
//        *outError = [NSError errorWithDomain:STStatTagErrorDomain
//                                        code:[error code]
//                                    userInfo:@{NSUnderlyingErrorKey: error}];
//      }
//    }
//    
//  }
//
//  return self;
//}

/**
 Create a new Tag object given a JSON string
 */
-(instancetype)initWithJSONString:(NSString*)JSONString andfiles:(NSArray<STCodeFile*>*)files error:(NSError**)outError {
  self = [[STFieldTag alloc] initWithJSONString:JSONString error:nil];
  if(self){
    [STFieldTag LinkToCodeFile:self CodeFile:files];
  }
  return self;
}

/**
 Provide a link to a FieldTag from a list of CodeFile objects
 */
+(void)LinkToCodeFile:(STFieldTag*)tag CodeFile:(NSArray<STCodeFile*>*)files {
  
  if (tag == nil || files == nil)
  {
    return;
  }
  
  for (STCodeFile* file in files)
  {
    if ([[tag CodeFilePath] isEqual:[file FilePath]])
    {
      tag.CodeFile = file;
      return;
    }
  }
}

/**
 Create a new Tag object given a JSON string
 */
+(instancetype)Deserialize:(NSString*)json withFiles:(NSArray<STCodeFile*>*)files error:(NSError**)outError
{
  NSError* error;
  STFieldTag* tag = (STFieldTag*)[super Deserialize:json error:&error];
  //tag.Name = [[self class] NormalizeName:[tag Name]]; //should be in the parent
  [[self class] LinkToCodeFile:tag CodeFile:files];
  return tag;
}


/**
 Utility function called when a FieldTag is created from an existing tag and
 a cell index (meaning it's a table tag).  We want to update this tag to
 only carry the specific cell value.
 */
- (void)SetCachedValue {
  if([self IsTableTag] && _TableCellIndex != nil && _CachedResult != nil && [_CachedResult count] > 0 ) {
    STTable* table = [[_CachedResult lastObject] TableResult];
    if (table != nil && [table FormattedCells] != nil)
    {
      _CachedResult = [[NSMutableArray<STCommandResult*> alloc] init];
      STCommandResult* cr = [[STCommandResult alloc] init];
      cr.ValueResult = ([_TableCellIndex integerValue] < [[table FormattedCells] count]) ? [[table FormattedCells]objectAtIndex:[_TableCellIndex integerValue]] : @"";
      [_CachedResult addObject:cr];
    }
  }
}


@end
