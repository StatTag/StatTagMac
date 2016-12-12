//
//  STTableGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTableParameterGenerator.h"
#import "STConstants.h"
#import "STTag.h"
#import "STTableFormat.h"
#import "STFilterFormat.h"

@implementation STTableParameterGenerator


-(NSString*)CreateParameters:(STTag*)tag
{
  // Putting in StringBuilder, assuming more params will be added
  NSMutableString* builder = [[NSMutableString alloc] init];
  [builder appendString:[self GetLabelParameter:tag]];
  [builder appendString:[self GetRunFrequencyParameter:tag]];
  [builder appendString:[self CreateTableParameters:tag]];
  return [self CleanResult:builder];
}

-(void)AppendFilter:(STFilterFormat*)filter builder:(NSMutableString*)builder
{
  if (filter != nil && [filter Enabled])
  {
    if(builder != nil && [builder length] > 0)
    {
      [builder appendFormat:@", "];
      //builder.AppendFormat(", ");
    }
    
    //    builder.AppendFormat("{0}{1}={2}, {0}{3}=\"{4}\", {0}{5}=\"{6}\"",
    [builder appendFormat:@"%@%@=%@, %@%@=\"%@\", %@%@=\"%@\"",
        [filter Prefix],
        [STConstantsTableParameters FilterEnabled],
        [filter Enabled] ? @"True" : @"False",

        [filter Prefix],
        [STConstantsTableParameters FilterType],
        [filter Type],
     
        [filter Prefix],
        [STConstantsTableParameters FilterValue],
        [filter Value]
     ];
  }
}


//FIXME: is this going to emit "YES" or "true" or "1"?
-(NSString*)CreateTableParameters:(STTag*) tag
{
  NSMutableString* builder = [[NSMutableString alloc] init];
  if([tag TableFormat] != nil && ([[[tag TableFormat] ColumnFilter] Enabled] || [[[tag TableFormat] RowFilter] Enabled] )) {
    [self AppendFilter:[[tag TableFormat] ColumnFilter] builder:builder];
    [self AppendFilter:[[tag TableFormat] RowFilter] builder:builder];
  }
    return [self CleanResult:builder];
}


@end
