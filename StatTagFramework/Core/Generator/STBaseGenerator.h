//
//  STBaseGenerator.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIGenerator.h"

@class STTag;

@interface STBaseGenerator : NSObject<STIGenerator> {
}

/** 
 The comment character that is used for single line comments
 */
-(NSString*)CommentCharacter;
/**
 The suffix expected at the end of a comment (default is none)
 */
-(NSString*)CommentSuffixCharacter;
-(NSString*)CreateOpenTagBase;
-(NSString*)CreateClosingTag;

-(NSString*)CreateOpenTag:(STTag*) tag;
-(NSString*)CombineValueAndTableParameters:(STTag*)tag;

@end
