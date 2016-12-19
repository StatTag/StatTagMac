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

@interface STRAutomation : NSObject <STIStatAutomation> {
  STRParser* Parser;
  NSMutableArray<NSString*>* OpenLogs;
}

//Need to add external reference to REngine
// none of real internal R interface methods are complete

-(NSString*)GetInitializationErrorMessage;

@end
