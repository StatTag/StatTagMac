//
//  STIGenerator.h
//  StatTag
//
//  Created by Eric Whitley on 6/17/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STITag;

@protocol STIGenerator <NSObject>

-(NSString*)CommentCharacter;
-(NSString*)CreateOpenTagBase;
-(NSString*)CreateClosingTag;
-(NSString*)CreateOpenTag:(STITag*) tag;


@end
