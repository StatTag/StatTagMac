//
//  STICodeFileParser.h
//  StatTag
//
//  Created by Eric Whitley on 12/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STCodeFile.h"
#import "STConstants.h"
#import "STTag.h"
#import "STExecutionStep.h"

@protocol STICodeFileParser <NSObject>

//  Tag[] Parse(CodeFile file, int filterMode = Constants.ParserFilterMode.IncludeAll, List<Tag> tagsToRun = null);
-(NSArray<STTag*>*)Parse:(STCodeFile*)file;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(NSInteger)filterMode;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(NSInteger)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;

//  List<ExecutionStep> GetExecutionSteps(CodeFile file, int filterMode = Constants.ParserFilterMode.IncludeAll, List<Tag> tagsToRun = null);
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file filterMode:(NSInteger)filterMode;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file filterMode:(NSInteger)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;


-(BOOL)IsImageExport:(NSString*)command;
-(NSString*)GetImageSaveLocation:(NSString*)command;

-(BOOL)IsValueDisplay:(NSString*)command;
-(NSString*)GetValueName:(NSString*)command;

-(BOOL)IsTableResult:(NSString*)command;
-(NSString*)GetTableName:(NSString*)command;


@end
