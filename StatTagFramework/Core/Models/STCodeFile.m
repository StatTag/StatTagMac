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
#import "STICodeFileParser.h"
#import "STConstants.h"
#import "STIGenerator.h"

@implementation STCodeFile

//@synthesize ContentCache = ContentCache;
@synthesize StatisticalPackage = _StatisticalPackage;
@synthesize FilePath = _FilePath;
@synthesize LastCached = _LastCached;
@synthesize Tags = _Tags;


//URL form accessor for FilePath
-(void)setFilePathURL:(NSURL*) u {
  [self setFilePath:[u path]];
}
-(NSURL*)FilePathURL {
  NSURL* url;
  if ([self FilePath] == nil) {
    return url;
  }
  @try {
    url = [NSURL fileURLWithPath:[self FilePath]];
  }
  @catch (NSException * e) {
    //NSLog(@"Exception creating URL (%@): %@", NSStringFromClass([self class]), [self FilePath]);
  }
  @finally {
  }
  return url;
}

//we're using custom setters/getters because there are places where we are overwriting the tag data as an immutable array - we want to avoid that as it breaks some of our updates
-(NSMutableArray<STTag*>*)Tags
{
  if(_Tags == nil)
  {
    _Tags = [[NSMutableArray<STTag*> alloc] init];
    [self LoadTagsFromContent:true];
  }
  return _Tags;
}
-(void)setTags:(NSArray<STTag*>*)tags
{
  _Tags = [[NSMutableArray<STTag*> alloc] initWithArray:tags];
}

-(NSString*)FileName {
  NSString* fileName = [[self FilePath] lastPathComponent];
  if([fileName isEqualToString:[self FilePath]])
  {
    //may be a Windows path
    // I get valid URLs back from these, but can't pluck out just the file name
    // It's flagged as a valid file URL, but the file name can't be pulled out
    // can't determine the best way to approach this, so I'm going to try a quick work-around
    fileName = [[[self FilePath] componentsSeparatedByString:@"\\"] lastObject];
  }
  return fileName;
}

-(NSString*)DirectoryPathString {
  NSString* folderPath = [self FilePath];
  NSRange lastFileNamePosition = [[self FilePath] rangeOfString:[self FileName] options:NSBackwardsSearch];
  if(lastFileNamePosition.location != NSNotFound) {
    folderPath = [folderPath stringByReplacingCharactersInRange:lastFileNamePosition withString:@""];
  }
  return folderPath;
}


-(void)setStatisticalPackage:(NSString *)StatisticalPackage {
  _StatisticalPackage = StatisticalPackage;
}
-(NSString*)StatisticalPackage {
  if(_StatisticalPackage == nil || [_StatisticalPackage length] <= 0) {
    _StatisticalPackage = [STCodeFile GuessStatisticalPackage:[self FilePath]];
  }
  return _StatisticalPackage;
}

//@synthesize Content = _Content;
- (void) setContent:(NSMutableArray *)c {
  //_Content = c;
  ContentCache = c;
}
- (NSMutableArray*) Content {
  if(ContentCache == nil) {
    ContentCache = [self LoadFileContent];
  }
  return ContentCache;
  //return _Content;
}

-(NSString*)ContentString
{
  return [[self Content] componentsJoinedByString:@"\n"];
}
-(void)setContentString:(NSString*)content
{
  [self setContent:[NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]]];
}

/**
 This is typically a lightweight wrapper around the standard
 File class, but is used to allow us to mock file IO during
 our unit tests.
 */
NSObject<STIFileHandler>* _FileHandler;

