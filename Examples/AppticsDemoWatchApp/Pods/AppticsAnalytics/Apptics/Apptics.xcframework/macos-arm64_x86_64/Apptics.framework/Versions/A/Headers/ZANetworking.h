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

+(void) processError : (NSDictionary*) response aaaUtil : (APAAAUtil*) aaautil;

@end
NS_ASSUME_NONNULL_END
