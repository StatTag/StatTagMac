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
@end

@interface STConstantsValueFormatType : NSObject
+(NSString*)Default;
+(NSString*)Numeric;
+(NSString*)DateTime;
+(NSString*)Percentage;
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
+(NSString*)FormatForOpenFileDialog;
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
+(NSString*)ColumnNames;
+(NSString*)RowNames;
@end

@interface STConstantsTableParameterDefaults : NSObject
+(BOOL)ColumnNames;
+(BOOL)RowNames;
@end

@interface STConstantsValueParameterDefaults : NSObject
+(BOOL)AllowInvalidTypes;
@end

@interface STConstantsCodeFileComment : NSObject
+(NSString*)Stata;
+(NSString*)R;
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
+(int)IncludeAll;
+(int)ExcludeOnDemand;
+(int)TagList;
@end

@interface STConstantsExecutionStepType : NSObject
+(int)CodeBlock;
+(int)Tag;
@end

@interface STConstantsDateFormats : NSObject
+(NSString*)MMDDYYYY;
+(NSString*)MonthDDYYYY;
@end

@interface STConstantsTimeFormats : NSObject
+(NSString*)HHMM;
+(NSString*)HHMMSS;
@end

@interface STConstantsDimensionIndex : NSObject
+(int)Rows;
+(int)Columns;
@end

@interface STConstantsCodeFileActionTask : NSObject
+(int)NoAction;
+(int)ChangeFile;
+(int)RemoveTags;
+(int)ReAddFile;
+(int)SelectFile;
@end

