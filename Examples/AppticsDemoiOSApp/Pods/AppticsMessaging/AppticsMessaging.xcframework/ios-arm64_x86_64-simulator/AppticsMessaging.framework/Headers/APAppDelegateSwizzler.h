//
//  APAppDelegateSwizzler.h
//  AppticsMessaging
//
//  Created by Saravanan S on 20/09/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define APTApplication UIApplication
#define APTApplicationDelegate UIApplicationDelegate

static NSString * _Nonnull const kAPTApplicationClassName = @"UIApplication";

NS_ASSUME_NONNULL_BEGIN

typedef NSString *const APAppDelegateMonitoringID;

@interface APAppDelegateSwizzler : NSProxy

+ (nullable APAppDelegateMonitoringID)registerAppDelegateInterceptor:
    (id<APTApplicationDelegate>)interceptor;

+ (void)unregisterAppDelegateInterceptorWithIdentifier:(APAppDelegateMonitoringID)interceptorID;

+ (void)proxyOrigDelegate;

+ (void)proxyOrigDelegateIncludingAPNSMethods;

+ (BOOL)isAppDelegateProxyEnabled;

+ (nullable APTApplication *)sharedApplication;

/** Do not initialize this class. */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
