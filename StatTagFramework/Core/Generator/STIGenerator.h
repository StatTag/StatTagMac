//
//  STIGenerator.h
//  StatTag
//
//  Created by Eric Whitley on 6/17/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STTag;

@protocol STIGenerator <NSObject>

-(NSString*)CommentCharacter;
-(NSString*)CreateOpenTagBase;
-(NSString*)CreateClosingTag;
-(NSString*)CreateOpenTag:(STTag*) tag;


@end
