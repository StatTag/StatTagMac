//
//  STStataCommands.m
//  StatTag
//
//  Created by Eric Whitley on 7/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STStataCommands.h"
#import "STStataParser.h"

@implementation STStataCommands

+(NSString*)CleanUpRegex:(NSString*)value
{
  return [[value stringByReplacingOccurrencesOfString:@"(:" withString:@"["] stringByReplacingOccurrencesOfString:@")?" withString:@"]"];
}

+(NSArray<NSString*>*)CleanUpRegexArray:(NSArray<NSString*>*)values
{
  NSMutableArray<NSString*>* c = [[NSMutableArray<NSString*> alloc] initWithArray:values];
  for(NSInteger i = 0; i < [c count]; i++)
  {
    [c setObject:[STStataCommands CleanUpRegex:[c objectAtIndex:i]] atIndexedSubscript:i];
  }
  return c;
}

-(NSObject<STIResultCommandList>*)ValueResultCommands {
  return [[STStataCommandsValueCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)FigureResultCommands {
  return [[STStataCommandsFigureCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)TableResultCommands {
  return [[STStataCommandsTableCommands alloc] init];
}
-(NSObject<STIResultCommandList>*)VerbatimResultCommands {
  return [[STStataVerbatimCommands alloc] init];
}

@end

//MARK: "nested" classes for Stata Commands

@implementation STStataCommandsValueCommands
//-(NSString*)Display {
//  return @"display";
//}
-(NSArray<NSString*>*)GetCommands {
  return [STStataParser ValueCommands];
//  return [NSArray arrayWithObjects:
//          [self Display]
//          , nil];
}
@end

@implementation STStataCommandsFigureCommands
//-(NSString*)GraphExport {
// return @"graph export";
//}
-(NSArray<NSString*>*)GetCommands {
  return [STStataCommands CleanUpRegexArray:[STStataParser GraphCommands]];
//  return [NSArray arrayWithObjects:
//          [self GraphExport]
//          , nil];
}
@end


@implementation STStataCommandsTableCommands
//-(NSString*)MatrixList {
// return @"matrix list";
//}
-(NSArray<NSString*>*)GetCommands {
  return [STStataCommands CleanUpRegexArray:[STStataParser TableCommands]];

//  return [NSArray arrayWithObjects:
//          [self MatrixList]
//          , nil];
}
@end

@implementation STStataVerbatimCommands
-(NSArray<NSString*>*)GetCommands {
  return [NSArray<NSString*> arrayWithObject:@"(Any command)"];
}
@end
