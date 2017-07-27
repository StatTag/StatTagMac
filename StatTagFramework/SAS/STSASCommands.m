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
-(NSObject<STIResultCommandList>*)VerbatimResultCommands {
    return [[STSASCommandsVerbatimCommands alloc] init];
}

@end

//MARK: "nested" classes for SAS Commands

@implementation STSASCommandsValueCommands
-(NSArray<NSString*>*)GetCommands {
  return [NSArray<NSString*> arrayWithObject: @"%put"];
}
@end

@implementation STSASCommandsFigureCommands
-(NSArray<NSString*>*)GetCommands {
  return [NSArray<NSString*> arrayWithObject: @"ODS PDF"];
}
@end


@implementation STSASCommandsTableCommands
-(NSArray<NSString*>*)GetCommands {
  return [NSArray<NSString*> arrayWithObject: @"ODS CSV"];
}
@end

@implementation STSASCommandsVerbatimCommands
-(NSArray<NSString*>*)GetCommands {
    return [NSArray<NSString*> arrayWithObject: @"(Any command)"];
}
@end
