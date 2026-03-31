//
//  NotificationViewController.m
//  AppticsDemoNotificationContentExtension
//
//  Created by Saravanan Selvam on 20/03/26.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <AppticsNotificationContentExtension/AppticsNotificationContentExtension.h>

static NSString *const kAppticsCarouselCategory = @"CUSTOM_CATEGORY_APPTICS_CAROUSEL";

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (nonatomic, strong) APNotificationContentExtension *apext;
@property (nonatomic, strong) UNNotification *bestAttemptContent;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.hidden = YES;
}

- (void)dealloc {
    if ([self.bestAttemptContent.request.content.categoryIdentifier isEqualToString:kAppticsCarouselCategory] && self.apext) {
        [self.apext stopAutoScrollIfNeeded];
        [self.apext stopMessageCountdownIfNeeded];
    }
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.bestAttemptContent = notification;
    if ([self.bestAttemptContent.request.content.categoryIdentifier isEqualToString:kAppticsCarouselCategory]) {
        if (!self.apext) {
            self.apext = [[APNotificationContentExtension alloc] initWithViewController:self];
            [self.apext setupUI];
        }

        [self.apext didReceiveNotificationExtensionWithContent:self.bestAttemptContent contentHandler:nil];
        
        return;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.bestAttemptContent.request.content.categoryIdentifier isEqualToString:kAppticsCarouselCategory] && self.apext) {
        [self.apext viewDidLayoutSubviews];
    }
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response
                     completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion {
    // Forward tap/action to host app
    completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
}
@end
