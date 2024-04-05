//
//  ZAConstants.h
//  JAnalytics
//
//  Created by Giridhar on 08/11/16.
//  Copyright Â© 2016 zoho. All rights reserved.
//

#ifndef ZAConstants_h
#define ZAConstants_h
#define UIAPPLICATION_ACCESS (TARGET_OS_IOS || TARGET_OS_TV)

#define UIKIT_ACCESS (TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH)
//(!TARGET_OS_OSX && (TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH))

#define APP_LIFECYCLE_SUPPORT (defined(IS_IOS) || defined(IS_TVOS) || defined(IS_MACOS))

#define NSLocalizedStringForZAnalytics(key,comment,tbl) \
[[[APBundle getInstance] getAnalyticLanguageBundle] localizedStringForKey:(key) value:@"" table:(tbl)]

#define ZAnalyticsLocalizedString(x) NSLocalizedStringForZAnalytics(x, @"", @"ZAnalyticsLocalizable")

#define AppticsLocalizedString(key, value) (value != nil && ![value isEqualToString:@""]) ? value : NSLocalizedStringForZAnalytics(key, @"", @"ZAnalyticsLocalizable")


static NSString *kJA_Lang_Change_flag = @"ap_Lang_Change_flag";


static NSString *kJA_UserProperties = @"ja_userproperties";
static NSString *kJA_FirstTimeInstallation = @"kJA_FirstTimeInstallation";
static NSString *kJA_BeginningOfTheDay = @"kJA_BeginningOfTheDay";
static NSString *kJA_ServerTimeZone = @"kJA_ServerTimeZone";
static NSString *kJA_Migration1 = @"kJA_Migration1";
static NSString * kJA_UserEmail = @"ja_userpropertyEmail";

static NSString  *kJA_DCLPrefix = @"ja-dclPfx";

static NSString * kJA_is_pfx = @"ja-is_pfx";

static NSString * kJA_dclBD = @"ja-dclBD";
static NSString * kJA_OsVersion = @"osVersion";
static NSString * kJA_updateVersion = @"updateVersion";

static NSString * kJA_SuccessStringInJSON = @"success";

static NSString *k_version_forFile = @"v2";

static NSString * kJA_BaseURLDomain = @"apptics";

static NSString * kJU_UpdateId         = @"kJU_UpdateId";
static NSString * kJU_PreviousAppVersion         = @"kJU_PreviousAppVersion";
static NSString * kJU_PreviousAppReleaseVersion         = @"kJU_PreviousAppReleaseVersion";
static NSString * kJU_SkipThisAppVersion         = @"kJU_SkipThisAppVersion";

static NSString * kJA_RegisteredDeviceId = @"kJA_RegisteredDeviceId";
static NSString * kJA_RegisteredApDeviceInfo = @"kJA_RegisteredApDeviceInfo";
//static NSString * kJA_RegisteredUpdatedTime = @"kJA_RegisteredUpdatedTime";

static NSString * kJA_AnalyticUserId = @"kJA_AnalyticUserId";
static NSString * kJA_AnalyticGroupId = @"kJA_AnalyticGroupId";
static NSString * kJA_Default = @"default";
static NSString * kJA_DefaultDc = @"com";
static NSString * kJA_MamDc = @"kJA_MamDc";
static NSString * kJA_Mam = @"kJA_Mam";
static NSString * kJA_OrgID = @"kJA_OrgID";
static NSString * kJA_MamKey = @"kJA_MamKey";
static NSString * kJA_MamInfo = @"kJA_MamInfo";
static NSString * kJA_UserIds = @"kJA_UserIds";
static NSString * kJA_UserGroupIds = @"kJA_UserGroupIds";
static NSString * kJA_MamPIIInfo = @"kJA_MamPIIInfo";
static NSString * kJA_MamDCInfo = @"kJA_MamDCInfo";
static NSString * kJA_MamTrackingInfo = @"kJA_MamTrackingInfo";
static NSString * kJA_MamCrashInfo = @"kJA_MamCrashInfo";
static NSString * kJA_MamLogInfo = @"kJA_MamLogInfo";
static NSString * kJA_CrashReportPermissionStatus = @"kJA_CrashReportPermissionStatus";
static NSString * kJA_CrashReportStatus = @"kJA_CrashReportStatus";
static NSString * kJA_ShouldCollectCustomProps = @"kJA_ShouldCollectCustomProps";

static NSString * kJA_SecretKey = @"1234567890123456";
static NSString * kJA_DeviceInfo = @"kJA_DeviceInfo";
static NSString * kJA_DeviceUUID = @"kJA_DeviceUUID";
static NSString * kJA_TrackingStatus = @"kJA_TrackingStatus";
static NSString * kJA_KeychainItems = @"kJA_KeychainItems";

// URL Paths
//The string over here is the same as the API ENDPOINT

static NSString * k_url_addScreens = @"addscreenviews";

static const NSUInteger k_ja_batchSize = 50;
static const NSUInteger k_ja_batchUpperLimit = 10;

static NSString * kJA_GroupTypeApplicationLifeCycle = @"app_life_cycle";
static NSString * kJA_GroupTypeUserLifeCycle = @"user_life_cycle";
static NSString * kJA_GroupTypeApplication = @"application";
static NSString * kJA_GroupTypeOthers = @"others";

