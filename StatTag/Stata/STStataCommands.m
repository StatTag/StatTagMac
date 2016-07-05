//
//  STStataCommands.m
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STStataCommands.h"

@implementation STStataCommands
-(NSObject<STIResultCommandList>*)ValueResultCommands {
  return [[STStataCommandsValueCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)FigureResultCommands {
  return [[STStataCommandsFigureCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)TableResultCommands {
  return [[STStataCommandsTableCommands alloc] init];
}
@end

//MARK: "nested" classes for Stata Commands

@implementation STStataCommandsValueCommands
NSString *const Display =  @"display";
-(NSArray<NSString*>*)GetCommands {
  return [NSArray arrayWithObjects:
          Display
          , nil];
}
@end

@implementation STStataCommandsFigureCommands
NSString *const GraphExport = @"graph export";
-(NSArray<NSString*>*)GetCommands {
  return [NSArray arrayWithObjects:
          GraphExport
          , nil];
}
@end


@implementation STStataCommandsTableCommands
NSString *const MatrixList = @"matrix list";
-(NSArray<NSString*>*)GetCommands {
  return [NSArray arrayWithObjects:
          MatrixList
          , nil];
}
@end
