//
//  STCodeFile.h
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STTag;
@class STFileHandler;
@protocol STIFileHandler;

/** 
@brief A sequence of instructions saved in a text file that can be executed
 in a statistical package (e.g. Stata, R, SAS), and will be used within
 a Word document to derive values that are placed into the document text.
*/
@interface STCodeFile : NSObject {
//  NSMutableArray<NSString *> *ContentCache;
  NSString* _StatisticalPackage;
  NSURL* _FilePath;
  NSDate* _LastCached;
  NSMutableArray<STTag*>*_Tags;
  
  NSMutableArray<NSString*>* _Content;

}

//NSMutableArray<NSString *> *onlyStrings

//@property NSMutableArray<NSString *> *ContentCache;
@property (copy, nonatomic) NSString *StatisticalPackage;
@property (copy, nonatomic) NSURL *FilePath;
@property (strong, nonatomic) NSDate *LastCached;
@property (strong, nonatomic) NSMutableArray<STTag *> *Tags;

@property (strong, nonatomic) NSMutableArray<NSString *> *Content;

/**
 @brief Return the contents of the CodeFile
 */
-(NSMutableArray*) LoadFileContent;
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


-(id)init:(NSObject<STIFileHandler>*)handler;
-(id)init;

-(NSString*)ToString;
-(void)Save:(NSError**)error;
-(void)SaveBackup:(NSError**)error;

-(NSDictionary *)toDictionary;

+(NSString*)SerializeObject:(STCodeFile*)codeFile error:(NSError**)error;
+(NSString*)SerializeList:(NSArray<STCodeFile*>*) files error:(NSError**)error;

+(STCodeFile*)DeserializeObject:(NSString*)codeFile error:(NSError**)error;
+(NSArray<STCodeFile*>*)DeserializeList:(NSString*)List error:(NSError**)error;

@end
