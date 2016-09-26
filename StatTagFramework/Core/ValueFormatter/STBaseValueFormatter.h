//
//  BaseValueFormatter.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIValueFormatter.h"

@interface STBaseValueFormatter : NSObject <STIValueFormatter> {
}

+(NSString*) MissingValue;

-(NSString*)GetMissingValue;
-(NSString*)Finalize:(NSString*)value;


@end
