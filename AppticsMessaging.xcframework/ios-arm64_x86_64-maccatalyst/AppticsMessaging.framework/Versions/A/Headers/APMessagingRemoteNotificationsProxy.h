//
//  APMessagingRemoteNotificationsProxy.h
//  AppticsMessaging
//
//  Created by Saravanan S on 19/09/24.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMessagingRemoteNotificationsProxy : NSObject

+ (BOOL)canPerformMethodSwizzling;

/**
 * A shared instance of `APMessagingRemoteNotificationsProxy`
 */
+ (instancetype)sharedInstance;

/**
 *  Intercepts the Application Delegate's remote notification callbacks and the User Notification Center delegate callback, then calls the original
 *  methods after execution.
 */
- (void)performMethodSwizzlingIfPossible;

@end

@interface APUserNotificationCenter : NSObject

- (void) appticsSetBadgeCount:(NSInteger) newBadgeCount
        withCompletionHandler:(void (^)(NSError * error)) completionHandler;

@end

@interface APUserNotificationCenterDelegate : NSObject

- (void) appticsUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler;

@end


NS_ASSUME_NONNULL_END
