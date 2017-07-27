//
//  STRVerbatimDevice.h
//  StatTag
//
//  Created by Rasmussen, Luke on 7/10/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#ifndef STRVerbatimDevice_h
#define STRVerbatimDevice_h

#import <RCocoa/RCICharacterDevice.h>

@interface STRVerbatimDevice : NSObject<RCICharacterDevice> {
  NSMutableArray<NSString*>* Cache;
  BOOL CacheEnabled;
}

+ (STRVerbatimDevice*) GetInstance;

-(id)init;
-(void)StartCache;
-(void)StopCache;
-(NSArray<NSString*>*)GetCache;

// Implemenetations for RCICharacterDevice
-(void)WriteConsole:(const char*)buffer length:(int)length;
-(void)WriteConsoleEx:(const char*)buffer length:(int)length otype:(int)otype;

@end

#endif /* STRVerbatimDevice_h */
