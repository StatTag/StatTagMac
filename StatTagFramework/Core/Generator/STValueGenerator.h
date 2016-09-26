//
//  STTableGenerator.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBaseParameterGenerator.h"

@class STTag;
@class STValueFormat;

@interface STValueGenerator : STBaseParameterGenerator

-(NSString*)CreateParameters:(STTag*)tag;
-(NSString*)CreateValueParameters:(STTag*)tag;


-(NSString*)CreatePercentageParameters:(STValueFormat*) format;
-(NSString*)CreateDateTimeParameters:(STValueFormat*) format;
-(NSString*)CreateNumericParameters:(STValueFormat*) format;

/**
 Establishes the default
 */
-(NSString*)CreateDefaultParameters:(NSString*)type invalidTypes:(BOOL)invalidTypes;
-(NSString*)CreateDefaultParameters:(NSString*)type;
-(NSString*)CreateDefaultParameters;


@end