//MARK: initializers
-(instancetype)init{
  self = [super init];
  if(self){
    [self initialize:nil];
  }
  return self;
}
-(instancetype)init:(NSObject<STIFileHandler>*)handler {
  self = [super init];
  if(self){
    [self initialize:handler];
  }
  return self;
}
+(instancetype)codeFileWithFilePath:(NSString*)filePath{
  return [STCodeFile codeFileWithFilePath:filePath andTags:nil];
}
+(instancetype)codeFileWithFilePath:(NSString*)filePath andTags:(NSArray<STTag*>*)tags {
  STCodeFile* f = [[STCodeFile alloc] init];
  f.FilePath = filePath;
  f.Tags = [NSMutableArray<STTag*> arrayWithArray:tags];
  return f;
}
-(void)initialize:(NSObject<STIFileHandler>*)handler {
  _Tags = [[NSMutableArray<STTag*> alloc] init];
  _FileHandler = handler ? handler :[[STFileHandler alloc] init];
  //NSLog(@"_FileHandler : %@", _FileHandler);
}

//MARK: copying
-(id)copyWithZone:(NSZone *)zone
{
//  STCodeFile *codeFile = [[[self class] allocWithZone:zone] init];
  STCodeFile *codeFile = (STCodeFile*)[super copyWithZone:zone];

  codeFile.StatisticalPackage = [_StatisticalPackage copyWithZone:zone];
  codeFile.FilePath = [_FilePath copyWithZone:zone];
  codeFile.LastCached = [_LastCached copyWithZone:zone];
  codeFile.Tags = [_Tags copyWithZone:zone];
  
  return codeFile;
}


//MARK:methods

-(NSString*)ToString {
  return _FilePath ? _FilePath : @"";
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
  if(other == nil) {
    return false;
  }
  return ([[other FilePath] caseInsensitiveCompare:_FilePath] == NSOrderedSame);
}


/**
 @brief Return the contents of the CodeFile
*/
- (NSMutableArray<NSString*>*) LoadFileContent {
  [self RefreshContent];
  return ContentCache;
}

/**
 @brief Return the contents of the CodeFile
*/
- (void) RefreshContent {
  NSError *error;
  //why is this possibly blowing up if we attempt to access the result directly? and only occasionally?
//  id result = [_FileHandler ReadAllLines:[self FilePathURL] error:&error];
//  if(result && [[result class] isEqualTo:[NSArray class]])
//  {
//    ContentCache = [result mutableCopy];
//  }
  ContentCache = [NSMutableArray arrayWithArray:[_FileHandler ReadAllLines:[self FilePathURL] error:&error]];
}

/**
 Using the contents of this file, parse the instructions and build the list
 of tags that are present and cache them for later use.
*/
-(void)LoadTagsFromContent {
  [self LoadTagsFromContent:true];
}
-(void)LoadTagsFromContent:(BOOL)preserveCache {
  NSArray<STTag*>* savedTags;
  if(preserveCache){
    savedTags = [[NSArray<STTag*> alloc] initWithArray:_Tags];    
  }
  else {
    NSLog(@"Not saving cache");
  }
  
  // Any time we try to load, reset the list of tags that may exist
  _Tags = [[NSMutableArray<STTag*> alloc] init];
  
  NSArray<NSString*> *content = [self LoadFileContent];
  if(content == nil || [content count] == 0){
    return;
  }
  
  NSObject<STICodeFileParser>* parser = [STFactories GetParser:self];
  if (parser == nil) {
    return;
  }
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  NSPredicate *tagPredicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
    return [[[aTag Type] stringByTrimmingCharactersInSet: ws] length] != 0;
  }];
  _Tags = [NSMutableArray<STTag*> arrayWithArray:[[parser Parse:self] filteredArrayUsingPredicate:tagPredicate]];
  for(STTag* tag in _Tags) {
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
  [_FileHandler WriteAllLines:[self FilePathURL] withContent:[self Content] error:error];
}

/**
 Save a backup copy of this code file, in the event we cause issues with the file and the
 user needs to restore it.
*/
-(void)SaveBackup:(NSError**)error {
  NSURL *backupFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@.%@", [[self FilePathURL] path], [STConstantsFileExtensions Backup]]];
  
  if (![_FileHandler Exists:backupFile error:error])
  {
    [_FileHandler Copy:[self FilePathURL] toDestinationFile:backupFile error:error];
  }
}

