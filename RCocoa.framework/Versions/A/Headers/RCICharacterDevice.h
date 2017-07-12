//
//  RCICharacterDevice.h
//  RCocoa
//
//  Created by Luke Rasmussen on 7/6/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCICharacterDevice_h
#define RCICharacterDevice_h

// We have purposely defined a minimal set of functions for the character device interface.
// R.NET exposes many more, and these can be added when/if the need arises.
// R.NET interface: https://github.com/jmp75/rdotnet/blob/master/R.NET/Devices/ICharacterDevice.cs
// More info on the types of callbacks at: http://www.hep.by/gnu/r-patched/r-exts/R-exts_157.html

@protocol RCICharacterDevice <NSObject>

-(void)WriteConsole:(const char*)buffer length:(int)length;
-(void) WriteConsoleEx:(const char*)buffer length:(int)length otype:(int)otype;

@end

#endif /* RCICharacterDevice_h */
