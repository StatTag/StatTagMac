//
//  STFactories.h
//  StatTag
//
//  Created by Eric Whitley on 6/17/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STCodeFile;
@protocol STICodeFileParser;
@protocol STIGenerator;
@protocol STIValueFormatter;


@interface STFactories : NSObject

+(id<STICodeFileParser>)GetParser:(STCodeFile*)file;
+(id<STIGenerator>)GetGenerator:(STCodeFile*)file;
+(id<STIValueFormatter>)GetValueFormatter:(STCodeFile*)file;


@end
