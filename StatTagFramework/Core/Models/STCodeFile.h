//
//  STCodeFile.h
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONable.h"


@class STTag;
@class STFileHandler;
@protocol STIFileHandler;

/** 
@brief A sequence of instructions saved in a text file that can be executed
 in a statistical package (e.g. Stata, R, SAS), and will be used within
 a Word document to derive values that are placed into the document text.
*/
@interface STCodeFile : NSObject <NSCopying, STJSONAble> {
  NSString* _StatisticalPackage;
  NSString* _FilePath;
  NSURL* _FilePathURL;
  NSDate* _LastCached;
  NSMutableArray<STTag*>*_Tags;
  
  NSMutableArray<NSString*>* _Content;
  NSMutableArray<NSString *> *ContentCache;
}

@property (copy, nonatomic) NSString *StatisticalPackage;
@property (copy, nonatomic) NSString *FilePath;
@property (copy, nonatomic) NSURL *FilePathURL;
@property (copy, nonatomic) NSDate *LastCached;
@property (strong, nonatomic) NSMutableArray<STTag *> *Tags;

@property (strong, nonatomic) NSMutableArray<NSString *> *Content;
@property (copy, nonatomic) NSString* ContentString;

/**
 @brief Return the contents of the CodeFile
 */
-(NSMutableArray<NSString *>*) LoadFileContent;
/**
 @brief Return the contents of the CodeFile
 */
- (void) RefreshContent;

/**
 Using the contents of this file, parse the instrutions and build the list
 of tags that are present and cache them for later use.
 */
-(void)LoadTagsFromContent:(BOOL)preserveCache;
-(void)LoadTagsFromContent;


-(instancetype)init:(NSObject<STIFileHandler>*)handler;
-(instancetype)init;
+(instancetype)codeFileWithFilePath:(NSString*)filePath;
+(instancetype)codeFileWithFilePath:(NSString*)filePath andTags:(NSArray<STTag*>*)tags;

-(NSString*)FileName;


- (NSUInteger)hash;
- (BOOL)isEqual:(id)object;

-(NSString*)ToString;
-(NSString*)description;
-(void)Save:(NSError**)error;
-(void)SaveBackup:(NSError**)error;


//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;

/**
 Utility method to serialize the list of code files into a JSON array.
 */
+(NSString*)SerializeList:(NSArray<STCodeFile*>*)list error:(NSError**)error;
/**
 Utility method to take a JSON array string and convert it back into a list of
 CodeFile objects.  This does not resolve the list of tags that may be
 associated with the CodeFile.
 */
+(NSArray<STCodeFile*>*)DeserializeList:(id)List error:(NSError**)error;


//MARK: other
+ (NSString*) GuessStatisticalPackage:(NSString*) path;
/**
 Removes an tag from the file, and from the internal cache.
 */
- (void)RemoveTag:(STTag*)tag;

/**
 Updates or inserts an tag in the file.  An update takes place only if oldTag is defined, and it is able to match that old tag.

 @ param matchWithPosition: When looking to replace an existing tag (which assumes that oldTag is specified), this parameter when set to true will only replace the tag if the line numbers match.  This is to be used when updating duplicate named tags, but shouldn't be used otherwise.</param>

 */
- (STTag*)AddTag:(STTag*)newTag oldTag:(STTag*)oldTag matchWithPosition:(BOOL)matchWithPosition;
- (STTag*)AddTag:(STTag*)newTag oldTag:(STTag*)oldTag;
- (STTag*)AddTag:(STTag*)newTag;

/**
 Look at all of the tags that are defined within this code file, and create a list
 of any tags that have duplicate names.
 */
-(NSDictionary<STTag*, NSArray<STTag*>*>*)FindDuplicateTags;

/**
 Given the content passed as a parameter, this method updates the file on disk with the new
 content and refreshes the internal cache.
 */
-(void)UpdateContent:(NSString*)text error:(NSError*)outError;

@end
