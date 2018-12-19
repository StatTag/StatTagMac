//
//  STRMarkdownParser.h
//  StatTag
//
//  Created by Luke Rasmussen on 12/18/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#ifndef STRMarkdownParser_h
#define STRMarkdownParser_h

#import <Foundation/Foundation.h>
#import "STRParser.h"

@interface STRMarkdownParser : STRParser {
  NSObject<STIFileHandler>* _FileHandler;
}

-(NSArray<NSString*>*)PreProcessFile:(STCodeFile*)file automation:(NSObject<STIStatAutomation>*) automation;
-(NSArray<NSString*>*)ReplaceKnitrCommands:(NSArray<NSString*>*)commands;

@property (copy, nonatomic) NSObject<STIFileHandler>* FileHandler;

@end

#endif /* STRMarkdownParser_h */
