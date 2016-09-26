//
//  ASOC.h
//  TestASOC
//
//  Created by Eric Whitley on 7/14/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol ASOC <NSObject>
//
//-(void)thinkdifferent;
//-(NSNumber *)square:(NSNumber *)aNumber;
//
//@end


@interface ASOC : NSObject

// Note: C primitives are only automatically bridged when calling from AS into ObjC.
// AS methods with boolean/integer/real parameters/results must declare NSNumber*:

-(void)thinkdifferent;
- (NSNumber *)square:(NSNumber *)aNumber;
//- (NSNumber *)findText:(NSString*)text atRangeStart:(NSNumber*)rangeStart andRangeEnd:(NSNumber*)rangeEnd;
//- (void)findText:(NSString*)text atRangeStart:(NSNumber*)rangeStart andRangeEnd:(NSNumber*)rangeEnd;

-(NSNumber*)findText:(NSString*)searchText atRangeStart:(NSNumber*)rangeStart andRangeEnd:(NSNumber*)rangeEnd;
-(NSString *)doSomethingTo:(NSString*)string andTo:(NSString *)another;

@end
