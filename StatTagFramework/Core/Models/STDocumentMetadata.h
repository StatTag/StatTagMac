//
//  STDocumentMetadata.h
//  StatTag
//
//  Created by Eric Whitley on 1/18/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBase.h"


/** 
 This class provides supplemental metadata that we want to track within a
 Word document regarding StatTag's use and configuration.
 */

@interface STDocumentMetadata : STBase <NSCopying> {
  NSString* _MetadataFormatVersion;
  NSString* _TagFormatVersion;
  NSString* _StatTagVersion;
  NSString* _RepresentMissingValues;
  NSString* _CustomMissingValue;
}

/** 
 This will be the most recent version.  Please document here any changes in the version over time.
*/
+(NSString*)CurrentMetadataFormatVersion; //= "1.0.0";

/** 
 The version of the format used for metadata in this document (for this class).  This is
 defined by the version of StatTag that created the document.
 */
@property (copy, nonatomic) NSString* MetadataFormatVersion;

/**
 The version of the tag format that is used by this document.  This is defined by the version
 of StatTag that created the document.
*/
@property (copy, nonatomic) NSString* TagFormatVersion;

/**
 The version of StatTag last used to save the document
*/
@property (copy, nonatomic) NSString* StatTagVersion;

/**
 How StatTag should represent missing values within the Word document.
 The allowed values should come from Constants.MissingValueOption
*/
@property (copy, nonatomic) NSString* RepresentMissingValues;

/**
 If a missing value is represented by a user-defined string, this will
 be the string to use.  It may be set even if another missing value
 option is selected, just to preserve the user's previous choice.
*/
@property (copy, nonatomic) NSString* CustomMissingValue;

/**
 A catch-all collection of unknown fields that are preserved across the
 serialization and de-serialization process.
*/
//@property (strong, nonatomic) NSMutableDictionary* ExtraMetadata;


/**
 Take our settings for how missing values are to be represented, and convert them into
 a text representation that can be used in the user interface.
*/
-(NSString*) GetMissingValueReplacementAsString;


//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
//-(NSString*)SerializeObject:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;
-(void)setWithDictionary:(NSDictionary*)dict;

/**
 Create a new Tag object given a JSON string
 */
+(instancetype)Deserialize:(NSString*)json error:(NSError**)outError;
+(NSArray<STDocumentMetadata*>*)DeserializeList:(id)List error:(NSError**)outError;


@end
