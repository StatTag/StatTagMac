//
//  STBaseParserStata.h
//  StatTag
//
//  Created by Eric Whitley on 6/28/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBaseParser.h"

@interface STBaseParserStata : STBaseParser {
  
}

+(BOOL)regexIsMatch:(NSRegularExpression*)regex inString:(NSString*)string;

@end
