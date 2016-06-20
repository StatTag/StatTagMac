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

//MARK: copying

-(id)copyWithZone:(NSZone *)zone
{
  STCodeFile *codeFile = [[STCodeFile alloc] init];

  codeFile.StatisticalPackage = [_StatisticalPackage copyWithZone:zone];
  codeFile.FilePath = [_StatisticalPackage copyWithZone:zone];
  codeFile.LastCached = [_LastCached copyWithZone:zone];
  codeFile.Tags = [_Tags copyWithZone:zone];
  
  return codeFile;
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
//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)

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
+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)files error:(NSError**)outError {
  return [STJSONUtility SerializeList:files error:nil];
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    if([key isEqualToString:@"FilePath"]) {
      [self setValue:[NSURL fileURLWithPath:[dict valueForKey:key]] forKey:key];
    } else if([key isEqualToString:@"LastCached"]) {
      [self setValue:[STJSONUtility dateFromString:[dict valueForKey:key]] forKey:key];
      //NSLog(@"LastCached : %@", [self LastCached]);
    } else {
      [self setValue:[dict valueForKey:key] forKey:key];
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

//MARK: other

/**
 Given a file filter (e.g. "*.txt" or "*.txt;*.t", determine if the supplied
 path parameter matches.
 */
+ (BOOL)FilterMatches:(NSString*)filter path:(NSString*)path
{

  NSArray<NSString*>* extensions = [filter componentsSeparatedByString:@";"];
  NSString* normalizedPath = [path uppercaseString];

  for(NSString* extension in extensions) {
    if([normalizedPath hasSuffix:[[extension stringByReplacingOccurrencesOfString:@"*" withString:@""] uppercaseString]]){
      return true;
    }
  }
  return false;
}

/**
 Utility method to take a path and determine which statistical package is
 most likely the right one  This only returns a value if there is a high
 degree of certainty of the guess, and is based purely on the file name
 (not file content).
 */
+ (NSString*) GuessStatisticalPackage:(NSString*) path {
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  if ([[path stringByTrimmingCharactersInSet: ws] length] == 0 )
  {
    return @"";
  }
  
  path = [path stringByTrimmingCharactersInSet:ws];

  if ([STCodeFile FilterMatches:[STConstantsFileFilters StataFilter] path:path]) {
    return [STConstantsStatisticalPackages Stata];
  }
  if ([STCodeFile FilterMatches:[STConstantsFileFilters SASFilter] path:path]) {
    return [STConstantsStatisticalPackages SAS];
  }
  if ([STCodeFile FilterMatches:[STConstantsFileFilters RFilter] path:path]) {
    return [STConstantsStatisticalPackages R];
  }
  
  return @"";
  
}

/**
 Removes an tag from the file, and from the internal cache.
 */
- (void)RemoveTag:(STTag*)tag {
  
  if (tag == nil)
  {
    return;
  }
  
  if([_Tags containsObject:tag]) {
    [_Tags removeObject:tag];
  } else {
    // If the exact object doesn't match, then search by equality

    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
      return [aTag isEqual:tag];
    }];
    STTag *foundTag = [[_Tags filteredArrayUsingPredicate:predicate] firstObject];
    
    if (foundTag == nil)
    {
      return;
    }
    [_Tags removeObject:foundTag];
  }
  
  [ContentCache removeObjectAtIndex:[[tag LineEnd] integerValue]]; //risky...
  [ContentCache removeObjectAtIndex:[[tag LineStart] integerValue]]; //risky...

  // Any tags below the one being removed need to be adjusted
  for(STTag* otherTag in _Tags){
    // Tags can't overlap, so we can simply check for the start after the end.
    if([otherTag LineStart] > [tag LineEnd]) {
      int _lineStart = [[otherTag LineStart] integerValue] -2;
      otherTag.LineStart = [NSNumber numberWithInteger:_lineStart];
      
      int _lineEnd = [[otherTag LineEnd] integerValue] -2;
      otherTag.LineEnd = [NSNumber numberWithInteger:_lineEnd];
    }
  }
}


/**
 Updates or inserts an tag in the file.  An update takes place only if oldTag is defined, and it is able to match that old tag.
 
 @ param matchWithPosition: When looking to replace an existing tag (which assumes that oldTag is specified), this parameter when set to true will only replace the tag if the line numbers match.  This is to be used when updating duplicate named tags, but shouldn't be used otherwise.</param>
 
 */
- (STTag*)AddTag:(STTag*)newTag oldTag:(STTag*)oldTag matchWithPosition:(BOOL)matchWithPosition {
  // Do some sanity checking before modifying anything
  if (newTag == nil || [newTag LineStart] == nil || [newTag LineEnd] == nil)
  {
    return nil;
  }

  if ([newTag LineStart] > [newTag LineEnd])
  {
    //FIXME: we shouldn't be doing things this way - fix
    [NSException raise:@"Invalid LineStart and LineEnd" format:@"The new tag start index is after the end index, which is not allowed."];
  }

  STTag* updatedTag = [STTag initWithTag:newTag];
  
  NSMutableArray<NSString*>* content = [self Content];  // Force cache to load so we can reference it later w/o accessor overhead

  if(oldTag != nil) {
    //var refreshedOldTag = (matchWithPosition ? Tags.FirstOrDefault(tag => oldTag.EqualsWithPosition(tag)) : Tags.FirstOrDefault(tag => oldTag.Equals(tag)));

    //this is all wrong
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
      return [aTag isEqual:oldTag];
    }];
    STTag *refreshedOldTag = [[_Tags filteredArrayUsingPredicate:predicate] firstObject];

    
    //STTag* refreshedOldTag = _Tags.FirstOrDefault(tag => oldTag.Equals(tag, matchWithPosition));
    if (refreshedOldTag == nil)
    {
      throw new InvalidDataException("Unable to find the existing tag to update.");
    }

  }

  
  
}
- (STTag*)AddTag:(STTag*)newTag oldTag:(STTag*)oldTag {
  return [self AddTag:newTag oldTag:oldTag matchWithPosition:false];
}
- (STTag*)AddTag:(STTag*)newTag {
  return [self AddTag:newTag oldTag:nil matchWithPosition:false];
}



@end
