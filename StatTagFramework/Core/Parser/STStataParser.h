//
//  STStataParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBaseParser.h"
#import "STExecutionStep.h"

@interface STStataCommentBlock : NSObject {
  long _Start;
  long _End;
  BOOL _IsNested;
}
@property long Start;
@property long End;
@property BOOL IsNested;
@end

@interface STStataParserLog : NSObject {
}
  @property (strong, nonatomic) NSString* LogType;
  @property (strong, nonatomic) NSString* LogPath;
  @property (strong, nonatomic) NSString* LiteralLogEntry;

@end


@interface STStataParser : STBaseParser {
  
}

//+(BOOL)regexIsMatch:(NSRegularExpression*)regex inString:(NSString*)string;

+(NSCharacterSet*)MacroDelimiters;
+(NSCharacterSet*)CalculationOperators;

+(NSArray<NSString*>*)MacroDelimitersCharacters;
+(NSArray<NSString*>*)CalculationOperatorsCharacters;


//MARK: Value regex
+(NSArray<NSString*>*)ValueCommands;
//MARK: Graph regex
+(NSArray<NSString*>*)GraphCommands;
//MARK: Table regex
+(NSArray<NSString*>*)TableCommands;

+(NSRegularExpression*)MacroRegex;

-(BOOL) IsMacroDisplayValue:(NSString*)command;
-(BOOL) IsStartingLog:(NSString*)command;
-(NSArray<NSString*>*) GetLogType:(NSString*)command;
-(NSArray<NSString*>*) GetLogFile:(NSString*)command;
-(NSArray<STStataParserLog*>*)GetLogs:(NSString*)command;

-(BOOL) IsCalculatedDisplayValue:(NSString*)command;
-(NSArray<NSString*>*)GetMacros:(NSString*)command;
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*)originalContent;
-(NSArray<NSString*>*) PreProcessExecutionStepCode:(STExecutionStep*) step;
-(NSString*) GetMacroValueName:(NSString*)command;
-(BOOL) IsSavedResultCommand:(NSString*)command;
-(BOOL) IsMatrix:(NSString*)command;
-(BOOL) IsTable1Command:(NSString*)command;
-(NSString*)GetTableDataPath:(NSString*)command;
-(BOOL) IsCapturableBlock:(NSString*) command;


@end
