//
//  STStataCommands.h
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIResultCommandFormatter.h"
#import "STIResultCommandList.h"

@interface STStataCommands : NSObject<STIResultCommandFormatter>
-(NSObject<STIResultCommandList>*)ValueResultCommands;
-(NSObject<STIResultCommandList>*)FigureResultCommands;
-(NSObject<STIResultCommandList>*)TableResultCommands;
-(NSObject<STIResultCommandList>*)VerbatimResultCommands;

@end


@interface STStataCommandsValueCommands : NSObject<STIResultCommandList>
//-(NSString*)Display;
-(NSArray<NSString*>*)GetCommands;
@end

@interface STStataCommandsFigureCommands : NSObject<STIResultCommandList>
//-(NSString*)GraphExport;
-(NSArray<NSString*>*)GetCommands;
@end


@interface STStataCommandsTableCommands : NSObject<STIResultCommandList>
//-(NSString*)MatrixList;
-(NSArray<NSString*>*)GetCommands;
@end

@interface STStataVerbatimCommands : NSObject<STIResultCommandList>
-(NSArray<NSString*>*)GetCommands;
@end
