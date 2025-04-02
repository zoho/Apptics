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

#pragma mark Apis to customise In-App Ratings and Reviews


/**
 This method will prevent rateus prompt being shown for that session.
 */

+ (void) shouldPauseRateUsAndReview : (BOOL) status;


#endif

@end

#endif /* APRateUs_h */
