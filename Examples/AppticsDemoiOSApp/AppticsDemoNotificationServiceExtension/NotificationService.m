//
//  NotificationService.m
//  AppticsDemoNotificationServiceExtension
//
//  Created by Saravanan Selvam on 20/03/26.
//

#import "NotificationService.h"
#import <AppticsNotificationServiceExtension/AppticsNotificationServiceExtension.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
        self.bestAttemptContent = [request.content mutableCopy];
        // Modify the notification content here...
    APPushNotificationExtension *apext = [APPushNotificationExtension new];
    apext.appGroup = @"group.MAIN_BUNDLE_IDENTIFIER.apptics";
    if ([apext isNotificationFromApptics:request]){
    
    [apext didReceiveNotificationExtensionWithContent:self.bestAttemptContent contentHandler:contentHandler];
    }else{
    self.contentHandler(self.bestAttemptContent);
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
