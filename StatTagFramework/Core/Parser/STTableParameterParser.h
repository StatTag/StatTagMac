//
//  STFigureParameterParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBaseParameterParser.h"

@class STTag;

@interface STTableParameterParser : STBaseParameterParser

+(void) Parse:(NSString*)tagText tag:(STTag*)tag;

@end
