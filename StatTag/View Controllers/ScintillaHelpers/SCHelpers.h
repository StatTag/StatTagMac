//
//  SCHelpers.h
//  StatTag
//
//  Created by Eric Whitley on 9/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHelpers : NSObject


+(long)Clamp:(long)value min:(long)min max:(long) max;
+(long)ClampMin:(long)value min:(long) min;


@end
