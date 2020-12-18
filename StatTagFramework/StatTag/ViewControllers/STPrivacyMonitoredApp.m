//
//  STPrivacyMonitoredApp.m
//  StatTagFramework
//
//  Created by Eric Whitley on 12/18/20.
//  Copyright © 2020 StatTag. All rights reserved.
//

#import "STPrivacyMonitoredApp.h"

@implementation STPrivacyMonitoredApp

@synthesize bundleIdentifier = _bundleIdentifier;
@synthesize messageText = _messageText;
@synthesize informativeText = _informativeText;
@synthesize privacyConsentState = _privacyConsentState;

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithBundleIdentifier:(NSString*)bundleIdentifier privacyConsentState:(PrivacyConsentState)privacyConsentState MessageText:(NSString*)messageText InformativeText:(NSString*)informativeText
{
    if (self = [super init]) {
      [self setBundleIdentifier:bundleIdentifier];
      [self setMessageText:messageText];
      [self setInformativeText:informativeText];
      [self setPrivacyConsentState:privacyConsentState];
    }
    return self;
}


@end
