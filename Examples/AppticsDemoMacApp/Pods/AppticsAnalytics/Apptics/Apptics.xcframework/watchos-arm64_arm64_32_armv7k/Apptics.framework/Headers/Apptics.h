//
//  Apptics.h
//  JAnalytics
//
//  Created by Giridhar on 22/02/17.
//  Copyright © 2017 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/APBundle.h>
#import <Apptics/ZAEvent.h>
#import <Apptics/ZAEnums.h>
#import <Apptics/APTheme.h>
#import <Apptics/APLog.h>
#import <Apptics/Analytics.h>
#import <Apptics/APCustomHandler.h>
#import <Apptics/AppticsConfig.h>

#import <Apptics/ZAConstants.h>
#import <Apptics/ZASystemInfo.h>
#import <Apptics/ZANetworkUtils.h>
#import <Apptics/ZASystemProperties.h>
#import <Apptics/ZANetworking.h>
#import <Apptics/ZAObject.h>
#import <Apptics/ZAScreenObject.h>
#import <Apptics/ZAGlobalQueue.h>
#import <Apptics/ZAPIIManager.h>
#import <Apptics/ZAJSONString.h>

#import <Apptics/ZAFileManager.h>
#import <Apptics/NSUserDefaults+SaveCustomObject.h>

#import <Apptics/ZAFilters.h>
#import <Apptics/APJWTWrapper.h>
#import <Apptics/ZAAESCrypto.h>
#import <Apptics/NSData+APGunZip.h>
#import <Apptics/ZAKeyChainWrapper.h>

#import <Apptics/ZAPIManager.h>
#import <Apptics/APRateusObject.h>

#import <Apptics/APRemoteConfigObject.h>

#if TARGET_OS_OSX
#import <Apptics/ZAnalyticsNSApplication.h>
#endif

#if TARGET_OS_TV
#import <Apptics/ZACustomNavigationController.h>
#import <Apptics/ZAnalyticsUIApplication.h>
#endif

#if TARGET_OS_IOS
#import <Apptics/ZALoader.h>
#import <Apptics/ZACustomNavigationController.h>
#import <Apptics/ZAAppUpdateAlert.h>
#import <Apptics/ZAnalyticsUIApplication.h>
#import <Apptics/WCSessionSwizzlerDelegate.h>
#import <Apptics/ZACustomAlertController.h>
#import <Apptics/ZAUserConsentAlert.h>
#import <Apptics/APReviewViewController.h>
#endif

#if TARGET_OS_WATCH
#import <Apptics/WCSessionSwizzlerDelegate.h>
#endif

#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

#define APTrackError(args) AP_TrackError(__FILENAME__,__LINE__,__func__,"error",args);

#define APTrackException(args) AP_TrackException(__FILENAME__,__LINE__,__func__,"exception",args);

FOUNDATION_EXPORT double AppticsVersionNumber;

FOUNDATION_EXPORT const unsigned char AppticsVersionString[];
NS_ASSUME_NONNULL_BEGIN

/**
 *  Use this class to integrate Apptics with your app. It provides all the necessary functionality to collect and submit data to the Apptics servers.

 */
@interface Apptics : NSObject

#pragma mark — initialization

  /**
   *  This method will initialise the Apptics framework.
   *
   */
  
+ (void)initializeWithVerbose : (BOOL) verbose
#if TARGET_OS_IOS || TARGET_OS_OSX || TARGET_OS_TV
NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions")
#endif
;

/**
 *  This method call will perform initialisation of Apptics framework witih config.
 *
 */

+ (void)initializeWithVerbose : (BOOL) verbose config: (nonnull AppticsConfig *) config
#if TARGET_OS_IOS || TARGET_OS_OSX || TARGET_OS_TV
NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions")
#endif
;

#pragma mark — Developer Config apis
 
+ (void) setConfig:(nonnull AppticsConfig *) config;
    
