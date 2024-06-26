//
//  APRateUs.h
//  Pods
//
//  Created by Prakash R on 12/10/20.
//

#ifndef APRateUs_h
#define APRateUs_h
/**
 *  Apptics is a library that enables your app to send usage reports and data securly to our servers. You get Session tracking, Screen tracking and Crash Reporting. Which means, with minimal setup of initializing the framework you can get these three features working without any other configuration.
 
    # Important:
    Make sure your build settings has the following when you ship your app so that you get proper symbolicated crashes.

    * Strip Build Symbols During Copy - **NO**
    * Strip Linked Product - **NO**
    * Strip Style - **Debugging Symbols**
 */
@interface APRateUs : NSObject

#pragma mark — In-App Ratings and Reviews apis

/**
 *  This method call will perform initialisation of APRateUs framework.
 *
 */

+(APRateUs* _Nonnull)listener;

#if !TARGET_OS_WATCH
/**
 Enable or disable rate us and review for your application.
 
 @param status boolean
 */

+ (void) enable : (BOOL) status;

/**
 Call this method to reset all numbers during development.
 
 - Warning:
 Don't call this method in App Store build.
*/

+(void) storeReviewMasterReset;

/**
 Call this method in the ARCustomHandlerManager willDisplayReviewPrompt call back.
 
*/

+(void) setAppRatingShown;

/**
 This method should be called initially, to stop SDK from showing the review prompt on fulfilling criteria.
 
 @param status boolean
 */

+(void) disableAutoPromptOnFulfillingCriteria : (bool) status;

/**
 This method should be called manually where you want to show the review prompt.
 */

+(void) showPromptOnFulfillingCriteria;


#pragma mark Apis to customise In-App Ratings and Reviews

/**
 Call this method in the callback method 'willDisplayReviewPrompt' of APCustomHandler class.
 */

+ (void) showCustomReviewPrompt;

/**
This method will take you to the App store.
 
- Note:
 Call this method in your apps settings screen when they tap on 'Rate in App Store' button.
*/

+ (void) takeToAppStoreReviewScreen;

/**
This method will open Feedback screen.
 
- Note:
 Call this method in the completion of custom review prompt when user taps on 'Send Feedback' button.
*/

+ (void) takeToFeedbackScreen;


/**
Call this method to update user action for App Store Review Screen when you open the Store Review on your own.
*/

+ (void) updateActionForAppStoreReview;

/**
Call this method to update user action for feedback when you open your custom feedback screen.
*/

+ (void) updateActionForFeedback;

/**
 This method will mark review prompt shown for the current version of the app. Note: Call this method if you have used custom review prompt.
 
 - Note:
 This should be called only if you show your custom prompt in 'willDisplayReviewPrompt' callback. Also the hitcount of sessions, events and screens will be reset.
 */

+(void) updateAppRatingShownForCurrentVersion;

/**
 This method will prevent rateus prompt being shown for that session.
 */

+ (void) shouldPauseRateUsAndReview : (BOOL) status;

///**
//This method will prompt ratings alert which will take you to the store.
// */
//
//+ (void) za_rateUsOnStore __deprecated_msg("use staticStoreReviewPrompt method instead.");
//
///**
//This method will prompt ratings alert which will show the option to rate in appstore or send feedback, call this method in you apps' settings page.
// */
//
//+ (void) staticStoreReviewPrompt;

#endif

@end

#endif /* APRateUs_h */
