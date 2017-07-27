//
//  DuplicateTagGroupRowView.h
//  StatTag
//
//  Created by Eric Whitley on 4/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DuplicateTagGroupRowView : NSTableCellView {
//@public
//  IBOutlet NSTextField* title;
//  IBOutlet NSTextField* subTitle;  
}

@property (assign) IBOutlet NSTextField *title;
@property (assign) IBOutlet NSTextField *subTitle;


//http://stackoverflow.com/questions/7998389/why-cant-i-set-a-referencing-outlet-for-my-nstextview-in-xcode-4

@end
