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
// atomic: written from async system callbacks (CoreTelephony radio/carrier change)
// while read concurrently from other queues (e.g. newDeviceInfo on the remote-config
// queue). nonatomic getters don't retain, so a concurrent setter releasing the old
// value leaves the reader with a dangling pointer -> EXC_BAD_ACCESS. atomic getters
// retain+autorelease (objc_getProperty), making concurrent read/write safe.
@property (strong,atomic) NSString *currentRadioAccess;
@property (strong,atomic) NSString *mobileServiceProvider;
//@property (strong,nonatomic) NSString *batteryLevelAndState;
@property (strong,atomic) NSNumber *batterylevel;
@property (strong,nonatomic) NSString *timeZone;
@property (strong,nonatomic) NSNumber *networkReachableStatus;
@property (strong,nonatomic) NSString *udid;
@property (strong,atomic) NSNumber *phoneOrientation;
@property (strong,nonatomic) NSString *ram;
@property (strong,nonatomic) NSString *rom;
@property (strong,nonatomic) NSString *totalram;
@property (strong,nonatomic) NSString *totalrom;
@property (strong,nonatomic) NSNumber *screenWidth;
@property (strong,nonatomic) NSNumber *screenHeight;
@property BOOL regappAddVersionInprogress;
@property (nonatomic, strong) NSMutableArray *app_AddVersionSuccessblocks;

@property (strong,nonatomic) NSString *appversionid;
@property (strong,nonatomic) NSString *appreleaseversionid;
@property (strong,nonatomic) NSString *platformid;
@property (strong,nonatomic) NSString *aaid;
@property (strong,nonatomic) NSString *apid;
@property (strong,nonatomic) NSString *mapid;
@property (strong,nonatomic) NSString *rsakey;
@property (strong,nonatomic) NSString *frameworkid;
@property (strong,nonatomic)NSString *portalid;
@property (strong,nonatomic)NSString *projectid;




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

+ (void)getAppVersionIDWithSuccess:(void (^)(NSString *appVersionID))success
                           failure:(void (^)(NSError *error))failure;

//-(void) executeRequestSuccessCallbacksWithResponseForAppVersion:(NSDictionary*) userInfo;
- (void)executeRequestSuccessCallbacksWithResponseForAppVersion:(NSString *)appVersionId;
@property (nonatomic, strong) NSMutableArray *regUserSuccessblocks;


+ (void)makeAddAppVersionCallWithSuccess:(void (^)(NSString *appVersionID))success
                                 failure:(void (^)(NSError *error))failure;


@end
NS_ASSUME_NONNULL_END
