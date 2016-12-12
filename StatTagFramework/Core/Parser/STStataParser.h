//
//  STStataParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBaseParser.h"

@interface STStataParser : STBaseParser {
  
}

+(BOOL)regexIsMatch:(NSRegularExpression*)regex inString:(NSString*)string;

+(NSCharacterSet*)MacroDelimiters;

//MARK: Value regex
+(NSArray<NSString*>*)ValueCommands;
//MARK: Graph regex
+(NSString*)GraphCommand;
//MARK: Table regex
+(NSString*)TableCommand;

+(NSRegularExpression*)MacroRegex;

-(BOOL) IsMacroDisplayValue:(NSString*)command;
-(BOOL) IsStartingLog:(NSString*)command;
-(NSArray<NSString*>*) GetLogType:(NSString*)command;
-(BOOL) IsCalculatedDisplayValue:(NSString*)command;
-(NSArray<NSString*>*)GetMacros:(NSString*)command;
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*)originalContent;
-(NSString*) GetMacroValueName:(NSString*)command;


@end
