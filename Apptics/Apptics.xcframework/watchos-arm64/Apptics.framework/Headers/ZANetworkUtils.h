//
//  ZANetworkUtils.h
//  JAnalytics
//
//  Created by Giridhar on 15/04/16.
//  Copyright © 2016 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAConstants.h>
#import <Apptics/ZAEnums.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZANetworkUtils : NSObject
+ (NSDateFormatter *)dateFormatter;

+ (NSData *)JSONSerializeObject:(id)obj;
+ (id)JSONSerializableObjectForObject:(id)obj;
//+ (NSString *)encodeAPIData:(NSArray *)array;
+ (NSString *)encodeURLParams:(NSString *)paramString;
+ (BOOL) isValidDeviceID:(NSString*)deviceID;
+ (NSArray*) splitArrayToBatches:(NSArray*)arrayToSplit withBatchSize:(NSInteger)batchSize;
+(NSString*_Nullable) keyNameForType:(JURLPath) urlType;
+(NSString*_Nullable) convertURLEnumToString: (JURLPath) urlType;
+ (NSArray *) groupBasedOnDeviceInfo:(NSArray*) arrayToFilter;

+ (void) setSyncStatusForArray:(NSArray*)array withStatus:(BOOL)isSynced;

/// YES when the request is one of the SDK's own calls: a /sdk/ or /hsdk/ path on the Apptics server (`serverHost`, the
/// host addversion saved), any host containing "apptics", or an upload host. `host` is expected in lowercase.
+ (BOOL) isAppticsSDKRequestForHost:(NSString*)host path:(NSString*)path serverHost:(NSString* _Nullable)serverHost;

@end
NS_ASSUME_NONNULL_END
