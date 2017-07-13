//
//  STRAutomation.h
//  StatTag
//
//  Created by Eric Whitley on 12/19/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STRCommands.h"
#import "STIStatAutomation.h"

@class STRParser;
@class RCEngine;
@class STRVerbatimDevice;

@interface STRAutomation : NSObject <STIStatAutomation> {
  STRParser* Parser;
  NSMutableArray<NSString*>* OpenLogs;
  RCEngine* Engine;
  STRVerbatimDevice* VerbatimLog;
}

-(BOOL)Initialize:(STCodeFile*)codeFile;
-(NSString*)GetInitializationErrorMessage;

@end