//MARK: JSON
//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[super toDictionary]];

  [dict setValue:[self StatisticalPackage] forKey:@"StatisticalPackage"];
  [dict setValue:[self FilePath] forKey:@"FilePath"];
  [dict setValue:[STJSONUtility convertDateToDateString:self.LastCached] forKey:@"LastCached"]; //format?
  //[dict setValue:ContentCache forKey:@"ContentCache"];
  return dict;
}


-(bool)setCustomObjectPropertyFromJSONObject:(id)object forKey:(NSString*)key
{
  if([key isEqualToString:@"FilePath"]) {
    //[self setValue:[[NSURL alloc] initWithString:[dict valueForKey:key]] forKey:key];
    [self setValue:object forKey:key];
  } else if([key isEqualToString:@"LastCached"]) {
    [self setValue:[STJSONUtility dateFromString:object] forKey:key];
    ////NSLog(@"LastCached : %@", [self LastCached]);
  } else {
    return false;
  }
  return true;
}

-(void)afterSetWithDictionary
{
  [super afterSetWithDictionary];
  if(_FileHandler == nil) {
    _FileHandler = [[STFileHandler alloc] init];
  }
}


//
//-(void)setWithDictionary:(NSDictionary*)dict {
//  if(dict == nil || [dict isKindOfClass:[[NSNull null] class]])
//  {
//    return;
//  }
//
//  for (NSString* key in dict) {
//    if([key isEqualToString:@"FilePath"]) {
//      //[self setValue:[[NSURL alloc] initWithString:[dict valueForKey:key]] forKey:key];
//      [self setValue:[dict valueForKey:key] forKey:key];
//    } else if([key isEqualToString:@"LastCached"]) {
//      [self setValue:[STJSONUtility dateFromString:[dict valueForKey:key]] forKey:key];
//      ////NSLog(@"LastCached : %@", [self LastCached]);
//    } else {
//      [self setValue:[dict valueForKey:key] forKey:key];
//    }
//  }
//  if(_FileHandler == nil) {
//    _FileHandler = [[STFileHandler alloc] init];
//  }
//}
//
//-(NSString*)Serialize:(NSError**)error
//{
//  return [STJSONUtility SerializeObject:self error:nil];
//}
//
///**
// Utility method to serialize the list of code files into a JSON array.
// */
//+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
//  return [STJSONUtility SerializeList:list error:nil];
//}
//
///**
// Utility method to take a JSON array string and convert it back into a list of
// CodeFile objects.  This does not resolve the list of tags that may be
// associated with the CodeFile.
// */
////+(NSArray<STCodeFile*>*)DeserializeList:(NSString*)List error:(NSError**)outError
//+(NSArray<STCodeFile*>*)DeserializeList:(id)List error:(NSError**)outError
//{
//  NSMutableArray<STCodeFile*>* ar = [[NSMutableArray<STCodeFile*> alloc] init];
//  for(id x in [STJSONUtility DeserializeList:List forClass:[self class] error:nil]) {
//    if([x isKindOfClass:[self class]])
//    {
//      [ar addObject:x];
//    }
//  }
//  return ar;
//}
//
//-(instancetype)initWithDictionary:(NSDictionary*)dict
//{
//  self = [super init];
//  if (self) {
//    if(dict != nil  && ![dict isKindOfClass:[[NSNull null] class]])
//    {
//      [self setWithDictionary:dict];
//    }
//  }
//  return self;
//}
//
//-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
//{
//  self = [super init];
//  if (self) {
//    NSError *error = nil;
//    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
//    
//    if (!error && JSONDictionary) {
//      [self setWithDictionary:JSONDictionary];
//    } else {
//      if (outError) {
//        *outError = [NSError errorWithDomain:STStatTagErrorDomain
//                                        code:[error code]
//                                    userInfo:@{NSUnderlyingErrorKey: error}];
//      }
//    }
//  }
//  return self;
//}




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
  if ([STCodeFile FilterMatches:[STConstantsFileFilters RMarkdownFilter] path:path]) {
    return [STConstantsStatisticalPackages RMarkdown];
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

  [STCodeFile OffsetTagListByRemovedTag:_Tags removedTag:tag];
  
  [self setContent:ContentCache];
  
}

