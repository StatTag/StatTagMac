//
//  STPropertiesManager.h
//  StatTag
//
//  Created by Eric Whitley on 8/1/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STProperties;

@interface STPropertiesManager : NSObject {
  STProperties* _Properties;
}

@property (strong, nonatomic) STProperties* Properties;


/**
 Save the properties to the user's registry.
 */
-(void)Save;

/**
 Load the properties from the user's registry.
 */
-(void)Load;


@end
