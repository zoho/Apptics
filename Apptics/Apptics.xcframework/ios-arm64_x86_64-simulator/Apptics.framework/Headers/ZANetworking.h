//
//  ZANetworking.h
//  BugReporterTest
//
//  Created by Saravanan Selvam & Girdhar V.C on 27/10/15.
//  Copyright © 2015 Giridhar. All rights reserved.
//

#import <Apptics/Analytics.h>
#import <Apptics/ZAConstants.h>
#import <Apptics/APAAAUtil.h>

NS_ASSUME_NONNULL_BEGIN

/// What to do with stored rows after an upload attempt.
typedef NS_ENUM(NSInteger, APUploadVerdict) {
    /// The server accepted them: delete the rows.
    APUploadVerdictSent,
    /// Nothing reached the server, or it failed for a reason that can pass (no network, timeout, unreadable
    /// response, 401, 429, 5xx, token errors): keep the rows and send them again.
    APUploadVerdictRetry,
    /// The server rejected the data itself: sending it again won't help, so the rows are dropped.
    APUploadVerdictDiscard
};

/// Called once per upload attempt with what came back (nil JSON when the body was not JSON).
typedef void (^APUploadResultHandler)(NSURLResponse * _Nullable response, NSDictionary * _Nullable json, NSError * _Nullable error);

@interface ZANetworking : NSObject <NSURLSessionDelegate>

//@property (nonatomic, strong) NSOperationQueue *operationQueue;
//@property (nonatomic, strong) NSString *baseUrl;
//@property (nonatomic, assign) BOOL isNetrowkReachable;
@property (strong, nonatomic) NSString* dclPfx;
@property (strong, nonatomic) NSString* dclBD;
@property (strong, nonatomic) NSString* is_pfx;
@property (strong, nonatomic) NSString *trackViewUrl;
@property (strong, nonatomic) NSString *apiToken;
@property (strong, nonatomic) NSString *userAgent;

+(ZANetworking*) sharedManager;
-(BOOL) isReachable;
-(BOOL) isApprovedForFlushing;
- (NSString*)setNewDefaultParams;
- (NSString*)setDefaultParams;
- (NSString*)setIdentificationParams : (NSString*) _params userID : (NSString* _Nullable) userId anonID : (NSString* _Nullable) anonid;
- (APAAAUtil*)getAuthindicatorForUserID : (NSString* _Nullable) userId anonID : (NSString* _Nullable) anonid;

//- (void) sendData:(NSDictionary*)payload toUrlPath:(JURLPath) urlPath success:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;
//- (void) sendData:(id)payload toUrlPath:(JURLPath) urlPath success:(void (^)(NSURLResponse *response, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;
//-(void) setTimeZone:(NSString*)timeZone;

-(NSString*) getDCFromBaseDomain:(NSString*)BD;

-(void) setBaseDomain:(NSString*)BD forKey : (NSString*) key;

//- (void) flush:(JURLPath)type withData:(NSArray*) dataArray withDeviceInfo:(NSDictionary*)deviceInfo success:(void (^ _Nullable)(NSArray *batch, id responeObject))success failure:(void (^ _Nullable)(NSURLResponse *reponse, NSError *error))failure;

//- (void) flushHistoricData:(JURLPath)type withPayload:(ZAPayloadObject*) payloadObject success:(void (^)(NSArray *batch, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;

//- (void) flushHistoricData:(JURLPath)type withPayload:(NSArray*) payloadObject success:(void (^)(NSArray *batch, id responeObject))success failure:(void (^)(NSURLResponse *reponse, NSError *error))failure;

- (NSString*)setNewUrlForType:(NSString*)type andParms:(NSString*)params userID : (NSString*) userID;

- (NSString*)setUrlForType:(NSString*)type apiVersion : (NSString*) apiVersion andParms:(NSString*) params userID: (NSString*) userID;

- (void)POSTWith:(JURLPath )path
         rawBody: (NSData* _Nullable) data parameters:(id _Nullable)parameters
         success:(void (^)(NSURLResponse *response, id responseObject))success
         failure:(void (^)(NSURLResponse *response, NSError *error))failure;

- (void)POSTWith:(JURLPath )path
         rawBody: (NSData* _Nullable) data parameters:(id)parameters
          userID : (NSString* _Nullable) userID success:(void (^)(NSURLResponse *response, id responseObject))success
         failure:(void (^)(NSURLResponse *response, NSError *error))failure;

- (void)POST:(NSString *)URLString
     rawBody: (NSData*) data parameters:(id)parameters
     success:(void (^)(NSURLResponse *response, id responseObject))success
     failure:(void (^)(NSURLResponse *response, NSError *error))failure;

-(NSString*) getBaseUrlForKey : (NSString*) key;
-(NSString*) getBaseUrlForUserID : (NSString*) userID;
- (void)setHTTPHeaderField : (NSMutableURLRequest*) request forPath : (JURLPath) path;
- (void)setHTTPHeaderField : (NSMutableURLRequest*) request forPath : (JURLPath) path aaautils : (APAAAUtil*  _Nullable) aaautils;
+(void) processError : (NSDictionary*) response aaaUtil : (APAAAUtil*) aaautil;

/// The response body as a JSON object, or nil.
+ (nullable NSDictionary *)uploadResponseJSON:(nullable NSData *)data;
/// Decides whether rows from an engagement, non-fatal or log upload are deleted, kept or dropped.
+ (APUploadVerdict)uploadVerdictForResponse:(nullable NSURLResponse *)response json:(nullable NSDictionary *)json error:(nullable NSError *)error;
/// YES when the server is rate limiting the request (URL_ROLLING_THROTTLES_LIMIT_EXCEEDED or another throttle error
/// code). It comes back as HTTP 400 but means "slow down", not "bad data": treat it like 429.
+ (BOOL)isThrottleErrorCode:(nullable NSString *)errorCode;
/// Wait before the next attempt after `attempts` uploads the server failed: 1 min, 5 min, 15 min, 1 h, 3 h, 6 h, then
/// 12 h. Rows are still kept; only the 7-day purge removes rows that never get through.
+ (long long)uploadRetryBackoffMillisForAttempt:(NSInteger)attempts;
/// For a retried upload: YES when the server itself answered with an error (5xx, or a body that isn't JSON), so the
/// rows back off before the next attempt. NO when the data never arrived (no network, timeout) or the token or
/// throttling was the problem (401, token error codes, 429, throttle error codes): those are retried on the normal schedule.
+ (BOOL)uploadFailureCountsAgainstData:(nullable NSURLResponse *)response json:(nullable NSDictionary *)json error:(nullable NSError *)error;

@end
NS_ASSUME_NONNULL_END
