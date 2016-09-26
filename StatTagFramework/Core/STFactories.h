//
//  STFactories.h
//  StatTag
//
//  Created by Eric Whitley on 6/17/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STCodeFile;
@protocol STIParser;
@protocol STIGenerator;
@protocol STIValueFormatter;


@interface STFactories : NSObject

+(NSObject<STIParser>*)GetParser:(STCodeFile*)file;
+(NSObject<STIGenerator>*)GetGenerator:(STCodeFile*)file;
+(NSObject<STIValueFormatter>*)GetValueFormatter:(STCodeFile*)file;


@end
