//
//  STRMarkdownAutomation.h
//  StatTag
//
//  Created by Luke Rasmussen on 12/18/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#ifndef STRMarkdownAutomation_h
#define STRMarkdownAutomation_h

#import "STRCommands.h"
#import "STIStatAutomation.h"
#import "STLogManager.h"

@class STRMarkdownParser;

@interface STRMarkdownAutomation : STRAutomation {
}

-(BOOL)Initialize:(STCodeFile*)codeFile withLogManager:(STLogManager*)logManager;
-(BOOL)knitRInstalled;

@end


#endif /* STRMarkdownAutomation_h */
