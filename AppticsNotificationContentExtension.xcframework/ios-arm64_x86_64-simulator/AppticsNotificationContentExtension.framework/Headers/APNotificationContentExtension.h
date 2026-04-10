#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface APNotificationContentExtension : NSObject

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)setupUI;
- (void)viewDidLayoutSubviews;
- (void)stopAutoScrollIfNeeded;
- (void)stopMessageCountdownIfNeeded;
- (void)didReceiveNotificationExtensionWithContent:(UNNotification *)notification
                                    contentHandler:(void (^ _Nullable)(UNNotificationContent *contentToDeliver))contentHandler;

@end

NS_ASSUME_NONNULL_END
