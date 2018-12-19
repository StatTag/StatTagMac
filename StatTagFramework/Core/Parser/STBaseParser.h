//
//  STBaseParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STICodeFileParser.h"
#import "STConstants.h"
#import "STCodeFile.h"

@interface STBaseParser : NSObject <STICodeFileParser> {
  NSRegularExpression* _StartTagRegEx;
  NSRegularExpression* _EndTagRegEx;
  NSRegularExpression* _MacFileProtocolRegEx;
}


//MARK: protocol implementation

-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(NSInteger)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(NSInteger)filterMode;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file;

-(NSArray<STTag*>*)ParseIncludingInvalidTags:(STCodeFile*)file;

-(bool)IsTagStart:(NSString*)line;
-(bool)IsTagEnd:(NSString*)line;

-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file automation:(NSObject<STIStatAutomation>*)automation filterMode:(NSInteger)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file automation:(NSObject<STIStatAutomation>*)automation filterMode:(NSInteger)filterMode;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file automation:(NSObject<STIStatAutomation>*)automation;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file;

+(NSString*)FormatCommandListAsNonCapturingGroup:(NSArray<NSString*>*)commands;

//These are empty because this was an abstract class in the original code
-(BOOL)IsImageExport:(NSString*)command;
-(NSString*)GetImageSaveLocation:(NSString*)command;
-(BOOL)IsValueDisplay:(NSString*)command;
-(NSString*)GetValueName:(NSString*)command;
-(BOOL)IsTableResult:(NSString*)command;
-(NSString*)GetTableName:(NSString*)command;

//MARK: other methods and properties
@property (copy, nonatomic) NSRegularExpression* StartTagRegEx;
@property (copy, nonatomic) NSRegularExpression* EndTagRegEx;
@property (copy, nonatomic) NSRegularExpression* MacFileProtocolRegEx;

-(NSString*)CommentCharacter;

/**
 @brief Perform any necessary pre-processing on the original code file content in order
        to allow it to be executed.  This may change the number of lines, so don't assume
        that the output will have a 1:1 line mapping from the original.
 @param originalContent The contents as read from the code file
 @returns A list of strings representing the code that should be executed
 */
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*) originalContent automation:(NSObject<STIStatAutomation>*)automation;

-(NSArray<NSString*>*) PreProcessExecutionStepCode:(STExecutionStep*) step;

-(NSArray<NSString*>*)PreProcessFile:(STCodeFile*) file automation:(NSObject<STIStatAutomation>*)automation;

//MARK: private methods
//had to make these public so we could use them in subclasses - these should probably be moved to a class extension
-(NSTextCheckingResult*)DetectTag:(NSRegularExpression*)tagRegex line:(NSString*)line;

-(NSString*)MatchRegexReturnGroup:(NSString*)text regex:(NSRegularExpression*)regex groupNum:(NSInteger)groupNum;
-(NSArray<NSString*>*)GlobalMatchRegexReturnGroup:(NSString*)text regex:(NSRegularExpression*)regex groupNum:(NSInteger)groupNum;

//FIXME: move this somewhere else
+(BOOL)regexIsMatch:(NSRegularExpression*)regex inString:(NSString*)string;

-(BOOL)IsRelativePath:(NSString*)filePath;

@end
