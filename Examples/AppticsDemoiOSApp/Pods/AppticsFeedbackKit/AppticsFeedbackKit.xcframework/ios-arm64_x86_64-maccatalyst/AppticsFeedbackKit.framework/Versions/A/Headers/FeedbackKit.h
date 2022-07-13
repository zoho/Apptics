//
//  ZBugReport.h
//  BugReporterTest
//
//  Created by Giridhar on 26/06/15.
//  Copyright (c) 2015 Giridhar. All rights reserved.
//



// Version : 0.7.6


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AppticsFeedbackKit/ZAPresenter.h>
#import <Apptics/APTheme.h>
#import <AppticsFeedbackKit/FKCustomHandler.h>
#import <MessageUI/MessageUI.h>
@class ZAIncludeLogConsent;
/**
 *  FeedbackKit is the class that you need to import to to use the shake to feedback system. Check out the properties and methods for more documentation.
 
 ## Important
 Your app should be registered to the JProxy service. If its not or if you aren't sure about it, contact samuthirapandian@zohocorp.com
 Once your app is registered, ask him for an API Key for your app.
 Make sure you set the Api key and App name (as registered in Janalytics)
 
 ## Change Log:
 * You will need to set the email address.
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackKit : NSObject<MFMailComposeViewControllerDelegate>



#pragma mark - Methods
/**
 *  Singleton Listener
 */
+(FeedbackKit* _Nonnull)listener;

/**
 *  Set this Method in your Reachabilty class. We'd want to send analytics data to our servers only when the internet is up.
 *  We didn't want to write another reachability class because we know you'd have one in your app. Make sure you set this because, if you dont set this, we assume you dont have wifi.
 *
 *  @param state NSInteger variable that sets the reachability via WiFi or WWAN
 */
-(void) setReachable : (NSInteger) state;


-(void) setMaskTextByDefault: (BOOL) alwaysOn;

/**
*  Set this true to mask the text detected in a screenshot by default. Setting to False will not mask by default but the user still can mask by tapping on individual text or By tapping on mask-all/unmask-all button.
*/


#pragma mark - Mandatory Properties


/**
 *  APIToken for accessing the app, this can be got by contacting JGarage
 */
@property (nonatomic, strong) NSString *apiToken;


#pragma mark - Other Important Properties

/**
 *  This is directly set by the developers
 */
@property (nonatomic, strong) NSString *toAddress;


/**
 *  This is directly set by the JGarage people, you need not set this
 */
@property (nonatomic, strong) NSString *emailAddress;


/**
 *  You need to specify the base url in case DC change is detected.
 
 */
@property (nonatomic, strong) NSString *baseUrl;

@property (nonatomic, strong) NSString *extensionAppGroup;

@property (nonatomic, strong) NSNumber *sessionStartTime;

@property (nonatomic, assign) BOOL isReachable;

@property (nonatomic, assign) BOOL reviewAndSendFeedback;

@property (nonatomic, strong) NSArray *diagnoInfo;

@property (strong,nonatomic) NSNumber *networkReachableStatus;
@property (nonatomic) NSInteger *networkReachableVia;

#pragma mark - Optional Properties


/**
 *  Points to the JProxy URL. You might want to change this for EU-DC
 */
@property (nonatomic,strong) NSString *jproxyURL;

/**
 *  Name of the app, you would not need this if you have a Authtoken
 */
//@property (nonatomic, assign) NSString *appName;



/**
 *  By default it uses the global app tint color, change if u want
 */
@property (nonatomic,strong) UIColor *defaultColor;


/**
 *  User cannot send feedback/bugreport unless he enters his emails. When this is not set, feedbacks and report still reach you, but you wouldn't know from whom the mail is coming from.
 */
@property (nonatomic,assign) BOOL isEmailIdCompulsory;

/**
 A bool value that says if the the app is listening to shakes or screenshots. Use the `enableMonitoring()` to set value to this property
 */
@property (nonatomic) BOOL maskText;

/**
 If set true, any text in the screenshot will be masked by default. Even if set ffalse still user can tap on text and mask it.
*/

@property (getter=isSwitchedOn, readonly) BOOL switchedOn;

@property (getter=isScreenShotSwitchedOn, readonly) BOOL screenShotSwitchedOn;

/**
 Assigns tolerance limit to show "Do not show this again" feature.
 A "Do not show this again" is shown in the alert after not choosing an any of the options in FeedbackKit (either shake or screenshot) after the assigned number of attempts.
 
 DETAIL: If you set tolerance limit as 2, and the user shakes the phone by mistake 2 times and he cancels alertview, from the third time, "Do not show this again" will be shown. Choosing Don't show this again  will switch off all the features of FeedbackKit and should be manually enabled again by the user. For this, you will need to include a switch to turn off and turn on FeedbackKit
 
 */
@property (nonatomic,assign) NSInteger maxToleranceLimit;


/**
 *  Success notification
 */
extern NSString *bSuccessNotification;

/**
 *  Failure notification
 */
extern NSString *bFailureNotification;

/**
 *  This Notification is called when the screen is closed, without making any report.
 */
extern NSString *bClosedScreenNotification;

/**
 *  Image upload success notification
 */
extern NSString *bImageUploadSuccessNotification;

/**
 *  Log upload success notification
 */
extern NSString *bLogUploadSuccessNotification;

/**
 *  Image upload failure notification
 */
extern NSString *bImageUploadFailureNotification;

/**
 *  Log upload failure notification
 */
