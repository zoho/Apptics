//
//  APMessaging.h
//  AppticsMessaging
//
//  Created by Saravanan S on 24/09/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMessaging : NSObject

@property(nonatomic, copy, nullable) NSData *APNSToken NS_SWIFT_NAME(apnsToken);

@property(nonatomic, readonly, nullable) NSString *pnToken NS_SWIFT_NAME(pnToken);

+ (APMessaging *)shared;
    
+ (void)startService;

- (instancetype)init __attribute__((unavailable("Use +shared instead.")));

- (void)setAPNSToken:(NSData *)apnsToken;

- (void)updateLogMsgIds:(NSDictionary *)message;

- (void)appDidReceiveMessage:(nonnull NSDictionary *)message withResponse : (nonnull id) response;

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void) updateBadgeCount:(NSInteger) value;

- (NSInteger) getBadgeCount;

@end

NS_ASSUME_NONNULL_END
