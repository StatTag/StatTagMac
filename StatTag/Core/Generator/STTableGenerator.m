//
//  STTableGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTableGenerator.h"
#import "STConstants.h"
#import "STTag.h"
#import "STTableFormat.h"

@implementation STTableGenerator


-(NSString*)CreateParameters:(STTag*)tag
{
  // Putting in StringBuilder, assuming more params will be added
  NSMutableString* builder = [[NSMutableString alloc] init];
  [builder appendString:[self GetLabelParameter:tag]];
  [builder appendString:[self GetRunFrequencyParameter:tag]];
  [builder appendString:[self CreateTableParameters:tag]];
  return [self CleanResult:builder];
}

//FIXME: is this going to emit "YES" or "true" or "1"?
-(NSString*)CreateTableParameters:(STTag*) tag
{
  NSMutableString* builder = [[NSMutableString alloc] init];
  if([tag TableFormat] != nil) {
    
    [builder appendString:[NSString stringWithFormat:@"%@=%hhd, %@=%hhd",
                           [STConstantsTableParameters ColumnNames],
                           [[tag TableFormat] IncludeColumnNames],
                           [STConstantsTableParameters RowNames],
                           [[tag TableFormat] IncludeRowNames]
                           ]];
  }
    return [self CleanResult:builder];
}


@end
