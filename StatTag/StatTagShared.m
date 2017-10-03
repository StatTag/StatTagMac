//
//  StatTagShared.m
//  StatTag
//
//  Created by Eric Whitley on 9/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "StatTagShared.h"


#import "StatTagFramework.h"
#import "MainTabViewController.h"
#import "ManageCodeFilesViewController.h"
#import "SettingsViewController.h"
#import "UpdateOutputViewController.h"
#import "StatTagNeedsWordViewController.h"
#import "ViewUtils.h"
#import "FileMonitor.h"
#import "STCodeFile+FileMonitor.h"
#import "STDocumentManager+FileMonitor.h"


@implementation StatTagShared

@synthesize docManager = _docManager;
@synthesize doc = _doc;
@synthesize app = _app;
@synthesize mainVC = _mainVC;

@synthesize propertiesManager = _propertiesManager;
@synthesize logManager = _logManager;
//@synthesize fileMonitors = _fileMonitors;
@synthesize lastLaunchedAppVersion = _lastLaunchedAppVersion;

//@synthesize fileNotifications = _fileNotifications;

static StatTagShared *sharedInstance = nil;

NSString* const kStatTagErrorDomain = @"STErrorDomain";


+ (StatTagShared*)sharedInstance {
  if (sharedInstance == nil) {
    sharedInstance = [[super allocWithZone:NULL] init];
  }
  
  return sharedInstance;
}

- (id)init
{
  self = [super init];
  if (self) {
    [self setWordAppStatusMessage:@""];
//    [self setFileMonitors:[[NSMutableArray<FileMonitor*> alloc] init]];
    [self setLogManager:[[STLogManager alloc] init]];
//    [self setFileNotifications:[[NSMutableArray<NSDictionary*> alloc] init]];
  }
  return self;
}

-(void)dealloc
{
  for(FileMonitor* fm in [[self docManager] fileMonitors])
  {
    [fm stopMonitoring];
  }
}


+ (id)allocWithZone:(NSZone*)zone {
  return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

-(STMSWord2011Document*)doc
{
  STMSWord2011Document* d = _doc;
  if(_doc == nil)
  {
    d = [[[StatTagShared sharedInstance] app] activeDocument];
    _doc = d;
  }
  return _doc;
}
-(void)setDoc:(STMSWord2011Document *)doc
{
  _doc = doc;
}

+ (NSColor*)colorFromRGBRed:(CGFloat)r  green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a
{
  //our colors weren't right, so... had to read up on color spaces
  //http://stackoverflow.com/questions/426979/how-do-i-create-nscolor-instances-that-exactly-match-those-in-a-photoshop-ui-moc
  
  CGFloat rFloat = ((int)r) % 256 / 255.0;
  CGFloat gFloat = ((int)g) % 256 / 255.0;
  CGFloat bFloat = ((int)b) % 256 / 255.0;

  return [NSColor colorWithCalibratedRed:rFloat green:gFloat blue:bFloat alpha:a];
}

-(void)configureBasicProperties
{
  StatTagShared* shared = [StatTagShared sharedInstance];

  //set up some of our shared stattag stuff
  shared.app= [[[STGlobals sharedInstance] ThisAddIn] Application];
  shared.doc = [[shared app] activeDocument]; //this will be problematic ongoing when we open / close documents, etc.
  shared.docManager = [[STDocumentManager alloc] init];
  
  shared.logManager = [[STLogManager alloc] init];
  shared.propertiesManager = [[STPropertiesManager alloc] init];
  
  [[shared propertiesManager] Load];
  //self.properties = [[self propertiesManager] Properties]; //just for setup
  
  shared.logManager.Enabled = shared.propertiesManager.Properties.EnableLogging;
  if(shared.propertiesManager.Properties.LogLocation != nil)
  {
    shared.logManager.LogFilePath = [NSURL fileURLWithPath:shared.propertiesManager.Properties.LogLocation];
  }

}


-(void)setArchivedWindowFrame:(NSRect)archivedWindowFrame
{
  _archivedWindowFrame = archivedWindowFrame;

  //save our rect
  //NSMutableDictionary* prefs = [[NSMutableDictionary alloc] init];
  NSMutableDictionary* prefs = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]]];

  [prefs setValue:NSStringFromRect(_archivedWindowFrame) forKey:@"windowRect"];
  [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:[STCocoaUtil currentBundleIdentifier]];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSRect)archivedWindowFrame
{
  if(_archivedWindowFrame.size.height == 0)
  {
    //try to restore from preference
    NSDictionary* prefsDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]];
    NSRect rect = NSRectFromString([prefsDict valueForKey:@"windowRect"]);
    _archivedWindowFrame = rect;
  }
  return _archivedWindowFrame;
}



-(void)setLastLaunchedAppVersion:(NSString *)lastLaunchedAppVersion
{
  _lastLaunchedAppVersion = lastLaunchedAppVersion;
  //NSMutableDictionary* prefs = [[NSMutableDictionary alloc] init];
  NSMutableDictionary* prefs = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]]];
  [prefs setValue:_lastLaunchedAppVersion forKey:@"lastLaunchedAppVersion"];
  [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:[STCocoaUtil currentBundleIdentifier]];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)lastLaunchedAppVersion
{
  NSDictionary* prefsDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]];
  _lastLaunchedAppVersion = [prefsDict valueForKey:@"lastLaunchedAppVersion"];
  return _lastLaunchedAppVersion;
}

-(BOOL)isFirstLaunch
{
  NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
  
  if ([self lastLaunchedAppVersion] != nil) {
    [self setLastLaunchedAppVersion:currentAppVersion];
    return NO;
  }
  
  [self setLastLaunchedAppVersion:currentAppVersion];
  
  return YES;
}


-(BOOL)isNewVersion
{
  NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

  if ([self lastLaunchedAppVersion] != nil && [currentAppVersion isEqualToString:[self lastLaunchedAppVersion]]) {
    return NO;
  }

  [self setLastLaunchedAppVersion:currentAppVersion];
  
  return YES;
}

-(void)saveWindowFrame
{
  NSWindow* window = [[[NSApplication sharedApplication] windows] firstObject];
  [[StatTagShared sharedInstance] setArchivedWindowFrame:[window frame]];
}

-(void)restoreWindowFrame
{
  NSWindow* window = [[[NSApplication sharedApplication] windows] firstObject];
  if([[window windowController] contentViewController] == [[StatTagShared sharedInstance] mainVC])
  {
    NSRect frame = [[StatTagShared sharedInstance] archivedWindowFrame];
    if(frame.size.width > 0) {
      [window setFrame:frame display:YES animate:YES];
    }
  }
}

-(void)logAppStartup
{
  [[self logManager] WriteMessage:[NSString stringWithFormat:@"Starting StatTag... OS: %@; Hardware: %@; RAM: %@", [STCocoaUtil macOSVersion], [STCocoaUtil machineModel], [STCocoaUtil physicalMemory]]];
}


@end
