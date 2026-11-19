//
//  ZAPIManager.h
//  JAnalytics
//
//  Created by Saravanan S on 05/03/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZANetworking.h>
#import <Apptics/ZAConstants.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAPIManager : NSObject

@property (nonatomic, strong) NSMutableArray *regUserSuccessblocks;
@property BOOL regUserInprogress;
@property BOOL regappAddVersionInprogress;
@property BOOL newregisterDeviceInprogress;

@property (nonatomic, strong) NSMutableArray *app_AddVersionSuccessblocks;
@property (nonatomic,strong) NSMutableArray *newregisterDeviceSuccessblocks;

+(ZAPIManager*)sharedManager;

//AppUpdate

- (void) getAppUpdateInfoWithUrlPath:(JURLPath) urlPath success:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;


- (void) setAppUpdateStatWithUrlPath:(JURLPath) urlPath action : (NSString*) action andUpdateId : (NSNumber*) updateId previousVersion : (NSString* _Nullable) previousversion success:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;

- (void) registerDeviceSuccess:(void (^)(NSString* deviceid))success;

- (void) newRegisterDeviceSuccess : (NSString* _Nullable) deviceid completion:(void (^)(NSDictionary  * _Nullable deviceInfo))success;

/// Same as newRegisterDeviceSuccess:completion:, but also passes the failure (HTTP status as the code, the server's
/// JSON as userInfo) so the request queue can tell a token problem from a network one.
- (void) newRegisterDevice : (NSString* _Nullable) deviceid completionWithError:(void (^)(NSDictionary * _Nullable deviceInfo, NSError * _Nullable error))success;


- (void)addAppVersionWithSuccess:(void (^)(NSDictionary *responseObject))success
                              failure:(void (^)(NSError *error))failure;

/// One addversion call, no retries, used by the request queue (which retries with backoff). `attempt` is only logged.
- (void)addAppVersionOnceForAttempt:(NSInteger)attempt
                            success:(void (^)(NSDictionary *responseObject))success
                            failure:(void (^)(NSError *error))failure;

/// One addversion call that retries `retryCount - 1` more times on failure. Always calls exactly one of the blocks.
- (void)addAppVersionWithRetryCount:(NSInteger)retryCount
                            success:(void (^)(NSDictionary *responseObject))success
                            failure:(void (^)(NSError *error))failure;







- (void) anonymousRegisterDeviceSuccess : (NSString* _Nullable) anonid completion:(void (^)(NSDictionary  * _Nullable deviceInfo))success;

- (void) updateTrackingStatus;
    
- (void) registerUserWithDeviceId : (NSString*) deviceId andOrgID : (NSString* _Nullable) groupID userProps : (NSDictionary*) userprops success:(void (^)(NSDictionary * _Nullable deviceInfo))success;

- (void) newRegisterUserWithOrgID : (NSString* _Nullable) groupID userProps : (NSDictionary*) userprops success: (void (^)(NSDictionary * _Nullable deviceInfo))success;

/// getupdates sent directly, without the request queue. Used by the queue's sender and when offline.
- (void) sendUpdatesForModules:(NSArray* _Nullable) modules flagTime : (NSNumber* _Nullable) flagtime success:(void (^ _Nullable)(NSURLResponse *response, id responeObject))success failure:(void (^ _Nullable)(NSURLResponse *reponse, NSError *error))failure;

/// getsdkconfig sent directly, without the request queue. Used by the queue's sender and when offline.
- (void) sendSDKConfigWithSuccess:(void (^ _Nullable)(NSURLResponse *response, id responeObject))success failure:(void (^ _Nullable)(NSURLResponse *reponse, NSError *error))failure;

/// device/updateconsent sent once with the current status. `sent` is NO when there is no device id yet.
- (void) sendTrackingStatusWithCompletion:(void (^ _Nullable)(BOOL sent, NSURLResponse * _Nullable response, NSDictionary * _Nullable json, NSError * _Nullable error))completion;

/// user/register with status false, sent once for the given user (captured when logout started).
- (void) sendUnregisterUserWithZauid : (NSString* ) zauid userID : (NSString* _Nullable) userID groupID : (NSString* _Nullable) groupID mam : (NSString* _Nullable) mam completion:(void (^)(BOOL result, NSURLResponse * _Nullable response, NSDictionary * _Nullable json, NSError * _Nullable error))completion;

/// Sends user/register once and saves its token, without the in-progress gate. Used by the request queue.
- (void) sendRegisterUserWithOrgID : (NSString* _Nullable) groupID userProps : (NSDictionary* _Nullable) userprops completion: (void (^)(NSDictionary * _Nullable info, NSError * _Nullable error))completion;

/// Calls and clears the callbacks waiting for user/register.
-(void) executeRequestSuccessCallbacksWithResponse:(NSDictionary* _Nullable) userInfo;

- (void) unregisterUserWithZauid : (NSString* ) zauid userID : (NSString* _Nullable) userID groupID : (NSString* _Nullable) groupID success:(void (^ _Nullable)(bool result))success;

- (void) unregisterUserWithZauid : (NSString* ) zauid groupID : (NSString* _Nullable) groupID success:(void (^ _Nullable)(bool result))success;

- (void) syncApiCriteriasWithSuccess : (void (^)(id info))success;

- (void) syncRemoteConfigInfoWithSuccess : (void (^)(id info))success;

- (void) fetchUpdatesForModules:(NSArray*) modules flagTime: (NSNumber*) flagtime WithSuccess:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;

- (void) fetchSDKConfigWithSuccess:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;

- (void) getPromotionalAppsList: (void (^)(id info))success;

- (void) promoAppSelectedCallback : (NSString *) crossPromoId;




@end
NS_ASSUME_NONNULL_END
