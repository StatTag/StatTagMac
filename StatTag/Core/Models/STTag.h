//
//  STTag.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STCodeFile;
@class STCommandResult;
@class STTableFormat;
@class STValueFormat;
@class STFigureFormat;

@interface STTag : NSObject <STJSONAble, NSCopying> {
  /*
   public CodeFile CodeFile { get; set; }
   public string Type { get; set; }
   public string Name { get; set; }
   public string RunFrequency { get; set; }
   public ValueFormat ValueFormat { get; set; }
   public FigureFormat FigureFormat { get; set; }
   public TableFormat TableFormat { get; set; }
   public List<CommandResult> CachedResult { get; set; }
   */
  STCodeFile* _CodeFile;
  NSString* _Type;
  NSString* _Name;
  NSString* _RunFrequency;
  STValueFormat* _ValueFormat;
  STFigureFormat* _FigureFormat;
  STTableFormat* _TableFormat;
  NSMutableArray<STCommandResult*>* _CachedResult;
  NSNumber* _LineStart;
  NSNumber* _LineEnd;
  
  NSString* _Id;
  NSString* _FormattedResult;
}


@property (strong, nonatomic) STCodeFile *CodeFile;
@property (copy, nonatomic) NSString *Type;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *RunFrequency;
@property (copy, nonatomic) STValueFormat *ValueFormat;
@property (copy, nonatomic) STFigureFormat *FigureFormat;
@property (copy, nonatomic) STTableFormat *TableFormat;
@property (strong, nonatomic) NSMutableArray<STCommandResult*> *CachedResult;
@property (readonly, nonatomic) NSString* Id;
/**
 Format the results for the tag.  This method assumes that the tag has
 received a cahced copy of the results it should format.  It does not call out to
 retrieve results if they are not set.
 */
@property (readonly, nonatomic) NSString* FormattedResult;

/**
 @brief The starting line is the 0-based line index where the opening tag tag exists.
 */
@property (copy, nonatomic) NSNumber *LineStart; //nil-able int

/**
 @brief The ending line is the 0-based line index where the closing tag tag exists.
 */
@property (copy, nonatomic) NSNumber *LineEnd; //nil-able int



+(instancetype)initWithTag:(STTag*)tag;


//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)SerializeObject:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;


-(NSString*)ToString;

/**
 A more specialized version of Equals that takes into account line numbers.  This is used when trying
 to disambiguate tags that have the same label in the same code file.
 */
- (BOOL) EqualsWithPosition:(STTag*)tag;

/**
 Ensure that all reserved characters that appear in an tag name are removed
 and replaced with a space.
 */
+ (NSString*)NormalizeName:(NSString*)label;

/**
 Determine if this tag is to represent a table
 */
- (BOOL)IsTableTag;
/**
 Determine if there is any table data saved and available for this tag.  It will perform this check
 regardless of the tag type (although it's not expected to be called for non-table tags).
 If the table was set but has 0 dimension, this will still return true.  It asserts that a table result
 was initialized.
 */
- (BOOL)HasTableData;

/**
 Update the underlying table data associated with this tag.
 */
- (void)UpdateFormattedTableData;

/**
 Get the dimensions for the displayable table.  This factors in not only the data, but if column and
 row labels are included.
 
 return type within array is: int
 */
- (NSArray<NSNumber*>*)GetTableDisplayDimensions;

@end
