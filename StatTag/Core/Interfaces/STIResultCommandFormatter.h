//
//  STIFileHandler.h
//  StatTag
//
//  Created by Eric Whitley on 6/17/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIResultCommandList.h"

@protocol IResultCommandFormatter <NSObject>

-(STIResultCommandList*)ValueResultCommands;
-(STIResultCommandList*)FigureResultCommands;
-(STIResultCommandList*)TableResultCommands;


@end
