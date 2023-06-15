//
//  ZAEnums.h
//  JAnalytics
//
//  Created by Giridhar on 27/02/17.
//  Copyright © 2017 zoho. All rights reserved.
//

#ifndef ZAEnums_h
#define ZAEnums_h



/**
 Specifies the Build type. You usually need not set this. This is used for Building URL and sending it to Zoho, localzoho or pre servers.
*/
typedef NS_ENUM(NSInteger, JBuildType)
{
    /**
     *  Points to local server. apptics.localzoho.com. You need to be connected to Zoho-Handhelds or ZohoCorp wifi to push data to this server
     */
    Local = 0,
    /**
     *  Points to live servers, use this mode when app goes live. Points to apptics.zoho.com
     */
    Live,
    /**
     *  Points to pre server, preapptics.zoho.com
     */
    Pre,
};

typedef NS_ENUM(NSInteger, JURLPath)
{
  JURLPathScreens = 1337,
//  JURLPathEvents,
//  JURLPathSession,
//  JURLPathRequests,
  JURLPathRegisterUser,
  JURLPathCrash,
//  JURLPathDeviceInfo,
//  JURLPathEvents_Log,
//  JURLPathSession_history,
//  JURLPathCurrentSession_History,
  JURLPathNonFatalErrors,
  JURLPathConsoleLogs,
//  JURLPathUpdateInfo,
//  JURLPathUpdateStats,
  JURLPathUnRegisterUser,
  JURLPathRegisterDevice,
  JURLPathRegisterAnonId,
//  JURLPathUpdateDeviceInfo,
//  JURLPathUpdateOptStatus,
//  JURLPathUpdateTrackingStatus,
//  JURLPathRateUs,
//  JURLPathMapdcdeviceid,
//  JURLPathSyncRateUsInfo,
  JURLPathSyncApiCriteriaInfo,
//  JURLPathSyncRemoteConfigInfo,
  JURLPathGetPromotionalApps,
  JURLPathCrossPromoStats,
  JURLPathEngagementsData,
  JURLPathUpdatesForModules,
  JURLPathRegisterUserWithOrg,
  JURLPathUnRegisterUserWithOrg,
  JURLPathUpdateDevicePreference,
  JURLPathDefault
};

typedef NS_ENUM(NSInteger, JAStatus)
{
  JAStatusSuccess = 2000,
  JAStatusInvalidApiToken = 3000,
  JAStatusInvalidApp = 3001,
  JAStatusJsonNull = 3002,
  JAStatusOtherExcep = 3003,
  JAStatusInvalidDeviceId = 3004,
  JAStatusJsonExcep = 3005,
  JAStatusInvalidUser = 3006,
};

static NSString* const kApstatusSuccess = @"success";
static NSString* const kApstatusFailure = @"failure";

typedef NS_ENUM(NSInteger, APTrackingStatus)
{
  APTrackingStatusOff = 0,
  APTrackingStatusOn
};

typedef NS_ENUM(NSInteger, APCrashStatus)
{
  APCrashStatusOff = 0,
  APCrashStatusOn
};

typedef NS_ENUM(NSInteger, APLogStatus)
{
  APLogStatusOff = 0,
  APLogStatusOn
};

typedef NS_ENUM(NSInteger, APPrivacyStatus)
{
  APPrivacyStatusTrackingAuthOff = -2,
  APPrivacyStatusUnknown,//New user
  APPrivacyStatusUnAuthorized,//User decided to opt-out
  APPrivacyStatusAuthorized//User opted-in
};

typedef NS_ENUM(NSInteger, ZAPrivacyStatus)
{
  ZAPrivacyStatusTrackingAuthOff = -2,
  ZAPrivacyStatusUnknown,//New user
  ZAPrivacyStatusUnAuthorized,//User decided to opt-out
  ZAPrivacyStatusAuthorized//User opted-in
};

typedef NS_ENUM(NSInteger, JRateUsAction)
{
  JRateUsActionCancel = -1,
  JRateUsActionSendFeedback,
  JRateUsActionRateOnStore
};

