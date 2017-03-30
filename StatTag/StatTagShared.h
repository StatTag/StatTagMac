//
//  StatTagShared.h
//  StatTag
//
//  Created by Eric Whitley on 9/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class MainTabViewController;
@class STMSWord2011Application;
@class STMSWord2011Document;
@class STDocumentManager;
@class ManageCodeFilesViewController;
@class STPropertiesManager;
//@class STLogManager;
@class StatTagNeedsWordViewController;
@class SettingsViewController;
@class FileMonitor;
@class UpdateOutputViewController;

#import "STLogManager.h"

@interface StatTagShared : NSObject {
  MainTabViewController* _mainVC;
  STMSWord2011Application* _app;
  STMSWord2011Document* _doc;
  STDocumentManager* _docManager;
  STPropertiesManager* _propertiesManager;
  STLogManager* _logManager;
  NSMutableArray<FileMonitor*>* _fileMonitors;
  NSRect _archivedWindowFrame;
  //  NSWindow* _mainWindow;
}

+ (id)sharedInstance;

//StatTag objects
@property (strong, nonatomic) STMSWord2011Application* app;
@property (strong, nonatomic) STMSWord2011Document* doc;
@property (strong, nonatomic) STDocumentManager* docManager;
@property (strong, nonatomic) STPropertiesManager* propertiesManager;
@property (strong, nonatomic) STLogManager* logManager;
@property (strong, nonatomic) StatTagNeedsWordViewController* needsWordController;
@property (strong, nonatomic) ManageCodeFilesViewController* codeFilesViewController;
@property (strong, nonatomic) SettingsViewController* settingsViewController;
@property (strong, nonatomic) UpdateOutputViewController* tagsViewController;

@property (strong, nonatomic) NSString* lastLaunchedAppVersion;
-(BOOL)isFirstLaunch;
-(BOOL)isNewVersion;


@property (strong, nonnull) NSString* wordAppStatusMessage;
@property BOOL wordAccessible;

//view controller accessors
@property (strong, nonatomic) MainTabViewController* mainVC; //weak?

+ (NSColor*)colorFromRGBRed:(CGFloat)r  green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;

@property (weak, nonatomic) NSWindow* window;

@property (strong, nonatomic) NSMutableArray<FileMonitor*>* fileMonitors;

-(void)initializeWordViews;
-(void)configureBasicProperties;

-(void)saveWindowFrame;
-(void)restoreWindowFrame;

@property NSRect archivedWindowFrame;

typedef enum {
  ManageCodeFiles = 0,
  Settings = 1,
  UpdateOutput = 2
} StatTagTabIndexes;

typedef enum {
  OK = 0,
  Error = 1,
  Cancel = 2
} StatTagResponseState;


extern NSString* const kStatTagErrorDomain = @"STErrorDomain";

-(void)logAppStartup;

//-(void)logMessage:(NSString*)message;
//-(void)logException:(NSException*)exception;


#define LOG_STATTAG_MESSAGE(var, ...) [[[StatTagShared sharedInstance] logManager] WriteMessage:var, ## __VA_ARGS__]
#define LOG_STATTAG_EXCEPTION(var, ...) [[[StatTagShared sharedInstance] logManager] WriteException:var, ## __VA_ARGS__]

@end

