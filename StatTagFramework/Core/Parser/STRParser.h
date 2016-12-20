//
//  STStataParser.h
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBaseParser.h"

@interface STRParserFunctionParam : NSObject {
  NSInteger _Index;
  NSString* _Key;
  NSString* _Value;
}
  @property NSInteger Index;
  @property (copy, nonatomic) NSString* Key;
  @property (copy, nonatomic) NSString* Value;
@end

@interface STRParser : STBaseParser {
  
}


//MARK: Figure regex
+(NSArray<NSString*>*)FigureCommands;
+(NSRegularExpression*)FigureRegex;
+(NSRegularExpression*)FigureParameterRegex;


//-(BOOL) IsStartingLog:(NSString*)command;
-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*)originalContent;


@end