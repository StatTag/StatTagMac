/*
 Taken from Apple sample code at
 https://developer.apple.com/library/content/samplecode/InfoBarStackView/Introduction/Intro.html
*/

#import "DisclosureViewController.h"
@import QuartzCore;   // for kCAMediaTimingFunctionEaseInEaseOut

@interface DisclosureViewController ()
{
  NSView *_disclosedView;
  BOOL _disclosureIsClosed;

}
@property (weak) IBOutlet NSTextField *titleTextField;      // the title of the discloved view
@property (weak) IBOutlet NSButton *disclosureButton;       // the hide/show button
@property (weak) IBOutlet NSView *headerView;               // header/title section of this view controller

@property (strong) NSLayoutConstraint *closingConstraint;   // layout constraint applied to this view controller when closed
@property BOOL disclosureIsClosed;

@end


#pragma mark -

@implementation DisclosureViewController
{
}

@synthesize sectionTitle = _sectionTitle;

- (id)init
{
    return [self initWithNibName:@"DisclosureViewController" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil)
    {
      self.disclosureIsClosed = NO;
    }
    return self;
}

- (BOOL)disclosureIsClosed {
  return _disclosureIsClosed;
}

-(void)setDisclosureIsClosed:(BOOL)closed {
  if(closed) {
    self.disclosureButton.state = NSOffState;
  } else {
    self.disclosureButton.state = NSOnState;
  }
  _disclosureIsClosed = closed;
}

- (void)awakeFromNib
{
  self.disclosureIsClosed = NO;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self.titleTextField setStringValue:title];
}

- (NSView *)disclosedView
{
    return _disclosedView;
}

- (void)setDisclosedView:(NSView *)disclosedView
{
  if (_disclosedView != disclosedView)
  {
    [self.disclosedView removeFromSuperview];
    _disclosedView = disclosedView;
    [self.view addSubview:self.disclosedView];
    
    // we want a white background to distinguish between the
    // header portion of this view controller containing the hide/show button
    //
    self.disclosedView.wantsLayer = YES;
    self.disclosedView.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_disclosedView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_disclosedView)]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView][_disclosedView]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_headerView, _disclosedView)]];
    
    // add an optional constraint (but with a priority stronger than a drag), that the disclosing view
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_disclosedView]-(0@600)-|"
                                                                      options:0 metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_disclosedView)]];
  }
}

// The hide/show button was clicked
//
- (IBAction)toggleDisclosure:(id)sender
{
    if (!self.disclosureIsClosed)
    {
        CGFloat distanceFromHeaderToBottom = NSMinY(self.view.bounds) - NSMinY(self.headerView.frame);

        if (!self.closingConstraint)
        {
            // The closing constraint is going to tie the bottom of the header view to the bottom of the overall disclosure view.
            // Initially, it will be offset by the current distance, but we'll be animating it to 0.
            self.closingConstraint = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:distanceFromHeaderToBottom];
        }
        self.closingConstraint.constant = distanceFromHeaderToBottom;
        [self.view addConstraint:self.closingConstraint];
    
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
          context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
          // Animate the closing constraint to 0, causing the bottom of the header to be flush with the bottom of the overall disclosure view.
          context.duration = 0.1;
          self.closingConstraint.animator.constant = 0;
        } completionHandler:^{
            self.disclosureIsClosed = YES;
        }];
    }
    else
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
          context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
          context.duration = 0.1;
          // Animate the constraint to fit the disclosed view again
          self.closingConstraint.animator.constant -= self.disclosedView.frame.size.height;
        } completionHandler:^{
            // The constraint is no longer needed, we can remove it.
            [self.view removeConstraint:self.closingConstraint];
            self.disclosureIsClosed = NO;
        }];
    }
}

@end
