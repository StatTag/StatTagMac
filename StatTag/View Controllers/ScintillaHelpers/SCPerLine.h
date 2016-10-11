//
//  SCPerLine.h
//  StatTag
//
//  Created by Eric Whitley on 10/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

//MARK: PerLine
typedef NS_ENUM(NSInteger, ContainsMultibyte) {
  No = -1,
  Unknown,
  Yes
};

@interface SCPerLine : NSObject


@property NSInteger Start;

/// <summary>
/// 1 if the line contains multibyte (Unicode) characters; -1 if not; 0 if undetermined.
/// </summary>
/// <remarks>Using an enum instead of Nullable because it uses less memory per line...</remarks>
@property ContainsMultibyte ContainsMultibyte;

-(instancetype) init;
-(instancetype) initWithStart:(NSInteger)start andContainsMultibyte:(ContainsMultibyte)mb;

@end
