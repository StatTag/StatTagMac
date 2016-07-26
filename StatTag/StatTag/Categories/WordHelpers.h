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
+(BOOL)FindText:(NSString*)text inRange:(STMSWord2011TextRange*)range;

/**
 Unlike the C# version of Range, we can't juset update content - this simply _appends_ content to the range. And - we can't directly update the content and shift the positions cleanly - the "update position" methods all return a new instance of the text range.  (I know, right?)
 
 So instead we need to return a new object, but... not. So we're going to create a new one in the method and then point to that object using the original object reference.
 
 Kludgy.
 */
+(void)updateContent:(NSString*)text inRange:(STMSWord2011TextRange**)range;
//+(STMSWord2011TextRange*)setRangeStart:(int)start end:(int)end;
+(void)setRange:(STMSWord2011TextRange**)range Start:(int)start end:(int)end;
  
@end
