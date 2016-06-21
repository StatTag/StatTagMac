//
//  STFigureGenerator.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBaseParameterGenerator.h"
@class STTag;

@interface STFigureGenerator : STBaseParameterGenerator {
  
}

-(NSString*)CreateParameters:(STTag*)tag;

@end
