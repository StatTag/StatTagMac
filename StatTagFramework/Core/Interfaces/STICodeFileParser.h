//
//  STICodeFileParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIStatAutomation.h"
//#import "STTag.h"
@class STTag;
@class STCodeFile;
@class STExecutionStep;

@protocol STICodeFileParser <NSObject>


-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(NSInteger)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(NSInteger)filterMode;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file;

-(NSArray<STTag*>*)ParseIncludingInvalidTags:(STCodeFile*)file;

-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file automation:(NSObject<STIStatAutomation>*)automation filterMode:(NSInteger)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file automation:(NSObject<STIStatAutomation>*)automation filterMode:(NSInteger)filterMode;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file automation:(NSObject<STIStatAutomation>*)automation;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file;

-(NSArray<NSString*>*) PreProcessExecutionStepCode:(STExecutionStep*) step;

-(BOOL)IsImageExport:(NSString*)command;
-(NSString*)GetImageSaveLocation:(NSString*)command;
-(BOOL)IsValueDisplay:(NSString*)command;
-(NSString*)GetValueName:(NSString*)command;
-(BOOL)IsTableResult:(NSString*)command;
-(NSString*)GetTableName:(NSString*)command;


@end
