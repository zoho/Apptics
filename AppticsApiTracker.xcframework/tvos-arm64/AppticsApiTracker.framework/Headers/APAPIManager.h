//
//  APAPIManager.h
//  JAnalytics
//
//  Created by Saravanan S on 03/12/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class APAPITrackingConfiguration;

@interface APAPIManager : NSObject


/**
 :nodoc:
 */
+ (APAPIManager *)sharedInstance;

/**
 * For enabling interception, add Apptics between your (NS)URLSession and internet. Register your session configuration (NS)URLSessionConfiguration) to Apptics using (enableApiTrackingForSessionConfiguration) method.
 * @param config Pass your session configuration (NS)URLSessionConfiguration)
*/

+ (void) enableForSessionConfiguration : (NSURLSessionConfiguration*) config;

/**
 * Enable API tracking globally for URLSession default/ephemeral configurations.
 * Call once during app startup (after Apptics init, before first network request).
 */
+ (void) enableAutomaticTracking;

/**
 * Replace-all runtime configuration for automatic API tracking.
 */
+ (void)configure:(void (^ _Nullable)(APAPITrackingConfiguration *config))block;
/**
 * Use startTrackingApi method with the API ID and the request method (GET, POST, PUT, etc.) before making network call.
 */
+ (NSString *) startTrackingApi : (NSString *) API_ID HTTPMethod : (NSString*) methodName;

/**
 * Manual tracking entrypoint for non-URLSession stacks.
 * Returns -1_<time> when filtered out.
 */
+ (NSString *)startTrackingApiWithURL:(NSString *)url HTTPMethod:(NSString *)methodName;

/**
 * Call endTrackingApi method once the API has returned the response.
 * @param trackId Pass the id returned by startTrackingApi
 * @param responsecode Pass the API response code (200, 400, etc.)
 */

+ (void) endTrackingApi : (NSString *) trackId  responseCode : (NSString*) responsecode;

/**
 * Manual tracking completion API for URL-based tracking.
 */
+ (void)endTrackingApi:(NSString *)trackId responseCode:(NSInteger)responseCode responseMessage:(NSString * _Nullable)responseMessage;

/**
 :nodoc:
 */
+ (NSString* _Nullable) getApiIdForUrl : (NSURLRequest*) request;

/**
 :nodoc:
 */
+ (NSDictionary* _Nullable) getApiInfoForUrl : (NSURLRequest*) request;

/**
 :nodoc:
 */
+ (NSDictionary* _Nullable) trackingMetadataForRequest : (NSURLRequest*) request;

@end

@interface APAPITrackingConfiguration : NSObject <NSCopying>

@property (nonatomic, assign) BOOL autoDetectionEnabled;

- (void)allowOnlyDomains:(NSArray<NSString *> *)domains;
- (void)ignoreDomains:(NSArray<NSString *> *)domains;
- (void)allowOnlyTLDs:(NSArray<NSString *> *)tlds;
- (void)ignoreTLDs:(NSArray<NSString *> *)tlds;
- (void)ignoreDomainPrefixes:(NSArray<NSString *> *)prefixes;
- (void)ignoreDomainSuffixes:(NSArray<NSString *> *)suffixes;
- (void)groupDomains:(NSArray<NSString *> *)patterns;
- (void)ignoreEndpoint:(NSArray<NSString *> *)patterns;
- (void)addPattern:(NSArray<NSString *> *)patterns;
- (void)preserveSegments:(NSArray<NSString *> *)segments;

@end

NS_ASSUME_NONNULL_END
