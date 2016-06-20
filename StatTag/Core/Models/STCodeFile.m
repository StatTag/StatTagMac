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
          self.LastCached, @"LastCached", //format?
          nil
          ];
}

+(NSString*)SerializeObject:(STCodeFile*)codeFile error:(NSError**)error
{
  
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[codeFile toDictionary] options:NSJSONWritingPrettyPrinted error:error];
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

+(STCodeFile*)DeserializeObject:(NSString*)codeFile error:(NSError**)error
{
  return nil;
}

/**
  Utility method to take a JSON array string and convert it back into a list of
  CodeFile objects.  This does not resolve the list of tags that may be
  associated with the CodeFile.
 */
+(NSArray<STCodeFile*>*)DeserializeList:(NSString*)List error:(NSError**)error
{

  //FIXME: this is not complete - at all
  NSData *jsonData = [List dataUsingEncoding:NSUTF8StringEncoding];
  NSArray *values = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
  //return JsonConvert.DeserializeObject<List<CodeFile>>(value);
  
  NSMutableArray *codeFiles = [[NSMutableArray<STCodeFile*> alloc] init];
  for(id x in values) {
//    STCodeFile *file = [STCodeFile Des]
  }
  
  return codeFiles;
  
//  // if you are expecting  the JSON string to be in form of array else use NSDictionary instead
//  id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:error];
//  
//  if ([object isKindOfClass:[NSDictionary class]] && error == nil)
//  {
//    NSArray *array;
//    if ([[object objectForKey:@"results"] isKindOfClass:[NSArray class]])
//    {
//      array = [object objectForKey:@"results"];
//      return array;
//    }
//  }
//  return nil;
}


@end
