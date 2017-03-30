//
//  NSAttributedString+NSAttributedString_Hyperlink.m
//  StatTag
//
//  Created by Eric Whitley on 3/29/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "NSAttributedString+Hyperlink.h"

@implementation NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
  NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
  NSRange range = NSMakeRange(0, [attrString length]);
  
  [attrString beginEditing];
  [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
  
  // make the text appear in blue
  [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
  
  // next make the text appear with an underline
  [attrString addAttribute:
   NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
  
  [attrString endEditing];
  
  return attrString;
}

@end
