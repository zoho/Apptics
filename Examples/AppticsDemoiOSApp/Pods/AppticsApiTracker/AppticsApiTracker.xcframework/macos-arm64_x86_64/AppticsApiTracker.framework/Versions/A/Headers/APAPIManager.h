//
//  APAPIManager.h
//  JAnalytics
//
//  Created by Saravanan S on 03/12/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
 * Use startTrackingApi method with the API ID and the request method (GET, POST, PUT, etc.) before making network call.
 */
+ (NSString *) startTrackingApi : (NSString *) API_ID HTTPMethod : (NSString*) methodName;

/**
 * Call endTrackingApi method once the API has returned the response.
 * @param trackId Pass the id returned by startTrackingApi
 * @param responsecode Pass the API response code (200, 400, etc.)
 */

+ (void) endTrackingApi : (NSString *) trackId  responseCode : (NSString*) responsecode;

/**
 :nodoc:
 */
+ (NSString* _Nullable) getApiIdForUrl : (NSURLRequest*) request;

@end

NS_ASSUME_NONNULL_END
