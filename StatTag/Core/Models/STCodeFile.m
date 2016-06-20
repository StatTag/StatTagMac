//
//  STCodeFile.m
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCodeFile.h"
#import "STTag.h"
#import "STIFileHandler.h"
#import "STFileHandler.h"
#import "STFactories.h"
#import "STIParser.h"
#import "STConstants.h"

@implementation STCodeFile

//@synthesize ContentCache = ContentCache;
@synthesize StatisticalPackage = _StatisticalPackage;
@synthesize FilePath = _FilePath;
@synthesize LastCached = _LastCached;
@synthesize Tags = _Tags;
NSMutableArray<NSString *> *ContentCache;


@synthesize Content = _Content;
- (void) setContent:(NSMutableArray *)c {
  _Content = c;
}
- (NSMutableArray*) Content {
  if(ContentCache == nil) {
    ContentCache = [self LoadFileContent];
  }
  return _Content;
}


/**
 This is typically a lightweight wrapper around the standard
 File class, but is used to allow us to mock file IO during
 our unit tests.
 */
NSObject<STIFileHandler>* _FileHandler;

//MARK: initializers
-(id)init{
  self = [super init];
  if(self){
    [self initialize:nil];
  }
  return self;
}
-(id)init:(NSObject<STIFileHandler>*)handler {
  self = [super init];
  if(self){
    [self initialize:handler];
  }
  return self;
}
-(void)initialize:(NSObject<STIFileHandler>*)handler {
  _Tags = [[NSMutableArray<STTag*> alloc] init];
  _FileHandler = handler ? handler :[[STFileHandler alloc] init];
}

//MARK:methods

-(NSString*)ToString {
  return _FilePath ? [_FilePath path] : @"";
}
-(NSString*)description {
  return [self ToString];
}

//MARK: equality
- (NSUInteger)hash {
  return (_FilePath ? [_FilePath hash] : 0);
}

- (BOOL)isEqual:(id)object
{
  if (![object isKindOfClass:self.class]) {
    return NO;
  }
  STCodeFile *other = object;
  return ([[[other FilePath] path] caseInsensitiveCompare:[_FilePath path]] == NSOrderedSame);
}


/**
 @brief Return the contents of the CodeFile
*/
- (NSMutableArray*) LoadFileContent {
  [self RefreshContent];
  return ContentCache;
}

/**
 @brief Return the contents of the CodeFile
*/
- (void) RefreshContent {
  NSError *error;
  ContentCache = [NSMutableArray arrayWithArray:[_FileHandler ReadAllLines:_FilePath error:&error]];
}

/**
 Using the contents of this file, parse the instrutions and build the list
 of tags that are present and cache them for later use.
*/
-(void)LoadTagsFromContent {
  [self LoadTagsFromContent:true];
}
-(void)LoadTagsFromContent:(BOOL)preserveCache {
  NSArray<STTag*>* savedTags;
  if(preserveCache){
    savedTags = [[NSArray<STTag*> alloc] initWithArray:savedTags];
  }
  
  // Any time we try to load, reset the list of tags that may exist
  _Tags = [[NSMutableArray<STTag*> alloc] init];
  
  NSArray<NSString*> *content = [self LoadFileContent];
  if(content == nil || [content count] == 0){
    return;
  }
  
  NSObject<STIParser>* parser = [STFactories GetParser:self];
  if (parser == nil) {
    return;
  }
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  NSPredicate *tagPredicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
    return [[[aTag Type] stringByTrimmingCharactersInSet: ws] length] == 0;
  }];
  _Tags = [NSMutableArray<STTag*> arrayWithArray:[[parser Parse:self] filteredArrayUsingPredicate:tagPredicate]];
  for(STTag *tag in _Tags) {
    tag.CodeFile = self;
  }

  
  if (preserveCache)
  {
    // Since we are reloading from a file, at this point if we had any cached results for
    // an tag we want to associate that back with the tag.
    for(STTag *tag in _Tags)
    {
      [self SetCachedTag:savedTags Tag:tag];
    }
  }

  
}

/**
Given a set of existing tags (which are assumed to have cached results already set), update
the cached results in another tag.
 
@remark This is used primarily when a code file is reloaded, which resets its collection
 of tags.  Those tags will be valid, but will have their cached results reset.</remarks>

@param existingTags: The tags that have cached results
@param tag: The tag that needs to receive results
 */
