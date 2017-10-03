//
//  StatTagShared.h
//  StatTag
//
//  Created by Eric Whitley on 9/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "FileMonitor.h"


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
@class STCodeFile;

#import "STLogManager.h"

@interface StatTagShared : NSObject {
  MainTabViewController* _mainVC;
  STMSWord2011Application* _app;
  STMSWord2011Document* _doc;
  STDocumentManager* _docManager;
  STPropertiesManager* _propertiesManager;
  STLogManager* _logManager;
  NSRect _archivedWindowFrame;
//  NSMutableArray<FileMonitor*>* _fileMonitors;
//  NSMutableArray<NSDictionary*>* _fileNotifications;
  //  NSWindow* _mainWindow;
}

+ (nullable id)sharedInstance;

//StatTag objects
@property (strong, nonatomic, nullable) STMSWord2011Application* app;
@property (strong, nonatomic, nullable) STMSWord2011Document* doc;
@property (strong, nonatomic, nullable) STDocumentManager* docManager;
@property (strong, nonatomic, nullable) STPropertiesManager* propertiesManager;
@property (strong, nonatomic, nullable) STLogManager* logManager;
@property (strong, nonatomic, nullable) StatTagNeedsWordViewController* needsWordController;
@property (strong, nonatomic, nullable) ManageCodeFilesViewController* codeFilesViewController;
@property (strong, nonatomic, nullable) SettingsViewController* settingsViewController;
@property (strong, nonatomic, nullable) UpdateOutputViewController* tagsViewController;

@property (strong, nonatomic, nullable) NSString* lastLaunchedAppVersion;
-(BOOL)isFirstLaunch;
-(BOOL)isNewVersion;


@property (strong, nonnull) NSString* wordAppStatusMessage;
@property BOOL wordAccessible;

//view controller accessors
@property (strong, nonatomic, nullable) MainTabViewController* mainVC; //weak?

+ (nonnull NSColor*)colorFromRGBRed:(CGFloat)r  green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;

@property (weak, nonatomic, nullable) NSWindow* window;

@property (strong, nonatomic, nullable) NSMutableArray<FileMonitor*>* fileMonitors;

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


extern NSString* _Nonnull const kStatTagErrorDomain;

-(void)logAppStartup;

//-(void)logMessage:(NSString*)message;
//-(void)logException:(NSException*)exception;

//-(void)monitorCodeFile:(STCodeFile*_Nullable)file;
//-(void)stopMonitoringCodeFile:(STCodeFile*_Nullable)file;
//-(void)fileDidChange:(NSDictionary*_Nullable)fileInfo;

//@property NSMutableArray<NSDictionary*>* _Nonnull fileNotifications;

#define LOG_STATTAG_MESSAGE(var, ...) [[[StatTagShared sharedInstance] logManager] WriteMessage:var, ## __VA_ARGS__]
#define LOG_STATTAG_EXCEPTION(var, ...) [[[StatTagShared sharedInstance] logManager] WriteException:var, ## __VA_ARGS__]

@end

