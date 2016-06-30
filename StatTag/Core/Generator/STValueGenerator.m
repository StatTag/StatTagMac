//
//  STTableGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STValueGenerator.h"
#import "STConstants.h"
#import "STTag.h"
#import "STValueFormat.h"

@implementation STValueGenerator


-(NSString*)CreateParameters:(STTag*)tag
{
  // Putting in StringBuilder, assuming more params will be added
  NSMutableString* builder = [[NSMutableString alloc] init];
  [builder appendString:[self GetLabelParameter:tag]];
  [builder appendString:[self GetRunFrequencyParameter:tag]];
  [builder appendString:[self CreateValueParameters:tag]];
  return [self CleanResult:builder];
}

//FIXME: is this going to emit "YES" or "true" or "1"?
-(NSString*)CreateValueParameters:(STTag*) tag
{
  NSMutableString* builder = [[NSMutableString alloc] init];

  if ([tag ValueFormat] == nil)
  {
    [builder appendString:[self CreateDefaultParameters]];
  }
  else
  {
    if([[[tag ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType Numeric]]) {
      [builder appendString:[self CreateDefaultParameters:[[tag ValueFormat] FormatType] invalidTypes:[[tag ValueFormat] AllowInvalidTypes]]];
      [builder appendString:[self CreateNumericParameters:[tag ValueFormat]]];
    } else if([[[tag ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType DateTime]]) {
      [builder appendString:[self CreateDefaultParameters:[[tag ValueFormat] FormatType] invalidTypes:[[tag ValueFormat] AllowInvalidTypes]]];
      [builder appendString:[self CreateDateTimeParameters:[tag ValueFormat]]];
    } else if([[[tag ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType Percentage]]) {
      [builder appendString:[self CreateDefaultParameters:[[tag ValueFormat] FormatType] invalidTypes:[[tag ValueFormat] AllowInvalidTypes]]];
      [builder appendString:[self CreatePercentageParameters:[tag ValueFormat]]];
    } else {
      [builder appendString:[self CreateDefaultParameters]];
    }    
  }
  
  return [self CleanResult:builder];
}


-(NSString*)CreatePercentageParameters:(STValueFormat*) format
{
  return [NSString stringWithFormat:@"%@=%d", [STConstantsValueParameters Decimals], [format DecimalPlaces]];
}

-(NSString*)CreateDateTimeParameters:(STValueFormat*) format
{
  NSMutableArray<NSString*>* elements = [[NSMutableArray<NSString*> alloc] init];

  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  if ([[[format DateFormat] stringByTrimmingCharactersInSet: ws] length] > 0) {
    [elements addObject:[NSString stringWithFormat:@"%@=\"%@\"", [STConstantsValueParameters DateFormat], [format DateFormat]]];
  }
  
  if ([[[format TimeFormat] stringByTrimmingCharactersInSet: ws] length] > 0) {
    [elements addObject:[NSString stringWithFormat:@"%@=\"%@\"", [STConstantsValueParameters TimeFormat], [format TimeFormat]]];
  }
  
  return [elements componentsJoinedByString:@", "];
}

-(NSString*)CreateNumericParameters:(STValueFormat*) format
{
  return [NSString stringWithFormat:@"%@=%d, %@=%@",
          [STConstantsValueParameters Decimals], [format DecimalPlaces],
          [STConstantsValueParameters UseThousands], [format UseThousands] ? @"True" : @"False"
          ];
}

/**
 Establishes the default
*/
-(NSString*)CreateDefaultParameters:(NSString*)type invalidTypes:(BOOL)invalidTypes
{
  NSMutableString* builder = [[NSMutableString alloc] initWithFormat:@"%@=\"%@\", ", [STConstantsValueParameters Type], type];
  if(invalidTypes != [STConstantsValueParameterDefaults AllowInvalidTypes]) {
    [builder appendString:[NSString stringWithFormat:@"%@=%@, ", [STConstantsValueParameters AllowInvalidTypes], invalidTypes ? @"True" : @"False"]];
  }
  return builder;
}

-(NSString*)CreateDefaultParameters:(NSString*)type {
  return [self CreateDefaultParameters:type invalidTypes:false];
}
-(NSString*)CreateDefaultParameters {
  return [self CreateDefaultParameters:[STConstantsValueFormatType Default] invalidTypes:false];
}




@end