extern NSString *bLogUploadFailureNotification;


#pragma mark - Deprecated

/**
 *  Setting this as true gets NSLogs and pushes to server. Not sure if you can use this for appstore build.
 */

@property (nonatomic,assign) BOOL shouldGetLogs;

/**
 Set theme color (nav bar, view bg color and title text color)
 */

-(void) setTheme : (id <APTheme> _Nonnull) theme;

/**
 Customize Analytics settings screen using this method.
 */

-(void) setSettingsTheme : (id <APSettingsTheme> _Nonnull) settingsTheme;

/**
 Customize Feedback settings screen using this method.
 */

-(void) setFeedbackTheme : (id <APFeedbackTheme> _Nonnull) feedbackTheme;

/**
 Get all types of completion handler in single place by extending our protocol.
 */

-(void) setCustomHandler:(id <FKCustomHandler> _Nonnull) handler;


#pragma mark - Public apis

/**
 *  Starts monitoring for getstures
 *
 *  @param shouldShake            detects for shake
 *  @param maxToleranceLimit Assigns tolerance limit to show "Do not show this again" feature.
 A "Do not show this again" is shown in the alert after not choosing an any of the options in FeedbackKit (either shake or screenshot) after the assigned number of attempts.

 DETAIL: If you set tolerance limit as 2, and the user shakes the phone by mistake 2 times and he cancels alertview, from the third time, "Do not show this again" will be shown. Choosing Don't show this again  will switch off all the features of FeedbackKit and should be manually enabled again by the user. For this, you will need to include a switch to turn off and turn on FeedbackKit
 */

+(void) startMonitoringWithShake:(BOOL)shouldShake maxToleranceLimit : (NSInteger) maxToleranceLimit;

/**
 Start monitoring features (shake and screenshot detection) of FeedbackKit.
 */

+(void)startMonitoring;

/**
 Start monitoring shake detection.
 */

+(void)startMonitoringShake;

///**
// Start monitoring screenshot detection.
// */
//
//+(void)startMonitoringScreenShot;

/**
 Stop monitoring both shake and screenshot detection temporarily.
 */

+(void)stopMonitoring;

/**
 Stop monitoring shake detection temporarily.
 */

+(void)stopMonitoringShake;

///**
// Stop monitoring screenshot detection temporarily.
// */
//
//+(void)stopMonitoringScreenShots;

/**
 Enable or disable monitoring status of shake detection.
 @param shouldMonitor BOOL
 */

+(void) enableMonitoringShake:(BOOL)shouldMonitor;

///**
// Enable or disable monitoring status of screenshot detection.
// @param shouldMonitor BOOL
// */
//
//+(void) enableMonitoringScreenShot:(BOOL)shouldMonitor;

/**
 Get monitoring status of shake detection.
 @return BOOL
 */

+(BOOL) monitoringStatusOfShake;

///**
// Get monitoring status of screenshot detection.
// @return BOOL
// */
//
//+(BOOL) monitoringStatusOfScreenShots;

/**
 Presents feedback screen
 */

+(void) showFeedback;

/**
 Presents help screen
 */

+(void) showHelpMe;

/**
 Presents feedback screen with top viewcontroller.
 */

+(void) showFeedback:(id _Nullable) viewController;

/**
 Presents help screen with top viewcontroller.
 */

+(void) showHelpMe:(id _Nullable) viewController;

/**
 Set diagnostic information in the format of dictionary @[@"key":@"<value>"] of array.
 */

+(void) setDiagnosticInfo : (NSArray<NSArray<NSDictionary*>*>* _Nonnull) info;

/**
 Send silent report with trace.
 */

+ (void) sendReportWithTrace:(NSString*_Nonnull) trace includeScreenName : (BOOL) includeScreenName includeLog : (BOOL) includeLog includeDignoInfo : (BOOL) includeDignoInfo tag : (NSString*_Nullable) tag;

/**
 Send silent report with trace and images.
 */

+ (void) sendReportWithTrace:(NSString*_Nonnull) trace andImages : (NSArray*_Nullable) images includeScreenName : (BOOL) includeScreenName includeLog : (BOOL) includeLog includeDignoInfo : (BOOL) includeDignoInfo tag : (NSString*_Nullable) tag;

/**
Set support email address to which the support emails will be sent from native email client.
*/

+ (void) setSupportEmailAddress:(NSString*_Nullable) email;

/**
Set sender email address to which the support emails will be sent from feedback screen.
*/

+ (void) setSenderEmailAddress:(NSString*_Nonnull) email;

+ (void) setFromEmailAddress:(NSString*_Nonnull) email __deprecated_msg("use setSenderEmailAddress method instead.");

+ (void) openNativeMailAppWithLogs : (BOOL) includeLogs diagnosticInfo : (BOOL) includeDiagnosticInfo viewController : (ZAIncludeLogConsent*) viewController;

+ (void) dismissViewController : (ZAIncludeLogConsent*) viewController;
/**
Set this true to mask the text detected in a screenshot by default. Setting to False will not mask by default but the user can still mask by tapping on individual text or By tapping on mask-all/unmask-all button.
*/

+ (void) setMaskTextByDefault: (BOOL) alwaysOn;
/**
 Shows a detailed page of what info is being sent to the server including device info, Diagnostic info and System logs.
 */

+ (void) showInfoBeforeSendingFeedbackToUser : (BOOL) status;

@end

NS_ASSUME_NONNULL_END
