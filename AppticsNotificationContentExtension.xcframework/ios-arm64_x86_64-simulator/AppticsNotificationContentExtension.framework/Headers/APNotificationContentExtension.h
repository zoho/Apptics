#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface APNotificationContentExtension : NSObject

/// Optional custom app logo image. When set, this image is displayed instead of the
/// default app icon in the notification content extension.  Set this **before** calling
/// ``-setupUI`` so the image is available when the view hierarchy is built.
@property (nonatomic, strong, nullable) UIImage *customAppLogo;

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)setupUI;
- (void)viewDidLayoutSubviews;
- (void)stopAutoScrollIfNeeded;
- (void)stopMessageCountdownIfNeeded;
- (void)didReceiveNotificationExtensionWithContent:(UNNotification *)notification
                                    contentHandler:(void (^ _Nullable)(UNNotificationContent *contentToDeliver))contentHandler;

@end

NS_ASSUME_NONNULL_END
