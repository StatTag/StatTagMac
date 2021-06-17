//
//  AppDelegate.h
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
}

@property NSWindowController *preferencesWindowController;
@property NSWindowController *aboutWindowController;
@property NSWindowController *samplesWindowController;

@property (weak) NSWindow* window;

@property (weak) IBOutlet NSView *dockTileView;

-(void)openPreferences;
-(void)openAboutWindow;
- (IBAction)openSamplesInstallerWindow:(id)sender;

-(void)openAlertPanelWithMessageText:(NSString*)messageText andInformativeText:(NSString*)informativeText;
-(void)openAlertPanelWithMessageText:(NSString*)messageText andInformativeText:(NSString*)informativeText Type:(NSAlertStyle)alertStyle;

@end

