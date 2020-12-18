//
//  STPrivacyMonitoredApp.h
//  StatTagFramework
//
//  Created by Eric Whitley on 12/18/20.
//  Copyright © 2020 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPrivacyConsentController.h"

NS_ASSUME_NONNULL_BEGIN

@interface STPrivacyMonitoredApp : NSObject{
  NSString* _bundleIdentifier;
  NSString* _messageText;
  NSString* _informativeText;
  PrivacyConsentState _privacyConsentState;
}

@property (strong, nonatomic, nullable) NSString* bundleIdentifier;
@property (strong, nonatomic, nullable) NSString* messageText;
@property (strong, nonatomic, nullable) NSString* informativeText;
@property (nonatomic) PrivacyConsentState privacyConsentState;

- (instancetype)initWithBundleIdentifier:(NSString*)bundleIdentifier privacyConsentState:(PrivacyConsentState)privacyConsentState MessageText:(NSString*)messageText InformativeText:(NSString*)informativeText ;

@end

NS_ASSUME_NONNULL_END
