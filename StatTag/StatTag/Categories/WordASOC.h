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


@interface WordASOC : NSObject

// Note: C primitives are only automatically bridged when calling from AS into ObjC.
// AS methods with boolean/integer/real parameters/results must declare NSNumber*:

-(NSNumber*)findText:(NSString*)searchText atRangeStart:(NSNumber*)rangeStart andRangeEnd:(NSNumber*)rangeEnd;

-(void)createOrUpdateDocumentVariableWithName:(NSString*)variableName andValue:(NSString*)variableValue;


@end
