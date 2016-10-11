//
//  SCHelpers.h
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHelpers : NSObject


+(NSInteger)Clamp:(NSInteger)value min:(NSInteger)min max:(NSInteger) max;
+(NSInteger)ClampMin:(NSInteger)value min:(NSInteger) min;


@end
