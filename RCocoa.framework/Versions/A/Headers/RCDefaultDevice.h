//
//  RCDefaultDevice.h
//  RCocoa
//
//  Created by Luke Rasmussen on 7/7/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCDefaultDevice_h
#define RCDefaultDevice_h

#include "RCICharacterDevice.h"

@interface RCDefaultDevice : NSObject<RCICharacterDevice>
{
}

-(void)WriteConsole:(const char*)buffer length:(int)length;
-(void) WriteConsoleEx:(const char*)buffer length:(int)length otype:(int)otype;

@end

#endif /* RCDefaultDevice_h */
