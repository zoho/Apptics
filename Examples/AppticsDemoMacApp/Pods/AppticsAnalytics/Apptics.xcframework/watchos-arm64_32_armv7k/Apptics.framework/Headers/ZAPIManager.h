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

+(ZAPIManager*)sharedManager;

//AppUpdate

- (void) getAppUpdateInfoWithUrlPath:(JURLPath) urlPath success:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;


- (void) setAppUpdateStatWithUrlPath:(JURLPath) urlPath action : (NSString*) action andUpdateId : (NSNumber*) updateId previousVersion : (NSString* _Nullable) previousversion success:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;

- (void) registerDeviceSuccess:(void (^)(NSString* deviceid))success;

- (void) newRegisterDeviceSuccess : (NSString* _Nullable) deviceid completion:(void (^)(NSDictionary  * _Nullable deviceInfo))success;

- (void) anonymousRegisterDeviceSuccess : (NSString* _Nullable) anonid completion:(void (^)(NSDictionary  * _Nullable deviceInfo))success;

- (void) updateTrackingStatus;
    
- (void) registerUserWithDeviceId : (NSString*) deviceId andOrgID : (NSString* _Nullable) groupID success:(void (^)(NSDictionary * _Nullable deviceInfo))success;

- (void) newRegisterUserWithOrgID : (NSString* _Nullable) groupID success: (void (^)(NSDictionary * _Nullable deviceInfo))success;

- (void) unregisterUserWithZauid : (NSString* ) zauid userID : (NSString* _Nullable) userID groupID : (NSString* _Nullable) groupID success:(void (^ _Nullable)(bool result))success;

- (void) unregisterUserWithZauid : (NSString* ) zauid groupID : (NSString* _Nullable) groupID success:(void (^ _Nullable)(bool result))success;

- (void) syncApiCriteriasWithSuccess : (void (^)(id info))success;

- (void) syncRemoteConfigInfoWithSuccess : (void (^)(id info))success;

- (void) fetchUpdatesForModules:(NSArray*) modules flagTime: (NSNumber*) flagtime WithSuccess:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;

- (void) getPromotionalAppsList: (void (^)(id info))success;

- (void) promoAppSelectedCallback : (NSString *) crossPromoId;

@end
NS_ASSUME_NONNULL_END
