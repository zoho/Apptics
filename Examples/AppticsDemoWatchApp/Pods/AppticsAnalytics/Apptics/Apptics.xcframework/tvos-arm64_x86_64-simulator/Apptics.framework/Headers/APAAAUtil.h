//
//  APAAAUtil.h
//  JAnalytics
//
//  Created by Saravanan S on 10/11/20.
//  Copyright © 2020 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APAAAUtil : NSObject

@property (nonatomic, strong) dispatch_queue_t serialDispatchQueue;
//@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic) BOOL operationinProgress;
@property (nonatomic, strong) NSMutableArray *successblocks;
@property (nonatomic, strong) NSMutableArray *failureblocks;
typedef void (^requestSuccessBlock)(NSString *token);
typedef void (^requestFailureBlock)(NSError *error);

typedef void (^ apiRequestSuccessBlock)(NSURLResponse *response, id responseObject);
typedef void (^ apiRequestFailureBlock)(NSURLResponse *response, NSError *error);

+ (APAAAUtil* _Nonnull) sharedManager;
+ (APAAAUtil* _Nonnull) sharedManagerForDevice;
+ (APAAAUtil* _Nonnull) sharedManagerForAnonymousUser;
+ (APAAAUtil* _Nonnull) sharedManagerForUser;

- (void) getTokenWithSuccess:(requestSuccessBlock)success andFailure:(requestFailureBlock)failure;
- (void) setHeaderFields:(NSMutableURLRequest*) request migrateDevice : (bool) migrate;
- (void) removeRefreshToken;
- (void) removeTokenTime;
- (void) updateToken : (NSString*_Nullable) refresh_token;
- (void) updateToken : (NSString*_Nullable) refresh_token time : (NSNumber* _Nullable) token_time;

@end

NS_ASSUME_NONNULL_END
