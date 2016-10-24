//
//  STCodeFile+FileAttributes.h
//  StatTag
//
//  Created by Eric Whitley on 10/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STCodeFile.h"

@interface STCodeFile (FileAttributes)

@property (copy, nonatomic) NSDate* creationDate;
@property (copy, nonatomic) NSDate* modificationDate;
-(BOOL)fileAccessibleAtPath;
-(NSString*)codeFileToolTipMessage;

@end
