//
//  STBaseParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIParser.h"
#import "STConstants.h"
#import "STCodeFile.h"

@interface STBaseParser : NSObject <STIParser> {
  NSRegularExpression* _StartTagRegEx;
  NSRegularExpression* _EndTagRegEx;
}


//MARK: protocol implementation

-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(int)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(int)filterMode;
-(NSArray<STTag*>*)Parse:(STCodeFile*)file;

-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file filterMode:(int)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file filterMode:(int)filterMode;
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file;


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

-(NSString*)CommentCharacter;

/**
 @brief Perform any necessary pre-processing on the original code file content in order
        to allow it to be executed.  This may change the number of lines, so don't assume
        that the output will have a 1:1 line mapping from the original.
 @param originalContent: The contents as read from the code file
 @returns A list of strings representing the code that should be executed
 */
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*) originalContent;


@end
