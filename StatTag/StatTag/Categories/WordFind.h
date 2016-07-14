//
//  WordFind.h
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

// http://stackoverflow.com/questions/25984559/objective-c-scripting-bridge-and-apple-remote-desktop

#import <Cocoa/Cocoa.h>

@interface WordFind : NSObject {
  
  id  _scriptFile;
  
}

// (note: C primitives are only automatically bridged when calling from AS into ObjC;
// AS-based methods with boolean/integer/real parameters or results use NSNumber*)

-(NSNumber *)square:(NSNumber *)aNumber;



@end