/**
 
 This method should be called whenever a configuration change is made in order for those changes to be reflected in the App.

 */

+ (void) synchronizeConfig;

/**
 Enable automatic event tracking, it allows you to track key events in your application's lifecycle. This information can be used to improve your application's performance and stability.
 
 @param status boolean
 */

+ (void) enableAutomaticEventTracking:(BOOL) status;

/**
Enable or disable automatic session tracking using this method. This feature is usually enabled by default.
 
 @param status boolean
 */

+ (void) enableAutomaticSessionTracking:(BOOL) status;

/**
 Enable or disable automatic screen tracking using this method. This feature is usually enabled by default.
 
 @param status boolean
 */

+ (void) enableAutomaticScreenTracking:(BOOL) status;

/**
 Enable or disable automatic crash tracking using this method. This feature is usually enabled by default.
 
 @param status boolean
 */

+ (void) enableAutomaticCrashTracking:(BOOL) status;

/**
 This method allows you to include custom information with your crash report that can help you troubleshoot the issue.
 
 @param object any object that is conforms to JSON Encoding
 */

+ (void) setCrashCustomProperty:(nonnull NSDictionary*) object;

/**
 Enable background task to send the analytics data to the server when your app is in the background.
 
 @param status  BOOL
 */

+ (void) setEnableBackgroundTask:(BOOL) status API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(macos, watchos);


/**
 Enable the option to review the crash report before sending it.
 */
+ (void) enableReviewAndSendCrashReport : (BOOL) status API_AVAILABLE(ios(2.0));

/**
 
 Use the 'complete off' method to prevent Apptics from communicating with the server. This will pause Apptics activities while the user is consenting.

 */

+ (void) setCompleteOff:(BOOL) status;
   
#pragma mark - Device consent

/**
 *  Returns an enum of privacy status:
 *  TrackingAuthOff=-2
 *  Unknown=-1
 *  UnAuthorized=0
 *  Authorized=1
 */

+(APPrivacyStatus) getPrivacyStatus;

/**
 *  This method will show the user the privacy options that are built into the Apptics SDK.
 */
+ (void) showPrivacyConsent;

/**
 *  This method will displays in built privacy concern on top of the viewcontroller passed.
 */

+ (void) showPrivacyConsent : (id _Nullable) viewController;

/**
 *  This method clears all user info from the app, including cached data and preferences.
 *
 *  - Warning:
 *  This method should not be called in a production environment.
 */

+ (void) resetConsentPreference;
    
#pragma mark — Flush

/**
 *  This will clear all stored data on your device without sending any information to the server.
 */

+ (void) reset;

/**
 *  Flushes all events that have been tracked so far to the server right away. You might typically want to use this when the user is going to log out, or pretty much whenever you need it.
 */

+ (void) flush;

#pragma mark — Non-fatals apis

/**
 Use this method to track any NSError:

 @param error Error.
 */

void AP_TrackError(const char *file, int lineNumber, const char *functionName,const char *type, NSError *error,...);

/**
 Use this method to track any NSException.
 
 @param exception A handled exception
 */

void AP_TrackException(const char *file, int lineNumber, const char *functionName,const char *type, NSException *exception,...);

#pragma mark — User apis

/**
 Log the user signup to see how many users have signed up from your app
 
 @param userID String
 */

+ (void) trackSignUp:(NSString* _Nullable)userID NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions");

/**
 Log the user login to see how many users have logged in to your app
 
 @param userID String
 */

+ (void) trackLogIn:(NSString* _Nullable)userID NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions");

/**
 Log the user out to see how many users have logged out to your app.
 
 @param userID String.
 */

+ (void) trackLogOut:(NSString* _Nullable)userID NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions");

/**
 Log the user signup along with the group id.
 @param userID String, groupID String
 */

+ (void) trackSignUp:(NSString* _Nullable)userID groupId : (NSString*_Nullable)groupID NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions");

/**
 Log the user login along with the group id.
 @param userID String, groupID String
 */

