//
//  STSASBaseGenerator.m
//  StatTag
//
//  Created by Eric Whitley on 12/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STSASBaseGenerator.h"
#import "STConstants.h"

@implementation STSASBaseGenerator

-(NSString*)CommentCharacter {
  return [STConstantsCodeFileComment SAS];
}

-(NSString*)CommentSuffixCharacter {
  return [STConstantsCodeFileCommentSuffix SAS];
}

@end
