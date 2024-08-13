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

typedef NS_ENUM(NSInteger, APMaxSessionTimeout) {
    APMaxSessionTimeout15 = 15,
    APMaxSessionTimeout20 = 20,
    APMaxSessionTimeout25 = 25,
    APMaxSessionTimeout30 = 30,
    APMaxSessionTimeout35 = 35,
    APMaxSessionTimeout40 = 40,
    APMaxSessionTimeout45 = 45,
    APMaxSessionTimeout50 = 50,
    APMaxSessionTimeout55 = 55,
    APMaxSessionTimeout60 = 60
};

typedef NS_ENUM(NSInteger, APMinSessionDuration) {
    APMinSessionDuration1 = 1,
    APMinSessionDuration2 = 2,
    APMinSessionDuration3 = 3,
    APMinSessionDuration4 = 4,
    APMinSessionDuration5 = 5,
    APMinSessionDuration6 = 6,
    APMinSessionDuration7 = 7,
    APMinSessionDuration8 = 8,
    APMinSessionDuration9 = 9,
    APMinSessionDuration10 = 10
};

typedef NS_ENUM(NSInteger, APFlushInterval) {
    APFlushIntervalNone = 0,
    APFlushInterval10 = 10,
    APFlushInterval15 = 15,
    APFlushInterval20 = 20,
    APFlushInterval25 = 25,
    APFlushInterval30 = 30,
    APFlushInterval35 = 35,
    APFlushInterval40 = 40,
    APFlushInterval45 = 45,
    APFlushInterval50 = 50,
    APFlushInterval55 = 55,
    APFlushInterval60 = 60
};

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
@property (nonatomic) bool trackAllScreens;

@property (nonatomic) APAnonymousType anonymousType;
//@property (nonatomic) APDeviceIdentifierType deviceIdentifierType API_UNAVAILABLE(macos, watchos);

@property (class) AppticsConfig *defaultConfig;

//@property (nonatomic) NSString* timeZone;
@property (nonatomic) NSString* defaultLang;

@property (nonatomic) APMinSessionDuration minSessionDuration;
@property (nonatomic) APMaxSessionTimeout maxSessionTimeout;
@property (nonatomic) APFlushInterval flushInterval;

@end

NS_ASSUME_NONNULL_END

