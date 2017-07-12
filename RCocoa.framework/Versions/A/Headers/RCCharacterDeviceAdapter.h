//
//  RCCharacterDeviceAdapter.h
//  RCocoa
//
//  Created by Luke Rasmussen on 7/6/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCCharacterDeviceAdapter_h
#define RCCharacterDeviceAdapter_h

@class RCEngine;
@class RCICharacterDevice;

@interface RCCharacterDeviceAdapter : NSObject
{
    RCEngine* _engine;
}

-(id) initWithDevice:(RCICharacterDevice*)device;
-(void) Install: (RCEngine*)engine;
-(void) SetupDevice;


@end

#endif /* RCCharacterDeviceAdapter_h */
