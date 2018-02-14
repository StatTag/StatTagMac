//
//  STIStatAutomation.h
//  StatTag
//
//  Created by Eric Whitley on 12/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STCommandResult.h"
#import "STTag.h"

@protocol STIStatAutomation <NSObject>

-(BOOL)Initialize:(STCodeFile*)codeFile;
-(NSArray<STCommandResult*>*)RunCommands:(NSArray<NSString*>*)commands;
-(NSArray<STCommandResult*>*)RunCommands:(NSArray<NSString*>*)commands tag:(STTag*)tag;
-(BOOL)IsReturnable:(NSString*)command;
-(NSString*)GetInitializationErrorMessage;

@end
