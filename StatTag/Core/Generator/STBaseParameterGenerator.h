//
//  STBaseParameterGenerator.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STTag;

@interface STBaseParameterGenerator : NSObject {
  
}

-(NSString*) GetLabelParameter:(STTag*)tag;
-(NSString*) GetRunFrequencyParameter:(STTag*)tag;
-(NSString*) CleanResult:(NSString*)result;

@end
