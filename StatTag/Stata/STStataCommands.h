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

@end


@interface STStataCommandsValueCommands : NSObject<STIResultCommandList>
extern NSString *const Display;
-(NSArray<NSString*>*)GetCommands;
@end

@interface STStataCommandsFigureCommands : NSObject<STIResultCommandList>
extern NSString *const GraphExport;
-(NSArray<NSString*>*)GetCommands;
@end


@interface STStataCommandsTableCommands : NSObject<STIResultCommandList>
extern NSString *const MatrixList;
-(NSArray<NSString*>*)GetCommands;
@end

