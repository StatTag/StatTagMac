//
//  STConstants.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//
/*
 This is a temporary approach to match the .NET.
 
 We should look at other options 
 */

#import <Foundation/Foundation.h>

extern NSString *const STStatTagErrorDomain;

@interface STConstantsStatisticalPackages : NSObject
+(NSString*)Stata;
+(NSString*)R;
+(NSString*)SAS;
+(NSArray<NSString *>*)GetList;
@end

@interface STConstantsRunFrequency : NSObject
+(NSString*)Always;
+(NSString*)OnDemand;
+(NSArray<NSString *>*)GetList;
@end

@interface STConstantsTagType : NSObject
+(NSString*)Value;
+(NSString*)Figure;
+(NSString*)Table;
+(NSString*)Verbatim;
+(NSArray<NSString *>*)GetList;
@end

@interface STConstantsValueFormatType : NSObject
+(NSString*)Default;
+(NSString*)Numeric;
+(NSString*)DateTime;
+(NSString*)Percentage;
+(NSArray<NSString *>*)GetList;
@end

@interface STConstantsDialogLabels : NSObject
+(NSString*)Elipsis;
+(NSString*)Details;
+(NSString*)Edit;
@end

@interface STConstantsFileFilters : NSObject
+(NSString*)StataLabel;
+(NSString*)StataFilter;
+(NSString*)RLabel;
+(NSString*)RFilter;
+(NSString*)SASLabel;
+(NSString*)SASFilter;
+(NSString*)AllLabel;
+(NSString*)AllFilter;
+(NSString*)SupportedLabel;
+(NSString*)SupportedFileFilters;
+(NSString*)FormatForOpenFileDialog;
+(NSArray<NSString*>*)SupportedFileFiltersArray;
@end

@interface STConstantsFileExtensions : NSObject
+(NSString*)Backup;
@end

@interface STConstantsPlaceholders : NSObject
+(NSString*)EmptyField;
+(NSString*)RemovedField;
@end

@interface STConstantsReservedCharacters : NSObject
+(NSString*)TagTableCellDelimiter;
+(NSString*)ListDelimiter;
+(NSString*)RangeDelimiter;
@end

@interface STConstantsFieldDetails : NSObject
+(NSString*)MacroButtonName;
@end

/**
 @brief A list of parameter names that are available across all types of tags.
 */
@interface STConstantsTagParameters : NSObject
+(NSString*)Id;
+(NSString*)Label;
+(NSString*)Frequency;
@end

@interface STConstantsValueParameters : NSObject
+(NSString*)Type;
+(NSString*)Decimals;
+(NSString*)UseThousands;
+(NSString*)DateFormat;
+(NSString*)TimeFormat;
+(NSString*)AllowInvalidTypes;
@end

@interface STConstantsTableParameters : NSObject
//+(NSString*)ColumnNames;
//+(NSString*)RowNames;
+(NSString*) FilterEnabled;
+(NSString*) FilterType;
+(NSString*) FilterValue;
@end

@interface STConstantsTableParameterDefaults : NSObject
//+(BOOL)ColumnNames;
//+(BOOL)RowNames;
+(BOOL) FilterEnabled;
+(NSString*) FilterType;
+(NSString*) FilterValue;
@end

@interface STConstantsValueParameterDefaults : NSObject
+(BOOL)AllowInvalidTypes;
@end

@interface STConstantsCodeFileComment : NSObject
+(NSString*)Stata;
+(NSString*)R;
+(NSString*)SAS;
@end

@interface STConstantsCodeFileCommentSuffix : NSObject
+(NSString*)Default;
+(NSString*)SAS;
@end


@interface STConstantsTagTags : NSObject
+(NSString*)StartTag;
+(NSString*)EndTag;
+(NSString*)TagPrefix;
+(NSString*)ParamStart;
+(NSString*)ParamEnd;
@end

@interface STConstantsParserFilterMode : NSObject
+(NSInteger)IncludeAll;
+(NSInteger)ExcludeOnDemand;
+(NSInteger)TagList;
@end

@interface STConstantsExecutionStepType : NSObject
+(NSInteger)CodeBlock;
+(NSInteger)Tag;
@end

@interface STConstantsDateFormats : NSObject
+(NSString*)MMDDYYYY;
+(NSString*)MonthDDYYYY;
+(NSArray<NSString *>*)GetList;
@end

@interface STConstantsTimeFormats : NSObject
+(NSString*)HHMM;
+(NSString*)HHMMSS;
+(NSArray<NSString *>*)GetList;
@end

@interface STConstantsDimensionIndex : NSObject
+(NSInteger)Rows;
+(NSInteger)Columns;
@end

@interface STConstantsCodeFileActionTask : NSObject
+(NSInteger)NoAction;
+(NSInteger)ChangeFile;
+(NSInteger)RemoveTags;
+(NSInteger)ReAddFile;
+(NSInteger)SelectFile;
@end

@interface STConstantsFilterPrefix : NSObject
+(NSString*)Row;
+(NSString*)Column;
@end

@interface STConstantsFilterType : NSObject
+(NSString*)Exclude;
+(NSString*)Include;
+(NSArray<NSString *>*)GetList;
@end
