//
//  STRCommands.m
//  StatTag
//
//  Created by Eric Whitley on 12/19/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STRCommands.h"
#import "STRParser.h"

@implementation STRCommands

-(NSObject<STIResultCommandList>*)ValueResultCommands {
  return [[STRCommandsValueCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)FigureResultCommands {
  return [[STRCommandsFigureCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)TableResultCommands {
  return [[STRCommandsTableCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)VerbatimResultCommands {
    return [[STRCommandsVerbatimCommands alloc] init];
}

@end


//MARK: "nested" classes for R Commands

@implementation STRCommandsValueCommands
-(NSArray<NSString*>*)GetCommands {
    return [NSArray<NSString*> arrayWithObject: @"(Any command that returns a value)"];
}
@end

@implementation STRCommandsFigureCommands
-(NSArray<NSString*>*)GetCommands {
  return [STRParser FigureCommands];
}
@end

@implementation STRCommandsTableCommands
-(NSArray<NSString*>*)GetCommands {
  return [NSArray<NSString*> arrayWithObject: @"(Any command that returns a data frame, matrix, vector or list)"];
}
@end

@implementation STRCommandsVerbatimCommands
-(NSArray<NSString*>*)GetCommands {
    return [NSArray<NSString*> arrayWithObject:@"(Any command)"];
}
@end