-(void)SetCachedTag:(NSArray<STTag*>*)existingTags Tag:(STTag*)tag {
  STTag *existingTag = [existingTags firstObjectCommonWithArray:@[tag]];
  if(existingTag != nil && existingTag.CachedResult != nil) {
    tag.CachedResult = [NSMutableArray<STCommandResult*> arrayWithArray:[existingTag CachedResult]];
  }
}

/**
 Save the content to the code file
*/
-(void)Save:(NSError**)error
{
  [_FileHandler WriteAllLines:_FilePath withContent:_Content error:error];
}

/**
 Save a backup copy of this code file, in the event we cause issues with the file and the
 user needs to restore it.
*/
-(void)SaveBackup:(NSError**)error {

  NSURL *backupFile = [NSURL URLWithString:[NSString stringWithFormat:@"%@.%@", [_FilePath path], [STConstantsFileExtensions Backup]]];

  if (![_FileHandler Exists:backupFile error:error])
  {
    [_FileHandler Copy:_FilePath toDestinationFile:backupFile error:error];
  }
}

//MARK: JSON

-(NSDictionary *)toDictionary {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          self.StatisticalPackage, @"StatisticalPackage",
          [self.FilePath path], @"FilePath",
          [STJSONUtility convertDateToDateString:self.LastCached], @"LastCached", //format?
          nil
          ];
}

-(NSString*)SerializeObject:(NSError**)error
{
  //NSJSONWritingPrettyPrinted
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:0 error:error];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  return jsonString;
}



/**
 Utility method to serialize the list of code files into a JSON array.
 */
+(NSString*)SerializeList:(NSArray<STCodeFile*>*)files error:(NSError**)outError {
  
  NSData *json;
  NSError *error = nil;

  NSMutableArray *fileList = [[NSMutableArray alloc] init];
  for (STCodeFile *f in files){
    [fileList addObject:[f toDictionary]];
  }
  
  //NSLog(@"fileList: %@", fileList);
  
  if ([NSJSONSerialization isValidJSONObject:fileList])
  {
    json = [NSJSONSerialization dataWithJSONObject:fileList options:NSJSONWritingPrettyPrinted error:&error];
    
    if (json != nil && error == nil)
    {
      return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    
    if (outError) {
      *outError = [NSError errorWithDomain:STStatTagErrorDomain
                                      code:[error code]
                                      userInfo:@{NSUnderlyingErrorKey: error}];
    }
    NSLog(@"error: %@", [error localizedDescription]);
  } else {
    NSLog(@"invalid json");
    *outError = [NSError errorWithDomain:STStatTagErrorDomain
                                    code:-1
                                    userInfo:@{NSLocalizedDescriptionKey: @"Invalid JSON"}];

  }
  return nil;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    if([key isEqualToString:@"FilePath"]) {
      [self setValue:[NSURL fileURLWithPath:[dict valueForKey:key]] forKey:key];
    } else if([key isEqualToString:@"LastCached"]) {
      [self setValue:[STJSONUtility dateFromString:[dict valueForKey:key]] forKey:key];
      NSLog(@"LastCached : %@", [self LastCached]);
    } else {
      [self setValue:[dict valueForKey:key] forKey:key];
      //NSLog(@"[JSONDictionary valueForKey:key] : %@", [JSONDictionary valueForKey:key]);
      //NSLog(@"[self valueForKey:key] : %@", [self valueForKey:key]);
    }
  }
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
      //Loop method
      //      for (NSString* key in JSONDictionary) {
      //        [self setValue:[JSONDictionary valueForKey:key] forKey:key];
      //      }
      //[self setValuesForKeysWithDictionary:JSONDictionary]; //we have a URL, so we can't do this
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

/**
  Utility method to take a JSON array string and convert it back into a list of
  CodeFile objects.  This does not resolve the list of tags that may be
  associated with the CodeFile.
 */
+(NSArray<STCodeFile*>*)DeserializeList:(NSString*)List error:(NSError**)outError
{

  NSMutableArray *list = [[NSMutableArray<STCodeFile*> alloc] init];

  //FIXME: this is not complete - at all
  NSData *jsonData = [List dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error = nil;
  NSArray *values = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
  if ([values isKindOfClass:[NSArray class]] && error == nil) {
    for(id d in values) {
      if([d isKindOfClass:[NSDictionary class]]){
      STCodeFile *file = [[STCodeFile alloc] initWithDictionary:d];
        if(file != nil) {
          [list addObject:file];
        }
      }
    }
  }
  return list;
}


@end
