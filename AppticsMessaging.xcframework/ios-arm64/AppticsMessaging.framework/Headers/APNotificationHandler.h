#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface APNotificationHandler : NSObject

+ (instancetype)shared;

// Call from UNUserNotificationCenterDelegate didReceiveNotificationResponse
- (void)handleNotificationResponse:(UNNotificationResponse *)response
                 completionHandler:(void (^)(void))completionHandler;

// Optional: get resolved clickAction without opening
- (nullable NSString *)resolvedClickActionFromResponse:(UNNotificationResponse *)response;

@end

NS_ASSUME_NONNULL_END
