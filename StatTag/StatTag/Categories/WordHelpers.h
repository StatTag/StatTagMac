//
//  WordHelpers.h
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STMSWord2011TextRange;
@class STMSWord2011Document;

@interface WordHelpers : NSObject

+ (instancetype)sharedInstance;

+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range;
+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range forDoc:(STMSWord2011Document*)doc;
+(void)TestAppleScript;
+(BOOL)FindText:(NSString*)text inRange:(STMSWord2011TextRange*)range;

@end
