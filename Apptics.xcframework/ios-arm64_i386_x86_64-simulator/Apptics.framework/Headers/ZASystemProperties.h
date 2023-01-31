//
//  ZASystemProperties.h
//  JAnalytics
//
//  Created by Giridhar on 23/01/17.
//  Copyright © 2017 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#endif
NS_ASSUME_NONNULL_BEGIN
@interface ZASystemProperties : NSObject
@property (strong,nonatomic) NSString *bundleID;
@property (strong,nonatomic) NSString *appVersion;
@property (strong,nonatomic) NSString *appReleaseVersion;
@property (strong,nonatomic) NSString *manufacturer;
@property (strong,nonatomic) NSString *os;
@property (strong,nonatomic) NSString *osVersion;
@property (strong,nonatomic) NSString *deviceType;
@property (strong,nonatomic) NSString *model;
@property (strong,nonatomic) NSString *currentRadioAccess;
@property (strong,nonatomic) NSString *mobileServiceProvider;
//@property (strong,nonatomic) NSString *batteryLevelAndState;
@property (strong,nonatomic) NSNumber *batterylevel;
@property (strong,nonatomic) NSString *timeZone;
@property (strong,nonatomic) NSNumber *networkReachableStatus;
@property (strong,nonatomic) NSString *udid;
@property (strong,nonatomic) NSNumber *phoneOrientation;
@property (strong,nonatomic) NSString *ram;
@property (strong,nonatomic) NSString *rom;
@property (strong,nonatomic) NSString *totalram;
@property (strong,nonatomic) NSString *totalrom;
@property (strong,nonatomic) NSNumber *screenWidth;
@property (strong,nonatomic) NSNumber *screenHeight;

@property (strong,nonatomic) NSString *appversionid;
@property (strong,nonatomic) NSString *appreleaseversionid;
@property (strong,nonatomic) NSString *platformid;
@property (strong,nonatomic) NSString *aaid;
@property (strong,nonatomic) NSString *apid;
@property (strong,nonatomic) NSString *mapid;
@property (strong,nonatomic) NSString *rsakey;
@property (strong,nonatomic) NSString *frameworkid;

#if TARGET_OS_IOS
@property (strong,nonatomic) CTTelephonyNetworkInfo *telephonyNetworkInfo;
#endif

+ (ZASystemProperties*) sharedInstance;
+ (NSDictionary*) allProperties;
+ (NSDictionary*) sessionProperties;
+ (NSDictionary*) deviceInfo;
+ (NSDictionary*) newDeviceInfo;
+ (NSDictionary* _Nullable) appMeta;
//+ (NSDictionary*) appMeta;
+ (NSString*) commonParams;
+ (NSDictionary*) deviceInfoV2;
+ (NSDictionary*) randomizeDeviceInfo;
+ (NSString*) libraryVersion;
+ (NSString*) getLogsDirPath;
+ (NSStringEncoding) getLogEncoding;
+ (NSString*) za_minimumOSVersion;
+ (NSArray *) allLogFiles;

@end
NS_ASSUME_NONNULL_END
