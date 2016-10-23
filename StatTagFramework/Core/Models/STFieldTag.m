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

- (NSString*) CodeFilePath {
  if(_CodeFile != nil) {
    return [_CodeFile FilePath];
  }
  return nil;
}
- (void) setCodeFilePath:(NSString *)c {
  if (_CodeFile == nil)
  {
    _CodeFile = [[STCodeFile alloc] init];
    _CodeFile.FilePath = c;
  }
}
- (NSURL*) CodeFilePathURL {
  if(_CodeFile != nil) {
    return [_CodeFile FilePathURL];
  }
  return nil;
}
- (void) setCodeFilePathURL:(NSURL *)c {
  if (_CodeFile == nil)
  {
    _CodeFile = [[STCodeFile alloc] init];
    _CodeFile.FilePathURL = c;
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
    NSLog(@"initWithTag: using STTag");
  } else {
    self = [super initWithTag:fieldTag];
    NSLog(@"initWithTag: using STFieldTag");
  }
  if(self){
    _TableCellIndex = [fieldTag TableCellIndex];
    [self setCodeFilePath:[fieldTag CodeFilePath]]; //= [fieldTag CodeFilePath];
    [self SetCachedValue];
    NSLog(@"initWithTag:andFieldTag: - FormattedResult : %@", [self FormattedResult]);
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
 Utility function called when a FieldTag is created from an existing tag and
 a cell index (meaning it's a table tag).  We want to update this tag to
 only carry the specific cell value.
 */
- (void)SetCachedValue {
  if([self IsTableTag] && _TableCellIndex != nil && _CachedResult != nil && [_CachedResult count] > 0 ) {
    STTable* table = [[_CachedResult lastObject] TableResult];
    //FIXME - EWW: hack to deal with missing FormattedCells when we have data - we haven't yet called "UpdateFormattedTableData"
    if([table FormattedCells] == nil && [table Data] != nil) {
      //go get updated data if we have some
      [self UpdateFormattedTableData];
    }
    if (table != nil && [table FormattedCells] != nil)
    {
      _CachedResult = [[NSMutableArray<STCommandResult*> alloc] init];
      STCommandResult* cr = [[STCommandResult alloc] init];
      cr.ValueResult = ([_TableCellIndex integerValue] < [[table FormattedCells] count]) ? [[table FormattedCells]objectAtIndex:[_TableCellIndex integerValue]] : @"";
      [_CachedResult addObject:cr];
    }
  }
}



//MARK: JSON methods

//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)

-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:[super toDictionary]];
  if([self TableCellIndex] != nil){
    [dict setObject:[self TableCellIndex] forKey:@"TableCellIndex"];
  }
  if([self CodeFilePath] != nil){
    [dict setObject:[self CodeFilePath] forKey:@"CodeFilePath"];
  }
  return dict;
}


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

-(void)setWithDictionary:(NSDictionary*)dict {
  [super setWithDictionary:dict];
//  for (NSString* key in dict) {
//    if([key isEqualToString:@"FilePath"]) {
//      [dict setObject:_TableCellIndex forKey:@"TableCellIndex"];
//    } else if([key isEqualToString:@"LastCached"]) {
//      [dict setObject:[[self CodeFilePath] path] forKey:@"CodeFilePath"];
//    }
//  }
  
  for (NSString* key in dict) {
//    if([key isEqualToString:@"CodeFile"]) {
//      //NSLog(@"STTag - attempting to recover CodeFile with value %@", [dict valueForKey:key]);
//      id aValue = [dict valueForKey:key];
//      NSDictionary *objDict = aValue;
//      if(objDict != nil) {
//        [self setValue:[[STCodeFile alloc] initWithDictionary:objDict] forKey:key];
//      }
//    } else
    if([key isEqualToString:@"CodeFilePath"]) {
      [self setValue:[dict valueForKey:key] forKey:key];
      //[self setValue:[[NSURL alloc] initWithString:[dict valueForKey:key]] forKey:key];
    } else if([key isEqualToString:@"TableCellIndex"]) {
        [self setValue:[dict valueForKey:key] forKey:key];
    //    } else {
//      [self setValue:[dict valueForKey:key] forKey:key];
    }
  }

  
}


/**
 Create a new Tag object given a JSON string
 */
+(instancetype)Deserialize:(NSString*)json withFiles:(NSArray<STCodeFile*>*)files error:(NSError**)outError
{
  NSLog(@"STFieldTag -> Deserialize json : %@", json);
  NSError* error;
  STFieldTag* tag = (STFieldTag*)[super Deserialize:json error:&error];
  //tag.Name = [[self class] NormalizeName:[tag Name]]; //should be in the parent
  [[self class] LinkToCodeFile:tag CodeFile:files];
  return tag;
}

+(NSArray<STFieldTag*>*)DeserializeList:(id)List error:(NSError**)outError
{
  NSMutableArray<STFieldTag*>* ar = [[NSMutableArray<STFieldTag*> alloc] init];
  for(id x in [STJSONUtility DeserializeList:List forClass:[self class] error:nil]) {
    if([x isKindOfClass:[self class]])
    {
      [ar addObject:x];
    }
  }
  return ar;
}


@end
