//
//  Test.m
//  AppticsDemo
//
//  Created by Saravanan S on 11/03/21.
//

#import "Test.h"
//#import <Apptics/Apptics.h>
//#import <Apptics/Analytics.h>
//#import <Apptics/APTheme.h>
#import <Apptics/APLog.h>
//#import <AppticsScreenTracker/AppticsScreenTracker.h>
//#import <ATTrackingManager>
//#import <Apptics/Apptics-Swift.h>
//#import <Apptics_SDK/Apptics_SDK-Swift.h>
//#import <Apptics/FeedbackKit.h>
//#import <Apptics/APRemoteConfig.h>
//#import <Apptics_Swift/Apptics-Swift-umbrella.h>
//@implementation Test
//- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
//
//    if ([identifier hasPrefix:@"com.apptics.engagement.backgroundsession"]){
//        [[Analytics getInstance] setBgEngagementRequestSuccessBlock:completionHandler];
//    }
//
//    if ([identifier hasPrefix:@"com.apptics.nonfatal.backgroundsession"]){
//        [[Analytics getInstance] setBgNonFatalRequestSuccessBlock:completionHandler];
//    }
////    [Apptics setCrashCustomProperty:<#(nonnull NSDictionary *)#>];
////    [Apptics setTheme:[CustomTheme new]];
////    [Apptics setFeedbackTheme:[CustomFeedackTheme new]];
////    [Apptics setSettingsTheme:[CustomSettingsTheme new]];
////    [Apptics setUserConsentTheme:[CustomUserConsentTheme new]];
////    [Apptics setAppUpdateConsentTheme:[CustomAppUpdateConsentTheme new]];
////    [APThemeSwiftManager crosspromotheme].viewBGColor = UIColor.whiteColor;
//
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//
//    @try  {
//       NSString *string = [array objectAtIndex:10];
//    } @catch (NSException *exception) {
//       trackException(exception);
//    }
////     [Apptics trackEvent:<#(nonnull NSString *)#>]
////     [Apptics trackEvent:<#(nonnull NSString *)#> andGroupName:<#(nonnull NSString *)#> withProperties:<#(nonnull NSDictionary *)#>]
//
//AppticsConfig.defaultConfig.enableAutoCheckForAppUpdate=true;
//AppticsConfig.defaultConfig.enableRateUs=true;
//AppticsConfig.defaultConfig.enableRemoteConfig=true;
//AppticsConfig.defaultConfig.enableBackgroundTask=true;
//AppticsConfig.defaultConfig.enableCrossPromotionAppsList=true;
//AppticsConfig.defaultConfig.sendDataOnMobileNetworkByDefault=true;
//AppticsConfig.defaultConfig.trackOnByDefault=true;
//AppticsConfig.defaultConfig.anonymousType=APAnonymousTypePseudoAnonymous;
//
////    NotificationCenter.default.addObserver(
////        self,
////        selector: #selector(updateRcValues:),
////        name: "APRemoteConfigUpdateNotification",
////        object: nil)
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRcValues:) name:APRemoteConfigUpdateNotification object:nil];
//
//}
//
//-(void) updateRcValues : (NSNotification*) notification{
//    //do stuff using the updated remote config values.
//}
//
//@end

@implementation Test

-(void) log{
//    [APLog getInstance].shouldPrint = false;
//    APLogInfo(@"Info Log %i",isatty(STDERR_FILENO));
//    APLogDebug(@"Info Debug %@", [@"someones@email.com" ap_privacy:APLogPrivacyPrivateMask]);
//    APLogWarn(@"Info Warn %@", [@"someones@email.com" ap_privacy:APLogPrivacyPrivate]);
//    APLogError(@"Info Error %@", [@"someones@email.com" ap_privacy:APLogPrivacySensitiveMask]);
//    APLogError(@"Info Error %@", [@"someones@email.com" ap_privacy:APLogPrivacySensitive]);
//    [APLog getInstance].shouldPrint = true;
//    [APScreentracker trackViewEnter:<#(nonnull NSString *)#>]
//    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//        // Check for status after request
//        switch (status) {
//            case ATTrackingManagerAuthorizationStatusAuthorized:
//                // The user authorizes access to app-related data that can be used for tracking the user or the device.
//                // Set personal info tracking status true when the user accepts.
//                [Apptics setPersonalInfoTrackingStatus:true];
//                break;
//            case default:
//                // Set personal info tracking status false when the user rejected.
//                [Apptics setPersonalInfoTrackingStatus:false];
//                break;
//        }
//    }];
}
-(void)crash{
//    [self performSelector:@selector(die_die)];
    @[][666];
}
@end


