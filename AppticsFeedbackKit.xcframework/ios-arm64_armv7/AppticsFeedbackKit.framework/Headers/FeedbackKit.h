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
#import "ZAArrowCanvasView.h"
#import "ZADragBlurView.h"
#import "FeedbackDiagosticInfo.h"

@class ZAIncludeLogConsent;
/**
 * The FeedbackKit class allows you to use the features of the Feedback module. Check out the properties and methods for more documentation.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackKit : NSObject<MFMailComposeViewControllerDelegate>

#pragma mark - Public apis

/**
 *  :nodoc: Initializes an instance of the FeedbackKit
 */
 +(FeedbackKit* _Nonnull)listener;

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

+(void) setDiagnosticInfo : (NSArray<NSArray<NSDictionary*>*>* _Nonnull) info __deprecated_msg("use setDiagnosticInfoDict method instead.");;

/**
 Set diagnostic information in the format of dictionary [@"key":@"value"]
 */

+(void) setDiagnosticInfoObject : (FeedbackDiagosticInfo* _Nonnull) diagnosticInfo;

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

+ (void) enableAnonymousUserAlert:(BOOL)status;
+ (void) reducedTransparencyStatus:(BOOL) status;

    
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

/**
 Set body text of the message, this method prefills the body content of feedback controller.
 */

+ (void) setMessageBody : (NSString*) messageBody;
  
#pragma mark - Apis to custamize the screens of Feedbackkit.

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
 :nodoc: Get all types of completion handler in single place by extending our protocol.
 */

-(void) setCustomHandler:(id <FKCustomHandler> _Nonnull) handler;

#pragma mark - Other Important Properties
/**
 :nodoc:
 */
@property (nonatomic, assign) BOOL anonymStatus;
@property (nonatomic, assign) BOOL setTransparencyStatus;
@property (nonatomic) BOOL maskText;
@property (nonatomic,strong) NSMutableArray*arrayOfimages;
@property NSString* feedback_KitType;
@property NSString* feedback_KitScreenCancel; //property used only to check floating bottom view closed or not

/**
 :nodoc:
 */
@property (nonatomic, strong) NSString *emailAddress;
/**
 :nodoc:
 */
@property (nonatomic, strong) NSString *baseUrl;
/**
 :nodoc:
 */
@property (nonatomic, strong) NSNumber *sessionStartTime;
/**
 :nodoc:
 */
@property (nonatomic, assign) BOOL reviewAndSendFeedback;
/**
 :nodoc:
 */
@property (nonatomic, strong) NSArray *diagnoInfo;
/**
 :nodoc:
 */
@property (nonatomic, strong) FeedbackDiagosticInfo *feedbackDiagosticInfo;
/**
 :nodoc:
 */
@property (strong,nonatomic) NSNumber *networkReachableStatus;

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

+ (NSString*_Nullable) getLocalizableStringForKey : (NSString*_Nonnull) key;
/**
 :nodoc:
 */
+ (ZAArrowCanvasView*) createArrowCanvasView : (CGRect)frame;

@end

NS_ASSUME_NONNULL_END
