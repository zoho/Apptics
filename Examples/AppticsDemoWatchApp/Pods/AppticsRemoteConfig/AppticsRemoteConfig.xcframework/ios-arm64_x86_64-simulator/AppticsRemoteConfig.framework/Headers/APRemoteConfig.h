//
//  APRemoteConfig.h
//  JAnalytics
//
//  Created by Saravanan S on 06/05/19.
//  Copyright © 2019 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ZAEnums.h"
#import "APRemoteConfigValue.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, APRemoteConfigFetchStatus)  {
  APRemoteConfigFetchStatusNotYetFetched=0,
  APRemoteConfigFetchStatusSuccess,
  APRemoteConfigFetchStatusFailure,
  APRemoteConfigFetchStatusUpToDate,
  APRemoteConfigFetchStatuThrottled
};

static NSString* APRemoteConfigUpdateNotification = @"APRemoteConfigUpdateNotification";

@interface APRemoteConfig : NSObject

@property (readonly, strong, nonatomic, nullable) NSDate *lastFetchTime;
@property (readonly, assign, nonatomic) APRemoteConfigFetchStatus lastFetchStatus;
@property (nonatomic) bool enableRemoteConfig;

- (void)setRcInfo:(NSDictionary *)rcInfo;

/**
 * Returns a singleton instance of Remote Config.
 * @return APRemoteConfig.
 */

+ (APRemoteConfig *)shared;

/**
 * Enable remote config.
 * @param status BOOL.'
 */

+ (void) enable:(BOOL)status;

/**
 * Fetch configs with completion handler.
 * @param completion APRemoteConfigFetchStatus.
 */

- (void) fetchRemoteConfigWithCompletion:(void(^)(APRemoteConfigFetchStatus status))completion;

/**
 * Activates the most recently fetched configs, and returns true if activated successfully.
 * @return BOOL.
 */

- (BOOL) activateFetched;

/**
 * Asynchronously fetches and then activates the fetched configs.
 */

- (void) fetchAndActivate;

/**
 Use this method to set the current location of the user.
 
 @param location (code or name) String.
 */

-(void) setCurrentLocation : (NSString *) location;

- (APRemoteConfigValue * _Nullable)objectForKeyedSubscript:(nonnull NSString *)key;

- (APRemoteConfigValue * _Nullable)configValueForKey:(nullable NSString *)key;

-(void) addCustomCriteria : (NSString *) key value : (NSString*) value;

-(void) updateRemoteConfigWithData:(nullable NSDictionary*) rcInfo withCompletionHandler:(nullable void(^)(APRemoteConfigFetchStatus status))completion;

-(NSString*) getStringValue:(NSString*) key coldFetch : (BOOL) coldFetch fallbackWithOfflineValue : (BOOL) fallbackWithOfflineValue;
    
@end

NS_ASSUME_NONNULL_END
