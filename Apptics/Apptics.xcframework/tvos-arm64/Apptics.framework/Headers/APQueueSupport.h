//
//  APQueueSupport.h
//  Apptics
//
//  ObjC side of the request queue (iOS only): registers the senders for the bootstrap calls and maps
//  Apptics API failures to queue results. CrashKit and FeedbackKit use it for their own request types.
//

#import <Foundation/Foundation.h>

@class APAAAUtil;
@class APQueueResult;

NS_ASSUME_NONNULL_BEGIN

/// YES when server calls go through APRequestQueue (every platform; a single switch to fall back to the direct calls).
FOUNDATION_EXPORT BOOL APQueueIsEnabled(void);

@interface APQueueSupport : NSObject

/// Queues addversion unless one is already queued. Waiters on getAppVersionIDWithSuccess: are called when it finishes.
+ (void)enqueueAddVersion;

/// Queues bearertoken then device/add (both after any queued addversion). Waiters on newRegisterDevice: are called
/// when device/add finishes.
+ (void)enqueueDeviceRegistration;

/// Queues user/register after device/add. Returns NO when the user properties can't be stored (not JSON), in which
/// case the caller sends it directly.
+ (BOOL)enqueueUserRegistrationWithGroupID:(nullable NSString *)groupID userProps:(nullable NSDictionary *)userProps;

/// Queues device/updateconsent; later calls join the waiting one (the status is read when it is sent).
+ (void)enqueueConsentUpdate;

/// Queues user/register with status false for this user. `success` is called when it finishes (in this run).
/// Returns NO when it can't be queued, in which case the caller sends it directly.
+ (BOOL)enqueueUnregisterUserWithZauid:(NSString *)zauid
                                userID:(nullable NSString *)userID
                               groupID:(nullable NSString *)groupID
                                   mam:(nullable NSString *)mam
                               success:(nullable void (^)(bool result))success;

/// Queues getupdates. The blocks are called when it finishes; a call for the same modules and flag time joins the
/// waiting request. Returns NO when it can't be queued, in which case the caller sends it directly.
+ (BOOL)enqueueGetUpdatesForModules:(nullable NSArray *)modules
                           flagTime:(nullable NSNumber *)flagtime
                            success:(nullable void (^)(NSURLResponse *response, id responseObject))success
                            failure:(nullable void (^)(NSURLResponse *response, NSError *error))failure;

/// Queues getsdkconfig (high priority, after device/add and user/register). The blocks are called when it finishes;
/// a call while one is waiting joins it. Returns NO when it can't be queued, in which case the caller sends it directly.
+ (BOOL)enqueueGetSDKConfigWithSuccess:(nullable void (^)(NSURLResponse *response, id responseObject))success
                               failure:(nullable void (^)(NSURLResponse *response, NSError *error))failure;

/// addversion values are already saved for this version and data center, so nothing waits for a new call.
+ (void)noteAppRegistered;

/// The data center changed: drops queued bootstrap requests (their waiters were already cleared by the caller)
/// and requires a fresh addversion before anything else is sent.
+ (void)resetForDataCenterSwitch;

/// Maps a failed Apptics call to a queue result:
/// - token errors (401, SESSION_TOKEN_EXPIRED, INVALID_TOKEN, INVALID_SESSION_TOKEN, NOT_AUTHENTICATED, no token) → 401,
///   so the queue refreshes `tokenUtil`'s token and retries;
/// - no response, timeouts → retry; 429 and 5xx → retry with backoff (Retry-After honoured);
/// - an application the server disabled, or any other rejection → failure.
+ (APQueueResult *)resultForResponse:(nullable NSURLResponse *)response
                                json:(nullable NSDictionary *)json
                               error:(nullable NSError *)error
                           tokenUtil:(nullable APAAAUtil *)tokenUtil;

@end

NS_ASSUME_NONNULL_END
