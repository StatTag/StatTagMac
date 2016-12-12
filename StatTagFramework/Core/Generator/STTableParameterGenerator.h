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

@interface STTableParameterGenerator : STBaseParameterGenerator

-(NSString*)CreateParameters:(STTag*)tag;
-(NSString*)CreateTableParameters:(STTag*)tag;

@end
