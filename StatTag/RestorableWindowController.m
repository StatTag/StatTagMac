//
//  RestorableWindowController.m
//  StatTag
//
//  Created by Eric Whitley on 7/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "RestorableWindowController.h"

@interface RestorableWindowController ()

@end

@implementation RestorableWindowController

static NSString* MAIN_WINDOW_FRAME = @"MAIN_WINDOW_FRAME";
static NSString* QUITTING_ZOOM_STATE = @"QUITTING_ZOOM_STATE";

//2nd monitor support
//https://stackoverflow.com/questions/30160885/nswindow-autosave-position-not-saved-on-2nd-monitor
/*
 Good option here for our weird window position/size being lost
 1) When we close our window (which closes our app), try to store our window frame information (into user defaults)
 2) When we then reopen our window, set the frame size back to our defaults
 
 The sticky bit is when we go full screen (which is not restored on startup - nor do we want it to), that's not a frame size we want to retain. So we're going to store the window state _before_ we go into full screen. That way we get the original size. That's what we're going to store.
 
 Delegate reference here: https://developer.apple.com/documentation/appkit/nswindowdelegate
 */

- (void)windowDidLoad {
  [super windowDidLoad];
  [self restoreWindowState];
}

-(void)windowWillEnterFullScreen:(NSNotification *)notification
{
  [self saveWindowState];
}

- (void)windowWillClose:(NSNotification *)notification
{
  [self saveWindowState];
}

-(void)saveWindowState
{
  NSString  *mainWindowFrameString;
  bool fullScreen = [[[self window] contentView] isInFullScreenMode];
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:fullScreen] forKey:QUITTING_ZOOM_STATE];
  
  if (fullScreen == NO) {
    //only save our frame if we are not in full screen
    mainWindowFrameString = NSStringFromRect([[self window] frame]);
    [[NSUserDefaults standardUserDefaults] setObject:mainWindowFrameString forKey:MAIN_WINDOW_FRAME];
  }
  
  [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)restoreWindowState
{
  NSString* mainWindowFrameString = [[NSUserDefaults standardUserDefaults] objectForKey:MAIN_WINDOW_FRAME];
  NSRect mainWindowFrame = NSRectFromString(mainWindowFrameString);
  
  if ((mainWindowFrame.size.width != 0) && (mainWindowFrame.size.height != 0)) {
    [[self window] setFrame:mainWindowFrame display:YES];
  }
  else {
    [[self window] center];
  }
}

@end