+ (void) trackLogIn:(NSString* _Nullable)userID groupId : (NSString*_Nullable)groupID NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions");

/**
 Log the user logout along with the group id.
 
 @param userID String, groupID String
 */

+ (void) trackLogOut:(NSString* _Nullable)userID groupId : (NSString*_Nullable)groupID NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions");

/**
 Specify a user identifier which will be used to identify the user in the future. We recommend you use a unique userID.
 
 - Warning:
 To protect users privacy, please do not pass any personally identifiable information to this method.
 
 @param userID String
 */

+ (void) setCurrentUser:(NSString * _Nullable)userID NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions");


/**
 Specify a user identifier along with the group id.
 
 @param userID String
 @param groupID String
 */

+ (void) setCurrentUser:(NSString * _Nullable)userID groupId : (NSString*_Nullable)groupID NS_EXTENSION_UNAVAILABLE("don't use this method in your extensions");


#pragma mark — Settings apis

#if !TARGET_OS_OSX && !TARGET_OS_WATCH

/**
 This method opens the screen where the user can change their analytic privacy settings.
 */

+ (void) openAnalyticSettingsController;

/**
 This method opens the analytic privacy settings on top of the view controller passed.
 */

+ (void) openAnalyticSettingsController : (id _Nullable) viewController ;


/**
 Returns the analytic privacy settings screen which allows user to change their settings for how the data is collected and used.
 @return AnalyticsSettingsViewController.
 */

+(id _Nonnull) getAnalyticSettingsController;

#endif

#if TARGET_OS_OSX

/**
 Present the screen which allows the user to change their analytic privacy settings.
 */

+ (void) openPIIManagerController_macOS;

#endif

/**
 Returns the status of data tracking for the current user.
 
 @return YES if enabled else NO.
 */

+ (BOOL) trackingStatus;

/**
 Data tracking can be enabled or disabled for the current user using this method.
 
 @param status boolean
 */

+ (void) setTrackingStatus : (BOOL) status;

/**
 Returns the status of crash tracking for the current user.
 
 @return YES if enabled else NO.
 */

+ (BOOL) crashReportStatus;

/**
 This method can be used to enable or disable crash tracking for the current user. If crash tracking is disabled, a consent message will be displayed asking the user if they wish to share the crash report.
 
 @param status boolean
 */

+ (void) setCrashReportStatus : (BOOL) status;

/**
 Returns the status of sending personalized data, which includes the user's ID and usage data for the current user.
 
 @return YES if enabled else NO.
 */

+ (BOOL) personalInfoTrackingStatus;

/**
 Update status of tracking data with userID for the current user.
 
 @param status boolean
 */

+ (void) setPersonalInfoTrackingStatus : (BOOL) status;

/**
 Returns the logged-in status of the user associated with the device.
 
 @return YES if logged in else NO.
 */

+ (BOOL) isUserLoggedIn;

/**
 Data will be sent to the Apptics servers using mobile data if this method is turned on.
 
 @param sendData boolean
 */

+ (void) setSendAnalyticsDataUsingMobileData : (BOOL) sendData;

/**
 Returns the status of sending data to a server over a mobile data connection.
 */
 
+ (BOOL) sendAnalyticsDataUsingMobileData;


#pragma mark — Callbacks

/**
 When the user consent prompt is presented, you will be notified in this block.
 
 @param userConsentPresentCompletionBlock userConsentPresentCompletionBlock.
 */

+(void) setUserConsentPresentCompletionHandler : (UserConsentPresentCompletionBlock _Nullable ) userConsentPresentCompletionBlock;

/**
 When the user consent prompt is dismissed, you will be notified in this block.
 
 @param userConsentDismissCompletionBlock userConsentDismissCompletionBlock.
 */

+(void) setUserConsentDismissCompletionHandler : (UserConsentDismissCompletionBlock _Nullable ) userConsentDismissCompletionBlock;