+(void) OffsetTagListByRemovedTag:(NSArray<STTag*>*) tagList removedTag:(STTag*)removedTag
{
  // Any tags below the one being removed need to be adjusted
  for(STTag* otherTag in tagList){
    // If the other tag starts after the removed tag ends, we need to offset
    // the start and end by two (one for each of the lines that were removed
    // for the start and end comments, respectively)
    if([otherTag LineStart] > [removedTag LineEnd]) {
      NSInteger _lineStart = [[otherTag LineStart] integerValue] -2;
      otherTag.LineStart = [NSNumber numberWithInteger:_lineStart];
      
      NSInteger _lineEnd = [[otherTag LineEnd] integerValue] -2;
      otherTag.LineEnd = [NSNumber numberWithInteger:_lineEnd];
    }
    // If the other tag only starts after the removed tag ends, we just offset
    // by one to account for the removed start tag.  The removed end tag
    // won't affect us.
    else if([otherTag LineStart] > [removedTag LineStart]) {
      NSInteger _lineStart = [[otherTag LineStart] integerValue] -1;
      otherTag.LineStart = [NSNumber numberWithInteger:_lineStart];
      
      NSInteger _lineEnd = [[otherTag LineEnd] integerValue] -1;
      otherTag.LineEnd = [NSNumber numberWithInteger:_lineEnd];
    }
    // If the other tag starts before the removed tag starts, the start position
    // isn't impacted.  But if it ends after the removed tag starts, we need to
    // offset just our end position by 2
    else if([otherTag LineStart] < [removedTag LineStart] && [otherTag LineEnd] > [removedTag LineEnd]) {
      NSInteger _lineEnd = [[otherTag LineEnd] integerValue] -2;
      otherTag.LineEnd = [NSNumber numberWithInteger:_lineEnd];
    }
    // If the other tag starts before the removed tag starts, the start position
    // isn't impacted.  But if it ends after the removed tag end, we need to
    // offset just our end position by 1
    else if([otherTag LineStart] < [removedTag LineStart] && [otherTag LineEnd] > [removedTag LineStart]) {
      NSInteger _lineEnd = [[otherTag LineEnd] integerValue] -1;
      otherTag.LineEnd = [NSNumber numberWithInteger:_lineEnd];
    }
  }
}

/**
 Removes a tag from the file, and from the internal cache.  This is different from RemoveTag in that
 it does additional processing and handling of tags that may exist in the code file, but aren't known
 (weren't loaded) because they collided with another tag.
 */
