//
//  AppticsConfig.h
//  JAnalytics
//
//  Created by Saravanan S on 08/06/20.
//  Copyright © 2020 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAEnums.h>
//#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppticsConfig : NSObject

@property (nonatomic) bool enableBackgroundTask API_AVAILABLE(ios(13.0), tvos(13.0), watchos(3.0)) API_UNAVAILABLE(macos);
//@property (nonatomic) bool enableAutoCheckForAppUpdate;
@property (nonatomic) bool enableAutomaticEventTracking;
@property (strong, nonatomic) NSDictionary *launchOptions;

//@property (nonatomic, strong) UISceneConnectionOptions *sceneconnectionOptions API_AVAILABLE(ios(13.0), tvos(13.0), watchos(3.0)) API_UNAVAILABLE(macos);

@property (nonatomic) bool enableCrossPromotionAppsList API_UNAVAILABLE(macos, tvos, watchos);

@property (nonatomic) bool enableFeedbackKit API_UNAVAILABLE(macos, tvos, watchos);
@property (nonatomic) int  maxToleranceForShakeToFeedback API_UNAVAILABLE(macos, tvos, watchos);

@property (nonatomic) bool enableRemoteConfig;
@property (nonatomic) bool enableRateUs API_UNAVAILABLE(macos, watchos);
@property (nonatomic) bool sendDataOnMobileNetworkByDefault;

//@property (nonatomic) bool completeOffByDefault;
@property (nonatomic) bool trackOnByDefault;
@property (nonatomic) bool enableAutomaticSessionTracking;
@property (nonatomic) bool enableAutomaticScreenTracking;
@property (nonatomic) bool enableAutomaticCrashTracking;

@property (nonatomic) APAnonymousType anonymousType;
@property (nonatomic) APDeviceIdentifierType deviceIdentifierType API_UNAVAILABLE(macos, watchos);

@property (class) AppticsConfig *defaultConfig;

//@property (nonatomic) NSString* timeZone;
@property (nonatomic) NSString* defaultLang;

@property (nonatomic) double minSessionDuration;
@property (nonatomic) double maxSessionTimeout;

@end

NS_ASSUME_NONNULL_END

