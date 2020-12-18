//
//  STPrivacyConsentController.h
//  StatTagFramework
//
//  Created by Eric Whitley on 12/18/20.
//
// Taken from : https://github.com/Panopto/test-mac-privacy-consent

#import <Foundation/Foundation.h>
@class STPrivacyMonitoredApp;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PrivacyConsentState) {
    PrivacyConsentStateUnknown,
    PrivacyConsentStateGranted,
    PrivacyConsentStateDenied
};


@interface STPrivacyConsentController : NSObject {
  NSMutableDictionary<NSString*, STPrivacyMonitoredApp*>* _monitoredApps;
}

+ (instancetype)sharedController;
- (PrivacyConsentState)automationConsentForBundleIdentifier:(NSString *)bundleIdentifier promptIfNeeded:(BOOL)promptIfNeeded MessageText:(NSString*)messageText InformativeText:(NSString*)informativeText;
- (void)RequestAutomationConsent:(NSString*)messageText InformativeText:(NSString*)informativeText;

@property (strong, nonatomic, nullable) NSMutableDictionary<NSString*, STPrivacyMonitoredApp*>* monitoredApps;


@end

NS_ASSUME_NONNULL_END