static NSString * kJA_EventTypeAppInstall = @"app_install";
static NSString * kJA_EventTypeAppUpdate = @"app_update";
static NSString * kJA_EventTypeAppCracked = @"app_cracked";
static NSString * kJA_EventTypeAppOpen = @"app_open";
static NSString * kJA_EventTypeAppFirstOpen = @"app_first_open";
static NSString * kJA_EventTypeAppClearData = @"app_clear_data";
static NSString * kJA_EventTypeAppForeground = @"app_foreground";
static NSString * kJA_EventTypeAppBackground = @"app_background";
static NSString * kJA_EventTypeAppTerminate = @"app_terminate";
static NSString * kJA_EventTypeAppOutOfMemory = @"app_out_of_memory";

static NSString * kJA_EventTypeUserSignup = @"user_signup";
static NSString * kJA_EventTypeUserLogin = @"user_login";
static NSString * kJA_EventTypeUserLogout = @"user_logout";

static NSString * kJA_EventTypeDynamicLinkOpen = @"dynamic_link_open";
static NSString * kJA_EventTypeDynamicLinkFirstOpen = @"dynamic_link_first_open";

static NSString * kJA_EventTypeNotificationAuthorizationStatus = @"notification_authorization_status";
static NSString * kJA_EventTypeNotificationReceive = @"notification_receive";
static NSString * kJA_EventTypeNotificationOpen = @"notification_open";
static NSString * kJA_EventTypeNotificationDismiss = @"notification_dismiss";
static NSString * kJA_EventTypeNotificationForeground = @"notification_foreground";
static NSString * kJA_EventTypeSearch = @"search";
static NSString * kJA_EventTypeShare = @"share";

static NSString * kJA_EventTypeBatteryLow = @"battery_low";
static NSString * kJA_EventTypeBatteryFull = @"battery_full";
static NSString * kJA_EventTypeLowPowerModeOn = @"low_power_mode_on";
static NSString * kJA_EventTypeLowPowerModeOff = @"low_power_mode_off";

static NSString * kJA_EventTypeNetworkReachabilityChange = @"network_reachability_change";
static NSString * kJA_EventTypeNetworkBandwidthChange = @"network_bandwidth_change";
static NSString * kJA_EventTypeOsUpdate = @"os_update";
static NSString * kJA_EventTypeOsUnsupported = @"os_unsupported";
static NSString * kJA_EventTypeSwitchTheme = @"switch_theme";

static NSString * kJA_tracking = @"tracking";
static NSString * kJA_personalized = @"personalized";
static NSString * kJA_sendcrash = @"sendcrash";
static NSString * kJA_sendlog = @"sendlog";
static NSString * kJA_tracking_on = @"tracking_on";
static NSString * kJA_tracking_off = @"tracking_off";
static NSString * kJA_personalized_on = @"personalized_on";
static NSString * kJA_personalized_off = @"personalized_off";
static NSString * kJA_sendcrash_on = @"sendcrash_on";
static NSString * kJA_sendcrash_off = @"sendcrash_off";
static NSString * kJA_sendlog_on = @"sendlog_on";
static NSString * kJA_sendlog_off = @"sendlog_off";


static NSString * JUDefaultSkippedVersion         = @"JUDefaultSkippedVersion";
static NSString * JUDefaultReminderCheckDate = @"JUDefaultReminderCheckDate";
static NSString * JUDefaultRemindedCount = @"JUDefaultRemindedCount";
static NSString * JUDefaultPreviousOpt = @"JUDefaultPreviousOpt";

//static NSString * JUActionTitleDownload = @"Update Now";
//static NSString * JUActionTitleLater = @"Remind Me Later";
//static NSString * JUActionTitleIgnore = @"Skip";
static NSString * JUActionTitleFeedback = @"Feedback";

static NSString * JUActionContinue = @"continue";
static NSString * JUActionImpression = @"impression";
static NSString * JUActionDownload = @"download";
static NSString * JUActionLater = @"later";
static NSString * JUActionIgnore = @"ignore";
static NSString * JUActionUpdated = @"updated";

static NSString * kJA_sessionHit = @"kJA_sessionHit";
static NSString * kJA_eventHit = @"kJA_eventHit";
static NSString * kJA_screenHit = @"kJA_screenHit";

static NSString * KJA_canSendDataInMobileData = @"KJA_canSendDataInMobileData";
static NSString * KJA_canSendDataInMobileDataOn = @"KJA_canSendDataInMobileData_On";
static NSString * KJA_canSendDataInMobileDataOff = @"KJA_canSendDataInMobileData_Off";
static NSString * KJA_canSendDataByDefault = @"KJA_canSendDataByDefault";

static NSString * kJA_autoReviewAttempt = @"kJA_autoReviewAttempt";
static NSString * kJA_autoReviewImpressionLimit = @"kJA_autoReviewImpressionLimit";
static NSString * kJA_autoPromptedDate = @"kJA_autoPromptedDate";
static NSString * kJA_promoted_apps = @"promotedApps";

extern unsigned long long const APLogMaxFileSize;
extern NSUInteger         const APLogMaxNumLogFiles;

typedef void (*ZACrashPostCrashSignalCallback)(void *context);

typedef struct ZACrashCallback {
  void *context;
  ZACrashPostCrashSignalCallback handleSignal;
} ZACrashCallback;

static ZACrashCallback zaCrashCallback = {.context = NULL, .handleSignal = NULL};

#endif /* ZAConstants_h */

