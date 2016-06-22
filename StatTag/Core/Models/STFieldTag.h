//
//  STFieldTag.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTag.h"

/**
A specialized version of Tag that lives inside of fields within the
Word document.  This contains some additional attributes that pertain to an
instance of an Attribute within the documment, and not the general specification
of the Attribute.

@remark A good example is with a Table tag.  The Tag defines how the
table as a whole is formatted, while the FieldTag specifies a single cell
within the table.</remarks>

 */
@interface STFieldTag : STTag {
  NSNumber* _TableCellIndex; //nil-able int value
  NSURL* _CodeFilePath;
}

@property (nonatomic, copy) NSNumber* TableCellIndex;
/**
 Shortcut to the file path of the CodeFile.  This is used for serialization.
 */
@property (nonatomic, copy) NSURL* CodeFilePath;

//MARK: initializers
-(instancetype)initWithTag:(STTag*)tag;
-(instancetype)initWithTag:(STTag*)tag andTableCellIndex:(NSNumber*)tableCellIndex;
-(instancetype)initWithTag:(STTag*)tag andFieldTag:(STFieldTag*)fieldTag;
-(instancetype)initWithFieldTag:(STFieldTag*)tag;


//MARK: JSON
-(NSDictionary *)toDictionary;

/**
 Create a new Tag object given a JSON string
 */
-(instancetype)initWithJSONString:(NSString*)JSONString andfiles:(NSArray<STCodeFile*>*)files error:(NSError**)outError;

/**
 Provide a link to a FieldTag from a list of CodeFile objects
 */
+(void)LinkToCodeFile:(STFieldTag*)tag CodeFile:(NSArray<STCodeFile*>*)files;

/**
 Create a new Tag object given a JSON string
*/
+(instancetype)Deserialize:(NSString*)json withFiles:(NSArray<STCodeFile*>*)files error:(NSError**)outError;

/**
 Utility function called when a FieldTag is created from an existing tag and
 a cell index (meaning it's a table tag).  We want to update this tag to
 only carry the specific cell value.
 */
- (void)SetCachedValue;




@end
