//
//  STIParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "STTag.h"
@class STTag;
@class STCodeFile;
@class STExecutionStep;

@protocol STIParser <NSObject>

/*
 Tag[] Parse(CodeFile file, int filterMode = Constants.ParserFilterMode.IncludeAll, List<Tag> tagsToRun = null);
 List<ExecutionStep> GetExecutionSteps(CodeFile file, int filterMode = Constants.ParserFilterMode.IncludeAll, List<Tag> tagsToRun = null);


 */

-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(int)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(int)filterMode;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file;

-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file filterMode:(int)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file filterMode:(int)filterMode;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file;

-(BOOL)IsImageExport:(NSString*)command;
-(NSString*)GetImageSaveLocation:(NSString*)command;
-(BOOL)IsValueDisplay:(NSString*)command;
-(NSString*)GetValueName:(NSString*)command;
-(BOOL)IsTableResult:(NSString*)command;
-(NSString*)GetTableName:(NSString*)command;


@end
