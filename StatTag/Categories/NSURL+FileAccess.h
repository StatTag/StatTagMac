//
//  NSURL+FileAccess.h
//  StatTag
//
//  Created by Eric Whitley on 5/27/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (FileAccess)

-(bool)canReadFileAtPath;
-(bool)canWriteToFileAtPath;
-(bool)fileExistsAtPath;

@end
