//
//  SCMarkerHandle.h
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCMarkerHandle : NSObject {
  NSInteger _Value;
}


@property (nonatomic) NSInteger Value;
+(NSInteger) Zero;

@end
