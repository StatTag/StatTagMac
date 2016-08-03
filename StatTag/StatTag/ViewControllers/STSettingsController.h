//
//  STSettingsController.h
//  StatTag
//
//  Created by Eric Whitley on 8/3/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STProperties;
@class STPropertiesManager;
@class STLogManager;

@interface STSettingsController : NSWindowController {
  __weak NSButton *buttonChooseFile;
  __weak NSButton *buttonCancelSave;
  __weak NSView *buttonSave;
  __weak NSButton *checkboxLogging;
  __weak NSTextField *labelFilePath;
  __weak NSView *boxView;
  __weak NSBox *boxGeneral;
  STProperties* _Properties;
  STPropertiesManager* _PropertiesManager;
  STLogManager* _LogManager;
}

@property (weak) IBOutlet NSButton *buttonChooseFile;
@property (weak) IBOutlet NSButton *buttonCancelSave;
@property (weak) IBOutlet NSView *buttonSave;
@property (weak) IBOutlet NSButton *checkboxLogging;
@property (weak) IBOutlet NSTextField *labelFilePath;
@property (weak) IBOutlet NSView *boxView;
@property (weak) IBOutlet NSBox *boxGeneral;

@property (strong, nonatomic) STProperties* Properties;
@property (strong, nonatomic) STPropertiesManager* PropertiesManager;
@property (strong, nonatomic) STLogManager* LogManager;


- (void)windowWillClose:(NSNotification*)notification;
- (void)windowDidBecomeKey:(NSNotification*)notification;


@end