typedef NS_ENUM(NSInteger, JRateUsType)
{
  JRateUsTypePopup1 = 1,
  JRateUsTypePopup2
};

typedef NS_ENUM(NSInteger, JRateUsSource)
{
  JRateUsSourceAuto = 1,
  JRateUsSourceManual
};

typedef NS_ENUM(NSInteger, JAUserStatus)
{
  JAUserStatusAuthorized = 0,
  JAUserStatusUnAuthorized,
  JAUserStatusDontTrack
};

typedef NS_ENUM(NSInteger, CrashPreferenceType) // Crash Authorization Result Type
{
  CrashPreferenceTypeAlwaysSend = 0,
  CrashPreferenceTypeSendNow,
  CrashPreferenceTypeNotNow,
  CrashPreferenceTypeNeverAsk
};

typedef void (^UserConsentPresentCompletionBlock) (bool status, NSError* error);

typedef void (^UserConsentDismissCompletionBlock) (int status);

typedef void (^CrashConsentDismissCompletionBlock) (int status);

#pragma mark - BugSquashKit

typedef NS_ENUM(NSInteger, ZBFeedbackType)
{
  ZBFeedbackTypeScreenshot = 0,
  ZBFeedbackTypeFeedbackOnly,
  ZBFeedbackTypeHelpMe,
  ZBFeedbackTypeReport
};

typedef NS_ENUM(NSInteger, ZBActionType)
{
  ZBActionTypeShake = 0,
  ZBActionTypeSettings
};

#endif /* ZAEnums_h */

typedef NS_ENUM(NSInteger, ZAAlertType)
{
  ZAAlertTypeUserConsent1 = 0,
  ZAAlertTypeUserConsent2,
  ZAAlertTypeAppUpdate,
  ZAAlertTypeWhatsNew
};

typedef NS_ENUM(NSInteger, ZAPrivacyConsentType)
{
  ZAPrivacyConsentType1 = 0,
  ZAPrivacyConsentType2
};


typedef NS_ENUM(NSUInteger, ZUAlertType)
{
  ZUAlertTypeIgnore = 1,   // Presents User with option to download the app now, remind him/her later, or to skip/ignore this version all together
  ZUAlertTypeRemind,       // Presents user with option to update app now or at next launch
    ZUAlertTypeForceUpdate,        // Customize the app update to your app
  ZUAlertTypeNone          // Don't show the alert type , useful for skipping Patch, Minor, Major updates
};

typedef NS_ENUM(NSUInteger, ZAUpdateAction)
{
  ZAUpdateActionImpression = 1,
  ZAUpdateActionDownload,
  ZAUpdateActionLater,
  ZAUpdateActionIgnore
};

typedef NS_ENUM(NSUInteger, ZUButtonType)
{
  ZUButtonTypeDownload = 1,   // Download now
  ZUButtonTypeRemind,       // Remind me later
  ZUTapTypeIgnore,        // Ignore this version
  
};

/**
 *  Log levels are used to print and push the levels of logs to the server.
 */

typedef NS_ENUM(NSUInteger, APLogLevel){
  APLogLevelOff       = 0,
  APLogLevelVerbose,
  APLogLevelDebug,
  APLogLevelInfo,
  APLogLevelWarning,
  APLogLevelError,
  APLogLevelAll
};


typedef NS_ENUM(NSInteger, APAnonymousType)
{
    APAnonymousTypeNone = 0,
    APAnonymousTypePseudoAnonymous
//    APAnonymousTypeFullyAnonymous
};

typedef NS_ENUM(NSUInteger, APLogPrivacy){
    APLogPrivacyPublic       = 0,
    APLogPrivacyPrivate,
    APLogPrivacyPrivateMask,
    APLogPrivacySensitive,
    APLogPrivacySensitiveMask    
};

typedef NS_ENUM(NSInteger, APDeviceIdentifierType)
{
    APDeviceIdentifierTypeVendorId = 0,
    APDeviceIdentifierTypeRandomId
};
