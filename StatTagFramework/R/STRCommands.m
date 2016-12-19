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

@end


//MARK: "nested" classes for R Commands

@implementation STRCommandsValueCommands
//-(NSString*)Display {
//  return @"(Any command that returns a value)";
//}
-(NSArray<NSString*>*)GetCommands {
  return [NSArray arrayWithObjects:
          @"(Any command that returns a value)"
          , nil];
}
@end

@implementation STRCommandsFigureCommands
//-(NSString*)GraphExport {
//  return @"graph export";
//}
-(NSArray<NSString*>*)GetCommands {
  return [STRParser FigureCommands];
}
@end


@implementation STRCommandsTableCommands
//-(NSString*)MatrixList {
//  return @"matrix list";
//}
-(NSArray<NSString*>*)GetCommands {

  return [NSArray arrayWithObjects:
          @"(Any command that returns a data frame, matrix, vector or list)"
          , nil];
}
@end
