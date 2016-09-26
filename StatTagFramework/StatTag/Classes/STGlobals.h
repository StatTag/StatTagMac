//
//  STGlobals.h
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STThisAddIn;

@interface STGlobals : NSObject {
  STThisAddIn* _ThisAddIn;
}

@property (copy, nonatomic) STThisAddIn* ThisAddIn;
+(instancetype)sharedInstance;

/**
 Dummy document activator for issues seen when deploying to Word as a framework
 we lose key field data like fieldText if we don't ask Word to bring something up
 */
+(void)activateDocument;

@end
