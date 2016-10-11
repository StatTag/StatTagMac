//
//  SettingsViewController.h
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STProperties;
@class STPropertiesManager;
@class STLogManager;


IB_DESIGNABLE

@interface SettingsViewController : NSViewController  {
  __weak NSButton *buttonChooseFile;
  __weak NSButton *buttonCancelSave;
  __weak NSView *buttonSave;
  __weak NSButton *checkboxLogging;
  __weak NSTextField *labelFilePath;
  __weak NSView *boxView;
  __weak NSBox *boxGeneral;
  STProperties* _properties;
  STPropertiesManager* _propertiesManager;
  STLogManager* _logManager;
}

@property (weak) IBOutlet NSButton *buttonChooseFile;
//@property (weak) IBOutlet NSButton *buttonCancelSave;
//@property (weak) IBOutlet NSView *buttonSave;
@property (weak) IBOutlet NSButton *checkboxLogging;
@property (weak) IBOutlet NSTextField *labelFilePath;
@property (weak) IBOutlet NSView *boxView;
@property (weak) IBOutlet NSBox *boxGeneral;

@property (strong, nonatomic) STProperties* properties;
@property (strong, nonatomic) STPropertiesManager* propertiesManager;
@property (strong, nonatomic) STLogManager* logManager;

@property (weak) IBOutlet NSPathControl *logPathControl;



@end
