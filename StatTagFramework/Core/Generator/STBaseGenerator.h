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

-(NSString*)CommentCharacter;
-(NSString*)CreateOpenTagBase;
-(NSString*)CreateClosingTag;

-(NSString*)CreateOpenTag:(STTag*) tag;
-(NSString*)CombineValueAndTableParameters:(STTag*)tag;

@end
