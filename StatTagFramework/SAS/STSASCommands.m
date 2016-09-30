//
//  STSASCommands.m
//  StatTag
//
//  Created by Eric Whitley on 9/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STSASCommands.h"

@implementation STSASCommands
-(NSObject<STIResultCommandList>*)ValueResultCommands {
  return [[STSASCommandsValueCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)FigureResultCommands {
  return [[STSASCommandsFigureCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)TableResultCommands {
  return [[STSASCommandsTableCommands alloc] init];
}

@end

//MARK: "nested" classes for SAS Commands

@implementation STSASCommandsValueCommands
-(NSString*)Display {
  return @"%put";
}

-(NSArray<NSString*>*)GetCommands {
  return [NSArray arrayWithObjects:
          [self Display]
          , nil];
}
@end

@implementation STSASCommandsFigureCommands
-(NSString*)GraphExport {
  return @"ODS PDF";
}
-(NSArray<NSString*>*)GetCommands {
  return [NSArray arrayWithObjects:
          [self GraphExport]
          , nil];
}
@end


@implementation STSASCommandsTableCommands
-(NSString*)MatrixList {
  return @"ODS CSV";
}
-(NSArray<NSString*>*)GetCommands {
  return [NSArray arrayWithObjects:
          [self MatrixList]
          , nil];
}
@end