- (void)RemoveCollidingTag:(STTag*)tag
{
  if (tag == nil) {
    return;
  }

  if([_Tags containsObject:tag]) {
    [_Tags removeObject:tag];
  } else {
    // If the exact object doesn't match, then search by equality.  Note that it's okay if we don't
    // find the tag.  That just means it wasn't loaded.  We still want to proceed with removing
    // the lines from the content cache.
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
      return [aTag isEqual:tag];
    }];
    STTag *foundTag = [[_Tags filteredArrayUsingPredicate:predicate] firstObject];
    if (foundTag != nil) {
      [_Tags removeObject:foundTag];
    }
  }

  [ContentCache removeObjectAtIndex:[[tag LineEnd] integerValue]]; //risky...
  [ContentCache removeObjectAtIndex:[[tag LineStart] integerValue]]; //risky...

  // Any tags below the one being removed need to be adjusted
  for (STTag* otherTag in _Tags){
    // If the other tag starts after the removed tag ends, we need to offset
    // the start and end by two (one for each of the lines that were removed
    // for the start and end comments, respectively)
    if([otherTag LineStart] > [tag LineEnd]) {
      NSInteger _lineStart = [[otherTag LineStart] integerValue] - 2;
      otherTag.LineStart = [NSNumber numberWithInteger:_lineStart];

      NSInteger _lineEnd = [[otherTag LineEnd] integerValue] - 2;
      otherTag.LineEnd = [NSNumber numberWithInteger:_lineEnd];
    }
    // If the other tag only starts after the removed tag ends, we just offset
    // by one to account for the removed start tag.  The removed end tag
    // won't affect us.
    else if (otherTag.LineStart > tag.LineStart) {
      NSInteger _lineStart = [[otherTag LineStart] integerValue] - 1;
      otherTag.LineStart = [NSNumber numberWithInteger:_lineStart];

      NSInteger _lineEnd = [[otherTag LineEnd] integerValue] - 1;
      otherTag.LineEnd = [NSNumber numberWithInteger:_lineEnd];
    }
  }

  [self setContent:ContentCache];
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

  if ([[newTag LineStart] intValue] > [[newTag LineEnd] intValue])
  {
    //FIXME: we shouldn't be doing things this way - fix
    [NSException raise:@"Invalid LineStart and LineEnd" format:@"The new tag start index is after the end index, which is not allowed."];
  }

  STTag* updatedTag = [[STTag alloc]initWithTag:newTag];
  
  NSMutableArray<NSString*>* content = [self Content];  // Force cache to load so we can reference it later w/o accessor overhead
  #pragma unused(content) //touching this just forces things to work - ignore the variable not being used

  if(oldTag != nil) {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
      //return [aTag isEqual:oldTag];
      return [aTag Equals:oldTag usePosition:matchWithPosition];
    }];
    STTag *refreshedOldTag = [[_Tags filteredArrayUsingPredicate:predicate] firstObject];
    
    if (refreshedOldTag == nil)
    {
      //FIXME: we shouldn't be doing things this way - fix
      [NSException raise:@"Unable to find the existing tag to update." format:@"Unable to find the existing tag to update."];
    }
    
    if ([[refreshedOldTag LineStart] integerValue] > [[refreshedOldTag LineEnd] integerValue])
    {
      //FIXME: we shouldn't be doing things this way - fix
      [NSException raise:@"Invalid LineStart and LineEnd" format:@"The new tag start index is after the end index, which is not allowed."];
    }

    // Remove the starting tag and then adjust indices as appropriate
    [ContentCache removeObjectAtIndex:[[refreshedOldTag LineStart] integerValue] ];

    if ([[updatedTag LineStart] integerValue] > [[refreshedOldTag LineStart] integerValue])
    {
      updatedTag.LineStart = [NSNumber numberWithInteger:[[updatedTag LineStart] integerValue] -1 ];
      updatedTag.LineEnd = [NSNumber numberWithInteger:[[updatedTag LineEnd] integerValue] -1 ]; // We know line end >= line start
    }
    else if ([[updatedTag LineEnd] integerValue] > [[refreshedOldTag LineStart] integerValue])
    {
      updatedTag.LineEnd = [NSNumber numberWithInteger:[[updatedTag LineEnd] integerValue] -1 ]; // We know line end >= line start
    }

    refreshedOldTag.LineEnd = [NSNumber numberWithInteger:[[refreshedOldTag LineEnd] integerValue] -1 ]; // Don't forget to adjust the old tag index
    [ContentCache removeObjectAtIndex:[[refreshedOldTag LineEnd] integerValue] ];
    if ([[updatedTag LineStart] integerValue] > [[refreshedOldTag LineEnd] integerValue])
    {
      updatedTag.LineStart = [NSNumber numberWithInteger:[[updatedTag LineStart] integerValue] -1 ];
      updatedTag.LineEnd = [NSNumber numberWithInteger:[[updatedTag LineEnd] integerValue] -1 ];
    }
    else if ([[updatedTag LineEnd] integerValue] >= [[refreshedOldTag LineEnd] integerValue])
    {
      updatedTag.LineEnd = [NSNumber numberWithInteger:[[updatedTag LineEnd] integerValue] -1 ];
    }

    //FIXME: this should be replaced with better nsindexset search and removal
    /* NOTE: leaving this in here for reference so we don't repeat the same mistake I did initially.
     
     We CANNOT use object equality to find tags here. The initial predicate match is fine, but the later "remove objects in array" uses an equality comparison, which basically undoes our specialized "match with position" logic below.
     
     Instead, we're going to do what I should have done initially - and what Luke did in the original c# - which is find and remove by _index_.
     
    predicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
      return [aTag Equals:refreshedOldTag usePosition:matchWithPosition];
    }];
    NSArray<STTag*>* foundTags = [_Tags filteredArrayUsingPredicate:predicate];
    [_Tags removeObjectsInArray:foundTags];
     */
    
    NSMutableIndexSet* tagIndexes = [[NSMutableIndexSet alloc] init];
    [_Tags enumerateObjectsUsingBlock:^(STTag* aTag, NSUInteger idx, BOOL *stop) {
      if([aTag Equals:refreshedOldTag usePosition:matchWithPosition]){
        [tagIndexes addIndex:idx];
      }
    }];
    [_Tags removeObjectsAtIndexes:tagIndexes];

  }

  NSObject<STIGenerator>* generator = [STFactories GetGenerator:self];
  if (generator == nil) {
    return nil;
  }
  
  [ContentCache insertObject:[generator CreateOpenTag:updatedTag] atIndex:[[updatedTag LineStart] integerValue]];
  updatedTag.LineEnd = [NSNumber numberWithInteger:[[updatedTag LineEnd] integerValue] +2 ]; // Offset one line for the opening tag, the second line is for the closing tag

  [ContentCache insertObject:[generator CreateClosingTag] atIndex:[[updatedTag LineEnd] integerValue]];
  
  // Add to our collection of tags
  [_Tags addObject:updatedTag];
  return updatedTag;
}
- (STTag*)AddTag:(STTag*)newTag oldTag:(STTag*)oldTag {
  return [self AddTag:newTag oldTag:oldTag matchWithPosition:false];
}
- (STTag*)AddTag:(STTag*)newTag {
  return [self AddTag:newTag oldTag:nil matchWithPosition:false];
}

