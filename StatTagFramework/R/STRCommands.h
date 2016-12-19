//
//  STRCommands.h
//  StatTag
//
//  Created by Eric Whitley on 12/19/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIResultCommandFormatter.h"
#import "STIResultCommandList.h"


@interface STRCommands  : NSObject<STIResultCommandFormatter>
-(NSObject<STIResultCommandList>*)ValueResultCommands;
-(NSObject<STIResultCommandList>*)FigureResultCommands;
-(NSObject<STIResultCommandList>*)TableResultCommands;

@end


@interface STRCommandsValueCommands : NSObject<STIResultCommandList>
//-(NSString*)Display;
-(NSArray<NSString*>*)GetCommands;
@end

@interface STRCommandsFigureCommands : NSObject<STIResultCommandList>
//-(NSString*)GraphExport;
-(NSArray<NSString*>*)GetCommands;
@end

@interface STRCommandsTableCommands : NSObject<STIResultCommandList>
//-(NSString*)MatrixList;
-(NSArray<NSString*>*)GetCommands;
@end

