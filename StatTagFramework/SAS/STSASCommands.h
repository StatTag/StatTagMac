//
//  STSASCommands.h
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIResultCommandFormatter.h"
#import "STIResultCommandList.h"

@interface STSASCommands : NSObject<STIResultCommandFormatter>
-(NSObject<STIResultCommandList>*)ValueResultCommands;
-(NSObject<STIResultCommandList>*)FigureResultCommands;
-(NSObject<STIResultCommandList>*)TableResultCommands;
-(NSObject<STIResultCommandList>*)VerbatimResultCommands;

@end


@interface STSASCommandsValueCommands : NSObject<STIResultCommandList>
-(NSArray<NSString*>*)GetCommands;
@end

@interface STSASCommandsFigureCommands : NSObject<STIResultCommandList>
-(NSArray<NSString*>*)GetCommands;
@end


@interface STSASCommandsTableCommands : NSObject<STIResultCommandList>
-(NSArray<NSString*>*)GetCommands;
@end

@interface STSASCommandsVerbatimCommands : NSObject<STIResultCommandList>
-(NSArray<NSString*>*)GetCommands;
@end
