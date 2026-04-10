//
//  APTokenManager.h
//  AppticsMessaging
//
//  Created by Saravanan S on 26/09/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APTokenManager : NSObject

+ (instancetype)sharedInstance;
- (void)setAPNSToken:(NSData *)token;
- (void)registerAPNSToken:(NSData *)token;
- (void)sendStatsToServer:(NSArray *)pnstats completion:(void (^)(bool status))completion;
- (NSString *)stringFromDeviceToken:(NSData *)deviceToken;
@end

NS_ASSUME_NONNULL_END
