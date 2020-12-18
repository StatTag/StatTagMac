//
//  STPrivacyConsentController.m
//  StatTagFramework
//
//  Created by Eric Whitley on 12/18/20.
//
// Taken from : https://github.com/Panopto/test-mac-privacy-consent

#import "STPrivacyConsentController.h"
#import "STPrivacyMonitoredApp.h"
#import <Cocoa/Cocoa.h>


@implementation STPrivacyConsentController

@synthesize monitoredApps = _monitoredApps;

+ (instancetype)sharedController
{
    static dispatch_once_t once;
    static STPrivacyConsentController *sharedController;
    dispatch_once(&once, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

- (instancetype)init
{
    if (self = [super init]) {
      //[self setMonitoredBundleIdentifiers: [[NSMutableDictionary<NSString*, NSNumber*> alloc] init]];
        if (@available(macOS 10.14, *)) {
            [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                                   selector:@selector(applicationLaunched:)
                                                                       name:NSWorkspaceDidLaunchApplicationNotification
                                                                     object:nil];
        }
    }
    return self;
}


// !!!: Workaround for Apple bug. Their AppleEvents.h header conditionally defines errAEEventWouldRequireUserConsent and one other constant, valid only for 10.14 and higher, which means our code inside the @available() check would fail to compile. Remove this definition when they fix it.
#if __MAC_OS_X_VERSION_MIN_REQUIRED <= __MAC_10_14
enum {
    errAEEventWouldRequireUserConsent = -1744, /* Determining whether this can be sent would require prompting the user, and the AppleEvent was sent with kAEDoNotPromptForPermission */
};
#endif

- (void)launchPrivacyAndSecurityPreferencesAutomationSubPane
{
    // !!!: as of August 2018, toggling these settings in the pref pane DOES NOT warn you to restart the app to have changes take effect.
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"]];
}
- (PrivacyConsentState)automationConsentForBundleIdentifier:(NSString *)bundleIdentifier promptIfNeeded:(BOOL)promptIfNeeded MessageText:(NSString*)messageText InformativeText:(NSString*)informativeText
{
  PrivacyConsentState privacyConsentState = [self automationConsentForBundleIdentifier:bundleIdentifier promptIfNeeded:promptIfNeeded];
  [self SetAppStatusForBundleIdentifier:bundleIdentifier privacyConsentState:privacyConsentState MessageText:messageText InformativeText:informativeText];

  return privacyConsentState;
}

// Be careful about calling this method from the main thread, because AEDeterminePermissionToAutomateTarget() is a blocking call.
- (PrivacyConsentState)automationConsentForBundleIdentifier:(NSString *)bundleIdentifier promptIfNeeded:(BOOL)promptIfNeeded
{
    PrivacyConsentState result;
    if (@available(macOS 10.14, *)) {
        AEAddressDesc addressDesc;
        // We need a C string here, not an NSString
        const char *bundleIdentifierCString = [bundleIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
        OSErr createDescResult = AECreateDesc(typeApplicationBundleID, bundleIdentifierCString, strlen(bundleIdentifierCString), &addressDesc);
        OSStatus appleScriptPermission = AEDeterminePermissionToAutomateTarget(&addressDesc, typeWildCard, typeWildCard, promptIfNeeded);
        AEDisposeDesc(&addressDesc);
        switch (appleScriptPermission) {
            case errAEEventWouldRequireUserConsent:
                NSLog(@"Automation consent not yet granted for %@, would require user consent.", bundleIdentifier);
                result = PrivacyConsentStateUnknown;
                break;
            case noErr:
                NSLog(@"Automation permitted for %@.", bundleIdentifier);
                result = PrivacyConsentStateGranted;
                break;
            case errAEEventNotPermitted:
                NSLog(@"Automation of %@ not permitted.", bundleIdentifier);
                result = PrivacyConsentStateDenied;
                break;
            case procNotFound:
                NSLog(@"%@ not running, automation consent unknown.", bundleIdentifier);
                result = PrivacyConsentStateUnknown;
                break;
            default:
                NSLog(@"%s switch statement fell through: %@ %d", __PRETTY_FUNCTION__, bundleIdentifier, appleScriptPermission);
                result = PrivacyConsentStateUnknown;
        }
        return result;
    }
    else {
        result = PrivacyConsentStateGranted;
    }
      
  return result;

}

-(void)SetAppStatusForBundleIdentifier:(NSString*)bundleIdentifier privacyConsentState:(PrivacyConsentState)privacyConsentState MessageText:(NSString*)messageText InformativeText:(NSString*)informativeText
{
  STPrivacyMonitoredApp *monitoredApp = [[self monitoredApps] objectForKey:bundleIdentifier];
  if(monitoredApp == nil){
    monitoredApp = [[STPrivacyMonitoredApp alloc] initWithBundleIdentifier:bundleIdentifier privacyConsentState:privacyConsentState MessageText:messageText InformativeText:informativeText ];
  }
  [[self monitoredApps] setObject:monitoredApp forKey:bundleIdentifier];

}

- (void)RequestAutomationConsent:(NSString*)messageText InformativeText:(NSString*)informativeText
{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = messageText;
    alert.informativeText = informativeText;
    [alert addButtonWithTitle:@"Change Security & Privacy Preferences"];
    [alert addButtonWithTitle:@"Cancel"];
      
    NSInteger modalResponse = [alert runModal];
    if (modalResponse == NSAlertFirstButtonReturn) {
        [self launchPrivacyAndSecurityPreferencesAutomationSubPane];
    }
}


- (void)applicationLaunched:(NSNotification *)notification
{
  NSRunningApplication *app = notification.userInfo[NSWorkspaceApplicationKey];
  STPrivacyMonitoredApp *monitoredApp = [[self monitoredApps] objectForKey:app.bundleIdentifier];
  if(monitoredApp != nil){
    PrivacyConsentState privacyConsentState = [self automationConsentForBundleIdentifier:app.bundleIdentifier promptIfNeeded:YES];
    [monitoredApp setPrivacyConsentState:privacyConsentState];
    [[self monitoredApps] setObject:monitoredApp forKey:app.bundleIdentifier];
    if (privacyConsentState != PrivacyConsentStateGranted) {
        NSLog(@"StatTag: applicationLaunched privacy check indicated application currently denied. Prompting for access.");
        [self RequestAutomationConsent:[monitoredApp messageText] InformativeText:[monitoredApp informativeText]];
    }
  }
}

 
@end
