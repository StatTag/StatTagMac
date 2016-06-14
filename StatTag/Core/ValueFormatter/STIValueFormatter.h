//
//  STIValueFormatter.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STIValueFormatter <NSObject>

/**
@brief Given a string value that has gone through normal formatting, perform the final formatting step that is dependent on the statistical package.
@remark Currently this just handles formatting empty/missing values.
 */
-(NSString*)Finalize:(NSString*)value;

/**
 @brief Provide the string that should be used to represent a missing value.  This typically differs by
 statistical package, but could be extended to user preference.
*/
-(NSString*)GetMissingValue;


@end
