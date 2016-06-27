//
//  STConstants.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STConstants.h"

NSString *const STStatTagErrorDomain = @"StatTagErrorDomain";

@implementation STConstantsStatisticalPackages
+(NSString*)Stata { return @"Stata";}
+(NSString*)R { return @"R";}
+(NSString*)SAS { return @"SAS";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsStatisticalPackages Stata], [STConstantsStatisticalPackages R], [STConstantsStatisticalPackages SAS], nil];
}
@end

@implementation STConstantsRunFrequency
+(NSString*)Always { return @"Always";}
+(NSString*)OnDemand { return @"On Demand";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsRunFrequency Always], [STConstantsRunFrequency OnDemand], nil];
}
@end

@implementation STConstantsTagType
+(NSString*)Value { return @"Value";}
+(NSString*)Figure { return @"Figure";}
+(NSString*)Table { return @"Table";}
@end

@implementation STConstantsValueFormatType
+(NSString*)Default { return @"Default";}
+(NSString*)Numeric { return @"Numeric";}
+(NSString*)DateTime { return @"DateTime";}
+(NSString*)Percentage { return @"Percentage";}
@end

@implementation STConstantsDialogLabels
+(NSString*)Elipsis { return @"...";}
+(NSString*)Details { return @"Detail";}
+(NSString*)Edit { return @"Edit";}
@end

@implementation STConstantsFileFilters
+(NSString*)StataLabel { return @"Stata Do Files";}
+(NSString*)StataFilter { return @"*.do*.ado";}
+(NSString*)RLabel { return @"R";}
+(NSString*)RFilter { return @"*.r";}
+(NSString*)SASLabel { return @"SAS";}
+(NSString*)SASFilter { return @"*.sas";}
+(NSString*)AllLabel { return @"All files";}
+(NSString*)AllFilter { return @"*.*";}
+(NSString*)FormatForOpenFileDialog {
  return [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@",
          [STConstantsFileFilters StataLabel],
          [STConstantsFileFilters StataFilter],
          [STConstantsFileFilters RLabel],
          [STConstantsFileFilters RFilter],
          [STConstantsFileFilters SASLabel],
          [STConstantsFileFilters SASFilter],
          [STConstantsFileFilters AllLabel],
          [STConstantsFileFilters AllFilter]
        ];
}
@end

@implementation STConstantsFileExtensions
+(NSString*)Backup { return @"st-bak";}
@end

@implementation STConstantsPlaceholders
+(NSString*)EmptyField { return @"[NO RESULT]";}
+(NSString*)RemovedField { return @"[REMOVED]";}
@end

@implementation STConstantsReservedCharacters
+(NSString*)TagTableCellDelimiter { return @"|";}
  @end
  
@implementation STConstantsFieldDetails
+(NSString*)MacroButtonName { return @"StatTag";}
@end

@implementation STConstantsTagParameters
+(NSString*)Id { return @"Id";}
+(NSString*)Label { return @"Label";}
+(NSString*)Frequency { return @"Frequency";}
@end

@implementation STConstantsValueParameters
+(NSString*)Type { return @"Type";}
+(NSString*)Decimals { return @"Decimals";}
+(NSString*)UseThousands { return @"Thousands";}
+(NSString*)DateFormat { return @"DateFormat";}
+(NSString*)TimeFormat { return @"TimeFormat";}
+(NSString*)AllowInvalidTypes { return @"AllowInvalid";}
@end

@implementation STConstantsTableParameters
+(NSString*)ColumnNames { return @"ColumnNames";}
+(NSString*)RowNames { return @"RowNames";}
@end

@implementation STConstantsTableParameterDefaults
+(BOOL)ColumnNames { return FALSE;}
+(BOOL)RowNames { return FALSE;}
@end

@implementation STConstantsValueParameterDefaults
+(BOOL)AllowInvalidTypes { return FALSE;}
@end

@implementation STConstantsCodeFileComment
+(NSString*)Stata { return @"*";}
+(NSString*)R { return @"*";}
+(NSString*)SAS { return @"*";}
@end

@implementation STConstantsTagTags
+(NSString*)StartTag { return @">>>";}
+(NSString*)EndTag { return @"<<<";}
+(NSString*)TagPrefix { return @"ST:";}
+(NSString*)ParamStart { return @"(";}
+(NSString*)ParamEnd { return @")";}
@end

@implementation STConstantsParserFilterMode
+(int)IncludeAll { return 0;}
+(int)ExcludeOnDemand { return 1;}
+(int)TagList { return 2;}
@end

@implementation STConstantsExecutionStepType
+(int)CodeBlock { return 0;}
+(int)Tag { return 1;}
@end

@implementation STConstantsDateFormats
+(NSString*)MMDDYYYY { return @"MM/dd/yyyy";}
+(NSString*)MonthDDYYYY { return @"MMMM dd, yyyy";}
@end

@implementation STConstantsTimeFormats
+(NSString*)HHMM { return @"HH:mm";}
+(NSString*)HHMMSS { return @"HH:mm:ss";}
@end

@implementation STConstantsDimensionIndex
+(int)Rows { return 0;}
+(int)Columns { return 1;}
@end

@implementation STConstantsCodeFileActionTask
+(int)NoAction { return 0;}
+(int)ChangeFile { return 1;}
+(int)RemoveTags { return 2;}
+(int)ReAddFile { return 3;}
+(int)SelectFile { return 4;}
@end

