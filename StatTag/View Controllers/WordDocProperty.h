//
//  WordDocProperty.h
//  StatTag
//
//  Created by Eric Whitley on 2/27/19.
//  Copyright © 2019 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordDocProperty : NSObject

@property NSString* propertyName;
@property NSString* propertyValue;
@property NSString* propertyType;
@property NSString* propertyData;

-(instancetype)init;
-(instancetype)initWithName:(NSString*)name andValue:(NSString*)value forType:(NSString*)type;

@end
