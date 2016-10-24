//
//  ViewUtils.m
//  StatTag
//
//  Created by Eric Whitley on 10/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "ViewUtils.h"

@implementation ViewUtils


+(void)fillView:(NSView*)parentView withView:(NSView*)newView {
  
  if(parentView != newView) {
    
    NSRect f = [parentView frame];
    f.size.width = newView.frame.size.width;
    f.size.height = newView.frame.size.height;
    parentView.frame = f;

    //clear existing subviews
    [parentView setSubviews:[NSArray array]];

    
    newView.frame = [parentView bounds];
    
    [newView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [parentView addSubview:newView];
    
    [parentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(newView)]];
    
    [parentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(newView)]];
  }
}

@end
