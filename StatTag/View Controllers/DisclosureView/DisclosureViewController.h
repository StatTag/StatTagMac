/*
Taken from Apple sample code at
 https://developer.apple.com/library/content/samplecode/InfoBarStackView/Introduction/Intro.html
 */

@import AppKit;

@interface DisclosureViewController : NSViewController

@property IBOutlet NSView *disclosedView;

- (IBAction)toggleDisclosure:(id)sender;

@end
