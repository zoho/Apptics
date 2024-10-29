//
//  APPushNotificationExtension.h
//  notificationservice
//
//  Created by Saravanan S on 28/09/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UNMutableNotificationContent, UNNotificationContent;

#if __has_include(<UserNotifications/UserNotifications.h>)
#import <UserNotifications/UserNotifications.h>
#endif

NS_ASSUME_NONNULL_BEGIN

static NSString *const kPayloadAps = @"aps";
static NSString *const kPayloadAddInfo = @"addInfo";
static NSString *const kPayloadOptionsImageURLName = @"mmInfo";
static NSString *const kNoExtension = @"";
static NSString *const kImagePathPrefix = @"image/";

static NSString *const kPayloadPndetails = @"pndetails";
static NSString *const kPayloadTitle = @"title";
static NSString *const kPayloadMessage = @"body";
static NSString *const kPayloadSound = @"sound";
static NSString *const kPayloadBadge = @"badge";
static NSString *const kPayloadAppticsPnID = @"appticsPnID";
static NSString *const kAPTAppticsBadgeCount = @"appticsBadgeCount";
static NSString *const kPayloadAppticsAdditional = @"additional";

@interface APPushNotificationExtension : NSObject

@property(nonatomic, retain) NSString *appGroup NS_SWIFT_NAME(appGroup);

-(void)didReceiveNotificationExtensionWithContent:(UNMutableNotificationContent*)replacementContent contentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler;
-(void) constructNotificatio : (NSDictionary*) pndetails;
-(NSDictionary*) parseBodyString : (NSString*) jsonString;
-(void) deliverNotification;
-(bool) isNotificationFromApptics : (UNNotificationRequest *)request;
-(id) getAdditionalPayload;
@end

NS_ASSUME_NONNULL_END
