//
//  AppDelegate.h
//  StatTagTestUI
//
//  Created by Eric Whitley on 8/3/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
  __unsafe_unretained NSTextView *logTextView;
}


@property (unsafe_unretained) IBOutlet NSTextView *logTextView;

@end

