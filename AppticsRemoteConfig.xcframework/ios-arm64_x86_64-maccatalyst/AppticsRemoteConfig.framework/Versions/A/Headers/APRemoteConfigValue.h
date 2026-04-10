//
//  APRemoteConfigValue.h
//  JAnalytics
//
//  Created by Saravanan S on 10/05/19.
//  Copyright © 2019 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APRemoteConfigValue : NSObject

@property (readonly, nonatomic, nullable) NSString *stringValue;
@property (readonly, nonatomic, nullable) NSNumber *numberValue;
@property (readonly, nonatomic, nullable) NSData *dataValue;
@property (readonly, nonatomic) BOOL boolValue;
@property (readonly, nonatomic, nullable) id jsonValue;

- (instancetype)initWithValue : (NSString *) value;

@end

NS_ASSUME_NONNULL_END
