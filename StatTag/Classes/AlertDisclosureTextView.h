//
//  AlertDisclosureTextView.h
//  StatTag
//
//  Created by Eric Whitley on 3/6/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AlertDisclosureTextView : NSViewController


@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (weak) IBOutlet NSTextField *disclosureLabel;


-(NSString*)viewNibName;

@end
