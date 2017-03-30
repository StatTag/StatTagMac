//
//  NSAttributedString+NSAttributedString_Hyperlink.h
//  StatTag
//
//  Created by Eric Whitley on 3/29/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

//https://developer.apple.com/library/content/qa/qa1487/_index.html

#import <Foundation/Foundation.h>

@interface NSAttributedString (Hyperlink)
  +(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end
