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
  return [[NSArray alloc] initWithObjects:[STConstantsStatisticalPackages Stata], [STConstantsStatisticalPackages SAS], [STConstantsStatisticalPackages R],  nil];
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
+(NSString*)Verbatim { return @"Verbatim";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsTagType Value], [STConstantsTagType Figure], [STConstantsTagType Table], [STConstantsTagType Verbatim], nil];
}
@end

@implementation STConstantsValueFormatType
+(NSString*)Default { return @"Default";}
+(NSString*)Numeric { return @"Numeric";}
+(NSString*)DateTime { return @"DateTime";}
+(NSString*)Percentage { return @"Percentage";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsValueFormatType Default], [STConstantsValueFormatType Numeric], [STConstantsValueFormatType DateTime], [STConstantsValueFormatType Percentage], nil];
}
@end

@implementation STConstantsDialogLabels
+(NSString*)Elipsis { return @"...";}
+(NSString*)Details { return @"Detail";}
+(NSString*)Edit { return @"Edit";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsDialogLabels Elipsis], [STConstantsDialogLabels Details], [STConstantsDialogLabels Edit], nil];
}
@end

@implementation STConstantsFileFilters
+(NSString*)StataLabel { return @"Stata Do Files";}
+(NSString*)StataFilter { return @"*do;*.ado";}//"*.do;*.ado"
+(NSString*)SASLabel { return @"SAS";}
+(NSString*)SASFilter { return @"*.sas";} //"*.sas"
+(NSString*)RLabel { return @"R";}
+(NSString*)RFilter { return @"*.r";} //"*.r"
+(NSString*)AllLabel { return @"All files";}
+(NSString*)AllFilter { return @"*.*";}//never use this
+(NSString*)SupportedLabel { return @"Supported files";}
+(NSArray<NSString*>*)SupportedFileFiltersArray
{
  //FIXME: don't do this... this is a shim to avoid changing the Windows pathing
  NSString* allFilters = [NSString stringWithFormat:@"%@;%@;%@", [[self class] StataFilter], [[self class] SASFilter], [[self class] RFilter]];
  NSCharacterSet *removeChars = [NSCharacterSet characterSetWithCharactersInString:@"*."];
  allFilters = [[allFilters componentsSeparatedByCharactersInSet: removeChars] componentsJoinedByString: @""];
  return [allFilters componentsSeparatedByString:@";"];
}
+(NSString*)SupportedFileFilters {
  return [[NSArray<NSString*> arrayWithObjects:[[self class] StataFilter], [[self class] SASFilter], [[self class] RFilter], nil] componentsJoinedByString:@";" ];
}
+(NSString*)FormatForOpenFileDialog {
  return [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",

          [STConstantsFileFilters SupportedLabel],
          [[NSArray<NSString*> arrayWithObjects:[[self class] StataFilter], [[self class] SASFilter], [[self class] RFilter], nil] componentsJoinedByString:@";" ],
          
          [STConstantsFileFilters StataLabel],
          [STConstantsFileFilters StataFilter],
          [STConstantsFileFilters SASLabel],
          [STConstantsFileFilters SASFilter],
          [STConstantsFileFilters RLabel],
          [STConstantsFileFilters RFilter],
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
+(NSString*)ListDelimiter {return @",";};
+(NSString*)RangeDelimiter {return @"-";};
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
//+(NSString*)ColumnNames { return @"ColumnNames";}
//+(NSString*)RowNames { return @"RowNames";}
+(NSString*) FilterEnabled { return @"FilterEnabled";}
+(NSString*) FilterType { return @"FilterType"; }
+(NSString*) FilterValue { return @"FilterValue";}
@end

@implementation STConstantsTableParameterDefaults
//+(BOOL)ColumnNames { return FALSE;}
//+(BOOL)RowNames { return FALSE;}
+(BOOL) FilterEnabled { return false;}
+(NSString*) FilterType { return @""; }
+(NSString*) FilterValue { return @"";}
@end

@implementation STConstantsValueParameterDefaults
+(BOOL)AllowInvalidTypes { return FALSE;}
@end

@implementation STConstantsCodeFileComment
+(NSString*)Stata { return @"*";}
+(NSString*)SAS { return @"*";}
+(NSString*)R { return @"#";}
@end

@implementation STConstantsCodeFileCommentSuffix
+(NSString*)Default { return @"";}
+(NSString*)SAS { return @";";}
@end


@implementation STConstantsTagTags
+(NSString*)StartTag { return @">>>";}
+(NSString*)EndTag { return @"<<<";}
+(NSString*)TagPrefix { return @"ST:";}
+(NSString*)ParamStart { return @"(";}
+(NSString*)ParamEnd { return @")";}
@end

@implementation STConstantsParserFilterMode
+(NSInteger)IncludeAll { return 0;}
+(NSInteger)ExcludeOnDemand { return 1;}
+(NSInteger)TagList { return 2;}
@end

@implementation STConstantsExecutionStepType
+(NSInteger)CodeBlock { return 0;}
+(NSInteger)Tag { return 1;}
@end

@implementation STConstantsDateFormats
+(NSString*)MMDDYYYY { return @"MM/dd/yyyy";}
+(NSString*)MonthDDYYYY { return @"MMMM dd, yyyy";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsDateFormats MMDDYYYY], [STConstantsDateFormats MonthDDYYYY], nil];
}
@end

@implementation STConstantsTimeFormats
+(NSString*)HHMM { return @"HH:mm";}
+(NSString*)HHMMSS { return @"HH:mm:ss";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsTimeFormats HHMM], [STConstantsTimeFormats HHMMSS], nil];
}
@end

@implementation STConstantsDimensionIndex
+(NSInteger)Rows { return 0;}
+(NSInteger)Columns { return 1;}
@end

@implementation STConstantsCodeFileActionTask
+(NSInteger)NoAction { return 0;}
+(NSInteger)ChangeFile { return 1;}
+(NSInteger)RemoveTags { return 2;}
+(NSInteger)ReAddFile { return 3;}
+(NSInteger)SelectFile { return 4;}
@end

@implementation STConstantsFilterPrefix
+(NSString*)Row { return @"Row";}
+(NSString*)Column { return @"Col";}
@end

@implementation STConstantsFilterType
+(NSString*)Exclude { return @"Exclude";}
+(NSString*)Include { return @"Include";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsFilterType Exclude], [STConstantsFilterType Include], nil];
}
@end

@implementation STConstantsMissingValueOption
+(NSString*)StatPackageDefault { return @"StatPackageDefault";}
+(NSString*)CustomValue { return @"CustomValue";}
+(NSString*)BlankString { return @"BlankString";}
+(NSArray<NSString *>*)GetList {
  return [[NSArray alloc] initWithObjects:[STConstantsMissingValueOption StatPackageDefault], [STConstantsMissingValueOption CustomValue], [STConstantsMissingValueOption BlankString], nil];
}
@end
