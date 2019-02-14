//
//  SettingsViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ConfigInfoViewController.h"
#import "DisclosureViewController.h"
#import "StatTagShared.h"

@class STUserSettings;
@class STSettingsManager;
@class STLogManager;


IB_DESIGNABLE

@interface SettingsViewController : NSViewController  {
  __weak NSButton *buttonChooseFile;
  __weak NSButton *buttonOpenLogFileFolder;
  __weak NSButton *configDisclosureButton;
  __weak NSButton *buttonCancelSave;
  __weak NSLayoutConstraint *configDetailsTextBoxHeightConstraint;
  __weak NSView *buttonSave;
  __weak NSButton *checkboxLogging;
  __weak NSTextField *labelFilePath;
  __weak NSView *boxView;
  __weak NSBox *boxGeneral;
  STUserSettings* _settings;
  STSettingsManager* _settingsManager;
  STLogManager* _logManager;
}

@property (weak) IBOutlet NSButton *buttonChooseFile;
//@property (weak) IBOutlet NSButton *buttonCancelSave;
//@property (weak) IBOutlet NSView *buttonSave;
@property (weak) IBOutlet NSButton *checkboxLogging;
@property (weak) IBOutlet NSTextField *labelFilePath;
@property (weak) IBOutlet NSView *boxView;
@property (weak) IBOutlet NSBox *boxGeneral;

@property (strong, nonatomic) STUserSettings* settings;
@property (strong, nonatomic) STSettingsManager* settingsManager;
@property (strong, nonatomic) STLogManager* logManager;

@property (weak) IBOutlet NSPathControl *logPathControl;

@property (weak) IBOutlet NSButton *buttonOpenLogFileFolder;
@property (weak) IBOutlet NSButton *configDisclosureButton;


@property (strong) IBOutlet DisclosureViewController *configDetailsDisclosureViewController;

@property (strong) IBOutlet ConfigInfoViewController *configDetailsViewController;
@property (weak) IBOutlet NSView *configDetailsView;



@end
