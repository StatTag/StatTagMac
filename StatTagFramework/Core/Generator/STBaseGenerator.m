//
//  STBaseGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseGenerator.h"
#import "STConstants.h"
#import "STTag.h"
#import "STValueParameterGenerator.h"
#import "STTableParameterGenerator.h"
#import "STFigureGenerator.h"
#import "STVerbatimGenerator.h"


@implementation STBaseGenerator

-(NSString*)CommentCharacter {
  return nil;
}

-(NSString*)CommentSuffixCharacter {
  return [STConstantsCodeFileCommentSuffix Default];
}

-(NSString*)CreateOpenTagBase {
  return [NSString stringWithFormat:@"%@%@%@%@", [self CommentCharacter], [self CommentCharacter], [STConstantsTagTags StartTag], [STConstantsTagTags TagPrefix]];
}

-(NSString*)CreateClosingTag {
  return [NSString stringWithFormat:@"%@%@%@%@", [self CommentCharacter], [self CommentCharacter], [STConstantsTagTags EndTag], [self CommentSuffixCharacter]];
}

-(NSString*)CreateOpenTag:(STTag*) tag {
 
  NSMutableString* openBase = [NSMutableString stringWithString:[self CreateOpenTagBase]];
  if (tag != nil) //this can't ever be nil the way we do things
  {
    if ([[tag Type] isEqualToString:[STConstantsTagType Value]])
    {
      STValueParameterGenerator* valueGenerator = [[STValueParameterGenerator alloc] init];
      [openBase appendFormat:@"%@%@%@%@",
          [STConstantsTagType Value],
          [STConstantsTagTags ParamStart],
          [valueGenerator CreateParameters:tag],
          [STConstantsTagTags ParamEnd]
       ];
    }
    else if ([[tag Type] isEqualToString:[STConstantsTagType Figure]])
    {
      STFigureGenerator* figureGenerator = [[STFigureGenerator alloc] init];
      [openBase appendFormat:@"%@%@%@%@",
       [STConstantsTagType Figure],
       [STConstantsTagTags ParamStart],
       [figureGenerator CreateParameters:tag],
       [STConstantsTagTags ParamEnd]
       ];
    }
    else if ([tag IsTableTag])
    {
      STTableParameterGenerator* tableGenerator = [[STTableParameterGenerator alloc] init];
      #pragma unused(tableGenerator) //just following the c#

      [openBase appendFormat:@"%@%@%@%@",
       [STConstantsTagType Table],
       [STConstantsTagTags ParamStart],
       //[tableGenerator CreateParameters:tag],
       [self CombineValueAndTableParameters:tag],
       [STConstantsTagTags ParamEnd]
       ];
    }
    
    else if ([[tag Type] isEqualToString:[STConstantsTagType Verbatim]])
    {
      STVerbatimGenerator* verbatimGenerator = [[STVerbatimGenerator alloc] init];
      [openBase appendFormat:@"%@%@%@%@",
       [STConstantsTagType Verbatim],
       [STConstantsTagTags ParamStart],
       [verbatimGenerator CreateParameters:tag],
       [STConstantsTagTags ParamEnd]
       ];
    }
    else
    {
      //FIXME: we shouldn't be doing things this way - fix
      [NSException raise:@"Unsupported tag type" format:@"Unsupported tag type"];
    }
  }

  [openBase appendString:[self CommentSuffixCharacter]];
  
  return openBase;
  
  
}

-(NSString*)CombineValueAndTableParameters:(STTag*)tag {
  STTableParameterGenerator* tableGenerator = [[STTableParameterGenerator alloc]init];
  STValueParameterGenerator* valueGenerator = [[STValueParameterGenerator alloc]init];
  NSString *tableParameters = [tableGenerator CreateParameters:tag];
  NSString *valueParameters = [valueGenerator CreateParameters:tag];

  NSString *temp = [[[NSArray alloc] initWithObjects:tableParameters, valueParameters, nil] componentsJoinedByString:@", "];

  //remove any additional prefix/suffix commas (or whatever) (trim) - NOT wholesale replace
  NSCharacterSet *otherChars = [NSCharacterSet characterSetWithCharactersInString:@","];
  temp = [temp stringByTrimmingCharactersInSet:otherChars];

  //remove the normal whitespace characters (trim)
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  temp = [temp stringByTrimmingCharactersInSet: ws];
  

  return temp;
}

@end
