//
//  SCHelpers.h
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHelpers : NSObject


+(int)Clamp:(int)value min:(int)min max:(int) max;
+(int)ClampMin:(int)value min:(int) min;


@end