/**
 Look at all of the tags that are defined within this code file, and create a list
 of any tags that have duplicate names.
 */
-(NSDictionary<STTag*, NSArray<STTag*>*>*)FindDuplicateTags {
  
  NSMutableDictionary<STTag*, NSMutableArray<STTag*>*>* duplicates = [[NSMutableDictionary<STTag*, NSMutableArray<STTag*>*> alloc] init];

  if (_Tags == nil)
  {
    return duplicates;
  }
  

  NSMutableDictionary<NSString*, STTag*>* distinct = [[NSMutableDictionary<NSString*, STTag*> alloc] init];
  
  for (STTag* tag in _Tags)
  {
    NSString* searchLabel = [[tag Name] uppercaseString];
    
    // See if we already have this in the distinct list of tag names
    if([distinct objectForKey:searchLabel] != nil)
    {
      // If the duplicates collection hasn't been initialized, we will do that now.
      if([duplicates objectForKey:[distinct objectForKey:searchLabel]] == nil)
      {
        [duplicates setObject:[[NSMutableArray<STTag*> alloc] init] forKey:[distinct objectForKey:searchLabel]];
      }
      NSMutableArray<STTag*>* someTags = [duplicates objectForKey:[distinct objectForKey:searchLabel]];
      [someTags addObject:tag];
      [duplicates setObject:someTags forKey:[distinct objectForKey:searchLabel]];
    }
    else
    {
      [distinct setObject:tag forKey:[[tag Name] uppercaseString]];
    }
  }
  return duplicates;
}

/**
 Given the content passed as a parameter, this method updates the file on disk with the new
 content and refreshes the internal cache.
 */
-(void)UpdateContent:(NSString*)text error:(NSError*)outError {
  NSError* error;
  [_FileHandler WriteAllText:[self FilePathURL] withContent:text error:&error];
  [self LoadTagsFromContent];
}


@end
