//
//  ZASystemInfo.h
//  JAnalytics
//
//  Created by Giridhar on 14/04/16.
//  Copyright © 2016 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@class NSHost;
NS_ASSUME_NONNULL_BEGIN
@interface ZASystemInfo : NSObject

+ (NSString*) getTimeZoneAbbrivation;
+ (NSString*) getUUID;
+ (NSString*) getServiceProvider;
+ (NSString*) getEdgeType;
+ (NSString*) getCurrentRadio;
+ (NSString*) getCurrentCarrier;
+ (NSString*) getOsVersion;
+ (NSString*) getBundleID;
+ (NSString*) getAppName;
+ (NSString*) getBuildNumber;
+ (NSString*) getAppVersion;
+ (NSNumber*) getBatteryLevel;
+ (NSNumber*) updateBatteryLevelAndState;
+ (CGFloat) getScreenWidth;
+ (CGFloat) getScreenHeight;
#if TARGET_OS_WATCH
+ (NSString*) getDeviceModel;
#endif
+ (NSString*) getDeviceModelName;
+ (NSString*) getSystemLanguage;
+ (NSString*) getSystemCurrency;
+ (NSString*) getTime;
+ (long long) getBeginingTimeinLong;
+ (NSDate *) beginningOfDay:(NSDate *)date;

+ (BOOL) isAppInBackground;

+ (float) getScreenBrightness;
+ (BOOL) isMultitaskingEnabled;

//#if !TARGET_OS_OSX
//+ (UIViewController*) getTopMostController;
//+ (UIViewController*) topVisibleViewController : (UIViewController*) topController;
//#else
//+ (NSViewController*) getTopMostController;
//+ (NSViewController*) topVisibleViewController : (NSViewController*) topController;
//#endif
+ (NSNumber*) getOrientation;
+ (NSNumber*) getSystemOrientation;

+ (NSString*) getDiskSpace;
+ (NSString*) getTotalDiskSpace;

+ (NSString*) getSystemName;
+ (NSString*) getOSType;
+ (NSString*) getOSDesc;

//+(UIViewController*) topVisibleViewController : (UIViewController*) topController;
+ (long long) getTimeinLong;
+ (long long) getTimeinLong:(NSDate *)date;

+ (BOOL) isDebug;

+(NSString*) getDeviceType;
+(NSString*) getRam;
+(NSString*) getTotalRam;
@end

@interface APDeviceInfo : NSObject

@property (nonatomic, retain) NSString*regDeviceId;//Registered Device Id

@property (nonatomic, retain, nullable) NSString*anonymousid;//Registered Anonymous Id

@property (nonatomic, retain) NSNumber*devicetypeid;//Registered Device Type Id

@property (nonatomic, retain) NSNumber*modelid;//Registered Device Model Id

@property (nonatomic, retain) NSNumber*osversionid;//Registered Device OS Version Id

@property (nonatomic, retain) NSNumber*timezoneid;

@property (nonatomic) NSNumber *regDeviceUpdatedTime;

+(APDeviceInfo*) defaultInfo;

+(instancetype) initWithDictionary:(NSDictionary*) deviceInfo;

- (void) updateDeviceInfo:(NSDictionary*) _deviceInfo;

- (NSDictionary*)jsonify;

- (NSDictionary*)jsonifyAnonymousInfo;

@end
NS_ASSUME_NONNULL_END
