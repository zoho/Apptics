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

@end
NS_ASSUME_NONNULL_END
