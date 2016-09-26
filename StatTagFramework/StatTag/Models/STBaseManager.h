//
//  STBaseManager.h
//  StatTag
//
//  Created by Eric Whitley on 8/1/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STLogManager;

@interface STBaseManager : NSObject {
  STLogManager* _Logger;
}

@property (strong, nonatomic) STLogManager* Logger;

-(void)Log:(NSString*)text;
-(void)LogException:(NSException*) exc;

@end
