//
//  STCodeParserUtil.h
//  StatTag
//
//  Created by Rasmussen, Luke on 8/23/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#ifndef STCodeParserUtil_h
#define STCodeParserUtil_h

#import <Foundation/Foundation.h>

@interface STCodeParserUtil : NSObject

+(NSString*) StripTrailingComments:(NSString*) originalText;

+(NSRegularExpression*)TrailingLineComment;

@end

#endif /* STCodeParserUtil_h */
