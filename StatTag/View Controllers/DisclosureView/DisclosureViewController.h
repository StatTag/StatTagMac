/*
Taken from Apple sample code at
 https://developer.apple.com/library/content/samplecode/InfoBarStackView/Introduction/Intro.html
 */

//@import AppKit;
#import <Cocoa/Cocoa.h>

@interface DisclosureViewController : NSViewController {
  NSString* _sectionTitle;
}

@property IBOutlet NSView *disclosedView;

@property (copy, nonatomic) NSString* sectionTitle;

- (IBAction)toggleDisclosure:(id)sender;

@end