/**
 When the user crash prompt is dismissed, you will be notified in this block.
 
 @param crashConsentDismissCompletionBlock crashConsentDismissCompletionBlock.
 */

+(void) setCrashConsentDismissCompletionHandler : (CrashConsentDismissCompletionBlock _Nullable ) crashConsentDismissCompletionBlock;

#pragma mark — Localization apis
/**
 This method returns the localized string for a given key. The keys are defined in the AppticsLocalizable.strings file.
 
 @param key String.
 */

+ (NSString*_Nullable) getLocalizableStringForKey : (NSString*_Nonnull) key;

/**
 Use this method to set the language for the Analytics SDK. If the language is not found in the resource bundle, the default language will be selected.
 
 @param lang (code) String.
 */

+ (void) setDefaultLanguage : (NSString*_Nonnull) lang;


/**
 Use this method to update the current location of the user.
 
 @param location (code or name) String.
 */

+ (void) setCurrentLocation : (NSString*_Nonnull) location;

#pragma mark — Themes api
#if !TARGET_OS_WATCH
/**
 Customize the (nav bar, view bg color and title text color) of Apptics screens to match the style of your applications by implementing the methods of APTheme.
 */

+(void) setTheme : (id <APTheme> _Nonnull) theme;

/**
 Customize the Analytics settings screen to match the style of your applications by implementing the methods of APSettingsTheme.
 */

+(void) setSettingsTheme : (id <APSettingsTheme> _Nonnull) settingsTheme;

/**
 Customize the screens of Feedback  module to match the style of your applications by implementing the methods of APFeedbackTheme.
 */
+(void) setFeedbackTheme : (id <APFeedbackTheme> _Nonnull) feedbackTheme;

/**
 Customize the IncludeLogConsent screen of Feedback module to match the style of your applications by implementing the methods of APFeedbackPrivacyTheme.
 */
+(void) setFeedbackPrivacyTheme : (id <APFeedbackPrivacyTheme> _Nonnull) feedbackPrivacyTheme;

/**
 Customize the user consent screens to match the style of your applications by implementing the methods of APUserConsentTheme.
 */

+(void) setUserConsentTheme : (id <APUserConsentTheme> _Nonnull) userConsentTheme;

/**
 Customize the In-App-Update screen to match the style of your applications by implementing the methods of APUserConsentTheme.
 */

+(void) setAppUpdateConsentTheme : (id <APAppUpdateConsentTheme> _Nonnull) appUpdateConsentTheme;

/**
 You can get all types of completion handlers in a single place by extending APCustomHandler protocol. This way, you can have all the information you need in one place, making it easier to manage and keep track of.
 */

+(void) setCustomHandler:(id <APCustomHandler> _Nonnull) handler;

/**
 Choose the privacy consent screen that better suits your app.
 */

+ (void) setPrivacyConsentType:(ZAPrivacyConsentType)privacyConsentType;

#endif

/**
Choose the type of tracking you want to have for your app, depending on the type of tracking chosen, the option to track anonymously will be shown in the user consent.
 @param type BOOL
*/

+ (void) setTypeOfAnonymity : (APAnonymousType) type;

#pragma mark — App Update apis

/**

After initializing Apptics, call this method to enable auto check for updates.
@param status BOOL
*/

//+ (void) enableAutoCheckForAppUpdate : (BOOL) status;

#pragma mark — Crash

/**
 This method can be used to simulate the crash for testing the crash module.
 */

+ (void) crash;

#pragma mark - Cross Promotional Apps

/**
 Use this methodtTo enable cross promotion in your app, go to the Apptics web, select your app, Under Promotions, select the apps you want to promote, and click Save.
 */

+(void) enableCrossPromotionAppsList : (bool) status API_UNAVAILABLE(macos, tvos, watchos);

#pragma mark - Reachability

/**
 Returns the reachability status of a the network connection.
 */
+(BOOL)isReachable;

@end
NS_ASSUME_NONNULL_END
